Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9793F22C5B3
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 15:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgGXNDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 09:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726639AbgGXNDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 09:03:18 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97117C0619E4
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 06:03:17 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id 6so6826698qtt.0
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 06:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t2D5tFAe1EvVc0g4ejtRj5fsh0GI3qxPsqhzIujMvfk=;
        b=Ar1CsVvRH/vhSP0xlXr1iBFKQGwbYQbpUUc8/SfwLnegjIe6p84BGRNgjOQfMitgdz
         A1ergQsdkgupl5e83/q7X0srmzK2ZuuORuW1ym6IR30LqAbGJpxG8KgssjnqIM6p7RgG
         I8rZ1jw+thtY4CDo8LuQEtFix9ByibKUqbWq9vz3ZL2e7H4cmKaaRLaJbmXJI10q9M5W
         EONUiU6pmeZRrrt4pMeg61on+I4SQRuCFxySjZtG+DPevaLnZ7YQSygkVDwub/Osrzla
         lmZgESSE1065LvveviqkX3oC/jHWSW6S+dfDSp+xxhZpnQiuohIlwKNjnVvMBxOJReiE
         joFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t2D5tFAe1EvVc0g4ejtRj5fsh0GI3qxPsqhzIujMvfk=;
        b=U+My/2YTIZjGPRJ3ZpcBzwEikXwOaL135eV8wRrU2i/g9kH4DbyeYssMiWTFjhsDV3
         oVGcGygS26NWH+iZcoMCyXaJP+cpIiZPsMIEK7DbZfdPGKqSvHnF3TAYz1bCC7i0ElbK
         iDdFZe24ppi1rKNdlfnuwHxhVtfiu1pGyQGWlalruNa+Og65KSYNPEqKqQUh3sUbyCMR
         FC8GdT3ehkpRmFaFHEO2fStNbWV7Eabd9NEhzmfJpu4CIqeqVAy1WgKHU6758/y/nM7B
         MTV3e/XYkvzpLsIrQCtILiKLKHT7unuClVWtJCYQ5v3uN9fitvExW+7dyiXN1pXGAgvR
         81Kw==
X-Gm-Message-State: AOAM533D1HKZQP0cQVolvWlkGsD0lwvisoqvzksmC+r0uf5Z/RzXDR2r
        N63CqqfkP5uBF0UwbsV1VdU+J4g9
X-Google-Smtp-Source: ABdhPJyeikv/TvCABQ/1uquskioFc9WTIIWVRzOmCjUptblWhXoKnD+U+UEZho2s4NAF1dl1EZjX7Q==
X-Received: by 2002:ac8:3fcf:: with SMTP id v15mr9469375qtk.274.1595595796473;
        Fri, 24 Jul 2020 06:03:16 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:f693:9fff:fef4:3e8a])
        by smtp.gmail.com with ESMTPSA id b8sm1203491qtg.45.2020.07.24.06.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 06:03:15 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next v2 3/3] icmp6: support rfc 4884
Date:   Fri, 24 Jul 2020 09:03:10 -0400
Message-Id: <20200724130310.788305-4-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
In-Reply-To: <20200724130310.788305-1-willemdebruijn.kernel@gmail.com>
References: <20200724130310.788305-1-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Extend the rfc 4884 read interface introduced for ipv4 in
commit eba75c587e81 ("icmp: support rfc 4884") to ipv6.

Add socket option SOL_IPV6/IPV6_RECVERR_RFC4884.

Changes v1->v2:
  - make ipv6_icmp_error_rfc4884 static (file scope)

Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 include/linux/ipv6.h        |  1 +
 include/uapi/linux/icmpv6.h |  1 +
 include/uapi/linux/in6.h    |  1 +
 net/ipv4/icmp.c             |  1 +
 net/ipv6/datagram.c         | 16 ++++++++++++++++
 net/ipv6/ipv6_sockglue.c    | 12 ++++++++++++
 6 files changed, 32 insertions(+)

diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index 8d8f877e7f81..a44789d027cc 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -283,6 +283,7 @@ struct ipv6_pinfo {
 				autoflowlabel:1,
 				autoflowlabel_set:1,
 				mc_all:1,
+				recverr_rfc4884:1,
 				rtalert_isolate:1;
 	__u8			min_hopcount;
 	__u8			tclass;
diff --git a/include/uapi/linux/icmpv6.h b/include/uapi/linux/icmpv6.h
index 2622b5a3e616..c1661febc2dc 100644
--- a/include/uapi/linux/icmpv6.h
+++ b/include/uapi/linux/icmpv6.h
@@ -68,6 +68,7 @@ struct icmp6hdr {
 #define icmp6_mtu		icmp6_dataun.un_data32[0]
 #define icmp6_unused		icmp6_dataun.un_data32[0]
 #define icmp6_maxdelay		icmp6_dataun.un_data16[0]
+#define icmp6_datagram_len	icmp6_dataun.un_data8[0]
 #define icmp6_router		icmp6_dataun.u_nd_advt.router
 #define icmp6_solicited		icmp6_dataun.u_nd_advt.solicited
 #define icmp6_override		icmp6_dataun.u_nd_advt.override
diff --git a/include/uapi/linux/in6.h b/include/uapi/linux/in6.h
index 9f2273a08356..5ad396a57eb3 100644
--- a/include/uapi/linux/in6.h
+++ b/include/uapi/linux/in6.h
@@ -179,6 +179,7 @@ struct in6_flowlabel_req {
 #define IPV6_LEAVE_ANYCAST	28
 #define IPV6_MULTICAST_ALL	29
 #define IPV6_ROUTER_ALERT_ISOLATE	30
+#define IPV6_RECVERR_RFC4884	31
 
 /* IPV6_MTU_DISCOVER values */
 #define IPV6_PMTUDISC_DONT		0
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 1e70e98f14f8..1155b6ad7a3b 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -1208,6 +1208,7 @@ void ip_icmp_error_rfc4884(const struct sk_buff *skb,
 	if (!ip_icmp_error_rfc4884_validate(skb, off))
 		out->flags |= SO_EE_RFC4884_FLAG_INVALID;
 }
+EXPORT_SYMBOL_GPL(ip_icmp_error_rfc4884);
 
 int icmp_err(struct sk_buff *skb, u32 info)
 {
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index 390bedde21a5..cc8ad7ddecda 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -19,6 +19,7 @@
 #include <linux/route.h>
 #include <linux/slab.h>
 #include <linux/export.h>
+#include <linux/icmp.h>
 
 #include <net/ipv6.h>
 #include <net/ndisc.h>
@@ -284,6 +285,17 @@ int ip6_datagram_connect_v6_only(struct sock *sk, struct sockaddr *uaddr,
 }
 EXPORT_SYMBOL_GPL(ip6_datagram_connect_v6_only);
 
+static void ipv6_icmp_error_rfc4884(const struct sk_buff *skb,
+				    struct sock_ee_data_rfc4884 *out)
+{
+	switch (icmp6_hdr(skb)->icmp6_type) {
+	case ICMPV6_TIME_EXCEED:
+	case ICMPV6_DEST_UNREACH:
+		ip_icmp_error_rfc4884(skb, out, sizeof(struct icmp6hdr),
+				      icmp6_hdr(skb)->icmp6_datagram_len * 8);
+	}
+}
+
 void ipv6_icmp_error(struct sock *sk, struct sk_buff *skb, int err,
 		     __be16 port, u32 info, u8 *payload)
 {
@@ -313,6 +325,10 @@ void ipv6_icmp_error(struct sock *sk, struct sk_buff *skb, int err,
 	serr->port = port;
 
 	__skb_pull(skb, payload - skb->data);
+
+	if (inet6_sk(sk)->recverr_rfc4884)
+		ipv6_icmp_error_rfc4884(skb, &serr->ee.ee_rfc4884);
+
 	skb_reset_transport_header(skb);
 
 	if (sock_queue_err_skb(sk, skb))
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index add8f7912299..d4140a23974f 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -964,6 +964,14 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 		np->rxopt.bits.recvfragsize = valbool;
 		retv = 0;
 		break;
+	case IPV6_RECVERR_RFC4884:
+		if (optlen < sizeof(int))
+			goto e_inval;
+		if (val < 0 || val > 1)
+			goto e_inval;
+		np->recverr_rfc4884 = valbool;
+		retv = 0;
+		break;
 	}
 
 	release_sock(sk);
@@ -1438,6 +1446,10 @@ static int do_ipv6_getsockopt(struct sock *sk, int level, int optname,
 		val = np->rtalert_isolate;
 		break;
 
+	case IPV6_RECVERR_RFC4884:
+		val = np->recverr_rfc4884;
+		break;
+
 	default:
 		return -ENOPROTOOPT;
 	}
-- 
2.28.0.rc0.142.g3c755180ce-goog

