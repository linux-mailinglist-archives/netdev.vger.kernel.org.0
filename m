Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0877D4CE670
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 19:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232169AbiCESqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 13:46:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiCESqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 13:46:44 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E9271BE4C4;
        Sat,  5 Mar 2022 10:45:53 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id 12so11158224oix.12;
        Sat, 05 Mar 2022 10:45:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PuOp5ntb+nEuSBc469Nks8I5JRj2m/8Ybt+N+X9PKqw=;
        b=ANn07dECYZcFM4Qmv3GAT2xaQscqR5agGyO9DWrkYlUdLJC06bFoDq23bkfFc/ayKh
         /Lj9qnnpnxE7IsD/YotJDRbH5sRkE7jti/Dg9tShKADg2CLGGKasObmRFZ7lQLSfDOXt
         UK0Bu5k+bdAXVAF9UZc47GCpgwNQLqrrLqN0gFvScb91yK8vt1O4IFWhZ8B3bBgK/tKf
         P2GL4Ww847WOs26MouuaTxGJZDGkPjmfI/IqdxDn9X44a/AMSdtIk4fihRT1Wc0OJvN9
         58j0BSU4d/zWaezrbY3uzSKICo+J4TDbanTE6uC5L5QzC4SGy8OnviD1eyiStjc2bgiD
         RM6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PuOp5ntb+nEuSBc469Nks8I5JRj2m/8Ybt+N+X9PKqw=;
        b=MVDF7DQsJRaKYA6AT0YANrcnWDpS5iVxHNapN3gkjdfTEehpXXfbl+D1cN9GQXPzKN
         KK12khEi6G6PPyMveG9G9yMetCJUZSIatDbcKDWPl4KVzTp3oRf/53mnNnOjcM66W0iO
         cpOsCksivSJ70QWdBEg5zEI7AXcgdLFrDZ6AdBkxgQDv6xEtf6ASRvSghFlx6yjanNvY
         BqTGRu2jP3CW06F7cbMtzaRk0/p1Hyi1WtKIdhrnLJLblOodYsAzFvzwijz2UXqxIerv
         +nbLAzfa6/GsBrQRVTyZWb3MjiR1zK5ENbXySpbv0V1VsGMZPqovD2driVZynQawdslT
         ks4g==
X-Gm-Message-State: AOAM5312KU9Yhx04/p2Ab5msNYlxNvfkIla3VTKgMuGQFXuIR2bdGTvu
        /elzMC7kBzmA8AtYj8T6O+M=
X-Google-Smtp-Source: ABdhPJzIPRFL630+DoDRGBco12MwwvcP83jHlei0WFj+nTL8I9SOpCGkvnJGLJ/Ek+HCu++oiaVEGg==
X-Received: by 2002:a05:6808:2209:b0:2d5:1bb4:bb37 with SMTP id bd9-20020a056808220900b002d51bb4bb37mr2482210oib.53.1646505952828;
        Sat, 05 Mar 2022 10:45:52 -0800 (PST)
Received: from localhost.localdomain ([2804:14c:485:4b69:1c78:cdf6:7845:f566])
        by smtp.gmail.com with ESMTPSA id o21-20020a056870e81500b000d9b2ba714asm3559179oan.21.2022.03.05.10.45.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 10:45:52 -0800 (PST)
From:   Fabio Estevam <festevam@gmail.com>
To:     kuba@kernel.org
Cc:     steve.glendinning@shawell.net, UNGLinuxDriver@microchip.com,
        fntoth@gmail.com, martyn.welch@collabora.com, andrew@lunn.ch,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Fabio Estevam <festevam@denx.de>
Subject: [PATCH] smsc95xx: Ignore -ENODEV errors when device is unplugged
Date:   Sat,  5 Mar 2022 15:45:03 -0300
Message-Id: <20220305184503.2954013-1-festevam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fabio Estevam <festevam@denx.de>

According to Documentation/driver-api/usb/URB.rst when a device
is unplugged usb_submit_urb() returns -ENODEV.

This error code propagates all the way up to usbnet_read_cmd() and
usbnet_write_cmd() calls inside the smsc95xx.c driver during
Ethernet cable unplug, unbind or reboot.

This causes the following errors to be shown on reboot, for example:

ci_hdrc ci_hdrc.1: remove, state 1
usb usb2: USB disconnect, device number 1
usb 2-1: USB disconnect, device number 2
usb 2-1.1: USB disconnect, device number 3
smsc95xx 2-1.1:1.0 eth1: unregister 'smsc95xx' usb-ci_hdrc.1-1.1, smsc95xx USB 2.0 Ethernet
smsc95xx 2-1.1:1.0 eth1: Failed to read reg index 0x00000114: -19
smsc95xx 2-1.1:1.0 eth1: Error reading MII_ACCESS
smsc95xx 2-1.1:1.0 eth1: __smsc95xx_mdio_read: MII is busy
smsc95xx 2-1.1:1.0 eth1: Failed to read reg index 0x00000114: -19
smsc95xx 2-1.1:1.0 eth1: Error reading MII_ACCESS
smsc95xx 2-1.1:1.0 eth1: __smsc95xx_mdio_read: MII is busy
smsc95xx 2-1.1:1.0 eth1: hardware isn't capable of remote wakeup
usb 2-1.4: USB disconnect, device number 4
ci_hdrc ci_hdrc.1: USB bus 2 deregistered
ci_hdrc ci_hdrc.0: remove, state 4
usb usb1: USB disconnect, device number 1
ci_hdrc ci_hdrc.0: USB bus 1 deregistered
imx2-wdt 30280000.watchdog: Device shutdown: Expect reboot!
reboot: Restarting system

Ignore the -ENODEV errors inside __smsc95xx_mdio_read() and
__smsc95xx_phy_wait_not_busy() and do not print error messages
when -ENODEV is returned.

Signed-off-by: Fabio Estevam <festevam@denx.de>
---
Hi,

Tested on 5.10.102 and 5.17-rc6.

On 5.10.102 this avoids the following kernel warning on reboot:

[   23.077179] ci_hdrc ci_hdrc.1: remove, state 1
[   23.081674] usb usb2: USB disconnect, device number 1
[   23.086740] usb 2-1: USB disconnect, device number 2
[   23.088393] smsc95xx 2-1.1:1.0 eth1: Failed to read reg index 0x00000114: -19
[   23.091718] usb 2-1.1: USB disconnect, device number 3
[   23.094090] smsc95xx 2-1.1:1.0 eth1: unregister 'smsc95xx'
usb-ci_hdrc.1-1.1, smsc95xx USB 2.0 Ethernet
[   23.098869] smsc95xx 2-1.1:1.0 eth1: Error reading MII_ACCESS
[   23.098877] smsc95xx 2-1.1:1.0 eth1: __smsc95xx_mdio_read: MII is busy
[   23.125763] ------------[ cut here ]------------
[   23.125860] smsc95xx 2-1.1:1.0 eth1: Failed to read reg index 0x00000114: -19
[   23.130393] WARNING: CPU: 3 PID: 119 at drivers/net/phy/phy.c:958
phy_error+0x14/0x60
[   23.130397] Modules linked in:
[   23.137550] smsc95xx 2-1.1:1.0 eth1: Error reading MII_ACCESS
[   23.145367]  iwlmvm mac80211 libarc4
[   23.148439] smsc95xx 2-1.1:1.0 eth1: __smsc95xx_mdio_read: MII is busy
[   23.154175]  af_alg caam_jr caamhash_desc caamalg_desc
crypto_engine rng_core authenc libdes btusb hci_uart btrtl btintel
btqca crct10dif_ce btbcm fsl_imx8_ddr_perf bluetooth ecdh_generic ecc
spi_imx spi_bitbang clk_bd718x7 at24 caam error rtc_snvs snvs_pwrkey
imx8mm_thermal imx_cpufreq_dt pwm_bl overlay iwlwifi cfg80211 rfkill
ipv6
[   23.193841] CPU: 3 PID: 119 Comm: kworker/u8:2 Not tainted 5.10.102-stable-standard #1
[   23.201764] Hardware name: CompuLab i.MX8MM IoT Gateway (DT)
[   23.207433] Workqueue: events_power_efficient phy_state_machine
[   23.213362] pstate: 60000005 (nZCv daif -PAN -UAO -TCO BTYPE=--)
[   23.219375] pc : phy_error+0x14/0x60
[   23.222954] lr : phy_state_machine+0x88/0x218
[   23.227315] sp : ffff800011743d20
[   23.230631] x29: ffff800011743d20 x28: ffff800011207000
[   23.235952] x27: ffff000000008070 x26: ffff000000008020
[   23.241273] x25: 0000000000000000 x24: 00000000ffffffed
[   23.246595] x23: ffff0000002e44e8 x22: ffff000000161c80
[   23.251915] x21: ffff0000002e4000 x20: 0000000000000005
[   23.257238] x19: ffff0000002e4000 x18: 0000000000000010
[   23.262558] x17: 0000000000000000 x16: 0000000000000000
[   23.267878] x15: 0000000e9816052e x14: 0000000000000000
[   23.273198] x13: 000000000000002f x12: 0000000000000198
[   23.278518] x11: 000000000000c6f5 x10: 000000000000c6f5
[   23.283838] x9 : 0000000000000000 x8 : ffff00007fbbc0c0
[   23.289161] x7 : ffff00007fbbb600 x6 : 0000000000000000
[   23.294481] x5 : 0000000000000008 x4 : 0000000000000000
[   23.299801] x3 : ffff0000002e44e8 x2 : 0000000000000000
[   23.305121] x1 : ffff000000161c80 x0 : ffff0000002e4000
[   23.310442] Call trace:
[   23.312894]  phy_error+0x14/0x60
[   23.316125]  phy_state_machine+0x88/0x218
[   23.320144]  process_one_work+0x1bc/0x338
[   23.324158]  worker_thread+0x50/0x420
[   23.327826]  kthread+0x140/0x160
[   23.331061]  ret_from_fork+0x10/0x34
[   23.334639] ---[ end trace 2cf86ece81b89776 ]---
[   23.339391] smsc95xx 2-1.1:1.0 eth1: Failed to read reg index 0x00000114: -19
[   23.346550] smsc95xx 2-1.1:1.0 eth1: Error reading MII_ACCESS
[   23.352312] smsc95xx 2-1.1:1.0 eth1: __smsc95xx_mdio_read: MII is busy
[   23.358863] smsc95xx 2-1.1:1.0 eth1: hardware isn't capable of remote wakeup
[   23.384599] usb 2-1.4: USB disconnect, device number 4
[   23.394062] ci_hdrc ci_hdrc.1: USB bus 2 deregistered
[   23.401921] ci_hdrc ci_hdrc.0: remove, state 4
[   23.406444] usb usb1: USB disconnect, device number 1
[   23.412082] ci_hdrc ci_hdrc.0: USB bus 1 deregistered
[   23.438063] imx2-wdt 30280000.watchdog: Device shutdown: Expect reboot!
[   23.444895] reboot: Restarting system

 drivers/net/usb/smsc95xx.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index b17bff6a1015..61a5748da133 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -84,7 +84,7 @@ static int __must_check __smsc95xx_read_reg(struct usbnet *dev, u32 index,
 	ret = fn(dev, USB_VENDOR_REQUEST_READ_REGISTER, USB_DIR_IN
 		 | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 		 0, index, &buf, 4);
-	if (unlikely(ret < 0)) {
+	if (ret < 0 && ret != -ENODEV) {
 		netdev_warn(dev->net, "Failed to read reg index 0x%08x: %d\n",
 			    index, ret);
 		return ret;
@@ -116,7 +116,7 @@ static int __must_check __smsc95xx_write_reg(struct usbnet *dev, u32 index,
 	ret = fn(dev, USB_VENDOR_REQUEST_WRITE_REGISTER, USB_DIR_OUT
 		 | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 		 0, index, &buf, 4);
-	if (unlikely(ret < 0))
+	if (ret < 0 && ret != -ENODEV)
 		netdev_warn(dev->net, "Failed to write reg index 0x%08x: %d\n",
 			    index, ret);
 
@@ -159,6 +159,9 @@ static int __must_check __smsc95xx_phy_wait_not_busy(struct usbnet *dev,
 	do {
 		ret = __smsc95xx_read_reg(dev, MII_ADDR, &val, in_pm);
 		if (ret < 0) {
+			/* Ignore -ENODEV error during disconnect() */
+			if (ret == -ENODEV)
+				return 0;
 			netdev_warn(dev->net, "Error reading MII_ACCESS\n");
 			return ret;
 		}
@@ -194,7 +197,8 @@ static int __smsc95xx_mdio_read(struct usbnet *dev, int phy_id, int idx,
 	addr = mii_address_cmd(phy_id, idx, MII_READ_ | MII_BUSY_);
 	ret = __smsc95xx_write_reg(dev, MII_ADDR, addr, in_pm);
 	if (ret < 0) {
-		netdev_warn(dev->net, "Error writing MII_ADDR\n");
+		if (ret != -ENODEV)
+			netdev_warn(dev->net, "Error writing MII_ADDR\n");
 		goto done;
 	}
 
@@ -206,7 +210,8 @@ static int __smsc95xx_mdio_read(struct usbnet *dev, int phy_id, int idx,
 
 	ret = __smsc95xx_read_reg(dev, MII_DATA, &val, in_pm);
 	if (ret < 0) {
-		netdev_warn(dev->net, "Error reading MII_DATA\n");
+		if (ret != -ENODEV)
+			netdev_warn(dev->net, "Error reading MII_DATA\n");
 		goto done;
 	}
 
@@ -214,6 +219,10 @@ static int __smsc95xx_mdio_read(struct usbnet *dev, int phy_id, int idx,
 
 done:
 	mutex_unlock(&dev->phy_mutex);
+
+	/* Ignore -ENODEV error during disconnect() */
+	if (ret == -ENODEV)
+		return 0;
 	return ret;
 }
 
@@ -235,7 +244,8 @@ static void __smsc95xx_mdio_write(struct usbnet *dev, int phy_id,
 	val = regval;
 	ret = __smsc95xx_write_reg(dev, MII_DATA, val, in_pm);
 	if (ret < 0) {
-		netdev_warn(dev->net, "Error writing MII_DATA\n");
+		if (ret != -ENODEV)
+			netdev_warn(dev->net, "Error writing MII_DATA\n");
 		goto done;
 	}
 
@@ -243,7 +253,8 @@ static void __smsc95xx_mdio_write(struct usbnet *dev, int phy_id,
 	addr = mii_address_cmd(phy_id, idx, MII_WRITE_ | MII_BUSY_);
 	ret = __smsc95xx_write_reg(dev, MII_ADDR, addr, in_pm);
 	if (ret < 0) {
-		netdev_warn(dev->net, "Error writing MII_ADDR\n");
+		if (ret != -ENODEV)
+			netdev_warn(dev->net, "Error writing MII_ADDR\n");
 		goto done;
 	}
 
-- 
2.25.1

