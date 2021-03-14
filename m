Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA3633A6FA
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 17:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234296AbhCNQtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 12:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234617AbhCNQsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 12:48:52 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E482C061574
        for <netdev@vger.kernel.org>; Sun, 14 Mar 2021 09:48:52 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id s21so7536676pjq.1
        for <netdev@vger.kernel.org>; Sun, 14 Mar 2021 09:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=p6WA719uKFNZHnzSkMAhwon+xZDnLUjzBF/lM1eFaGc=;
        b=Kkxk66iNRHCJ+ZxMy3tdvHpFDrg1yDVykFnSc5/eA/AV1lIxF69CJkJYpgkopcwNsx
         F8T1hZhcDFU4ysytSOhhrcyFwvfgmB0CXkryu5hKnsaXsE4DOhgwgAK0sqRM/T3IrR/R
         M3RKe38GzpdapPhrNOS6RdvhdKrp2iL+uLFMBwiVB3e4AN00AKm3GqpO2isN1fKxwtLj
         MjbYuOBHOrAnBJXRQg8dyivRVgmBxBP69/qMTsGUHNGreJwMYZS2rsFR++akqfN+JPkd
         GY3vSNCDVnMozUKMKffme8+MdYwtJpggSWKTu1Gv7YlISluEIAyLuYTOkZciJB0Rye4F
         vTWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=p6WA719uKFNZHnzSkMAhwon+xZDnLUjzBF/lM1eFaGc=;
        b=pdj1VcKwAPrtE/CVqQFsrThCMzZkrQyJUFDYPKI/0PN8T5luP5lC5/Gy67BiDNVdWb
         ncHmTimcWYXP4eI+hpPhCA7WWbiKR7S0OMmrlU3MRo28ggQJ5yEnnHxno6B22nIzgF/q
         FTV+oJ3DqzSRcCS2SLRlYWkXPxGToRuypKqDryIR0gpj7L04mN12bh4F/Lxj88X9Sw5Q
         Gf/7OTLZlc6MoH0H9ydi80ATF1olPdLWhQOEVSo/8oGSX1OP61jthOCtE7IgwHHGRg4+
         tclvcqit3L7wmodZj38DwgRggepxjvrS8wQWp2Ip5xuHNsHxf/1+aIBCoVMy74D9oe9t
         oq3Q==
X-Gm-Message-State: AOAM530K1MuH3jZ/dxkNBSKoPsHCKxYtvmRlNSBHtkRqzx7Vbp2D59fv
        6a4dK4uTRaKTj52F+AmxmCCIwLv623U=
X-Google-Smtp-Source: ABdhPJzNh7zxINr1CBSD+DksLG2bODMV9mz/hg14F5m1zvLR7h6bBFwc8xOxjrHk4d/SiLwLL7mYiQ==
X-Received: by 2002:a17:902:bd4b:b029:e6:a4a1:9d8b with SMTP id b11-20020a170902bd4bb02900e6a4a19d8bmr5033692plx.56.1615740531725;
        Sun, 14 Mar 2021 09:48:51 -0700 (PDT)
Received: from clinic20-Precision-T3610.hsd1.ut.comcast.net ([2601:681:8800:baf9:ed7e:5608:ecd4:c342])
        by smtp.googlemail.com with ESMTPSA id mp19sm18752093pjb.2.2021.03.14.09.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 09:48:51 -0700 (PDT)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org,
        Andreas Roeseler <andreas.a.roeseler@gmail.com>
Subject: [PATCH V4 net-next 5/5] icmp: add response to RFC 8335 PROBE messages
Date:   Sun, 14 Mar 2021 09:48:49 -0700
Message-Id: <a30d45c43a24f7b65febe51929e6fe990a904805.1615738432.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1615738431.git.andreas.a.roeseler@gmail.com>
References: <cover.1615738431.git.andreas.a.roeseler@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify the icmp_rcv function to check PROBE messages and call icmp_echo
if a PROBE request is detected.

Modify the existing icmp_echo function to respond ot both ping and PROBE
requests.

This was tested using a custom modification to the iputils package and
wireshark. It supports IPV4 probing by name, ifindex, and probing by
both IPV4 and IPV6 addresses. It currently does not support responding
to probes off the proxy node (see RFC 8335 Section 2).

Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
---
Changes:
v1 -> v2:
 - Reorder variable declarations to follow coding style
 - Switch to functions such as dev_get_by_name and ip_dev_find to lookup
   net devices

v2 -> v3:
Suggested by Willem de Bruijn <willemdebruijn.kernel@gmail.com>
 - Add verification of incoming messages before looking up netdev
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
 - Include net/addrconf.h library for ipv6_dev_find

v3 -> v4:
Suggested by Willem de Bruijn <willemdebruijn.kernel@gmail.com>
 - Use skb_header_pointer to verify fields in incoming message
 - Add check to ensure that extobj_hdr.length is valid
 - Check to ensure object payload is padded with ASCII NULL characters
   when probing by name, as specified by RFC 8335
 - Statically allocate buff using IFNAMSIZ
 - Add rcu blocking around ipv6_dev_find
 - Use __in_dev_get_rcu to access IPV4 addresses of identified
   net_device
 - Remove check for ICMPV6 PROBE types
---
 net/ipv4/icmp.c | 145 +++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 130 insertions(+), 15 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 616e2dc1c8fa..f1530011b7bc 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -93,6 +93,10 @@
 #include <net/ip_fib.h>
 #include <net/l3mdev.h>
 
+#if IS_ENABLED(CONFIG_IPV6)
+#include <net/addrconf.h>
+#endif
+
 /*
  *	Build xmit assembly blocks
  */
@@ -971,7 +975,7 @@ static bool icmp_redirect(struct sk_buff *skb)
 }
 
 /*
- *	Handle ICMP_ECHO ("ping") requests.
+ *	Handle ICMP_ECHO ("ping") and ICMP_EXT_ECHO ("PROBE") requests.
  *
  *	RFC 1122: 3.2.2.6 MUST have an echo server that answers ICMP echo
  *		  requests.
@@ -979,27 +983,127 @@ static bool icmp_redirect(struct sk_buff *skb)
  *		  included in the reply.
  *	RFC 1812: 4.3.3.6 SHOULD have a config option for silently ignoring
  *		  echo requests, MUST have default=NOT.
+ *	RFC 8335: 8 MUST have a config option to enable/disable ICMP
+ *		  Extended Echo Functionality, MUST be disabled by default
  *	See also WRT handling of options once they are done and working.
  */
 
 static bool icmp_echo(struct sk_buff *skb)
 {
+	struct icmp_ext_hdr *ext_hdr, _ext_hdr;
+	struct icmp_ext_echo_iio *iio, _iio;
+	struct icmp_bxm icmp_param;
+	struct net_device *dev;
 	struct net *net;
+	u16 ident_len;
+	char *buff;
+	u8 status;
 
 	net = dev_net(skb_dst(skb)->dev);
-	if (!net->ipv4.sysctl_icmp_echo_ignore_all) {
-		struct icmp_bxm icmp_param;
-
-		icmp_param.data.icmph	   = *icmp_hdr(skb);
-		icmp_param.data.icmph.type = ICMP_ECHOREPLY;
-		icmp_param.skb		   = skb;
-		icmp_param.offset	   = 0;
-		icmp_param.data_len	   = skb->len;
-		icmp_param.head_len	   = sizeof(struct icmphdr);
-		icmp_reply(&icmp_param, skb);
-	}
 	/* should there be an ICMP stat for ignored echos? */
-	return true;
+	if (net->ipv4.sysctl_icmp_echo_ignore_all)
+		return true;
+
+	icmp_param.data.icmph	   = *icmp_hdr(skb);
+	icmp_param.skb		   = skb;
+	icmp_param.offset	   = 0;
+	icmp_param.data_len	   = skb->len;
+	icmp_param.head_len	   = sizeof(struct icmphdr);
+
+	if (icmp_param.data.icmph.type == ICMP_ECHO)
+		goto send_reply;
+	if (!net->ipv4.sysctl_icmp_echo_enable_probe)
+		return true;
+	/* We currently only support probing interfaces on the proxy node
+	 * Check to ensure L-bit is set
+	 */
+	if (!(ntohs(icmp_param.data.icmph.un.echo.sequence) & 1))
+		return true;
+	/* Clear status bits in reply message */
+	icmp_param.data.icmph.un.echo.sequence &= htons(0xFF00);
+	icmp_param.data.icmph.type = ICMP_EXT_ECHOREPLY;
+	ext_hdr = skb_header_pointer(skb, 0, sizeof(_ext_hdr), &_ext_hdr);
+	iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(_iio), &_iio);
+	if (!ext_hdr || !iio)
+		goto send_mal_query;
+	if (ntohs(iio->extobj_hdr.length) <= sizeof(iio->extobj_hdr))
+		goto send_mal_query;
+	ident_len = ntohs(iio->extobj_hdr.length) - sizeof(iio->extobj_hdr);
+	status = 0;
+	dev = NULL;
+	switch (iio->extobj_hdr.class_type) {
+	case EXT_ECHO_CTYPE_NAME:
+		if (ident_len >= IFNAMSIZ)
+			goto send_mal_query;
+		buff = kcalloc(IFNAMSIZ, sizeof(char), GFP_KERNEL);
+		if (!buff)
+			return -ENOMEM;
+		memcpy(buff, &iio->ident.name, ident_len);
+		/* RFC 8335 2.1 If the Object Payload would not otherwise terminate
+		 * on a 32-bit boundary, it MUST be padded with ASCII NULL characters
+		 */
+		if (ident_len % sizeof(u32) != 0) {
+			u8 i;
+
+			for (i = ident_len; i % sizeof(u32) != 0; i++) {
+				if (buff[i] != '\0')
+					goto send_mal_query;
+			}
+		}
+		dev = dev_get_by_name(net, buff);
+		kfree(buff);
+		break;
+	case EXT_ECHO_CTYPE_INDEX:
+		if (ident_len != sizeof(iio->ident.ifindex))
+			goto send_mal_query;
+		dev = dev_get_by_index(net, ntohl(iio->ident.ifindex));
+		break;
+	case EXT_ECHO_CTYPE_ADDR:
+		if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) + iio->ident.addr.ctype3_hdr.addrlen)
+			goto send_mal_query;
+		switch (ntohs(iio->ident.addr.ctype3_hdr.afi)) {
+		case ICMP_AFI_IP:
+			if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) + sizeof(struct in_addr))
+				goto send_mal_query;
+			dev = ip_dev_find(net, iio->ident.addr.ip_addr.ipv4_addr.s_addr);
+			break;
+#if IS_ENABLED(CONFIG_IPV6)
+		case ICMP_AFI_IP6:
+			if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) + sizeof(struct in6_addr))
+				goto send_mal_query;
+			rcu_read_lock();
+			dev = ipv6_dev_find(net, &iio->ident.addr.ip_addr.ipv6_addr, dev);
+			if (dev)
+				dev_hold(dev);
+			rcu_read_unlock();
+			break;
+#endif
+		default:
+			goto send_mal_query;
+		}
+		break;
+	default:
+		goto send_mal_query;
+	}
+	if (!dev) {
+		icmp_param.data.icmph.code = ICMP_EXT_NO_IF;
+		goto send_reply;
+	}
+	/* Fill bits in reply message */
+	if (dev->flags & IFF_UP)
+		status |= EXT_ECHOREPLY_ACTIVE;
+	if (__in_dev_get_rcu(dev) && __in_dev_get_rcu(dev)->ifa_list)
+		status |= EXT_ECHOREPLY_IPV4;
+	if (!list_empty(&dev->ip6_ptr->addr_list))
+		status |= EXT_ECHOREPLY_IPV6;
+	dev_put(dev);
+	icmp_param.data.icmph.un.echo.sequence |= htons(status);
+send_reply:
+	icmp_reply(&icmp_param, skb);
+		return true;
+send_mal_query:
+	icmp_param.data.icmph.code = ICMP_EXT_MAL_QUERY;
+	goto send_reply;
 }
 
 /*
@@ -1088,6 +1192,11 @@ int icmp_rcv(struct sk_buff *skb)
 	icmph = icmp_hdr(skb);
 
 	ICMPMSGIN_INC_STATS(net, icmph->type);
+
+	/* Check for ICMP Extended Echo (PROBE) messages */
+	if (icmph->type == ICMP_EXT_ECHO)
+		goto probe;
+
 	/*
 	 *	18 is the highest 'known' ICMP type. Anything else is a mystery
 	 *
@@ -1097,7 +1206,6 @@ int icmp_rcv(struct sk_buff *skb)
 	if (icmph->type > NR_ICMP_TYPES)
 		goto error;
 
-
 	/*
 	 *	Parse the ICMP message
 	 */
@@ -1123,7 +1231,7 @@ int icmp_rcv(struct sk_buff *skb)
 	}
 
 	success = icmp_pointers[icmph->type].handler(skb);
-
+success_check:
 	if (success)  {
 		consume_skb(skb);
 		return NET_RX_SUCCESS;
@@ -1137,6 +1245,12 @@ int icmp_rcv(struct sk_buff *skb)
 error:
 	__ICMP_INC_STATS(net, ICMP_MIB_INERRORS);
 	goto drop;
+probe:
+	/* We can't use icmp_pointers[].handler() because it is an array of
+	 * size NR_ICMP_TYPES + 1 (19 elements) and PROBE has code 42.
+	 */
+	success = icmp_echo(skb);
+	goto success_check;
 }
 
 static bool ip_icmp_error_rfc4884_validate(const struct sk_buff *skb, int off)
@@ -1340,6 +1454,7 @@ static int __net_init icmp_sk_init(struct net *net)
 
 	/* Control parameters for ECHO replies. */
 	net->ipv4.sysctl_icmp_echo_ignore_all = 0;
+	net->ipv4.sysctl_icmp_echo_enable_probe = 0;
 	net->ipv4.sysctl_icmp_echo_ignore_broadcasts = 1;
 
 	/* Control parameter - ignore bogus broadcast responses? */
-- 
2.17.1

