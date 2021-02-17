Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9DB31DED4
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 19:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbhBQSJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 13:09:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233050AbhBQSJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 13:09:07 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2514C06178A
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 10:08:25 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id p21so3319413pgl.12
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 10:08:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bNo72LUMDna5zhFukHr7znkipTWgQyuQ1sN47ZJAVmA=;
        b=gAMDv0rI0i9jFX3QGbU9ouhiPpGYLLCmDJHeq+ZO70kSgtvylm9U8SuixrwgQ22vGA
         8Y8/vQ9pJVxfRHWjzwHQdPGnO96TNEX0RiZKuthn62I9cq60rbQ+xloT+hJ3qKEu9i8a
         XwPgXDbQq7H75UKpxdOlM/DKG7rj+oliAKA7fsxTInYKC3JIsHYg9ytzYQdCUjt5HBX4
         /nqdYcQYMf/GZgSFaGOV6WrqXuxPL1CN30jbcIf745yg2LtxArfpz4HC1f2I/w8vg7l/
         S3wihItXFXoMCsyenH1yqKnJA4xBbq/hFfM805ZZPgi2b41zkigbZfSYosfEpBDyern2
         l1zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bNo72LUMDna5zhFukHr7znkipTWgQyuQ1sN47ZJAVmA=;
        b=jk71RIPmdyfchboMpzZTjvwKw1wHG9tsYHTtYoYsU20uJWBjSC8DlCL7ViY+cf3ioL
         fNoB+zqhAr2Rk7Qsje/Slde35janzJ6eNUsVMcM0Wyor8vdphRKw21ECdN5uwflfWP1x
         nEC3MVCx53gEQ+IlL/cAPHeHyKTwyJXa3sYVfVrMBkr/G3pnwhvdZ2+Z6B9jXPfHIA9v
         GweLn1tSQqejs7ciXDPuNQVw4M+8CNySiGdN5Vr+P13FmEWtz+ruy/FsdB0lmZ+stuyA
         f6Fe8LwjSKpUGmBLTPlfzYk+UDI2PIekMETQdSwSO+ta2yh1vkJs32KbHFJ59g77NesZ
         760Q==
X-Gm-Message-State: AOAM5332Xh4MVfVdpfyP9RJ0x/21HkFWs0bGmu1E10Ec/VH9ynxG8tea
        sHzLu3RYyCUFPuAYkJlBQ/M=
X-Google-Smtp-Source: ABdhPJwDje4odMop+swzmcBx8j+ddUOvgaq723PlC3p+Vb7xtUOWBMtpq9ZN+yJMPX4tj+wq2kiDSQ==
X-Received: by 2002:a63:4504:: with SMTP id s4mr539958pga.184.1613585305376;
        Wed, 17 Feb 2021 10:08:25 -0800 (PST)
Received: from localhost.localdomain (h134-215-166-75.lapior.broadband.dynamic.tds.net. [134.215.166.75])
        by smtp.gmail.com with ESMTPSA id m16sm3219705pfd.203.2021.02.17.10.08.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 10:08:25 -0800 (PST)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH V3 net-next 5/5] icmp: add response to RFC 8335 PROBE messages
Date:   Wed, 17 Feb 2021 10:08:24 -0800
Message-Id: <7bff18c2cffe77b2ea66fd8774a5d0374ff6dd97.1613583620.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1613583620.git.andreas.a.roeseler@gmail.com>
References: <cover.1613583620.git.andreas.a.roeseler@gmail.com>
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
Changes since v1:
 - Reorder variable declarations to follow coding style
 - Switch to functions such as dev_get_by_name and ip_dev_find to lookup
   net devices

Changes since v2:
Suggested by Willem de Brujin <willemdebrujin.kernel@gmail.com>
 - Add verification of incoming messages before looking up netdev
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
 - Include net/addrconf.h library for ipv6_dev_find
---
 net/ipv4/icmp.c | 133 ++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 122 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 396b492c804f..3caca9f2aa07 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -92,6 +92,7 @@
 #include <net/inet_common.h>
 #include <net/ip_fib.h>
 #include <net/l3mdev.h>
+#include <net/addrconf.h>
 
 /*
  *	Build xmit assembly blocks
@@ -970,7 +971,7 @@ static bool icmp_redirect(struct sk_buff *skb)
 }
 
 /*
- *	Handle ICMP_ECHO ("ping") requests.
+ *	Handle ICMP_ECHO ("ping") and ICMP_EXT_ECHO ("PROBE") requests.
  *
  *	RFC 1122: 3.2.2.6 MUST have an echo server that answers ICMP echo
  *		  requests.
@@ -978,26 +979,122 @@ static bool icmp_redirect(struct sk_buff *skb)
  *		  included in the reply.
  *	RFC 1812: 4.3.3.6 SHOULD have a config option for silently ignoring
  *		  echo requests, MUST have default=NOT.
+ *	RFC 8335: 8 MUST have a config option to enable/disable ICMP
+ *		  Extended Echo functionality, MUST be disabled by default
  *	See also WRT handling of options once they are done and working.
  */
 
 static bool icmp_echo(struct sk_buff *skb)
 {
+	struct icmp_ext_echo_iio *iio;
+	struct icmp_ext_hdr *ext_hdr;
+	struct icmp_bxm icmp_param;
+	struct net_device *dev;
 	struct net *net;
+	__u16 ident_len;
+	__u8 status;
+	char *buff;
 
 	net = dev_net(skb_dst(skb)->dev);
-	if (!net->ipv4.sysctl_icmp_echo_ignore_all) {
-		struct icmp_bxm icmp_param;
+	/* should there be an ICMP stat for ignored echos? */
+	if (net->ipv4.sysctl_icmp_echo_ignore_all)
+		return true;
 
-		icmp_param.data.icmph	   = *icmp_hdr(skb);
+	icmp_param.data.icmph		= *icmp_hdr(skb);
+	icmp_param.skb			= skb;
+	icmp_param.offset		= 0;
+	icmp_param.data_len		= skb->len;
+	icmp_param.head_len		= sizeof(struct icmphdr);
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
+	/* We currently only support probing interfaces on the proxy node
+	 * Check to ensure L-bit is set
+	 */
+	if (!(ntohs(icmp_param.data.icmph.un.echo.sequence) & 1))
+		return true;
+
+	/* Clear status bits in reply message */
+	icmp_param.data.icmph.un.echo.sequence &= htons(0xFF00);
+	icmp_param.data.icmph.type = ICMP_EXT_ECHOREPLY;
+	ext_hdr = (struct icmp_ext_hdr *)(icmp_hdr(skb) + 1);
+	iio = (struct icmp_ext_echo_iio *)(ext_hdr + 1);
+	ident_len = ntohs(iio->extobj_hdr.length) - sizeof(iio->extobj_hdr);
+	status = 0;
+	dev = NULL;
+	switch (iio->extobj_hdr.class_type) {
+	case EXT_ECHO_CTYPE_NAME:
+		if (ident_len >= skb->len - sizeof(struct icmphdr) - sizeof(iio->extobj_hdr)) {
+			icmp_param.data.icmph.code = ICMP_EXT_MAL_QUERY;
+			goto send_reply;
+		}
+		buff = kcalloc(ident_len + 1, sizeof(char), GFP_KERNEL);
+		if (!buff)
+			return -ENOMEM;
+		memcpy(buff, &iio->ident.name, ident_len);
+		dev = dev_get_by_name(net, buff);
+		kfree(buff);
+		break;
+	case EXT_ECHO_CTYPE_INDEX:
+		if (ident_len != sizeof(iio->ident.ifIndex)) {
+			icmp_param.data.icmph.code = ICMP_EXT_MAL_QUERY;
+			goto send_reply;
+		}
+		dev = dev_get_by_index(net, ntohl(iio->ident.ifIndex));
+		break;
+	case EXT_ECHO_CTYPE_ADDR:
+		switch (ntohs(iio->ident.addr.ctype3_hdr.afi)) {
+		case EXT_ECHO_AFI_IP:
+			if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) + sizeof(__be32) ||
+			    ident_len != sizeof(iio->ident.addr.ctype3_hdr) + iio->ident.addr.ctype3_hdr.addrlen) {
+				icmp_param.data.icmph.code = ICMP_EXT_MAL_QUERY;
+				goto send_reply;
+			}
+			dev = ip_dev_find(net, iio->ident.addr.ip_addr.ipv4_addr);
+			break;
+		case EXT_ECHO_AFI_IP6:
+			if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) + sizeof(struct in6_addr) ||
+			    ident_len != sizeof(iio->ident.addr.ctype3_hdr) + iio->ident.addr.ctype3_hdr.addrlen) {
+				icmp_param.data.icmph.code = ICMP_EXT_MAL_QUERY;
+				goto send_reply;
+			}
+			dev = ipv6_dev_find(net, &iio->ident.addr.ip_addr.ipv6_addr, dev);
+			if (dev)
+				dev_hold(dev);
+			break;
+		default:
+			icmp_param.data.icmph.code = ICMP_EXT_MAL_QUERY;
+			goto send_reply;
+		}
+		break;
+	default:
+		icmp_param.data.icmph.code = ICMP_EXT_MAL_QUERY;
+		goto send_reply;
+	}
+	if (!dev) {
+		icmp_param.data.icmph.code = ICMP_EXT_NO_IF;
+		goto send_reply;
+	}
+	/* RFC 8335: 3 the last 8 bits of the Extended Echo Reply Message
+	 *  are laid out as follows:
+	 *	+-+-+-+-+-+-+-+-+
+	 *	|State|Res|A|4|6|
+	 *	+-+-+-+-+-+-+-+-+
+	 */
+	if (dev->flags & IFF_UP)
+		status |= EXT_ECHOREPLY_ACTIVE;
+	if (dev->ip_ptr->ifa_list)
+		status |= EXT_ECHOREPLY_IPV4;
+	if (!list_empty(&dev->ip6_ptr->addr_list))
+		status |= EXT_ECHOREPLY_IPV6;
+	dev_put(dev);
+	icmp_param.data.icmph.un.echo.sequence |= htons(status);
+
+send_reply:
+	icmp_reply(&icmp_param, skb);
 	return true;
 }
 
@@ -1087,6 +1184,13 @@ int icmp_rcv(struct sk_buff *skb)
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
@@ -1096,7 +1200,6 @@ int icmp_rcv(struct sk_buff *skb)
 	if (icmph->type > NR_ICMP_TYPES)
 		goto error;
 
-
 	/*
 	 *	Parse the ICMP message
 	 */
@@ -1123,6 +1226,7 @@ int icmp_rcv(struct sk_buff *skb)
 
 	success = icmp_pointers[icmph->type].handler(skb);
 
+success_check:
 	if (success)  {
 		consume_skb(skb);
 		return NET_RX_SUCCESS;
@@ -1136,6 +1240,13 @@ int icmp_rcv(struct sk_buff *skb)
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

