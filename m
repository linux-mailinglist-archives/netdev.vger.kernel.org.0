Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85DFA32136B
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 10:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbhBVJt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 04:49:28 -0500
Received: from lucky1.263xmail.com ([211.157.147.134]:58598 "EHLO
        lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbhBVJtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 04:49:20 -0500
Received: from localhost (unknown [192.168.167.235])
        by lucky1.263xmail.com (Postfix) with ESMTP id 67692C7067;
        Mon, 22 Feb 2021 17:46:53 +0800 (CST)
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ADDR-CHECKED4: 1
X-ANTISPAM-LEVEL: 2
X-ABS-CHECKED: 0
Received: from localhost.localdomain (unknown [61.183.83.60])
        by smtp.263.net (postfix) whith ESMTP id P19729T140185198249728S1613987213533934_;
        Mon, 22 Feb 2021 17:46:54 +0800 (CST)
X-IP-DOMAINF: 1
X-UNIQUE-TAG: <0fe8e79161a448df2189d52a356cd587>
X-RL-SENDER: chenhaoa@uniontech.com
X-SENDER: chenhaoa@uniontech.com
X-LOGIN-NAME: chenhaoa@uniontech.com
X-FST-TO: tony0620emma@gmail.com
X-SENDER-IP: 61.183.83.60
X-ATTACHMENT-NUM: 0
X-System-Flag: 0
From:   Hao Chen <chenhaoa@uniontech.com>
To:     tony0620emma@gmail.com
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, timlee@realtek.com, arnd@arndb.de,
        zhanjun@uniontech.com, Hao Chen <chenhaoa@uniontech.com>
Subject: [PATCH v2] rtw88: 8822ce: fix wifi disconnect after S3/S4 on HONOR laptop
Date:   Mon, 22 Feb 2021 17:46:38 +0800
Message-Id: <20210222094638.18392-1-chenhaoa@uniontech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The laptop's wifi disconnect after the laptop HONOR MagicBook 14
sleep to S3/S4 and wake up.

The dmesg of kernel report:
"[   99.990168] pcieport 0000:00:01.2: can't change power state from D3hot
to D0 (config space inaccessible)
[   99.990176] ACPI: EC: interrupt unblocked
[   99.993334] rtw_pci 0000:01:00.0: can't change power state from D3hot
to D0 (config space inaccessible)
......
[  102.133500] rtw_pci 0000:01:00.0: mac power on failed
[  102.133503] rtw_pci 0000:01:00.0: failed to power on mac
[  102.133505] ------------[ cut here ]------------
[  102.133506] Hardware became unavailable upon resume. This could be a
software issue prior to suspend or a hardware issue.
[  102.133569] WARNING: CPU: 4 PID: 5612 at net/mac80211/util.c:2232
ieee80211_reconfig+0x9b/0x1490 [mac80211]
[  102.133570] Modules linked in: ccm rfcomm uvcvideo videobuf2_vmalloc
videobuf2_memops videobuf2_v4l2 videobuf2_common videodev mc cmac bnep 
btusb btrtl btbcm btintel edac_mce_amd bluetooth kvm_amd ecdh_generic 
ecc kvm nls_iso8859_1 rtwpci rtw88 crct10dif_pclmul crc32_pclmul mac80211 
ghash_clmulni_intel aesni_intel snd_hda_codec_realtek crypto_simd huawei_wmi
snd_hda_codec_generic cryptd cfg80211 wmi_bmof serio_raw sparse_keymap
ledtrig_audio sp5100_tco glue_helper joydev snd_hda_codec_hdmi snd_hda_intel
snd_intel_dspcfg wdat_wdt snd_hda_codec snd_hda_core pcspkr snd_hwdep snd_pcm
efi_pstore snd_timer libarc4 k10temp snd soundcore snd_pci_acp3x ccp mac_hid
binfmt_misc ip_tables x_tables autofs4 amdgpu amd_iommu_v2 gpu_sched 
i2c_algo_bit ttm drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops
usbmouse cec nvme hid_generic i2c_piix4 usbhid nvme_core drm wmi video
[  102.133617] CPU: 4 PID: 5612 Comm: kworker/u32:16 Not tainted 5.7.7-amd64-desktop-8822 #3
[  102.133618] Hardware name: HUAWEI NBLL-WXX9/NBLL-WXX9-PCB, BIOS 1.06 09/29/2020
[  102.133623] Workqueue: events_unbound async_run_entry_fn
[  102.133651] RIP: 0010:ieee80211_reconfig+0x9b/0x1490 [mac80211]
[  102.133654] Code: 31 db e8 e8 fb 27 c2 41 c6 85 34 05 00 00 00 4c 89 ef e8 38
56 fc ff 89 45 b8 85 c0 74 4c 48 c7 c7 d0 0c 09 c1 e8 01 e0 25 c2 <0f> 0b 4c
89 ef e8 2b d1 ff ff e9 02 03 00 00 80 7d 9f 00 0f 85 1d
[  102.133655] RSP: 0018:ffffbe52c059fd08 EFLAGS: 00010286
[  102.133657] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000007
[  102.133658] RDX: 0000000000000007 RSI: 0000000000000096 RDI: ffff9d573f519cc0
[  102.133659] RBP: ffffbe52c059fd80 R08: ffffffffffd96245 R09: 000000000002cb80
[  102.133660] R10: 000000016989e54c R11: 000000000002a360 R12: ffff9d5731f50300
[  102.133661] R13: ffff9d5731f50800 R14: ffff9d5731f504c8 R15: ffffffff8463fbef
[  102.133664] FS:  0000000000000000(0000) GS:ffff9d573f500000(0000) knlGS:0000000000000000
[  102.133665] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  102.133666] CR2: 0000000000000000 CR3: 000000033320a000 CR4: 0000000000340ee0
[  102.133667] Call Trace:
[  102.133673]  ? enqueue_entity+0xe3/0x680
[  102.133705]  ieee80211_resume+0x55/0x70 [mac80211]
[  102.133729]  wiphy_resume+0x84/0x130 [cfg80211]
[  102.133752]  ? addresses_show+0xa0/0xa0 [cfg80211]
[  102.133757]  dpm_run_callback+0x5b/0x150
[  102.133760]  device_resume+0xad/0x1f0
[  102.133762]  async_resume+0x1d/0x30
[  102.133764]  async_run_entry_fn+0x3e/0x170
[  102.133768]  process_one_work+0x1ab/0x380
[  102.133771]  worker_thread+0x37/0x3b0
[  102.133774]  kthread+0x120/0x140
[  102.133776]  ? create_worker+0x1b0/0x1b0
[  102.133778]  ? kthread_park+0x90/0x90
[  102.133782]  ret_from_fork+0x22/0x40
[  102.133785] ---[ end trace 46229bfd3a4273be ]---
[  102.134137] ------------[ cut here ]------------
[  102.134141] wlp1s0:  Failed check-sdata-in-driver check, flags: 0x0
[  102.134195] WARNING: CPU: 0 PID: 5612 at net/mac80211/driver-ops.h:19
drv_remove_interface+0xfe/0x110 [mac80211]"

When try to pointer the driver.pm to NULL, the problem is fixed.
It makes the sleep and wake procedure expected when pm's ops not NULL.

By `git blame` command, I know that the assignment of .driver.pm =
RTW_PM_OPS was in commit 44bc17f7f5b3 ("rtw88: support wowlan feature for
8822c"), and another
commit 7dc7c41607d1 ("rtw88: avoid unused function warnings")
pointed out rtw_pci_resume() and rtw_pci_suspend() are not used at
all.

So I think it's safe to remove them.

Fixes: 7dc7c41607d1 ("rtw88: avoid unused function warnings")
Fixes: 44bc17f7f5b3 ("rtw88: support wowlan feature for 8822c")

Signed-off-by: Hao Chen <chenhaoa@uniontech.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8822ce.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822ce.c b/drivers/net/wireless/realtek/rtw88/rtw8822ce.c
index 3845b1333dc3..4c063192f801 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822ce.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822ce.c
@@ -25,7 +25,6 @@ static struct pci_driver rtw_8822ce_driver = {
 	.id_table = rtw_8822ce_id_table,
 	.probe = rtw_pci_probe,
 	.remove = rtw_pci_remove,
-	.driver.pm = &rtw_pm_ops,
 	.shutdown = rtw_pci_shutdown,
 };
 module_pci_driver(rtw_8822ce_driver);
-- 
2.20.1



