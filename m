Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD5723CD1C4
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 12:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236300AbhGSJgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 05:36:23 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:33644 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236292AbhGSJgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 05:36:21 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1626689820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CuTPlhmxaB6rZmMnaD1VhInphyN85lMOA0JYAV15TK8=;
        b=Z9HNZtbWUfRIZ8omDUD1jZLBjSHHgyZCwAjgPlxQWnaR9iwFjOWRzuZfJitW6/AcGODFP0
        9ZriZHU58AKK5HCv+cgOiEgcJpu2DBeq09OxN2pJ3hFxI3Vjr4v/8DVFs1zBDvqbMZnnn4
        rq8OdzPV0Uy42YeQQHHgU1WcU2DwsXyERH6Ovb0V2APptDtAs40pmZ9hDP203ufUUtCtiW
        h4WmDuHwLNw0SB3L6PXZw5A5XamlX/zDvpjtea4EgoB7FY+vXr3rW0ecsglkmBr1CPh10R
        DINGwrFU8cGQg9dY3e4H3LwtG0gtjGhCGnskdtV8DQEzqRlfrQUCKLrZGMXQUw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1626689820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CuTPlhmxaB6rZmMnaD1VhInphyN85lMOA0JYAV15TK8=;
        b=PlRSr1mw180y+s6VwukPlS3++Y7ktdu4O+yH2mxEsPFr8uHgselDMPEdpbadzR7LHd2Z3T
        1vu4sYFFXfkBWZBA==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        netdev@vger.kernel.org, vinicius.gomes@intel.com,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next] Revert "igc: Export LEDs"
Date:   Mon, 19 Jul 2021 12:16:40 +0200
Message-Id: <20210719101640.16047-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit cf8331825a8d10e46fa574fdf015a65cb5a6db86.

There are better Linux interfaces to export the different LED modes
and blinking reasons.

Revert this patch for now and come up with better solution later.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---

Link to the discussion:
https://lkml.kernel.org/netdev/20210716212427.821834-6-anthony.l.nguyen@intel.com/

 drivers/net/ethernet/intel/Kconfig           |   1 -
 drivers/net/ethernet/intel/igc/igc.h         |  10 --
 drivers/net/ethernet/intel/igc/igc_defines.h |  10 --
 drivers/net/ethernet/intel/igc/igc_main.c    | 132 -------------------
 drivers/net/ethernet/intel/igc/igc_regs.h    |   2 -
 5 files changed, 155 deletions(-)

diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index 3639cf79cfae..82744a7501c7 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -335,7 +335,6 @@ config IGC
 	tristate "Intel(R) Ethernet Controller I225-LM/I225-V support"
 	default n
 	depends on PCI
-	depends on LEDS_CLASS
 	help
 	  This driver supports Intel(R) Ethernet Controller I225-LM/I225-V
 	  family of adapters.
diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 2df0fd2b9ecf..a0ecfe5a4078 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -13,7 +13,6 @@
 #include <linux/ptp_clock_kernel.h>
 #include <linux/timecounter.h>
 #include <linux/net_tstamp.h>
-#include <linux/leds.h>
 
 #include "igc_hw.h"
 
@@ -240,17 +239,8 @@ struct igc_adapter {
 		struct timespec64 start;
 		struct timespec64 period;
 	} perout[IGC_N_PEROUT];
-
-	/* LEDs */
-	struct mutex led_mutex;
-	struct led_classdev led0;
-	struct led_classdev led1;
-	struct led_classdev led2;
 };
 
-#define led_to_igc(ldev, led)                          \
-	container_of(ldev, struct igc_adapter, led)
-
 void igc_up(struct igc_adapter *adapter);
 void igc_down(struct igc_adapter *adapter);
 int igc_open(struct net_device *netdev);
diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 156c3ef57c0a..c6315690e20f 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -144,16 +144,6 @@
 #define IGC_CTRL_SDP0_DIR	0x00400000  /* SDP0 Data direction */
 #define IGC_CTRL_SDP1_DIR	0x00800000  /* SDP1 Data direction */
 
-/* LED Control */
-#define IGC_LEDCTL_LED0_MODE_SHIFT	0
-#define IGC_LEDCTL_LED0_MODE_MASK	GENMASK(3, 0)
-#define IGC_LEDCTL_LED1_MODE_SHIFT	8
-#define IGC_LEDCTL_LED1_MODE_MASK	GENMASK(11, 8)
-#define IGC_LEDCTL_LED2_MODE_SHIFT	16
-#define IGC_LEDCTL_LED2_MODE_MASK	GENMASK(19, 16)
-
-#define IGC_CONNSW_AUTOSENSE_EN		0x1
-
 /* As per the EAS the maximum supported size is 9.5KB (9728 bytes) */
 #define MAX_JUMBO_FRAME_SIZE	0x2600
 
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 100819dcc7dd..11385c380947 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6130,134 +6130,6 @@ int igc_set_spd_dplx(struct igc_adapter *adapter, u32 spd, u8 dplx)
 	return -EINVAL;
 }
 
-static void igc_select_led(struct igc_adapter *adapter, int led,
-			   u32 *mask, u32 *shift)
-{
-	switch (led) {
-	case 0:
-		*mask  = IGC_LEDCTL_LED0_MODE_MASK;
-		*shift = IGC_LEDCTL_LED0_MODE_SHIFT;
-		break;
-	case 1:
-		*mask  = IGC_LEDCTL_LED1_MODE_MASK;
-		*shift = IGC_LEDCTL_LED1_MODE_SHIFT;
-		break;
-	case 2:
-		*mask  = IGC_LEDCTL_LED2_MODE_MASK;
-		*shift = IGC_LEDCTL_LED2_MODE_SHIFT;
-		break;
-	default:
-		*mask = *shift = 0;
-		dev_err(&adapter->pdev->dev, "Unknown led %d selected!", led);
-	}
-}
-
-static void igc_led_set(struct igc_adapter *adapter, int led, u16 brightness)
-{
-	struct igc_hw *hw = &adapter->hw;
-	u32 shift, mask, ledctl;
-
-	igc_select_led(adapter, led, &mask, &shift);
-
-	mutex_lock(&adapter->led_mutex);
-	ledctl = rd32(IGC_LEDCTL);
-	ledctl &= ~mask;
-	ledctl |= brightness << shift;
-	wr32(IGC_LEDCTL, ledctl);
-	mutex_unlock(&adapter->led_mutex);
-}
-
-static enum led_brightness igc_led_get(struct igc_adapter *adapter, int led)
-{
-	struct igc_hw *hw = &adapter->hw;
-	u32 shift, mask, ledctl;
-
-	igc_select_led(adapter, led, &mask, &shift);
-
-	mutex_lock(&adapter->led_mutex);
-	ledctl = rd32(IGC_LEDCTL);
-	mutex_unlock(&adapter->led_mutex);
-
-	return (ledctl & mask) >> shift;
-}
-
-static void igc_led0_set(struct led_classdev *ldev, enum led_brightness b)
-{
-	struct igc_adapter *adapter = led_to_igc(ldev, led0);
-
-	igc_led_set(adapter, 0, b);
-}
-
-static enum led_brightness igc_led0_get(struct led_classdev *ldev)
-{
-	struct igc_adapter *adapter = led_to_igc(ldev, led0);
-
-	return igc_led_get(adapter, 0);
-}
-
-static void igc_led1_set(struct led_classdev *ldev, enum led_brightness b)
-{
-	struct igc_adapter *adapter = led_to_igc(ldev, led1);
-
-	igc_led_set(adapter, 1, b);
-}
-
-static enum led_brightness igc_led1_get(struct led_classdev *ldev)
-{
-	struct igc_adapter *adapter = led_to_igc(ldev, led1);
-
-	return igc_led_get(adapter, 1);
-}
-
-static void igc_led2_set(struct led_classdev *ldev, enum led_brightness b)
-{
-	struct igc_adapter *adapter = led_to_igc(ldev, led2);
-
-	igc_led_set(adapter, 2, b);
-}
-
-static enum led_brightness igc_led2_get(struct led_classdev *ldev)
-{
-	struct igc_adapter *adapter = led_to_igc(ldev, led2);
-
-	return igc_led_get(adapter, 2);
-}
-
-static int igc_led_setup(struct igc_adapter *adapter)
-{
-	/* Setup */
-	mutex_init(&adapter->led_mutex);
-
-	adapter->led0.name	     = "igc_led0";
-	adapter->led0.max_brightness = 15;
-	adapter->led0.brightness_set = igc_led0_set;
-	adapter->led0.brightness_get = igc_led0_get;
-
-	adapter->led1.name	     = "igc_led1";
-	adapter->led1.max_brightness = 15;
-	adapter->led1.brightness_set = igc_led1_set;
-	adapter->led1.brightness_get = igc_led1_get;
-
-	adapter->led2.name	     = "igc_led2";
-	adapter->led2.max_brightness = 15;
-	adapter->led2.brightness_set = igc_led2_set;
-	adapter->led2.brightness_get = igc_led2_get;
-
-	/* Register leds */
-	led_classdev_register(&adapter->pdev->dev, &adapter->led0);
-	led_classdev_register(&adapter->pdev->dev, &adapter->led1);
-	led_classdev_register(&adapter->pdev->dev, &adapter->led2);
-
-	return 0;
-}
-
-static void igc_led_destroy(struct igc_adapter *adapter)
-{
-	led_classdev_unregister(&adapter->led0);
-	led_classdev_unregister(&adapter->led1);
-	led_classdev_unregister(&adapter->led2);
-}
-
 /**
  * igc_probe - Device Initialization Routine
  * @pdev: PCI device information struct
@@ -6485,8 +6357,6 @@ static int igc_probe(struct pci_dev *pdev,
 
 	pm_runtime_put_noidle(&pdev->dev);
 
-	igc_led_setup(adapter);
-
 	return 0;
 
 err_register:
@@ -6528,8 +6398,6 @@ static void igc_remove(struct pci_dev *pdev)
 
 	igc_ptp_stop(adapter);
 
-	igc_led_destroy(adapter);
-
 	set_bit(__IGC_DOWN, &adapter->state);
 
 	del_timer_sync(&adapter->watchdog_timer);
diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index f6247b00c4e3..828c3501c448 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -10,8 +10,6 @@
 #define IGC_EECD		0x00010  /* EEPROM/Flash Control - RW */
 #define IGC_CTRL_EXT		0x00018  /* Extended Device Control - RW */
 #define IGC_MDIC		0x00020  /* MDI Control - RW */
-#define IGC_LEDCTL		0x00E00	 /* LED Control - RW */
-#define IGC_MDICNFG		0x00E04  /* MDC/MDIO Configuration - RW */
 #define IGC_CONNSW		0x00034  /* Copper/Fiber switch control - RW */
 #define IGC_VET			0x00038  /* VLAN Ether Type - RW */
 #define IGC_I225_PHPM		0x00E14  /* I225 PHY Power Management */
-- 
2.30.2

