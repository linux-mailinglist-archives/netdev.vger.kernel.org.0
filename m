Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22CD655C6D
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 01:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbfFYXkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 19:40:12 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42294 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbfFYXkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 19:40:11 -0400
Received: by mail-wr1-f66.google.com with SMTP id x17so493046wrl.9
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 16:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=F4lhVnUFKsOiOiaPeD9LH8pqJ89tDTyJAo/B/2V1/Jk=;
        b=SjthHPT/mwSWmLXyJwwLAoDUfjs/Xj3t53iJjHNPLe7+s5qNJlyP/lMJ6OlamQOa/F
         M9K1IUX6beSPeQ6xk5+PMANDsIaKHOmWvw8puFiV/aSUtSSlavZsrr2+Fc3rGDx4lZYz
         FJm3YfwxKoADOQA8gMdzOYtqq7qLoe0xk/dSWbldepfFKIErnDxNACUnxyQWFgrDfBFy
         XFd13o99Q1xBRcXSQB0gjk9jkLfwg9hf2xCySWZos/D6vl5qxAAhRDIisz7gws0UlGg8
         TN4AekBOc0E+OPTFZGlc7lMPnhJtpyl++tKtDg0Wt7WrB1T6K1MRfVh5NfufLGCp/0wY
         F3sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=F4lhVnUFKsOiOiaPeD9LH8pqJ89tDTyJAo/B/2V1/Jk=;
        b=PepouZvbGx1Mn9VvUNM+fEmVlGGsxAiFX91MownABYP1W8bIiKPthxU8b8Do7q+/FG
         2+aseVLnDIwVjKMphON+SjcOo/f0I3xWYmD5/X7MwddSNETiU9AWNdliD1q3d5ont5sp
         fGx7hzI01CRnsQZpIl99lk1WaHomEWSukjz062gscTzy8c+8air91aMfj3+0mGzcMkeC
         Dv8DLtTy6xa0A4Pn8zkGgGLKCvoxkUdZ2UnbfzKcC7DmpbdUij6HThxvZ6YqKdb43ZFR
         RYZhd7bM70X0VSV2DCDBwm6HMpjkiDaJYq50YFQnM9EFN6H1PuRf2XSVx8VOFxFckV6O
         vN+g==
X-Gm-Message-State: APjAAAWnox2q5ZKMQQggMMhMx6D3a6AQ4ca6dOBfWvYjE6JoBApx3nTp
        qEvYpnAzO3d/9rNY8DrVG1I=
X-Google-Smtp-Source: APXvYqxBWaNu1F5Gvn+355cELPW5rhXI3iq8Vp5IwwdDv82cZ66eu/f0i+V146k5a9hKjxqxITl7XA==
X-Received: by 2002:adf:e490:: with SMTP id i16mr478135wrm.280.1561506009316;
        Tue, 25 Jun 2019 16:40:09 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id p3sm10810949wrd.47.2019.06.25.16.40.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 16:40:08 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 06/10] net: dsa: sja1105: Back up static FDB entries in kernel memory
Date:   Wed, 26 Jun 2019 02:39:38 +0300
Message-Id: <20190625233942.1946-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190625233942.1946-1-olteanv@gmail.com>
References: <20190625233942.1946-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 8456721dd4ec ("net: dsa: sja1105: Add support for
configuring address ageing time"), we started to reset the switch rather
often (each time the bridge core changes the ageing time on a switch
port).

The unfortunate reality is that SJA1105 doesn't have any {cold, warm,
whatever} reset mode in which it accepts a new configuration stream
without flushing the FDB.  Instead, in its world, the FDB *is* an
optional part of the static configuration.

So we play its game, and do what we also do for VLANs: for each 'bridge
fdb' command, we add the FDB entry through the dynamic interface, and we
append the in-kernel static config memory with info that we're going to
use later, when the next reset command is going to be issued.

The result is that 'bridge fdb' commands are now persistent (dynamically
learned entries are lost, but that's ok).

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 111 ++++++++++++++++++++++---
 1 file changed, 99 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 46a3c81825ec..80d8d2f5c472 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -816,6 +816,77 @@ static void sja1105_phylink_validate(struct dsa_switch *ds, int port,
 		   __ETHTOOL_LINK_MODE_MASK_NBITS);
 }
 
+static int
+sja1105_find_static_fdb_entry(struct sja1105_private *priv, int port,
+			      const struct sja1105_l2_lookup_entry *requested)
+{
+	struct sja1105_l2_lookup_entry *l2_lookup;
+	struct sja1105_table *table;
+	int i;
+
+	table = &priv->static_config.tables[BLK_IDX_L2_LOOKUP];
+	l2_lookup = table->entries;
+
+	for (i = 0; i < table->entry_count; i++)
+		if (l2_lookup[i].macaddr == requested->macaddr &&
+		    l2_lookup[i].vlanid == requested->vlanid &&
+		    l2_lookup[i].destports & BIT(port))
+			return i;
+
+	return -1;
+}
+
+/* We want FDB entries added statically through the bridge command to persist
+ * across switch resets, which are a common thing during normal SJA1105
+ * operation. So we have to back them up in the static configuration tables
+ * and hence apply them on next static config upload... yay!
+ */
+static int
+sja1105_static_fdb_change(struct sja1105_private *priv, int port,
+			  const struct sja1105_l2_lookup_entry *requested,
+			  bool keep)
+{
+	struct sja1105_l2_lookup_entry *l2_lookup;
+	struct sja1105_table *table;
+	int rc, match;
+
+	table = &priv->static_config.tables[BLK_IDX_L2_LOOKUP];
+
+	match = sja1105_find_static_fdb_entry(priv, port, requested);
+	if (match < 0) {
+		/* Can't delete a missing entry. */
+		if (!keep)
+			return 0;
+
+		/* No match => new entry */
+		rc = sja1105_table_resize(table, table->entry_count + 1);
+		if (rc)
+			return rc;
+
+		match = table->entry_count - 1;
+	}
+
+	/* Assign pointer after the resize (it may be new memory) */
+	l2_lookup = table->entries;
+
+	/* We have a match.
+	 * If the job was to add this FDB entry, it's already done (mostly
+	 * anyway, since the port forwarding mask may have changed, case in
+	 * which we update it).
+	 * Otherwise we have to delete it.
+	 */
+	if (keep) {
+		l2_lookup[match] = *requested;
+		return 0;
+	}
+
+	/* To remove, the strategy is to overwrite the element with
+	 * the last one, and then reduce the array size by 1
+	 */
+	l2_lookup[match] = l2_lookup[table->entry_count - 1];
+	return sja1105_table_resize(table, table->entry_count - 1);
+}
+
 /* First-generation switches have a 4-way set associative TCAM that
  * holds the FDB entries. An FDB index spans from 0 to 1023 and is comprised of
  * a "bin" (grouping of 4 entries) and a "way" (an entry within a bin).
@@ -866,7 +937,7 @@ int sja1105et_fdb_add(struct dsa_switch *ds, int port,
 	struct sja1105_private *priv = ds->priv;
 	struct device *dev = ds->dev;
 	int last_unused = -1;
-	int bin, way;
+	int bin, way, rc;
 
 	bin = sja1105et_fdb_hash(priv, addr, vid);
 
@@ -910,9 +981,13 @@ int sja1105et_fdb_add(struct dsa_switch *ds, int port,
 	}
 	l2_lookup.index = sja1105et_fdb_index(bin, way);
 
-	return sja1105_dynamic_config_write(priv, BLK_IDX_L2_LOOKUP,
-					    l2_lookup.index, &l2_lookup,
-					    true);
+	rc = sja1105_dynamic_config_write(priv, BLK_IDX_L2_LOOKUP,
+					  l2_lookup.index, &l2_lookup,
+					  true);
+	if (rc < 0)
+		return rc;
+
+	return sja1105_static_fdb_change(priv, port, &l2_lookup, true);
 }
 
 int sja1105et_fdb_del(struct dsa_switch *ds, int port,
@@ -920,7 +995,7 @@ int sja1105et_fdb_del(struct dsa_switch *ds, int port,
 {
 	struct sja1105_l2_lookup_entry l2_lookup = {0};
 	struct sja1105_private *priv = ds->priv;
-	int index, bin, way;
+	int index, bin, way, rc;
 	bool keep;
 
 	bin = sja1105et_fdb_hash(priv, addr, vid);
@@ -942,8 +1017,12 @@ int sja1105et_fdb_del(struct dsa_switch *ds, int port,
 	else
 		keep = false;
 
-	return sja1105_dynamic_config_write(priv, BLK_IDX_L2_LOOKUP,
-					    index, &l2_lookup, keep);
+	rc = sja1105_dynamic_config_write(priv, BLK_IDX_L2_LOOKUP,
+					  index, &l2_lookup, keep);
+	if (rc < 0)
+		return rc;
+
+	return sja1105_static_fdb_change(priv, port, &l2_lookup, keep);
 }
 
 int sja1105pqrs_fdb_add(struct dsa_switch *ds, int port,
@@ -994,9 +1073,13 @@ int sja1105pqrs_fdb_add(struct dsa_switch *ds, int port,
 	l2_lookup.index = i;
 
 skip_finding_an_index:
-	return sja1105_dynamic_config_write(priv, BLK_IDX_L2_LOOKUP,
-					    l2_lookup.index, &l2_lookup,
-					    true);
+	rc = sja1105_dynamic_config_write(priv, BLK_IDX_L2_LOOKUP,
+					  l2_lookup.index, &l2_lookup,
+					  true);
+	if (rc < 0)
+		return rc;
+
+	return sja1105_static_fdb_change(priv, port, &l2_lookup, true);
 }
 
 int sja1105pqrs_fdb_del(struct dsa_switch *ds, int port,
@@ -1030,8 +1113,12 @@ int sja1105pqrs_fdb_del(struct dsa_switch *ds, int port,
 	else
 		keep = false;
 
-	return sja1105_dynamic_config_write(priv, BLK_IDX_L2_LOOKUP,
-					    l2_lookup.index, &l2_lookup, keep);
+	rc = sja1105_dynamic_config_write(priv, BLK_IDX_L2_LOOKUP,
+					  l2_lookup.index, &l2_lookup, keep);
+	if (rc < 0)
+		return rc;
+
+	return sja1105_static_fdb_change(priv, port, &l2_lookup, keep);
 }
 
 static int sja1105_fdb_add(struct dsa_switch *ds, int port,
-- 
2.17.1

