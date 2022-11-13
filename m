Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24515626E7D
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 09:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235203AbiKMIWR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 13 Nov 2022 03:22:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbiKMIWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 03:22:16 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C727D106;
        Sun, 13 Nov 2022 00:22:14 -0800 (PST)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1ou8Fo-0007QA-6g; Sun, 13 Nov 2022 09:22:12 +0100
Message-ID: <83b28e2d-7af7-f91a-7e67-7f224bcf0557@leemhuis.info>
Date:   Sun, 13 Nov 2022 09:22:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Content-Language: en-US, de-DE
From:   Thorsten Leemhuis <regressions@leemhuis.info>
Subject: [Regression] Bug 216672 - soft lockup in ieee80211_select_queue --
 system freezing random time on msi laptop
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, misac1987@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1668327734;a3404831;
X-HE-SMSGID: 1ou8Fo-0007QA-6g
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, this is your Linux kernel regression tracker speaking.

I noticed a slightly vague regression report in bugzilla.kernel.org. As
many (most?) kernel developer don't keep an eye on it, I decided to
forward it by mail. Quoting from
https://bugzilla.kernel.org/show_bug.cgi?id=216672 :

>  misac1987@gmail.com 2022-11-08 17:14:07 UTC
> 
> ─$ uname -a
> Linux MSI-CR61-3M 6.0.6-060006-generic #202210290932 SMP PREEMPT_DYNAMIC Sat Oct 29 09:37:56 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
> 
> dmesg log
> 
> Nov  8 19:31:24 MSI-CR61-3M kernel: [   21.272059] Bluetooth: RFCOMM TTY layer initialized
> Nov  8 19:31:24 MSI-CR61-3M kernel: [   21.272103] Bluetooth: RFCOMM socket layer initialized
> Nov  8 19:31:24 MSI-CR61-3M kernel: [   21.272140] Bluetooth: RFCOMM ver 1.11
> Nov  8 19:31:27 MSI-CR61-3M kernel: [   24.797928] rfkill: input handler disabled
> Nov  8 19:31:37 MSI-CR61-3M kernel: [   34.430707] rfkill: input handler enabled
> Nov  8 19:31:46 MSI-CR61-3M kernel: [   43.680775] rfkill: input handler disabled
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.479443] watchdog: BUG: soft lockup - CPU#1 stuck for 26s! [ksoftirqd/1:23]
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.479464] Modules linked in: rfcomm snd_seq_dummy snd_hrtimer xt_CHECKSUM xt_MASQUERADE ccm nft_chain_nat nf_nat bridge stp llc amdgpu iommu_v2 gpu_sched drm_buddy ip6t_REJECT nf_reject_ipv6 cmac xt_hl ip6_tables algif_hash ip6t_rt algif_skcipher ipt_REJECT nf_reject_ipv4 af_alg xt_comment bnep xt_multiport nft_limit snd_hda_codec_realtek xt_limit xt_addrtype xt_tcpudp snd_hda_codec_generic amd_freq_sensitivity snd_hda_codec_hdmi ledtrig_audio xt_conntrack edac_mce_amd snd_hda_intel nf_conntrack crct10dif_pclmul nf_defrag_ipv6 snd_intel_dspcfg polyval_clmulni kvm_amd ccp nf_defrag_ipv4 nft_compat snd_intel_sdw_acpi polyval_generic kvm nf_tables ghash_clmulni_intel snd_hda_codec nfnetlink aesni_intel snd_hda_core btusb nls_iso8859_1 rtl8723ae crypto_simd cryptd psmouse btrtl btcoexist serio_raw msi_wmi radeon snd_hwdep btbcm sparse_keymap btintel rtl8723_common snd_pcm btmtk joydev input_leds rtl_pci drm_ttm_helper snd_seq_midi bluetooth rtlwifi snd_seq_midi_event ttm ecdh_generic ecc
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.479669]  fam15h_power k10temp drm_display_helper snd_rawmidi mac80211 snd_seq snd_seq_device snd_timer cec rc_core cfg80211 drm_kms_helper snd i2c_algo_bit fb_sys_fops mac_hid libarc4 syscopyarea soundcore sysfillrect sysimgblt msr parport_pc ppdev lp parport ramoops reed_solomon pstore_blk pstore_zone drm mtd efi_pstore ip_tables x_tables autofs4 btrfs blake2b_generic xor raid6_pq zstd_compress libcrc32c hid_generic usbhid hid sdhci_pci cqhci ahci crc32_pclmul alx sdhci i2c_piix4 libahci xhci_pci xhci_pci_renesas mdio wmi video
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.479808] CPU: 1 PID: 23 Comm: ksoftirqd/1 Not tainted 6.0.6-060006-generic #202210290932
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.479817] Hardware name: Micro-Star International Co., Ltd. CR61 3M/MS-16GP, BIOS E16GPAMS.10A 11/25/2013
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.479822] RIP: 0010:ieee80211_select_queue+0x1b/0x110 [mac80211]
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.479982] Code: 31 ff e9 48 cf ca d6 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 8b 87 88 07 00 00 48 8b 90 c0 01 00 00 48 83 ba e0 02 00 00 00 <74> 0d 31 c0 31 d2 31 f6 31 ff e9 16 cf ca d6 55 48 89 e5 41 54 49
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.479989] RSP: 0018:ffffb35d8010b5b0 EFLAGS: 00000246
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.479996] RAX: ffff96c14aee08e0 RBX: ffff96c14c810000 RCX: 0000000000000000
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480001] RDX: ffffffffc0f755a0 RSI: ffff96c0423eb100 RDI: ffff96c14c8109c0
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480005] RBP: ffffb35d8010b5b8 R08: 0000000000000000 R09: 0000000000000000
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480010] R10: 0000000000000000 R11: 0000000000000000 R12: ffff96c0423eb100
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480013] R13: ffff96c14c810000 R14: 0000000000000000 R15: 0000000000000010
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480018] FS:  0000000000000000(0000) GS:ffff96c277480000(0000) knlGS:0000000000000000
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480024] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480028] CR2: 000055f37b7070ac CR3: 00000001108aa000 CR4: 00000000000406e0
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480034] Call Trace:
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480038]  <TASK>
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480042]  ? ieee80211_netdev_select_queue+0x15/0x20 [mac80211]
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480163]  netdev_core_pick_tx+0x58/0xc0
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480176]  __dev_queue_xmit+0xf2/0x6d0
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480187]  neigh_hh_output+0x93/0x110
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480195]  ip_finish_output2+0x1ea/0x490
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480203]  __ip_finish_output+0xb6/0x180
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480211]  ip_finish_output+0x2d/0xe0
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480218]  ip_output+0x73/0x120
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480224]  ? __ip_finish_output+0x180/0x180
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480231]  ip_push_pending_frames+0xbb/0xd0
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480238]  ip_send_unicast_reply+0x357/0x490
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480244]  ? nft_counter_eval+0x54/0x70 [nf_tables]
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480286]  tcp_v4_send_reset+0x3ad/0x840
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480295]  ? tcp_v4_send_reset+0x3ad/0x840
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480307]  tcp_v4_rcv+0x9dd/0xee0
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480314]  ? tcp_v4_rcv+0x9dd/0xee0
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480323]  ip_protocol_deliver_rcu+0x3c/0x2b0
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480332]  ? ipv4_confirm+0x5f/0xf0 [nf_conntrack]
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480365]  ip_local_deliver_finish+0x77/0xa0
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480374]  ip_local_deliver+0x6e/0x120
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480382]  ? ip_protocol_deliver_rcu+0x2b0/0x2b0
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480391]  ip_rcv+0x177/0x1a0
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480398]  ? ip_sublist_rcv+0x220/0x220
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480407]  __netif_receive_skb_core.constprop.0+0x4f4/0xd20
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480419]  __netif_receive_skb_list_core+0xfd/0x250
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480427]  netif_receive_skb_list_internal+0x1a3/0x2d0
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480436]  netif_receive_skb_list+0x25/0xe0
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480442]  ieee80211_rx_napi+0xc2/0xd0 [mac80211]
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480564]  ieee80211_tasklet_handler+0xc9/0xd0 [mac80211]
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480673]  tasklet_action_common.constprop.0+0xd5/0x100
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480683]  tasklet_action+0x22/0x30
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480688]  __do_softirq+0xdd/0x34f
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480698]  ? find_next_bit+0x30/0x30
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480705]  run_ksoftirqd+0x37/0x60
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480711]  smpboot_thread_fn+0xe3/0x1e0
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480719]  kthread+0xe9/0x110
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480727]  ? kthread_complete_and_exit+0x20/0x20
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480735]  ret_from_fork+0x22/0x30
> Nov  8 19:38:07 MSI-CR61-3M kernel: [  424.480747]  </TASK>
> Nov  8 19:38:22 MSI-CR61-3M kernel: [  439.491084] rfkill: input handler enabled

See the ticket for more details.

BTW, let me use this mail to also add the report to the list of tracked
regressions to ensure it's doesn't fall through the cracks:

#regzbot introduced: v5.19..v6.0
https://bugzilla.kernel.org/show_bug.cgi?id=216672
#regzbot ignore-activity

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I deal with a lot of
reports and sometimes miss something important when writing mails like
this. If that's the case here, don't hesitate to tell me in a public
reply, it's in everyone's interest to set the public record straight.
