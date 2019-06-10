Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05B033BEDD
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 23:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389362AbfFJVps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 17:45:48 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:52378 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389083AbfFJVpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 17:45:47 -0400
Received: by mail-pf1-f202.google.com with SMTP id i123so8063221pfb.19
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 14:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=qRVB35Ix0EnXk+x19HEgddT7X6s8d1Gr4NFUIpSc2zk=;
        b=EOoH0wYFbuMx81Rw2RRwCVBrmaRpOgzg7DgThbSfYnoKOvC1ZT5ESql0L+43Lkzaja
         fVIeNjWHwXdoXmwUyz+2dnZ5oKfY+2fCOetIo1M5xg9ZP5aaLAISRTXyFy8gZ/oAILbO
         1JwmNJFzw1wpwjvtToumiCSy/fZ4voVrA+PuiQXIVzX/AXHINPhbd72thetBCtZNTWKA
         1/LFAgqrqDowu5ZYtdSkEXzuXET8s2taWst78hJ6lT7CufTyLjaeIdP9WnUDCKeBqpXa
         wHG2sW0YOsn+4hy8ZAog+dNSy7ld3ZUBp9xrq+h47umN2LHz/CHzGKDuhasB4EuUlZlM
         5w5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=qRVB35Ix0EnXk+x19HEgddT7X6s8d1Gr4NFUIpSc2zk=;
        b=X4odKHMlhR6Lji1ZjvWV1Lyd1jz7lQ5udQOhR9n3NtS8O28c16ncbNCAM+h4arcGTq
         br1aRzfbsSJx/bhtAZUVdrM5bO/qNmEJTfOsfppgnBiRF1nc13cHC88hr9U4N01FHLYO
         j7Wc+cxJDRUWLafp8xNl9Sg4KP++AkOa8KNlQ7rfBo8vQc4coprMshssejysERiMat/M
         1CwpxBubCL9l503lryI/oPe9ulHKuxYlWv5mH0vlX6VhWNb2xMZGqT+4irFyU3Hx9z2L
         yvyzgYSVFCiq04cjOfZDZX9YUwDRtoGNcc6wim1rsqcRlmQINbx/IMeWu+q+AeKGhNTM
         idqg==
X-Gm-Message-State: APjAAAW0k07K4dKZbpMgrfTRBOYH17UyRy6+etqfraZiLUlIrldtOXug
        os3BStpZS3AS/AblE4J26G9ldp8XNkJeHg==
X-Google-Smtp-Source: APXvYqyEbVdWVm90JLGQ7Z0h46UJANxDfIhIDOhVZLeXx1s5RUuNdf8V33N/23hdAYEewLoTEnA0H3xbqeQeng==
X-Received: by 2002:a63:c94f:: with SMTP id y15mr17582952pgg.159.1560203146698;
 Mon, 10 Jun 2019 14:45:46 -0700 (PDT)
Date:   Mon, 10 Jun 2019 14:45:43 -0700
Message-Id: <20190610214543.92576-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
Subject: [PATCH net-next] tcp: take care of SYN_RECV sockets in
 tcp_v4_send_ack() and tcp_v6_send_response()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jon Maxwell <jmaxwell37@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TCP can send ACK packets on behalf of SYN_RECV sockets.

tcp_v4_send_ack() and tcp_v6_send_response() incorrectly
dereference sk->sk_mark for non TIME_WAIT sockets.

This field is not defined for SYN_RECV sockets.

Using sk_to_full_sk() should get back to the listener socket.

Note that this also provides a socket pointer to sock_net_uid() calls.

Fixes: 00483690552c ("tcp: Add mark for TIMEWAIT sockets")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jon Maxwell <jmaxwell37@gmail.com>
---
 net/ipv4/tcp_ipv4.c | 6 ++++--
 net/ipv6/tcp_ipv6.c | 1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index f059fbd81a84314ae6fef37f600b0cf28bd2ad30..2bb27d5eae78efdff52a741904d7526a234595d8 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -856,12 +856,14 @@ static void tcp_v4_send_ack(const struct sock *sk,
 	if (oif)
 		arg.bound_dev_if = oif;
 	arg.tos = tos;
-	arg.uid = sock_net_uid(net, sk_fullsock(sk) ? sk : NULL);
 	local_bh_disable();
 	ctl_sk = this_cpu_read(*net->ipv4.tcp_sk);
-	if (sk)
+	if (sk) {
+		sk = sk_to_full_sk(sk);
 		ctl_sk->sk_mark = (sk->sk_state == TCP_TIME_WAIT) ?
 				   inet_twsk(sk)->tw_mark : sk->sk_mark;
+	}
+	arg.uid = sock_net_uid(net, sk_fullsock(sk) ? sk : NULL);
 	ip_send_unicast_reply(ctl_sk,
 			      skb, &TCP_SKB_CB(skb)->header.h4.opt,
 			      ip_hdr(skb)->saddr, ip_hdr(skb)->daddr,
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index ad7039137a20f9ad8581d9ca01347c67aa8a8433..ea4dd988bc7f9a90e0d95283e10db5a517a59027 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -884,6 +884,7 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 	}
 
 	if (sk) {
+		sk = sk_to_full_sk(sk);
 		if (sk->sk_state == TCP_TIME_WAIT) {
 			mark = inet_twsk(sk)->tw_mark;
 			/* autoflowlabel relies on buff->hash */
-- 
2.22.0.rc2.383.gf4fbbf30c2-goog

