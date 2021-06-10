Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 664C63A3236
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 19:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbhFJRh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 13:37:59 -0400
Received: from mail-ed1-f44.google.com ([209.85.208.44]:38840 "EHLO
        mail-ed1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbhFJRh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 13:37:58 -0400
Received: by mail-ed1-f44.google.com with SMTP id d13so20475938edt.5
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 10:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kH6YJD/XoOCLim6QyTt5pOniDEXuTmphfPtmVeI990k=;
        b=TXEHU6CpFP/SE01VMz5nOlRkOjUEcYAWMNKATD5zGotjJZkYKCGX+/yHKkfi3n3f6z
         mMVz1dTEA75XtYZs6vCKgCkyokSxwZpnJkR1SMt84nJUIcm2mf2gXyQl56nj3vgs6J+Q
         KdOoX8LulQM0eP7H96aOmgi0wISwD8zVXsx/+vFb/kXyDy/atHCmFGAN12vZpA1O8Uu8
         FFZvqL/H6Pkdkfp6mquQQJFpPLyAcYThWDrbfTzXD/j6fzsqB/39mSfjFwKcHmkhfIeR
         GsooQakDO56f6OfoNWy85fZCKiQyx7ow82Peu9eSjvKtJA3B91TT4VfA1zhhCQguqtql
         j68g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kH6YJD/XoOCLim6QyTt5pOniDEXuTmphfPtmVeI990k=;
        b=qvQJb/Tbk5oVEDR8XBrNKwWeJACs6l3YdYYVmIiJWoir9ig3pZwGRvRaHlBtdrTd9t
         a9sscFlbhrd8L0+l7E4NKwcXKiQNzTymH2zqi036UtF1bQQ5OSKB8cIvxhZ+iu77KIZX
         O7CzfY9n1RlbDQ5sbZP9o0lkasxlPCf4kZjpyI4n6Up09p7dchozFXJaL1nXCunrn5c4
         wCdSWhn23XIWqM/N0WQn4lKDD0ScB7L3mjpvV/QUp+d5tBMx66bcd4xKVPfBZxdI/xwv
         SM9xGruUF2ZZOeoSeY/3uQ2S0hiK4jHaPqZu90ZZ4KdRTUMW6kw6GnH1BFYS7H9cxGJA
         zcdg==
X-Gm-Message-State: AOAM530qO36midhLRc0NHq/5QJF/2RKsvi9wm+PQ5qQxNf7w/GiHCyHR
        eqQQ8GJmtUsRRVQOGdqeJQg=
X-Google-Smtp-Source: ABdhPJw473MULSAD1TKnWixIjAXqdPzdQG/qTwB4OgwwedfttV2pxnqpDZ/F1SG7xTZ3cK/b922e5g==
X-Received: by 2002:a05:6402:18c:: with SMTP id r12mr655388edv.10.1623346501309;
        Thu, 10 Jun 2021 10:35:01 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g17sm1789595edp.14.2021.06.10.10.35.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 10:35:00 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 03/10] net: dsa: generalize overhead for taggers that use both headers and trailers
Date:   Thu, 10 Jun 2021 20:34:18 +0300
Message-Id: <20210610173425.1791379-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210610173425.1791379-1-olteanv@gmail.com>
References: <20210610173425.1791379-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Some really really weird switches just couldn't decide whether to use a
normal or a tail tagger, so they just did both.

This creates problems for DSA, because we only have the concept of an
'overhead' which can be applied to the headroom or to the tailroom of
the skb (like for example during the central TX reallocation procedure),
depending on the value of bool tail_tag, but not to both.

We need to generalize DSA to cater for these odd switches by
transforming the 'overhead / tail_tag' pair into 'needed_headroom /
needed_tailroom'.

The DSA master's MTU is increased to account for both.

The flow dissector code is modified such that it only calls the DSA
adjustment callback if the tagger has a non-zero header length.

Taggers are trivially modified to declare either needed_headroom or
needed_tailroom, based on the tail_tag value that they currently
declare.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/networking/dsa/dsa.rst | 21 +++++++++++----------
 include/net/dsa.h                    |  6 +++---
 net/core/flow_dissector.c            |  2 +-
 net/dsa/dsa_priv.h                   |  5 +++++
 net/dsa/master.c                     |  6 ++++--
 net/dsa/slave.c                      | 10 ++++------
 net/dsa/tag_ar9331.c                 |  2 +-
 net/dsa/tag_brcm.c                   |  6 +++---
 net/dsa/tag_dsa.c                    |  4 ++--
 net/dsa/tag_gswip.c                  |  2 +-
 net/dsa/tag_hellcreek.c              |  3 +--
 net/dsa/tag_ksz.c                    |  9 +++------
 net/dsa/tag_lan9303.c                |  2 +-
 net/dsa/tag_mtk.c                    |  2 +-
 net/dsa/tag_ocelot.c                 |  4 ++--
 net/dsa/tag_ocelot_8021q.c           |  2 +-
 net/dsa/tag_qca.c                    |  2 +-
 net/dsa/tag_rtl4_a.c                 |  2 +-
 net/dsa/tag_sja1105.c                |  2 +-
 net/dsa/tag_trailer.c                |  3 +--
 net/dsa/tag_xrs700x.c                |  3 +--
 21 files changed, 49 insertions(+), 49 deletions(-)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index 8688009514cc..a2787bdd057c 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -93,14 +93,15 @@ A tagging protocol may tag all packets with switch tags of the same length, or
 the tag length might vary (for example packets with PTP timestamps might
 require an extended switch tag, or there might be one tag length on TX and a
 different one on RX). Either way, the tagging protocol driver must populate the
-``struct dsa_device_ops::overhead`` with the length in octets of the longest
-switch frame header. The DSA framework will automatically adjust the MTU of the
-master interface to accomodate for this extra size in order for DSA user ports
-to support the standard MTU (L2 payload length) of 1500 octets. The ``overhead``
-is also used to request from the network stack, on a best-effort basis, the
-allocation of packets with a ``needed_headroom`` or ``needed_tailroom``
-sufficient such that the act of pushing the switch tag on transmission of a
-packet does not cause it to reallocate due to lack of memory.
+``struct dsa_device_ops::needed_headroom`` and/or ``struct dsa_device_ops::needed_tailroom``
+with the length in octets of the longest switch frame header/trailer. The DSA
+framework will automatically adjust the MTU of the master interface to
+accommodate for this extra size in order for DSA user ports to support the
+standard MTU (L2 payload length) of 1500 octets. The ``needed_headroom`` and
+``needed_tailroom`` properties are also used to request from the network stack,
+on a best-effort basis, the allocation of packets with enough extra space such
+that the act of pushing the switch tag on transmission of a packet does not
+cause it to reallocate due to lack of memory.
 
 Even though applications are not expected to parse DSA-specific frame headers,
 the format on the wire of the tagging protocol represents an Application Binary
@@ -169,8 +170,8 @@ The job of this method is to prepare the skb in a way that the switch will
 understand what egress port the packet is for (and not deliver it towards other
 ports). Typically this is fulfilled by pushing a frame header. Checking for
 insufficient size in the skb headroom or tailroom is unnecessary provided that
-the ``overhead`` and ``tail_tag`` properties were filled out properly, because
-DSA ensures there is enough space before calling this method.
+the ``needed_headroom`` and ``needed_tailroom`` properties were filled out
+properly, because DSA ensures there is enough space before calling this method.
 
 The reception of a packet goes through the tagger's ``rcv`` function. The
 passed ``struct sk_buff *skb`` has ``skb->data`` pointing at
diff --git a/include/net/dsa.h b/include/net/dsa.h
index e1a2610a0e06..0a10f6fffc3d 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -91,7 +91,8 @@ struct dsa_device_ops {
 	 * as regular on the master net device.
 	 */
 	bool (*filter)(const struct sk_buff *skb, struct net_device *dev);
-	unsigned int overhead;
+	unsigned int needed_headroom;
+	unsigned int needed_tailroom;
 	const char *name;
 	enum dsa_tag_protocol proto;
 	/* Some tagging protocols either mangle or shift the destination MAC
@@ -100,7 +101,6 @@ struct dsa_device_ops {
 	 * its RX filter.
 	 */
 	bool promisc_on_master;
-	bool tail_tag;
 };
 
 /* This structure defines the control interfaces that are overlayed by the
@@ -926,7 +926,7 @@ static inline void dsa_tag_generic_flow_dissect(const struct sk_buff *skb,
 {
 #if IS_ENABLED(CONFIG_NET_DSA)
 	const struct dsa_device_ops *ops = skb->dev->dsa_ptr->tag_ops;
-	int tag_len = ops->overhead;
+	int tag_len = ops->needed_headroom;
 
 	*offset = tag_len;
 	*proto = ((__be16 *)skb->data)[(tag_len / 2) - 1];
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 3ed7c98a98e1..c04455981c1e 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -944,7 +944,7 @@ bool __skb_flow_dissect(const struct net *net,
 
 			ops = skb->dev->dsa_ptr->tag_ops;
 			/* Tail taggers don't break flow dissection */
-			if (!ops->tail_tag) {
+			if (!ops->needed_headroom) {
 				if (ops->flow_dissect)
 					ops->flow_dissect(skb, &proto, &offset);
 				else
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 92282de54230..b8b17474b72b 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -154,6 +154,11 @@ const struct dsa_device_ops *dsa_find_tagger_by_name(const char *buf);
 bool dsa_schedule_work(struct work_struct *work);
 const char *dsa_tag_protocol_to_str(const struct dsa_device_ops *ops);
 
+static inline int dsa_tag_protocol_overhead(const struct dsa_device_ops *ops)
+{
+	return ops->needed_headroom + ops->needed_tailroom;
+}
+
 /* master.c */
 int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp);
 void dsa_master_teardown(struct net_device *dev);
diff --git a/net/dsa/master.c b/net/dsa/master.c
index 63adbc21a735..3fc90e36772d 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -346,10 +346,12 @@ static struct lock_class_key dsa_master_addr_list_lock_key;
 
 int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 {
-	int mtu = ETH_DATA_LEN + cpu_dp->tag_ops->overhead;
+	const struct dsa_device_ops *tag_ops = cpu_dp->tag_ops;
 	struct dsa_switch *ds = cpu_dp->ds;
 	struct device_link *consumer_link;
-	int ret;
+	int mtu, ret;
+
+	mtu = ETH_DATA_LEN + dsa_tag_protocol_overhead(tag_ops);
 
 	/* The DSA master must use SET_NETDEV_DEV for this to work. */
 	consumer_link = device_link_add(ds->dev, dev->dev.parent,
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index d4756b920108..3ca509eb284d 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1569,7 +1569,7 @@ int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
 
 	mtu_limit = min_t(int, master->max_mtu, dev->max_mtu);
 	old_master_mtu = master->mtu;
-	new_master_mtu = largest_mtu + cpu_dp->tag_ops->overhead;
+	new_master_mtu = largest_mtu + dsa_tag_protocol_overhead(cpu_dp->tag_ops);
 	if (new_master_mtu > mtu_limit)
 		return -ERANGE;
 
@@ -1605,7 +1605,7 @@ int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
 out_port_failed:
 	if (new_master_mtu != old_master_mtu)
 		dsa_port_mtu_change(cpu_dp, old_master_mtu -
-				    cpu_dp->tag_ops->overhead,
+				    dsa_tag_protocol_overhead(cpu_dp->tag_ops),
 				    true);
 out_cpu_failed:
 	if (new_master_mtu != old_master_mtu)
@@ -1824,10 +1824,8 @@ void dsa_slave_setup_tagger(struct net_device *slave)
 	const struct dsa_port *cpu_dp = dp->cpu_dp;
 	struct net_device *master = cpu_dp->master;
 
-	if (cpu_dp->tag_ops->tail_tag)
-		slave->needed_tailroom = cpu_dp->tag_ops->overhead;
-	else
-		slave->needed_headroom = cpu_dp->tag_ops->overhead;
+	slave->needed_headroom = cpu_dp->tag_ops->needed_headroom;
+	slave->needed_tailroom = cpu_dp->tag_ops->needed_tailroom;
 	/* Try to save one extra realloc later in the TX path (in the master)
 	 * by also inheriting the master's needed headroom and tailroom.
 	 * The 8021q driver also does this.
diff --git a/net/dsa/tag_ar9331.c b/net/dsa/tag_ar9331.c
index 002cf7f952e2..0efae1a372b3 100644
--- a/net/dsa/tag_ar9331.c
+++ b/net/dsa/tag_ar9331.c
@@ -85,7 +85,7 @@ static const struct dsa_device_ops ar9331_netdev_ops = {
 	.proto	= DSA_TAG_PROTO_AR9331,
 	.xmit	= ar9331_tag_xmit,
 	.rcv	= ar9331_tag_rcv,
-	.overhead = AR9331_HDR_LEN,
+	.needed_headroom = AR9331_HDR_LEN,
 };
 
 MODULE_LICENSE("GPL v2");
diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index 40e9f3098c8d..0750af951fc9 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -205,7 +205,7 @@ static const struct dsa_device_ops brcm_netdev_ops = {
 	.proto	= DSA_TAG_PROTO_BRCM,
 	.xmit	= brcm_tag_xmit,
 	.rcv	= brcm_tag_rcv,
-	.overhead = BRCM_TAG_LEN,
+	.needed_headroom = BRCM_TAG_LEN,
 };
 
 DSA_TAG_DRIVER(brcm_netdev_ops);
@@ -286,7 +286,7 @@ static const struct dsa_device_ops brcm_legacy_netdev_ops = {
 	.proto = DSA_TAG_PROTO_BRCM_LEGACY,
 	.xmit = brcm_leg_tag_xmit,
 	.rcv = brcm_leg_tag_rcv,
-	.overhead = BRCM_LEG_TAG_LEN,
+	.needed_headroom = BRCM_LEG_TAG_LEN,
 };
 
 DSA_TAG_DRIVER(brcm_legacy_netdev_ops);
@@ -314,7 +314,7 @@ static const struct dsa_device_ops brcm_prepend_netdev_ops = {
 	.proto	= DSA_TAG_PROTO_BRCM_PREPEND,
 	.xmit	= brcm_tag_xmit_prepend,
 	.rcv	= brcm_tag_rcv_prepend,
-	.overhead = BRCM_TAG_LEN,
+	.needed_headroom = BRCM_TAG_LEN,
 };
 
 DSA_TAG_DRIVER(brcm_prepend_netdev_ops);
diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index 7e7b7decdf39..a822355afc90 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -303,7 +303,7 @@ static const struct dsa_device_ops dsa_netdev_ops = {
 	.proto	  = DSA_TAG_PROTO_DSA,
 	.xmit	  = dsa_xmit,
 	.rcv	  = dsa_rcv,
-	.overhead = DSA_HLEN,
+	.needed_headroom = DSA_HLEN,
 };
 
 DSA_TAG_DRIVER(dsa_netdev_ops);
@@ -346,7 +346,7 @@ static const struct dsa_device_ops edsa_netdev_ops = {
 	.proto	  = DSA_TAG_PROTO_EDSA,
 	.xmit	  = edsa_xmit,
 	.rcv	  = edsa_rcv,
-	.overhead = EDSA_HLEN,
+	.needed_headroom = EDSA_HLEN,
 };
 
 DSA_TAG_DRIVER(edsa_netdev_ops);
diff --git a/net/dsa/tag_gswip.c b/net/dsa/tag_gswip.c
index 2f5bd5e338ab..5985dab06ab8 100644
--- a/net/dsa/tag_gswip.c
+++ b/net/dsa/tag_gswip.c
@@ -103,7 +103,7 @@ static const struct dsa_device_ops gswip_netdev_ops = {
 	.proto	= DSA_TAG_PROTO_GSWIP,
 	.xmit = gswip_tag_xmit,
 	.rcv = gswip_tag_rcv,
-	.overhead = GSWIP_RX_HEADER_LEN,
+	.needed_headroom = GSWIP_RX_HEADER_LEN,
 };
 
 MODULE_LICENSE("GPL");
diff --git a/net/dsa/tag_hellcreek.c b/net/dsa/tag_hellcreek.c
index a09805c8e1ab..424130f85f59 100644
--- a/net/dsa/tag_hellcreek.c
+++ b/net/dsa/tag_hellcreek.c
@@ -54,8 +54,7 @@ static const struct dsa_device_ops hellcreek_netdev_ops = {
 	.proto	  = DSA_TAG_PROTO_HELLCREEK,
 	.xmit	  = hellcreek_xmit,
 	.rcv	  = hellcreek_rcv,
-	.overhead = HELLCREEK_TAG_LEN,
-	.tail_tag = true,
+	.needed_tailroom = HELLCREEK_TAG_LEN,
 };
 
 MODULE_LICENSE("Dual MIT/GPL");
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 4820dbcedfa2..53565f48934c 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -77,8 +77,7 @@ static const struct dsa_device_ops ksz8795_netdev_ops = {
 	.proto	= DSA_TAG_PROTO_KSZ8795,
 	.xmit	= ksz8795_xmit,
 	.rcv	= ksz8795_rcv,
-	.overhead = KSZ_INGRESS_TAG_LEN,
-	.tail_tag = true,
+	.needed_tailroom = KSZ_INGRESS_TAG_LEN,
 };
 
 DSA_TAG_DRIVER(ksz8795_netdev_ops);
@@ -149,8 +148,7 @@ static const struct dsa_device_ops ksz9477_netdev_ops = {
 	.proto	= DSA_TAG_PROTO_KSZ9477,
 	.xmit	= ksz9477_xmit,
 	.rcv	= ksz9477_rcv,
-	.overhead = KSZ9477_INGRESS_TAG_LEN,
-	.tail_tag = true,
+	.needed_tailroom = KSZ9477_INGRESS_TAG_LEN,
 };
 
 DSA_TAG_DRIVER(ksz9477_netdev_ops);
@@ -183,8 +181,7 @@ static const struct dsa_device_ops ksz9893_netdev_ops = {
 	.proto	= DSA_TAG_PROTO_KSZ9893,
 	.xmit	= ksz9893_xmit,
 	.rcv	= ksz9477_rcv,
-	.overhead = KSZ_INGRESS_TAG_LEN,
-	.tail_tag = true,
+	.needed_tailroom = KSZ_INGRESS_TAG_LEN,
 };
 
 DSA_TAG_DRIVER(ksz9893_netdev_ops);
diff --git a/net/dsa/tag_lan9303.c b/net/dsa/tag_lan9303.c
index aa1318dccaf0..26207ef39ebc 100644
--- a/net/dsa/tag_lan9303.c
+++ b/net/dsa/tag_lan9303.c
@@ -125,7 +125,7 @@ static const struct dsa_device_ops lan9303_netdev_ops = {
 	.proto	= DSA_TAG_PROTO_LAN9303,
 	.xmit = lan9303_xmit,
 	.rcv = lan9303_rcv,
-	.overhead = LAN9303_TAG_LEN,
+	.needed_headroom = LAN9303_TAG_LEN,
 };
 
 MODULE_LICENSE("GPL");
diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
index f9b2966d1936..cc3ba864ad5b 100644
--- a/net/dsa/tag_mtk.c
+++ b/net/dsa/tag_mtk.c
@@ -102,7 +102,7 @@ static const struct dsa_device_ops mtk_netdev_ops = {
 	.proto		= DSA_TAG_PROTO_MTK,
 	.xmit		= mtk_tag_xmit,
 	.rcv		= mtk_tag_rcv,
-	.overhead	= MTK_HDR_LEN,
+	.needed_headroom = MTK_HDR_LEN,
 };
 
 MODULE_LICENSE("GPL");
diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index 91f0fd1242cd..190f4bfd3bef 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -143,7 +143,7 @@ static const struct dsa_device_ops ocelot_netdev_ops = {
 	.proto			= DSA_TAG_PROTO_OCELOT,
 	.xmit			= ocelot_xmit,
 	.rcv			= ocelot_rcv,
-	.overhead		= OCELOT_TOTAL_TAG_LEN,
+	.needed_headroom	= OCELOT_TOTAL_TAG_LEN,
 	.promisc_on_master	= true,
 };
 
@@ -155,7 +155,7 @@ static const struct dsa_device_ops seville_netdev_ops = {
 	.proto			= DSA_TAG_PROTO_SEVILLE,
 	.xmit			= seville_xmit,
 	.rcv			= ocelot_rcv,
-	.overhead		= OCELOT_TOTAL_TAG_LEN,
+	.needed_headroom	= OCELOT_TOTAL_TAG_LEN,
 	.promisc_on_master	= true,
 };
 
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index 62a93303bd63..663b74793cfc 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -73,7 +73,7 @@ static const struct dsa_device_ops ocelot_8021q_netdev_ops = {
 	.proto			= DSA_TAG_PROTO_OCELOT_8021Q,
 	.xmit			= ocelot_xmit,
 	.rcv			= ocelot_rcv,
-	.overhead		= VLAN_HLEN,
+	.needed_headroom	= VLAN_HLEN,
 	.promisc_on_master	= true,
 };
 
diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index 88181b52f480..693bda013065 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -91,7 +91,7 @@ static const struct dsa_device_ops qca_netdev_ops = {
 	.proto	= DSA_TAG_PROTO_QCA,
 	.xmit	= qca_tag_xmit,
 	.rcv	= qca_tag_rcv,
-	.overhead = QCA_HDR_LEN,
+	.needed_headroom = QCA_HDR_LEN,
 };
 
 MODULE_LICENSE("GPL");
diff --git a/net/dsa/tag_rtl4_a.c b/net/dsa/tag_rtl4_a.c
index cf8ac316f4c7..57c46b4ab2b3 100644
--- a/net/dsa/tag_rtl4_a.c
+++ b/net/dsa/tag_rtl4_a.c
@@ -124,7 +124,7 @@ static const struct dsa_device_ops rtl4a_netdev_ops = {
 	.proto	= DSA_TAG_PROTO_RTL4_A,
 	.xmit	= rtl4a_tag_xmit,
 	.rcv	= rtl4a_tag_rcv,
-	.overhead = RTL4_A_HDR_LEN,
+	.needed_headroom = RTL4_A_HDR_LEN,
 };
 module_dsa_tag_driver(rtl4a_netdev_ops);
 
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 50496013cdb7..ff4a81eae16f 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -362,7 +362,7 @@ static const struct dsa_device_ops sja1105_netdev_ops = {
 	.xmit = sja1105_xmit,
 	.rcv = sja1105_rcv,
 	.filter = sja1105_filter,
-	.overhead = VLAN_HLEN,
+	.needed_headroom = VLAN_HLEN,
 	.flow_dissect = sja1105_flow_dissect,
 	.promisc_on_master = true,
 };
diff --git a/net/dsa/tag_trailer.c b/net/dsa/tag_trailer.c
index 5b97ede56a0f..ba73804340a5 100644
--- a/net/dsa/tag_trailer.c
+++ b/net/dsa/tag_trailer.c
@@ -55,8 +55,7 @@ static const struct dsa_device_ops trailer_netdev_ops = {
 	.proto	= DSA_TAG_PROTO_TRAILER,
 	.xmit	= trailer_xmit,
 	.rcv	= trailer_rcv,
-	.overhead = 4,
-	.tail_tag = true,
+	.needed_tailroom = 4,
 };
 
 MODULE_LICENSE("GPL");
diff --git a/net/dsa/tag_xrs700x.c b/net/dsa/tag_xrs700x.c
index 858cdf9d2913..a31ff7fcb45f 100644
--- a/net/dsa/tag_xrs700x.c
+++ b/net/dsa/tag_xrs700x.c
@@ -56,8 +56,7 @@ static const struct dsa_device_ops xrs700x_netdev_ops = {
 	.proto	= DSA_TAG_PROTO_XRS700X,
 	.xmit	= xrs700x_xmit,
 	.rcv	= xrs700x_rcv,
-	.overhead = 1,
-	.tail_tag = true,
+	.needed_tailroom = 1,
 };
 
 MODULE_LICENSE("GPL");
-- 
2.25.1

