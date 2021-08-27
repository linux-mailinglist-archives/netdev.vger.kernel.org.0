Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C99F3F9165
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 02:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243901AbhH0Ap5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 20:45:57 -0400
Received: from mga17.intel.com ([192.55.52.151]:40465 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243885AbhH0Apw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 20:45:52 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10088"; a="198108898"
X-IronPort-AV: E=Sophos;i="5.84,354,1620716400"; 
   d="scan'208";a="198108898"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2021 17:45:03 -0700
X-IronPort-AV: E=Sophos;i="5.84,354,1620716400"; 
   d="scan'208";a="599007124"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.68.199])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2021 17:45:00 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/5] mptcp: do not set unconditionally csum_reqd on incoming opt
Date:   Thu, 26 Aug 2021 17:44:50 -0700
Message-Id: <20210827004455.286754-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210827004455.286754-1-mathew.j.martineau@linux.intel.com>
References: <20210827004455.286754-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Should be set only if the ingress packets present it, otherwise
we can confuse csum validation.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index bec3ed82e253..f012a71dd996 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -355,8 +355,6 @@ void mptcp_get_options(const struct sock *sk,
 		       const struct sk_buff *skb,
 		       struct mptcp_options_received *mp_opt)
 {
-	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
-	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
 	const struct tcphdr *th = tcp_hdr(skb);
 	const unsigned char *ptr;
 	int length;
@@ -372,7 +370,7 @@ void mptcp_get_options(const struct sock *sk,
 	mp_opt->dss = 0;
 	mp_opt->mp_prio = 0;
 	mp_opt->reset = 0;
-	mp_opt->csum_reqd = READ_ONCE(msk->csum_enabled);
+	mp_opt->csum_reqd = 0;
 	mp_opt->deny_join_id0 = 0;
 	mp_opt->mp_fail = 0;
 
-- 
2.33.0

