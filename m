Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E37714CB3D
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 14:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgA2NND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 08:13:03 -0500
Received: from comms.puri.sm ([159.203.221.185]:41454 "EHLO comms.puri.sm"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726145AbgA2NNC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jan 2020 08:13:02 -0500
X-Greylist: delayed 557 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Jan 2020 08:13:02 EST
Received: from localhost (localhost [127.0.0.1])
        by comms.puri.sm (Postfix) with ESMTP id 31822E0399;
        Wed, 29 Jan 2020 05:03:45 -0800 (PST)
Received: from comms.puri.sm ([127.0.0.1])
        by localhost (comms.puri.sm [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id SHkGkaww1GcA; Wed, 29 Jan 2020 05:03:40 -0800 (PST)
From:   Martin Kepplinger <martin.kepplinger@puri.sm>
To:     amitkarwar@gmail.com, siva8118@gmail.com
Cc:     kvalo@codeaurora.org, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Kepplinger <martin.kepplinger@puri.sm>
Subject: [PATCH] rsi: fix null pointer dereference during rsi_shutdown()
Date:   Wed, 29 Jan 2020 14:02:59 +0100
Message-Id: <20200129130259.21919-1-martin.kepplinger@puri.sm>
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Appearently the hw pointer can be NULL while the module is loaded and
in that case rsi_shutdown() crashes due to the unconditional dereference.

Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>
---

I'm not at all sure whether this is the way you would want this be fixed,
just wanted to point out what I found and what prevents that:

[   68.735990] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000040
[   68.744798] Mem abort info:
[   68.747606]   ESR = 0x96000004
[   68.750672]   EC = 0x25: DABT (current EL), IL = 32 bits
[   68.755994]   SET = 0, FnV = 0
[   68.759059]   EA = 0, S1PTW = 0
[   68.762210] Data abort info:
[   68.765101]   ISV = 0, ISS = 0x00000004
[   68.768947]   CM = 0, WnR = 0
[   68.771917] user pgtable: 4k pages, 48-bit VAs, pgdp=00000000fedd2000
[   68.778368] [0000000000000040] pgd=0000000000000000
[   68.783261] Internal error: Oops: 96000004 [#1] PREEMPT SMP
[   68.788833] Modules linked in: rsi_sdio rsi_91x btrsi bluetooth mac80211 cfg80211 qmi_wwan cdc_wdm usbnet mii option usb_wwan usbserial rfkill caam_jr caamhash_desc mousedev caamalg_desc aes_ce_blk crypto_simd uas crct10dif_ce st_lsm6dsx_spi ghash_ce sha2_ce st_magn_spi st_sensors_spi sha1_ce gpio_vibra snd_soc_simple_card snd_soc_gtm601 st_magn_i2c snd_soc_simple_card_utils usb_storage st_magn st_sensors_i2c st_sensors st_lsm6dsx_i2c st_lsm6dsx industrialio_triggered_buffer kfifo_buf goodix snd_soc_sgtl5000 snd_soc_fsl_sai imx_pcm_dma snd_soc_core tcpci tcpm snd_pcm_dmaengine caam roles snd_pcm typec error snd_timer imx2_wdt bq25890_charger snd imx_sdma soundcore virt_dma watchdog usb_f_acm u_serial usb_f_rndis g_multi usb_f_mass_storage u_ether libcomposite ip_tables x_tables ipv6 nf_defrag_ipv6 xhci_plat_hcd xhci_hcd usbcore clk_bd718x7 snvs_pwrkey dwc3 ulpi udc_core usb_common phy_fsl_imx8mq_usb
[   68.868560] CPU: 2 PID: 1 Comm: systemd-shutdow Not tainted 5.5.0-next-20200128-00042-g6db9997c58e8 #134
[   68.878036] Hardware name: Purism Librem 5 devkit (DT)
[   68.883174] pstate: 80000005 (Nzcv daif -PAN -UAO)
[   68.887972] pc : rsi_shutdown+0x6c/0x2d0 [rsi_sdio]
[   68.892851] lr : rsi_shutdown+0x6c/0x2d0 [rsi_sdio]
[   68.897726] sp : ffff80001003bc50
[   68.901038] x29: ffff80001003bc50 x28: ffff0000aa710000 
[   68.906348] x27: 0000000000000000 x26: ffff0000a6b52488 
[   68.911659] x25: ffff800010cf2a38 x24: 0000000000000001 
[   68.916969] x23: ffff80001104c048 x22: ffff8000110be408 
[   68.922280] x21: ffff0000a3cd6600 x20: 0000000000000000 
[   68.927591] x19: ffff0000948ed800 x18: 0000000000000010 
[   68.932902] x17: 0000000000000000 x16: 0000000000000000 
[   68.938212] x15: ffffffffffffffff x14: ffff800010f08808 
[   68.943523] x13: ffff80009003b9c7 x12: ffff80001003b9cf 
[   68.948834] x11: ffff800010f28000 x10: ffff80001003b950 
[   68.954145] x9 : ffff80001010fb9c x8 : ffff80001066ea38 
[   68.959456] x7 : 0000000000000b9a x6 : ffff80001003b990 
[   68.964767] x5 : 0000000000000001 x4 : 0000000000000001 
[   68.970077] x3 : 0000000000000001 x2 : c2326a42961bac00 
[   68.975387] x1 : 0000000000000000 x0 : 000000000000000a 
[   68.980698] Call trace:
[   68.983146]  rsi_shutdown+0x6c/0x2d0 [rsi_sdio]
[   68.987681]  device_shutdown+0x150/0x208
[   68.991607]  kernel_restart_prepare+0x3c/0x48
[   68.995962]  kernel_restart+0x1c/0x68
[   68.999624]  __do_sys_reboot+0x104/0x208
[   69.003547]  __arm64_sys_reboot+0x28/0x30
[   69.007558]  el0_svc_common.constprop.3+0x98/0x170
[   69.012348]  do_el0_svc+0x20/0x28
[   69.015664]  el0_sync_handler+0x134/0x1a0
[   69.019672]  el0_sync+0x140/0x180
[   69.022989] Code: 14000004 b0000000 913a6000 95c9b5b7 (f9402282) 
[   69.029082] ---[ end trace edcafbe41a521f23 ]---
[   69.033723] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
[   69.041386] Kernel Offset: disabled
[   69.044874] CPU features: 0x00002,2000200c
[   69.048968] Memory Limit: none
[   69.052024] ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b ]---


 drivers/net/wireless/rsi/rsi_91x_sdio.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index 1bebba4e8527..5d6143a55187 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -1468,12 +1468,15 @@ static void rsi_shutdown(struct device *dev)
 	struct rsi_91x_sdiodev *sdev =
 		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
 	struct ieee80211_hw *hw = adapter->hw;
-	struct cfg80211_wowlan *wowlan = hw->wiphy->wowlan_config;
 
 	rsi_dbg(ERR_ZONE, "SDIO Bus shutdown =====>\n");
 
-	if (rsi_config_wowlan(adapter, wowlan))
-		rsi_dbg(ERR_ZONE, "Failed to configure WoWLAN\n");
+	if (hw) {
+		struct cfg80211_wowlan *wowlan = hw->wiphy->wowlan_config;
+
+		if (rsi_config_wowlan(adapter, wowlan))
+			rsi_dbg(ERR_ZONE, "Failed to configure WoWLAN\n");
+	}
 
 	if (IS_ENABLED(CONFIG_RSI_COEX) && adapter->priv->coex_mode > 1 &&
 	    adapter->priv->bt_adapter) {
-- 
2.20.1

