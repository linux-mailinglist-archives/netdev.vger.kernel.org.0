Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC7AB58AA13
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 13:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240614AbiHELZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 07:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240606AbiHELZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 07:25:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78ABBF26
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 04:25:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 250BDB82884
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 11:25:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A84C433D6;
        Fri,  5 Aug 2022 11:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659698713;
        bh=KmJe2qnqGyoOeiAUg0mt7Tfq1iwsWa5Ik7kNc1FSwGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jP3SFGjpiKDYr5Ol6KP/IzgbS3NrexKwGRq84KeOXNGiGqoifnPy3cZKN2raB7I0G
         YGgYLZbCJdjgEyZ9tAtgfkNObaAgGVxOgbYkM7ZzFk2Sy9bUMaxHMEfe02toVYR2bZ
         1mA2U8ll+X5n5Mp3oW5BEIuHvtX0nkBWHtfA+N4qje4iHaZvuSD5sQQ2dcB+7VfN8S
         Ti7jS1lRf+nndY/uk+j+UEUatzeTmsR3+pv9qb9mNh3qvmyu9OSVt/oquxMhtQYV7p
         e9dLHJprBTiStWtHRjJyvwJQDqGWLnKPjkdR3hSwAxkh4DOusen8AzMOvcNmHUPY5P
         zf1ZWqiOM2UwQ==
From:   James Hogan <jhogan@kernel.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Sasha Neftin <sasha.neftin@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org
Subject: Re: [Intel-wired-lan] I225-V (igc driver) hangs after resume in igc_resume/igc_tsn_reset
Date:   Fri, 05 Aug 2022 12:25:05 +0100
Message-ID: <4765029.31r3eYUQgx@saruman>
In-Reply-To: <3514132.R56niFO833@saruman>
References: <4752347.31r3eYUQgx@saruman> <1838555.CQOukoFCf9@saruman> <3514132.R56niFO833@saruman>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday, 4 August 2022 23:07:34 BST James Hogan wrote:
> And I just found this patch from December which may have been masked by the
> PTM issues:
> https://lore.kernel.org/netdev/20211201185731.236130-1-vinicius.gomes@intel.
> com/
> 
> I'll build and run with that for a few days and see how it goes.

I gave it a good hammering yesterday evening with suspend/resume cycles, and
it didn't lock up, however it did still fail to bring the network up a couple
of times, requiring me to unload and reload the driver.

The only kernel log splats I saw were an assert that RTNL mutex wasn't taken
in the igc_runtime_resume path, and a suspicious RCU usage warning, both
pasted below.

I'll keep running with that patch and lockdep enabled (based on
5.18.16-arch1-1) and report back any further issues.

Cheers
James

------------[ cut here ]------------
RTNL: assertion failed at net/core/dev.c (2886)
WARNING: CPU: 0 PID: 7752 at net/core/dev.c:2886 netif_set_real_num_tx_queues+0x1f0/0x210
Modules linked in: rfcomm intel_rapl_msr ee1004 spi_nor iTCO_wdt intel_pmc_bxt mtd iTCO_vendor_support mei_pxp mei_hdcp cmac algif_hash algif_skcipher af_alg bnep pmt_telemetry pmt_class wmi_bmof mxm_wmi intel_rapl_common intel_tcc_cooling x86_pkg_temp_thermal intel_powerclamp kvm_intel kvm irqbypass rapl intel_cstate intel_uncore pcspkr snd_sof_pci_intel_tgl snd_sof_intel_hda_common soundwire_intel soundwire_generic_allocation soundwire_cadence snd_sof_intel_hda snd_sof_pci snd_sof_xtensa_dsp snd_sof snd_hda_codec_realtek snd_sof_utils snd_soc_hdac_hda snd_hda_codec_generic snd_hda_ext_core snd_soc_acpi_intel_match snd_soc_acpi soundwire_bus ledtrig_audio uvcvideo snd_usb_audio snd_soc_core videobuf2_vmalloc videobuf2_memops snd_usbmidi_lib videobuf2_v4l2 snd_compress i2c_i801 snd_rawmidi spi_intel_pci ac97_bus igc(-) spi_intel videobuf2_common snd_pcm_dmaengine i2c_smbus snd_seq_device mei_me snd_hda_codec_hdmi mei cdc_acm videodev snd_hda_intel snd_intel_dspcfg
 snd_intel_sdw_acpi mc amdgpu mousedev i915 snd_hda_codec snd_hda_core btusb snd_hwdep btrtl snd_pcm btbcm gpu_sched drm_buddy joydev btintel snd_timer drm_ttm_helper btmtk snd ttm intel_vsec drm_dp_helper soundcore intel_gtt serial_multi_instantiate wmi video bluetooth ecdh_generic acpi_tad rfkill coretemp acpi_pad nls_iso8859_1 vfat fat mac_hid ip6t_REJECT nf_reject_ipv6 xt_hl ip6t_rt ipt_REJECT nf_reject_ipv4 xt_LOG nf_log_syslog xt_multiport xt_limit xt_addrtype xt_tcpudp xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c ip6table_filter ip6_tables iptable_filter i2c_dev sg crypto_user fuse bpf_preload ip_tables x_tables ext4 crc32c_generic crc16 mbcache jbd2 hid_microsoft ff_memless dm_crypt cbc encrypted_keys trusted asn1_encoder tee tpm rng_core dm_mod usbhid crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel crypto_simd nvme cryptd sr_mod xhci_pci nvme_core cdrom xhci_pci_renesas
CPU: 0 PID: 7752 Comm: kworker/0:1 Not tainted 5.18.16-arch1-1 #3 2927cbed739f932be66f137e6808a2714da26c25
Hardware name: Micro-Star International Co., Ltd. MS-7D25/PRO Z690-A DDR4(MS-7D25), BIOS 1.40 05/17/2022
Workqueue: pm pm_runtime_work
RIP: 0010:netif_set_real_num_tx_queues+0x1f0/0x210
Code: f8 f7 5f 01 00 0f 85 90 fe ff ff ba 46 0b 00 00 48 c7 c6 6e 6e 6f 82 48 c7 c7 70 a5 72 82 c6 05 d8 f7 5f 01 01 e8 1f d6 25 00 <0f> 0b e9 6a fe ff ff b8 ea ff ff ff e9 46 fe ff ff 66 66 2e 0f 1f
RSP: 0018:ffffa25e823dbc98 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff95a5668fa000 RCX: 0000000000000027
RDX: ffff95accfc21a28 RSI: 0000000000000001 RDI: ffff95accfc21a20
RBP: 0000000000000004 R08: 0000000000000000 R09: ffffa25e823dbaa0
R10: 0000000000000003 R11: ffff95acf07ac2e8 R12: 0000000000000001
R13: 0000000000000004 R14: ffff95a5668fa000 R15: ffff95a5691bc1e8
FS:  0000000000000000(0000) GS:ffff95accfc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007feec86e5c90 CR3: 0000000252fdc001 CR4: 0000000000f70ef0
PKRU: 55555554
Call Trace:
 <TASK>
 __igc_open+0x40a/0x660 [igc 73e11f9f5110389b26a5a274cff80c9ddf9bab7a]
 __igc_resume+0x133/0x240 [igc 73e11f9f5110389b26a5a274cff80c9ddf9bab7a]
 ? pci_pme_active+0xa5/0x1a0
 pci_pm_runtime_resume+0xab/0xd0
 ? pci_pm_freeze_noirq+0xf0/0xf0
 __rpm_callback+0x41/0x170
 rpm_callback+0x35/0x70
 ? pci_pm_freeze_noirq+0xf0/0xf0
 rpm_resume+0x5ee/0x820
 pm_runtime_work+0x7c/0xb0
 process_one_work+0x276/0x570
 worker_thread+0x53/0x390
 ? _raw_spin_unlock_irqrestore+0x34/0x60
 ? process_one_work+0x570/0x570
 kthread+0xdb/0x110
 ? kthread_complete_and_exit+0x20/0x20
 ret_from_fork+0x1f/0x30
 </TASK>
irq event stamp: 128847
hardirqs last  enabled at (128853): [<ffffffff81132dde>] __up_console_sem+0x5e/0x70
hardirqs last disabled at (128858): [<ffffffff81132dc3>] __up_console_sem+0x43/0x70
softirqs last  enabled at (125404): [<ffffffff810a5533>] __irq_exit_rcu+0xa3/0xd0
softirqs last disabled at (125395): [<ffffffff810a5533>] __irq_exit_rcu+0xa3/0xd0
---[ end trace 0000000000000000 ]---

=============================
WARNING: suspicious RCU usage
5.18.16-arch1-1 #3 Tainted: G        W   
-----------------------------
net/sched/sch_generic.c:1389 suspicious rcu_dereference_protected() usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1 
2 locks held by kworker/0:1/7752:
 #0: ffff95a540ba8b38 ((wq_completion)pm){+.+.}-{0:0}, at: process_one_work+0x1f5/0x570
 #1: ffffa25e823dbe78 ((work_completion)(&dev->power.work)){+.+.}-{0:0}, at: process_one_work+0x1f5/0x570

stack backtrace:
CPU: 0 PID: 7752 Comm: kworker/0:1 Tainted: G        W         5.18.16-arch1-1 #3 2927cbed739f932be66f137e6808a2714da26c25
Hardware name: Micro-Star International Co., Ltd. MS-7D25/PRO Z690-A DDR4(MS-7D25), BIOS 1.40 05/17/2022
Workqueue: pm pm_runtime_work
Call Trace:
 <TASK>
 dump_stack_lvl+0x5f/0x7b
 dev_qdisc_change_real_num_tx+0x68/0x80
 netif_set_real_num_tx_queues+0x8d/0x210
 __igc_open+0x40a/0x660 [igc 73e11f9f5110389b26a5a274cff80c9ddf9bab7a]
 __igc_resume+0x133/0x240 [igc 73e11f9f5110389b26a5a274cff80c9ddf9bab7a]
 ? pci_pme_active+0xa5/0x1a0
 pci_pm_runtime_resume+0xab/0xd0
 ? pci_pm_freeze_noirq+0xf0/0xf0
 __rpm_callback+0x41/0x170
 rpm_callback+0x35/0x70
 ? pci_pm_freeze_noirq+0xf0/0xf0
 rpm_resume+0x5ee/0x820
 pm_runtime_work+0x7c/0xb0
 process_one_work+0x276/0x570
 worker_thread+0x53/0x390
 ? _raw_spin_unlock_irqrestore+0x34/0x60
 ? process_one_work+0x570/0x570
 kthread+0xdb/0x110
 ? kthread_complete_and_exit+0x20/0x20
 ret_from_fork+0x1f/0x30
 </TASK>


