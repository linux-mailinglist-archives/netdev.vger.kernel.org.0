Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1397B20D6C2
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732175AbgF2TXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732284AbgF2TWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:22:44 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB7D8C030F3D
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 09:57:36 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id z63so15861015qkb.8
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 09:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zua9p6Y8ptDjEDVl0wCUlNSRqfWmZgjoeLnZXsrGlA0=;
        b=mLRuR1oSNtRYeUEVPQyWMVJoUuYYyVPtSnvFwhRBy2VQK4IoeaSIevWFHlxOGbwoM3
         2jaidbLYpL11SmqJSxTQYhaIYOB9IUUr0qau8MlcY6zORXGgXz+lfzXoMpOLY/8xojie
         wv9eEl2B+2yuhmzZibgtEbCdiVMqUuiQzQG00RsM4++rVZ9tgaq6z6qbs7Hw6XY/XFDn
         wpUYTwEYFTGhSqtt9XoqAp5r2KNUv69vpiUpJ1MfWY9hpAzfINrnvRLImiLyvZSVjFkj
         TgEx4OeWxsUUHm0ucFjqjEjF9iiEAkKQ1id+nIJLwAZAi3Vd3/Zr0UL8Z4q8s7e03yTp
         R0hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zua9p6Y8ptDjEDVl0wCUlNSRqfWmZgjoeLnZXsrGlA0=;
        b=mRM+K9T3gaQoS9rk6/KQWZ6jeTd67ZVtdbn2Y2hlTttZlMjUaVbqxvswZl1dN840iT
         ze15qPAN0CutuDd10JSSgMgI8lxqIwX17ePV4u+zlgw8ZxliLxkyIAsntW4yLpuYgM2Y
         6djKqdDSAZWoAu89dN7g6834aTT4NIuD+VdzAglZ37Qgmox4HSLx3l8Iub0Y1QL1QeoV
         xigAccRfmgRyaVphey2xgjUN8H3Zs0ddBtinNASMTJs6q4iE6PXvBFqKra6buZAUgBa3
         CJNmqNQsv5PHgUZMFa3N+bVrFaXoQGq6FufPFtopZEhQTGOskpAwZBjXV+Oc9/P6p3zg
         5RAw==
X-Gm-Message-State: AOAM5313e39kYbGVE7mgH6InVcA0Zz5dsRlht9RwESB5v3iuwkSErxW4
        LII1wsnPq/UT1cGuWNU6Vt/GMTM/
X-Google-Smtp-Source: ABdhPJzLAQ4eAQIyp5POJg6BUJRjAVzqz73c19QGic4Wqgw6THdv/eXnlwQm+ucYx2VZaziDHtQm/A==
X-Received: by 2002:a05:620a:81c:: with SMTP id s28mr15111053qks.133.1593449855056;
        Mon, 29 Jun 2020 09:57:35 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:8798:f98:652b:63f1])
        by smtp.gmail.com with ESMTPSA id g41sm297370qtb.37.2020.06.29.09.57.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 09:57:34 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next] icmp: support rfc 4884
Date:   Mon, 29 Jun 2020 12:57:31 -0400
Message-Id: <20200629165731.1553050-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

ICMP messages may include an extension structure after the original
datagram. RFC 4884 standardized this behavior.

It introduces an explicit original datagram length field in the ICMP
header to delineate the original datagram from the extension struct.

Return this field when reading an ICMP error from the error queue.

ICMPv6 by default already returns the entire 32-bit part of the header
that includes this field by default. For consistency, do the exact
same for ICMP. So far it only returns mtu on ICMP_FRAG_NEEDED and gw
on ICMP_PARAMETERPROB.

For backwards compatibility, make this optional, set by setsockopt
SOL_IP/IP_RECVERR_RFC4884. For API documentation and feature test, see
https://github.com/wdebruij/kerneltools/blob/master/tests/recv_icmp.c

Alternative implementation to reading from the skb in ip_icmp_error
is to pass the field from icmp_unreach, again analogous to ICMPv6. But
this would require changes to every $proto_err() callback, which for
ICMP_FRAG_NEEDED pass the u32 info arg to a pmtu update function.

Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 include/net/inet_sock.h |  1 +
 include/uapi/linux/in.h |  1 +
 net/ipv4/ip_sockglue.c  | 12 ++++++++++++
 3 files changed, 14 insertions(+)

diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index a7ce00af6c44..a3702d1d4875 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -225,6 +225,7 @@ struct inet_sock {
 				mc_all:1,
 				nodefrag:1;
 	__u8			bind_address_no_port:1,
+				recverr_rfc4884:1,
 				defer_connect:1; /* Indicates that fastopen_connect is set
 						  * and cookie exists so we defer connect
 						  * until first data frame is written
diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
index 8533bf07450f..3d0d8231dc19 100644
--- a/include/uapi/linux/in.h
+++ b/include/uapi/linux/in.h
@@ -123,6 +123,7 @@ struct in_addr {
 #define IP_CHECKSUM	23
 #define IP_BIND_ADDRESS_NO_PORT	24
 #define IP_RECVFRAGSIZE	25
+#define IP_RECVERR_RFC4884	26
 
 /* IP_MTU_DISCOVER values */
 #define IP_PMTUDISC_DONT		0	/* Never send DF frames */
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 84ec3703c909..525140e3947c 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -398,6 +398,9 @@ void ip_icmp_error(struct sock *sk, struct sk_buff *skb, int err,
 	if (!skb)
 		return;
 
+	if (inet_sk(sk)->recverr_rfc4884)
+		info = ntohl(icmp_hdr(skb)->un.gateway);
+
 	serr = SKB_EXT_ERR(skb);
 	serr->ee.ee_errno = err;
 	serr->ee.ee_origin = SO_EE_ORIGIN_ICMP;
@@ -755,6 +758,7 @@ static int do_ip_setsockopt(struct sock *sk, int level,
 	case IP_RECVORIGDSTADDR:
 	case IP_CHECKSUM:
 	case IP_RECVFRAGSIZE:
+	case IP_RECVERR_RFC4884:
 		if (optlen >= sizeof(int)) {
 			if (get_user(val, (int __user *) optval))
 				return -EFAULT;
@@ -914,6 +918,11 @@ static int do_ip_setsockopt(struct sock *sk, int level,
 		if (!val)
 			skb_queue_purge(&sk->sk_error_queue);
 		break;
+	case IP_RECVERR_RFC4884:
+		if (val != 0 && val != 1)
+			goto e_inval;
+		inet->recverr_rfc4884 = val;
+		break;
 	case IP_MULTICAST_TTL:
 		if (sk->sk_type == SOCK_STREAM)
 			goto e_inval;
@@ -1588,6 +1597,9 @@ static int do_ip_getsockopt(struct sock *sk, int level, int optname,
 	case IP_RECVERR:
 		val = inet->recverr;
 		break;
+	case IP_RECVERR_RFC4884:
+		val = inet->recverr_rfc4884;
+		break;
 	case IP_MULTICAST_TTL:
 		val = inet->mc_ttl;
 		break;
-- 
2.27.0.212.ge8ba1cc988-goog

