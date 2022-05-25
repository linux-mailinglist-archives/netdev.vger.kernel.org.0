Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 033C5533DEA
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 15:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233387AbiEYNeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 09:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiEYNeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 09:34:04 -0400
Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7AF4E391
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 06:34:02 -0700 (PDT)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.67.129])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 405721A0073
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 13:34:01 +0000 (UTC)
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 12345500066
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 13:34:01 +0000 (UTC)
Received: from [192.168.1.115] (unknown [98.97.39.238])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 69FAE13C2B0
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 06:34:00 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 69FAE13C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1653485640;
        bh=44GwjZl+edhlMp2iBYua/asGpY32WpDR74NIeplhbo4=;
        h=To:From:Subject:Date:From;
        b=ZhNYdYTea7Txh/ccCoyGZLFiHX7WAcCHkT6JfSRpA2ljfpZqo3qtVV4Zf6Tv66hTw
         SaKKXM9aGdI5A44jZLPT7Sj/xBxVlwOw24TPdicqnkW9UEIWUM7GBzjN8qGyO3hi6f
         ubL/RdLqTZu8AxqcKSA7rnt35ASaqxKNKbZO9xrw=
To:     netdev <netdev@vger.kernel.org>
From:   Ben Greear <greearb@candelatech.com>
Subject: 5.17.8+ crash in tcp_enter_loss
Organization: Candela Technologies
Message-ID: <2aa966eb-1a7e-76ea-9e1a-5571ab49d9e9@candelatech.com>
Date:   Wed, 25 May 2022 06:33:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
X-MDID: 1653485641-ZQCdaCG4dumv
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I believe I have hit this several times in the past few days, though finally I caught it in serial
console logs.  It happens during TCP test across a wifi mesh using iwlwifi driver, though I am
not sure the driver really has anything to do with it.  Maybe just the 2-hop mesh has more than normal
jitter and pkt loss and latency.  I don't think I have hit this in 5.17.4 or earlier kernels, but
also, I haven't been running this particular test case on older kernels.

BUG: kernel NULL pointer dereference, address: 0000000000000085
2477 #PF: supervisor read access in kernel mode
2478 #PF: error_code(0x0000) - not-present page
2479 PGD 0 P4D 0
2480 Oops: 0000 [#1] PREEMPT SMP
2481 CPU: 4 PID: 0 Comm: swapper/4 Not tainted 5.17.8+ #34
2482 Hardware name: Default string Default string/SKYBAY, BIOS 5.12 02/19/2019
2483 RIP: 0010:rb_next+0x14/0x50
2484 Code: ff 48 c7 07 01 00 00 00 c3 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 8b 17 48 39 d7 74 35 48 8b 47 08 48 85 c0 74 1c 49 89 c0 <48> 8b 40 10 48 85 c0 
75       f4 4c 89 c0 c3 48 3b 78 08 75 f6 48 8b 10
2485 RSP: 0018:ffffc900001ccdd8 EFLAGS: 00010202
2486 RAX: 0000000000000075 RBX: 0000000000000000 RCX: 00000010b35897fe
2487 RDX: ffff888149940800 RSI: 000000000002c742 RDI: ffff888149943200
2488 RBP: ffff888149943200 R08: 0000000000000075 R09: 0000000000000000
2489 R10: 0000000000000002 R11: 000000000000005a R12: ffff88814da96000
2490 R13: 0000000000000000 R14: ffffffff831f1100 R15: ffff888145e8e040
2491 FS:  0000000000000000(0000) GS:ffff88845dd00000(0000) knlGS:0000000000000000
2492 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
2493 CR2: 0000000000000085 CR3: 000000000280f001 CR4: 00000000003706e0
2494 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
2495 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
2496 Call Trace:
2497  <IRQ>
2498  tcp_enter_loss+0xc5/0x360
2499  tcp_retransmit_timer+0x376/0x9d0
2500  ? check_preempt_curr+0x2a/0x60
2501  ? tcp_write_timer_handler+0x270/0x270
2502  tcp_write_timer_handler+0x1b6/0x270
2503  tcp_write_timer+0x90/0xd0
2504  ? tcp_write_timer_handler+0x270/0x270
2505  call_timer_fn+0x1f/0x120
2506  __run_timers.part.0+0x1ce/0x270
2507  ? __hrtimer_run_queues+0x131/0x2c0
2508  ? ktime_get+0x30/0x90
2509  run_timer_softirq+0x21/0x50
2510  __do_softirq+0xbc/0x290
2511  __irq_exit_rcu+0x68/0x80
2512  sysvec_apic_timer_interrupt+0x72/0x90
2513  </IRQ>
2514  <TASK>
2515  asm_sysvec_apic_timer_interrupt+0x12/0x20
2516 RIP: 0010:cpuidle_enter_state+0xd0/0x360
2517 Code: 31 ff e8 53 f9 80 ff 45 84 ff 74 17 9c 58 0f 1f 44 00 00 f6 c4 02 0f 85 77 02 00 00 31 ff e8 b7 3e 87 ff fb 66 0f 1f 44 00 00 <45> 85 f6 0f 88 11 01 
00       00 49 63 d6 4c 2b 2c 24 48 8d 04 52 48 8d
2518 RSP: 0018:ffffc900000ffea8 EFLAGS: 00000246
2519 RAX: ffff88845dd2c800 RBX: 0000000000000006 RCX: 000000000000001f
2520 RDX: 0000000000000000 RSI: 000000002c13c01d RDI: 0000000000000000
2521 RBP: ffff88845dd36550 R08: 0000413c9a77c269 R09: 0000000000000001
2522 R10: 0000000000009bd3 R11: 0000000000002c87 R12: ffffffff829bacc0
2523 R13: 0000413c9a77c269 R14: 0000000000000006 R15: 0000000000000000
524  ? cpuidle_enter_state+0xad/0x360
2525  cpuidle_enter+0x24/0x40
2526  do_idle+0x1d7/0x250
2527  cpu_startup_entry+0x14/0x20
2528  secondary_startup_64_no_verify+0xc3/0xcb
2529  </TASK>
2530 Modules linked in: nf_conntrack_netlink nf_conntrack nfnetlink vrf nf_defrag_ipv6 nf_defrag_ipv4 bpfilter 8021q garp mrp stp llc macvlan pktgen 
          snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ledtrig_audio snd_hda_intel coretemp snd_intel_dspcfg intel_rapl_msr intel_rapl_common 
               snd_hda_codec iwlmvm snd_hda_core snd_hwdep mac80211 snd_seq snd_seq_device snd_pcm iTCO_wdt iwlwifi intel_pmc_bxt iwlmei snd_timer 
intel_tcc_cooling ee1004        iTCO_vendor_support snd x86_pkg_temp_thermal i2c_i801 soundcore intel_powerclamp i2c_smbus intel_wmi_thunderbolt cfg80211 
mei_hdcp mei_pxp mei_wdt                  intel_pch_thermal acpi_pad nfsd auth_rpcgss nfs_acl lockd grace sch_fq_codel sunrpc raid1 dm_raid raid456 libcrc32c 
async_raid6_recov async_memcpy async_pq         async_xor async_tx raid6_pq i915 intel_gtt drm_kms_helper cec rc_core ttm igb i2c_algo_bit drm ixgbe agpgart 
mdio hwmon xhci_pci i2c_core xhci_pci_renesas dca      wmi video fuse [last unloaded: nfnetlink]
2531 CR2: 0000000000000085
2532 ---[ end trace 0000000000000000 ]---
2533 RIP: 0010:rb_next+0x14/0x50
2534 Code: ff 48 c7 07 01 00 00 00 c3 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 8b 17 48 39 d7 74 35 48 8b 47 08 48 85 c0 74 1c 49 89 c0 <48> 8b 40 10 48 85 c0 
75       f4 4c 89 c0 c3 48 3b 78 08 75 f6 48 8b 10
2535 RSP: 0018:ffffc900001ccdd8 EFLAGS: 00010202
2536 RAX: 0000000000000075 RBX: 0000000000000000 RCX: 00000010b35897fe
2537 RDX: ffff888149940800 RSI: 000000000002c742 RDI: ffff888149943200
2538 RBP: ffff888149943200 R08: 0000000000000075 R09: 0000000000000000
2539 R10: 0000000000000002 R11: 000000000000005a R12: ffff88814da96000
2540 R13: 0000000000000000 R14: ffffffff831f1100 R15: ffff888145e8e040
2541 FS:  0000000000000000(0000) GS:ffff88845dd00000(0000) knlGS:0000000000000000
2542 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
2543 CR2: 0000000000000085 CR3: 000000000280f001 CR4: 00000000003706e0
2544 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
2545 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
2546 Kernel panic - not syncing: Fatal exception in interrupt
2547 Kernel Offset: disabled
2548 Rebooting in 10 seconds..

(gdb) l *(tcp_enter_loss+0xc5)
0xffffffff81ac8df5 is in tcp_enter_loss (/home/greearb/git/linux-5.17.dev.y/net/ipv4/tcp_input.c:2123).
2118		} else if (tcp_is_reno(tp)) {
2119			tcp_reset_reno_sack(tp);
2120		}
2121	
2122		skb = head;
2123		skb_rbtree_walk_from(skb) {
2124			if (is_reneg)
2125				TCP_SKB_CB(skb)->sacked &= ~TCPCB_SACKED_ACKED;
2126			else if (tcp_is_rack(sk) && skb != head &&
2127				 tcp_rack_skb_timeout(tp, skb, 0) > 0)
(gdb)


Please let me know if you have any suggestions for fixes or ways to provide more
info on the bug.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
