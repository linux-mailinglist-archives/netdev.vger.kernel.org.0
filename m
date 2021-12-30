Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF44E481B26
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 10:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238333AbhL3JdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 04:33:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238250AbhL3JdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 04:33:11 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0FFC06173E;
        Thu, 30 Dec 2021 01:33:11 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id 7so8358813pgn.0;
        Thu, 30 Dec 2021 01:33:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XpmOdo48v0qorMGRdhSjMbUK9NGsQvJ8d68QyMk6C44=;
        b=W4wXqbBhjMsExgMq12VwD9kkaHiiMGAjooi6wH1pc7N6bz3HMwHLSklbyUNiJSu2eM
         KnCdfmmq8KJnJUX2GGNuwrwSSYKqUWhE3EP6f9kJibCu9EaCa1E0IuMD28FGbu2XeSU/
         S2mnDExTRn9GFwRS/QieMnK+bTv8x1/4DBzK1/UcRYpBpAZ+Sq56ssq6oafo6vnoONAM
         mUZyaNGiT0ZJylB8F1Kq43rvS6Ii3sLeEUbbixlc2xwaHOnQSIIA16weQb8Bk8w4qP64
         KSDSWiiowaZg1evwOyEonVeZ3HImV1eTzYwFvQM0Kl9AqYw2lNOzBNOj97TArJj+p3sp
         YSBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XpmOdo48v0qorMGRdhSjMbUK9NGsQvJ8d68QyMk6C44=;
        b=0YVAS8Qo0E8x78CrFfvGKaQL2pPni9o1gijdV87r5WsvWCtc3Jn5iZsDrihOlBq1i7
         35JrHTKFG6Z85u82EqRSz/m41LjtjaLP9sdU0pZpXF7THF84/PS/gSydpbudoY6lNmi5
         0TzS6G81Xv3Df9o/uRmc2bsqdj3nl/PBRUvaEM6Mjrmw3OSvXF4WKR4MXBTncsuQNgiA
         kiHGL6ajN/wS/ztNoq+0H60v6piw94h57VtQz3+uDyDOzbsNYBelm5zpQECO9vCWLXuI
         Qb/wGDE2qnf4DgJpid/gThYy39xxzIhQz5wWgq6MKEXNu/0nonUx6zZ8leTxsFLRagVb
         QiRQ==
X-Gm-Message-State: AOAM532CGCDRU6t/c+l8R6UGJT1CDUllyjl8VHlpKcXQRZjKYKjFAbU5
        /ILlw8AX4lztjEQR5MYZL0Q=
X-Google-Smtp-Source: ABdhPJyaeZtLd+AeE8YLqhMSR+mMGi2UJ9FzTaQLtbdU18hnXXj4L6Eu4Hy+acrk5Qu/AjG73a/uWg==
X-Received: by 2002:a63:575c:: with SMTP id h28mr26513220pgm.171.1640856791070;
        Thu, 30 Dec 2021 01:33:11 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id f4sm23231052pfj.25.2021.12.30.01.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 01:33:10 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     rostedt@goodmis.org, dsahern@kernel.org
Cc:     mingo@redhat.com, davem@davemloft.net, kuba@kernel.org,
        nhorman@tuxdriver.com, edumazet@google.com,
        yoshfuji@linux-ipv6.org, jonathan.lemon@gmail.com, alobakin@pm.me,
        keescook@chromium.org, pabeni@redhat.com, talalahmad@google.com,
        haokexin@gmail.com, imagedong@tencent.com, atenart@kernel.org,
        bigeasy@linutronix.de, weiwan@google.com, arnd@arndb.de,
        vvs@virtuozzo.com, cong.wang@bytedance.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        mengensun@tencent.com, mungerjiang@tencent.com
Subject: [PATCH v2 net-next 2/3] net: skb: use kfree_skb_with_reason() in tcp_v4_rcv()
Date:   Thu, 30 Dec 2021 17:32:39 +0800
Message-Id: <20211230093240.1125937-3-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211230093240.1125937-1-imagedong@tencent.com>
References: <20211230093240.1125937-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

Replace kfree_skb() with kfree_skb_with_reason() in tcp_v4_rcv().
Following drop reason are added:

SKB_DROP_REASON_NO_SOCKET
SKB_DROP_REASON_PKT_TOO_SMALL
SKB_DROP_REASON_TCP_CSUM
SKB_DROP_REASON_TCP_FILTER

After this patch, 'kfree_skb' event will print message like this:

$           TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
$              | |         |   |||||     |         |
          <idle>-0       [000] ..s1.    36.113438: kfree_skb: skbaddr=(____ptrval____) protocol=2048 location=(____ptrval____) reason: NO_SOCKET

The reason of skb drop is printed too.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v2:
- rename some reason name as David suggested
- add the new reason: SKB_DROP_REASON_TCP_FILTER
---
 include/linux/skbuff.h     |  4 ++++
 include/trace/events/skb.h |  4 ++++
 net/ipv4/tcp_ipv4.c        | 14 +++++++++++---
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 3620b3ff2154..43cb3b75b5af 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -313,6 +313,10 @@ struct sk_buff;
  */
 enum skb_drop_reason {
 	SKB_DROP_REASON_NOT_SPECIFIED,
+	SKB_DROP_REASON_NO_SOCKET,
+	SKB_DROP_REASON_PKT_TOO_SMALL,
+	SKB_DROP_REASON_TCP_CSUM,
+	SKB_DROP_REASON_TCP_FILTER,
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index cab1c08a30cd..c6f4ecf6781e 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -11,6 +11,10 @@
 
 #define TRACE_SKB_DROP_REASON					\
 	EM(SKB_DROP_REASON_NOT_SPECIFIED, NOT_SPECIFIED)	\
+	EM(SKB_DROP_REASON_NO_SOCKET, NO_SOCKET)		\
+	EM(SKB_DROP_REASON_PKT_TOO_SMALL, PKT_TOO_SMALL)	\
+	EM(SKB_DROP_REASON_TCP_CSUM, TCP_CSUM)			\
+	EM(SKB_DROP_REASON_TCP_FILTER, TCP_FILTER)		\
 	EMe(SKB_DROP_REASON_MAX, HAHA_MAX)
 
 #undef EM
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index ac10e4cdd8d0..61832949fc93 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1971,8 +1971,10 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	const struct tcphdr *th;
 	bool refcounted;
 	struct sock *sk;
+	int drop_reason;
 	int ret;
 
+	drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	if (skb->pkt_type != PACKET_HOST)
 		goto discard_it;
 
@@ -1984,8 +1986,10 @@ int tcp_v4_rcv(struct sk_buff *skb)
 
 	th = (const struct tcphdr *)skb->data;
 
-	if (unlikely(th->doff < sizeof(struct tcphdr) / 4))
+	if (unlikely(th->doff < sizeof(struct tcphdr) / 4)) {
+		drop_reason = SKB_DROP_REASON_PKT_TOO_SMALL;
 		goto bad_packet;
+	}
 	if (!pskb_may_pull(skb, th->doff * 4))
 		goto discard_it;
 
@@ -2090,8 +2094,10 @@ int tcp_v4_rcv(struct sk_buff *skb)
 
 	nf_reset_ct(skb);
 
-	if (tcp_filter(sk, skb))
+	if (tcp_filter(sk, skb)) {
+		drop_reason = SKB_DROP_REASON_TCP_FILTER;
 		goto discard_and_relse;
+	}
 	th = (const struct tcphdr *)skb->data;
 	iph = ip_hdr(skb);
 	tcp_v4_fill_cb(skb, iph, th);
@@ -2124,6 +2130,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	return ret;
 
 no_tcp_socket:
+	drop_reason = SKB_DROP_REASON_NO_SOCKET;
 	if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb))
 		goto discard_it;
 
@@ -2131,6 +2138,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 
 	if (tcp_checksum_complete(skb)) {
 csum_error:
+		drop_reason = SKB_DROP_REASON_TCP_CSUM;
 		trace_tcp_bad_csum(skb);
 		__TCP_INC_STATS(net, TCP_MIB_CSUMERRORS);
 bad_packet:
@@ -2141,7 +2149,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 
 discard_it:
 	/* Discard frame. */
-	kfree_skb(skb);
+	kfree_skb_with_reason(skb, drop_reason);
 	return 0;
 
 discard_and_relse:
-- 
2.30.2

