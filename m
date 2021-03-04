Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA1B632DBDA
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 22:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239591AbhCDVe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 16:34:29 -0500
Received: from mga12.intel.com ([192.55.52.136]:5221 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239471AbhCDVeJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 16:34:09 -0500
IronPort-SDR: 5xw/XTXwKuQhe2UemEvnzdPaG1AeRb+dDEWfsX5PmiJSxZtOe+h/uVOHT6PNdZdHrXzDXdAC0U
 QcLseH9UPE0A==
X-IronPort-AV: E=McAfee;i="6000,8403,9913"; a="166769410"
X-IronPort-AV: E=Sophos;i="5.81,223,1610438400"; 
   d="scan'208";a="166769410"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 13:32:23 -0800
IronPort-SDR: 4MDIgTRcFu2vNB922qJ5S7x69QiOog9Jv4jFiX+5OM0KcOSr6NqyVLeZGC4TQVrSefs2nsVyf9
 ijnHMgrRL80Q==
X-IronPort-AV: E=Sophos;i="5.81,223,1610438400"; 
   d="scan'208";a="368329476"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.105.71])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 13:32:22 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net, mptcp@lists.01.org,
        Christoph Paasch <cpaasch@apple.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 1/9] mptcp: reset last_snd on subflow close
Date:   Thu,  4 Mar 2021 13:32:08 -0800
Message-Id: <20210304213216.205472-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304213216.205472-1-mathew.j.martineau@linux.intel.com>
References: <20210304213216.205472-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Send logic caches last active subflow in the msk, so it needs to be
cleared when the cached subflow is closed.

Fixes: d5f49190def61c ("mptcp: allow picking different xmit subflows")
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/155
Reported-by: Christoph Paasch <cpaasch@apple.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index c5d5e68940ea..7362a536cbc0 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2126,6 +2126,8 @@ static struct sock *mptcp_subflow_get_retrans(const struct mptcp_sock *msk)
 static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 			      struct mptcp_subflow_context *subflow)
 {
+	struct mptcp_sock *msk = mptcp_sk(sk);
+
 	list_del(&subflow->node);
 
 	lock_sock_nested(ssk, SINGLE_DEPTH_NESTING);
@@ -2154,6 +2156,9 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 	release_sock(ssk);
 
 	sock_put(ssk);
+
+	if (ssk == msk->last_snd)
+		msk->last_snd = NULL;
 }
 
 void mptcp_close_ssk(struct sock *sk, struct sock *ssk,
-- 
2.30.1

