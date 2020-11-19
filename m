Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0212B9BAC
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 20:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbgKSTqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 14:46:11 -0500
Received: from mga04.intel.com ([192.55.52.120]:13142 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727657AbgKSTqK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 14:46:10 -0500
IronPort-SDR: S1M/wRfE5wppRT7CQfzf0nLI05Zbv+I2/WbQkwTxHpiHUllvuRdszQYGgFkP8bHDdiPbXIHzwF
 MfeDh1ossbCw==
X-IronPort-AV: E=McAfee;i="6000,8403,9810"; a="168780892"
X-IronPort-AV: E=Sophos;i="5.78,354,1599548400"; 
   d="scan'208";a="168780892"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2020 11:46:09 -0800
IronPort-SDR: zdEQxS5eu52G5sE2T98oJnIyF1KwUj0Ngv3taWMYvDl5/s+WTk4LhMz2IjC0Dwed3kQFmWccyS
 Yb7qtI3oXLlw==
X-IronPort-AV: E=Sophos;i="5.78,354,1599548400"; 
   d="scan'208";a="476940476"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.255.229.232])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2020 11:46:08 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, kuba@kernel.org,
        mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 02/10] mptcp: fix state tracking for fallback socket
Date:   Thu, 19 Nov 2020 11:45:55 -0800
Message-Id: <20201119194603.103158-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201119194603.103158-1-mathew.j.martineau@linux.intel.com>
References: <20201119194603.103158-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

We need to cope with some more state transition for
fallback sockets, or could still end-up moving to TCP_CLOSE
too early and avoid spooling some pending data

Fixes: e16163b6e2b7 ("mptcp: refactor shutdown and close")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 749c00fffff5..a46a542b1766 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -777,7 +777,9 @@ static void mptcp_check_for_eof(struct mptcp_sock *msk)
 		inet_sk_state_store(sk, TCP_CLOSE_WAIT);
 		break;
 	case TCP_FIN_WAIT1:
-		/* fallback sockets skip TCP_CLOSING - TCP will take care */
+		inet_sk_state_store(sk, TCP_CLOSING);
+		break;
+	case TCP_FIN_WAIT2:
 		inet_sk_state_store(sk, TCP_CLOSE);
 		break;
 	default:
@@ -2085,10 +2087,16 @@ static void __mptcp_check_send_data_fin(struct sock *sk)
 
 	WRITE_ONCE(msk->snd_nxt, msk->write_seq);
 
-	/* fallback socket will not get data_fin/ack, can move to close now */
-	if (__mptcp_check_fallback(msk) && sk->sk_state == TCP_LAST_ACK) {
-		inet_sk_state_store(sk, TCP_CLOSE);
-		mptcp_close_wake_up(sk);
+	/* fallback socket will not get data_fin/ack, can move to the next
+	 * state now
+	 */
+	if (__mptcp_check_fallback(msk)) {
+		if ((1 << sk->sk_state) & (TCPF_CLOSING | TCPF_LAST_ACK)) {
+			inet_sk_state_store(sk, TCP_CLOSE);
+			mptcp_close_wake_up(sk);
+		} else if (sk->sk_state == TCP_FIN_WAIT1) {
+			inet_sk_state_store(sk, TCP_FIN_WAIT2);
+		}
 	}
 
 	__mptcp_flush_join_list(msk);
-- 
2.29.2

