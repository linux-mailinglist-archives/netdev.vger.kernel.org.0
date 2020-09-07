Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3817425F406
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 09:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgIGHcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 03:32:03 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:56838 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbgIGHcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 03:32:02 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0877VgIT033308;
        Mon, 7 Sep 2020 02:31:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1599463902;
        bh=vDnFpjeQpYRszsFcfmJjU1hDoZEnJNtJIKKm9nrhwfg=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=ra9T4dAvEH8lGxAqOZazvF3Dk+yVsckf7rAoMvzaKp1JXiwUdVAMzEv/qCKAmse45
         Lh7k2csz1cyUfPsGtZWYin4vxMEkTICCtvRElHM+wwq+LyAf5KFdhB03DdRWAZoGG+
         ioP4ezkliQ9apjW4qbEPUeKgIfCVnlmGyx5u605g=
Received: from DLEE101.ent.ti.com (dlee101.ent.ti.com [157.170.170.31])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0877Vgvh088780
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 7 Sep 2020 02:31:42 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 7 Sep
 2020 02:31:41 -0500
Received: from DLEE105.ent.ti.com ([fe80::d8b7:9c27:242c:8236]) by
 DLEE105.ent.ti.com ([fe80::d8b7:9c27:242c:8236%17]) with mapi id
 15.01.1979.003; Mon, 7 Sep 2020 02:31:41 -0500
From:   "Bouganim, Raz" <r-bouganim@ti.com>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
CC:     "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "mauro.chehab@huawei.com" <mauro.chehab@huawei.com>,
        John Stultz <john.stultz@linaro.org>,
        "Manivannan Sadhasivam" <mani@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Tony Lindgren" <tony@atomide.com>,
        Dinghao Liu <dinghao.liu@zju.edu.cn>,
        "Mishol, Guy" <guym@ti.com>, "Hahn, Maital" <maitalm@ti.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Fuqian Huang <huangfq.daxian@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXTERNAL] [PATCH v2] net: wireless: wlcore: fix support for IGTK
 key
Thread-Topic: [EXTERNAL] [PATCH v2] net: wireless: wlcore: fix support for
 IGTK key
Thread-Index: AQHWhOFv5jYTn6+jm02OzGgC9OgJY6lcwneA
Date:   Mon, 7 Sep 2020 07:31:41 +0000
Message-ID: <0b35411ad77e4d38bc0dfeb5737869a9@ti.com>
References: <49d4cdaf6aad40f591e8b2f17e09007c@ti.com>
 <bbffd27164e3c06636c57cba1550f34664ab5d4c.1599460469.git.mchehab+huawei@kernel.org>
In-Reply-To: <bbffd27164e3c06636c57cba1550f34664ab5d4c.1599460469.git.mchehab+huawei@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.167.21.82]
x-exclaimer-md-config: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This is not a really good solution, this patch will cause a wrong status to=
 the user:
The supplicant will give status to the user that we are connected although =
we are not able to encrypt a management packet in addition, the supplicant =
will try over and over to send the AES_CMAC key.

The right solution is the override the supported cipher that is configured =
when the wlcore is up:
If the version is below 8.9.0.0.83 the cipher suite configured to wl->hw->w=
iphy->cipher_suites
cipher_suites[] =3D {
        WLAN_CIPHER_SUITE_WEP40,
        WLAN_CIPHER_SUITE_WEP104,
        WLAN_CIPHER_SUITE_TKIP,
        WLAN_CIPHER_SUITE_CCMP,
        WL1271_CIPHER_SUITE_GEM,
    };


 however, I don't know if it is a good solution to decide the cipher depend=
s on the FW version because we are not able to know what is the FW version =
when we are loaded the wlcore driver.

What do you think?=20


-----Original Message-----
From: Mauro Carvalho Chehab [mailto:mchehab@kernel.org] On Behalf Of Mauro =
Carvalho Chehab
Sent: Monday, September 7, 2020 9:38 AM
To: Bouganim, Raz
Cc: linuxarm@huawei.com; mauro.chehab@huawei.com; Mauro Carvalho Chehab; Jo=
hn Stultz; Manivannan Sadhasivam; Kalle Valo; David S. Miller; Jakub Kicins=
ki; Tony Lindgren; Dinghao Liu; Mishol, Guy; Hahn, Maital; Johannes Berg; F=
uqian Huang; linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-=
kernel@vger.kernel.org
Subject: [EXTERNAL] [PATCH v2] net: wireless: wlcore: fix support for IGTK =
key

Changeset 2b7aadd3b9e1 ("wlcore: Adding suppoprt for IGTK key in wlcore dri=
ver")
added support for AEC CMAC cipher suite.

However, this only works with the very newest firmware version
(8.9.0.0.83). Such firmware weren't even pushed to linux-firmware
git tree yet:

	https://git.ti.com/cgit/wilink8-wlan/wl18xx_fw/log/

Due to that, it causes a regression betwen Kernel 5.7 and 5.8:
with such patch applied, WiFi stops working, and the Kernel starts
printing this message every second:

   wlcore: PHY firmware version: Rev 8.2.0.0.242
   wlcore: firmware booted (Rev 8.9.0.0.79)
   wlcore: ERROR command execute failure 14
   ------------[ cut here ]------------
   WARNING: CPU: 0 PID: 133 at drivers/net/wireless/ti/wlcore/main.c:795 wl=
12xx_queue_recovery_work.part.0+0x6c/0x74 [wlcore]
   Modules linked in: wl18xx wlcore mac80211 libarc4 cfg80211 rfkill snd_so=
c_hdmi_codec crct10dif_ce wlcore_sdio adv7511 cec kirin9xx_drm(C) kirin9xx_=
dw_drm_dsi(C) drm_kms_helper drm ip_tables x_tables ipv6 nf_defrag_ipv6
   CPU: 0 PID: 133 Comm: kworker/0:1 Tainted: G        WC        5.8.0+ #18=
6
   Hardware name: HiKey970 (DT)
   Workqueue: events_freezable ieee80211_restart_work [mac80211]
   pstate: 60000005 (nZCv daif -PAN -UAO BTYPE=3D--)
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
   mmc_host mmc0: Bus speed (slot 0) =3D 400000Hz (slot req 400000Hz, actua=
l 400000HZ div =3D 0)
   mmc_host mmc0: Bus speed (slot 0) =3D 25000000Hz (slot req 25000000Hz, a=
ctual 25000000HZ div =3D 0)
   wlcore: PHY firmware version: Rev 8.2.0.0.242
   wlcore: firmware booted (Rev 8.9.0.0.79)
   wlcore: ERROR command execute failure 14
   ------------[ cut here ]------------

Fix it by adding some code that will check if the firmware version
is at least version 8.9.0.0.83.

Tested on Hikey 970.

Fixes: 2b7aadd3b9e1 ("wlcore: Adding suppoprt for IGTK key in wlcore driver=
")
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---

Hi Raz,

Maybe this patch could be useful once firmware 8.9.0.0.83 is released.

v2: change it to require minimal verson 8.9.0.0.83 for IGTK key

 drivers/net/wireless/ti/wlcore/main.c   | 48 +++++++++++++++++++++++++
 drivers/net/wireless/ti/wlcore/wlcore.h |  2 ++
 2 files changed, 50 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/t=
i/wlcore/main.c
index de6c8a7589ca..4332eaa1a733 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -14,6 +14,7 @@
 #include <linux/irq.h>
 #include <linux/pm_runtime.h>
 #include <linux/pm_wakeirq.h>
+#include <linux/ctype.h>
=20
 #include "wlcore.h"
 #include "debug.h"
@@ -1082,6 +1083,45 @@ static int wl12xx_chip_wakeup(struct wl1271 *wl, boo=
l plt)
 	return ret;
 }
=20
+static bool wl1271_check_aes_cmac_cypher(struct wl1271 *wl)
+{
+	int ver[5] =3D { };
+	int ret;
+	const char *p =3D wl->chip.fw_ver_str;
+
+
+	/* The string starts with "Rev ". Ignore it */
+	while (*p && !isdigit(*p))
+		p++;
+
+	ret =3D sscanf(p, "%d.%d.%d.%d.%d",
+		     &ver[0], &ver[1], &ver[2], &ver[3], &ver[4]);
+
+	if (ret !=3D ARRAY_SIZE(ver)) {
+		wl1271_info("Parsed version: %d.%d.%d.%d.%d\n",
+			    ver[0], ver[1], ver[2], ver[3], ver[4]);
+		wl1271_error("Couldn't parse firmware version string: %d\n", ret);
+		return false;
+	}
+
+	/*
+	 * Only versions equal (and probably above) 8.9.0.0.83
+	 * supports such feature.
+	 */
+	if (ver[0] < 8)
+		return false;
+	if (ver[1] < 9)
+		return false;
+	if (ver[2] > 0)
+		return true;
+	if (ver[3] > 0)
+		return true;
+	if (ver[4] >=3D 83)
+		return true;
+
+	return false;
+}
+
 int wl1271_plt_start(struct wl1271 *wl, const enum plt_mode plt_mode)
 {
 	int retries =3D WL1271_BOOT_RETRIES;
@@ -1133,6 +1173,8 @@ int wl1271_plt_start(struct wl1271 *wl, const enum pl=
t_mode plt_mode)
 		strncpy(wiphy->fw_version, wl->chip.fw_ver_str,
 			sizeof(wiphy->fw_version));
=20
+		wl->has_aes_cmac_cipher =3D wl1271_check_aes_cmac_cypher(wl);
+
 		goto out;
=20
 power_off:
@@ -2358,6 +2400,8 @@ static int wl12xx_init_fw(struct wl1271 *wl)
 	strncpy(wiphy->fw_version, wl->chip.fw_ver_str,
 		sizeof(wiphy->fw_version));
=20
+	wl->has_aes_cmac_cipher =3D wl1271_check_aes_cmac_cypher(wl);
+
 	/*
 	 * Now we know if 11a is supported (info from the NVS), so disable
 	 * 11a channels if not supported
@@ -3551,6 +3595,10 @@ int wlcore_set_key(struct wl1271 *wl, enum set_key_c=
md cmd,
 		key_type =3D KEY_GEM;
 		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
+		if (!wl->has_aes_cmac_cipher) {
+			wl1271_error("AEC CMAC cipher not available on this firmware version\n"=
);
+			return -EOPNOTSUPP;
+		}
 		key_type =3D KEY_IGTK;
 		break;
 	default:
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless=
/ti/wlcore/wlcore.h
index b7821311ac75..26a2bd9b2df1 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -213,6 +213,8 @@ struct wl1271 {
 	void *nvs;
 	size_t nvs_len;
=20
+	u32 has_aes_cmac_cipher:1;
+
 	s8 hw_pg_ver;
=20
 	/* address read from the fuse ROM */
--=20
2.26.2


