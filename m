Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1FAB3B4EDC
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 16:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhFZOKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 10:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbhFZOKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Jun 2021 10:10:40 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3149C061574
        for <netdev@vger.kernel.org>; Sat, 26 Jun 2021 07:08:17 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id k11so16083740ioa.5
        for <netdev@vger.kernel.org>; Sat, 26 Jun 2021 07:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q4dGvhnIvU/oAyXPyqbBz0DCQgwGP4sWSrEpe9zFf3E=;
        b=pUCIcCJSXdxVEmBq4svMTXlbfyxokIzSBoFboUr6vNmSq06u5kRK4ZmXG2fa9qAtrg
         WnG7zpx4PsXKoMbI8lFXqwgy9yHibEWCGg76QSw+uuATD4dQNlOhYtz/fGNAmByIGcoO
         LF+hmT6HlkniyIkCyyUXP7dNUitqd65xkTte8g2r1AMORGZLi1r8gxUWQk1WdYD7R7pR
         9L385v7Qsc5plBPR3sNXUN+mcyPDmafNjjM0q3fK2/sI2KVTz5+CF2IgqJaHKgthv1oz
         ZWl9xkSY7xxxdgxWVDArjBe4AAG4/ys6WOpwAdAYhTZf87PkjIXmW06O1EvDNSB0CgcM
         8UHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q4dGvhnIvU/oAyXPyqbBz0DCQgwGP4sWSrEpe9zFf3E=;
        b=rWsw7Z5zog7juq9IrNYHjg/D4D4kUYsVwAFyPKwd3Y266vYZ+o8IuCOP9JMLIqP/1g
         wb8IUF71HWCZ4VDhE0izjyeaiEJUMl2wXBVDgT3XTzFFmjK6BirnT27bPNbXEAE6Dnfy
         bu6Y5WSjWq3ItCB2s0abvq7iBjpwU4FDQbO8wsBmBlr+rGmRr/+xFoIwa7akbwy745Mg
         N3N7jfxjRklInts6iiP9QEHdYFfzrAYJQ4gKoixXEQuw8Lz+1jTvzypGPVMSQo6Lo4su
         pEXJx1GRaiZA1gWPG9Z2otuNA+rz8GwU35rgIp2vLX/fQlPs9V5lfyM6W3ZXi4AvGPew
         SXDA==
X-Gm-Message-State: AOAM530CG1iD6IMp8C1iuN6z/AtLvIj4mI//FXAoIfPZNJosLRxcXhls
        Z3jg3pX8Z/pQ56KMdZM2iELp8/gb6Dc=
X-Google-Smtp-Source: ABdhPJxpZXrc+1N6OBO/UluUZndid5q5cdfk3irdXiBZRBf6Ky52/YkNqnezxE2o8nDsAOf9zIDVRQ==
X-Received: by 2002:a5e:db06:: with SMTP id q6mr6322826iop.144.1624716496643;
        Sat, 26 Jun 2021 07:08:16 -0700 (PDT)
Received: from aroeseler-LY545.hsd1.mn.comcast.net ([2601:448:c580:1890::bc1f])
        by smtp.gmail.com with ESMTPSA id r4sm5636622ilq.27.2021.06.26.07.08.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Jun 2021 07:08:16 -0700 (PDT)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, willemdebruijn.kernel@gmail.com,
        Andreas Roeseler <andreas.a.roeseler@gmail.com>
Subject: [PATCH net-next V4] ipv6: ICMPV6: add response to ICMPV6 RFC 8335 PROBE messages
Date:   Sat, 26 Jun 2021 09:07:46 -0500
Message-Id: <c9bd6d9006f446b7eebd3a5bf06cb92f61e5f3a8.1624716130.git.andreas.a.roeseler@gmail.com>
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

v3 -> v4:
- Remove redundant sysctl check in icmpv6_echo_reply.
Suggested by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
- Keep separate case statements for ICMPV6 Echo and Extended Echo to
  check both sysctls.
---
 include/net/icmp.h |  1 +
 net/ipv4/icmp.c    | 63 ++++++++++++++++++++++++++++++----------------
 net/ipv6/icmp.c    | 21 +++++++++++++---
 3 files changed, 60 insertions(+), 25 deletions(-)

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
index e8398ffb5e35..a7c31ab67c5d 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -725,6 +725,7 @@ static void icmpv6_echo_reply(struct sk_buff *skb)
 	struct ipcm6_cookie ipc6;
 	u32 mark = IP6_REPLY_MARK(net, skb->mark);
 	bool acast;
+	u8 type;
 
 	if (ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr) &&
 	    net->ipv6.sysctl.icmpv6_echo_ignore_multicast)
@@ -740,8 +741,13 @@ static void icmpv6_echo_reply(struct sk_buff *skb)
 	    !(net->ipv6.sysctl.anycast_src_echo_reply && acast))
 		saddr = NULL;
 
+	if (icmph->icmp6_type == ICMPV6_EXT_ECHO_REQUEST)
+		type = ICMPV6_EXT_ECHO_REPLY;
+	else
+		type = ICMPV6_ECHO_REPLY;
+
 	memcpy(&tmp_hdr, icmph, sizeof(tmp_hdr));
-	tmp_hdr.icmp6_type = ICMPV6_ECHO_REPLY;
+	tmp_hdr.icmp6_type = type;
 
 	memset(&fl6, 0, sizeof(fl6));
 	if (net->ipv6.sysctl.flowlabel_reflect & FLOWLABEL_REFLECT_ICMPV6_ECHO_REPLIES)
@@ -752,7 +758,7 @@ static void icmpv6_echo_reply(struct sk_buff *skb)
 	if (saddr)
 		fl6.saddr = *saddr;
 	fl6.flowi6_oif = icmp6_iif(skb);
-	fl6.fl6_icmp_type = ICMPV6_ECHO_REPLY;
+	fl6.fl6_icmp_type = type;
 	fl6.flowi6_mark = mark;
 	fl6.flowi6_uid = sock_net_uid(net, NULL);
 	security_skb_classify_flow(skb, flowi6_to_flowi_common(&fl6));
@@ -783,13 +789,17 @@ static void icmpv6_echo_reply(struct sk_buff *skb)
 
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
@@ -911,6 +921,11 @@ static int icmpv6_rcv(struct sk_buff *skb)
 		if (!net->ipv6.sysctl.icmpv6_echo_ignore_all)
 			icmpv6_echo_reply(skb);
 		break;
+	case ICMPV6_EXT_ECHO_REQUEST:
+		if (!net->ipv6.sysctl.icmpv6_echo_ignore_all &&
+		    net->ipv4.sysctl_icmp_echo_enable_probe)
+			icmpv6_echo_reply(skb);
+		break;
 
 	case ICMPV6_ECHO_REPLY:
 		success = ping_rcv(skb);
-- 
2.32.0

