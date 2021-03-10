Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2B7333C6C
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232942AbhCJMQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:16:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232706AbhCJMPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:15:46 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63411C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:15:46 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id dx17so38268360ejb.2
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:15:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kpZeMpCOC/ymRC/QZvFWzDOCjDQ+rmZk44jPjhC7JUk=;
        b=EIOIx3ktvsPctT9K7kGjA2qM9V1dYsyhyoSSACZ4ClCnNEnvPxiAdyrNiWXkXNf1/r
         3foFBIYcS/wx3o4KmO6tir+99VtAGxMxLzO2IMVaBCW7llg1Xmp4oW5HjK4k9B3SMiNz
         EoCBR2eIOs0ylJnPaccvpoL6dIcxDr2jjQ3YffoPZsTSoz3YGACR/NdKoMPSWE12R3Da
         hdCWIQ4kE9G8tgqgFyemO9TdAydy0AM9ebBkKzk/vQ+kW8EW7Q+cWRcZ63WepSeOA5OV
         cXdXT1IPqfsorCVtgQuyv0/xuj40phkPq/u61iMG+A4pQiMMgDTX46p2sTf4unsYhxgL
         MnLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kpZeMpCOC/ymRC/QZvFWzDOCjDQ+rmZk44jPjhC7JUk=;
        b=lLfNbbvtuwZ6ShZU6NuTZvuco/wL0993ajpuxMSClrUxCgk4LZkmtB6wOJ+S1Rqirz
         mjXCiUKLsvHWDoYBkvPJchf+vbLEB+dQUP7p13kIJAWylzrO4HO8jF7qeW8YQDmrWUbt
         gfBnMLnaVA+pR4SZr1Ws+nCBJhz/PqY9pTW5VxaIZfHPKONkg0wqSGuvJveVhB4p5o/w
         rBQvDEOup8fXYfZRBwlWTW0pC4XsLPNnVKEoAvxZY7UxRSLhANCvnMvEoak3z/D1tTqr
         JqBJUpiBreBV/L99ldQ+tjOk03xT6vCsorQrnA1tivDbzAP6uu62D968Q2SDGTwlBYk8
         EJjw==
X-Gm-Message-State: AOAM531OyvTj5ddzChEJVomwztLkmqTTBUcZR0eJOzbQLP4DkRJy2J3q
        j1YBYpbSDj6lbocNsHzlFg4=
X-Google-Smtp-Source: ABdhPJxIw3H9hQPPZEJZ+mCHux5LcQsKBNg1ieMDLFt0+36zGOzpGOsrLAIBRg3mUrbv4Z4zyPq+AQ==
X-Received: by 2002:a17:906:d18e:: with SMTP id c14mr3228878ejz.62.1615378545119;
        Wed, 10 Mar 2021 04:15:45 -0800 (PST)
Received: from yoga-910.localhost ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id v15sm4865527edw.28.2021.03.10.04.15.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 04:15:44 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        jiri@resnulli.us, ruxandra.radulescu@nxp.com,
        netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 13/15] staging: dpaa2-switch: add fast-ageing on bridge leave
Date:   Wed, 10 Mar 2021 14:14:50 +0200
Message-Id: <20210310121452.552070-14-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210310121452.552070-1-ciorneiioana@gmail.com>
References: <20210310121452.552070-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Upon leaving a bridge, any MAC addresses learnt on the switch port prior
to this point have to be removed so that we preserve the bridging domain
configuration.

Restructure the dpaa2_switch_port_fdb_dump() function in order to have a
common dpaa2_switch_fdb_iterate() function between the FDB dump callback
and the fast age procedure. To accomplish this, add a new callback -
dpaa2_switch_fdb_cb_t - which will be called on each MAC addr and,
depending on the situation, will either dump the FDB entry into a
netlink message or will delete the address from the FDB table, in case
of the fast-age.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c | 76 +++++++++++++++++++------
 drivers/staging/fsl-dpaa2/ethsw/ethsw.h |  3 +
 2 files changed, 63 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
index 8058bc3ed467..5fa7e41f6866 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -729,21 +729,14 @@ static int dpaa2_switch_port_fdb_valid_entry(struct fdb_dump_entry *entry,
 	return valid;
 }
 
-static int dpaa2_switch_port_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb,
-				      struct net_device *net_dev,
-				      struct net_device *filter_dev, int *idx)
+static int dpaa2_switch_fdb_iterate(struct ethsw_port_priv *port_priv,
+				    dpaa2_switch_fdb_cb_t cb, void *data)
 {
-	struct ethsw_port_priv *port_priv = netdev_priv(net_dev);
+	struct net_device *net_dev = port_priv->netdev;
 	struct ethsw_core *ethsw = port_priv->ethsw_data;
 	struct device *dev = net_dev->dev.parent;
 	struct fdb_dump_entry *fdb_entries;
 	struct fdb_dump_entry fdb_entry;
-	struct ethsw_dump_ctx dump = {
-		.dev = net_dev,
-		.skb = skb,
-		.cb = cb,
-		.idx = *idx,
-	};
 	dma_addr_t fdb_dump_iova;
 	u16 num_fdb_entries;
 	u32 fdb_dump_size;
@@ -778,17 +771,12 @@ static int dpaa2_switch_port_fdb_dump(struct sk_buff *skb, struct netlink_callba
 	for (i = 0; i < num_fdb_entries; i++) {
 		fdb_entry = fdb_entries[i];
 
-		if (!dpaa2_switch_port_fdb_valid_entry(&fdb_entry, port_priv))
-			continue;
-
-		err = dpaa2_switch_fdb_dump_nl(&fdb_entry, &dump);
+		err = cb(port_priv, &fdb_entry, data);
 		if (err)
 			goto end;
 	}
 
 end:
-	*idx = dump.idx;
-
 	kfree(dma_mem);
 
 	return 0;
@@ -800,6 +788,59 @@ static int dpaa2_switch_port_fdb_dump(struct sk_buff *skb, struct netlink_callba
 	return err;
 }
 
+static int dpaa2_switch_fdb_entry_dump(struct ethsw_port_priv *port_priv,
+				       struct fdb_dump_entry *fdb_entry,
+				       void *data)
+{
+	if (!dpaa2_switch_port_fdb_valid_entry(fdb_entry, port_priv))
+		return 0;
+
+	return dpaa2_switch_fdb_dump_nl(fdb_entry, data);
+}
+
+static int dpaa2_switch_port_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb,
+				      struct net_device *net_dev,
+				      struct net_device *filter_dev, int *idx)
+{
+	struct ethsw_port_priv *port_priv = netdev_priv(net_dev);
+	struct ethsw_dump_ctx dump = {
+		.dev = net_dev,
+		.skb = skb,
+		.cb = cb,
+		.idx = *idx,
+	};
+	int err;
+
+	err = dpaa2_switch_fdb_iterate(port_priv, dpaa2_switch_fdb_entry_dump, &dump);
+	*idx = dump.idx;
+
+	return err;
+}
+
+static int dpaa2_switch_fdb_entry_fast_age(struct ethsw_port_priv *port_priv,
+					   struct fdb_dump_entry *fdb_entry,
+					   void *data __always_unused)
+{
+	if (!dpaa2_switch_port_fdb_valid_entry(fdb_entry, port_priv))
+		return 0;
+
+	if (!(fdb_entry->type & DPSW_FDB_ENTRY_TYPE_DYNAMIC))
+		return 0;
+
+	if (fdb_entry->type & DPSW_FDB_ENTRY_TYPE_UNICAST)
+		dpaa2_switch_port_fdb_del_uc(port_priv, fdb_entry->mac_addr);
+	else
+		dpaa2_switch_port_fdb_del_mc(port_priv, fdb_entry->mac_addr);
+
+	return 0;
+}
+
+static void dpaa2_switch_port_fast_age(struct ethsw_port_priv *port_priv)
+{
+	dpaa2_switch_fdb_iterate(port_priv,
+				 dpaa2_switch_fdb_entry_fast_age, NULL);
+}
+
 static int dpaa2_switch_port_vlan_add(struct net_device *netdev, __be16 proto,
 				      u16 vid)
 {
@@ -1511,6 +1552,9 @@ static int dpaa2_switch_port_bridge_leave(struct net_device *netdev)
 	struct ethsw_core *ethsw = port_priv->ethsw_data;
 	int err;
 
+	/* First of all, fast age any learn FDB addresses on this switch port */
+	dpaa2_switch_port_fast_age(port_priv);
+
 	/* Clear all RX VLANs installed through vlan_vid_add() either as VLAN
 	 * upper devices or otherwise from the FDB table that we are about to
 	 * leave
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
index ac9335c83357..933563064015 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
@@ -172,4 +172,7 @@ int dpaa2_switch_port_vlans_add(struct net_device *netdev,
 int dpaa2_switch_port_vlans_del(struct net_device *netdev,
 				const struct switchdev_obj_port_vlan *vlan);
 
+typedef int dpaa2_switch_fdb_cb_t(struct ethsw_port_priv *port_priv,
+				  struct fdb_dump_entry *fdb_entry,
+				  void *data);
 #endif	/* __ETHSW_H */
-- 
2.30.0

