Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16EA43AE178
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 03:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbhFUBlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 21:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbhFUBlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 21:41:22 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0772DC0617AE;
        Sun, 20 Jun 2021 18:39:05 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id q64so20087418qke.7;
        Sun, 20 Jun 2021 18:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=2qEu6hyygPUG7vZacfx29PScvu6pxHqGQ21VaXwEz+0=;
        b=CPAw2mhx6eYJPr4DDDMq/p7C5cTdfVIw+JJOK3yqZd+zP6CB3IPCghNQb98gDeX9lN
         hBuHIv4No/8NOFFmBr4tk4h/wfWs9uiZC+ll1pHnwPMkbWhXY9DyVkUh09yLghz8kAfr
         XPTezTG2Ky0UOohRxZh0kXpGO5EJvt0796cqJts4lY6yYpGpHPjfDHabUfRt2M8VFx+P
         p1gBCxUad6yVieFKk4PVqTQBKlu3u+7MqnDV1iP+64Zj3x/TONG6dwHebASh+hASKiWO
         F1ZQNnM0YTzC5Sr33wdD3l3N/BV7pNhL0U2WfioWDwda05X0wKwtT4peM0mIBDSqDziN
         5cQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2qEu6hyygPUG7vZacfx29PScvu6pxHqGQ21VaXwEz+0=;
        b=hX5zWoskXqoOVx8/xusb543wPleqpCWkSwHx8+nf7UzExDTwe8uyAQQeTUUGJuFFhw
         i2c3Q7u5N2YSIPXSwZeqvrI2LdSVMJL5Lapt0+pI6ISmhQoHBCwNKmIgaQcGfU2OH9ii
         7WnloTcZkfKdYtQKTjUrckhqabKYZ3Q5nXmAaHiavcp+oEXunM97UYzPz0aznpVC5RWY
         3WCR0OoM9iH70Mll+GDBzDisokLVbRHXGoYtE4Lumh+fFpAUukw1oSQS+2BcjBCPuYhU
         pkXJy4PPDNoHnHJdyxOrK2PsjezrhRd427hyZQpElg+xHAXTTiJaK2Wh+kuyvLKzJnU9
         8bhQ==
X-Gm-Message-State: AOAM532Y3os0nuLPQtXGHP8pR1eQi7AjQKpGeHA8F5ZXQhuiDeAmyx6W
        gUy6/AyHE6TSO1noSqg4yvhiiTZw07rSsA==
X-Google-Smtp-Source: ABdhPJwzznB4M5UdTdaTibeTe6QeM7+6msOFCISEPf1fgAW1ddVTWf/LrWwl2O6knscLfcGw4YzNJQ==
X-Received: by 2002:a37:9e53:: with SMTP id h80mr21049529qke.150.1624239544041;
        Sun, 20 Jun 2021 18:39:04 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id v5sm8917652qkh.39.2021.06.20.18.39.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Jun 2021 18:39:03 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org
Subject: [PATCH net-next 12/14] sctp: extract sctp_v6_err_handle function from sctp_v6_err
Date:   Sun, 20 Jun 2021 21:38:47 -0400
Message-Id: <c04b96f2ed41c099d4f43fb1782e1ef84c41daf3.1624239422.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1624239422.git.lucien.xin@gmail.com>
References: <cover.1624239422.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to extract sctp_v6_err_handle() from sctp_v6_err() to
only handle the icmp err after the sock lookup, and it also makes
the code clearer.

sctp_v6_err_handle() will be used in sctp over udp's err handling
in the following patch.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/ipv6.c | 76 ++++++++++++++++++++++++++-----------------------
 1 file changed, 40 insertions(+), 36 deletions(-)

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 50ed4de18069..6ad422f2d0d0 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -122,50 +122,28 @@ static struct notifier_block sctp_inet6addr_notifier = {
 	.notifier_call = sctp_inet6addr_event,
 };
 
-/* ICMP error handler. */
-static int sctp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
-			u8 type, u8 code, int offset, __be32 info)
+static void sctp_v6_err_handle(struct sctp_transport *t, struct sk_buff *skb,
+			       __u8 type, __u8 code, __u32 info)
 {
-	struct sock *sk;
-	struct sctp_association *asoc;
-	struct sctp_transport *transport;
+	struct sctp_association *asoc = t->asoc;
+	struct sock *sk = asoc->base.sk;
 	struct ipv6_pinfo *np;
-	__u16 saveip, savesctp;
-	int err, ret = 0;
-	struct net *net = dev_net(skb->dev);
-
-	/* Fix up skb to look at the embedded net header. */
-	saveip	 = skb->network_header;
-	savesctp = skb->transport_header;
-	skb_reset_network_header(skb);
-	skb_set_transport_header(skb, offset);
-	sk = sctp_err_lookup(net, AF_INET6, skb, sctp_hdr(skb), &asoc, &transport);
-	/* Put back, the original pointers. */
-	skb->network_header   = saveip;
-	skb->transport_header = savesctp;
-	if (!sk) {
-		__ICMP6_INC_STATS(net, __in6_dev_get(skb->dev), ICMP6_MIB_INERRORS);
-		return -ENOENT;
-	}
-
-	/* Warning:  The sock lock is held.  Remember to call
-	 * sctp_err_finish!
-	 */
+	int err = 0;
 
 	switch (type) {
 	case ICMPV6_PKT_TOOBIG:
 		if (ip6_sk_accept_pmtu(sk))
-			sctp_icmp_frag_needed(sk, asoc, transport, ntohl(info));
-		goto out_unlock;
+			sctp_icmp_frag_needed(sk, asoc, t, info);
+		return;
 	case ICMPV6_PARAMPROB:
 		if (ICMPV6_UNK_NEXTHDR == code) {
-			sctp_icmp_proto_unreachable(sk, asoc, transport);
-			goto out_unlock;
+			sctp_icmp_proto_unreachable(sk, asoc, t);
+			return;
 		}
 		break;
 	case NDISC_REDIRECT:
-		sctp_icmp_redirect(sk, transport, skb);
-		goto out_unlock;
+		sctp_icmp_redirect(sk, t, skb);
+		return;
 	default:
 		break;
 	}
@@ -175,13 +153,39 @@ static int sctp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	if (!sock_owned_by_user(sk) && np->recverr) {
 		sk->sk_err = err;
 		sk->sk_error_report(sk);
-	} else {  /* Only an error on timeout */
+	} else {
 		sk->sk_err_soft = err;
 	}
+}
+
+/* ICMP error handler. */
+static int sctp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
+		       u8 type, u8 code, int offset, __be32 info)
+{
+	struct net *net = dev_net(skb->dev);
+	struct sctp_transport *transport;
+	struct sctp_association *asoc;
+	__u16 saveip, savesctp;
+	struct sock *sk;
+
+	/* Fix up skb to look at the embedded net header. */
+	saveip	 = skb->network_header;
+	savesctp = skb->transport_header;
+	skb_reset_network_header(skb);
+	skb_set_transport_header(skb, offset);
+	sk = sctp_err_lookup(net, AF_INET6, skb, sctp_hdr(skb), &asoc, &transport);
+	/* Put back, the original pointers. */
+	skb->network_header   = saveip;
+	skb->transport_header = savesctp;
+	if (!sk) {
+		__ICMP6_INC_STATS(net, __in6_dev_get(skb->dev), ICMP6_MIB_INERRORS);
+		return -ENOENT;
+	}
 
-out_unlock:
+	sctp_v6_err_handle(transport, skb, type, code, ntohl(info));
 	sctp_err_finish(sk, transport);
-	return ret;
+
+	return 0;
 }
 
 static int sctp_v6_xmit(struct sk_buff *skb, struct sctp_transport *t)
-- 
2.27.0

