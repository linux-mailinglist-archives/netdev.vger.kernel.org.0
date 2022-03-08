Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10ED94D2498
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 00:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbiCHXGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 18:06:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiCHXGC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 18:06:02 -0500
Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE905EDC3
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 15:05:02 -0800 (PST)
Received: (wp-smtpd smtp.wp.pl 26950 invoked from network); 9 Mar 2022 00:04:59 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1646780699; bh=OLgWtwFbtTxDfDBG+/DhEFnjk/bpFHtT+b+PcGpPCqs=;
          h=From:To:Cc:Subject;
          b=x7/aEyw3SWhmJPvNg9B2YQa8fgwwBtbvxxOOTEjVFsz9vXuZCT47ZLhDgEfcWl9/2
           BCgpsEMofyB5uYQSO0wG0pGemzuIfkIaeRo/qYIcWo7yJ0C2a+7Klm99foUa2pOW3Y
           XGKJrOcdDLgwS1itdZjHQSLl+E1M/8+akCfwGFCA=
Received: from riviera.nat.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 9 Mar 2022 00:04:59 +0100
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Aleksander Jan Bajkowski <olek2@wp.pl>,
        Thomas Nixon <tom@tomn.co.uk>
Subject: [PATCH net-next] net: dsa: lantiq_gswip: enable jumbo frames on GSWIP
Date:   Wed,  9 Mar 2022 00:04:57 +0100
Message-Id: <20220308230457.1599237-1-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: 570e89349c46434796f7ed3f4d7bf1ee
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [8bNE]                               
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This enables non-standard MTUs on a per-port basis, with the overall
frame size set based on the CPU port.

When the MTU is not changed, this should have no effect.

Long packets crash the switch with MTUs of greater than 2526, so the
maximum is limited for now. Medium packets are sometimes dropped (e.g.
TCP over 2477, UDP over 2516-2519, ICMP over 2526), Hence an MTU value
of 2400 seems safe.

Signed-off-by: Thomas Nixon <tom@tomn.co.uk>
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 drivers/net/dsa/lantiq_gswip.c | 53 +++++++++++++++++++++++++++++++---
 1 file changed, 49 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 8a7a8093a156..f7059ab3b014 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -213,6 +213,7 @@
 #define  GSWIP_MAC_CTRL_0_GMII_MII	0x0001
 #define  GSWIP_MAC_CTRL_0_GMII_RGMII	0x0002
 #define GSWIP_MAC_CTRL_2p(p)		(0x905 + ((p) * 0xC))
+#define GSWIP_MAC_CTRL_2_LCHKL		BIT(2) /* Frame Length Check Long Enable */
 #define GSWIP_MAC_CTRL_2_MLEN		BIT(3) /* Maximum Untagged Frame Lnegth */
 
 /* Ethernet Switch Fetch DMA Port Control Register */
@@ -239,6 +240,15 @@
 
 #define XRX200_GPHY_FW_ALIGN	(16 * 1024)
 
+/* Maximum packet size supported by the switch. In theory this should be 10240,
+ * but long packets currently cause lock-ups with an MTU of over 2526. Medium
+ * packets are sometimes dropped (e.g. TCP over 2477, UDP over 2516-2519, ICMP
+ * over 2526), hence an MTU value of 2400 seems safe. This issue only affects
+ * packet reception. This is probably caused by the PPA engine, which is on the
+ * RX part of the device. Packet transmission works properly up to 10240.
+ */
+#define GSWIP_MAX_PACKET_LENGTH	2400
+
 struct gswip_hw_info {
 	int max_ports;
 	int cpu_port;
@@ -863,10 +873,6 @@ static int gswip_setup(struct dsa_switch *ds)
 	gswip_switch_mask(priv, 0, GSWIP_PCE_PCTRL_0_INGRESS,
 			  GSWIP_PCE_PCTRL_0p(cpu_port));
 
-	gswip_switch_mask(priv, 0, GSWIP_MAC_CTRL_2_MLEN,
-			  GSWIP_MAC_CTRL_2p(cpu_port));
-	gswip_switch_w(priv, VLAN_ETH_FRAME_LEN + 8 + ETH_FCS_LEN,
-		       GSWIP_MAC_FLEN);
 	gswip_switch_mask(priv, 0, GSWIP_BM_QUEUE_GCTRL_GL_MOD,
 			  GSWIP_BM_QUEUE_GCTRL);
 
@@ -883,6 +889,8 @@ static int gswip_setup(struct dsa_switch *ds)
 		return err;
 	}
 
+	ds->mtu_enforcement_ingress = true;
+
 	gswip_port_enable(ds, cpu_port, NULL);
 
 	ds->configure_vlan_while_not_filtering = false;
@@ -1446,6 +1454,39 @@ static int gswip_port_fdb_dump(struct dsa_switch *ds, int port,
 	return 0;
 }
 
+static int gswip_port_max_mtu(struct dsa_switch *ds, int port)
+{
+	/* Includes 8 bytes for special header. */
+	return GSWIP_MAX_PACKET_LENGTH - VLAN_ETH_HLEN - ETH_FCS_LEN;
+}
+
+static int gswip_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
+{
+	struct gswip_priv *priv = ds->priv;
+	int cpu_port = priv->hw_info->cpu_port;
+
+	/* CPU port always has maximum mtu of user ports, so use it to set
+	 * switch frame size, including 8 byte special header.
+	 */
+	if (port == cpu_port) {
+		new_mtu += 8;
+		gswip_switch_w(priv, VLAN_ETH_HLEN + new_mtu + ETH_FCS_LEN,
+			       GSWIP_MAC_FLEN);
+	}
+
+	/* Enable MLEN for ports with non-standard MTUs, including the special
+	 * header on the CPU port added above.
+	 */
+	if (new_mtu != ETH_DATA_LEN)
+		gswip_switch_mask(priv, 0, GSWIP_MAC_CTRL_2_MLEN,
+				  GSWIP_MAC_CTRL_2p(port));
+	else
+		gswip_switch_mask(priv, GSWIP_MAC_CTRL_2_MLEN, 0,
+				  GSWIP_MAC_CTRL_2p(port));
+
+	return 0;
+}
+
 static void gswip_xrx200_phylink_get_caps(struct dsa_switch *ds, int port,
 					  struct phylink_config *config)
 {
@@ -1791,6 +1832,8 @@ static const struct dsa_switch_ops gswip_xrx200_switch_ops = {
 	.port_fdb_add		= gswip_port_fdb_add,
 	.port_fdb_del		= gswip_port_fdb_del,
 	.port_fdb_dump		= gswip_port_fdb_dump,
+	.port_change_mtu	= gswip_port_change_mtu,
+	.port_max_mtu		= gswip_port_max_mtu,
 	.phylink_get_caps	= gswip_xrx200_phylink_get_caps,
 	.phylink_mac_config	= gswip_phylink_mac_config,
 	.phylink_mac_link_down	= gswip_phylink_mac_link_down,
@@ -1815,6 +1858,8 @@ static const struct dsa_switch_ops gswip_xrx300_switch_ops = {
 	.port_fdb_add		= gswip_port_fdb_add,
 	.port_fdb_del		= gswip_port_fdb_del,
 	.port_fdb_dump		= gswip_port_fdb_dump,
+	.port_change_mtu	= gswip_port_change_mtu,
+	.port_max_mtu		= gswip_port_max_mtu,
 	.phylink_get_caps	= gswip_xrx300_phylink_get_caps,
 	.phylink_mac_config	= gswip_phylink_mac_config,
 	.phylink_mac_link_down	= gswip_phylink_mac_link_down,
-- 
2.30.2

