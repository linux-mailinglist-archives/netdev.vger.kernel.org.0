Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 650F91AE572
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 21:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgDQTIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 15:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726050AbgDQTIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 15:08:06 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E911DC061A0C
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 12:08:04 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id j2so4258329wrs.9
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 12:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=sDQ2u3uVIu7MkBjkONO308K8qxOVY+zoysPH0XykaXY=;
        b=RK0gH1KrulL4PpoMLl5u9mD7tV8D4hJUqg4DMy1bc/LZ+Xw3uPs8FhSjjH9XJOoLVA
         VU2QwuBxGSp6VH8Uv0C7hmQWrS/Dyt72vVWgsxiYXU7TgYNiEgdZlyPvS39deO2A7JVW
         xPhx5JvYV5v3BkkcFYYsCxLYBeyOAMcdibXj3a/R6smBSICQcn4XuyeSFV4F9Sm7kaDA
         TERoKruJwUsl4BjjCHCEQ8PRpexyogWLD2DxiqjOKIw9jaEN8/vAWoJkR8VbZelglG1g
         VkLtwA3BRHZNjcCJyb7CGiGlFaRLxt0llOcSaZsgTKqG5pD7+vlH2WOJRSKunyltmbZU
         YrjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=sDQ2u3uVIu7MkBjkONO308K8qxOVY+zoysPH0XykaXY=;
        b=pLYboSGGDgi6QHq/pje8Kszy4H0cpy3LQVB8IZ4lesi2Fqan7Cam48DoCsD5KFKdiv
         7RyZgaURzxyNaqAZt0BMeTOr//ND6LTrIHFBfxfF2VjgQO7wYott5PbZZ2wxrMn+vxOp
         jLOCuhyl8AetyuYCcJgWEqwdq92bamF5oiija2UD1kjZ/NlxTa+GYByWMnW7NHUIU4SR
         edFYurBffdXvovP5n1aUQYm/DvnreTDuXFaWUblActJzbRsBUHdLF8QlscrL8StlOnlA
         BOTEO1T7AHYXk+wuvyQQ1JoD106wVQ3ta8JTlfr2x05vrnT9nYo6+XL/AGZGqr9k8i9z
         JphQ==
X-Gm-Message-State: AGi0PuaBuZXPtglewIfT++f3lY81tSlNDIiY6DkMzfHqONxEfGfC3N5y
        rbk9uqVF8Y3qdnbG5zmzFY0=
X-Google-Smtp-Source: APiQypJPnhP6u2kWF9dbJjne68Ssfdq70LP+EzTWOrdn9FR3Bt9DX14vVWQ2GoHmuLgstnmoEsoopA==
X-Received: by 2002:adf:9168:: with SMTP id j95mr5167539wrj.145.1587150483673;
        Fri, 17 Apr 2020 12:08:03 -0700 (PDT)
Received: from localhost.localdomain ([188.25.102.96])
        by smtp.gmail.com with ESMTPSA id h1sm9366315wme.42.2020.04.17.12.08.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2020 12:08:03 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        yangbo.lu@nxp.com, po.liu@nxp.com
Subject: [PATCH net-next] enetc: permit configuration of rx-vlan-filter with ethtool
Date:   Fri, 17 Apr 2020 22:07:55 +0300
Message-Id: <20200417190755.1394-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Each ENETC station interface (SI) has a VLAN filter list and a port
flag (PSIPVMR) by which it can be put in "VLAN promiscuous" mode, which
enables the reception of VLAN-tagged traffic even if it is not in the
VLAN filtering list.

Currently the handling of this setting works like this: the port starts
off as VLAN promiscuous, then it switches to enabling VLAN filtering as
soon as the first VLAN is installed in its filter via
.ndo_vlan_rx_add_vid. In practice that does not work out very well,
because more often than not, the first VLAN to be installed is out of
the control of the user: the 8021q module, if loaded, adds its rule for
802.1p (VID 0) traffic upon bringing the interface up.

What the user is currently seeing in ethtool is this:
ethtool -k eno2
rx-vlan-filter: on [fixed]

which doesn't match the intention of the code, but the practical reality
of having the 8021q module install its VID which has the side-effect of
turning on VLAN filtering in this driver. All in all, a slightly
confusing experience.

So instead of letting this driver switch the VLAN filtering state by
itself, just wire it up with the rx-vlan-filter feature from ethtool,
and let it be user-configurable just through that knob, except for one
case, see below.

In promiscuous mode, it is more intuitive that all traffic is received,
including VLAN tagged traffic. It appears that it is necessary to set
the flag in PSIPVMR for that to be the case, so VLAN promiscuous mode is
also temporarily enabled. On exit from promiscuous mode, the setting
made by ethtool is restored.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 44 +++++++------------
 1 file changed, 16 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index ebcc0e74915a..671bf63f964d 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -50,21 +50,6 @@ static void enetc_set_vlan_promisc(struct enetc_hw *hw, char si_map)
 	enetc_port_wr(hw, ENETC_PSIPVMR, ENETC_PSIPVMR_SET_VP(si_map) | val);
 }
 
-static bool enetc_si_vlan_promisc_is_on(struct enetc_pf *pf, int si_idx)
-{
-	return pf->vlan_promisc_simap & BIT(si_idx);
-}
-
-static bool enetc_vlan_filter_is_on(struct enetc_pf *pf)
-{
-	int i;
-
-	for_each_set_bit(i, pf->active_vlans, VLAN_N_VID)
-		return true;
-
-	return false;
-}
-
 static void enetc_enable_si_vlan_promisc(struct enetc_pf *pf, int si_idx)
 {
 	pf->vlan_promisc_simap |= BIT(si_idx);
@@ -204,6 +189,7 @@ static void enetc_pf_set_rx_mode(struct net_device *ndev)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct enetc_pf *pf = enetc_si_priv(priv->si);
+	char vlan_promisc_simap = pf->vlan_promisc_simap;
 	struct enetc_hw *hw = &priv->si->hw;
 	bool uprom = false, mprom = false;
 	struct enetc_mac_filter *filter;
@@ -216,16 +202,16 @@ static void enetc_pf_set_rx_mode(struct net_device *ndev)
 		psipmr = ENETC_PSIPMR_SET_UP(0) | ENETC_PSIPMR_SET_MP(0);
 		uprom = true;
 		mprom = true;
-		/* enable VLAN promisc mode for SI0 */
-		if (!enetc_si_vlan_promisc_is_on(pf, 0))
-			enetc_enable_si_vlan_promisc(pf, 0);
-
+		/* Enable VLAN promiscuous mode for SI0 (PF) */
+		vlan_promisc_simap |= BIT(0);
 	} else if (ndev->flags & IFF_ALLMULTI) {
 		/* enable multi cast promisc mode for SI0 (PF) */
 		psipmr = ENETC_PSIPMR_SET_MP(0);
 		mprom = true;
 	}
 
+	enetc_set_vlan_promisc(&pf->si->hw, vlan_promisc_simap);
+
 	/* first 2 filter entries belong to PF */
 	if (!uprom) {
 		/* Update unicast filters */
@@ -306,9 +292,6 @@ static int enetc_vlan_rx_add_vid(struct net_device *ndev, __be16 prot, u16 vid)
 	struct enetc_pf *pf = enetc_si_priv(priv->si);
 	int idx;
 
-	if (enetc_si_vlan_promisc_is_on(pf, 0))
-		enetc_disable_si_vlan_promisc(pf, 0);
-
 	__set_bit(vid, pf->active_vlans);
 
 	idx = enetc_vid_hash_idx(vid);
@@ -326,9 +309,6 @@ static int enetc_vlan_rx_del_vid(struct net_device *ndev, __be16 prot, u16 vid)
 	__clear_bit(vid, pf->active_vlans);
 	enetc_sync_vlan_ht_filter(pf, true);
 
-	if (!enetc_vlan_filter_is_on(pf))
-		enetc_enable_si_vlan_promisc(pf, 0);
-
 	return 0;
 }
 
@@ -681,6 +661,15 @@ static int enetc_pf_set_features(struct net_device *ndev,
 		enetc_enable_txvlan(&priv->si->hw, 0,
 				    !!(features & NETIF_F_HW_VLAN_CTAG_TX));
 
+	if (changed & NETIF_F_HW_VLAN_CTAG_FILTER) {
+		struct enetc_pf *pf = enetc_si_priv(priv->si);
+
+		if (!!(features & NETIF_F_HW_VLAN_CTAG_FILTER))
+			enetc_disable_si_vlan_promisc(pf, 0);
+		else
+			enetc_enable_si_vlan_promisc(pf, 0);
+	}
+
 	if (changed & NETIF_F_LOOPBACK)
 		enetc_set_loopback(ndev, !!(features & NETIF_F_LOOPBACK));
 
@@ -723,12 +712,11 @@ static void enetc_pf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
 
 	ndev->hw_features = NETIF_F_SG | NETIF_F_RXCSUM | NETIF_F_HW_CSUM |
 			    NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
-			    NETIF_F_LOOPBACK;
+			    NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_LOOPBACK;
 	ndev->features = NETIF_F_HIGHDMA | NETIF_F_SG |
 			 NETIF_F_RXCSUM | NETIF_F_HW_CSUM |
 			 NETIF_F_HW_VLAN_CTAG_TX |
-			 NETIF_F_HW_VLAN_CTAG_RX |
-			 NETIF_F_HW_VLAN_CTAG_FILTER;
+			 NETIF_F_HW_VLAN_CTAG_RX;
 
 	if (si->num_rss)
 		ndev->hw_features |= NETIF_F_RXHASH;
-- 
2.17.1

