Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F931252694
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 07:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgHZFtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 01:49:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725786AbgHZFtq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Aug 2020 01:49:46 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35CCB206FA;
        Wed, 26 Aug 2020 05:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598420985;
        bh=6sp8rWsIjWmvlvwsP+g2dW9kA81u8URuS8FMA6HUJcM=;
        h=From:To:Cc:Subject:Date:From;
        b=RF5WxgrnA0zdjScUJzHn7bW5LeKMj+cT1EYujpp7dpDaHSzU7YsZoqM/WvEVjMgnI
         0vzf0mkPBqSfoAshkiKMiq2XfBL0/oly7p+4g+aK+Q70YaRDHrdvS/Y0KzviUknfdF
         FsOvokvwiYYX8k8/yKvenW/W7PeNN5bBoYFN+buY=
Received: from mchehab by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1kAoJa-001PPP-HC; Wed, 26 Aug 2020 07:49:42 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linuxarm@huawei.com, mauro.chehab@huawei.com,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Maital Hahn <maitalm@ti.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Raz Bouganim <r-bouganim@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Johannes Berg <johannes.berg@intel.com>,
        Fuqian Huang <huangfq.daxian@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Revert "wlcore: Adding suppoprt for IGTK key in wlcore driver"
Date:   Wed, 26 Aug 2020 07:49:34 +0200
Message-Id: <f0a2cb7ea606f1a284d4c23cbf983da2954ce9b6.1598420968.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch causes a regression betwen Kernel 5.7 and 5.8 at wlcore:
with it applied, WiFi stops working, and the Kernel starts printing
this message every second:

   wlcore: PHY firmware version: Rev 8.2.0.0.242
   wlcore: firmware booted (Rev 8.9.0.0.79)
   wlcore: ERROR command execute failure 14
   ------------[ cut here ]------------
   WARNING: CPU: 0 PID: 133 at drivers/net/wireless/ti/wlcore/main.c:795 wl12xx_queue_recovery_work.part.0+0x6c/0x74 [wlcore]
   Modules linked in: wl18xx wlcore mac80211 libarc4 cfg80211 rfkill snd_soc_hdmi_codec crct10dif_ce wlcore_sdio adv7511 cec kirin9xx_drm(C) kirin9xx_dw_drm_dsi(C) drm_kms_helper drm ip_tables x_tables ipv6 nf_defrag_ipv6
   CPU: 0 PID: 133 Comm: kworker/0:1 Tainted: G        WC        5.8.0+ #186
   Hardware name: HiKey970 (DT)
   Workqueue: events_freezable ieee80211_restart_work [mac80211]
   pstate: 60000005 (nZCv daif -PAN -UAO BTYPE=--)
   pc : wl12xx_queue_recovery_work.part.0+0x6c/0x74 [wlcore]
   lr : wl12xx_queue_recovery_work+0x24/0x30 [wlcore]
   sp : ffff8000126c3a60
   x29: ffff8000126c3a60 x28: 00000000000025de
   x27: 0000000000000010 x26: 0000000000000005
   x25: ffff0001a5d49e80 x24: ffff8000092cf580
   x23: ffff0001b7c12623 x22: ffff0001b6fcf2e8
   x21: ffff0001b7e46200 x20: 00000000fffffffb
   x19: ffff0001a78e6400 x18: 0000000000000030
   x17: 0000000000000001 x16: 0000000000000001
   x15: ffff0001b7e46670 x14: ffffffffffffffff
   x13: ffff8000926c37d7 x12: ffff8000126c37e0
   x11: ffff800011e01000 x10: ffff8000120526d0
   x9 : 0000000000000000 x8 : 3431206572756c69
   x7 : 6166206574756365 x6 : 0000000000000c2c
   x5 : 0000000000000000 x4 : ffff0001bf1361e8
   x3 : ffff0001bf1790b0 x2 : 0000000000000000
   x1 : ffff0001a5d49e80 x0 : 0000000000000001
   Call trace:
    wl12xx_queue_recovery_work.part.0+0x6c/0x74 [wlcore]
    wl12xx_queue_recovery_work+0x24/0x30 [wlcore]
    wl1271_cmd_set_sta_key+0x258/0x25c [wlcore]
    wl1271_set_key+0x7c/0x2dc [wlcore]
    wlcore_set_key+0xe4/0x360 [wlcore]
    wl18xx_set_key+0x48/0x1d0 [wl18xx]
    wlcore_op_set_key+0xa4/0x180 [wlcore]
    ieee80211_key_enable_hw_accel+0xb0/0x2d0 [mac80211]
    ieee80211_reenable_keys+0x70/0x110 [mac80211]
    ieee80211_reconfig+0xa00/0xca0 [mac80211]
    ieee80211_restart_work+0xc4/0xfc [mac80211]
    process_one_work+0x1cc/0x350
    worker_thread+0x13c/0x470
    kthread+0x154/0x160
    ret_from_fork+0x10/0x30
   ---[ end trace b1f722abf9af5919 ]---
   wlcore: WARNING could not set keys
   wlcore: ERROR Could not add or replace key
   wlan0: failed to set key (4, ff:ff:ff:ff:ff:ff) to hardware (-5)
   wlcore: Hardware recovery in progress. FW ver: Rev 8.9.0.0.79
   wlcore: pc: 0x0, hint_sts: 0x00000040 count: 39
   wlcore: down
   wlcore: down
   ieee80211 phy0: Hardware restart was requested
   mmc_host mmc0: Bus speed (slot 0) = 400000Hz (slot req 400000Hz, actual 400000HZ div = 0)
   mmc_host mmc0: Bus speed (slot 0) = 25000000Hz (slot req 25000000Hz, actual 25000000HZ div = 0)
   wlcore: PHY firmware version: Rev 8.2.0.0.242
   wlcore: firmware booted (Rev 8.9.0.0.79)
   wlcore: ERROR command execute failure 14
   ------------[ cut here ]------------

Tested on Hikey 970.

This reverts commit 2b7aadd3b9e17e8b81eeb8d9cc46756ae4658265.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 drivers/net/wireless/ti/wlcore/cmd.h  | 1 -
 drivers/net/wireless/ti/wlcore/main.c | 4 ----
 2 files changed, 5 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.h b/drivers/net/wireless/ti/wlcore/cmd.h
index 9acd8a41ea61..f2609d5b6bf7 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.h
+++ b/drivers/net/wireless/ti/wlcore/cmd.h
@@ -458,7 +458,6 @@ enum wl1271_cmd_key_type {
 	KEY_TKIP = 2,
 	KEY_AES  = 3,
 	KEY_GEM  = 4,
-	KEY_IGTK  = 5,
 };
 
 struct wl1271_cmd_set_keys {
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index de6c8a7589ca..ef169de99224 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -3550,9 +3550,6 @@ int wlcore_set_key(struct wl1271 *wl, enum set_key_cmd cmd,
 	case WL1271_CIPHER_SUITE_GEM:
 		key_type = KEY_GEM;
 		break;
-	case WLAN_CIPHER_SUITE_AES_CMAC:
-		key_type = KEY_IGTK;
-		break;
 	default:
 		wl1271_error("Unknown key algo 0x%x", key_conf->cipher);
 
@@ -6222,7 +6219,6 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 		WLAN_CIPHER_SUITE_TKIP,
 		WLAN_CIPHER_SUITE_CCMP,
 		WL1271_CIPHER_SUITE_GEM,
-		WLAN_CIPHER_SUITE_AES_CMAC,
 	};
 
 	/* The tx descriptor buffer */
-- 
2.26.2

