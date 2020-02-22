Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA7F4168AFB
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 01:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgBVAa0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 21 Feb 2020 19:30:26 -0500
Received: from mga12.intel.com ([192.55.52.136]:57313 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726697AbgBVAa0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 19:30:26 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Feb 2020 16:30:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,470,1574150400"; 
   d="scan'208";a="437123404"
Received: from orsmsx107.amr.corp.intel.com ([10.22.240.5])
  by fmsmga006.fm.intel.com with ESMTP; 21 Feb 2020 16:30:22 -0800
Received: from orsmsx103.amr.corp.intel.com ([169.254.5.43]) by
 ORSMSX107.amr.corp.intel.com ([169.254.1.106]) with mapi id 14.03.0439.000;
 Fri, 21 Feb 2020 16:30:22 -0800
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH v3 1/2] igb: Use device_lock() insead
 of rtnl_lock()
Thread-Topic: [Intel-wired-lan] [PATCH v3 1/2] igb: Use device_lock() insead
 of rtnl_lock()
Thread-Index: AQHV3Z7TQowGVpsUH068d9CcjdELQKgmcBOA
Date:   Sat, 22 Feb 2020 00:30:22 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B971F9210@ORSMSX103.amr.corp.intel.com>
References: <20200207101005.4454-1-kai.heng.feng@canonical.com>
In-Reply-To: <20200207101005.4454-1-kai.heng.feng@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Kai-Heng Feng
> Sent: Friday, February 7, 2020 2:10 AM
> To: davem@davemloft.net; mkubecek@suse.cz; Kirsher, Jeffrey T
> <jeffrey.t.kirsher@intel.com>
> Cc: open list:NETWORKING DRIVERS <netdev@vger.kernel.org>; Kai-Heng
> Feng <kai.heng.feng@canonical.com>; moderated list:INTEL ETHERNET
> DRIVERS <intel-wired-lan@lists.osuosl.org>; open list <linux-
> kernel@vger.kernel.org>
> Subject: [Intel-wired-lan] [PATCH v3 1/2] igb: Use device_lock() insead of
> rtnl_lock()
> 
> Commit 9474933caf21 ("igb: close/suspend race in netif_device_detach")
> fixed race condition between close and power management ops by using
> rtnl_lock().
> 
> However we can achieve the same by using device_lock() since all power
> management ops are protected by device_lock().
> 
> This fix is a preparation for next patch, to prevent a dead lock under
> rtnl_lock() when calling runtime resume routine.
> 
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
> v3:
>  - Fix unreleased lock reported by 0-day test bot.
> v2:
>  - No change.
> 
>  drivers/net/ethernet/intel/igb/igb_main.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)

This patch introduces the following call trace / RIP when I sleep / resume (via rtcwake) a system that has an igb port with link up:  I'm not sure if it introduces the issue or just exposes / displays it as it only shows up on the first sleep / resume cycle and the systems I have that were stable for many sleep / resume cycles (arbitrarily 50+) continue to be so.  
-------------------------------------------------------------------------------------------------
...
[   50.279436] usb usb3: root hub lost power or was reset
[   50.279437] usb usb4: root hub lost power or was reset
[   50.279491] sd 1:0:0:0: [sda] Starting disk
[   50.317691] ------------[ cut here ]------------
[   50.317692] RTNL: assertion failed at net/core/dev.c (2867)
[   50.317700] WARNING: CPU: 6 PID: 5287 at net/core/dev.c:2867 netif_set_real_num_tx_queues+0x184/0x1a0
[   50.317701] Modules linked in: rfcomm xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ipt_REJECT nf_rej
ect_ipv4 nft_counter nft_compat nf_tables nfnetlink tun bridge stp llc cmac bnep iTCO_wdt intel_wmi_thunderbolt iT
CO_vendor_support mxm_wmi wmi_bmof x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel snd_hda_codec_hdmi kvm
 snd_hda_codec_realtek irqbypass snd_hda_codec_generic ledtrig_audio btusb btrtl btbcm snd_hda_intel btintel snd_i
ntel_dspcfg snd_hda_codec bluetooth snd_hwdep snd_hda_core snd_seq crct10dif_pclmul crc32_pclmul joydev snd_seq_de
vice ghash_clmulni_intel intel_cstate snd_pcm mei_me intel_uncore snd_timer ecdh_generic snd ecc pcspkr mei rfkill
 i2c_i801 soundcore intel_rapl_perf sg wmi acpi_pad intel_pmc_core nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_
tables xfs libcrc32c sr_mod sd_mod cdrom t10_pi i915 intel_gtt drm_kms_helper syscopyarea sysfillrect sysimgblt fb
_sys_fops cec drm igb ahci libahci e1000e libata crc32c_intel dca i2c_algo_bit video
[   50.317719] CPU: 6 PID: 5287 Comm: kworker/u24:17 Not tainted 5.6.0-rc2_next-queue_dev-queue_81b6341+ #5
[   50.317720] Hardware name: Gigabyte Technology Co., Ltd. Z370 AORUS Gaming 5/Z370 AORUS Gaming 5-CF, BIOS F6 04
/03/2018
[   50.317722] Workqueue: events_unbound async_run_entry_fn
[   50.317723] RIP: 0010:netif_set_real_num_tx_queues+0x184/0x1a0
[   50.317724] Code: 43 1e e7 00 00 0f 85 fc fe ff ff ba 33 0b 00 00 48 c7 c6 92 57 9a bd 48 c7 c7 e0 a4 91 bd c6
05 23 1e e7 00 01 e8 57 3c 97 ff <0f> 0b e9 d6 fe ff ff 41 be ea ff ff ff e9 a4 fe ff ff 66 2e 0f 1f
[   50.317724] RSP: 0018:ffffb57fc1347d38 EFLAGS: 00010282
[   50.317725] RAX: 0000000000000000 RBX: ffff995a9e3e4000 RCX: 0000000000000007
[   50.317725] RDX: 0000000000000007 RSI: 0000000000000002 RDI: ffff995abe398f40
[   50.317725] RBP: 0000000000000004 R08: 0000000000000002 R09: 000000000002b500
[   50.317726] R10: 0000003a9dc62fa1 R11: 0000000000fed278 R12: 0000000000000004
[   50.317726] R13: 0000000000000004 R14: ffff995a9e3e4000 R15: ffff995a9e3e4000
[   50.317727] FS:  0000000000000000(0000) GS:ffff995abe380000(0000) knlGS:0000000000000000
[   50.317727] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   50.317727] CR2: 00007f4dbd7fae20 CR3: 0000000efbe0a004 CR4: 00000000003606e0
[   50.317728] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   50.317728] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   50.317728] Call Trace:
[   50.317734]  __igb_open+0x1ee/0x5c0 [igb]
[   50.317737]  igb_resume+0x193/0x1c0 [igb]
[   50.317739]  ? pci_pm_thaw+0x80/0x80
[   50.317741]  dpm_run_callback+0x4f/0x140
[   50.317742]  device_resume+0x107/0x180
[   50.317743]  async_resume+0x19/0x50
[   50.317744]  async_run_entry_fn+0x39/0x160
[   50.317746]  process_one_work+0x1a7/0x370
[   50.317747]  worker_thread+0x30/0x380
[   50.317748]  ? process_one_work+0x370/0x370
[   50.317749]  kthread+0x10c/0x130
[   50.317750]  ? kthread_park+0x80/0x80
[   50.317751]  ret_from_fork+0x35/0x40
[   50.317752] ---[ end trace 45a9ec6b02347b6e ]---
[   50.317753] ------------[ cut here ]------------
[   50.317753] RTNL: assertion failed at net/core/dev.c (2913)
[   50.317756] WARNING: CPU: 6 PID: 5287 at net/core/dev.c:2913 netif_set_real_num_rx_queues+0x79/0x80
[   50.317757] Modules linked in: rfcomm xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ipt_REJECT nf_rej
ect_ipv4 nft_counter nft_compat nf_tables nfnetlink tun bridge stp llc cmac bnep iTCO_wdt intel_wmi_thunderbolt iT
CO_vendor_support mxm_wmi wmi_bmof x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel snd_hda_codec_hdmi kvm
 snd_hda_codec_realtek irqbypass snd_hda_codec_generic ledtrig_audio btusb btrtl btbcm snd_hda_intel btintel snd_i
ntel_dspcfg snd_hda_codec bluetooth snd_hwdep snd_hda_core snd_seq crct10dif_pclmul crc32_pclmul joydev snd_seq_de
vice ghash_clmulni_intel intel_cstate snd_pcm mei_me intel_uncore snd_timer ecdh_generic snd ecc pcspkr mei rfkill
 i2c_i801 soundcore intel_rapl_perf sg wmi acpi_pad intel_pmc_core nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_
tables xfs libcrc32c sr_mod sd_mod cdrom t10_pi i915 intel_gtt drm_kms_helper syscopyarea sysfillrect sysimgblt fb
_sys_fops cec drm igb ahci libahci e1000e libata crc32c_intel dca i2c_algo_bit video
[   50.317766] CPU: 6 PID: 5287 Comm: kworker/u24:17 Tainted: G        W         5.6.0-rc2_next-queue_dev-queue_81
b6341+ #5
[   50.317766] Hardware name: Gigabyte Technology Co., Ltd. Z370 AORUS Gaming 5/Z370 AORUS Gaming 5-CF, BIOS F6 04
/03/2018
[   50.317767] Workqueue: events_unbound async_run_entry_fn
[   50.317768] RIP: 0010:netif_set_real_num_rx_queues+0x79/0x80
[   50.317768] Code: ff c3 80 3d 89 6c e7 00 00 75 db ba 61 0b 00 00 48 c7 c6 92 57 9a bd 48 c7 c7 e0 a4 91 bd c6
05 6d 6c e7 00 01 e8 a2 8a 97 ff <0f> 0b eb b8 0f 1f 00 0f 1f 44 00 00 53 f0 48 0f ba af d8 00 00 00
[   50.317769] RSP: 0018:ffffb57fc1347d58 EFLAGS: 00010282
[   50.317769] RAX: 0000000000000000 RBX: ffff995a9e3e4000 RCX: 0000000000000007
[   50.317769] RDX: 0000000000000007 RSI: 0000000000000002 RDI: ffff995abe398f40
[   50.317770] RBP: 0000000000000004 R08: 0000000000000002 R09: 000000000002b500
[   50.317770] R10: 0000003a9dc92851 R11: 0000000000fec568 R12: 0000000000000000
[   50.317770] R13: 0000000000000001 R14: ffff995a9e3e4000 R15: ffff995a9e3e4000
[   50.317771] FS:  0000000000000000(0000) GS:ffff995abe380000(0000) knlGS:0000000000000000
[   50.317771] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   50.317771] CR2: 00007f4dbd7fae20 CR3: 0000000efbe0a004 CR4: 00000000003606e0
[   50.317772] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   50.317772] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   50.317772] Call Trace:
[   50.317775]  __igb_open+0x208/0x5c0 [igb]
[   50.317777]  igb_resume+0x193/0x1c0 [igb]
[   50.317777]  ? pci_pm_thaw+0x80/0x80
[   50.317778]  dpm_run_callback+0x4f/0x140
[   50.317779]  device_resume+0x107/0x180
[   50.317780]  async_resume+0x19/0x50
[   50.317781]  async_run_entry_fn+0x39/0x160
[   50.317782]  process_one_work+0x1a7/0x370
[   50.317783]  worker_thread+0x30/0x380
[   50.317784]  ? process_one_work+0x370/0x370
[   50.317785]  kthread+0x10c/0x130
[   50.317785]  ? kthread_park+0x80/0x80
[   50.317786]  ret_from_fork+0x35/0x40
[   50.317787] ---[ end trace 45a9ec6b02347b6f ]---
[   50.560158] OOM killer enabled.
[   50.560158] Restarting tasks ... done.
[   50.560713] video LNXVIDEO:00: Restoring backlight state
[   50.560714] PM: suspend exit
[   50.601179] ata5: SATA link down (SStatus 4 SControl 300)
[   50.601201] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
...
