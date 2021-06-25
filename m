Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFD43B4675
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 17:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhFYPVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 11:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhFYPVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 11:21:20 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76028C061574
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 08:18:59 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id v3so12864034ioq.9
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 08:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=11oj2A9CBxc2Znkw9e63fr/5bSdZjNWtZtJuBwXPI/4=;
        b=MbbySq1afCBaNLc600yeVdcWhJUphAMQ/PUTjeAxuHfS3u1a0ChLfGpQVe16p6JuiB
         dlYyVlJQqXzxmbAE5ttz1PaNRGrJkVjewIVi7fJdMqnL67RP8RYtPwLQWhdLY3tbj2Q9
         bsHST/OJtvnYDlF5JErBCtQn69/Y8gv5l8muP1bQH7CLjroCrI6SEz8VLDe3XFMG6MVc
         LvTMv1WtlEoizOodVtfl6MWMeF9iV1NIcA2Z6qHOZGXpYIfdOQ9UOEAU33RdU/LwFRs/
         i0O1MQfT0NeXbK6DzH3I4bVDVbWGSxSEN5EJOr+20V4tkyVWmtRAdJlKLJTIFzwUd6qA
         C9og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=11oj2A9CBxc2Znkw9e63fr/5bSdZjNWtZtJuBwXPI/4=;
        b=BzyqUHPenGVihjSBg75hQcMCWH28s+uZXy7lgaiOmlVet91JI0WvlBKXXg11UTfM9n
         wql6+cFlvJSvrgOIwGuuJx2iXcK37Ks92peoDlWdDcMM8QR5mJkvLjY6SlZjyIWuaBqW
         iadQHWH5mjWCqsWiOxj0Q5Gpz+Te9ThbXswjxWQXVMr3d1nVLkke58b4tl2dj6xN/M5+
         yeVVj4HcJja+RLF3XPDk96mLObd0e0lUXQ+ww4JXjgEYF33/81OsRAxpaLhSkAoe+SHT
         DzkfeDP3I4rEjYm5TP5BZKCa5DNZGnM4Ms/8rSFVmVaDHdf3EHaw7r2gKbEcGeYdZm7y
         zxhA==
X-Gm-Message-State: AOAM530wBd64a5O9MqrLpM55oz/t95OYNnZVEP1HDB92ekzNJeOD+tU1
        s1SMu6sDL1eeN+8Rs665dlDObCUYQKw=
X-Google-Smtp-Source: ABdhPJx4T0W/lIZz15f0Z9n55RqKEUKt1Yer2XgGUwkU45Ha4Og4MFG1W6d6ok5lXNTV50zLEBbQkA==
X-Received: by 2002:a6b:3b95:: with SMTP id i143mr2424177ioa.173.1624634338523;
        Fri, 25 Jun 2021 08:18:58 -0700 (PDT)
Received: from aroeseler-LY545.hsd1.mn.comcast.net ([2601:448:c580:1890::bc1f])
        by smtp.gmail.com with ESMTPSA id z12sm3435247iop.46.2021.06.25.08.18.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 08:18:58 -0700 (PDT)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, willemdebruijn.kernel@gmail.com,
        Andreas Roeseler <andreas.a.roeseler@gmail.com>
Subject: [PATCH net-next V3] ipv6: ICMPV6: add response to ICMPV6 RFC 8335 PROBE messages
Date:   Fri, 25 Jun 2021 10:18:32 -0500
Message-Id: <98f7ab5fb176f1d1565a001c3324f1db6c0e6d4f.1624632443.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch builds off of commit 2b246b2569cd2ac6ff700d0dce56b8bae29b1842
and adds functionality to respond to ICMPV6 PROBE requests.

Add icmp_build_probe function to construct PROBE requests for both
ICMPV4 and ICMPV6.

Modify icmpv6_rcv to detect ICMPV6 PROBE messages and call the
icmpv6_echo_reply handler.

Modify icmpv6_echo_reply to build a PROBE response message based on the
queried interface.

This patch has been tested using a branch of the iputils git repo which can
be found here: https://github.com/Juniper-Clinic-2020/iputils/tree/probe-request

Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
---
Changes:
v1 -> v2:
Suggested by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
- Do not add sysctl for ICMPV6 PROBE control and instead use existing
  ICMPV4 sysctl.
- Add icmp_build_probe function to construct PROBE responses for both
  ICMPV4 and ICMPV6.

v2 -> v3:
Suggested by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
- Move icmp_build_probe helper to after icmp_echo to reduce diff size.
- Export icmp_build_probe for use in icmpv6_echo_reply when compiled
  modularly. 
- Simplify icmp_echo control flow by removing extra if statement.
- Simplify icmpv6 handler case statements.
---
 include/net/icmp.h |  1 +
 net/ipv4/icmp.c    | 63 ++++++++++++++++++++++++++++++----------------
 net/ipv6/icmp.c    | 23 ++++++++++++-----
 3 files changed, 59 insertions(+), 28 deletions(-)

diff --git a/include/net/icmp.h b/include/net/icmp.h
index fd84adc47963..caddf4a59ad1 100644
--- a/include/net/icmp.h
+++ b/include/net/icmp.h
@@ -57,5 +57,6 @@ int icmp_rcv(struct sk_buff *skb);
 int icmp_err(struct sk_buff *skb, u32 info);
 int icmp_init(void);
 void icmp_out_count(struct net *net, unsigned char type);
+bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr);
 
 #endif	/* _ICMP_H */
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 0a57f1892e7e..c695d294a5df 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -993,14 +993,8 @@ static bool icmp_redirect(struct sk_buff *skb)
 
 static bool icmp_echo(struct sk_buff *skb)
 {
-	struct icmp_ext_hdr *ext_hdr, _ext_hdr;
-	struct icmp_ext_echo_iio *iio, _iio;
 	struct icmp_bxm icmp_param;
-	struct net_device *dev;
-	char buff[IFNAMSIZ];
 	struct net *net;
-	u16 ident_len;
-	u8 status;
 
 	net = dev_net(skb_dst(skb)->dev);
 	/* should there be an ICMP stat for ignored echos? */
@@ -1013,20 +1007,46 @@ static bool icmp_echo(struct sk_buff *skb)
 	icmp_param.data_len	   = skb->len;
 	icmp_param.head_len	   = sizeof(struct icmphdr);
 
-	if (icmp_param.data.icmph.type == ICMP_ECHO) {
+	if (icmp_param.data.icmph.type == ICMP_ECHO)
 		icmp_param.data.icmph.type = ICMP_ECHOREPLY;
-		goto send_reply;
-	}
-	if (!net->ipv4.sysctl_icmp_echo_enable_probe)
+	else if (!icmp_build_probe(skb, &icmp_param.data.icmph))
 		return true;
+
+	icmp_reply(&icmp_param, skb);
+	return true;
+}
+
+/*	Helper for icmp_echo and icmpv6_echo_reply.
+ *	Searches for net_device that matches PROBE interface identifier
+ *		and builds PROBE reply message in icmphdr.
+ *
+ *	Returns false if PROBE responses are disabled via sysctl
+ */
+
+bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr)
+{
+	struct icmp_ext_hdr *ext_hdr, _ext_hdr;
+	struct icmp_ext_echo_iio *iio, _iio;
+	struct net *net = dev_net(skb->dev);
+	struct net_device *dev;
+	char buff[IFNAMSIZ];
+	u16 ident_len;
+	u8 status;
+
+	if (!net->ipv4.sysctl_icmp_echo_enable_probe)
+		return false;
+
 	/* We currently only support probing interfaces on the proxy node
 	 * Check to ensure L-bit is set
 	 */
-	if (!(ntohs(icmp_param.data.icmph.un.echo.sequence) & 1))
-		return true;
+	if (!(ntohs(icmphdr->un.echo.sequence) & 1))
+		return false;
 	/* Clear status bits in reply message */
-	icmp_param.data.icmph.un.echo.sequence &= htons(0xFF00);
-	icmp_param.data.icmph.type = ICMP_EXT_ECHOREPLY;
+	icmphdr->un.echo.sequence &= htons(0xFF00);
+	if (icmphdr->type == ICMP_EXT_ECHO)
+		icmphdr->type = ICMP_EXT_ECHOREPLY;
+	else
+		icmphdr->type = ICMPV6_EXT_ECHO_REPLY;
 	ext_hdr = skb_header_pointer(skb, 0, sizeof(_ext_hdr), &_ext_hdr);
 	/* Size of iio is class_type dependent.
 	 * Only check header here and assign length based on ctype in the switch statement
@@ -1087,8 +1107,8 @@ static bool icmp_echo(struct sk_buff *skb)
 		goto send_mal_query;
 	}
 	if (!dev) {
-		icmp_param.data.icmph.code = ICMP_EXT_CODE_NO_IF;
-		goto send_reply;
+		icmphdr->code = ICMP_EXT_CODE_NO_IF;
+		return true;
 	}
 	/* Fill bits in reply message */
 	if (dev->flags & IFF_UP)
@@ -1098,14 +1118,13 @@ static bool icmp_echo(struct sk_buff *skb)
 	if (!list_empty(&rcu_dereference(dev->ip6_ptr)->addr_list))
 		status |= ICMP_EXT_ECHOREPLY_IPV6;
 	dev_put(dev);
-	icmp_param.data.icmph.un.echo.sequence |= htons(status);
-send_reply:
-	icmp_reply(&icmp_param, skb);
-		return true;
+	icmphdr->un.echo.sequence |= htons(status);
+	return true;
 send_mal_query:
-	icmp_param.data.icmph.code = ICMP_EXT_CODE_MAL_QUERY;
-	goto send_reply;
+	icmphdr->code = ICMP_EXT_CODE_MAL_QUERY;
+	return true;
 }
+EXPORT_SYMBOL_GPL(icmp_build_probe);
 
 /*
  *	Handle ICMP Timestamp requests.
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index e8398ffb5e35..f15ef168310f 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -725,6 +725,7 @@ static void icmpv6_echo_reply(struct sk_buff *skb)
 	struct ipcm6_cookie ipc6;
 	u32 mark = IP6_REPLY_MARK(net, skb->mark);
 	bool acast;
+	u8 type;
 
 	if (ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr) &&
 	    net->ipv6.sysctl.icmpv6_echo_ignore_multicast)
@@ -740,8 +741,16 @@ static void icmpv6_echo_reply(struct sk_buff *skb)
 	    !(net->ipv6.sysctl.anycast_src_echo_reply && acast))
 		saddr = NULL;
 
+	if (icmph->icmp6_type == ICMPV6_EXT_ECHO_REQUEST) {
+		if (!net->ipv4.sysctl_icmp_echo_enable_probe)
+			return;
+		type = ICMPV6_EXT_ECHO_REPLY;
+	} else {
+		type = ICMPV6_ECHO_REPLY;
+	}
+
 	memcpy(&tmp_hdr, icmph, sizeof(tmp_hdr));
-	tmp_hdr.icmp6_type = ICMPV6_ECHO_REPLY;
+	tmp_hdr.icmp6_type = type;
 
 	memset(&fl6, 0, sizeof(fl6));
 	if (net->ipv6.sysctl.flowlabel_reflect & FLOWLABEL_REFLECT_ICMPV6_ECHO_REPLIES)
@@ -752,7 +761,7 @@ static void icmpv6_echo_reply(struct sk_buff *skb)
 	if (saddr)
 		fl6.saddr = *saddr;
 	fl6.flowi6_oif = icmp6_iif(skb);
-	fl6.fl6_icmp_type = ICMPV6_ECHO_REPLY;
+	fl6.fl6_icmp_type = type;
 	fl6.flowi6_mark = mark;
 	fl6.flowi6_uid = sock_net_uid(net, NULL);
 	security_skb_classify_flow(skb, flowi6_to_flowi_common(&fl6));
@@ -783,13 +792,17 @@ static void icmpv6_echo_reply(struct sk_buff *skb)
 
 	msg.skb = skb;
 	msg.offset = 0;
-	msg.type = ICMPV6_ECHO_REPLY;
+	msg.type = type;
 
 	ipcm6_init_sk(&ipc6, np);
 	ipc6.hlimit = ip6_sk_dst_hoplimit(np, &fl6, dst);
 	ipc6.tclass = ipv6_get_dsfield(ipv6_hdr(skb));
 	ipc6.sockc.mark = mark;
 
+	if (icmph->icmp6_type == ICMPV6_EXT_ECHO_REQUEST)
+		if (!icmp_build_probe(skb, (struct icmphdr *)&tmp_hdr))
+			goto out_dst_release;
+
 	if (ip6_append_data(sk, icmpv6_getfrag, &msg,
 			    skb->len + sizeof(struct icmp6hdr),
 			    sizeof(struct icmp6hdr), &ipc6, &fl6,
@@ -908,14 +921,12 @@ static int icmpv6_rcv(struct sk_buff *skb)
 
 	switch (type) {
 	case ICMPV6_ECHO_REQUEST:
+	case ICMPV6_EXT_ECHO_REQUEST:
 		if (!net->ipv6.sysctl.icmpv6_echo_ignore_all)
 			icmpv6_echo_reply(skb);
 		break;
 
 	case ICMPV6_ECHO_REPLY:
-		success = ping_rcv(skb);
-		break;
-
 	case ICMPV6_EXT_ECHO_REPLY:
 		success = ping_rcv(skb);
 		break;
-- 
2.32.0

