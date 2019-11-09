Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F06DF5F44
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 14:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfKIND1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 08:03:27 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:32832 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbfKIND0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 08:03:26 -0500
Received: by mail-wm1-f65.google.com with SMTP id a17so8564344wmb.0
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 05:03:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xBAl4AUBK8/22/GUqPFGHk8/9GKUwvaze/TZI/UAA5Q=;
        b=nbkQMenhHASfo1+0WVDfqO3lEy8WaK4TUO+lo2Tu87143BCg3GXNRB/DpBGzo4ZBOM
         LD3hA8D7FkcQTwg3J8HLmYHP0ey6x4hCd+NhV2PmYPBJf8fowwE0KAxSbGoFjKR1b03I
         5V8jSq5rL80Tx9BEnzvFTzIBVQYkahpgS0FIjFnuE8bxdnpoFA+pCqun0rljrf0fqmit
         QBmhRATCbkdDwmamoXBjsmm8f1MTswAVACfX/4QkT/fsoQ+Zrq/A49MlmlgAvCbNy5R2
         Jllh9Cv8klkWj/T9TjdGcVDuYhOQzO8cyzjstJevzxRJqcwWawr4DKinvvfcz9sQONEs
         4SFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xBAl4AUBK8/22/GUqPFGHk8/9GKUwvaze/TZI/UAA5Q=;
        b=BMSivTBOOrz5Nai2bdKk34k3dLTHodUOoTvV1VRvUsB26irCuVZhUohJk1xpq9+0ZD
         /znc1431c3ahcVoIdYtZlEWzNaCPBPRk8Edk2wuQUJ1yGVG+xd846N5wnMN/t66ulhqX
         QqbcUQvdN+KVPy80XiQVNGUcpaP8QSegO0eqWeQ2d87iqdGEfjLAOaU5v04qkF3etaRM
         OkkL8YTa621D7BdhrHy6pVwKEeF/gyrmuIl8pES+Sll34CEAZRxtSyYI5e0/+vHAP+dv
         +W1HQSAR/SEP1q2O3JW3e6g2VwlbljnDC8HMYjRLYud7P8VbYnKYc4VkctISxAuyQD7R
         MR5A==
X-Gm-Message-State: APjAAAXAB5/ILfgxqBNfciFeuy/0wDDulGOYiHKBQYKuQEzqJDCUldt4
        bdfY5Iqui3+cjSwY1wlCj8g=
X-Google-Smtp-Source: APXvYqwNPacmmIQvPji2cXlYLR4yy7H/OspEsRIrKyOHevxGx0Iw9Ee35R0AnDLQEzSt3fUHLSidlw==
X-Received: by 2002:a1c:720b:: with SMTP id n11mr11646149wmc.60.1573304602830;
        Sat, 09 Nov 2019 05:03:22 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id n13sm8370908wmi.25.2019.11.09.05.03.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 05:03:22 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jakub.kicinski@netronome.com, davem@davemloft.net,
        alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 03/15] net: mscc: ocelot: break out fdb operations into abstract implementations
Date:   Sat,  9 Nov 2019 15:02:49 +0200
Message-Id: <20191109130301.13716-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191109130301.13716-1-olteanv@gmail.com>
References: <20191109130301.13716-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

To be able to implement a DSA front-end over ocelot_fdb_add,
ocelot_fdb_del, ocelot_fdb_dump, these need to have a simple function
prototype that is independent of struct net_device, netlink skb, etc.

So rename the ndo ops of the ocelot driver into
ocelot_port_fdb_{add,del,dump}, and have them all call the abstract
implementations. At the same time, refactor ocelot_port_fdb_do_dump into
a function whose prototype is compatible with dsa_fdb_dump_cb_t, so that
the do_dump implementations can live together and be called by the
ocelot_fdb_dump through a function pointer.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 124 ++++++++++++++++++-----------
 1 file changed, 78 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 5b9cde6d3e38..3e03c4dd80a0 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -21,6 +21,7 @@
 #include <net/netevent.h>
 #include <net/rtnetlink.h>
 #include <net/switchdev.h>
+#include <net/dsa.h>
 
 #include "ocelot.h"
 #include "ocelot_ace.h"
@@ -814,21 +815,18 @@ static void ocelot_get_stats64(struct net_device *dev,
 	stats->collisions = ocelot_read(ocelot, SYS_COUNT_TX_COLLISION);
 }
 
-static int ocelot_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
-			  struct net_device *dev, const unsigned char *addr,
-			  u16 vid, u16 flags,
-			  struct netlink_ext_ack *extack)
+static int ocelot_fdb_add(struct ocelot *ocelot, int port,
+			  const unsigned char *addr, u16 vid)
 {
-	struct ocelot_port *port = netdev_priv(dev);
-	struct ocelot *ocelot = port->ocelot;
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
 
 	if (!vid) {
-		if (!port->vlan_aware)
+		if (!ocelot_port->vlan_aware)
 			/* If the bridge is not VLAN aware and no VID was
 			 * provided, set it to pvid to ensure the MAC entry
 			 * matches incoming untagged packets
 			 */
-			vid = port->pvid;
+			vid = ocelot_port->pvid;
 		else
 			/* If the bridge is VLAN aware a VID must be provided as
 			 * otherwise the learnt entry wouldn't match any frame.
@@ -836,20 +834,37 @@ static int ocelot_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 			return -EINVAL;
 	}
 
-	return ocelot_mact_learn(ocelot, port->chip_port, addr, vid,
-				 ENTRYTYPE_LOCKED);
+	return ocelot_mact_learn(ocelot, port, addr, vid, ENTRYTYPE_LOCKED);
 }
 
-static int ocelot_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
-			  struct net_device *dev,
-			  const unsigned char *addr, u16 vid)
+static int ocelot_port_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
+			       struct net_device *dev,
+			       const unsigned char *addr,
+			       u16 vid, u16 flags,
+			       struct netlink_ext_ack *extack)
 {
-	struct ocelot_port *port = netdev_priv(dev);
-	struct ocelot *ocelot = port->ocelot;
+	struct ocelot_port *ocelot_port = netdev_priv(dev);
+	struct ocelot *ocelot = ocelot_port->ocelot;
+
+	return ocelot_fdb_add(ocelot, ocelot_port->chip_port, addr, vid);
+}
 
+static int ocelot_fdb_del(struct ocelot *ocelot, int port,
+			  const unsigned char *addr, u16 vid)
+{
 	return ocelot_mact_forget(ocelot, addr, vid);
 }
 
+static int ocelot_port_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
+			       struct net_device *dev,
+			       const unsigned char *addr, u16 vid)
+{
+	struct ocelot_port *ocelot_port = netdev_priv(dev);
+	struct ocelot *ocelot = ocelot_port->ocelot;
+
+	return ocelot_fdb_del(ocelot, ocelot_port->chip_port, addr, vid);
+}
+
 struct ocelot_dump_ctx {
 	struct net_device *dev;
 	struct sk_buff *skb;
@@ -857,9 +872,10 @@ struct ocelot_dump_ctx {
 	int idx;
 };
 
-static int ocelot_fdb_do_dump(struct ocelot_mact_entry *entry,
-			      struct ocelot_dump_ctx *dump)
+static int ocelot_port_fdb_do_dump(const unsigned char *addr, u16 vid,
+				   bool is_static, void *data)
 {
+	struct ocelot_dump_ctx *dump = data;
 	u32 portid = NETLINK_CB(dump->cb->skb).portid;
 	u32 seq = dump->cb->nlh->nlmsg_seq;
 	struct nlmsghdr *nlh;
@@ -880,12 +896,12 @@ static int ocelot_fdb_do_dump(struct ocelot_mact_entry *entry,
 	ndm->ndm_flags   = NTF_SELF;
 	ndm->ndm_type    = 0;
 	ndm->ndm_ifindex = dump->dev->ifindex;
-	ndm->ndm_state   = NUD_REACHABLE;
+	ndm->ndm_state   = is_static ? NUD_NOARP : NUD_REACHABLE;
 
-	if (nla_put(dump->skb, NDA_LLADDR, ETH_ALEN, entry->mac))
+	if (nla_put(dump->skb, NDA_LLADDR, ETH_ALEN, addr))
 		goto nla_put_failure;
 
-	if (entry->vid && nla_put_u16(dump->skb, NDA_VLAN, entry->vid))
+	if (vid && nla_put_u16(dump->skb, NDA_VLAN, vid))
 		goto nla_put_failure;
 
 	nlmsg_end(dump->skb, nlh);
@@ -899,12 +915,11 @@ static int ocelot_fdb_do_dump(struct ocelot_mact_entry *entry,
 	return -EMSGSIZE;
 }
 
-static inline int ocelot_mact_read(struct ocelot_port *port, int row, int col,
-				   struct ocelot_mact_entry *entry)
+static int ocelot_mact_read(struct ocelot *ocelot, int port, int row, int col,
+			    struct ocelot_mact_entry *entry)
 {
-	struct ocelot *ocelot = port->ocelot;
-	char mac[ETH_ALEN];
 	u32 val, dst, macl, mach;
+	char mac[ETH_ALEN];
 
 	/* Set row and column to read from */
 	ocelot_field_write(ocelot, ANA_TABLES_MACTINDX_M_INDEX, row);
@@ -927,7 +942,7 @@ static inline int ocelot_mact_read(struct ocelot_port *port, int row, int col,
 	 * do not report it.
 	 */
 	dst = (val & ANA_TABLES_MACACCESS_DEST_IDX_M) >> 3;
-	if (dst != port->chip_port)
+	if (dst != port)
 		return -EINVAL;
 
 	/* Get the entry's MAC address and VLAN id */
@@ -947,43 +962,60 @@ static inline int ocelot_mact_read(struct ocelot_port *port, int row, int col,
 	return 0;
 }
 
-static int ocelot_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb,
-			   struct net_device *dev,
-			   struct net_device *filter_dev, int *idx)
+static int ocelot_fdb_dump(struct ocelot *ocelot, int port,
+			   dsa_fdb_dump_cb_t *cb, void *data)
 {
-	struct ocelot_port *port = netdev_priv(dev);
-	int i, j, ret = 0;
-	struct ocelot_dump_ctx dump = {
-		.dev = dev,
-		.skb = skb,
-		.cb = cb,
-		.idx = *idx,
-	};
-
-	struct ocelot_mact_entry entry;
+	int i, j;
 
 	/* Loop through all the mac tables entries. There are 1024 rows of 4
 	 * entries.
 	 */
 	for (i = 0; i < 1024; i++) {
 		for (j = 0; j < 4; j++) {
-			ret = ocelot_mact_read(port, i, j, &entry);
+			struct ocelot_mact_entry entry;
+			bool is_static;
+			int ret;
+
+			ret = ocelot_mact_read(ocelot, port, i, j, &entry);
 			/* If the entry is invalid (wrong port, invalid...),
 			 * skip it.
 			 */
 			if (ret == -EINVAL)
 				continue;
 			else if (ret)
-				goto end;
+				return ret;
+
+			is_static = (entry.type == ENTRYTYPE_LOCKED);
 
-			ret = ocelot_fdb_do_dump(&entry, &dump);
+			ret = cb(entry.mac, entry.vid, is_static, data);
 			if (ret)
-				goto end;
+				return ret;
 		}
 	}
 
-end:
+	return 0;
+}
+
+static int ocelot_port_fdb_dump(struct sk_buff *skb,
+				struct netlink_callback *cb,
+				struct net_device *dev,
+				struct net_device *filter_dev, int *idx)
+{
+	struct ocelot_port *ocelot_port = netdev_priv(dev);
+	struct ocelot *ocelot = ocelot_port->ocelot;
+	struct ocelot_dump_ctx dump = {
+		.dev = dev,
+		.skb = skb,
+		.cb = cb,
+		.idx = *idx,
+	};
+	int ret;
+
+	ret = ocelot_fdb_dump(ocelot, ocelot_port->chip_port,
+			      ocelot_port_fdb_do_dump, &dump);
+
 	*idx = dump.idx;
+
 	return ret;
 }
 
@@ -1129,9 +1161,9 @@ static const struct net_device_ops ocelot_port_netdev_ops = {
 	.ndo_get_phys_port_name		= ocelot_port_get_phys_port_name,
 	.ndo_set_mac_address		= ocelot_port_set_mac_address,
 	.ndo_get_stats64		= ocelot_get_stats64,
-	.ndo_fdb_add			= ocelot_fdb_add,
-	.ndo_fdb_del			= ocelot_fdb_del,
-	.ndo_fdb_dump			= ocelot_fdb_dump,
+	.ndo_fdb_add			= ocelot_port_fdb_add,
+	.ndo_fdb_del			= ocelot_port_fdb_del,
+	.ndo_fdb_dump			= ocelot_port_fdb_dump,
 	.ndo_vlan_rx_add_vid		= ocelot_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid		= ocelot_vlan_rx_kill_vid,
 	.ndo_set_features		= ocelot_set_features,
-- 
2.17.1

