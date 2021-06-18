Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B85943AD4BC
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 00:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234698AbhFRWEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 18:04:39 -0400
Received: from mga05.intel.com ([192.55.52.43]:53160 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233033AbhFRWEh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 18:04:37 -0400
IronPort-SDR: bVOy+9raFoF69cz8KCvzRxXPEg9Lr2ctvYvpT43VDdMceql47PntiK6UWPROfXAXLwIAaA4sC5
 T26MW0iouluA==
X-IronPort-AV: E=McAfee;i="6200,9189,10019"; a="292256527"
X-IronPort-AV: E=Sophos;i="5.83,284,1616482800"; 
   d="scan'208";a="292256527"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2021 15:02:27 -0700
IronPort-SDR: E7BgKZAdnyEmq+vwF0de9WcEquueXC4EPviy63J01W9mT+p/xKCguUPFTcjU5LbTmomMXMPI3Y
 F3Wq2Cq3FE1g==
X-IronPort-AV: E=Sophos;i="5.83,284,1616482800"; 
   d="scan'208";a="443703682"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.26.218])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2021 15:02:27 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, fw@strlen.de,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 1/2] mptcp: fix bad handling of 32 bit ack wrap-around
Date:   Fri, 18 Jun 2021 15:02:20 -0700
Message-Id: <20210618220221.99172-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210618220221.99172-1-mathew.j.martineau@linux.intel.com>
References: <20210618220221.99172-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

When receiving 32 bits DSS ack from the peer, the MPTCP need
to expand them to 64 bits value. The current code is buggy
WRT detecting 32 bits ack wrap-around: when the wrap-around
happens the current unsigned 32 bit ack value is lower than
the previous one.

Additionally check for possible reverse wrap and make the helper
visible, so that we could re-use it for the next patch.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/204
Fixes: cc9d25669866 ("mptcp: update per unacked sequence on pkt reception")
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/options.c  | 29 +++++++++++++++--------------
 net/mptcp/protocol.h |  8 ++++++++
 2 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 9b263f27ce9b..b87e46f515fb 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -896,19 +896,20 @@ static bool check_fully_established(struct mptcp_sock *msk, struct sock *ssk,
 	return false;
 }
 
-static u64 expand_ack(u64 old_ack, u64 cur_ack, bool use_64bit)
+u64 __mptcp_expand_seq(u64 old_seq, u64 cur_seq)
 {
-	u32 old_ack32, cur_ack32;
-
-	if (use_64bit)
-		return cur_ack;
-
-	old_ack32 = (u32)old_ack;
-	cur_ack32 = (u32)cur_ack;
-	cur_ack = (old_ack & GENMASK_ULL(63, 32)) + cur_ack32;
-	if (unlikely(before(cur_ack32, old_ack32)))
-		return cur_ack + (1LL << 32);
-	return cur_ack;
+	u32 old_seq32, cur_seq32;
+
+	old_seq32 = (u32)old_seq;
+	cur_seq32 = (u32)cur_seq;
+	cur_seq = (old_seq & GENMASK_ULL(63, 32)) + cur_seq32;
+	if (unlikely(cur_seq32 < old_seq32 && before(old_seq32, cur_seq32)))
+		return cur_seq + (1LL << 32);
+
+	/* reverse wrap could happen, too */
+	if (unlikely(cur_seq32 > old_seq32 && after(old_seq32, cur_seq32)))
+		return cur_seq - (1LL << 32);
+	return cur_seq;
 }
 
 static void ack_update_msk(struct mptcp_sock *msk,
@@ -926,7 +927,7 @@ static void ack_update_msk(struct mptcp_sock *msk,
 	 * more dangerous than missing an ack
 	 */
 	old_snd_una = msk->snd_una;
-	new_snd_una = expand_ack(old_snd_una, mp_opt->data_ack, mp_opt->ack64);
+	new_snd_una = mptcp_expand_seq(old_snd_una, mp_opt->data_ack, mp_opt->ack64);
 
 	/* ACK for data not even sent yet? Ignore. */
 	if (after64(new_snd_una, snd_nxt))
@@ -963,7 +964,7 @@ bool mptcp_update_rcv_data_fin(struct mptcp_sock *msk, u64 data_fin_seq, bool us
 		return false;
 
 	WRITE_ONCE(msk->rcv_data_fin_seq,
-		   expand_ack(READ_ONCE(msk->ack_seq), data_fin_seq, use_64bit));
+		   mptcp_expand_seq(READ_ONCE(msk->ack_seq), data_fin_seq, use_64bit));
 	WRITE_ONCE(msk->rcv_data_fin, 1);
 
 	return true;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 385796f0ef19..5d7c44028e47 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -593,6 +593,14 @@ int mptcp_setsockopt(struct sock *sk, int level, int optname,
 int mptcp_getsockopt(struct sock *sk, int level, int optname,
 		     char __user *optval, int __user *option);
 
+u64 __mptcp_expand_seq(u64 old_seq, u64 cur_seq);
+static inline u64 mptcp_expand_seq(u64 old_seq, u64 cur_seq, bool use_64bit)
+{
+	if (use_64bit)
+		return cur_seq;
+
+	return __mptcp_expand_seq(old_seq, cur_seq);
+}
 void __mptcp_check_push(struct sock *sk, struct sock *ssk);
 void __mptcp_data_acked(struct sock *sk);
 void __mptcp_error_report(struct sock *sk);
-- 
2.32.0

