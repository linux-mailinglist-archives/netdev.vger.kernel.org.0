Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0627213F6CC
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436841AbgAPTHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 14:07:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:52254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388069AbgAPRBU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:01:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 856592077B;
        Thu, 16 Jan 2020 17:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194079;
        bh=sjTRzExdiLm8gEWDOXMD1vYTDXfZ+AluGIg0Y66rPeQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ukkh1P+b/V4w+N1x4FIDrw8LA1XSAYDIT8025z9Xq/HIsU9zUeMHuoI04Ga1cO/AP
         ldz5g/BeznTUaRoiAIomVIdRQFFqFqC0WEm6fbsqeIgt0aHhmLlYdn/bR0ESOIUs9k
         bl1CNFwP7ZpZCO99EI1W0OxJDUPxj4lrVivJnXHU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 185/671] net: dsa: b53: Properly account for VLAN filtering
Date:   Thu, 16 Jan 2020 11:51:34 -0500
Message-Id: <20200116165940.10720-68-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit dad8d7c6452b5b9f9828c9e2c7ca143205fd40c7 ]

VLAN filtering can be built into the kernel, and also dynamically turned
on/off through the bridge master device. Allow re-configuring the switch
appropriately to account for that by deciding whether VLAN table
(v_table) misses should lead to a drop or forward.

Fixes: a2482d2ce349 ("net: dsa: b53: Plug in VLAN support")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 59 +++++++++++++++++++++++++++++---
 drivers/net/dsa/b53/b53_priv.h   |  3 ++
 2 files changed, 57 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index bceda1e88442..426ec1c05799 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -343,7 +343,8 @@ static void b53_set_forwarding(struct b53_device *dev, int enable)
 	b53_write8(dev, B53_CTRL_PAGE, B53_SWITCH_CTRL, mgmt);
 }
 
-static void b53_enable_vlan(struct b53_device *dev, bool enable)
+static void b53_enable_vlan(struct b53_device *dev, bool enable,
+			    bool enable_filtering)
 {
 	u8 mgmt, vc0, vc1, vc4 = 0, vc5;
 
@@ -368,8 +369,13 @@ static void b53_enable_vlan(struct b53_device *dev, bool enable)
 		vc0 |= VC0_VLAN_EN | VC0_VID_CHK_EN | VC0_VID_HASH_VID;
 		vc1 |= VC1_RX_MCST_UNTAG_EN | VC1_RX_MCST_FWD_EN;
 		vc4 &= ~VC4_ING_VID_CHECK_MASK;
-		vc4 |= VC4_ING_VID_VIO_DROP << VC4_ING_VID_CHECK_S;
-		vc5 |= VC5_DROP_VTABLE_MISS;
+		if (enable_filtering) {
+			vc4 |= VC4_ING_VID_VIO_DROP << VC4_ING_VID_CHECK_S;
+			vc5 |= VC5_DROP_VTABLE_MISS;
+		} else {
+			vc4 |= VC4_ING_VID_VIO_FWD << VC4_ING_VID_CHECK_S;
+			vc5 &= ~VC5_DROP_VTABLE_MISS;
+		}
 
 		if (is5325(dev))
 			vc0 &= ~VC0_RESERVED_1;
@@ -419,6 +425,9 @@ static void b53_enable_vlan(struct b53_device *dev, bool enable)
 	}
 
 	b53_write8(dev, B53_CTRL_PAGE, B53_SWITCH_MODE, mgmt);
+
+	dev->vlan_enabled = enable;
+	dev->vlan_filtering_enabled = enable_filtering;
 }
 
 static int b53_set_jumbo(struct b53_device *dev, bool enable, bool allow_10_100)
@@ -646,7 +655,7 @@ int b53_configure_vlan(struct dsa_switch *ds)
 		b53_do_vlan_op(dev, VTA_CMD_CLEAR);
 	}
 
-	b53_enable_vlan(dev, false);
+	b53_enable_vlan(dev, false, dev->vlan_filtering_enabled);
 
 	b53_for_each_port(dev, i)
 		b53_write16(dev, B53_VLAN_PAGE,
@@ -1081,6 +1090,46 @@ static void b53_adjust_link(struct dsa_switch *ds, int port,
 
 int b53_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering)
 {
+	struct b53_device *dev = ds->priv;
+	struct net_device *bridge_dev;
+	unsigned int i;
+	u16 pvid, new_pvid;
+
+	/* Handle the case were multiple bridges span the same switch device
+	 * and one of them has a different setting than what is being requested
+	 * which would be breaking filtering semantics for any of the other
+	 * bridge devices.
+	 */
+	b53_for_each_port(dev, i) {
+		bridge_dev = dsa_to_port(ds, i)->bridge_dev;
+		if (bridge_dev &&
+		    bridge_dev != dsa_to_port(ds, port)->bridge_dev &&
+		    br_vlan_enabled(bridge_dev) != vlan_filtering) {
+			netdev_err(bridge_dev,
+				   "VLAN filtering is global to the switch!\n");
+			return -EINVAL;
+		}
+	}
+
+	b53_read16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(port), &pvid);
+	new_pvid = pvid;
+	if (dev->vlan_filtering_enabled && !vlan_filtering) {
+		/* Filtering is currently enabled, use the default PVID since
+		 * the bridge does not expect tagging anymore
+		 */
+		dev->ports[port].pvid = pvid;
+		new_pvid = b53_default_pvid(dev);
+	} else if (!dev->vlan_filtering_enabled && vlan_filtering) {
+		/* Filtering is currently disabled, restore the previous PVID */
+		new_pvid = dev->ports[port].pvid;
+	}
+
+	if (pvid != new_pvid)
+		b53_write16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(port),
+			    new_pvid);
+
+	b53_enable_vlan(dev, dev->vlan_enabled, vlan_filtering);
+
 	return 0;
 }
 EXPORT_SYMBOL(b53_vlan_filtering);
@@ -1096,7 +1145,7 @@ int b53_vlan_prepare(struct dsa_switch *ds, int port,
 	if (vlan->vid_end > dev->num_vlans)
 		return -ERANGE;
 
-	b53_enable_vlan(dev, true);
+	b53_enable_vlan(dev, true, dev->vlan_filtering_enabled);
 
 	return 0;
 }
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index df149756c282..e87af5db0d6d 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -73,6 +73,7 @@ enum {
 struct b53_port {
 	u16		vlan_ctl_mask;
 	struct ethtool_eee eee;
+	u16		pvid;
 };
 
 struct b53_vlan {
@@ -118,6 +119,8 @@ struct b53_device {
 
 	unsigned int num_vlans;
 	struct b53_vlan *vlans;
+	bool vlan_enabled;
+	bool vlan_filtering_enabled;
 	unsigned int num_ports;
 	struct b53_port *ports;
 };
-- 
2.20.1

