Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5AE72F85A
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 10:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbfE3IM7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 30 May 2019 04:12:59 -0400
Received: from torres.zugschlus.de ([85.214.131.164]:53206 "EHLO
        torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726667AbfE3IM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 04:12:59 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.92)
        (envelope-from <mh+netdev@zugschlus.de>)
        id 1hWGBF-0006wP-MX; Thu, 30 May 2019 10:12:57 +0200
Date:   Thu, 30 May 2019 10:12:57 +0200
From:   Marc Haber <mh+netdev@zugschlus.de>
To:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: iwl_mvm_add_new_dqa_stream_wk BUG in lib/list_debug.c:56
Message-ID: <20190530081257.GA26133@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

on my primary notebook, a Lenovo X260, with an Intel Wireless 8260
(8086:24f3), running Debian unstable, I have started to see network
hangs since upgrading to kernel 5.1. In this situation, I cannot
restart Network-Manager (the call just hangs), I can log out of X, but
the system does not cleanly shut down and I need to Magic SysRq myself
out of the running system. This happens about once every two days.

dmesg:
[38083.673678] lanw0: authenticate with 92:2a:a8:cb:8b:6c
[38083.682971] lanw0: send auth to 92:2a:a8:cb:8b:6c (try 1/3)
[38083.693860] lanw0: authenticated
[38083.697711] lanw0: associate with 92:2a:a8:cb:8b:6c (try 1/3)
[38083.703029] lanw0: RX ReassocResp from 92:2a:a8:cb:8b:6c (capab=0x411 status=0 aid=1)
[38083.705838] lanw0: associated
[38114.658765] lanw0: disconnect from AP 92:2a:a8:cb:8b:6c for new auth to 02:9f:c2:ab:b6:9f
[38114.671649] lanw0: authenticate with 02:9f:c2:ab:b6:9f
[38114.680074] lanw0: send auth to 02:9f:c2:ab:b6:9f (try 1/3)
[38114.692359] lanw0: authenticated
[38114.693609] lanw0: associate with 02:9f:c2:ab:b6:9f (try 1/3)
[38114.698697] lanw0: RX ReassocResp from 02:9f:c2:ab:b6:9f (capab=0x411 status=0 aid=1)
[38114.700878] lanw0: associated
[38179.708187] lanw0: disconnect from AP 02:9f:c2:ab:b6:9f for new auth to 92:2a:a8:cb:8b:6c
[38179.720183] lanw0: authenticate with 92:2a:a8:cb:8b:6c
[38179.728924] lanw0: send auth to 92:2a:a8:cb:8b:6c (try 1/3)
[38179.741439] lanw0: authenticated
[38179.745606] lanw0: associate with 92:2a:a8:cb:8b:6c (try 1/3)
[38179.750579] lanw0: RX ReassocResp from 92:2a:a8:cb:8b:6c (capab=0x411 status=0 aid=1)
[38179.752854] lanw0: associated
[38179.854525] list_del corruption. next->prev should be ffff88839d6167f8, but was ffff88839d616108
[38179.854533] ------------[ cut here ]------------
[38179.854535] kernel BUG at lib/list_debug.c:56!
[38179.854539] invalid opcode: 0000 [#2] SMP PTI
[38179.854542] CPU: 0 PID: 1869 Comm: kworker/0:2 Tainted: G      D    O      5.1.1-zgws1 #5.1.1.20190514.3
[38179.854543] Hardware name: LENOVO 20F5S5X100/20F5S5X100, BIOS R02ET63W (1.36 ) 12/15/2017
[38179.854552] Workqueue: events iwl_mvm_add_new_dqa_stream_wk [iwlmvm]
[38179.854556] RIP: 0010:__list_del_entry_valid.cold.1+0x20/0x4c
[38179.854557] Code: e3 d8 81 e8 a7 f2 da ff 0f 0b 48 89 fe 48 89 c2 48 c7 c7 20 e4 d8 81 e8 93 f2 da ff 0f 0b 48 c7 c7 d0 e4 d8 81 e8 85 f2 da ff <0f> 0b 48 89 f2 48 89 fe 48 c7 c7 90 e4 d8 81 e8 71 f2 da ff 0f 0b
38179.854559] RSP: 0018:ffffc9000844fde8 EFLAGS: 00010246
[38179.854560] RAX: 0000000000000054 RBX: ffff88839d6167f8 RCX: 0000000000000000
[38179.854561] RDX: 0000000000000000 RSI: ffff8884318164d8 RDI: ffff8884318164d8
[38179.854562] RBP: ffff888150a56888 R08: 000000000000042a R09: 0000000000000063
[38179.854563] R10: 0000000000000000 R11: ffffc9000844fc88 R12: 000000000000000a
[38179.854564] R13: 0000000000000000 R14: ffff88842bdfe388 R15: 0000000000000000
[38179.854566] FS:  0000000000000000(0000) GS:ffff888431800000(0000) knlGS:0000000000000000
[38179.854567] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[38179.854568] CR2: 00007f87c26a5000 CR3: 000000033154a006 CR4: 00000000003626f0
[38179.854569] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[38179.854570] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[38179.854571] Call Trace:
[38179.854578]  iwl_mvm_add_new_dqa_stream_wk+0x2b2/0x760 [iwlmvm]
[38179.854582]  process_one_work+0x195/0x3d0
[38179.854584]  worker_thread+0x2b/0x390
[38179.854586]  ? create_worker+0x190/0x190
[38179.854588]  kthread+0x111/0x130
[38179.854589]  ? kthread_bind+0x20/0x20
[38179.854592]  ret_from_fork+0x35/0x40
[38179.854594] Modules linked in: vhost_net vhost tap ext2 mmc_block tun hid_generic usbhid hid ctr ccm rfcomm fuse acpi_call(O) cpufreq_userspace cpufreq_powersave cpufreq_conservative cmac bnep option cdc_ether btusb usbnet btbcm btintel usb_wwan mii usbserial bluetooth hmac drbg ansi_cprng ecdh_generic msr bridge stp llc dummy ip6t_REJECT arc4 nf_reject_ipv6 ip6_tables nft_chain_nat ipt_MASQUERADE nf_nat wmi_bmof nft_chain_route_ipv4 snd_hda_codec_hdmi iwlmvm xt_TCPMSS mac80211 snd_hda_codec_realtek nft_counter snd_hda_codec_generic iwlwifi snd_hda_intel intel_rapl snd_hda_codec x86_pkg_temp_thermal intel_powerclamp ipt_REJECT nf_reject_ipv4 kvm_intel xt_tcpudp snd_hda_core kvm irqbypass snd_hwdep xt_conntrack intel_cstate intel_rapl_perf nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 snd_pcm nft_compat input_leds serio_raw snd_timer cfg80211 thinkpad_acpi nf_tables sg nvram mei_hdcp ledtrig_audio intel_pch_thermal tpm_tis snd nfnetlink tpm_tis_core soundcore tpm rfkill wmi rng_core ac battery
[38179.854623]  evdev pcc_cpufreq button tcp_bbr sch_fq nfsd auth_rpcgss nfs_acl lockd grace coretemp sunrpc loop ip_tables x_tables autofs4 btrfs zlib_deflate ext4 crc16 mbcache jbd2 algif_skcipher af_alg dm_crypt dm_mod raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor uas usb_storage raid6_pq libcrc32c crc32c_generic raid1 raid0 multipath linear md_mod sd_mod crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel rtsx_pci_sdmmc mmc_core aesni_intel aes_x86_64 crypto_simd cryptd glue_helper ahci libahci psmouse xhci_pci i2c_i801 e1000e libata xhci_hcd rtsx_pci mfd_core scsi_mod usbcore usb_common i915 i2c_algo_bit drm_kms_helper drm i2c_core thermal video
[38179.854652] ---[ end trace fd93637fcde969e6 ]---
[38179.854654] RIP: 0010:compaction_alloc+0x569/0x8c0
[38179.854656] Code: 62 01 00 00 49 be 00 00 00 00 00 16 00 00 eb 72 48 b8 00 00 00 00 00 ea ff ff 49 89 da 49 c1 e2 06 4d 8d 2c 02 4d 85 ed 74 3b <41> 8b 45 30 25 80 00 00 f0 3d 00 00 00 f0 0f 84 f9 00 00 00 41 80
[38179.854657] RSP: 0018:ffffc90001a5f900 EFLAGS: 00010286
[38179.854658] RAX: ffffea0000000000 RBX: 80000000000ffe00 RCX: 000000000000003c
[38179.854659] RDX: 80000000000ffe00 RSI: 0000000000000000 RDI: ffff8884417f42c0
[38179.854660] RBP: 8000000000100000 R08: 0000000000000000 R09: ffff8884417fab80
[38179.854661] R10: 0000000003ff8000 R11: 8000000000122c00 R12: 0000000000000020
[38179.854662] R13: ffffea0003ff8000 R14: 0000160000000000 R15: ffffc90001a5fae0
[38179.854664] FS:  0000000000000000(0000) GS:ffff888431800000(0000) knlGS:0000000000000000
[38179.854665] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[38179.854666] CR2: 00007f87c26a5000 CR3: 000000033154a006 CR4: 00000000003626f0
[38179.854667] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[38179.854667] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


Is that a known issue? I currently have this with 5.1.5, are there patches in
the queue that may be candidates to stabilize my wireless again?

Greetings
Marc


-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
