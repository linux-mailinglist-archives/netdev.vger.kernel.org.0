Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAFE30E74C
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 00:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233507AbhBCXZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 18:25:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233436AbhBCXZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 18:25:37 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01081C061573
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 15:24:57 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id gx20so642992pjb.1
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 15:24:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HqSAslGnKq8CudbvP13enE08AyxXeCOAntNd5UTOUgs=;
        b=k4d8WLar74wFvSRVCyzfTMRxri/RDbFMAn0adzFlW3RsUyPv2hd6Hi+vOPo+gCPTvh
         IMYIoUBR1M3xhxybF10AQs4RvXVX5q4wnu94ySkXxbcJknTi2DRx9oTDThDX4QWhY6m8
         6UNPrqcvKo3M0EAZviqsb5A9Gy03MtFy/B2aS0/gQLGMVKOVInUrtESo5TMRsy7XI8PO
         Y4DZSh1ZU1R2AtX1O/ibdD9YxwhHAezUVx7mJurOPMg7hMGmpmkbfwp6Gb+NZ10w+AhM
         kBmE+i8leMUOplObmnNf7uT/l+kHtY6pmOd5JN7bBr195NY4xyj2Xq6YEer1Whv3NuAM
         IVCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HqSAslGnKq8CudbvP13enE08AyxXeCOAntNd5UTOUgs=;
        b=MUn84Oh2t910Q8LAi5D/rgQu7UkvZ0CVE5y9R7GAAviAfmcwMDMpmLMx0MBL/saihB
         4f07UgEh67Xq2j4gfCXrFcUavOA/GLkFQ/UTnAQa4AU6UkkH3QsDXVM+iECfOovb1PYt
         2O3TJ1KjcKPR+40YHPuUZUpAzT9cwk4YW9Px52WyMou/dOQToZWMsXX8QAf+ZaTM5eHD
         bnfa1CB8NQpsL0EHOX9pnLBWl/r4cYczz1VQifzJHMMeEQfud1/0pMwQN+uu3Q2RG5mS
         qfVzarA7eSO7wvwsn6u4Wj2sMo1o62F8Nof/KqrdLmf/MIdXX66le4dsByzmOrXrM9wi
         UfFA==
X-Gm-Message-State: AOAM533Wt4Ao+QeCjBh/AUg+gZClDd5a9m5e8DemuU5EtrwuJOvHbY6l
        ENmMRBozcLiyDre/dtkFxcQ=
X-Google-Smtp-Source: ABdhPJzmFOmnB+Y2jkgpUcFL7PP/QlGrjld6gbptU7dYL0V2BGJjI+kCyE6WgsDdt1vJhl7ThZ1flQ==
X-Received: by 2002:a17:90b:17c7:: with SMTP id me7mr5352906pjb.205.1612394696613;
        Wed, 03 Feb 2021 15:24:56 -0800 (PST)
Received: from localhost.localdomain (h134-215-163-197.lapior.broadband.dynamic.tds.net. [134.215.163.197])
        by smtp.gmail.com with ESMTPSA id j9sm2883268pjn.32.2021.02.03.15.24.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 15:24:56 -0800 (PST)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH V2 net-next 5/5] icmp: add response to RFC 8335 PROBE messages
Date:   Wed,  3 Feb 2021 15:24:55 -0800
Message-Id: <7af3da33a7aa540f7878cfcbf5076dcf61d201ef.1612393368.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1612393368.git.andreas.a.roeseler@gmail.com>
References: <cover.1612393368.git.andreas.a.roeseler@gmail.com>
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
---
 net/ipv4/icmp.c | 98 ++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 88 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 396b492c804f..18f9a2a3bf59 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -983,21 +983,85 @@ static bool icmp_redirect(struct sk_buff *skb)
 
 static bool icmp_echo(struct sk_buff *skb)
 {
+	struct icmp_bxm icmp_param;
 	struct net *net;
+	struct net_device *dev;
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
+	if (!(ntohs(icmp_param.data.icmph.un.echo.sequence) & 1))
+		return true;
+
+	icmp_param.data.icmph.type = ICMP_EXT_ECHOREPLY;
+	icmp_param.data.icmph.un.echo.sequence &= htons(0xFF00);
+	extobj_hdr = (struct icmp_extobj_hdr *)(skb->data + sizeof(struct icmp_ext_hdr));
+	ctype3_hdr = (struct icmp_ext_ctype3_hdr *)(extobj_hdr + 1);
+	status = 0;
+	switch (extobj_hdr->class_type) {
+	case CTYPE_NAME:
+		dev = dev_get_by_name(net, (char *)(extobj_hdr + 1));
+		break;
+	case CTYPE_INDEX:
+		dev = dev_get_by_index(net, ntohl(*((uint32_t *)(extobj_hdr + 1))));
+		break;
+	case CTYPE_ADDR:
+		switch (ntohs(ctype3_hdr->afi)) {
+		case AFI_IP:
+			dev = ip_dev_find(net, *(__be32 *)(ctype3_hdr + 1));
+			break;
+		case AFI_IP6:
+			dev = ipv6_dev_find(net, (struct in6_addr *)(ctype3_hdr + 1), dev);
+			if(dev) dev_hold(dev);
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
+	if(!dev) {
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
 
@@ -1087,6 +1151,13 @@ int icmp_rcv(struct sk_buff *skb)
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
@@ -1096,7 +1167,6 @@ int icmp_rcv(struct sk_buff *skb)
 	if (icmph->type > NR_ICMP_TYPES)
 		goto error;
 
-
 	/*
 	 *	Parse the ICMP message
 	 */
@@ -1123,6 +1193,7 @@ int icmp_rcv(struct sk_buff *skb)
 
 	success = icmp_pointers[icmph->type].handler(skb);
 
+success_check:
 	if (success)  {
 		consume_skb(skb);
 		return NET_RX_SUCCESS;
@@ -1136,6 +1207,13 @@ int icmp_rcv(struct sk_buff *skb)
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

