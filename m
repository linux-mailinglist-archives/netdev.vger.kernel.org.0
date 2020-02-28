Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85E8117438B
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 00:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgB1Xr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 18:47:57 -0500
Received: from mga14.intel.com ([192.55.52.115]:3767 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726695AbgB1Xr5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Feb 2020 18:47:57 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Feb 2020 15:47:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,497,1574150400"; 
   d="scan'208";a="351031531"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.18.184])
  by fmsmga001.fm.intel.com with ESMTP; 28 Feb 2020 15:47:55 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/3] mptcp: Check connection state before attempting send
Date:   Fri, 28 Feb 2020 15:47:39 -0800
Message-Id: <20200228234741.57086-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200228234741.57086-1-mathew.j.martineau@linux.intel.com>
References: <20200228234741.57086-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MPTCP should wait for an active connection or skip sending depending on
the connection state, as TCP does. This happens before the possible
passthrough to a regular TCP sendmsg because the subflow's socket type
(MPTCP or TCP fallback) is not known until the connection is
complete. This is also relevent at disconnect time, where data should
not be sent in certain MPTCP-level connection states.

Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index a8445407d25a..07559b45eec5 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -419,6 +419,15 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		return -EOPNOTSUPP;
 
 	lock_sock(sk);
+
+	timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
+
+	if ((1 << sk->sk_state) & ~(TCPF_ESTABLISHED | TCPF_CLOSE_WAIT)) {
+		ret = sk_stream_wait_connect(sk, &timeo);
+		if (ret)
+			goto out;
+	}
+
 	ssock = __mptcp_tcp_fallback(msk);
 	if (unlikely(ssock)) {
 fallback:
@@ -427,8 +436,6 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		return ret >= 0 ? ret + copied : (copied ? copied : ret);
 	}
 
-	timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
-
 	ssk = mptcp_subflow_get(msk);
 	if (!ssk) {
 		release_sock(sk);
@@ -460,6 +467,7 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	ssk_check_wmem(msk, ssk);
 	release_sock(ssk);
+out:
 	release_sock(sk);
 	return ret;
 }
-- 
2.25.1

