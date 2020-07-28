Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9BD231563
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 00:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729822AbgG1WMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 18:12:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:2589 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729746AbgG1WMS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 18:12:18 -0400
IronPort-SDR: olc2f72b9c91KQFFbhnr49KSRZ1XZ23PXUUdCopewOPtdfqhMVQeP777ikruceGecHaMmXDoz8
 6spucC9kFjTw==
X-IronPort-AV: E=McAfee;i="6000,8403,9696"; a="139342684"
X-IronPort-AV: E=Sophos;i="5.75,408,1589266800"; 
   d="scan'208";a="139342684"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2020 15:12:14 -0700
IronPort-SDR: SDqzFE1WrXvcIGJ/CDQDgcSsEZhgKG/+K0OVgCoHml1puQYiimPA7xvbec9p/rLzMWLBdzNk+6
 xqPHLyxXZFHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,408,1589266800"; 
   d="scan'208";a="328468888"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.116.118])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Jul 2020 15:12:14 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        mptcp@lists.01.org, matthieu.baerts@tessares.net, pabeni@redhat.com
Subject: [PATCH net-next 06/12] mptcp: Add mptcp_close_state() helper
Date:   Tue, 28 Jul 2020 15:12:04 -0700
Message-Id: <20200728221210.92841-7-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200728221210.92841-1-mathew.j.martineau@linux.intel.com>
References: <20200728221210.92841-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will be used to transition to the appropriate state on close and
determine if a DATA_FIN needs to be sent for that state transition.

Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index e1c71bfd61a3..51370b69e30b 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1498,6 +1498,33 @@ static void mptcp_subflow_shutdown(struct sock *ssk, int how)
 	release_sock(ssk);
 }
 
+static const unsigned char new_state[16] = {
+	/* current state:     new state:      action:	*/
+	[0 /* (Invalid) */] = TCP_CLOSE,
+	[TCP_ESTABLISHED]   = TCP_FIN_WAIT1 | TCP_ACTION_FIN,
+	[TCP_SYN_SENT]      = TCP_CLOSE,
+	[TCP_SYN_RECV]      = TCP_FIN_WAIT1 | TCP_ACTION_FIN,
+	[TCP_FIN_WAIT1]     = TCP_FIN_WAIT1,
+	[TCP_FIN_WAIT2]     = TCP_FIN_WAIT2,
+	[TCP_TIME_WAIT]     = TCP_CLOSE,	/* should not happen ! */
+	[TCP_CLOSE]         = TCP_CLOSE,
+	[TCP_CLOSE_WAIT]    = TCP_LAST_ACK  | TCP_ACTION_FIN,
+	[TCP_LAST_ACK]      = TCP_LAST_ACK,
+	[TCP_LISTEN]        = TCP_CLOSE,
+	[TCP_CLOSING]       = TCP_CLOSING,
+	[TCP_NEW_SYN_RECV]  = TCP_CLOSE,	/* should not happen ! */
+};
+
+static int mptcp_close_state(struct sock *sk)
+{
+	int next = (int)new_state[sk->sk_state];
+	int ns = next & TCP_STATE_MASK;
+
+	inet_sk_state_store(sk, ns);
+
+	return next & TCP_ACTION_FIN;
+}
+
 static void mptcp_close(struct sock *sk, long timeout)
 {
 	struct mptcp_subflow_context *subflow, *tmp;
-- 
2.28.0

