Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2E43939BC
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 01:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236969AbhE0X4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 19:56:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:38823 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236705AbhE0X4Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 19:56:16 -0400
IronPort-SDR: FjC2Xp2f2XICMu3cFMHXn8U3NAKXBxO+ZAQ9El32xrcP1i6zo3h0pI7mxHBi05davwB/MQMyEX
 R+iQlVmS9DbA==
X-IronPort-AV: E=McAfee;i="6200,9189,9997"; a="224079919"
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="224079919"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2021 16:54:36 -0700
IronPort-SDR: REzDS1hbYzJYnjh3Dv7PZz7AlOEU2/F9TmkYJrBQDz8rdnw+ZyvqHxZzFw9f4AI9HRI0sN21dZ
 lgb1Vp7Fv+lQ==
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="443774250"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.84.136])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2021 16:54:36 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Jianguo Wu <wujianguo@chinatelecom.cn>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/7] mptcp: fix pr_debug in mptcp_token_new_connect
Date:   Thu, 27 May 2021 16:54:24 -0700
Message-Id: <20210527235430.183465-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527235430.183465-1-mathew.j.martineau@linux.intel.com>
References: <20210527235430.183465-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianguo Wu <wujianguo@chinatelecom.cn>

After commit 2c5ebd001d4f ("mptcp: refactor token container"),
pr_debug() is called before mptcp_crypto_key_gen_sha() in
mptcp_token_new_connect(), so the output local_key, token and
idsn are 0, like:

  MPTCP: ssk=00000000f6b3c4a2, local_key=0, token=0, idsn=0

Move pr_debug() after mptcp_crypto_key_gen_sha().

Fixes: 2c5ebd001d4f ("mptcp: refactor token container")
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/token.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/token.c b/net/mptcp/token.c
index 8f0270a780ce..72a24e63b131 100644
--- a/net/mptcp/token.c
+++ b/net/mptcp/token.c
@@ -156,9 +156,6 @@ int mptcp_token_new_connect(struct sock *sk)
 	int retries = TOKEN_MAX_RETRIES;
 	struct token_bucket *bucket;
 
-	pr_debug("ssk=%p, local_key=%llu, token=%u, idsn=%llu\n",
-		 sk, subflow->local_key, subflow->token, subflow->idsn);
-
 again:
 	mptcp_crypto_key_gen_sha(&subflow->local_key, &subflow->token,
 				 &subflow->idsn);
@@ -172,6 +169,9 @@ int mptcp_token_new_connect(struct sock *sk)
 		goto again;
 	}
 
+	pr_debug("ssk=%p, local_key=%llu, token=%u, idsn=%llu\n",
+		 sk, subflow->local_key, subflow->token, subflow->idsn);
+
 	WRITE_ONCE(msk->token, subflow->token);
 	__sk_nulls_add_node_rcu((struct sock *)msk, &bucket->msk_chain);
 	bucket->chain_len++;
-- 
2.31.1

