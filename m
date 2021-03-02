Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6869B32A3E0
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382721AbhCBJwB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 2 Mar 2021 04:52:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47063 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379001AbhCBJhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 04:37:17 -0500
Received: from ip5f5af0a0.dynamic.kabel-deutschland.de ([95.90.240.160] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1lH1Rq-00008b-Gf; Tue, 02 Mar 2021 09:36:10 +0000
Date:   Tue, 2 Mar 2021 10:36:09 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Triggering WARN in net/wireless/nl80211.c
Message-ID: <20210302093609.a6vmvwtlu3qns67s@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey everyone,

I get the following WARN triggered in net/wireless/nl80211.c during boot
on v5.12-rc1:

[   36.749643] ------------[ cut here ]------------
[   36.749645] WARNING: CPU: 7 PID: 829 at net/wireless/nl80211.c:7746 nl80211_get_reg_do+0x215/0x250 [cfg80211]
[   36.749683] Modules linked in: bnep ccm algif_aead des_generic libdes arc4 algif_skcipher cmac md4 algif_hash af_alg typec_displayport binfmt_misc snd_hda_codec_hdmi nls_iso8859_1 joydev mei_hdcp intel_rapl_msr x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm snd_hda_codec_realtek snd_hda_codec_generic rapl iwlmvm intel_cstate mac80211 snd_hda_intel snd_intel_dspcfg input_leds snd_seq_midi snd_hda_codec rmi_smbus libarc4 snd_seq_midi_event rmi_core serio_raw snd_hda_core uvcvideo snd_rawmidi efi_pstore iwlwifi snd_hwdep intel_wmi_thunderbolt videobuf2_vmalloc snd_pcm wmi_bmof btusb videobuf2_memops thinkpad_acpi videobuf2_v4l2 btrtl videobuf2_common processor_thermal_device btbcm processor_thermal_rfim nvram snd_seq btintel platform_profile videodev processor_thermal_mbox ucsi_acpi bluetooth ledtrig_audio processor_thermal_rapl mei_me snd_seq_device intel_rapl_common typec_ucsi mc ecdh_generic cfg80211 ecc intel_pch_thermal mei intel_soc_dts_iosf intel_xhci_usb_role_switch
[   36.749713]  typec snd_timer snd soundcore int3403_thermal int340x_thermal_zone acpi_pad mac_hid int3400_thermal acpi_thermal_rel sch_fq_codel pkcs8_key_parser ip_tables x_tables autofs4 btrfs blake2b_generic xor zstd_compress raid6_pq libcrc32c dm_crypt uas usb_storage i915 crct10dif_pclmul crc32_pclmul ghash_clmulni_intel i2c_algo_bit aesni_intel crypto_simd drm_kms_helper cryptd syscopyarea nvme sysfillrect psmouse sysimgblt fb_sys_fops nvme_core cec e1000e i2c_i801 drm i2c_smbus wmi video
[   36.749735] CPU: 7 PID: 829 Comm: iwd Tainted: G     U            5.12.0-rc1-brauner-v5.12-rc1 #316
[   36.749737] Hardware name: LENOVO 20KHCTO1WW/20KHCTO1WW, BIOS N23ET75W (1.50 ) 10/13/2020
[   36.749738] RIP: 0010:nl80211_get_reg_do+0x215/0x250 [cfg80211]
[   36.749763] Code: 00 e8 8f f0 07 d0 85 c0 0f 84 ee fe ff ff eb a3 4c 89 e7 48 89 45 c0 e8 49 6d 44 d0 e8 64 09 47 d0 48 8b 45 c0 e9 36 ff ff ff <0f> 0b 4c 89 e7 e8 31 6d 44 d0 e8 4c 09 47 d0 b8 ea ff ff ff e9 1d
[   36.749765] RSP: 0018:ffffa71800b7bb10 EFLAGS: 00010202
[   36.749766] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
[   36.749767] RDX: ffff8bef4beb0008 RSI: 0000000000000000 RDI: ffff8bef4beb0300
[   36.749768] RBP: ffffa71800b7bb50 R08: ffff8bef4beb0300 R09: ffff8bef4b7ba014
[   36.749770] R10: 0000000000000000 R11: 000000000000001f R12: ffff8bef4d38e800
[   36.749771] R13: ffffa71800b7bb78 R14: ffff8bef4b7ba014 R15: 0000000000000000
[   36.749772] FS:  00007f89333c4740(0000) GS:ffff8bf2d17c0000(0000) knlGS:0000000000000000
[   36.749773] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   36.749774] CR2: 00007ffdda038ca8 CR3: 0000000108ca0002 CR4: 00000000003706e0
[   36.749776] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   36.749777] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   36.749778] Call Trace:
[   36.749781]  ? rtnl_unlock+0xe/0x10
[   36.749786]  genl_family_rcv_msg_doit.isra.0+0xec/0x150
[   36.749791]  genl_rcv_msg+0xe5/0x1e0
[   36.749793]  ? __cfg80211_rdev_from_attrs+0x1c0/0x1c0 [cfg80211]
[   36.749821]  ? nl80211_send_regdom.constprop.0+0x1a0/0x1a0 [cfg80211]
[   36.749847]  ? genl_family_rcv_msg_doit.isra.0+0x150/0x150
[   36.749850]  netlink_rcv_skb+0x55/0x100
[   36.749853]  genl_rcv+0x29/0x40
[   36.749855]  netlink_unicast+0x1a8/0x250
[   36.749858]  netlink_sendmsg+0x233/0x460
[   36.749860]  sock_sendmsg+0x65/0x70
[   36.749863]  __sys_sendto+0x113/0x190
[   36.749865]  ? __secure_computing+0x42/0xe0
[   36.749867]  __x64_sys_sendto+0x29/0x30
[   36.749869]  do_syscall_64+0x38/0x90
[   36.749872]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   36.749874] RIP: 0033:0x7f89334e16c0
[   36.749875] Code: c0 ff ff ff ff eb b8 0f 1f 00 f3 0f 1e fa 41 89 ca 64 8b 04 25 18 00 00 00 85 c0 75 1d 45 31 c9 45 31 c0 b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 68 c3 0f 1f 80 00 00 00 00 55 48 83 ec 20 48
[   36.749877] RSP: 002b:00007ffdda03da08 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[   36.749878] RAX: ffffffffffffffda RBX: 0000561f2c3c7b00 RCX: 00007f89334e16c0
[   36.749879] RDX: 000000000000001c RSI: 0000561f2c3e66c0 RDI: 0000000000000004
[   36.749880] RBP: 0000561f2c3d28e0 R08: 0000000000000000 R09: 0000000000000000
[   36.749880] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffdda03da6c
[   36.749881] R13: 00007ffdda03da68 R14: 0000561f2c3d1790 R15: 0000000000000000
[   36.749883] ---[ end trace 7cf430797302f3ab ]---

> dmesg | grep -i wifi
[   32.842573] Intel(R) Wireless WiFi driver for Linux
[   32.869098] iwlwifi 0000:02:00.0: Found debug destination: EXTERNAL_DRAM
[   32.869102] iwlwifi 0000:02:00.0: Found debug configuration: 0
[   32.869688] iwlwifi 0000:02:00.0: loaded firmware version 36.79ff3ccf.0 8265-36.ucode op_mode iwlmvm
[   32.931443] iwlwifi 0000:02:00.0: Detected Intel(R) Dual Band Wireless AC 8265, REV=0x230
[   32.952115] iwlwifi 0000:02:00.0: Applying debug destination EXTERNAL_DRAM
[   32.952519] iwlwifi 0000:02:00.0: Allocated 0x00400000 bytes for firmware monitor.
[   33.016062] iwlwifi 0000:02:00.0: base HW address: 3c:6a:a7:16:8c:cb
[   36.861423] iwlwifi 0000:02:00.0: Applying debug destination EXTERNAL_DRAM
[   36.993832] iwlwifi 0000:02:00.0: Applying debug destination EXTERNAL_DRAM
[   37.061293] iwlwifi 0000:02:00.0: FW already configured (0) - re-configuring

Thanks!
Christian
