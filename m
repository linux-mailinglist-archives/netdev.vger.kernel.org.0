Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83870A89D3
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731573AbfIDP5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 11:57:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:59312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730355AbfIDP5n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 11:57:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C642E22CED;
        Wed,  4 Sep 2019 15:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612661;
        bh=5VvYnwAMIunNq1mXCuUviFAgfKWidIzSl/qVKwJNG6o=;
        h=From:To:Cc:Subject:Date:From;
        b=nXH8BwmK1/9SEQm+IJEnDMrjIdaWLCdIp7snz5/AHFiV4qt/pSXqU6s4lJ5xlH/uE
         2rmppkBbgRwO7Xjs6D67Q+AIiYmthoHGM+bwFgVEetzDCD+colfj2LHEjTL+l2o3iw
         /r5U7Z86NuCogfWI2V889hxAd3ELJS4bmPIWX6bE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Alexander Aring <aring@mojatatu.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 01/94] ieee802154: hwsim: Fix error handle path in hwsim_init_module
Date:   Wed,  4 Sep 2019 11:56:06 -0400
Message-Id: <20190904155739.2816-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 1cbbbf39efab05fae67f59e6ed01bb85061c69e2 ]

KASAN report this:

BUG: unable to handle kernel paging request at fffffbfff834f001
PGD 237fe8067 P4D 237fe8067 PUD 237e64067 PMD 1c968d067 PTE 0
Oops: 0000 [#1] SMP KASAN PTI
CPU: 1 PID: 8871 Comm: syz-executor.0 Tainted: G         C        5.0.0+ #5
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
RIP: 0010:strcmp+0x31/0xa0 lib/string.c:328
Code: 00 00 00 00 fc ff df 55 53 48 83 ec 08 eb 0a 84 db 48 89 ef 74 5a 4c 89 e6 48 89 f8 48 89 fa 48 8d 6f 01 48 c1 e8 03 83 e2 07 <42> 0f b6 04 28 38 d0 7f 04 84 c0 75 50 48 89 f0 48 89 f2 0f b6 5d
RSP: 0018:ffff8881e0c57800 EFLAGS: 00010246
RAX: 1ffffffff834f001 RBX: ffffffffc1a78000 RCX: ffffffff827b9503
RDX: 0000000000000000 RSI: ffffffffc1a40008 RDI: ffffffffc1a78008
RBP: ffffffffc1a78009 R08: fffffbfff6a92195 R09: fffffbfff6a92195
R10: ffff8881e0c578b8 R11: fffffbfff6a92194 R12: ffffffffc1a40008
R13: dffffc0000000000 R14: ffffffffc1a3e470 R15: ffffffffc1a40000
FS:  00007fdcc02ff700(0000) GS:ffff8881f7300000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff834f001 CR3: 00000001b3134003 CR4: 00000000007606e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 genl_family_find_byname+0x7f/0xf0 net/netlink/genetlink.c:104
 genl_register_family+0x1e1/0x1070 net/netlink/genetlink.c:333
 ? 0xffffffffc1978000
 hwsim_init_module+0x6a/0x1000 [mac802154_hwsim]
 ? 0xffffffffc1978000
 ? 0xffffffffc1978000
 ? 0xffffffffc1978000
 do_one_initcall+0xbc/0x47d init/main.c:887
 do_init_module+0x1b5/0x547 kernel/module.c:3456
 load_module+0x6405/0x8c10 kernel/module.c:3804
 __do_sys_finit_module+0x162/0x190 kernel/module.c:3898
 do_syscall_64+0x9f/0x450 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x462e99
Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fdcc02fec58 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
RAX: ffffffffffffffda RBX: 000000000073bf00 RCX: 0000000000462e99
RDX: 0000000000000000 RSI: 0000000020000200 RDI: 0000000000000003
RBP: 00007fdcc02fec70 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fdcc02ff6bc
R13: 00000000004bcefa R14: 00000000006f6fb0 R15: 0000000000000004
Modules linked in: mac802154_hwsim(+) mac802154 ieee802154 speakup(C) rc_proteus_2309 rtc_rk808 streebog_generic rds vboxguest madera_spi madera da9052_wdt mISDN_core ueagle_atm usbatm atm ir_imon_decoder scsi_transport_sas rc_dntv_live_dvb_t panel_samsung_s6d16d0 drm drm_panel_orientation_quirks lib80211 fb_agm1264k_fl(C) gspca_pac7302 gspca_main videobuf2_v4l2 soundwire_intel_init i2c_dln2 dln2 usbcore hid_gaff 88pm8607 nfnetlink axp20x_i2c axp20x uio pata_marvell pmbus_core snd_sonicvibes gameport snd_pcm snd_opl3_lib snd_timer snd_hwdep snd_mpu401_uart snd_rawmidi snd_seq_device snd soundcore rtc_ds1511 rtc_ds1742 vsock dwc_xlgmac rtc_rx8010 libphy twofish_x86_64_3way twofish_x86_64 twofish_common ad5696_i2c ad5686 lp8788_charger cxd2880_spi dvb_core videobuf2_common videodev media videobuf2_vmalloc videobuf2_memops fbtft(C) sysimgblt sysfillrect syscopyarea fb_sys_fops janz_ican3 firewire_net firewire_core crc_itu_t spi_slave_system_control i2c_matroxfb i2c_algo_bit
 matroxfb_base fb fbdev matroxfb_DAC1064 matroxfb_accel cfbcopyarea cfbimgblt cfbfillrect matroxfb_Ti3026 matroxfb_g450 g450_pll matroxfb_misc leds_blinkm ti_dac7311 intel_spi_pci intel_spi spi_nor hid_elan hid async_tx rc_cinergy_1400 rc_core intel_ishtp kxcjk_1013 industrialio_triggered_buffer kfifo_buf can_dev intel_th spi_pxa2xx_platform pata_artop vme_ca91cx42 gb_gbphy(C) greybus(C) industrialio mptbase st_drv cmac ttpci_eeprom via_wdt gpio_xra1403 mtd iptable_security iptable_raw iptable_mangle iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_filter bpfilter ip6_vti ip_vti ip_gre ipip sit tunnel4 ip_tunnel hsr veth netdevsim vxcan batman_adv cfg80211 rfkill chnl_net caif nlmon dummy team bonding vcan bridge stp llc ip6_gre gre ip6_tunnel tunnel6 tun joydev mousedev ppdev kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 input_leds crypto_simd cryptd glue_helper ide_pci_generic piix psmouse
 ide_core serio_raw ata_generic i2c_piix4 pata_acpi parport_pc parport floppy rtc_cmos intel_agp intel_gtt agpgart sch_fq_codel ip_tables x_tables sha1_ssse3 sha1_generic ipv6 [last unloaded: speakup]
Dumping ftrace buffer:
   (ftrace buffer empty)
CR2: fffffbfff834f001
---[ end trace 5aa772c793e0e971 ]---
RIP: 0010:strcmp+0x31/0xa0 lib/string.c:328
Code: 00 00 00 00 fc ff df 55 53 48 83 ec 08 eb 0a 84 db 48 89 ef 74 5a 4c 89 e6 48 89 f8 48 89 fa 48 8d 6f 01 48 c1 e8 03 83 e2 07 <42> 0f b6 04 28 38 d0 7f 04 84 c0 75 50 48 89 f0 48 89 f2 0f b6 5d
RSP: 0018:ffff8881e0c57800 EFLAGS: 00010246
RAX: 1ffffffff834f001 RBX: ffffffffc1a78000 RCX: ffffffff827b9503
RDX: 0000000000000000 RSI: ffffffffc1a40008 RDI: ffffffffc1a78008
RBP: ffffffffc1a78009 R08: fffffbfff6a92195 R09: fffffbfff6a92195
R10: ffff8881e0c578b8 R11: fffffbfff6a92194 R12: ffffffffc1a40008
R13: dffffc0000000000 R14: ffffffffc1a3e470 R15: ffffffffc1a40000
FS:  00007fdcc02ff700(0000) GS:ffff8881f7300000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff834f001 CR3: 00000001b3134003 CR4: 00000000007606e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554

The error handing path misplace the cleanup in hwsim_init_module,
switch the two cleanup functions to fix above issues.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Alexander Aring <aring@mojatatu.com>
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/mac802154_hwsim.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index b41696e16bdc8..94b9e9d775e40 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -901,9 +901,9 @@ static __init int hwsim_init_module(void)
 	return 0;
 
 platform_drv:
-	genl_unregister_family(&hwsim_genl_family);
-platform_dev:
 	platform_device_unregister(mac802154hwsim_dev);
+platform_dev:
+	genl_unregister_family(&hwsim_genl_family);
 	return rc;
 }
 
-- 
2.20.1

