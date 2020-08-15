Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7F1424531F
	for <lists+netdev@lfdr.de>; Sat, 15 Aug 2020 23:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728948AbgHOV6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 17:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728864AbgHOVv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Aug 2020 17:51:57 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A7CC061238
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 22:53:30 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id d6so7405144qkg.6
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 22:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=15QM3+NbaLfdCqkFkLPVJz42xPLv4Zz9+szGyFTCyrk=;
        b=k98kfjWilzJjVL5LEDa+msfwfeZmpGA7TMcB8HK8u46H/eZCFFx1rOstL/w5yvf+Wu
         YzXt1Ea4Jit2nCR/FJSxk151+PMUbGUUtdT6Cvl6X/oil7bhfbX6q2Ne2uR2mU13J9OF
         g/KG/Z7PGN/9mSQa5m2RwJ8cpxKjhzkvsbLji3Oe20wFFXyEydWdL4hY8TDHV7ubLm7m
         /HG6hocdZ6XDpsR0ifVmAp2P4Us6RHuYeJT54LgoMt/zsu3EDzysaXvtQLQ39MsaN9pA
         BRLxns5Kpf5iu5nA9/87QWk17nEnNyB2IixRCtUwKf9YxZv/1FXHn72wLz1NQbUGQL/W
         tmXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=15QM3+NbaLfdCqkFkLPVJz42xPLv4Zz9+szGyFTCyrk=;
        b=eCKkAOF/BUJIttTmub3kPCIGrACFwh2H4fgPtRNXBTF2urB/sjZn5srhptrjAHUH7Y
         NdT7n1C2z4QhdxiCXZDmlgaZnaGcl4MGrf8WySAAuse6TFMgocHtFXeBdkA45n2Lop2x
         ploWDv9w7u58HQVAv9PPadhDyTLFjNyPU6RyOucwgePfnnjuWuFydCrWmNt5+ija+zRB
         Kr4d3Z6p3+eNQTTLI6xWVIuO8ADYgQoMAUtAlz/QmmQWb2IV/r31mXvBvpE0NB+yuxn7
         dpdbpw5NQf9TrBHxUT8cf+oacQeESJQN4gvQctLybpabeiFbfiS2jPtatoxpPjR7RP68
         dBDA==
X-Gm-Message-State: AOAM5315Lvpim8Hdc82JAs86b2vbnQLFL191pYOlfwD4uq3fvB7fzVPy
        a8on/DnSF+/3ZRv5/DOS0p/KXI8wFXo5fihzK/XRozsrAGixOB0nZkKy1jguClDkKInY9j87cr8
        z1Hbu1LyXOpcyadpbazWWNMDkqNCiwUNELqWT3Q/+B3NZgH2FJ0zc4PI4fcgOawGN
X-Google-Smtp-Source: ABdhPJwHjwsa4yl+4uK9KsZH2o3gR3cu1+qSn2wJ03QUJLYsEVbEOhlBDte9GoBRjybnHo4ZM+y4VakMjrPz
X-Received: by 2002:a0c:b895:: with SMTP id y21mr5973088qvf.87.1597470809289;
 Fri, 14 Aug 2020 22:53:29 -0700 (PDT)
Date:   Fri, 14 Aug 2020 22:53:24 -0700
Message-Id: <20200815055324.3361890-1-maheshb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH net] ipvlan: fix device features
From:   Mahesh Bandewar <maheshb@google.com>
To:     Netdev <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        Mahesh Bandewar <maheshb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Processing NETDEV_FEAT_CHANGE causes IPvlan links to lose
NETIF_F_LLTX feature because of the incorrect handling of
features in ipvlan_fix_features().

--before--
lpaa10:~# ethtool -k ipvl0 | grep tx-lockless
tx-lockless: on [fixed]
lpaa10:~# ethtool -K ipvl0 tso off
Cannot change tcp-segmentation-offload
Actual changes:
vlan-challenged: off [fixed]
tx-lockless: off [fixed]
lpaa10:~# ethtool -k ipvl0 | grep tx-lockless
tx-lockless: off [fixed]
lpaa10:~#

--after--
lpaa10:~# ethtool -k ipvl0 | grep tx-lockless
tx-lockless: on [fixed]
lpaa10:~# ethtool -K ipvl0 tso off
Cannot change tcp-segmentation-offload
Could not change any device features
lpaa10:~# ethtool -k ipvl0 | grep tx-lockless
tx-lockless: on [fixed]
lpaa10:~#

Fixes: 2ad7bf363841 ("ipvlan: Initial check-in of the IPVLAN driver.")
Signed-off-by: Mahesh Bandewar <maheshb@google.com>
Cc: Eric Dumazet <edumazet@google.com>
---
 drivers/net/ipvlan/ipvlan_main.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index 15e87c097b0b..5bca94c99006 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -106,12 +106,21 @@ static void ipvlan_port_destroy(struct net_device *dev)
 	kfree(port);
 }
 
+#define IPVLAN_ALWAYS_ON_OFLOADS \
+	(NETIF_F_SG | NETIF_F_HW_CSUM | \
+	 NETIF_F_GSO_ROBUST | NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL)
+
+#define IPVLAN_ALWAYS_ON \
+	(IPVLAN_ALWAYS_ON_OFLOADS | NETIF_F_LLTX | NETIF_F_VLAN_CHALLENGED)
+
 #define IPVLAN_FEATURES \
-	(NETIF_F_SG | NETIF_F_CSUM_MASK | NETIF_F_HIGHDMA | NETIF_F_FRAGLIST | \
+	(NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_HIGHDMA | NETIF_F_FRAGLIST | \
 	 NETIF_F_GSO | NETIF_F_ALL_TSO | NETIF_F_GSO_ROBUST | \
 	 NETIF_F_GRO | NETIF_F_RXCSUM | \
 	 NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_STAG_FILTER)
 
+	/* NETIF_F_GSO_ENCAP_ALL NETIF_F_GSO_SOFTWARE Newly added */
+
 #define IPVLAN_STATE_MASK \
 	((1<<__LINK_STATE_NOCARRIER) | (1<<__LINK_STATE_DORMANT))
 
@@ -125,7 +134,9 @@ static int ipvlan_init(struct net_device *dev)
 	dev->state = (dev->state & ~IPVLAN_STATE_MASK) |
 		     (phy_dev->state & IPVLAN_STATE_MASK);
 	dev->features = phy_dev->features & IPVLAN_FEATURES;
-	dev->features |= NETIF_F_LLTX | NETIF_F_VLAN_CHALLENGED;
+	dev->features |= IPVLAN_ALWAYS_ON;
+	dev->vlan_features = phy_dev->vlan_features & IPVLAN_FEATURES;
+	dev->vlan_features |= IPVLAN_ALWAYS_ON_OFLOADS;
 	dev->hw_enc_features |= dev->features;
 	dev->gso_max_size = phy_dev->gso_max_size;
 	dev->gso_max_segs = phy_dev->gso_max_segs;
@@ -227,7 +238,14 @@ static netdev_features_t ipvlan_fix_features(struct net_device *dev,
 {
 	struct ipvl_dev *ipvlan = netdev_priv(dev);
 
-	return features & (ipvlan->sfeatures | ~IPVLAN_FEATURES);
+	features |= NETIF_F_ALL_FOR_ALL;
+	features &= (ipvlan->sfeatures | ~IPVLAN_FEATURES);
+	features = netdev_increment_features(ipvlan->phy_dev->features,
+					     features, features);
+	features |= IPVLAN_ALWAYS_ON;
+	features &= (IPVLAN_FEATURES | IPVLAN_ALWAYS_ON);
+
+	return features;
 }
 
 static void ipvlan_change_rx_flags(struct net_device *dev, int change)
@@ -734,10 +752,9 @@ static int ipvlan_device_event(struct notifier_block *unused,
 
 	case NETDEV_FEAT_CHANGE:
 		list_for_each_entry(ipvlan, &port->ipvlans, pnode) {
-			ipvlan->dev->features = dev->features & IPVLAN_FEATURES;
 			ipvlan->dev->gso_max_size = dev->gso_max_size;
 			ipvlan->dev->gso_max_segs = dev->gso_max_segs;
-			netdev_features_change(ipvlan->dev);
+			netdev_update_features(ipvlan->dev);
 		}
 		break;
 
-- 
2.28.0.220.ged08abb693-goog

