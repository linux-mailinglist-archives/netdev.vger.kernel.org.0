Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12CE012359
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 22:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbfEBU0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 16:26:19 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36262 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbfEBUYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 16:24:44 -0400
Received: by mail-wm1-f66.google.com with SMTP id p16so4264378wma.1;
        Thu, 02 May 2019 13:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pXNiZxIEuEOGBjBjl3rt3BvTIVi3TdYeNLIHWzLdBAY=;
        b=SsG7w01ypay02w0KvFdNyh+EkmM7NzFndJBaLaPv6RBWLZd1mB67zgPrsE6ODtmMAS
         ZikijICubGa9WL3qHkoNfSz3hdVhadvEcLpiIzotC/Gxim68iQ+w7AVUeyM3QqK0wwJ9
         sCNhRbCUHRRnqjL36SIA39fHtP8ds6VgiwaF44fZDNqw23kYwXeOUaUb4Vo7v3j9eOB6
         P72pAimvxaT7OEJy043/ZTW8lSE9rf1qRoJPVdotLw4Mmh33KKqs76gkxUJBSKmkiTie
         1PuRJcm8i4/Bb/s8DYCRaOWsvpdhMgGU+erlj/413ku2cYY//9OB8Ul4APO4W3PuY0cO
         Ww9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pXNiZxIEuEOGBjBjl3rt3BvTIVi3TdYeNLIHWzLdBAY=;
        b=G+I6FgyxecjGSWR6H7t2PTzPMEG9TiLSo19wsjmpaH8gWBhonvjZY0u38ylas1lJxr
         BsI2KqbEz+BjCpCb4fr17Lc7DNeWwSLdfGwsceUU+knlF10emZmuduWeoAxzwKfBJQ2s
         uGX0Kw2hZMpn7XWIpAbvMKS1ryRUQEV3eblB9HrFUldMRGhQWbPvK1g1RlVg8sgleH9t
         n0ZGX0Ttc91hWLJnnM21U4zGZfO3wlPslPn+XPOycqxUz7Mi1c0WK70nJrnXH7Pz+Jl0
         Za6b2EfXp3/453J3VzXx+mV5L2qRpvqj+5meFCghEFhQonbAviWJTnIx7hzUFrnRx8U5
         Meww==
X-Gm-Message-State: APjAAAVPx2813ZuUos895ero39A1VeS0vzt/dTcOxA9z1G13GjXTun96
        oMuAer5EM+e33c21nNIhwVM=
X-Google-Smtp-Source: APXvYqwisijWSO0ns4damRt2bAbGcBZz4sqzRuoY7liU2HA66AHH7Cwhz3fb80jVuYnN14P1mOTCZw==
X-Received: by 2002:a1c:f119:: with SMTP id p25mr3626510wmh.4.1556828680948;
        Thu, 02 May 2019 13:24:40 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id s124sm217655wmf.42.2019.05.02.13.24.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 13:24:40 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v5 net-next 03/12] net: dsa: sja1105: Add support for FDB and MDB management
Date:   Thu,  2 May 2019 23:23:31 +0300
Message-Id: <20190502202340.21054-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190502202340.21054-1-olteanv@gmail.com>
References: <20190502202340.21054-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently only the (more difficult) first generation E/T series is
supported. Here the TCAM is only 4-way associative, and to know where
the hardware will search for a FDB entry, we need to perform the same
hash algorithm in order to install the entry in the correct bin.

On P/Q/R/S, the TCAM should be fully associative. However the SPI
command interface is different, and because I don't have access to a
new-generation device at the moment, support for it is TODO.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v5:
Stripped blank lines at the end of files.

Changes from v4:
Added prefix to crc8_add function name, renamed "index_in_bin" into
"way", got rid of #undef, turned macros into functions.

Changes from v3:
None

Changes from v2:
None

 drivers/net/dsa/sja1105/sja1105.h             |   2 +
 .../net/dsa/sja1105/sja1105_dynamic_config.c  |  43 ++++
 drivers/net/dsa/sja1105/sja1105_main.c        | 194 ++++++++++++++++++
 3 files changed, 239 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index e01cb854cbcd..50ab9282c4f1 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -123,6 +123,8 @@ int sja1105_dynamic_config_write(struct sja1105_private *priv,
 				 enum sja1105_blk_idx blk_idx,
 				 int index, void *entry, bool keep);
 
+u8 sja1105_fdb_hash(struct sja1105_private *priv, const u8 *addr, u16 vid);
+
 /* Common implementations for the static and dynamic configs */
 size_t sja1105_l2_forwarding_entry_packing(void *buf, void *entry_ptr,
 					   enum packing_op op);
diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
index d8f145488063..e73ab28bf632 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
@@ -487,3 +487,46 @@ int sja1105_dynamic_config_write(struct sja1105_private *priv,
 
 	return 0;
 }
+
+static u8 sja1105_crc8_add(u8 crc, u8 byte, u8 poly)
+{
+	int i;
+
+	for (i = 0; i < 8; i++) {
+		if ((crc ^ byte) & (1 << 7)) {
+			crc <<= 1;
+			crc ^= poly;
+		} else {
+			crc <<= 1;
+		}
+		byte <<= 1;
+	}
+	return crc;
+}
+
+/* CRC8 algorithm with non-reversed input, non-reversed output,
+ * no input xor and no output xor. Code customized for receiving
+ * the SJA1105 E/T FDB keys (vlanid, macaddr) as input. CRC polynomial
+ * is also received as argument in the Koopman notation that the switch
+ * hardware stores it in.
+ */
+u8 sja1105_fdb_hash(struct sja1105_private *priv, const u8 *addr, u16 vid)
+{
+	struct sja1105_l2_lookup_params_entry *l2_lookup_params =
+		priv->static_config.tables[BLK_IDX_L2_LOOKUP_PARAMS].entries;
+	u64 poly_koopman = l2_lookup_params->poly;
+	/* Convert polynomial from Koopman to 'normal' notation */
+	u8 poly = (u8)(1 + (poly_koopman << 1));
+	u64 vlanid = l2_lookup_params->shared_learn ? 0 : vid;
+	u64 input = (vlanid << 48) | ether_addr_to_u64(addr);
+	u8 crc = 0; /* seed */
+	int i;
+
+	/* Mask the eight bytes starting from MSB one at a time */
+	for (i = 56; i >= 0; i -= 8) {
+		u8 byte = (input & (0xffull << i)) >> i;
+
+		crc = sja1105_crc8_add(crc, byte, poly);
+	}
+	return crc;
+}
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 7d2ad2db0d88..ec8137eff223 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -179,6 +179,9 @@ static int sja1105_init_static_fdb(struct sja1105_private *priv)
 
 	table = &priv->static_config.tables[BLK_IDX_L2_LOOKUP];
 
+	/* We only populate the FDB table through dynamic
+	 * L2 Address Lookup entries
+	 */
 	if (table->entry_count) {
 		kfree(table->entries);
 		table->entry_count = 0;
@@ -689,6 +692,191 @@ static void sja1105_adjust_link(struct dsa_switch *ds, int port,
 		sja1105_adjust_port_config(priv, port, phydev->speed, true);
 }
 
+/* First-generation switches have a 4-way set associative TCAM that
+ * holds the FDB entries. An FDB index spans from 0 to 1023 and is comprised of
+ * a "bin" (grouping of 4 entries) and a "way" (an entry within a bin).
+ * For the placement of a newly learnt FDB entry, the switch selects the bin
+ * based on a hash function, and the way within that bin incrementally.
+ */
+static inline int sja1105et_fdb_index(int bin, int way)
+{
+	return bin * SJA1105ET_FDB_BIN_SIZE + way;
+}
+
+static int sja1105_is_fdb_entry_in_bin(struct sja1105_private *priv, int bin,
+				       const u8 *addr, u16 vid,
+				       struct sja1105_l2_lookup_entry *match,
+				       int *last_unused)
+{
+	int way;
+
+	for (way = 0; way < SJA1105ET_FDB_BIN_SIZE; way++) {
+		struct sja1105_l2_lookup_entry l2_lookup = {0};
+		int index = sja1105et_fdb_index(bin, way);
+
+		/* Skip unused entries, optionally marking them
+		 * into the return value
+		 */
+		if (sja1105_dynamic_config_read(priv, BLK_IDX_L2_LOOKUP,
+						index, &l2_lookup)) {
+			if (last_unused)
+				*last_unused = way;
+			continue;
+		}
+
+		if (l2_lookup.macaddr == ether_addr_to_u64(addr) &&
+		    l2_lookup.vlanid == vid) {
+			if (match)
+				*match = l2_lookup;
+			return way;
+		}
+	}
+	/* Return an invalid entry index if not found */
+	return -1;
+}
+
+static int sja1105_fdb_add(struct dsa_switch *ds, int port,
+			   const unsigned char *addr, u16 vid)
+{
+	struct sja1105_l2_lookup_entry l2_lookup = {0};
+	struct sja1105_private *priv = ds->priv;
+	struct device *dev = ds->dev;
+	int last_unused = -1;
+	int bin, way;
+
+	bin = sja1105_fdb_hash(priv, addr, vid);
+
+	way = sja1105_is_fdb_entry_in_bin(priv, bin, addr, vid,
+					  &l2_lookup, &last_unused);
+	if (way >= 0) {
+		/* We have an FDB entry. Is our port in the destination
+		 * mask? If yes, we need to do nothing. If not, we need
+		 * to rewrite the entry by adding this port to it.
+		 */
+		if (l2_lookup.destports & BIT(port))
+			return 0;
+		l2_lookup.destports |= BIT(port);
+	} else {
+		int index = sja1105et_fdb_index(bin, way);
+
+		/* We don't have an FDB entry. We construct a new one and
+		 * try to find a place for it within the FDB table.
+		 */
+		l2_lookup.macaddr = ether_addr_to_u64(addr);
+		l2_lookup.destports = BIT(port);
+		l2_lookup.vlanid = vid;
+
+		if (last_unused >= 0) {
+			way = last_unused;
+		} else {
+			/* Bin is full, need to evict somebody.
+			 * Choose victim at random. If you get these messages
+			 * often, you may need to consider changing the
+			 * distribution function:
+			 * static_config[BLK_IDX_L2_LOOKUP_PARAMS].entries->poly
+			 */
+			get_random_bytes(&way, sizeof(u8));
+			way %= SJA1105ET_FDB_BIN_SIZE;
+			dev_warn(dev, "Warning, FDB bin %d full while adding entry for %pM. Evicting entry %u.\n",
+				 bin, addr, way);
+			/* Evict entry */
+			sja1105_dynamic_config_write(priv, BLK_IDX_L2_LOOKUP,
+						     index, NULL, false);
+		}
+	}
+	l2_lookup.index = sja1105et_fdb_index(bin, way);
+
+	return sja1105_dynamic_config_write(priv, BLK_IDX_L2_LOOKUP,
+					    l2_lookup.index, &l2_lookup,
+					    true);
+}
+
+static int sja1105_fdb_del(struct dsa_switch *ds, int port,
+			   const unsigned char *addr, u16 vid)
+{
+	struct sja1105_l2_lookup_entry l2_lookup = {0};
+	struct sja1105_private *priv = ds->priv;
+	int index, bin, way;
+	bool keep;
+
+	bin = sja1105_fdb_hash(priv, addr, vid);
+	way = sja1105_is_fdb_entry_in_bin(priv, bin, addr, vid,
+					  &l2_lookup, NULL);
+	if (way < 0)
+		return 0;
+	index = sja1105et_fdb_index(bin, way);
+
+	/* We have an FDB entry. Is our port in the destination mask? If yes,
+	 * we need to remove it. If the resulting port mask becomes empty, we
+	 * need to completely evict the FDB entry.
+	 * Otherwise we just write it back.
+	 */
+	if (l2_lookup.destports & BIT(port))
+		l2_lookup.destports &= ~BIT(port);
+	if (l2_lookup.destports)
+		keep = true;
+	else
+		keep = false;
+
+	return sja1105_dynamic_config_write(priv, BLK_IDX_L2_LOOKUP,
+					    index, &l2_lookup, keep);
+}
+
+static int sja1105_fdb_dump(struct dsa_switch *ds, int port,
+			    dsa_fdb_dump_cb_t *cb, void *data)
+{
+	struct sja1105_private *priv = ds->priv;
+	struct device *dev = ds->dev;
+	int i;
+
+	for (i = 0; i < SJA1105_MAX_L2_LOOKUP_COUNT; i++) {
+		struct sja1105_l2_lookup_entry l2_lookup = {0};
+		u8 macaddr[ETH_ALEN];
+		int rc;
+
+		rc = sja1105_dynamic_config_read(priv, BLK_IDX_L2_LOOKUP,
+						 i, &l2_lookup);
+		/* No fdb entry at i, not an issue */
+		if (rc == -EINVAL)
+			continue;
+		if (rc) {
+			dev_err(dev, "Failed to dump FDB: %d\n", rc);
+			return rc;
+		}
+
+		/* FDB dump callback is per port. This means we have to
+		 * disregard a valid entry if it's not for this port, even if
+		 * only to revisit it later. This is inefficient because the
+		 * 1024-sized FDB table needs to be traversed 4 times through
+		 * SPI during a 'bridge fdb show' command.
+		 */
+		if (!(l2_lookup.destports & BIT(port)))
+			continue;
+		u64_to_ether_addr(l2_lookup.macaddr, macaddr);
+		cb(macaddr, l2_lookup.vlanid, false, data);
+	}
+	return 0;
+}
+
+/* This callback needs to be present */
+static int sja1105_mdb_prepare(struct dsa_switch *ds, int port,
+			       const struct switchdev_obj_port_mdb *mdb)
+{
+	return 0;
+}
+
+static void sja1105_mdb_add(struct dsa_switch *ds, int port,
+			    const struct switchdev_obj_port_mdb *mdb)
+{
+	sja1105_fdb_add(ds, port, mdb->addr, mdb->vid);
+}
+
+static int sja1105_mdb_del(struct dsa_switch *ds, int port,
+			   const struct switchdev_obj_port_mdb *mdb)
+{
+	return sja1105_fdb_del(ds, port, mdb->addr, mdb->vid);
+}
+
 static int sja1105_bridge_member(struct dsa_switch *ds, int port,
 				 struct net_device *br, bool member)
 {
@@ -791,8 +979,14 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.get_tag_protocol	= sja1105_get_tag_protocol,
 	.setup			= sja1105_setup,
 	.adjust_link		= sja1105_adjust_link,
+	.port_fdb_dump		= sja1105_fdb_dump,
+	.port_fdb_add		= sja1105_fdb_add,
+	.port_fdb_del		= sja1105_fdb_del,
 	.port_bridge_join	= sja1105_bridge_join,
 	.port_bridge_leave	= sja1105_bridge_leave,
+	.port_mdb_prepare	= sja1105_mdb_prepare,
+	.port_mdb_add		= sja1105_mdb_add,
+	.port_mdb_del		= sja1105_mdb_del,
 };
 
 static int sja1105_check_device_id(struct sja1105_private *priv)
-- 
2.17.1

