Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8FB467FFA
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 23:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383432AbhLCWjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 17:39:22 -0500
Received: from mga18.intel.com ([134.134.136.126]:46470 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1383433AbhLCWjQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 17:39:16 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10187"; a="223940938"
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="223940938"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2021 14:35:48 -0800
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="460185314"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.18.88])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2021 14:35:47 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Maxim Galaganov <max@internet.ru>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 09/10] mptcp: expose mptcp_check_and_set_pending
Date:   Fri,  3 Dec 2021 14:35:40 -0800
Message-Id: <20211203223541.69364-10-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211203223541.69364-1-mathew.j.martineau@linux.intel.com>
References: <20211203223541.69364-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Galaganov <max@internet.ru>

Expose the mptcp_check_and_set_pending() function for use inside MPTCP
sockopt code. The next patch will call it when TCP_CORK is cleared or
TCP_NODELAY is set on the MPTCP socket in order to push pending data
from mptcp_release_cb().

Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Maxim Galaganov <max@internet.ru>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 2 +-
 net/mptcp/protocol.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 943f74e804bd..f124cca125d2 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1502,7 +1502,7 @@ static void mptcp_update_post_push(struct mptcp_sock *msk,
 		msk->snd_nxt = snd_nxt_new;
 }
 
-static void mptcp_check_and_set_pending(struct sock *sk)
+void mptcp_check_and_set_pending(struct sock *sk)
 {
 	if (mptcp_send_head(sk) &&
 	    !test_bit(MPTCP_PUSH_PENDING, &mptcp_sk(sk)->flags))
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index bb51fa7f5566..147b22da41ca 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -555,6 +555,7 @@ unsigned int mptcp_stale_loss_cnt(const struct net *net);
 void mptcp_subflow_fully_established(struct mptcp_subflow_context *subflow,
 				     struct mptcp_options_received *mp_opt);
 bool __mptcp_retransmit_pending_data(struct sock *sk);
+void mptcp_check_and_set_pending(struct sock *sk);
 void __mptcp_push_pending(struct sock *sk, unsigned int flags);
 bool mptcp_subflow_data_available(struct sock *sk);
 void __init mptcp_subflow_init(void);
-- 
2.34.1

