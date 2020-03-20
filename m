Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC1718C7CB
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 08:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgCTHAW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 20 Mar 2020 03:00:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:29769 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgCTHAW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 03:00:22 -0400
IronPort-SDR: Z7jCwTFPON1Lbr5bsP1MHSGhFuht36CcdBdK/0XnHfCLA07tTMQz8l5WkSyCZC7i5RWmi52B5V
 lPydsrkLNUkg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 00:00:20 -0700
IronPort-SDR: yQmtV6g6mbucOm54zVhJ+bwVVb5eA5/Z9idp1Zah4IOJ5M4PWylSE2EsiJl3Oc8qIFNhaxhAft
 pV3Nxo+OA3gw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,283,1580803200"; 
   d="scan'208";a="392065558"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by orsmga004.jf.intel.com with ESMTP; 20 Mar 2020 00:00:20 -0700
Received: from orsmsx103.amr.corp.intel.com ([169.254.5.6]) by
 ORSMSX106.amr.corp.intel.com ([169.254.1.230]) with mapi id 14.03.0439.000;
 Fri, 20 Mar 2020 00:00:20 -0700
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH v3 1/2] igb: Use device_lock() insead
 of rtnl_lock()
Thread-Topic: [Intel-wired-lan] [PATCH v3 1/2] igb: Use device_lock() insead
 of rtnl_lock()
Thread-Index: AQHV3Z7TQowGVpsUH068d9CcjdELQKgmcBOAgARebgCAJllakA==
Date:   Fri, 20 Mar 2020 07:00:19 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B97224361@ORSMSX103.amr.corp.intel.com>
References: <20200207101005.4454-1-kai.heng.feng@canonical.com>
 <309B89C4C689E141A5FF6A0C5FB2118B971F9210@ORSMSX103.amr.corp.intel.com>
 <3CA021B0-FEB8-4DAA-9CF2-224F305A8C8A@canonical.com>
In-Reply-To: <3CA021B0-FEB8-4DAA-9CF2-224F305A8C8A@canonical.com>
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

> From: Kai-Heng Feng <kai.heng.feng@canonical.com>
> Sent: Monday, February 24, 2020 3:02 AM
> To: Brown, Aaron F <aaron.f.brown@intel.com>
> Cc: davem@davemloft.net; mkubecek@suse.cz; Kirsher, Jeffrey T
> <jeffrey.t.kirsher@intel.com>; open list:NETWORKING DRIVERS
> <netdev@vger.kernel.org>; moderated list:INTEL ETHERNET DRIVERS <intel-
> wired-lan@lists.osuosl.org>; open list <linux-kernel@vger.kernel.org>
> Subject: Re: [Intel-wired-lan] [PATCH v3 1/2] igb: Use device_lock() insead of
> rtnl_lock()
> 
> 
> 
> > On Feb 22, 2020, at 08:30, Brown, Aaron F <aaron.f.brown@intel.com> wrote:
> >
> >
> >
> >> -----Original Message-----
> >> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> >> Kai-Heng Feng
> >> Sent: Friday, February 7, 2020 2:10 AM
> >> To: davem@davemloft.net; mkubecek@suse.cz; Kirsher, Jeffrey T
> >> <jeffrey.t.kirsher@intel.com>
> >> Cc: open list:NETWORKING DRIVERS <netdev@vger.kernel.org>; Kai-Heng
> >> Feng <kai.heng.feng@canonical.com>; moderated list:INTEL ETHERNET
> >> DRIVERS <intel-wired-lan@lists.osuosl.org>; open list <linux-
> >> kernel@vger.kernel.org>
> >> Subject: [Intel-wired-lan] [PATCH v3 1/2] igb: Use device_lock() insead of
> >> rtnl_lock()
> >>
> >> Commit 9474933caf21 ("igb: close/suspend race in netif_device_detach")
> >> fixed race condition between close and power management ops by using
> >> rtnl_lock().
> >>
> >> However we can achieve the same by using device_lock() since all power
> >> management ops are protected by device_lock().
> >>
> >> This fix is a preparation for next patch, to prevent a dead lock under
> >> rtnl_lock() when calling runtime resume routine.
> >>
> >> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> >> ---
> >> v3:
> >> - Fix unreleased lock reported by 0-day test bot.
> >> v2:
> >> - No change.
> >>
> >> drivers/net/ethernet/intel/igb/igb_main.c | 14 ++++++++------
> >> 1 file changed, 8 insertions(+), 6 deletions(-)
> >
> > This patch introduces the following call trace / RIP when I sleep / resume (via
> rtcwake) a system that has an igb port with link up:  I'm not sure if it introduces
> the issue or just exposes / displays it as it only shows up on the first sleep /
> resume cycle and the systems I have that were stable for many sleep / resume
> cycles (arbitrarily 50+) continue to be so.
> 
> I can't reproduce the issue here.
> 

I just got back to looking at the igb driver and  found a similar call trace / RIP with this patch.  Turns out any of my igb systems will freeze if the igb driver is unloaded while the interface is logically up with link.  The system continues to run if I switch to another console, but any attempt to look at the network (ifconfig, ethtool, etc...) makes that other session freeze up.  Then about 5 minutes later a trace appears on the screen and continues to do so every few minutes.  Here's what I pulled out of the system log for this instance:
-----------------------------------------------------------------------------------------------------
Mar 20 04:11:40 u1458 kernel: igb 0000:09:00.0 eth2: igb: eth2 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
Mar 20 04:14:54 u1458 kernel: INFO: task kworker/7:1:53 blocked for more than 122 seconds.
Mar 20 04:14:54 u1458 kernel:      Not tainted 5.6.0-rc5_next-queue_dev-queue_a601740+ #24
Mar 20 04:14:54 u1458 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 20 04:14:54 u1458 kernel: kworker/7:1     D    0    53      2 0x80004000
Mar 20 04:14:54 u1458 kernel: Workqueue: events linkwatch_event
Mar 20 04:14:54 u1458 kernel: Call Trace:
Mar 20 04:14:54 u1458 kernel: ? __schedule+0x2ca/0x6e0
Mar 20 04:14:54 u1458 kernel: schedule+0x4a/0xb0
Mar 20 04:14:54 u1458 kernel: schedule_preempt_disabled+0xa/0x10
Mar 20 04:14:54 u1458 kernel: __mutex_lock.isra.11+0x233/0x4e0
Mar 20 04:14:54 u1458 kernel: ? igb_watchdog_task+0x2ef/0x770 [igb]
Mar 20 04:14:54 u1458 kernel: linkwatch_event+0xa/0x30
Mar 20 04:14:54 u1458 kernel: process_one_work+0x172/0x380
Mar 20 04:14:54 u1458 kernel: worker_thread+0x49/0x3f0
Mar 20 04:14:54 u1458 kernel: kthread+0xf8/0x130
Mar 20 04:14:54 u1458 kernel: ? max_active_store+0x80/0x80
Mar 20 04:14:54 u1458 kernel: ? kthread_bind+0x10/0x10
Mar 20 04:14:54 u1458 kernel: ret_from_fork+0x35/0x40
Mar 20 04:14:54 u1458 kernel: INFO: task kworker/1:1:174 blocked for more than 122 seconds.
Mar 20 04:14:54 u1458 kernel:      Not tainted 5.6.0-rc5_next-queue_dev-queue_a601740+ #24
Mar 20 04:14:54 u1458 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 20 04:14:54 u1458 kernel: kworker/1:1     D    0   174      2 0x80004000
Mar 20 04:14:54 u1458 kernel: Workqueue: ipv6_addrconf addrconf_dad_work
Mar 20 04:14:54 u1458 kernel: Call Trace:
Mar 20 04:14:54 u1458 kernel: ? __schedule+0x2ca/0x6e0
Mar 20 04:14:54 u1458 kernel: schedule+0x4a/0xb0
Mar 20 04:14:54 u1458 kernel: schedule_preempt_disabled+0xa/0x10
Mar 20 04:14:54 u1458 kernel: __mutex_lock.isra.11+0x233/0x4e0
Mar 20 04:14:54 u1458 kernel: ? __switch_to_asm+0x40/0x70
Mar 20 04:14:54 u1458 kernel: ? __switch_to_asm+0x40/0x70
Mar 20 04:14:54 u1458 kernel: ? __switch_to_asm+0x34/0x70
Mar 20 04:14:54 u1458 kernel: addrconf_dad_work+0x3e/0x5b0
Mar 20 04:14:54 u1458 kernel: ? __switch_to+0x7a/0x3e0
Mar 20 04:14:54 u1458 kernel: ? __switch_to_asm+0x34/0x70
Mar 20 04:14:54 u1458 kernel: process_one_work+0x172/0x380
Mar 20 04:14:54 u1458 kernel: worker_thread+0x49/0x3f0
Mar 20 04:14:54 u1458 kernel: kthread+0xf8/0x130
Mar 20 04:14:54 u1458 kernel: ? max_active_store+0x80/0x80
Mar 20 04:14:54 u1458 kernel: ? kthread_bind+0x10/0x10
Mar 20 04:14:54 u1458 kernel: ret_from_fork+0x35/0x40
Mar 20 04:14:54 u1458 kernel: INFO: task kworker/2:1:5008 blocked for more than 122 seconds.
Mar 20 04:14:54 u1458 kernel:      Not tainted 5.6.0-rc5_next-queue_dev-queue_a601740+ #24
Mar 20 04:14:54 u1458 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 20 04:14:54 u1458 kernel: kworker/2:1     D    0  5008      2 0x80004000
Mar 20 04:14:54 u1458 kernel: Workqueue: ipv6_addrconf addrconf_dad_work
Mar 20 04:14:54 u1458 kernel: Call Trace:
Mar 20 04:14:54 u1458 kernel: ? __schedule+0x2ca/0x6e0
Mar 20 04:14:54 u1458 kernel: schedule+0x4a/0xb0
Mar 20 04:14:54 u1458 kernel: schedule_preempt_disabled+0xa/0x10
Mar 20 04:14:54 u1458 kernel: __mutex_lock.isra.11+0x233/0x4e0
Mar 20 04:14:54 u1458 kernel: ? __switch_to_asm+0x40/0x70
Mar 20 04:14:54 u1458 kernel: ? __switch_to_asm+0x40/0x70
Mar 20 04:14:54 u1458 kernel: ? __switch_to_asm+0x34/0x70
Mar 20 04:14:54 u1458 kernel: addrconf_dad_work+0x3e/0x5b0
Mar 20 04:14:54 u1458 kernel: ? __switch_to+0x7a/0x3e0
Mar 20 04:14:54 u1458 kernel: ? __switch_to_asm+0x34/0x70
Mar 20 04:14:54 u1458 kernel: process_one_work+0x172/0x380
Mar 20 04:14:54 u1458 kernel: worker_thread+0x49/0x3f0
Mar 20 04:14:54 u1458 kernel: kthread+0xf8/0x130
Mar 20 04:14:54 u1458 kernel: ? max_active_store+0x80/0x80
Mar 20 04:14:54 u1458 kernel: ? kthread_bind+0x10/0x10
Mar 20 04:14:54 u1458 kernel: ret_from_fork+0x35/0x40
Mar 20 04:14:54 u1458 kernel: INFO: task rmmod:5322 blocked for more than 122 seconds.
Mar 20 04:14:54 u1458 kernel:      Not tainted 5.6.0-rc5_next-queue_dev-queue_a601740+ #24
Mar 20 04:14:54 u1458 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 20 04:14:54 u1458 kernel: rmmod           D    0  5322   4580 0x00004000
Mar 20 04:14:54 u1458 kernel: Call Trace:
Mar 20 04:14:54 u1458 kernel: ? __schedule+0x2ca/0x6e0
Mar 20 04:14:54 u1458 kernel: schedule+0x4a/0xb0
Mar 20 04:14:54 u1458 kernel: schedule_preempt_disabled+0xa/0x10
Mar 20 04:14:54 u1458 kernel: __mutex_lock.isra.11+0x233/0x4e0
Mar 20 04:14:54 u1458 kernel: igb_close+0x22/0x60 [igb]
Mar 20 04:14:54 u1458 kernel: __dev_close_many+0x96/0x100
Mar 20 04:14:54 u1458 kernel: dev_close_many+0x96/0x150
Mar 20 04:14:54 u1458 kernel: rollback_registered_many+0x140/0x530
Mar 20 04:14:54 u1458 kernel: rollback_registered+0x56/0x90
Mar 20 04:14:54 u1458 kernel: unregister_netdevice_queue+0x7e/0x100
Mar 20 04:14:54 u1458 kernel: unregister_netdev+0x18/0x20
Mar 20 04:14:54 u1458 kernel: igb_remove+0xa3/0x160 [igb]
Mar 20 04:14:54 u1458 kernel: pci_device_remove+0x3b/0xc0
Mar 20 04:14:54 u1458 kernel: device_release_driver_internal+0xec/0x1b0
Mar 20 04:14:54 u1458 kernel: driver_detach+0x46/0x90
Mar 20 04:14:54 u1458 kernel: bus_remove_driver+0x58/0xd0
Mar 20 04:14:54 u1458 kernel: pci_unregister_driver+0x26/0xa0
Mar 20 04:14:54 u1458 kernel: __x64_sys_delete_module+0x16c/0x260
Mar 20 04:14:54 u1458 kernel: ? exit_to_usermode_loop+0xa4/0xcf
Mar 20 04:14:54 u1458 kernel: do_syscall_64+0x5b/0x1d0
Mar 20 04:14:54 u1458 kernel: entry_SYSCALL_64_after_hwframe+0x44/0xa9
Mar 20 04:14:54 u1458 kernel: RIP: 0033:0x7f1aab487397
Mar 20 04:14:54 u1458 kernel: Code: Bad RIP value.
Mar 20 04:14:54 u1458 kernel: RSP: 002b:00007ffebcda13a8 EFLAGS: 00000202 ORIG_RAX: 00000000000000b0
Mar 20 04:14:54 u1458 kernel: RAX: ffffffffffffffda RBX: 000000000098e190 RCX: 00007f1aab487397
Mar 20 04:14:54 u1458 kernel: RDX: 00007f1aab4fbb20 RSI: 0000000000000800 RDI: 000000000098e1f8
Mar 20 04:14:54 u1458 kernel: RBP: 0000000000000000 R08: 00007f1aab750060 R09: 00007f1aab4fbb20
Mar 20 04:14:54 u1458 kernel: R10: 00007ffebcda0f70 R11: 0000000000000202 R12: 00007ffebcda2703
Mar 20 04:14:54 u1458 kernel: R13: 0000000000000000 R14: 000000000098e190 R15: 000000000098e010
-----------------------------------------------------------------------------------------------------

> > -----------------------------------------------------------------------------------------------
> --
> > ...
> > [   50.279436] usb usb3: root hub lost power or was reset
> > [   50.279437] usb usb4: root hub lost power or was reset
> > [   50.279491] sd 1:0:0:0: [sda] Starting disk
> > [   50.317691] ------------[ cut here ]------------
> > [   50.317692] RTNL: assertion failed at net/core/dev.c (2867)
> > [   50.317700] WARNING: CPU: 6 PID: 5287 at net/core/dev.c:2867
> netif_set_real_num_tx_queues+0x184/0x1a0
> > [   50.317701] Modules linked in: rfcomm xt_conntrack nf_conntrack
> nf_defrag_ipv6 nf_defrag_ipv4 ipt_REJECT nf_rej
> > ect_ipv4 nft_counter nft_compat nf_tables nfnetlink tun bridge stp llc cmac
> bnep iTCO_wdt intel_wmi_thunderbolt iT
> > CO_vendor_support mxm_wmi wmi_bmof x86_pkg_temp_thermal
> intel_powerclamp coretemp kvm_intel snd_hda_codec_hdmi kvm
> > snd_hda_codec_realtek irqbypass snd_hda_codec_generic ledtrig_audio btusb
> btrtl btbcm snd_hda_intel btintel snd_i
> > ntel_dspcfg snd_hda_codec bluetooth snd_hwdep snd_hda_core snd_seq
> crct10dif_pclmul crc32_pclmul joydev snd_seq_de
> > vice ghash_clmulni_intel intel_cstate snd_pcm mei_me intel_uncore snd_timer
> ecdh_generic snd ecc pcspkr mei rfkill
> > i2c_i801 soundcore intel_rapl_perf sg wmi acpi_pad intel_pmc_core nfsd
> auth_rpcgss nfs_acl lockd grace sunrpc ip_
> > tables xfs libcrc32c sr_mod sd_mod cdrom t10_pi i915 intel_gtt
> drm_kms_helper syscopyarea sysfillrect sysimgblt fb
> > _sys_fops cec drm igb ahci libahci e1000e libata crc32c_intel dca i2c_algo_bit
> video
> > [   50.317719] CPU: 6 PID: 5287 Comm: kworker/u24:17 Not tainted 5.6.0-
> rc2_next-queue_dev-queue_81b6341+ #5
> > [   50.317720] Hardware name: Gigabyte Technology Co., Ltd. Z370 AORUS
> Gaming 5/Z370 AORUS Gaming 5-CF, BIOS F6 04
> > /03/2018
> > [   50.317722] Workqueue: events_unbound async_run_entry_fn
> > [   50.317723] RIP: 0010:netif_set_real_num_tx_queues+0x184/0x1a0
> 
> I added some debug message and made sure the ASSERT_RTNL() was reached.
> However rtnl is locked for me.
> 
> > [   50.317724] Code: 43 1e e7 00 00 0f 85 fc fe ff ff ba 33 0b 00 00 48 c7 c6 92
> 57 9a bd 48 c7 c7 e0 a4 91 bd c6
> > 05 23 1e e7 00 01 e8 57 3c 97 ff <0f> 0b e9 d6 fe ff ff 41 be ea ff ff ff e9 a4 fe
> ff ff 66 2e 0f 1f
> > [   50.317724] RSP: 0018:ffffb57fc1347d38 EFLAGS: 00010282
> > [   50.317725] RAX: 0000000000000000 RBX: ffff995a9e3e4000 RCX:
> 0000000000000007
> > [   50.317725] RDX: 0000000000000007 RSI: 0000000000000002 RDI:
> ffff995abe398f40
> > [   50.317725] RBP: 0000000000000004 R08: 0000000000000002 R09:
> 000000000002b500
> > [   50.317726] R10: 0000003a9dc62fa1 R11: 0000000000fed278 R12:
> 0000000000000004
> > [   50.317726] R13: 0000000000000004 R14: ffff995a9e3e4000 R15:
> ffff995a9e3e4000
> > [   50.317727] FS:  0000000000000000(0000) GS:ffff995abe380000(0000)
> knlGS:0000000000000000
> > [   50.317727] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [   50.317727] CR2: 00007f4dbd7fae20 CR3: 0000000efbe0a004 CR4:
> 00000000003606e0
> > [   50.317728] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> > [   50.317728] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> > [   50.317728] Call Trace:
> > [   50.317734]  __igb_open+0x1ee/0x5c0 [igb]
> > [   50.317737]  igb_resume+0x193/0x1c0 [igb]
> > [   50.317739]  ? pci_pm_thaw+0x80/0x80
> 
> So this is hibernation instead of suspension. I tried both S3 and S4 and can't
> reproduce the issue.

I used rtc-wake with all the modes in /sys/power/state.  At the time I was thinking it was a good way to exercise various power states.
> 
> Kai-Heng
> 
> > [   50.317741]  dpm_run_callback+0x4f/0x140
> > [   50.317742]  device_resume+0x107/0x180
> > [   50.317743]  async_resume+0x19/0x50
> > [   50.317744]  async_run_entry_fn+0x39/0x160
> > [   50.317746]  process_one_work+0x1a7/0x370
> > [   50.317747]  worker_thread+0x30/0x380
> > [   50.317748]  ? process_one_work+0x370/0x370
> > [   50.317749]  kthread+0x10c/0x130
> > [   50.317750]  ? kthread_park+0x80/0x80
> > [   50.317751]  ret_from_fork+0x35/0x40
> > [   50.317752] ---[ end trace 45a9ec6b02347b6e ]---
> > [   50.317753] ------------[ cut here ]------------
> > [   50.317753] RTNL: assertion failed at net/core/dev.c (2913)
> > [   50.317756] WARNING: CPU: 6 PID: 5287 at net/core/dev.c:2913
> netif_set_real_num_rx_queues+0x79/0x80
> > [   50.317757] Modules linked in: rfcomm xt_conntrack nf_conntrack
> nf_defrag_ipv6 nf_defrag_ipv4 ipt_REJECT nf_rej
> > ect_ipv4 nft_counter nft_compat nf_tables nfnetlink tun bridge stp llc cmac
> bnep iTCO_wdt intel_wmi_thunderbolt iT
> > CO_vendor_support mxm_wmi wmi_bmof x86_pkg_temp_thermal
> intel_powerclamp coretemp kvm_intel snd_hda_codec_hdmi kvm
> > snd_hda_codec_realtek irqbypass snd_hda_codec_generic ledtrig_audio btusb
> btrtl btbcm snd_hda_intel btintel snd_i
> > ntel_dspcfg snd_hda_codec bluetooth snd_hwdep snd_hda_core snd_seq
> crct10dif_pclmul crc32_pclmul joydev snd_seq_de
> > vice ghash_clmulni_intel intel_cstate snd_pcm mei_me intel_uncore snd_timer
> ecdh_generic snd ecc pcspkr mei rfkill
> > i2c_i801 soundcore intel_rapl_perf sg wmi acpi_pad intel_pmc_core nfsd
> auth_rpcgss nfs_acl lockd grace sunrpc ip_
> > tables xfs libcrc32c sr_mod sd_mod cdrom t10_pi i915 intel_gtt
> drm_kms_helper syscopyarea sysfillrect sysimgblt fb
> > _sys_fops cec drm igb ahci libahci e1000e libata crc32c_intel dca i2c_algo_bit
> video
> > [   50.317766] CPU: 6 PID: 5287 Comm: kworker/u24:17 Tainted: G        W
> 5.6.0-rc2_next-queue_dev-queue_81
> > b6341+ #5
> > [   50.317766] Hardware name: Gigabyte Technology Co., Ltd. Z370 AORUS
> Gaming 5/Z370 AORUS Gaming 5-CF, BIOS F6 04
> > /03/2018
> > [   50.317767] Workqueue: events_unbound async_run_entry_fn
> > [   50.317768] RIP: 0010:netif_set_real_num_rx_queues+0x79/0x80
> > [   50.317768] Code: ff c3 80 3d 89 6c e7 00 00 75 db ba 61 0b 00 00 48 c7 c6
> 92 57 9a bd 48 c7 c7 e0 a4 91 bd c6
> > 05 6d 6c e7 00 01 e8 a2 8a 97 ff <0f> 0b eb b8 0f 1f 00 0f 1f 44 00 00 53 f0 48
> 0f ba af d8 00 00 00
> > [   50.317769] RSP: 0018:ffffb57fc1347d58 EFLAGS: 00010282
> > [   50.317769] RAX: 0000000000000000 RBX: ffff995a9e3e4000 RCX:
> 0000000000000007
> > [   50.317769] RDX: 0000000000000007 RSI: 0000000000000002 RDI:
> ffff995abe398f40
> > [   50.317770] RBP: 0000000000000004 R08: 0000000000000002 R09:
> 000000000002b500
> > [   50.317770] R10: 0000003a9dc92851 R11: 0000000000fec568 R12:
> 0000000000000000
> > [   50.317770] R13: 0000000000000001 R14: ffff995a9e3e4000 R15:
> ffff995a9e3e4000
> > [   50.317771] FS:  0000000000000000(0000) GS:ffff995abe380000(0000)
> knlGS:0000000000000000
> > [   50.317771] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [   50.317771] CR2: 00007f4dbd7fae20 CR3: 0000000efbe0a004 CR4:
> 00000000003606e0
> > [   50.317772] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> > [   50.317772] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> > [   50.317772] Call Trace:
> > [   50.317775]  __igb_open+0x208/0x5c0 [igb]
> > [   50.317777]  igb_resume+0x193/0x1c0 [igb]
> > [   50.317777]  ? pci_pm_thaw+0x80/0x80
> > [   50.317778]  dpm_run_callback+0x4f/0x140
> > [   50.317779]  device_resume+0x107/0x180
> > [   50.317780]  async_resume+0x19/0x50
> > [   50.317781]  async_run_entry_fn+0x39/0x160
> > [   50.317782]  process_one_work+0x1a7/0x370
> > [   50.317783]  worker_thread+0x30/0x380
> > [   50.317784]  ? process_one_work+0x370/0x370
> > [   50.317785]  kthread+0x10c/0x130
> > [   50.317785]  ? kthread_park+0x80/0x80
> > [   50.317786]  ret_from_fork+0x35/0x40
> > [   50.317787] ---[ end trace 45a9ec6b02347b6f ]---
> > [   50.560158] OOM killer enabled.
> > [   50.560158] Restarting tasks ... done.
> > [   50.560713] video LNXVIDEO:00: Restoring backlight state
> > [   50.560714] PM: suspend exit
> > [   50.601179] ata5: SATA link down (SStatus 4 SControl 300)
> > [   50.601201] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> > ...

