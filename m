Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6675A65FEA2
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 11:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232136AbjAFKRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 05:17:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjAFKRg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 05:17:36 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 618B026E6;
        Fri,  6 Jan 2023 02:17:34 -0800 (PST)
Received: from localhost.localdomain (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 6BD9C855F3;
        Fri,  6 Jan 2023 11:17:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1673000251;
        bh=/eIa0D/g1AhXYWja1k/WFzyx8e1tJpZ3rsMlh8fHKdg=;
        h=From:To:Cc:Subject:Date:From;
        b=BU8uzegwb9FW3hf1KlKeaGXUXU1pYZ3n9fOm8K+sKmkj+EO1EZVKlufe/SN3bjReM
         xSMFNUSgKlP9UY1OBiqbKGgpsS3JIFyndY6+ivwClmSQKshEnpg78a1VAtI+ZDspQa
         Jf4cfJFIMseY93DJr8VDPEQdwOBvv85bWnNfL0/BiO2LSHFlR7fWr1d+owe/QRuPDh
         HIKU2Kmq5BjxFWSmKtACIDqiC0PU/YtyTumdg2Tw3ymnSxVCenxH1HHaa0YnPC3rB0
         8WExpeibhPlV24MqejOTqq4vM1HRBseulN/es0anRMS9gGYaYeKzsTer1M8LZiQLb9
         7EWysRoqkBnzg==
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukasz Majewski <lukma@denx.de>
Subject: [PATCH v4 1/3] dsa: marvell: Provide per device information about max frame size
Date:   Fri,  6 Jan 2023 11:16:49 +0100
Message-Id: <20230106101651.1137755-1-lukma@denx.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Different Marvell DSA switches support different size of max frame
bytes to be sent. This value corresponds to the memory allocated
in switch to store single frame.

For example mv88e6185 supports max 1632 bytes, which is now in-driver
standard value. On the other hand - mv88e6250 supports 2048 bytes.
To be more interresting - devices supporting jumbo frames - use yet
another value (10240 bytes)

As this value is internal and may be different for each switch IC,
new entry in struct mv88e6xxx_info has been added to store it.

This commit doesn't change the code functionality - it just provides
the max frame size value explicitly - up till now it has been
assigned depending on the callback provided by the IC driver
(e.g. .set_max_frame_size, .port_set_jumbo_size).

Signed-off-by: Lukasz Majewski <lukma@denx.de>

---
Changes for v2:
- Define max_frame_size with default value of 1632 bytes,
- Set proper value for the mv88e6250 switch SoC (linkstreet) family

Changes for v3:
- Add default value for 1632B of the max frame size (to avoid problems
  with not defined values)

Changes for v4:
- Rework the mv88e6xxx_get_max_mtu() by using per device defined
  max_frame_size value

- Add WARN_ON_ONCE() when max_frame_size is not defined

- Add description for the new 'max_frame_size' member of mv88e6xxx_info
---
 drivers/net/dsa/mv88e6xxx/chip.c | 41 ++++++++++++++++++++++++++++----
 drivers/net/dsa/mv88e6xxx/chip.h |  6 +++++
 2 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 242b8b325504..fc6d98c4a029 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3545,11 +3545,10 @@ static int mv88e6xxx_get_max_mtu(struct dsa_switch *ds, int port)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 
-	if (chip->info->ops->port_set_jumbo_size)
-		return 10240 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
-	else if (chip->info->ops->set_max_frame_size)
-		return 1632 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
-	return 1522 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
+	WARN_ON_ONCE(!chip->info->max_frame_size);
+
+	return chip->info->max_frame_size - VLAN_ETH_HLEN - EDSA_HLEN
+		- ETH_FCS_LEN;
 }
 
 static int mv88e6xxx_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
@@ -4955,6 +4954,7 @@ static const struct mv88e6xxx_ops mv88e6250_ops = {
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6250_ptp_ops,
 	.phylink_get_caps = mv88e6250_phylink_get_caps,
+	.set_max_frame_size = mv88e6185_g1_set_max_frame_size,
 };
 
 static const struct mv88e6xxx_ops mv88e6290_ops = {
@@ -5543,6 +5543,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 5,
 		.max_vid = 4095,
 		.max_sid = 63,
+		.max_frame_size = 1522,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5565,6 +5566,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_ports = 11,
 		.num_internal_phys = 0,
 		.max_vid = 4095,
+		.max_frame_size = 1632,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5586,6 +5588,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 8,
 		.max_vid = 4095,
 		.max_sid = 63,
+		.max_frame_size = 1632,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5610,6 +5613,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 5,
 		.max_vid = 4095,
 		.max_sid = 63,
+		.max_frame_size = 1632,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5633,6 +5637,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_ports = 8,
 		.num_internal_phys = 0,
 		.max_vid = 4095,
+		.max_frame_size = 10240,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5655,6 +5660,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_gpio = 11,
 		.max_vid = 4095,
 		.max_sid = 63,
+		.max_frame_size = 10240,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x10,
 		.global1_addr = 0x1b,
@@ -5679,6 +5685,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 5,
 		.max_vid = 4095,
 		.max_sid = 63,
+		.max_frame_size = 1632,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5704,6 +5711,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 0,
 		.max_vid = 4095,
 		.max_sid = 63,
+		.max_frame_size = 1632,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5728,6 +5736,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 5,
 		.max_vid = 4095,
 		.max_sid = 63,
+		.max_frame_size = 10240,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5753,6 +5762,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_gpio = 15,
 		.max_vid = 4095,
 		.max_sid = 63,
+		.max_frame_size = 10240,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5777,6 +5787,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 5,
 		.max_vid = 4095,
 		.max_sid = 63,
+		.max_frame_size = 10240,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5802,6 +5813,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_gpio = 15,
 		.max_vid = 4095,
 		.max_sid = 63,
+		.max_frame_size = 10240,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5825,6 +5837,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_ports = 10,
 		.num_internal_phys = 0,
 		.max_vid = 4095,
+		.max_frame_size = 1632,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5848,6 +5861,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_gpio = 16,
 		.max_vid = 8191,
 		.max_sid = 63,
+		.max_frame_size = 10240,
 		.port_base_addr = 0x0,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5872,6 +5886,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_gpio = 16,
 		.max_vid = 8191,
 		.max_sid = 63,
+		.max_frame_size = 1522,
 		.port_base_addr = 0x0,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5895,6 +5910,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 9,
 		.max_vid = 8191,
 		.max_sid = 63,
+		.max_frame_size = 1522,
 		.port_base_addr = 0x0,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5918,6 +5934,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 9,
 		.max_vid = 8191,
 		.max_sid = 63,
+		.max_frame_size = 1522,
 		.port_base_addr = 0x0,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5941,6 +5958,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 9,
 		.max_vid = 8191,
 		.max_sid = 63,
+		.max_frame_size = 1522,
 		.port_base_addr = 0x0,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5968,6 +5986,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 2,
 		.invalid_port_mask = BIT(2) | BIT(3) | BIT(4),
 		.max_vid = 4095,
+		.max_frame_size = 2048,
 		.port_base_addr = 0x08,
 		.phy_base_addr = 0x00,
 		.global1_addr = 0x0f,
@@ -5992,6 +6011,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_gpio = 15,
 		.max_vid = 4095,
 		.max_sid = 63,
+		.max_frame_size = 10240,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -6015,6 +6035,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.max_vid = 4095,
+		.max_frame_size = 2048,
 		.port_base_addr = 0x08,
 		.phy_base_addr = 0x00,
 		.global1_addr = 0x0f,
@@ -6038,6 +6059,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_gpio = 16,
 		.max_vid = 8191,
 		.max_sid = 63,
+		.max_frame_size = 1522,
 		.port_base_addr = 0x0,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -6062,6 +6084,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 5,
 		.num_gpio = 15,
 		.max_vid = 4095,
+		.max_frame_size = 10240,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -6087,6 +6110,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 5,
 		.num_gpio = 15,
 		.max_vid = 4095,
+		.max_frame_size = 10240,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -6112,6 +6136,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_gpio = 11,
 		.max_vid = 4095,
 		.max_sid = 63,
+		.max_frame_size = 10240,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x10,
 		.global1_addr = 0x1b,
@@ -6137,6 +6162,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 5,
 		.max_vid = 4095,
 		.max_sid = 63,
+		.max_frame_size = 10240,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -6161,6 +6187,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 5,
 		.max_vid = 4095,
 		.max_sid = 63,
+		.max_frame_size = 10240,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -6186,6 +6213,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_gpio = 15,
 		.max_vid = 4095,
 		.max_sid = 63,
+		.max_frame_size = 10240,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -6211,6 +6239,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_gpio = 16,
 		.max_vid = 8191,
 		.max_sid = 63,
+		.max_frame_size = 10240,
 		.port_base_addr = 0x0,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -6236,6 +6265,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_gpio = 16,
 		.max_vid = 8191,
 		.max_sid = 63,
+		.max_frame_size = 10240,
 		.port_base_addr = 0x0,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -6260,6 +6290,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 9,
 		.max_vid = 8191,
 		.max_sid = 63,
+		.max_frame_size = 10240,
 		.port_base_addr = 0x0,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index e693154cf803..31c09b66fbff 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -132,6 +132,12 @@ struct mv88e6xxx_info {
 	unsigned int num_gpio;
 	unsigned int max_vid;
 	unsigned int max_sid;
+
+	/* Max Frame Size.
+	 * This value corresponds to the memory allocated in switch internal
+	 * memory to store single frame.
+	 */
+	unsigned int max_frame_size;
 	unsigned int port_base_addr;
 	unsigned int phy_base_addr;
 	unsigned int global1_addr;
-- 
2.20.1

