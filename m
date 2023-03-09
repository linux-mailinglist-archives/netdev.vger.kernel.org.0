Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9366B249E
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 13:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbjCIMzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 07:55:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbjCIMzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 07:55:10 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9489F8C5A0;
        Thu,  9 Mar 2023 04:55:07 -0800 (PST)
Received: from localhost.localdomain (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 0AE6885E7B;
        Thu,  9 Mar 2023 13:55:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1678366503;
        bh=t175zUR0JS2y8jH+2a8DPk99nDwK2HWMrLZdfrlhGrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zleKWsSuWv1eHOZljNQ+wGhh9ph+fpm7VA8kUewhGTVxlnqugo5YCL1qoN7Orj+wA
         XMSZqnCiJR+sqjlFeEgheKHq7B5ozsi6BxmtWn/FyFCCZCw5DLZSNICBm43DFaAWwX
         2BgluYehPMRjJBDSG9wM4uhsyBoek8bZCXzmKTaPDHWaOPHLkw/eF4JnpT30ydvwxk
         bJStDR4QRWwkewOYxvdfx4bmFZgE4EFRYtyLEa9KAvVjnIJAh98Dw+/smB8f2gDKp8
         7iafwwwq+1tUK7P8dsmXrnTC9XPbyq4ZmmmfHfRxsDOkaBKPqBZV9ndCQRsEvse9z1
         ycqeCzqMH0O9g==
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukasz Majewski <lukma@denx.de>
Subject: [PATCH 1/7] dsa: marvell: Provide per device information about max frame size
Date:   Thu,  9 Mar 2023 13:54:15 +0100
Message-Id: <20230309125421.3900962-2-lukma@denx.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230309125421.3900962-1-lukma@denx.de>
References: <20230309125421.3900962-1-lukma@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
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
To be more interesting - devices supporting jumbo frames - use yet
another value (10240 bytes)

As this value is internal and may be different for each switch IC,
new entry in struct mv88e6xxx_info has been added to store it.

This commit doesn't change the code functionality - it just provides
the max frame size value explicitly - up till now it has been
assigned depending on the callback provided by the switch driver
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

Changes for v5:
- Move some code fragments (like get_mtu callback changes) to separate
  patches
---
 drivers/net/dsa/mv88e6xxx/chip.c | 31 +++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/chip.h |  6 ++++++
 2 files changed, 37 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 0a5d6c7bb128..c097a0b19ba6 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5626,6 +5626,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 5,
 		.max_vid = 4095,
 		.max_sid = 63,
+		.max_frame_size = 1522,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5648,6 +5649,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_ports = 11,
 		.num_internal_phys = 0,
 		.max_vid = 4095,
+		.max_frame_size = 1632,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5669,6 +5671,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 8,
 		.max_vid = 4095,
 		.max_sid = 63,
+		.max_frame_size = 1632,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5693,6 +5696,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 5,
 		.max_vid = 4095,
 		.max_sid = 63,
+		.max_frame_size = 1632,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5716,6 +5720,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_ports = 8,
 		.num_internal_phys = 0,
 		.max_vid = 4095,
+		.max_frame_size = 10240,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5738,6 +5743,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_gpio = 11,
 		.max_vid = 4095,
 		.max_sid = 63,
+		.max_frame_size = 10240,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x10,
 		.global1_addr = 0x1b,
@@ -5762,6 +5768,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 5,
 		.max_vid = 4095,
 		.max_sid = 63,
+		.max_frame_size = 1632,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5787,6 +5794,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 0,
 		.max_vid = 4095,
 		.max_sid = 63,
+		.max_frame_size = 1632,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5811,6 +5819,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 5,
 		.max_vid = 4095,
 		.max_sid = 63,
+		.max_frame_size = 10240,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5836,6 +5845,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_gpio = 15,
 		.max_vid = 4095,
 		.max_sid = 63,
+		.max_frame_size = 10240,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5860,6 +5870,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 5,
 		.max_vid = 4095,
 		.max_sid = 63,
+		.max_frame_size = 10240,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5885,6 +5896,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_gpio = 15,
 		.max_vid = 4095,
 		.max_sid = 63,
+		.max_frame_size = 10240,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5908,6 +5920,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_ports = 10,
 		.num_internal_phys = 0,
 		.max_vid = 4095,
+		.max_frame_size = 1632,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5931,6 +5944,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_gpio = 16,
 		.max_vid = 8191,
 		.max_sid = 63,
+		.max_frame_size = 10240,
 		.port_base_addr = 0x0,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5955,6 +5969,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_gpio = 16,
 		.max_vid = 8191,
 		.max_sid = 63,
+		.max_frame_size = 1522,
 		.port_base_addr = 0x0,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5978,6 +5993,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 9,
 		.max_vid = 8191,
 		.max_sid = 63,
+		.max_frame_size = 1522,
 		.port_base_addr = 0x0,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -6001,6 +6017,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 9,
 		.max_vid = 8191,
 		.max_sid = 63,
+		.max_frame_size = 1522,
 		.port_base_addr = 0x0,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -6024,6 +6041,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 9,
 		.max_vid = 8191,
 		.max_sid = 63,
+		.max_frame_size = 1522,
 		.port_base_addr = 0x0,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -6051,6 +6069,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 2,
 		.invalid_port_mask = BIT(2) | BIT(3) | BIT(4),
 		.max_vid = 4095,
+		.max_frame_size = 2048,
 		.port_base_addr = 0x08,
 		.phy_base_addr = 0x00,
 		.global1_addr = 0x0f,
@@ -6075,6 +6094,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_gpio = 15,
 		.max_vid = 4095,
 		.max_sid = 63,
+		.max_frame_size = 10240,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -6098,6 +6118,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.max_vid = 4095,
+		.max_frame_size = 2048,
 		.port_base_addr = 0x08,
 		.phy_base_addr = 0x00,
 		.global1_addr = 0x0f,
@@ -6121,6 +6142,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_gpio = 16,
 		.max_vid = 8191,
 		.max_sid = 63,
+		.max_frame_size = 1522,
 		.port_base_addr = 0x0,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -6145,6 +6167,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 5,
 		.num_gpio = 15,
 		.max_vid = 4095,
+		.max_frame_size = 10240,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -6170,6 +6193,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 5,
 		.num_gpio = 15,
 		.max_vid = 4095,
+		.max_frame_size = 10240,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -6195,6 +6219,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_gpio = 11,
 		.max_vid = 4095,
 		.max_sid = 63,
+		.max_frame_size = 10240,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x10,
 		.global1_addr = 0x1b,
@@ -6220,6 +6245,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 5,
 		.max_vid = 4095,
 		.max_sid = 63,
+		.max_frame_size = 10240,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -6244,6 +6270,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 5,
 		.max_vid = 4095,
 		.max_sid = 63,
+		.max_frame_size = 10240,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -6269,6 +6296,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_gpio = 15,
 		.max_vid = 4095,
 		.max_sid = 63,
+		.max_frame_size = 10240,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -6294,6 +6322,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_gpio = 16,
 		.max_vid = 8191,
 		.max_sid = 63,
+		.max_frame_size = 10240,
 		.port_base_addr = 0x0,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -6319,6 +6348,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_gpio = 16,
 		.max_vid = 8191,
 		.max_sid = 63,
+		.max_frame_size = 10240,
 		.port_base_addr = 0x0,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -6343,6 +6373,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 9,
 		.max_vid = 8191,
 		.max_sid = 63,
+		.max_frame_size = 10240,
 		.port_base_addr = 0x0,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index da6e1339f809..e2b88f1f8376 100644
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

