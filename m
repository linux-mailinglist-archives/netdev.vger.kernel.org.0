Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8E435F690
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 16:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351947AbhDNOsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 10:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232151AbhDNOsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 10:48:43 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB1FAC061574;
        Wed, 14 Apr 2021 07:48:21 -0700 (PDT)
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 8F7B422236;
        Wed, 14 Apr 2021 16:48:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1618411700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=DRE++d7dvKVi65uc75EP/u33OrOWHzediP/38agxpRE=;
        b=er+q0RGhw9RgholiKai2xEqChWa6x2Am29Er2wHDePBve6YPe2m8jJz/AP66oNkdXIkIzZ
        5TdGjhEQv6ZKS0m3yCxuL7DXz8toJ02fo2d1Hg9y/MPjmuQin50EBo8+2ThlmnJtUNLxkB
        na4PdjKFRx4v3am/53limSEOuhpcoIc=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next] net: enetc: fetch MAC address from device tree
Date:   Wed, 14 Apr 2021 16:48:14 +0200
Message-Id: <20210414144814.25382-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Normally, the bootloader will already initialize the MAC address
registers of the ENETC and the driver will just use them or generate a
random one, if it is not initialized.

Add a new way to provide the MAC address: via device tree. Besides the
usual 'mac-address' property, there is also the possibility to fetch it
via a NVMEM provider. The sl28 board stores the MAC address in the SPI
NOR flash OTP region. Having this will allow linux to fetch the MAC
address from there without being dependent on the bootloader.

No in-tree boards have the device tree properties set, thus for these,
this is a no-op.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 65 ++++++++++++++-----
 1 file changed, 49 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index f61fedf462e5..30b22b71630e 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -390,23 +390,54 @@ static int enetc_pf_set_vf_spoofchk(struct net_device *ndev, int vf, bool en)
 	return 0;
 }
 
-static void enetc_port_setup_primary_mac_address(struct enetc_si *si)
+static int enetc_setup_mac_address(struct device_node *np, struct enetc_pf *pf,
+				   int si)
 {
-	unsigned char mac_addr[MAX_ADDR_LEN];
-	struct enetc_pf *pf = enetc_si_priv(si);
-	struct enetc_hw *hw = &si->hw;
-	int i;
+	struct device *dev = &pf->si->pdev->dev;
+	struct enetc_hw *hw = &pf->si->hw;
+	u8 mac_addr[ETH_ALEN] = { 0 };
+	int err;
 
-	/* check MAC addresses for PF and all VFs, if any is 0 set it ro rand */
-	for (i = 0; i < pf->total_vfs + 1; i++) {
-		enetc_pf_get_primary_mac_addr(hw, i, mac_addr);
-		if (!is_zero_ether_addr(mac_addr))
-			continue;
+	/* (1) try to get the MAC address from the device tree */
+	if (np) {
+		err = of_get_mac_address(np, mac_addr);
+		if (err == -EPROBE_DEFER)
+			return err;
+	}
+
+	/* (2) bootloader supplied MAC address */
+	if (is_zero_ether_addr(mac_addr))
+		enetc_pf_get_primary_mac_addr(hw, si, mac_addr);
+
+	/* (3) choose a random one */
+	if (is_zero_ether_addr(mac_addr)) {
 		eth_random_addr(mac_addr);
-		dev_info(&si->pdev->dev, "no MAC address specified for SI%d, using %pM\n",
-			 i, mac_addr);
-		enetc_pf_set_primary_mac_addr(hw, i, mac_addr);
+		dev_info(dev, "no MAC address specified for SI%d, using %pM\n",
+			 si, mac_addr);
 	}
+
+	enetc_pf_set_primary_mac_addr(hw, si, mac_addr);
+
+	return 0;
+}
+
+static int enetc_setup_mac_addresses(struct device_node *np,
+				     struct enetc_pf *pf)
+{
+	int err, i;
+
+	/* The PF might take its MAC from the device tree */
+	err = enetc_setup_mac_address(np, pf, 0);
+	if (err)
+		return err;
+
+	for (i = 0; i < pf->total_vfs; i++) {
+		err = enetc_setup_mac_address(NULL, pf, i + 1);
+		if (err)
+			return err;
+	}
+
+	return 0;
 }
 
 static void enetc_port_assign_rfs_entries(struct enetc_si *si)
@@ -562,9 +593,6 @@ static void enetc_configure_port(struct enetc_pf *pf)
 	/* split up RFS entries */
 	enetc_port_assign_rfs_entries(pf->si);
 
-	/* fix-up primary MAC addresses, if not set already */
-	enetc_port_setup_primary_mac_address(pf->si);
-
 	/* enforce VLAN promisc mode for all SIs */
 	pf->vlan_promisc_simap = ENETC_VLAN_PROMISC_MAP_ALL;
 	enetc_set_vlan_promisc(hw, pf->vlan_promisc_simap);
@@ -1137,6 +1165,10 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 	pf->si = si;
 	pf->total_vfs = pci_sriov_get_totalvfs(pdev);
 
+	err = enetc_setup_mac_addresses(node, pf);
+	if (err)
+		goto err_setup_mac_addresses;
+
 	enetc_configure_port(pf);
 
 	enetc_get_si_caps(si);
@@ -1204,6 +1236,7 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 err_init_port_rss:
 err_init_port_rfs:
 err_device_disabled:
+err_setup_mac_addresses:
 	enetc_teardown_cbdr(&si->cbd_ring);
 err_setup_cbdr:
 err_map_pf_space:
-- 
2.20.1

