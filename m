Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570E23ABFAE
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 01:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233054AbhFQXsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 19:48:39 -0400
Received: from mga03.intel.com ([134.134.136.65]:13468 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232631AbhFQXsh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 19:48:37 -0400
IronPort-SDR: p8kU1213F21fIGK/ZUySOqafHoTrAFigk3XQaQkyD/kN6SFBHkHT8r6JI3oTY0azwTMKZx9FMO
 8//rkXRSEWMw==
X-IronPort-AV: E=McAfee;i="6200,9189,10018"; a="206506625"
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="206506625"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 16:46:28 -0700
IronPort-SDR: Y5/6TygveoKF1iEZY7ouV2L9SLieb0WDigEwil4LLco5wKh3IZ8iQ19dV8sRM4uWb/qc/Dmkzj
 xZwIo0yqkjfQ==
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="452943897"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.250.143])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 16:46:28 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, pabeni@redhat.com,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 01/16] mptcp: add csum_enabled in mptcp_sock
Date:   Thu, 17 Jun 2021 16:46:07 -0700
Message-Id: <20210617234622.472030-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210617234622.472030-1-mathew.j.martineau@linux.intel.com>
References: <20210617234622.472030-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch added a new member named csum_enabled in struct mptcp_sock,
used a dummy mptcp_is_checksum_enabled() helper to initialize it.

Also added a new member named mptcpi_csum_enabled in struct mptcp_info
to expose the csum_enabled flag.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/uapi/linux/mptcp.h | 1 +
 net/mptcp/mptcp_diag.c     | 1 +
 net/mptcp/protocol.c       | 1 +
 net/mptcp/protocol.h       | 2 ++
 4 files changed, 5 insertions(+)

diff --git a/include/uapi/linux/mptcp.h b/include/uapi/linux/mptcp.h
index 8eb3c0844bff..7b05f7102321 100644
--- a/include/uapi/linux/mptcp.h
+++ b/include/uapi/linux/mptcp.h
@@ -105,6 +105,7 @@ struct mptcp_info {
 	__u64	mptcpi_rcv_nxt;
 	__u8	mptcpi_local_addr_used;
 	__u8	mptcpi_local_addr_max;
+	__u8	mptcpi_csum_enabled;
 };
 
 /*
diff --git a/net/mptcp/mptcp_diag.c b/net/mptcp/mptcp_diag.c
index f16d9b5ee978..8f88ddeab6a2 100644
--- a/net/mptcp/mptcp_diag.c
+++ b/net/mptcp/mptcp_diag.c
@@ -144,6 +144,7 @@ static void mptcp_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
 	info->mptcpi_write_seq = READ_ONCE(msk->write_seq);
 	info->mptcpi_snd_una = READ_ONCE(msk->snd_una);
 	info->mptcpi_rcv_nxt = READ_ONCE(msk->ack_seq);
+	info->mptcpi_csum_enabled = READ_ONCE(msk->csum_enabled);
 	unlock_sock_fast(sk, slow);
 }
 
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 993095089990..2caca0dc2c1c 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2453,6 +2453,7 @@ static int __mptcp_init_sock(struct sock *sk)
 	msk->ack_hint = NULL;
 	msk->first = NULL;
 	inet_csk(sk)->icsk_sync_mss = mptcp_sync_mss;
+	WRITE_ONCE(msk->csum_enabled, mptcp_is_checksum_enabled(sock_net(sk)));
 
 	mptcp_pm_data_init(msk);
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 89f6b73783d5..1fc6693e257e 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -234,6 +234,7 @@ struct mptcp_sock {
 	bool		snd_data_fin_enable;
 	bool		rcv_fastclose;
 	bool		use_64bit_ack; /* Set when we received a 64-bit DSN */
+	bool		csum_enabled;
 	spinlock_t	join_list_lock;
 	struct sock	*ack_hint;
 	struct work_struct work;
@@ -525,6 +526,7 @@ static inline void mptcp_subflow_delegated_done(struct mptcp_subflow_context *su
 
 int mptcp_is_enabled(struct net *net);
 unsigned int mptcp_get_add_addr_timeout(struct net *net);
+static inline int mptcp_is_checksum_enabled(struct net *net) { return false; }
 void mptcp_subflow_fully_established(struct mptcp_subflow_context *subflow,
 				     struct mptcp_options_received *mp_opt);
 bool mptcp_subflow_data_available(struct sock *sk);
-- 
2.32.0

