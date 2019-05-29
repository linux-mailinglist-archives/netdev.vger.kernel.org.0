Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E795C2DDB6
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 15:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbfE2NIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 09:08:00 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:40414 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726613AbfE2NH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 09:07:59 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07487;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0TSyCu0g_1559135275;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0TSyCu0g_1559135275)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 29 May 2019 21:07:56 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net,
        laoar.shao@gmail.com, songliubraving@fb.com
Subject: [PATCH net-next 2/3] udp: introduce a new tracepoint for udp_queue_rcv_skb
Date:   Wed, 29 May 2019 21:06:56 +0800
Message-Id: <20190529130656.23979-3-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190529130656.23979-1-tonylu@linux.alibaba.com>
References: <20190529130656.23979-1-tonylu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This introduces a new tracepoint trace_udp_queue_rcv, it will trace UDP
packets that are going to be queued on the socket receive queue.

Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
---
 include/trace/events/udp.h | 7 +++++++
 net/ipv4/udp.c             | 1 +
 net/ipv6/udp.c             | 1 +
 3 files changed, 9 insertions(+)

diff --git a/include/trace/events/udp.h b/include/trace/events/udp.h
index f2c26780e2a9..37daea5f7cb1 100644
--- a/include/trace/events/udp.h
+++ b/include/trace/events/udp.h
@@ -108,6 +108,13 @@ DEFINE_EVENT(udp_event_sk_skb, udp_send,
 	TP_ARGS(sk, skb)
 );
 
+DEFINE_EVENT(udp_event_sk_skb, udp_queue_rcv,
+
+	TP_PROTO(const struct sock *sk, const struct sk_buff *skb),
+
+	TP_ARGS(sk, skb)
+);
+
 #endif /* _TRACE_UDP_H */
 
 /* This part must be outside protection */
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 3ff6fea9debe..262d76559bd5 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2238,6 +2238,7 @@ static int udp_unicast_rcv_skb(struct sock *sk, struct sk_buff *skb,
 		skb_checksum_try_convert(skb, IPPROTO_UDP, uh->check,
 					 inet_compute_pseudo);
 
+	trace_udp_queue_rcv(sk, skb);
 	ret = udp_queue_rcv_skb(sk, skb);
 
 	/* a return value > 0 means to resubmit the input, but
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 3a26990d5dc8..49473c5d3c4b 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -842,6 +842,7 @@ static int udp6_unicast_rcv_skb(struct sock *sk, struct sk_buff *skb,
 		skb_checksum_try_convert(skb, IPPROTO_UDP, uh->check,
 					 ip6_compute_pseudo);
 
+	trace_udp_queue_rcv(sk, skb);
 	ret = udpv6_queue_rcv_skb(sk, skb);
 
 	/* a return value > 0 means to resubmit the input */
-- 
2.21.0

