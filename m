Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0621922B171
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 16:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729190AbgGWOeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 10:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728811AbgGWOeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 10:34:09 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF9AC0619E2
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 07:34:09 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id x69so5536414qkb.1
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 07:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5FbJXuBlGDFf/8gdCB0TBOOF2kd8jOfaRnCGlOzRD7I=;
        b=gft6/MA2h29wAMRkbUYJQLthEPRT7d4vHZURBquY3j4YgX4q7bnZmIxsK314R4a9G2
         pnh3ddWTf0U4W9prZ+iIxGoUYEeUobm9JxpOpUx8mboqeRWIUOE29NgEnpWIZkb6RCQk
         cm1/S4RE5CoA8TCFLu9OHD21p5tqYBg9GlKYtBMQusyvlEroz3+FeagR7b3KYyHIyxyZ
         m1MOx4URv3CgqUOkaBtqvwseIHCq9b95BaPJZkr+Md9IaVeBVDifCOaRHmzb1lG0JxQA
         MvR6EWhqdYymkrSDD72WMHw/ZAGl8Hc5Xjyu4YQI31NvAjzHzJD6E8I5ANt+0HbXjO1E
         3J7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5FbJXuBlGDFf/8gdCB0TBOOF2kd8jOfaRnCGlOzRD7I=;
        b=M8WeAp86WAbhGFQmKfDgiSOT+/pTm1FfwhifA9g2TTqLaia3vMg/45yceQtpEACkJz
         iIXuKVZRL3DB59UisdTFjYN3Vk4BNdwJH7jMSYvPL67/uO0OojgCnOLL1vD9YYXvV7hl
         2nMzyd4At0Y/WnOpMohiZkHnd7Z0NEB3p0e/a5z6xG435zTZ6Ss18TAqqfOk3AYhcjm5
         wdz6KQYS759fAt7Kjvu0Td3EVbgg8BplddDGJrFeJSFQ2IDBqPsm/CCebA4YlwAULeLN
         Nd+S5SZNUGGiiliDyNDkXHGYQz/Fyes0QajSGGjMKc8vDrhKEb5rpiiSbolbRLO+uutL
         wRgg==
X-Gm-Message-State: AOAM530YXe6irqVkAmyMpPfbhm9neLsQ2RfevZSe3BmdGzjh3qazUu47
        k/hKOdXsmqQ7IqepSYjsGU2sBXwI
X-Google-Smtp-Source: ABdhPJyonCChK864GV82EYvuxkmZ9+GxDwn6/+beZvtc7wQ5tH0phc72D4MqsbeliDR3Fm5oNAenHw==
X-Received: by 2002:a37:3cd:: with SMTP id 196mr5450672qkd.458.1595514847897;
        Thu, 23 Jul 2020 07:34:07 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:f693:9fff:fef4:3e8a])
        by smtp.gmail.com with ESMTPSA id w27sm2488114qtv.68.2020.07.23.07.34.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 07:34:06 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next 3/3] icmp6: support rfc 4884
Date:   Thu, 23 Jul 2020 10:33:57 -0400
Message-Id: <20200723143357.451069-4-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0.rc0.105.gf9edc3c819-goog
In-Reply-To: <20200723143357.451069-1-willemdebruijn.kernel@gmail.com>
References: <20200723143357.451069-1-willemdebruijn.kernel@gmail.com>
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
index 390bedde21a5..dd1d71e12b61 100644
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
 
+void ipv6_icmp_error_rfc4884(const struct sk_buff *skb,
+			     struct sock_ee_data_rfc4884 *out)
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
2.28.0.rc0.105.gf9edc3c819-goog

