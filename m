Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1519513F2BF
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390567AbgAPRMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:12:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:56096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390560AbgAPRMq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:12:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9823246A5;
        Thu, 16 Jan 2020 17:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194765;
        bh=sfdtezAZn8Ir6ruYN4QRauIXgF7EqzfCgZEnkclNeDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W9vV3NCmM3HR0yAehrn3lgacCYkGNXGxSk4QNKTwsZ4DWVDZ7Zg90Z3bKPxY3mzZd
         ABnTg2b1v0sq3vSm5vYzZfW6dAqmwwoQV7kC4wYygHCX0XmzSFfS2JnuN0GWqmWAXj
         DuOSD0vyP32f7wkwQkEfLS8qaF8SzoXuVQ1L6CGo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xin Long <lucien.xin@gmail.com>, Ying Xu <yinxu@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 585/671] sctp: add chunks to sk_backlog when the newsk sk_socket is not set
Date:   Thu, 16 Jan 2020 12:03:43 -0500
Message-Id: <20200116170509.12787-322-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 819be8108fded0b9e710bbbf81193e52f7bab2f7 ]

This patch is to fix a NULL-ptr deref in selinux_socket_connect_helper:

  [...] kasan: GPF could be caused by NULL-ptr deref or user memory access
  [...] RIP: 0010:selinux_socket_connect_helper+0x94/0x460
  [...] Call Trace:
  [...]  selinux_sctp_bind_connect+0x16a/0x1d0
  [...]  security_sctp_bind_connect+0x58/0x90
  [...]  sctp_process_asconf+0xa52/0xfd0 [sctp]
  [...]  sctp_sf_do_asconf+0x785/0x980 [sctp]
  [...]  sctp_do_sm+0x175/0x5a0 [sctp]
  [...]  sctp_assoc_bh_rcv+0x285/0x5b0 [sctp]
  [...]  sctp_backlog_rcv+0x482/0x910 [sctp]
  [...]  __release_sock+0x11e/0x310
  [...]  release_sock+0x4f/0x180
  [...]  sctp_accept+0x3f9/0x5a0 [sctp]
  [...]  inet_accept+0xe7/0x720

It was caused by that the 'newsk' sk_socket was not set before going to
security sctp hook when processing asconf chunk with SCTP_PARAM_ADD_IP
or SCTP_PARAM_SET_PRIMARY:

  inet_accept()->
    sctp_accept():
      lock_sock():
          lock listening 'sk'
                                          do_softirq():
                                            sctp_rcv():  <-- [1]
                                                asconf chunk arrives and
                                                enqueued in 'sk' backlog
      sctp_sock_migrate():
          set asoc's sk to 'newsk'
      release_sock():
          sctp_backlog_rcv():
            lock 'newsk'
            sctp_process_asconf()  <-- [2]
            unlock 'newsk'
    sock_graft():
        set sk_socket  <-- [3]

As it shows, at [1] the asconf chunk would be put into the listening 'sk'
backlog, as accept() was holding its sock lock. Then at [2] asconf would
get processed with 'newsk' as asoc's sk had been set to 'newsk'. However,
'newsk' sk_socket is not set until [3], while selinux_sctp_bind_connect()
would deref it, then kernel crashed.

Here to fix it by adding the chunk to sk_backlog until newsk sk_socket is
set when .accept() is done.

Note that sk->sk_socket can be NULL when the sock is closed, so SOCK_DEAD
flag is also needed to check in sctp_newsk_ready().

Thanks to Ondrej for reviewing the code.

Fixes: d452930fd3b9 ("selinux: Add SCTP support")
Reported-by: Ying Xu <yinxu@redhat.com>
Suggested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sctp/sctp.h |  5 +++++
 net/sctp/input.c        | 12 +++++++++---
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 2abbc15824af..2c6570e6fcfe 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -625,4 +625,9 @@ static inline __u32 sctp_min_frag_point(struct sctp_sock *sp, __u16 datasize)
 	return sctp_mtu_payload(sp, SCTP_DEFAULT_MINSEGMENT, datasize);
 }
 
+static inline bool sctp_newsk_ready(const struct sock *sk)
+{
+	return sock_flag(sk, SOCK_DEAD) || sk->sk_socket;
+}
+
 #endif /* __net_sctp_h__ */
diff --git a/net/sctp/input.c b/net/sctp/input.c
index bfe29158afcc..f64d882c8698 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -255,7 +255,7 @@ int sctp_rcv(struct sk_buff *skb)
 		bh_lock_sock(sk);
 	}
 
-	if (sock_owned_by_user(sk)) {
+	if (sock_owned_by_user(sk) || !sctp_newsk_ready(sk)) {
 		if (sctp_add_backlog(sk, skb)) {
 			bh_unlock_sock(sk);
 			sctp_chunk_free(chunk);
@@ -333,7 +333,7 @@ int sctp_backlog_rcv(struct sock *sk, struct sk_buff *skb)
 		local_bh_disable();
 		bh_lock_sock(sk);
 
-		if (sock_owned_by_user(sk)) {
+		if (sock_owned_by_user(sk) || !sctp_newsk_ready(sk)) {
 			if (sk_add_backlog(sk, skb, sk->sk_rcvbuf))
 				sctp_chunk_free(chunk);
 			else
@@ -348,7 +348,13 @@ int sctp_backlog_rcv(struct sock *sk, struct sk_buff *skb)
 		if (backloged)
 			return 0;
 	} else {
-		sctp_inq_push(inqueue, chunk);
+		if (!sctp_newsk_ready(sk)) {
+			if (!sk_add_backlog(sk, skb, sk->sk_rcvbuf))
+				return 0;
+			sctp_chunk_free(chunk);
+		} else {
+			sctp_inq_push(inqueue, chunk);
+		}
 	}
 
 done:
-- 
2.20.1

