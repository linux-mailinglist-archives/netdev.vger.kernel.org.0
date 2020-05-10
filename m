Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 497921CCC67
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 18:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729369AbgEJQoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 12:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728600AbgEJQne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 12:43:34 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 261F9C061A0E;
        Sun, 10 May 2020 09:43:34 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id y24so16339347wma.4;
        Sun, 10 May 2020 09:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=E8h43DVwyQEgSe9HIpdWtHOas81wEn11zRRa4f/9ZqY=;
        b=mVQTYMOFooSM6RmZW+EMQJ9xmnGfScaL/MYmCMDzbroi11rHUC42IgfGQhzx0XNuEV
         jitnnpg5Y2S8DHErQvSv1XUQnrOKDQW+uD9SZy3ToF4bkS+cDZkqNT4g19QuKj9ekdhe
         gI+ZkGobmo/pameejq0LhGmoIQ9N0t25CjgyX2i95Dyp5vbD4HZvTbu7dG7L3WD8uetq
         LtVM7BrI/mSzDF6oRgQay+XTdkwgRtq5dhyr6sMgfn8VykPEx4xocL70CIUEPRlNAujY
         bFUTN/xQQW8ftmmwThBhBJnk+NQRk5TPVg2/FxYWtdrcYo7ch9D8u5j/+Z6GAXLKnR8c
         3AIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=E8h43DVwyQEgSe9HIpdWtHOas81wEn11zRRa4f/9ZqY=;
        b=GgSnkQw00T0v8t07Twk+/uSJw3AYLwQUhjX4odqdWR37tTG3sijRxgcJgj3ZifCjDZ
         g7uCVhyLLycUrGaplotPN5Puwf9y1uBUJAw0vAEiEuhdE1GOuXWZGHoK4sJ2fHnX8X5S
         UnpNFzjYjjfAYa1VWBPZNRGNgV/o0JxRuuTvnLBdHIlzDG9Uvcr/42gFU4BZCMlseQIN
         /OPvRfv4UcvzLCauO+pV128nfs/Jb8pAREV+5wTN59s9UQiB8UCwOIoc4MTTjKb9mqK/
         KzLjmfCPO1HgwAc0wyjaiWKF+EG5nEnbfScEc2RHJ7QOPzcaERC0qNnY6K743EiaG48e
         lGmQ==
X-Gm-Message-State: AGi0PuaDMWL/ldXtA2DSyyQ2HZIzy5SpJ8fEFJVV2wg1taF3IsbwUAbt
        M5HSCSBTRJ9MabtShk1FSro=
X-Google-Smtp-Source: APiQypKgVHOV8okpTdmr5fM/KeOlvti8GIAiuavgVTfCo94SN/jcs0VE92Tg0gYmnnvv+lJ5WwSlmg==
X-Received: by 2002:a7b:c5d3:: with SMTP id n19mr19754955wmk.21.1589129012851;
        Sun, 10 May 2020 09:43:32 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id i1sm13390916wrx.22.2020.05.10.09.43.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2020 09:43:32 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 04/15] net: dsa: sja1105: deny alterations of dsa_8021q VLANs from the bridge
Date:   Sun, 10 May 2020 19:42:44 +0300
Message-Id: <20200510164255.19322-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200510164255.19322-1-olteanv@gmail.com>
References: <20200510164255.19322-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

At the moment, this can never happen. The 2 modes that we operate in do
not permit that:

 - SJA1105_VLAN_UNAWARE: we are guarded from bridge VLANs added by the
   user by the DSA core. We will later lift this restriction by setting
   ds->vlan_bridge_vtu = true, and that is where we'll need it.

 - SJA1105_VLAN_FILTERING_FULL: in this mode, dsa_8021q configuration is
   disabled. So the user is free to add these VLANs in the 1024-3071
   range.

The reason for the patch is that we'll introduce a third VLAN awareness
state, where both dsa_8021q as well as the bridge are going to call our
.port_vlan_add and .port_vlan_del methods.

For that, we need a good way to discriminate between the 2. The easiest
(and less intrusive way for upper layers) is to recognize the fact that
dsa_8021q configurations are always driven by our driver - we _know_
when a .port_vlan_add method will be called from dsa_8021q because _we_
initiated it.

So introduce an expect_dsa_8021q boolean which is only used, at the
moment, for blacklisting VLANs in range 1024-3071 in the modes when
dsa_8021q is active.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h      |  1 +
 drivers/net/dsa/sja1105/sja1105_main.c | 31 +++++++++++++++++++++++++-
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 5b2b275d01a7..667056d0c819 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -198,6 +198,7 @@ struct sja1105_private {
 	 * the switch doesn't confuse them with one another.
 	 */
 	struct mutex mgmt_lock;
+	bool expect_dsa_8021q;
 	enum sja1105_vlan_state vlan_state;
 	struct sja1105_tagger_data tagger_data;
 	struct sja1105_ptp_data ptp_data;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 7dee9b282a1b..78ec97850f96 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1811,15 +1811,19 @@ static int sja1105_crosschip_bridge_join(struct dsa_switch *ds,
 		if (dsa_to_port(ds, port)->bridge_dev != br)
 			continue;
 
+		other_priv->expect_dsa_8021q = true;
 		rc = dsa_8021q_crosschip_bridge_join(ds, port, other_ds,
 						     other_port, br,
 						     &priv->crosschip_links);
+		other_priv->expect_dsa_8021q = false;
 		if (rc)
 			return rc;
 
+		priv->expect_dsa_8021q = true;
 		rc = dsa_8021q_crosschip_bridge_join(other_ds, other_port, ds,
 						     port, br,
 						     &other_priv->crosschip_links);
+		priv->expect_dsa_8021q = false;
 		if (rc)
 			return rc;
 	}
@@ -1846,12 +1850,16 @@ static void sja1105_crosschip_bridge_leave(struct dsa_switch *ds,
 		if (dsa_to_port(ds, port)->bridge_dev != br)
 			continue;
 
+		other_priv->expect_dsa_8021q = true;
 		dsa_8021q_crosschip_bridge_leave(ds, port, other_ds, other_port,
 						 br, &priv->crosschip_links);
+		other_priv->expect_dsa_8021q = false;
 
+		priv->expect_dsa_8021q = true;
 		dsa_8021q_crosschip_bridge_leave(other_ds, other_port, ds,
 						 port, br,
 						 &other_priv->crosschip_links);
+		priv->expect_dsa_8021q = false;
 	}
 }
 
@@ -1862,8 +1870,10 @@ static int sja1105_replay_crosschip_vlans(struct dsa_switch *ds, bool enabled)
 	int rc;
 
 	list_for_each_entry(c, &priv->crosschip_links, list) {
+		priv->expect_dsa_8021q = true;
 		rc = dsa_8021q_crosschip_link_apply(ds, c->port, c->other_ds,
 						    c->other_port, enabled);
+		priv->expect_dsa_8021q = false;
 		if (rc)
 			break;
 	}
@@ -1873,10 +1883,13 @@ static int sja1105_replay_crosschip_vlans(struct dsa_switch *ds, bool enabled)
 
 static int sja1105_setup_8021q_tagging(struct dsa_switch *ds, bool enabled)
 {
+	struct sja1105_private *priv = ds->priv;
 	int rc, i;
 
 	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
+		priv->expect_dsa_8021q = true;
 		rc = dsa_port_setup_8021q_tagging(ds, i, enabled);
+		priv->expect_dsa_8021q = false;
 		if (rc < 0) {
 			dev_err(ds->dev, "Failed to setup VLAN tagging for port %d: %d\n",
 				i, rc);
@@ -1901,10 +1914,26 @@ sja1105_get_tag_protocol(struct dsa_switch *ds, int port,
 	return DSA_TAG_PROTO_SJA1105;
 }
 
-/* This callback needs to be present */
 static int sja1105_vlan_prepare(struct dsa_switch *ds, int port,
 				const struct switchdev_obj_port_vlan *vlan)
 {
+	struct sja1105_private *priv = ds->priv;
+	u16 vid;
+
+	if (priv->vlan_state == SJA1105_VLAN_FILTERING_FULL)
+		return 0;
+
+	/* If the user wants best-effort VLAN filtering (aka vlan_filtering
+	 * bridge plus tagging), be sure to at least deny alterations to the
+	 * configuration done by dsa_8021q.
+	 */
+	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
+		if (!priv->expect_dsa_8021q && vid_is_dsa_8021q(vid)) {
+			dev_err(ds->dev, "Range 1024-3071 reserved for dsa_8021q operation\n");
+			return -EBUSY;
+		}
+	}
+
 	return 0;
 }
 
-- 
2.17.1

