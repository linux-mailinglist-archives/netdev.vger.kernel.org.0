Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D433533E0
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 13:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236841AbhDCLtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 07:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236652AbhDCLtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Apr 2021 07:49:10 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6E6C0617A9
        for <netdev@vger.kernel.org>; Sat,  3 Apr 2021 04:49:06 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lSelp-0000er-6s; Sat, 03 Apr 2021 13:48:53 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lSell-0007xg-Nc; Sat, 03 Apr 2021 13:48:49 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: [PATCH net-next v1 2/9] net: dsa: tag_ar9331: detect IGMP and MLD packets
Date:   Sat,  3 Apr 2021 13:48:41 +0200
Message-Id: <20210403114848.30528-3-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210403114848.30528-1-o.rempel@pengutronix.de>
References: <20210403114848.30528-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ar9331 switch is not forwarding IGMP and MLD packets if IGMP
snooping is enabled. This patch is trying to mimic the HW heuristic to take
same decisions as this switch would do to be able to tell the linux
bridge if some packet was prabably forwarded or not.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 net/dsa/tag_ar9331.c | 130 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 130 insertions(+)

diff --git a/net/dsa/tag_ar9331.c b/net/dsa/tag_ar9331.c
index 002cf7f952e2..0ba90e0f91bb 100644
--- a/net/dsa/tag_ar9331.c
+++ b/net/dsa/tag_ar9331.c
@@ -6,6 +6,8 @@
 
 #include <linux/bitfield.h>
 #include <linux/etherdevice.h>
+#include <linux/igmp.h>
+#include <net/addrconf.h>
 
 #include "dsa_priv.h"
 
@@ -24,6 +26,69 @@
 #define AR9331_HDR_RESERVED_MASK	GENMASK(5, 4)
 #define AR9331_HDR_PORT_NUM_MASK	GENMASK(3, 0)
 
+/*
+ * This code replicated MLD detection more or less in the same way as the
+ * switch is doing it
+ */
+static int ipv6_mc_check_ip6hdr(struct sk_buff *skb)
+{
+	const struct ipv6hdr *ip6h;
+	unsigned int offset;
+
+	offset = skb_network_offset(skb) + sizeof(*ip6h);
+
+	if (!pskb_may_pull(skb, offset))
+		return -EINVAL;
+
+	ip6h = ipv6_hdr(skb);
+
+	if (ip6h->version != 6)
+		return -EINVAL;
+
+	skb_set_transport_header(skb, offset);
+
+	return 0;
+}
+
+static int ipv6_mc_check_exthdrs(struct sk_buff *skb)
+{
+	const struct ipv6hdr *ip6h;
+	int offset;
+	u8 nexthdr;
+	__be16 frag_off;
+
+	ip6h = ipv6_hdr(skb);
+
+	if (ip6h->nexthdr != IPPROTO_HOPOPTS)
+		return -ENOMSG;
+
+	nexthdr = ip6h->nexthdr;
+	offset = skb_network_offset(skb) + sizeof(*ip6h);
+	offset = ipv6_skip_exthdr(skb, offset, &nexthdr, &frag_off);
+
+	if (offset < 0)
+		return -EINVAL;
+
+	if (nexthdr != IPPROTO_ICMPV6)
+		return -ENOMSG;
+
+	skb_set_transport_header(skb, offset);
+
+	return 0;
+}
+
+static int my_ipv6_mc_check_mld(struct sk_buff *skb)
+{
+	int ret;
+
+	ret = ipv6_mc_check_ip6hdr(skb);
+	if (ret < 0)
+		return ret;
+
+	return ipv6_mc_check_exthdrs(skb);
+}
+
+
 static struct sk_buff *ar9331_tag_xmit(struct sk_buff *skb,
 				       struct net_device *dev)
 {
@@ -31,6 +96,13 @@ static struct sk_buff *ar9331_tag_xmit(struct sk_buff *skb,
 	__le16 *phdr;
 	u16 hdr;
 
+	if (dp->stp_state == BR_STATE_BLOCKING) {
+		/* TODO: should we reflect it in the stats? */
+		netdev_warn_once(dev, "%s:%i dropping blocking packet\n",
+				 __func__, __LINE__);
+		return NULL;
+	}
+
 	phdr = skb_push(skb, AR9331_HDR_LEN);
 
 	hdr = FIELD_PREP(AR9331_HDR_VERSION_MASK, AR9331_HDR_VERSION);
@@ -80,11 +152,69 @@ static struct sk_buff *ar9331_tag_rcv(struct sk_buff *skb,
 	return skb;
 }
 
+static void ar9331_tag_rcv_post(struct sk_buff *skb)
+{
+	const struct iphdr *iph;
+	unsigned char *dest;
+	int ret;
+
+	/*
+	 * Since the switch do not tell us which packets was offloaded we assume
+	 * that all of them did. Except:
+	 * - port is not configured for forwarding to any other ports
+	 * - igmp/mld snooping is enabled
+	 * - unicast or multicast flood is disabled on some of bridged ports
+	 * - if we have two port bridge and one is not in forwarding state.
+	 * - packet was dropped on the output port..
+	 * - any other reasons?
+	 */
+	skb->offload_fwd_mark = true;
+
+	dest = eth_hdr(skb)->h_dest;
+	/*
+	 * Complete not multicast traffic seems to be forwarded automatically,
+	 * as long as multicast and unicast flood are enabled
+	 */
+	if (!(is_multicast_ether_addr(dest) && !is_broadcast_ether_addr(dest)))
+		return;
+
+
+	/*
+	 * Documentation do not providing any usable information on how the
+	 * igmp/mld snooping is implemented on this switch. Following
+	 * implementation is based on testing, by sending correct and malformed
+	 * packets to the switch.
+	 * It is not trying to find sane and properly formated packets. Instead
+	 * it is trying to be as close to the switch behavior as possible.
+	 */
+	skb_reset_network_header(skb);
+	switch (ntohs(skb->protocol)) {
+	case ETH_P_IP:
+
+		if (!pskb_network_may_pull(skb, sizeof(*iph)))
+			break;
+
+		iph = ip_hdr(skb);
+		if (iph->protocol == IPPROTO_IGMP)
+			skb->offload_fwd_mark = false;
+
+		break;
+	case ETH_P_IPV6:
+		ret = my_ipv6_mc_check_mld(skb);
+		if (!ret)
+			skb->offload_fwd_mark = false;
+
+		break;
+	}
+}
+
+
 static const struct dsa_device_ops ar9331_netdev_ops = {
 	.name	= "ar9331",
 	.proto	= DSA_TAG_PROTO_AR9331,
 	.xmit	= ar9331_tag_xmit,
 	.rcv	= ar9331_tag_rcv,
+	.rcv_post = ar9331_tag_rcv_post,
 	.overhead = AR9331_HDR_LEN,
 };
 
-- 
2.29.2

