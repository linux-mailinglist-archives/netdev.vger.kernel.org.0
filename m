Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60FFE30B241
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 22:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhBAVqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 16:46:38 -0500
Received: from mga11.intel.com ([192.55.52.93]:26807 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229629AbhBAVqe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 16:46:34 -0500
IronPort-SDR: 7DNJE1Pin/iA9MEHjl2NsLKnnNkvbC+/7Dz4gs9Kre1g5j81CVgqSnKqaaPcrmZh1VLQezR/9W
 +jP582ZgOdzg==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="177249325"
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="177249325"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 13:45:34 -0800
IronPort-SDR: U4oDIVD8mg63hUVZyGSCVCm/6a1dn04/u6rNmMZj7LCWvqrHGLVMnPksDaHMeZ2FT6xvEb7CWh
 BE6/geh0fbXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="354638537"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 01 Feb 2021 13:45:34 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Sasha Neftin <sasha.neftin@intel.com>
Subject: [PATCH net v2 1/4] igc: Report speed and duplex as unknown when device is runtime suspended
Date:   Mon,  1 Feb 2021 13:46:15 -0800
Message-Id: <20210201214618.852831-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210201214618.852831-1-anthony.l.nguyen@intel.com>
References: <20210201214618.852831-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

Similar to commit 165ae7a8feb5 ("igb: Report speed and duplex as unknown
when device is runtime suspended"), if we try to read speed and duplex
sysfs while the device is runtime suspended, igc will complain and
stops working:

[  123.449883] igc 0000:03:00.0 enp3s0: PCIe link lost, device now detached
[  123.450052] BUG: kernel NULL pointer dereference, address: 0000000000000008
[  123.450056] #PF: supervisor read access in kernel mode
[  123.450058] #PF: error_code(0x0000) - not-present page
[  123.450059] PGD 0 P4D 0
[  123.450064] Oops: 0000 [#1] SMP NOPTI
[  123.450068] CPU: 0 PID: 2525 Comm: udevadm Tainted: G     U  W  OE     5.10.0-1002-oem #2+rkl2-Ubuntu
[  123.450078] RIP: 0010:igc_rd32+0x1c/0x90 [igc]
[  123.450080] Code: c0 5d c3 b8 fd ff ff ff c3 0f 1f 44 00 00 0f 1f 44 00 00 55 89 f0 48 89 e5 41 56 41 55 41 54 49 89 c4 53 48 8b 57 08 48 01 d0 <44> 8b 28 41 83 fd ff 74 0c 5b 44 89 e8 41 5c 41 5d 4

[  123.450083] RSP: 0018:ffffb0d100d6fcc0 EFLAGS: 00010202
[  123.450085] RAX: 0000000000000008 RBX: ffffb0d100d6fd30 RCX: 0000000000000000
[  123.450087] RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff945a12716c10
[  123.450089] RBP: ffffb0d100d6fce0 R08: ffff945a12716550 R09: ffff945a09874000
[  123.450090] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000008
[  123.450092] R13: ffff945a12716000 R14: ffff945a037da280 R15: ffff945a037da290
[  123.450094] FS:  00007f3b34c868c0(0000) GS:ffff945b89200000(0000) knlGS:0000000000000000
[  123.450096] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  123.450098] CR2: 0000000000000008 CR3: 00000001144de006 CR4: 0000000000770ef0
[  123.450100] PKRU: 55555554
[  123.450101] Call Trace:
[  123.450111]  igc_ethtool_get_link_ksettings+0xd6/0x1b0 [igc]
[  123.450118]  __ethtool_get_link_ksettings+0x71/0xb0
[  123.450123]  duplex_show+0x74/0xc0
[  123.450129]  dev_attr_show+0x1d/0x40
[  123.450134]  sysfs_kf_seq_show+0xa1/0x100
[  123.450137]  kernfs_seq_show+0x27/0x30
[  123.450142]  seq_read+0xb7/0x400
[  123.450148]  ? common_file_perm+0x72/0x170
[  123.450151]  kernfs_fop_read+0x35/0x1b0
[  123.450155]  vfs_read+0xb5/0x1b0
[  123.450157]  ksys_read+0x67/0xe0
[  123.450160]  __x64_sys_read+0x1a/0x20
[  123.450164]  do_syscall_64+0x38/0x90
[  123.450168]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  123.450170] RIP: 0033:0x7f3b351fe142
[  123.450173] Code: c0 e9 c2 fe ff ff 50 48 8d 3d 3a ca 0a 00 e8 f5 19 02 00 0f 1f 44 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 0f 05 <48> 3d 00 f0 ff ff 77 56 c3 0f 1f 44 00 00 48 83 ec 28 48 89 54 24
[  123.450174] RSP: 002b:00007fffef2ec138 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[  123.450177] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f3b351fe142
[  123.450179] RDX: 0000000000001001 RSI: 00005644c047f070 RDI: 0000000000000003
[  123.450180] RBP: 00007fffef2ec340 R08: 00005644c047f070 R09: 00007f3b352d9320
[  123.450182] R10: 00005644c047c010 R11: 0000000000000246 R12: 00005644c047cbf0
[  123.450184] R13: 00005644c047e6d0 R14: 0000000000000003 R15: 00007fffef2ec140
[  123.450189] Modules linked in: rfcomm ccm cmac algif_hash algif_skcipher af_alg bnep toshiba_acpi industrialio toshiba_haps hp_accel lis3lv02d btusb btrtl btbcm btintel bluetooth ecdh_generic ecc joydev input_leds nls_iso8859_1 snd_sof_pci snd_sof_intel_byt snd_sof_intel_ipc snd_sof_intel_hda_common snd_soc_hdac_hda snd_hda_codec_hdmi snd_sof_xtensa_dsp snd_sof_intel_hda snd_sof snd_hda_ext_core snd_soc_acpi_intel_match snd_soc_acpi snd_hda_codec_realtek snd_hda_codec_generic ledtrig_audio snd_hda_intel snd_intel_dspcfg soundwire_intel soundwire_generic_allocation soundwire_cadence snd_hda_codec snd_hda_core ath10k_pci snd_hwdep intel_rapl_msr intel_rapl_common ath10k_core soundwire_bus snd_soc_core x86_pkg_temp_thermal ath intel_powerclamp snd_compress ac97_bus snd_pcm_dmaengine mac80211 snd_pcm coretemp snd_seq_midi snd_seq_midi_event snd_rawmidi kvm_intel cfg80211 snd_seq snd_seq_device snd_timer mei_hdcp kvm libarc4 snd crct10dif_pclmul ghash_clmulni_intel aesni_intel
 mei_me dell_wmi
[  123.450266]  dell_smbios soundcore sparse_keymap dcdbas crypto_simd cryptd mei dell_uart_backlight glue_helper ee1004 wmi_bmof intel_wmi_thunderbolt dell_wmi_descriptor mac_hid efi_pstore acpi_pad acpi_tad intel_cstate sch_fq_codel parport_pc ppdev lp parport ip_tables x_tables autofs4 btrfs blake2b_generic raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c raid1 raid0 multipath linear dm_mirror dm_region_hash dm_log hid_generic usbhid hid i915 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops cec crc32_pclmul rc_core drm intel_lpss_pci i2c_i801 ahci igc intel_lpss i2c_smbus idma64 xhci_pci libahci virt_dma xhci_pci_renesas wmi video pinctrl_tigerlake
[  123.450335] CR2: 0000000000000008
[  123.450338] ---[ end trace 9f731e38b53c35cc ]---

The more generic approach will be wrap get_link_ksettings() with begin()
and complete() callbacks, and calls runtime resume and runtime suspend
routine respectively. However, igc is like igb, runtime resume routine
uses rtnl_lock() which upper ethtool layer also uses.

So to prevent a deadlock on rtnl, take a different approach, use
pm_runtime_suspended() to avoid reading register while device is runtime
suspended.

Fixes: 8c5ad0dae93c ("igc: Add ethtool support")
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 831f2f09de5f..ec8cd69d4992 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -1714,7 +1714,8 @@ static int igc_ethtool_get_link_ksettings(struct net_device *netdev,
 						     Asym_Pause);
 	}
 
-	status = rd32(IGC_STATUS);
+	status = pm_runtime_suspended(&adapter->pdev->dev) ?
+		 0 : rd32(IGC_STATUS);
 
 	if (status & IGC_STATUS_LU) {
 		if (status & IGC_STATUS_SPEED_1000) {
-- 
2.26.2

