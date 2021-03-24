Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB4C348048
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 19:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237519AbhCXSS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 14:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237485AbhCXSSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 14:18:24 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE53C0613DE
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 11:18:24 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id 91-20020a9d08640000b0290237d9c40382so2607568oty.12
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 11:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rb4Aj52dwtBiCMiyyeXYam8IwXeqFhQXyisyxJGdRHg=;
        b=nFFNrxq5qFcyQvL+R0ibv30KGIl/gFG0qW6/Hs2ZkfoAICa+DBGJjQd4sN6TyH5Uvw
         idK7qejKUiBRNobodlPDVfxMtWWaeg3/l02d3WCKTrJSSdnCAXFbi+6ykfx9Lp+L0mOE
         1zXgQIGw48V2kF0wYLzyPaamaN6wc7nM9Px0oCy6wrLKEMsS9i4v6dZ2dNfwZNHP5IAV
         ipxht7sPKgu2RsY9i1eS6SNU4jFXa/6O3ntbxPgsl1ypOapzqtdnx7b55PFsTciFkP4c
         Qbqo7nZKN2jv59Ma4zXwTAz+ymCVKEoiQgKnH3b7SrnG9R6E1S462zpMiR8v2t68B+oW
         LRPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rb4Aj52dwtBiCMiyyeXYam8IwXeqFhQXyisyxJGdRHg=;
        b=Y15PAbYlDQ9QGv5JEzK19Ym3ye3mKzY3JGHku5dO2P7UEQ8ZXCI5dhVO5bH6XjNI1n
         98AHv/km0A5rHPfj5GBvbza/scPYFY7tdgspFjXI5jJFB7kPwDLlZA5Dl9/TuDXt47+A
         UKmFsWAzKn7caEPU9wj47M9wu715iC6En9rIPjwcHwjEY3q6vJDUA9NamIa/P1yl4dDA
         Bh5I3IXgN9I4prR7tCS19QS++M4d8S9YsM8iJEoMWbmhygkFSTfyUkxp3TDzyTAzC/4v
         gBNX7j3vAzozEX/5kUSG8uRFhnUKqw49X+T0ag9tcXtaKoi7rKSOd3s2JbwEgbxzMx01
         jCQA==
X-Gm-Message-State: AOAM531Lj9ab5z7SiFZIORPL2Nc42/JWVtbqwBBQ5WUb7qRUM+xzat1s
        ig/LJBo01HET/bgIzFXjrFOJEtK9dD8=
X-Google-Smtp-Source: ABdhPJz3EfKXpV/6amhbpOoycJz5Fwk+A0bFMaVjPjlvkebHpTi5FD1u3k8MJKd/dkKUljOYYowQog==
X-Received: by 2002:a9d:740c:: with SMTP id n12mr4186237otk.21.1616609903687;
        Wed, 24 Mar 2021 11:18:23 -0700 (PDT)
Received: from clinic20-Precision-T3610.hsd1.ut.comcast.net ([2601:681:8800:baf9:abb9:79f4:f528:e200])
        by smtp.googlemail.com with ESMTPSA id n10sm445062otj.36.2021.03.24.11.18.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 11:18:23 -0700 (PDT)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, Andreas Roeseler <andreas.a.roeseler@gmail.com>
Subject: [PATCH net-next V5 6/6] icmp: add response to RFC 8335 PROBE messages
Date:   Wed, 24 Mar 2021 11:18:21 -0700
Message-Id: <77658f2ff9f9de796ae2386f60b2a372882befa6.1616608328.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1616608328.git.andreas.a.roeseler@gmail.com>
References: <cover.1616608328.git.andreas.a.roeseler@gmail.com>
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

The modification to the iputils package is still in development and can
be found here: https://github.com/Juniper-Clinic-2020/iputils.git. It
supports full sending functionality of PROBE requests, but currently
does not parse the response messages, which is why Wireshark is required
to verify the sent and recieved PROBE messages. The modification adds
the ``-e'' flag to the command which allows the user to specify the
interface identifier to query the probed host. An example usage would be
<./ping -4 -e 1 [destination]> to send a PROBE request of ifindex 1 to the
destination node.

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

v4 -> v5:
 - Statically allocate buff to size IFNAMSIZ on declaration
 - Remove goto probe in favor of single branch
 - Remove strict check for incoming PROBE requests padding to nearest
   32-bit boundary
Reported-by: kernel test robot <lkp@intel.com>
 - Use rcu_dereference when accessing i6_ptr in net_device
---
 net/ipv4/icmp.c | 127 +++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 114 insertions(+), 13 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 616e2dc1c8fa..2acf7d3a66cb 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -971,7 +971,7 @@ static bool icmp_redirect(struct sk_buff *skb)
 }
 
 /*
- *	Handle ICMP_ECHO ("ping") requests.
+ *	Handle ICMP_ECHO ("ping") and ICMP_EXT_ECHO ("PROBE") requests.
  *
  *	RFC 1122: 3.2.2.6 MUST have an echo server that answers ICMP echo
  *		  requests.
@@ -979,27 +979,118 @@ static bool icmp_redirect(struct sk_buff *skb)
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
+	char buff[IFNAMSIZ];
 	struct net *net;
+	u16 ident_len;
+	u8 status;
 
 	net = dev_net(skb_dst(skb)->dev);
-	if (!net->ipv4.sysctl_icmp_echo_ignore_all) {
-		struct icmp_bxm icmp_param;
+	/* should there be an ICMP stat for ignored echos? */
+	if (net->ipv4.sysctl_icmp_echo_ignore_all)
+		return true;
+
+	icmp_param.data.icmph	   = *icmp_hdr(skb);
+	icmp_param.skb		   = skb;
+	icmp_param.offset	   = 0;
+	icmp_param.data_len	   = skb->len;
+	icmp_param.head_len	   = sizeof(struct icmphdr);
 
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
-	return true;
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
+		memset(buff, 0, sizeof(buff));
+		memcpy(buff, &iio->ident.name, ident_len);
+		dev = dev_get_by_name(net, buff);
+		break;
+	case EXT_ECHO_CTYPE_INDEX:
+		if (ident_len != sizeof(iio->ident.ifindex))
+			goto send_mal_query;
+		dev = dev_get_by_index(net, ntohl(iio->ident.ifindex));
+		break;
+	case EXT_ECHO_CTYPE_ADDR:
+		if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
+				 iio->ident.addr.ctype3_hdr.addrlen)
+			goto send_mal_query;
+		switch (ntohs(iio->ident.addr.ctype3_hdr.afi)) {
+		case ICMP_AFI_IP:
+			if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
+					 sizeof(struct in_addr))
+				goto send_mal_query;
+			dev = ip_dev_find(net, iio->ident.addr.ip_addr.ipv4_addr.s_addr);
+			break;
+#if IS_ENABLED(CONFIG_IPV6)
+		case ICMP_AFI_IP6:
+			if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
+					 sizeof(struct in6_addr))
+				goto send_mal_query;
+			rcu_read_lock();
+			dev = ipv6_stub->ipv6_dev_find(net, &iio->ident.addr.ip_addr.ipv6_addr, dev);
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
+	if (!list_empty(&rcu_dereference(dev->ip6_ptr)->addr_list))
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
@@ -1088,6 +1179,16 @@ int icmp_rcv(struct sk_buff *skb)
 	icmph = icmp_hdr(skb);
 
 	ICMPMSGIN_INC_STATS(net, icmph->type);
+
+	/* Check for ICMP Extended Echo (PROBE) messages */
+	if (icmph->type == ICMP_EXT_ECHO) {
+		/* We can't use icmp_pointers[].handler() because it is an array of
+		 * size NR_ICMP_TYPES + 1 (19 elements) and PROBE has code 42.
+		 */
+		success = icmp_echo(skb);
+		goto success_check;
+	}
+
 	/*
 	 *	18 is the highest 'known' ICMP type. Anything else is a mystery
 	 *
@@ -1097,7 +1198,6 @@ int icmp_rcv(struct sk_buff *skb)
 	if (icmph->type > NR_ICMP_TYPES)
 		goto error;
 
-
 	/*
 	 *	Parse the ICMP message
 	 */
@@ -1123,7 +1223,7 @@ int icmp_rcv(struct sk_buff *skb)
 	}
 
 	success = icmp_pointers[icmph->type].handler(skb);
-
+success_check:
 	if (success)  {
 		consume_skb(skb);
 		return NET_RX_SUCCESS;
@@ -1340,6 +1440,7 @@ static int __net_init icmp_sk_init(struct net *net)
 
 	/* Control parameters for ECHO replies. */
 	net->ipv4.sysctl_icmp_echo_ignore_all = 0;
+	net->ipv4.sysctl_icmp_echo_enable_probe = 0;
 	net->ipv4.sysctl_icmp_echo_ignore_broadcasts = 1;
 
 	/* Control parameter - ignore bogus broadcast responses? */
-- 
2.17.1

