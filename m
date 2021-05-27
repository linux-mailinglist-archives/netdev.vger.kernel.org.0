Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A188539394B
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 01:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235083AbhE0XdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 19:33:22 -0400
Received: from mga18.intel.com ([134.134.136.126]:8585 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235068AbhE0XdT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 19:33:19 -0400
IronPort-SDR: r86PluOk+ZBJSaXWFTeWVuyzcKIKjIphDzg2+eC2p0rtNqae6Tvf0Q1T+DHHWLipLw+0BnaEyL
 RC9/K3jQLWmw==
X-IronPort-AV: E=McAfee;i="6200,9189,9997"; a="190227181"
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="190227181"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2021 16:31:45 -0700
IronPort-SDR: xQY4shMYAtwGfOqK5tGOFSc6ORdt/AOyDBucP0yeQ1e+VyL3pi3e+GgBSEuuEzXFzlgdHeQw+p
 KrMa+eQKDa3g==
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="477700334"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.84.136])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2021 16:31:45 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 3/4] mptcp: do not reset MP_CAPABLE subflow on mapping errors
Date:   Thu, 27 May 2021 16:31:39 -0700
Message-Id: <20210527233140.182728-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527233140.182728-1-mathew.j.martineau@linux.intel.com>
References: <20210527233140.182728-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

When some mapping related errors occurs we close the main
MPC subflow with a RST. We should instead fallback gracefully
to TCP, and do the reset only for MPJ subflows.

Fixes: d22f4988ffec ("mptcp: process MP_CAPABLE data option")
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/192
Reported-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/subflow.c | 62 +++++++++++++++++++++++----------------------
 1 file changed, 32 insertions(+), 30 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index c6ee81149829..ef3d037f984a 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1011,21 +1011,11 @@ static bool subflow_check_data_avail(struct sock *ssk)
 
 		status = get_mapping_status(ssk, msk);
 		trace_subflow_check_data_avail(status, skb_peek(&ssk->sk_receive_queue));
-		if (status == MAPPING_INVALID) {
-			ssk->sk_err = EBADMSG;
-			goto fatal;
-		}
-		if (status == MAPPING_DUMMY) {
-			__mptcp_do_fallback(msk);
-			skb = skb_peek(&ssk->sk_receive_queue);
-			subflow->map_valid = 1;
-			subflow->map_seq = READ_ONCE(msk->ack_seq);
-			subflow->map_data_len = skb->len;
-			subflow->map_subflow_seq = tcp_sk(ssk)->copied_seq -
-						   subflow->ssn_offset;
-			subflow->data_avail = MPTCP_SUBFLOW_DATA_AVAIL;
-			return true;
-		}
+		if (unlikely(status == MAPPING_INVALID))
+			goto fallback;
+
+		if (unlikely(status == MAPPING_DUMMY))
+			goto fallback;
 
 		if (status != MAPPING_OK)
 			goto no_data;
@@ -1038,10 +1028,8 @@ static bool subflow_check_data_avail(struct sock *ssk)
 		 * MP_CAPABLE-based mapping
 		 */
 		if (unlikely(!READ_ONCE(msk->can_ack))) {
-			if (!subflow->mpc_map) {
-				ssk->sk_err = EBADMSG;
-				goto fatal;
-			}
+			if (!subflow->mpc_map)
+				goto fallback;
 			WRITE_ONCE(msk->remote_key, subflow->remote_key);
 			WRITE_ONCE(msk->ack_seq, subflow->map_seq);
 			WRITE_ONCE(msk->can_ack, true);
@@ -1069,17 +1057,31 @@ static bool subflow_check_data_avail(struct sock *ssk)
 no_data:
 	subflow_sched_work_if_closed(msk, ssk);
 	return false;
-fatal:
-	/* fatal protocol error, close the socket */
-	/* This barrier is coupled with smp_rmb() in tcp_poll() */
-	smp_wmb();
-	ssk->sk_error_report(ssk);
-	tcp_set_state(ssk, TCP_CLOSE);
-	subflow->reset_transient = 0;
-	subflow->reset_reason = MPTCP_RST_EMPTCP;
-	tcp_send_active_reset(ssk, GFP_ATOMIC);
-	subflow->data_avail = 0;
-	return false;
+
+fallback:
+	/* RFC 8684 section 3.7. */
+	if (subflow->mp_join || subflow->fully_established) {
+		/* fatal protocol error, close the socket.
+		 * subflow_error_report() will introduce the appropriate barriers
+		 */
+		ssk->sk_err = EBADMSG;
+		ssk->sk_error_report(ssk);
+		tcp_set_state(ssk, TCP_CLOSE);
+		subflow->reset_transient = 0;
+		subflow->reset_reason = MPTCP_RST_EMPTCP;
+		tcp_send_active_reset(ssk, GFP_ATOMIC);
+		subflow->data_avail = 0;
+		return false;
+	}
+
+	__mptcp_do_fallback(msk);
+	skb = skb_peek(&ssk->sk_receive_queue);
+	subflow->map_valid = 1;
+	subflow->map_seq = READ_ONCE(msk->ack_seq);
+	subflow->map_data_len = skb->len;
+	subflow->map_subflow_seq = tcp_sk(ssk)->copied_seq - subflow->ssn_offset;
+	subflow->data_avail = MPTCP_SUBFLOW_DATA_AVAIL;
+	return true;
 }
 
 bool mptcp_subflow_data_available(struct sock *sk)
-- 
2.31.1

