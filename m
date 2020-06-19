Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05355201AFB
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 21:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733024AbgFSTMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 15:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727848AbgFSTMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 15:12:41 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7804C06174E
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 12:12:40 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id p22so11088065ybg.21
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 12:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=g7X/TMBaYmZdNAHeWuGDya39hctuYRSa52ZDBQqiHc0=;
        b=v328LNh3SoFAgwwqKrDRJNgYCLfrtZja178sjv9jPQtzmTRrpYDGejjXabxnIn0DHW
         Up8dqCITFF4TEb/unaH5bm14K4WCSwQ7YU3tsVvsOw2zhw8qlDwvk9iLzC3RgTNvH1CB
         mwahoDkemJopvejgcGV1swZ600WWNXqVTyhGe4zwN7VMNh5IdSDLDP2/rTHIJAKb4EPD
         Jx/hh9WYCu58LPervT72eJl3xiJTAX1Z9U1tWzy9MvWD/P8kk8T5SiDw/WE6aUD/frtN
         8RGYPVzwBSguibGPCSIBjppVZReFuRPmMFWhC7C7CyiZrMftcNZ0QFvokx+CRBuBYFod
         n/1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=g7X/TMBaYmZdNAHeWuGDya39hctuYRSa52ZDBQqiHc0=;
        b=ugcd0WU6Ck31ZLFR7AsoR1OcOf1x4TIysIh4ZZRQcj87SH7rg0/O4kfwkzmBLqOBYL
         w6lEEroHT8Iz5REllyExhqjBQX8EMkDmPlbS7w57MVlHIv6opKWOWiUFeq10jpOj9QsO
         B0FVZYB3QKQZOkWaDVzaC5yjgeoBHWqi25qRdTxJnI7gp5nWTKJaD99Wj33pmOsB5vRu
         JXgoCy6ogpcx84KMmjdJ35lG2VUYVcroWfjz7219Q3qTXAqO0oSG8a54KT20hqmogb8g
         8Fdy9pjz31UlmHC7fIeOmepEpCfgknz541egGsTH2351xiN6Upec8OqDlf5G1Au5HT2+
         kiRw==
X-Gm-Message-State: AOAM533ITEMq/Z5EPKXXnHHSUfnyRCz+8x5NpJCNC7c6w657ZWuwc/Ca
        cuPq92yTeX9dSYz0w/QdSbkP93YxYS64tw==
X-Google-Smtp-Source: ABdhPJx+XlcK1XV5xWuMDrl0G0GmBzq7BD0peHJdrRYHiE/RsLWcePpHC1F6V7gAx/YRLPNo+I2Kt0GyKZgrTg==
X-Received: by 2002:a5b:548:: with SMTP id r8mr8408478ybp.322.1592593959973;
 Fri, 19 Jun 2020 12:12:39 -0700 (PDT)
Date:   Fri, 19 Jun 2020 12:12:34 -0700
In-Reply-To: <20200619191235.199506-1-edumazet@google.com>
Message-Id: <20200619191235.199506-2-edumazet@google.com>
Mime-Version: 1.0
References: <20200619191235.199506-1-edumazet@google.com>
X-Mailer: git-send-email 2.27.0.111.gc72c7da667-goog
Subject: [PATCH net-next 1/2] tcp: remove indirect calls for icsk->icsk_af_ops->queue_xmit
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mitigate RETPOLINE costs in __tcp_transmit_skb()
by using INDIRECT_CALL_INET() wrapper.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/ip.h      | 6 +-----
 include/net/tcp.h     | 1 +
 net/ipv4/ip_output.c  | 6 ++++++
 net/ipv4/tcp_output.c | 7 ++++++-
 4 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 04ebe7bf54c6a8b21cf7894691b36e564ef1aef1..862c9545833a95e25fdcddafcfc84cd07421835d 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -231,11 +231,7 @@ struct sk_buff *ip_make_skb(struct sock *sk, struct flowi4 *fl4,
 			    struct ipcm_cookie *ipc, struct rtable **rtp,
 			    struct inet_cork *cork, unsigned int flags);
 
-static inline int ip_queue_xmit(struct sock *sk, struct sk_buff *skb,
-				struct flowi *fl)
-{
-	return __ip_queue_xmit(sk, skb, fl, inet_sk(sk)->tos);
-}
+int ip_queue_xmit(struct sock *sk, struct sk_buff *skb, struct flowi *fl);
 
 static inline struct sk_buff *ip_finish_skb(struct sock *sk, struct flowi4 *fl4)
 {
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 4de9485f73d97d0b44f1e423bcbc8a3598749adc..e5d7e0b099245cf245a5f1c994d164a9fff66124 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -25,6 +25,7 @@
 #include <linux/skbuff.h>
 #include <linux/kref.h>
 #include <linux/ktime.h>
+#include <linux/indirect_call_wrapper.h>
 
 #include <net/inet_connection_sock.h>
 #include <net/inet_timewait_sock.h>
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 090d3097ee15baa87695c530278761fb26534ad5..d946356187eddfb0f81a2f632ee863fafad5f89c 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -539,6 +539,12 @@ int __ip_queue_xmit(struct sock *sk, struct sk_buff *skb, struct flowi *fl,
 }
 EXPORT_SYMBOL(__ip_queue_xmit);
 
+int ip_queue_xmit(struct sock *sk, struct sk_buff *skb, struct flowi *fl)
+{
+	return __ip_queue_xmit(sk, skb, fl, inet_sk(sk)->tos);
+}
+EXPORT_SYMBOL(ip_queue_xmit);
+
 static void ip_copy_metadata(struct sk_buff *to, struct sk_buff *from)
 {
 	to->pkt_type = from->pkt_type;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index a50e1990a845a258d4cc6a2a989d09068ea3a973..be1bd37185d82e5827dfc5105ae74cd815ba1877 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1064,6 +1064,9 @@ static void tcp_update_skb_after_send(struct sock *sk, struct sk_buff *skb,
 	list_move_tail(&skb->tcp_tsorted_anchor, &tp->tsorted_sent_queue);
 }
 
+INDIRECT_CALLABLE_DECLARE(int ip_queue_xmit(struct sock *sk, struct sk_buff *skb, struct flowi *fl));
+INDIRECT_CALLABLE_DECLARE(int inet6_csk_xmit(struct sock *sk, struct sk_buff *skb, struct flowi *fl));
+
 /* This routine actually transmits TCP packets queued in by
  * tcp_do_sendmsg().  This is used by both the initial
  * transmission and possible later retransmissions.
@@ -1235,7 +1238,9 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 
 	tcp_add_tx_delay(skb, tp);
 
-	err = icsk->icsk_af_ops->queue_xmit(sk, skb, &inet->cork.fl);
+	err = INDIRECT_CALL_INET(icsk->icsk_af_ops->queue_xmit,
+				 inet6_csk_xmit, ip_queue_xmit,
+				 sk, skb, &inet->cork.fl);
 
 	if (unlikely(err > 0)) {
 		tcp_enter_cwr(sk);
-- 
2.27.0.111.gc72c7da667-goog

