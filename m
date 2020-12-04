Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2902CE666
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 04:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbgLDDRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 22:17:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727066AbgLDDRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 22:17:53 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA9DC061A4F
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 19:17:13 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id t37so2676225pga.7
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 19:17:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KhdUb7dyDzVdEjqGLBmV/wGAVdtT552zc8ri2UMvozM=;
        b=Cads377RA/jnwd/YITfFD3QmsMifej4eDF6K+sYpjbXnK8gglkNvscSwVMpyIMc/St
         2j9dvvAZdxa5xrpIl+D0OorAQ9chUhGcerhuyU5c8x9qFGb8ekICGZOKdl0ZrsbgYqg+
         W3hDPMKZqnHxKlc8Hx2q8bwbOibl+mtjQfRh4lnzYdcf7g20ccVu/Rt6sLT6DGNASDc7
         Y6fZVkLmSRe2vmUFd64wPh4599YkW/Z866wn3CQ4zcMCsJs5e3UBCAgfB3kgQleLY0Ka
         RhG5en0OHPM4Cr+qGDyCoYCklOESVf1glITjL38bdUqsEb1uqNt/VPuk5z2ILmjvXLG+
         mlQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KhdUb7dyDzVdEjqGLBmV/wGAVdtT552zc8ri2UMvozM=;
        b=WGfOh6k4VzFnYsKhw1GC/LhkinECCoCKcbUfSeFIgH+QczjdT9+SMnT2ZJ01EumvcI
         jzICd3/J8LDKKbi6ZgG9njWFB9SMTVCx/Cc2v3NWNmCZidxOpi2I5NaXFxcVJtOf6fas
         Tq+UhDl0zi8l/ctzBK5sZeLtRyc8aZ0SwUuNUsI7ninpqV26Rsl6hKevTPZOGR+3DlPZ
         56CENuolqHAIetxOsXTjwpTAQjIzeNqUmW3OKYTWce2yhq0xXSWZs+/dpSYRF0I1knin
         vTDIhwm6vhlGevv1FaakCCYbzPwGMaqcF4R27kbeFcl4isWDKg+oHHGaQZXj9mGu3NDT
         3Bgg==
X-Gm-Message-State: AOAM533aF2h/xuLJ24qHXv2yVDKnk29UAhQmrg4BM/F4iSJxU8BA0iKC
        Nl2Zzdl2v0KqJEmxH9y5Tmw=
X-Google-Smtp-Source: ABdhPJy1WtJuXhpNESK/fwjiD6T6c3g2rwtisrKBwwmv8URurGp6cVUq6fA0Rn2yKuXYXl1uzWmqOw==
X-Received: by 2002:a63:d312:: with SMTP id b18mr5736848pgg.233.1607051832879;
        Thu, 03 Dec 2020 19:17:12 -0800 (PST)
Received: from clinic20-Precision-T3610.hsd1.ca.comcast.net ([2601:648:8400:9ef4:bf20:728e:4c43:a644])
        by smtp.gmail.com with ESMTPSA id h7sm3072153pfr.210.2020.12.03.19.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 19:17:12 -0800 (PST)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 6/6] icmp: add response to RFC 8335 PROBE messages
Date:   Thu,  3 Dec 2020 19:17:11 -0800
Message-Id: <403b12364707f6e579b91927799c505867336bb3.1607050389.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1607050388.git.andreas.a.roeseler@gmail.com>
References: <cover.1607050388.git.andreas.a.roeseler@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify the icmp_rcv function to check for PROBE messages and call
icmp_echo if a PROBE request is detected.

Modify the existing icmp_echo function to respond to both ping and PROBE
requests.

This was tested using a custom modification of the iputils package and
wireshark. It supports IPV4 probing by name, ifindex, and probing by both IPV4 and IPV6
addresses. It currently does not support responding to probes off the proxy node
(See RFC 8335 Section 2). 

Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
---
 net/ipv4/icmp.c | 135 ++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 125 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 005faea415a4..313061b60387 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -984,20 +984,121 @@ static bool icmp_redirect(struct sk_buff *skb)
 static bool icmp_echo(struct sk_buff *skb)
 {
 	struct net *net;
+	struct icmp_bxm icmp_param;
+	struct net_device *dev;
+	struct net_device *target_dev;
+	struct in_ifaddr *ifaddr;
+	struct inet6_ifaddr *inet6_ifaddr;
+	struct list_head *position;
+	struct icmp_extobj_hdr *extobj_hdr;
+	struct icmp_ext_ctype3_hdr *ctype3_hdr;
+	__u8 status;
 
 	net = dev_net(skb_dst(skb)->dev);
-	if (!net->ipv4.sysctl_icmp_echo_ignore_all) {
-		struct icmp_bxm icmp_param;
+	/* should there be an ICMP stat for ignored echos? */
+	if (net->ipv4.sysctl_icmp_echo_ignore_all)
+		return true;
+
+	icmp_param.data.icmph		= *icmp_hdr(skb);
+	icmp_param.skb			= skb;
+	icmp_param.offset		= 0;
+	icmp_param.data_len		= skb->len;
+	icmp_param.head_len		= sizeof(struct icmphdr);
 
-		icmp_param.data.icmph	   = *icmp_hdr(skb);
+	if (icmp_param.data.icmph.type == ICMP_ECHO) {
 		icmp_param.data.icmph.type = ICMP_ECHOREPLY;
-		icmp_param.skb		   = skb;
-		icmp_param.offset	   = 0;
-		icmp_param.data_len	   = skb->len;
-		icmp_param.head_len	   = sizeof(struct icmphdr);
-		icmp_reply(&icmp_param, skb);
+		goto send_reply;
 	}
-	/* should there be an ICMP stat for ignored echos? */
+	if (!net->ipv4.sysctl_icmp_echo_enable_probe)
+		return true;
+	/* We currently do not support probing off the proxy node */
+	if ((ntohs(icmp_param.data.icmph.un.echo.sequence) & 1) == 0)
+		return true;
+
+	icmp_param.data.icmph.type = ICMP_EXT_ECHOREPLY;
+	icmp_param.data.icmph.un.echo.sequence &= htons(0xFF00);
+	extobj_hdr = (struct icmp_extobj_hdr *)(skb->data + sizeof(struct icmp_ext_hdr));
+	ctype3_hdr = (struct icmp_ext_ctype3_hdr *)(extobj_hdr + 1);
+	status = 0;
+	target_dev = NULL;
+	read_lock(&dev_base_lock);
+	for_each_netdev(net, dev) {
+		switch (extobj_hdr->class_type) {
+		case CTYPE_NAME:
+			if (strcmp(dev->name, (char *)(extobj_hdr + 1)) == 0)
+				goto found_matching_interface;
+			break;
+		case CTYPE_INDEX:
+			if (ntohl(*((uint32_t *)(extobj_hdr + 1))) ==
+				dev->ifindex)
+				goto found_matching_interface;
+			break;
+		case CTYPE_ADDR:
+			switch (ntohs(ctype3_hdr->afi)) {
+			/* IPV4 address */
+			case 1:
+				ifaddr = dev->ip_ptr->ifa_list;
+				while (ifaddr) {
+					if (memcmp(&ifaddr->ifa_address,
+						   (ctype3_hdr + 1),
+						   sizeof(ifaddr->ifa_address)) == 0)
+						goto found_matching_interface;
+					ifaddr = ifaddr->ifa_next;
+				}
+				break;
+			/* IPV6 address */
+			case 2:
+				list_for_each(position,
+					      &dev->ip6_ptr->addr_list) {
+					inet6_ifaddr = list_entry(position,
+								  struct inet6_ifaddr,
+								  if_list);
+					if (memcmp(&inet6_ifaddr->addr.in6_u,
+						   (ctype3_hdr + 1),
+						   sizeof(inet6_ifaddr->addr.in6_u)) == 0)
+						goto found_matching_interface;
+				}
+				break;
+			default:
+				icmp_param.data.icmph.code = ICMP_EXT_MAL_QUERY;
+				goto unlock_dev;
+			}
+			break;
+		default:
+			icmp_param.data.icmph.code = ICMP_EXT_MAL_QUERY;
+			goto unlock_dev;
+		}
+		continue;
+found_matching_interface:
+		if (target_dev) {
+			icmp_param.data.icmph.code = ICMP_EXT_MULT_IFS;
+			goto unlock_dev;
+		}
+		target_dev = dev;
+	}
+	if (!target_dev) {
+		icmp_param.data.icmph.code = ICMP_EXT_NO_IF;
+		goto unlock_dev;
+	}
+
+	/* RFC 8335: 3 the last 8 bits of the Extended Echo Reply Message
+	 *  are laid out as follows:
+	 *	+-+-+-+-+-+-+-+-+
+	 *	|State|Res|A|4|6|
+	 *	+-+-+-+-+-+-+-+-+
+	 */
+	if (target_dev->flags & IFF_UP)
+		status |= EXT_ECHOREPLY_ACTIVE;
+	if (target_dev->ip_ptr->ifa_list)
+		status |= EXT_ECHOREPLY_IPV4;
+	if (!list_empty(&target_dev->ip6_ptr->addr_list))
+		status |= EXT_ECHOREPLY_IPV6;
+
+	icmp_param.data.icmph.un.echo.sequence |= htons(status);
+unlock_dev:
+	read_unlock(&dev_base_lock);
+send_reply:
+	icmp_reply(&icmp_param, skb);
 	return true;
 }
 
@@ -1087,6 +1188,13 @@ int icmp_rcv(struct sk_buff *skb)
 	icmph = icmp_hdr(skb);
 
 	ICMPMSGIN_INC_STATS(net, icmph->type);
+
+	/*
+	 *	Check for ICMP Extended Echo (PROBE) messages
+	 */
+	if (icmph->type == ICMP_EXT_ECHO || icmph->type == ICMPV6_EXT_ECHO_REQUEST)
+		goto probe;
+
 	/*
 	 *	18 is the highest 'known' ICMP type. Anything else is a mystery
 	 *
@@ -1096,7 +1204,6 @@ int icmp_rcv(struct sk_buff *skb)
 	if (icmph->type > NR_ICMP_TYPES)
 		goto error;
 
-
 	/*
 	 *	Parse the ICMP message
 	 */
@@ -1123,6 +1230,7 @@ int icmp_rcv(struct sk_buff *skb)
 
 	success = icmp_pointers[icmph->type].handler(skb);
 
+success_check:
 	if (success)  {
 		consume_skb(skb);
 		return NET_RX_SUCCESS;
@@ -1136,6 +1244,13 @@ int icmp_rcv(struct sk_buff *skb)
 error:
 	__ICMP_INC_STATS(net, ICMP_MIB_INERRORS);
 	goto drop;
+probe:
+	/*
+	 * We can't use icmp_pointers[].handler() because the codes for PROBE
+	 *   messages are 42 or 160
+	 */
+	success = icmp_echo(skb);
+	goto success_check;
 }
 
 static bool ip_icmp_error_rfc4884_validate(const struct sk_buff *skb, int off)
-- 
2.25.1

