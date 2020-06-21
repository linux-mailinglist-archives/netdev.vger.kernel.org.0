Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F2A202A60
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 13:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730019AbgFULq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 07:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729986AbgFULqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 07:46:25 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56608C061794
        for <netdev@vger.kernel.org>; Sun, 21 Jun 2020 04:46:25 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id p18so11326771eds.7
        for <netdev@vger.kernel.org>; Sun, 21 Jun 2020 04:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xoL2PQI3jQWu4vfU0EC/ltsvc2tzYLZXkQsmez3Mjpw=;
        b=Pz/rvE0bnmhYWM86I/KkJQDDh0yDI55UGnQv3Dnnl5tdvgJ+4XXwK35DCttmzimCmf
         E/Z0VTGVFile7lrLfxuLJTzzE8Dx8BWKabUyaM4Tk7CcoF7uRUorIWs9Sibq9ru5bOgE
         PGQGRh12aZgd4/csot2gnWF+f5YRcqerQEF1UKUF7Hs0Ulb+vvyAHv9PDo9UctOPgS0y
         ViL4/yQ3BYse4qlp9c0amOfa2nrDK03itYVCTKB5Y3PBOalPWKsjuLCLr7OsSeo24WJH
         US2Nuvo26W0jemVS1tc83wy7N3xj5c6wMoFI7Ch6ku3I9xdTLHlXNE3FRfzeLpUQFv/J
         HtoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xoL2PQI3jQWu4vfU0EC/ltsvc2tzYLZXkQsmez3Mjpw=;
        b=dXqBoNVIyl4DMbrdziiBSz59JX9QFgnbirjHOfezfOzh32bpbrb+Eiwinw7AbJtwGF
         8GCvZpAlSEUUrIcm5DKw8MKi1bNWog9Xe4e+IsJgI1izCBCPFVwqLtYsVYb19nl9w7Bf
         285dF3aEq7mMkpNq+j2YjwkP3AHwKDJKO+eSubxt3kkbZCCFzxMrnBvDyTl0m6Jmml6R
         3+PHwJovTmj1HiCUCB42GlQPlwj9LegqtXAdrk1+4Q9JQtxVLLpLv3ns1i70w0rEkK4f
         gMG9zHRVoKRJMR2evbOCxunyco9zK2/I1JbsfC0N95CrQ6+qPZyI9eYslyvGHoXXiOyx
         EOHg==
X-Gm-Message-State: AOAM532Ee18pdYau8aqOqVuCNmzEkEYPliOzHSKlVd2vv7NeuHKZuTBj
        ArZzbJ2VU90BRaFVkCHj1NqgCsb6
X-Google-Smtp-Source: ABdhPJyCUxz8lzdsVnvwHfkG2yOZ9PvZ7LTvOqCpOPFgncE1vcT7rxIrf/UcctzBpVHzA6jx/wY2LQ==
X-Received: by 2002:aa7:c74e:: with SMTP id c14mr11807019eds.322.1592739984033;
        Sun, 21 Jun 2020 04:46:24 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id k23sm9155508ejg.89.2020.06.21.04.46.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2020 04:46:23 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     UNGLinuxDriver@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com
Subject: [PATCH net-next 5/5] net: mscc: ocelot: support IPv4, IPv6 and plain Ethernet mdb entries
Date:   Sun, 21 Jun 2020 14:46:03 +0300
Message-Id: <20200621114603.119608-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200621114603.119608-1-olteanv@gmail.com>
References: <20200621114603.119608-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The current procedure for installing a multicast address is hardcoded
for IPv4. But, in the ocelot hardware, there are 3 different procedures
for IPv4, IPv6 and for regular L2 multicast.

For IPv6 (33-33-xx-xx-xx-xx), it's the same as for IPv4
(01-00-5e-xx-xx-xx), except that the destination port mask is stuffed
into first 2 bytes of the MAC address except into first 3 bytes.

For plain Ethernet multicast, there's no port-in-address stuffing going
on, instead the DEST_IDX (pointer to PGID) is used there, just as for
unicast. So we have to use one of the nonreserved multicast PGIDs that
the hardware has allocated for this purpose.

This patch classifies the type of multicast address based on its first
bytes, then redirects to one of the 3 different hardware procedures.

Note that this gives us a really better way of redirecting PTP frames
sent at 01-1b-19-00-00-00 to the CPU. Previously, Yangbo Lu tried to add
a trapping rule for PTP EtherType but got a lot of pushback:

https://patchwork.ozlabs.org/project/netdev/patch/20190813025214.18601-5-yangbo.lu@nxp.com/

But right now, that isn't needed at all. The application stack (ptp4l)
does this for the PTP multicast addresses it's interested in (which are
configurable, and include 01-1b-19-00-00-00):

	memset(&mreq, 0, sizeof(mreq));
	mreq.mr_ifindex = index;
	mreq.mr_type = PACKET_MR_MULTICAST;
	mreq.mr_alen = MAC_LEN;
	memcpy(mreq.mr_address, addr1, MAC_LEN);

	err1 = setsockopt(fd, SOL_PACKET, PACKET_ADD_MEMBERSHIP, &mreq,
			  sizeof(mreq));

Into the kernel, this translates into a dev_mc_add on the switch network
interfaces, and our drivers know that it means they should translate it
into a host MDB address (make the CPU port be the destination).
Previously, this was broken because all mdb addresses were treated as
IPv4 (which 01-1b-19-00-00-00 obviously is not).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 94 +++++++++++++++++++++++++-----
 drivers/net/ethernet/mscc/ocelot.h |  1 +
 2 files changed, 80 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index b6254c20f2f0..e815aad8d85e 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -944,10 +944,68 @@ static struct ocelot_multicast *ocelot_multicast_get(struct ocelot *ocelot,
 	return NULL;
 }
 
+static enum macaccess_entry_type ocelot_classify_mdb(const unsigned char *addr)
+{
+	if (addr[0] == 0x01 && addr[1] == 0x00 && addr[2] == 0x5e)
+		return ENTRYTYPE_MACv4;
+	if (addr[0] == 0x33 && addr[1] == 0x33)
+		return ENTRYTYPE_MACv6;
+	return ENTRYTYPE_NORMAL;
+}
+
+static int ocelot_mdb_get_pgid(struct ocelot *ocelot,
+			       enum macaccess_entry_type entry_type)
+{
+	int pgid;
+
+	/* According to VSC7514 datasheet 3.9.1.5 IPv4 Multicast Entries and
+	 * 3.9.1.6 IPv6 Multicast Entries, "Instead of a lookup in the
+	 * destination mask table (PGID), the destination set is programmed as
+	 * part of the entry MAC address.", and the DEST_IDX is set to 0.
+	 */
+	if (entry_type == ENTRYTYPE_MACv4 ||
+	    entry_type == ENTRYTYPE_MACv6)
+		return 0;
+
+	for_each_nonreserved_multicast_dest_pgid(ocelot, pgid) {
+		struct ocelot_multicast *mc;
+		bool used = false;
+
+		list_for_each_entry(mc, &ocelot->multicast, list) {
+			if (mc->pgid == pgid) {
+				used = true;
+				break;
+			}
+		}
+
+		if (!used)
+			return pgid;
+	}
+
+	return -1;
+}
+
+static void ocelot_encode_ports_to_mdb(unsigned char *addr,
+				       struct ocelot_multicast *mc,
+				       enum macaccess_entry_type entry_type)
+{
+	memcpy(addr, mc->addr, ETH_ALEN);
+
+	if (entry_type == ENTRYTYPE_MACv4) {
+		addr[0] = 0;
+		addr[1] = mc->ports >> 8;
+		addr[2] = mc->ports & 0xff;
+	} else if (entry_type == ENTRYTYPE_MACv6) {
+		addr[0] = mc->ports >> 8;
+		addr[1] = mc->ports & 0xff;
+	}
+}
+
 int ocelot_port_mdb_add(struct ocelot *ocelot, int port,
 			const struct switchdev_obj_port_mdb *mdb)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	enum macaccess_entry_type entry_type;
 	unsigned char addr[ETH_ALEN];
 	struct ocelot_multicast *mc;
 	u16 vid = mdb->vid;
@@ -959,33 +1017,40 @@ int ocelot_port_mdb_add(struct ocelot *ocelot, int port,
 	if (!vid)
 		vid = ocelot_port->pvid;
 
+	entry_type = ocelot_classify_mdb(mdb->addr);
+
 	mc = ocelot_multicast_get(ocelot, mdb->addr, vid);
 	if (!mc) {
+		int pgid = ocelot_mdb_get_pgid(ocelot, entry_type);
+
+		if (pgid < 0) {
+			dev_err(ocelot->dev,
+				"No more PGIDs available for mdb %pM vid %d\n",
+				mdb->addr, vid);
+			return -ENOSPC;
+		}
+
 		mc = devm_kzalloc(ocelot->dev, sizeof(*mc), GFP_KERNEL);
 		if (!mc)
 			return -ENOMEM;
 
 		memcpy(mc->addr, mdb->addr, ETH_ALEN);
 		mc->vid = vid;
+		mc->pgid = pgid;
 
 		list_add_tail(&mc->list, &ocelot->multicast);
 		new = true;
 	}
 
-	memcpy(addr, mc->addr, ETH_ALEN);
-	addr[0] = 0;
-
 	if (!new) {
-		addr[1] = mc->ports >> 8;
-		addr[2] = mc->ports & 0xff;
+		ocelot_encode_ports_to_mdb(addr, mc, entry_type);
 		ocelot_mact_forget(ocelot, addr, vid);
 	}
 
 	mc->ports |= BIT(port);
-	addr[1] = mc->ports >> 8;
-	addr[2] = mc->ports & 0xff;
+	ocelot_encode_ports_to_mdb(addr, mc, entry_type);
 
-	return ocelot_mact_learn(ocelot, 0, addr, vid, ENTRYTYPE_MACv4);
+	return ocelot_mact_learn(ocelot, mc->pgid, addr, vid, entry_type);
 }
 EXPORT_SYMBOL(ocelot_port_mdb_add);
 
@@ -993,6 +1058,7 @@ int ocelot_port_mdb_del(struct ocelot *ocelot, int port,
 			const struct switchdev_obj_port_mdb *mdb)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	enum macaccess_entry_type entry_type;
 	unsigned char addr[ETH_ALEN];
 	struct ocelot_multicast *mc;
 	u16 vid = mdb->vid;
@@ -1007,10 +1073,9 @@ int ocelot_port_mdb_del(struct ocelot *ocelot, int port,
 	if (!mc)
 		return -ENOENT;
 
-	memcpy(addr, mc->addr, ETH_ALEN);
-	addr[0] = 0;
-	addr[1] = mc->ports >> 8;
-	addr[2] = mc->ports & 0xff;
+	entry_type = ocelot_classify_mdb(mdb->addr);
+
+	ocelot_encode_ports_to_mdb(addr, mc, entry_type);
 	ocelot_mact_forget(ocelot, addr, vid);
 
 	mc->ports &= ~BIT(port);
@@ -1020,10 +1085,9 @@ int ocelot_port_mdb_del(struct ocelot *ocelot, int port,
 		return 0;
 	}
 
-	addr[1] = mc->ports >> 8;
-	addr[2] = mc->ports & 0xff;
+	ocelot_encode_ports_to_mdb(addr, mc, entry_type);
 
-	return ocelot_mact_learn(ocelot, 0, addr, vid, ENTRYTYPE_MACv4);
+	return ocelot_mact_learn(ocelot, mc->pgid, addr, vid, entry_type);
 }
 EXPORT_SYMBOL(ocelot_port_mdb_del);
 
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index be4a41646e5e..394362e23c47 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -46,6 +46,7 @@ struct ocelot_multicast {
 	unsigned char addr[ETH_ALEN];
 	u16 vid;
 	u16 ports;
+	int pgid;
 };
 
 struct ocelot_port_tc {
-- 
2.25.1

