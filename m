Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4466C3ABFAF
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 01:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233084AbhFQXsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 19:48:41 -0400
Received: from mga03.intel.com ([134.134.136.65]:13470 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232860AbhFQXsi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 19:48:38 -0400
IronPort-SDR: 6WTwFkM6z53DYoaCM6COSmiMpJnksOZIsTxvGQx3glQ5lQAz+j5Ff2IV0LGKXByBwMBcLYD6U7
 tdAW2YeiEveg==
X-IronPort-AV: E=McAfee;i="6200,9189,10018"; a="206506628"
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="206506628"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 16:46:29 -0700
IronPort-SDR: 6P1q/uOhj6mW8Vs8CT5TPLqlDjB19Rs/7kUCMTOdK2JcIp6XyeCZR9F70QAEBkBs5qJyCBIZNw
 cLqXOonV1bxg==
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="452943898"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.250.143])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 16:46:28 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, pabeni@redhat.com,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 02/16] mptcp: generate the data checksum
Date:   Thu, 17 Jun 2021 16:46:08 -0700
Message-Id: <20210617234622.472030-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210617234622.472030-1-mathew.j.martineau@linux.intel.com>
References: <20210617234622.472030-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch added a new member named csum in struct mptcp_ext, implemented
a new function named mptcp_generate_data_checksum().

Generate the data checksum in mptcp_sendmsg_frag, save it in mpext->csum.

Note that we must generate the csum for zero window probe, too.

Do the csum update incrementally, to avoid multiple csum computation
when the data is appended to existing skb.

Note that in a later patch we will skip unneeded csum related operation.
Changes not included here to keep the delta small.

Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/net/mptcp.h  |  1 +
 net/mptcp/protocol.c | 18 +++++++++++++++++-
 net/mptcp/protocol.h |  7 +++++++
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 83f23774b908..23bbd439e115 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -23,6 +23,7 @@ struct mptcp_ext {
 	u64		data_seq;
 	u32		subflow_seq;
 	u16		data_len;
+	__sum16		csum;
 	u8		use_map:1,
 			dsn64:1,
 			data_fin:1,
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 2caca0dc2c1c..f0da067301f6 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1308,6 +1308,18 @@ static bool mptcp_alloc_tx_skb(struct sock *sk, struct sock *ssk)
 	return __mptcp_alloc_tx_skb(sk, ssk, sk->sk_allocation);
 }
 
+/* note: this always recompute the csum on the whole skb, even
+ * if we just appended a single frag. More status info needed
+ */
+static void mptcp_update_data_checksum(struct sk_buff *skb, int added)
+{
+	struct mptcp_ext *mpext = mptcp_get_ext(skb);
+	__wsum csum = ~csum_unfold(mpext->csum);
+	int offset = skb->len - added;
+
+	mpext->csum = csum_fold(csum_block_add(csum, skb_checksum(skb, offset, added, 0), offset));
+}
+
 static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 			      struct mptcp_data_frag *dfrag,
 			      struct mptcp_sendmsg_info *info)
@@ -1402,10 +1414,14 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	if (zero_window_probe) {
 		mptcp_subflow_ctx(ssk)->rel_write_seq += ret;
 		mpext->frozen = 1;
-		ret = 0;
+		if (READ_ONCE(msk->csum_enabled))
+			mptcp_update_data_checksum(tail, ret);
 		tcp_push_pending_frames(ssk);
+		return 0;
 	}
 out:
+	if (READ_ONCE(msk->csum_enabled))
+		mptcp_update_data_checksum(tail, ret);
 	mptcp_subflow_ctx(ssk)->rel_write_seq += ret;
 	return ret;
 }
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 1fc6693e257e..4913ac7b6d19 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -336,6 +336,13 @@ static inline struct mptcp_data_frag *mptcp_rtx_head(const struct sock *sk)
 	return list_first_entry_or_null(&msk->rtx_queue, struct mptcp_data_frag, list);
 }
 
+struct csum_pseudo_header {
+	__be64 data_seq;
+	__be32 subflow_seq;
+	__be16 data_len;
+	__sum16 csum;
+};
+
 struct mptcp_subflow_request_sock {
 	struct	tcp_request_sock sk;
 	u16	mp_capable : 1,
-- 
2.32.0

