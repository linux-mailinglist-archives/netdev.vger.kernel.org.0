Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B48BDA250
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 01:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437623AbfJPXeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 19:34:12 -0400
Received: from hermod.demfloro.ru ([88.198.40.173]:19980 "EHLO demfloro.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728302AbfJPXeL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 19:34:11 -0400
X-Greylist: delayed 430 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Oct 2019 19:34:10 EDT
Received: from fire.localdomain (unknown [IPv6:2001:470:28:88::100])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: demfloro)
        by demfloro.ru (Postfix) with ESMTPSA id 46tpNM1fyHz3hq4;
        Wed, 16 Oct 2019 23:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=demfloro.ru; s=032019;
        t=1571268419; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:content-transfer-encoding:in-reply-to:
         references; bh=kEbyNSttD7j7Jw0p0sYf7lJIG9uKLSgOlKCehITXp3A=;
        b=mHeDnTyL4lbvyel8kbesCIuvLrPIapLt5xRu8/j5Ll4SDAg5+WD6HU30jeA5usmU/KN3gQ
        Jw1KlKeZ12R1GLeENWi6JRQgJMCXE7RR3jDGG41Kel0mXzpLbNPvxh2rAkWbrqYyJUqhyW
        kVZI7AJyMQeFfAy96LSoPP877AqMu+E/9OS34cHRUBmfte9Z6Fsc8i/S3/sa1nxJxIR1i7
        EuSCtRnMRMYsoToar30MzCWLbCxU6+U46o20zltMkPISZDI3f2fyPcgYs/MNJiRmY1ATbs
        uHe8Di1LeCiI4kSvtu8V8l0oEgEK0etsDqyu/O9wwCNhdNpQAqBzqC5R6Hk9oQ==
Date:   Thu, 17 Oct 2019 02:26:54 +0300
From:   Dmitrii Tcvetkov <demfloro@demfloro.ru>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: Memory leak of skbuff_ext_cache in v5.4-rc2
Message-ID: <20191017022654.5b993ce1@fire.localdomain>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/ATeF16.Qk1ukxCl/3HOOUGP"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=demfloro.ru;
        s=arc032019; t=1571268419;
        h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:content-transfer-encoding:in-reply-to:
         references; bh=kEbyNSttD7j7Jw0p0sYf7lJIG9uKLSgOlKCehITXp3A=;
        b=DFDVPPtEVaxrxZZfltuImyj8Ls3eI8sfVZZbqdRGZZpr4M6n5UnHMKr9Ec5tM8tWg2195T
        oJgW6t1OaVyjx18NRjHtXnoILi8O0ZBHxr2jnpG0JOjXkeL/NZUzhTiGFjOJSmsYX3RWWH
        A2Egsn2BGDQI4m2JWC8FzJIChNRBQ99DYClpurKDoIV3a3AEFK6aN/EeC1In/qmtXXz77Y
        O+oRN892Abr4MUJ0UFpN0bI0iIBsjzHnCwpVa9eCB86vvPqwM+VacZ7+hwTzG/lLrYIT9A
        IWxBl6BlKliM1i0SiXUBPYW+f+MKL+Mpx5J5Es/aeA5bBTtpsaFlq9w8TL0AhQ==
ARC-Seal: i=1; s=arc032019; d=demfloro.ru; t=1571268419; a=rsa-sha256;
        cv=none;
        b=Jg9GGXI+cmNPJ9dDGIgcgHftH5r23zhpaXprGlVEW1zUGFD02WEytnJfmwLeXSfSTEPIjn
        X4UywXKRcIs5q+0emUohvK54pXW32CeJItg4Ir+ZUqLC7lWEzoj6ucLGGf7jQ3CqG+TXbP
        eqsse/4D48HDSl2s8VauCt0bPABmdye0Ig3YffjjuJchseNr0F9HrMNIDWUx0tNq4SMWRY
        bRsZNmxvFatSqP+7NvuK3mHXXCS5wJq8gGTUwA9MMMz+UOa6jdg5gJof8Qe2TNP8xL/Lv8
        5C9NLEWFbFwx6IopDxMCYfenqjnD6jjYqEVOPkmt2rniGQpDyrMISDltwGSJHQ==
ARC-Authentication-Results: i=1;
        demfloro.ru;
        auth=pass smtp.auth=demfloro smtp.mailfrom=demfloro@demfloro.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--MP_/ATeF16.Qk1ukxCl/3HOOUGP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

During testing of v5.4-rc2 on a machine with

0a:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 09)

I noticed that skbuff_ext_cache memory usage was constantly increasing:

# grep skbuff_ext_cache /proc/slabinfo
slabinfo - version: 2.1
...
skbuff_ext_cache  206880 206880    128   32    1 : tunables    0    0    0 : slabdata   6465   6465      0

(After 60 seconds)

# grep skbuff_ext_cache /proc/slabinfo
slabinfo - version: 2.1
...
skbuff_ext_cache  217312 217312    128   32    1 : tunables    0    0    0 : slabdata   6791   6791      0

There is no limit to this, after about 24 hours size of the cache was more
than 1.5 GiB.

Bisect led me to commit 895b5c9f206 (netfilter: drop bridge nf reset from nf_reset).
After reverting the commit I can't reproduce the problem on current
mainline master (bc88f85c6c0) on the machine.

Bisect log:
git bisect start
# good: [54ecb8f7028c5eb3d740bb82b0f1d90f2df63c5c] Linux 5.4-rc1
git bisect good 54ecb8f7028c5eb3d740bb82b0f1d90f2df63c5c
# bad: [da0c9ea146cbe92b832f1b0f694840ea8eb33cce] Linux 5.4-rc2
git bisect bad da0c9ea146cbe92b832f1b0f694840ea8eb33cce
# good: [2cf2aa6a69db0b17b3979144287af8775c1c1534] dma-mapping: fix false positivse warnings in dma_common_free_remap()
git bisect good 2cf2aa6a69db0b17b3979144287af8775c1c1534
# bad: [2d880b8709c013d47472f85a9d42ea1aca3bce47] net: phy: extract pause mode
git bisect bad 2d880b8709c013d47472f85a9d42ea1aca3bce47
# good: [b33210e3797d600a5a5e556682f0afe596aa011b] Merge branch 'stmmac-fixes'
git bisect good b33210e3797d600a5a5e556682f0afe596aa011b
# bad: [53de429f4e88f538f7a8ec2b18be8c0cd9b2c8e1] net: hisilicon: Fix usage of uninitialized variable in function mdio_sc_cfg_reg_write()
git bisect bad 53de429f4e88f538f7a8ec2b18be8c0cd9b2c8e1
# good: [e8521e53cca584ddf8ec4584d3c550a6c65f88c4] net: dsa: rtl8366: Check VLAN ID and not ports
git bisect good e8521e53cca584ddf8ec4584d3c550a6c65f88c4
# good: [76d674947c17d297d65b185aa6ce551f915c7e2e] Merge branch 'SJA1105-DSA-locking-fixes-for-PTP'
git bisect good 76d674947c17d297d65b185aa6ce551f915c7e2e
# bad: [34a4c95abd25ab41fb390b985a08a651b1fa0b0f] netfilter: nft_connlimit: disable bh on garbage collection
git bisect bad 34a4c95abd25ab41fb390b985a08a651b1fa0b0f
# bad: [895b5c9f206eb7d25dc1360a8ccfc5958895eb89] netfilter: drop bridge nf reset from nf_reset
git bisect bad 895b5c9f206eb7d25dc1360a8ccfc5958895eb89
# first bad commit: [895b5c9f206eb7d25dc1360a8ccfc5958895eb89] netfilter: drop bridge nf reset from nf_reset

dmesg after "echo 1 > /sys/kernel/slab/skbuff_ext_cache/trace" attached.

Other machines with other network cards don't show the problem with
commit 895b5c9f206 (netfilter: drop bridge nf reset from nf_reset).

--MP_/ATeF16.Qk1ukxCl/3HOOUGP
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=trace.txt

[76490.590184]  net_rx_action+0x110/0x2d0
[76490.590187]  __do_softirq+0xd7/0x21f
[76490.590190]  irq_exit+0x9b/0xa0
[76490.590192]  do_IRQ+0x49/0xd0
[76490.590195]  common_interrupt+0xf/0xf
[76490.590196]  </IRQ>
[76490.590199] RIP: 0010:cpuidle_enter_state+0x120/0x2a0
[76490.590201] Code: e8 c5 27 75 ff 31 ff 49 89 c6 e8 ab 31 75 ff 45 84 ff 74 12 9c 58 f6 c4 02 0f 85 6b 01 00 00 31 ff e8 c4 2d 79 ff fb 45 85 ed <0f> 88 c3 00 00 00 49 63 cd 4c 89 f6 48 8d 04 49 48 29 ee 48 c1 e0
[76490.590203] RSP: 0018:ffffa822000c7e80 EFLAGS: 00000202 ORIG_RAX: ffffffffffffffdc
[76490.590205] RAX: ffff9472debdad80 RBX: ffffffffb2c46c60 RCX: 0000000000000000
[76490.590207] RDX: 0000000000000000 RSI: 000000001fe490a5 RDI: 0000000000000000
[76490.590209] RBP: 000045915a731821 R08: 000045915a73cfad R09: 000000000000017a
[76490.590210] R10: ffff9472debd9f00 R11: ffff9472debd9ee0 R12: ffff9470c892b000
[76490.590212] R13: 0000000000000002 R14: 000045915a73cfad R15: 0000000000000000
[76490.590215]  cpuidle_enter+0x24/0x40
[76490.590217]  do_idle+0x1b8/0x200
[76490.590220]  cpu_startup_entry+0x14/0x20
[76490.590222]  start_secondary+0x14d/0x180
[76490.590224]  secondary_startup_64+0xa4/0xb0
[76490.590237] TRACE skbuff_ext_cache free 0x00000000e96232cc inuse=3 fp=0x00000000471d135e
[76490.590239] Object 00000000e96232cc: e6 3c 93 ad b0 dd a2 b9 00 00 00 00 00 00 00 00  .<..............
[76490.590241] Object 000000003607d258: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.590242] Object 00000000993a2854: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.590244] Object 000000003615d84a: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.590246] Object 00000000e0b2f4a9: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.590248] Object 00000000616bfa3d: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.590250] Object 00000000ca971e2c: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.590252] Object 000000005de56d3d: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.590254] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.590256] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.590257] Call Trace:
[76490.590259]  <IRQ>
[76490.590261]  dump_stack+0x46/0x68
[76490.590263]  free_debug_processing.cold+0x55/0x14b
[76490.590266]  ? skb_release_all+0xc/0x30
[76490.590268]  ? skb_release_all+0xc/0x30
[76490.590270]  __slab_free+0x1f0/0x350
[76490.590273]  ? skb_release_all+0xc/0x30
[76490.590279]  kmem_cache_free+0x1e8/0x200
[76490.590282]  skb_release_all+0xc/0x30
[76490.590284]  __kfree_skb+0xc/0x20
[76490.590286]  tcp_rcv_established+0x29a/0x5f0
[76490.590289]  tcp_v4_do_rcv+0x136/0x1f0
[76490.590291]  tcp_v4_rcv+0xa5d/0xb50
[76490.590293]  ? br_pass_frame_up+0x160/0x160
[76490.590296]  ip_protocol_deliver_rcu+0x26/0x1b0
[76490.590298]  ip_local_deliver_finish+0x4b/0x60
[76490.590300]  ip_local_deliver+0xf4/0x100
[76490.590302]  ? ip_protocol_deliver_rcu+0x1b0/0x1b0
[76490.590304]  ip_sabotage_in+0x5f/0x70
[76490.590307]  nf_hook_slow+0x38/0xa0
[76490.590309]  ip_rcv+0x9f/0xe0
[76490.590311]  ? ip_rcv_finish_core.isra.0+0x340/0x340
[76490.590313]  __netif_receive_skb_one_core+0x81/0x90
[76490.590316]  netif_receive_skb_internal+0x3b/0xb0
[76490.590318]  br_pass_frame_up+0x142/0x160
[76490.590320]  ? br_add_if.cold+0x37/0x37
[76490.590322]  br_handle_frame_finish+0x322/0x440
[76490.590324]  br_nf_hook_thresh+0xf0/0x100
[76490.590327]  ? br_pass_frame_up+0x160/0x160
[76490.590329]  br_nf_pre_routing_finish+0x14e/0x320
[76490.590331]  ? br_pass_frame_up+0x160/0x160
[76490.590334]  br_nf_pre_routing+0x22c/0x4d6
[76490.590337]  ? br_nf_forward_ip+0x490/0x490
[76490.590347]  br_handle_frame+0x19f/0x370
[76490.590349]  ? br_pass_frame_up+0x160/0x160
[76490.590351]  __netif_receive_skb_core+0x2ae/0xc80
[76490.590354]  __netif_receive_skb_one_core+0x37/0x90
[76490.590357]  netif_receive_skb_internal+0x3b/0xb0
[76490.590360]  napi_gro_receive+0x4b/0x90
[76490.590362]  rtl8169_poll+0x220/0x640
[76490.590364]  net_rx_action+0x110/0x2d0
[76490.590367]  __do_softirq+0xd7/0x21f
[76490.590369]  irq_exit+0x9b/0xa0
[76490.590372]  do_IRQ+0x49/0xd0
[76490.590374]  common_interrupt+0xf/0xf
[76490.590376]  </IRQ>
[76490.590379] RIP: 0010:cpuidle_enter_state+0x120/0x2a0
[76490.590381] Code: e8 c5 27 75 ff 31 ff 49 89 c6 e8 ab 31 75 ff 45 84 ff 74 12 9c 58 f6 c4 02 0f 85 6b 01 00 00 31 ff e8 c4 2d 79 ff fb 45 85 ed <0f> 88 c3 00 00 00 49 63 cd 4c 89 f6 48 8d 04 49 48 29 ee 48 c1 e0
[76490.590383] RSP: 0018:ffffa822000c7e80 EFLAGS: 00000202 ORIG_RAX: ffffffffffffffdc
[76490.590385] RAX: ffff9472debdad80 RBX: ffffffffb2c46c60 RCX: 0000000000000000
[76490.590388] RDX: 0000000000000000 RSI: 000000001fe490a5 RDI: 0000000000000000
[76490.590391] RBP: 000045915a731821 R08: 000045915a73cfad R09: 000000000000017a
[76490.590392] R10: ffff9472debd9f00 R11: ffff9472debd9ee0 R12: ffff9470c892b000
[76490.590394] R13: 0000000000000002 R14: 000045915a73cfad R15: 0000000000000000
[76490.590397]  cpuidle_enter+0x24/0x40
[76490.590399]  do_idle+0x1b8/0x200
[76490.590402]  cpu_startup_entry+0x14/0x20
[76490.590404]  start_secondary+0x14d/0x180
[76490.590408]  secondary_startup_64+0xa4/0xb0
[76490.590415] TRACE skbuff_ext_cache alloc 0x00000000e96232cc inuse=32 fp=0x00000000cb688f98
[76490.590417] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.590419] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.590420] Call Trace:
[76490.590422]  <IRQ>
[76490.590424]  dump_stack+0x46/0x68
[76490.590427]  alloc_debug_processing.cold+0x6c/0x71
[76490.590430]  ___slab_alloc.constprop.0+0x544/0x5a0
[76490.590433]  ? skb_ext_add+0xd5/0x170
[76490.590435]  ? br_pass_frame_up+0x160/0x160
[76490.590438]  ? skb_ext_add+0xd5/0x170
[76490.590440]  kmem_cache_alloc+0x180/0x1a0
[76490.590443]  skb_ext_add+0xd5/0x170
[76490.590445]  br_nf_pre_routing+0x154/0x4d6
[76490.590449]  ? br_nf_forward_ip+0x490/0x490
[76490.590450]  br_handle_frame+0x19f/0x370
[76490.590452]  ? br_pass_frame_up+0x160/0x160
[76490.590455]  __netif_receive_skb_core+0x2ae/0xc80
[76490.590457]  __netif_receive_skb_one_core+0x37/0x90
[76490.590459]  netif_receive_skb_internal+0x3b/0xb0
[76490.590461]  napi_gro_receive+0x4b/0x90
[76490.590463]  rtl8169_poll+0x220/0x640
[76490.590466]  net_rx_action+0x110/0x2d0
[76490.590469]  __do_softirq+0xd7/0x21f
[76490.590472]  irq_exit+0x9b/0xa0
[76490.590474]  do_IRQ+0x49/0xd0
[76490.590476]  common_interrupt+0xf/0xf
[76490.590478]  </IRQ>
[76490.590480] RIP: 0010:cpuidle_enter_state+0x120/0x2a0
[76490.590482] Code: e8 c5 27 75 ff 31 ff 49 89 c6 e8 ab 31 75 ff 45 84 ff 74 12 9c 58 f6 c4 02 0f 85 6b 01 00 00 31 ff e8 c4 2d 79 ff fb 45 85 ed <0f> 88 c3 00 00 00 49 63 cd 4c 89 f6 48 8d 04 49 48 29 ee 48 c1 e0
[76490.590487] RSP: 0018:ffffa822000c7e80 EFLAGS: 00000202 ORIG_RAX: ffffffffffffffdc
[76490.590489] RAX: ffff9472debdad80 RBX: ffffffffb2c46c60 RCX: 0000000000000000
[76490.590490] RDX: 0000000000000000 RSI: 000000001fe490a5 RDI: 0000000000000000
[76490.590492] RBP: 000045915a731821 R08: 000045915a73cfad R09: 000000000000017a
[76490.590493] R10: ffff9472debd9f00 R11: ffff9472debd9ee0 R12: ffff9470c892b000
[76490.590495] R13: 0000000000000002 R14: 000045915a73cfad R15: 0000000000000000
[76490.590500]  cpuidle_enter+0x24/0x40
[76490.590502]  do_idle+0x1b8/0x200
[76490.590505]  cpu_startup_entry+0x14/0x20
[76490.590507]  start_secondary+0x14d/0x180
[76490.590512]  secondary_startup_64+0xa4/0xb0
[76490.590523] TRACE skbuff_ext_cache free 0x00000000e96232cc inuse=3 fp=0x000000003be3530a
[76490.590525] Object 00000000e96232cc: e6 3c 93 ad b0 dd a2 b9 00 00 00 00 00 00 00 00  .<..............
[76490.590527] Object 000000003607d258: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.590531] Object 00000000993a2854: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.590532] Object 000000003615d84a: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.590535] Object 00000000e0b2f4a9: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.590537] Object 00000000616bfa3d: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.590538] Object 00000000ca971e2c: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.590542] Object 000000005de56d3d: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.590545] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.590546] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.590548] Call Trace:
[76490.590549]  <IRQ>
[76490.590552]  dump_stack+0x46/0x68
[76490.590554]  free_debug_processing.cold+0x55/0x14b
[76490.590556]  ? skb_release_all+0xc/0x30
[76490.590558]  ? skb_release_all+0xc/0x30
[76490.590561]  __slab_free+0x1f0/0x350
[76490.590563]  ? skb_release_all+0xc/0x30
[76490.590565]  kmem_cache_free+0x1e8/0x200
[76490.590568]  skb_release_all+0xc/0x30
[76490.590572]  __kfree_skb+0xc/0x20
[76490.590574]  tcp_rcv_established+0x29a/0x5f0
[76490.590577]  tcp_v4_do_rcv+0x136/0x1f0
[76490.590579]  tcp_v4_rcv+0xa5d/0xb50
[76490.590581]  ? br_pass_frame_up+0x160/0x160
[76490.590583]  ip_protocol_deliver_rcu+0x26/0x1b0
[76490.590585]  ip_local_deliver_finish+0x4b/0x60
[76490.590587]  ip_local_deliver+0xf4/0x100
[76490.590589]  ? ip_protocol_deliver_rcu+0x1b0/0x1b0
[76490.590592]  ip_sabotage_in+0x5f/0x70
[76490.590594]  nf_hook_slow+0x38/0xa0
[76490.590596]  ip_rcv+0x9f/0xe0
[76490.590598]  ? ip_rcv_finish_core.isra.0+0x340/0x340
[76490.590601]  __netif_receive_skb_one_core+0x81/0x90
[76490.590603]  netif_receive_skb_internal+0x3b/0xb0
[76490.590606]  br_pass_frame_up+0x142/0x160
[76490.590608]  ? br_add_if.cold+0x37/0x37
[76490.590610]  br_handle_frame_finish+0x322/0x440
[76490.590612]  br_nf_hook_thresh+0xf0/0x100
[76490.590614]  ? br_pass_frame_up+0x160/0x160
[76490.590617]  br_nf_pre_routing_finish+0x14e/0x320
[76490.590619]  ? br_pass_frame_up+0x160/0x160
[76490.590622]  br_nf_pre_routing+0x22c/0x4d6
[76490.590624]  ? br_nf_forward_ip+0x490/0x490
[76490.590626]  br_handle_frame+0x19f/0x370
[76490.590628]  ? br_pass_frame_up+0x160/0x160
[76490.590631]  __netif_receive_skb_core+0x2ae/0xc80
[76490.590634]  __netif_receive_skb_one_core+0x37/0x90
[76490.590636]  netif_receive_skb_internal+0x3b/0xb0
[76490.590638]  napi_gro_receive+0x4b/0x90
[76490.590640]  rtl8169_poll+0x220/0x640
[76490.590642]  net_rx_action+0x110/0x2d0
[76490.590645]  __do_softirq+0xd7/0x21f
[76490.590647]  irq_exit+0x9b/0xa0
[76490.590650]  do_IRQ+0x49/0xd0
[76490.590652]  common_interrupt+0xf/0xf
[76490.590654]  </IRQ>
[76490.590656] RIP: 0010:cpuidle_enter_state+0x120/0x2a0
[76490.590658] Code: e8 c5 27 75 ff 31 ff 49 89 c6 e8 ab 31 75 ff 45 84 ff 74 12 9c 58 f6 c4 02 0f 85 6b 01 00 00 31 ff e8 c4 2d 79 ff fb 45 85 ed <0f> 88 c3 00 00 00 49 63 cd 4c 89 f6 48 8d 04 49 48 29 ee 48 c1 e0
[76490.590660] RSP: 0018:ffffa822000c7e80 EFLAGS: 00000202 ORIG_RAX: ffffffffffffffdc
[76490.590662] RAX: ffff9472debdad80 RBX: ffffffffb2c46c60 RCX: 0000000000000000
[76490.590664] RDX: 0000000000000000 RSI: 000000001fe490a5 RDI: 0000000000000000
[76490.590666] RBP: 000045915a731821 R08: 000045915a73cfad R09: 000000000000017a
[76490.590667] R10: ffff9472debd9f00 R11: ffff9472debd9ee0 R12: ffff9470c892b000
[76490.590669] R13: 0000000000000002 R14: 000045915a73cfad R15: 0000000000000000
[76490.590672]  cpuidle_enter+0x24/0x40
[76490.590674]  do_idle+0x1b8/0x200
[76490.590677]  cpu_startup_entry+0x14/0x20
[76490.590679]  start_secondary+0x14d/0x180
[76490.590681]  secondary_startup_64+0xa4/0xb0
[76490.590687] TRACE skbuff_ext_cache alloc 0x00000000e96232cc inuse=32 fp=0x00000000cb688f98
[76490.590689] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.590691] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.590692] Call Trace:
[76490.590693]  <IRQ>
[76490.590696]  dump_stack+0x46/0x68
[76490.590698]  alloc_debug_processing.cold+0x6c/0x71
[76490.590700]  ___slab_alloc.constprop.0+0x544/0x5a0
[76490.590703]  ? skb_ext_add+0xd5/0x170
[76490.590705]  ? br_pass_frame_up+0x160/0x160
[76490.590708]  ? skb_ext_add+0xd5/0x170
[76490.590710]  kmem_cache_alloc+0x180/0x1a0
[76490.590712]  skb_ext_add+0xd5/0x170
[76490.590715]  br_nf_pre_routing+0x154/0x4d6
[76490.590717]  ? br_nf_forward_ip+0x490/0x490
[76490.590719]  br_handle_frame+0x19f/0x370
[76490.590722]  ? br_pass_frame_up+0x160/0x160
[76490.590724]  __netif_receive_skb_core+0x2ae/0xc80
[76490.590727]  __netif_receive_skb_one_core+0x37/0x90
[76490.590730]  netif_receive_skb_internal+0x3b/0xb0
[76490.590731]  napi_gro_receive+0x4b/0x90
[76490.590733]  rtl8169_poll+0x220/0x640
[76490.590735]  net_rx_action+0x110/0x2d0
[76490.590738]  __do_softirq+0xd7/0x21f
[76490.590741]  irq_exit+0x9b/0xa0
[76490.590743]  do_IRQ+0x49/0xd0
[76490.590745]  common_interrupt+0xf/0xf
[76490.590747]  </IRQ>
[76490.590749] RIP: 0010:cpuidle_enter_state+0x120/0x2a0
[76490.590751] Code: e8 c5 27 75 ff 31 ff 49 89 c6 e8 ab 31 75 ff 45 84 ff 74 12 9c 58 f6 c4 02 0f 85 6b 01 00 00 31 ff e8 c4 2d 79 ff fb 45 85 ed <0f> 88 c3 00 00 00 49 63 cd 4c 89 f6 48 8d 04 49 48 29 ee 48 c1 e0
[76490.590753] RSP: 0018:ffffa822000c7e80 EFLAGS: 00000202 ORIG_RAX: ffffffffffffffdc
[76490.590755] RAX: ffff9472debdad80 RBX: ffffffffb2c46c60 RCX: 0000000000000000
[76490.590756] RDX: 0000000000000000 RSI: 000000001fe490a5 RDI: 0000000000000000
[76490.590758] RBP: 000045915a731821 R08: 000045915a73cfad R09: 000000000000017a
[76490.590760] R10: ffff9472debd9f00 R11: ffff9472debd9ee0 R12: ffff9470c892b000
[76490.590761] R13: 0000000000000002 R14: 000045915a73cfad R15: 0000000000000000
[76490.590764]  cpuidle_enter+0x24/0x40
[76490.590766]  do_idle+0x1b8/0x200
[76490.590769]  cpu_startup_entry+0x14/0x20
[76490.590771]  start_secondary+0x14d/0x180
[76490.590773]  secondary_startup_64+0xa4/0xb0
[76490.590782] TRACE skbuff_ext_cache free 0x00000000e96232cc inuse=3 fp=0x00000000471d135e
[76490.590784] Object 00000000e96232cc: e6 3c 93 ad b0 dd a2 b9 00 00 00 00 00 00 00 00  .<..............
[76490.590786] Object 000000003607d258: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.590788] Object 00000000993a2854: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.590792] Object 000000003615d84a: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.590794] Object 00000000e0b2f4a9: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.590795] Object 00000000616bfa3d: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.590797] Object 00000000ca971e2c: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.590799] Object 000000005de56d3d: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.590801] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.590807] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.590808] Call Trace:
[76490.590810]  <IRQ>
[76490.590812]  dump_stack+0x46/0x68
[76490.590814]  free_debug_processing.cold+0x55/0x14b
[76490.590817]  ? skb_release_all+0xc/0x30
[76490.590820]  ? skb_release_all+0xc/0x30
[76490.590824]  __slab_free+0x1f0/0x350
[76490.590826]  ? skb_release_all+0xc/0x30
[76490.590829]  kmem_cache_free+0x1e8/0x200
[76490.590831]  skb_release_all+0xc/0x30
[76490.590833]  __kfree_skb+0xc/0x20
[76490.590835]  tcp_rcv_established+0x29a/0x5f0
[76490.590838]  tcp_v4_do_rcv+0x136/0x1f0
[76490.590840]  tcp_v4_rcv+0xa5d/0xb50
[76490.590842]  ? br_pass_frame_up+0x160/0x160
[76490.590844]  ip_protocol_deliver_rcu+0x26/0x1b0
[76490.590846]  ip_local_deliver_finish+0x4b/0x60
[76490.590848]  ip_local_deliver+0xf4/0x100
[76490.590851]  ? ip_protocol_deliver_rcu+0x1b0/0x1b0
[76490.590853]  ip_sabotage_in+0x5f/0x70
[76490.590855]  nf_hook_slow+0x38/0xa0
[76490.590858]  ip_rcv+0x9f/0xe0
[76490.590860]  ? ip_rcv_finish_core.isra.0+0x340/0x340
[76490.590862]  __netif_receive_skb_one_core+0x81/0x90
[76490.590865]  netif_receive_skb_internal+0x3b/0xb0
[76490.590867]  br_pass_frame_up+0x142/0x160
[76490.590869]  ? br_add_if.cold+0x37/0x37
[76490.590871]  br_handle_frame_finish+0x322/0x440
[76490.590874]  br_nf_hook_thresh+0xf0/0x100
[76490.590876]  ? br_pass_frame_up+0x160/0x160
[76490.590879]  br_nf_pre_routing_finish+0x14e/0x320
[76490.590881]  ? br_pass_frame_up+0x160/0x160
[76490.590884]  br_nf_pre_routing+0x22c/0x4d6
[76490.590886]  ? br_nf_forward_ip+0x490/0x490
[76490.590888]  br_handle_frame+0x19f/0x370
[76490.590891]  ? br_pass_frame_up+0x160/0x160
[76490.590893]  __netif_receive_skb_core+0x2ae/0xc80
[76490.590895]  __netif_receive_skb_one_core+0x37/0x90
[76490.590897]  netif_receive_skb_internal+0x3b/0xb0
[76490.590899]  napi_gro_receive+0x4b/0x90
[76490.590900]  rtl8169_poll+0x220/0x640
[76490.590902]  net_rx_action+0x110/0x2d0
[76490.590904]  __do_softirq+0xd7/0x21f
[76490.590906]  irq_exit+0x9b/0xa0
[76490.590908]  do_IRQ+0x49/0xd0
[76490.590910]  common_interrupt+0xf/0xf
[76490.590911]  </IRQ>
[76490.590913] RIP: 0010:cpuidle_enter_state+0x120/0x2a0
[76490.590915] Code: e8 c5 27 75 ff 31 ff 49 89 c6 e8 ab 31 75 ff 45 84 ff 74 12 9c 58 f6 c4 02 0f 85 6b 01 00 00 31 ff e8 c4 2d 79 ff fb 45 85 ed <0f> 88 c3 00 00 00 49 63 cd 4c 89 f6 48 8d 04 49 48 29 ee 48 c1 e0
[76490.590917] RSP: 0018:ffffa822000c7e80 EFLAGS: 00000202 ORIG_RAX: ffffffffffffffdc
[76490.590918] RAX: ffff9472debdad80 RBX: ffffffffb2c46c60 RCX: 0000000000000000
[76490.590919] RDX: 0000000000000000 RSI: 000000001fe490a5 RDI: 0000000000000000
[76490.590920] RBP: 000045915a731821 R08: 000045915a73cfad R09: 000000000000017a
[76490.590922] R10: ffff9472debd9f00 R11: ffff9472debd9ee0 R12: ffff9470c892b000
[76490.590923] R13: 0000000000000002 R14: 000045915a73cfad R15: 0000000000000000
[76490.590925]  cpuidle_enter+0x24/0x40
[76490.590927]  do_idle+0x1b8/0x200
[76490.590929]  cpu_startup_entry+0x14/0x20
[76490.590931]  start_secondary+0x14d/0x180
[76490.590932]  secondary_startup_64+0xa4/0xb0
[76490.593594] TRACE skbuff_ext_cache alloc 0x00000000e96232cc inuse=32 fp=0x00000000cb688f98
[76490.593598] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.593600] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.593602] Call Trace:
[76490.593604]  <IRQ>
[76490.593608]  dump_stack+0x46/0x68
[76490.593611]  alloc_debug_processing.cold+0x6c/0x71
[76490.593614]  ___slab_alloc.constprop.0+0x544/0x5a0
[76490.593616]  ? skb_ext_add+0xd5/0x170
[76490.593619]  ? br_dev_xmit+0x254/0x3c0
[76490.593622]  ? skb_ext_add+0xd5/0x170
[76490.593624]  kmem_cache_alloc+0x180/0x1a0
[76490.593627]  skb_ext_add+0xd5/0x170
[76490.593630]  br_nf_pre_routing+0x154/0x4d6
[76490.593632]  br_handle_frame+0x19f/0x370
[76490.593634]  ? br_pass_frame_up+0x160/0x160
[76490.593637]  __netif_receive_skb_core+0x2ae/0xc80
[76490.593640]  __netif_receive_skb_one_core+0x37/0x90
[76490.593642]  netif_receive_skb_internal+0x3b/0xb0
[76490.593644]  napi_gro_receive+0x4b/0x90
[76490.593646]  rtl8169_poll+0x220/0x640
[76490.593648]  net_rx_action+0x110/0x2d0
[76490.593651]  __do_softirq+0xd7/0x21f
[76490.593654]  irq_exit+0x9b/0xa0
[76490.593656]  do_IRQ+0x49/0xd0
[76490.593659]  common_interrupt+0xf/0xf
[76490.593660]  </IRQ>
[76490.593663] RIP: 0010:acpi_idle_do_entry+0x3c/0x50
[76490.593666] Code: 04 ec 48 8b 15 a9 c9 6a 01 ed 5d c3 65 48 8b 04 25 c0 14 01 00 48 8b 00 a8 08 75 ee e9 07 00 00 00 0f 00 2d d6 ba 67 00 fb f4 <fa> 5d c3 48 89 ef 5d e9 88 fe ff ff 90 90 90 90 90 90 90 90 41 56
[76490.593668] RSP: 0018:ffffa822000c7e28 EFLAGS: 00000246 ORIG_RAX: ffffffffffffffdc
[76490.593670] RAX: 0000000080004000 RBX: 0000000000000001 RCX: 0000000000000034
[76490.593672] RDX: 4ec4ec4ec4ec4ec5 RSI: ffffffffb2c46c60 RDI: ffff946d7a570064
[76490.593673] RBP: ffff946d7a570064 R08: 000045915aa6cd38 R09: 00000000000003a7
[76490.593675] R10: ffff9472debd9f00 R11: ffff9472debd9ee0 R12: 0000000000000001
[76490.593676] R13: 0000000000000001 R14: ffff946d7a570064 R15: 0000000000000000
[76490.593681]  acpi_idle_enter+0xe1/0x2a0
[76490.593684]  ? tick_nohz_get_sleep_length+0x6b/0xa0
[76490.593687]  cpuidle_enter_state+0xe7/0x2a0
[76490.593690]  cpuidle_enter+0x24/0x40
[76490.593692]  do_idle+0x1b8/0x200
[76490.593695]  cpu_startup_entry+0x14/0x20
[76490.593697]  start_secondary+0x14d/0x180
[76490.593699]  secondary_startup_64+0xa4/0xb0
[76490.593724] TRACE skbuff_ext_cache alloc 0x000000003be3530a inuse=32 fp=0x00000000cb688f98
[76490.593727] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.593729] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.593730] Call Trace:
[76490.593732]  <IRQ>
[76490.593734]  dump_stack+0x46/0x68
[76490.593736]  alloc_debug_processing.cold+0x6c/0x71
[76490.593739]  ___slab_alloc.constprop.0+0x544/0x5a0
[76490.593741]  ? skb_ext_add+0xd5/0x170
[76490.593743]  ? br_pass_frame_up+0x160/0x160
[76490.593746]  ? skb_ext_add+0xd5/0x170
[76490.593748]  kmem_cache_alloc+0x180/0x1a0
[76490.593750]  skb_ext_add+0xd5/0x170
[76490.593753]  br_nf_pre_routing+0x154/0x4d6
[76490.593755]  ? br_nf_forward_ip+0x490/0x490
[76490.593757]  br_handle_frame+0x19f/0x370
[76490.593759]  ? br_pass_frame_up+0x160/0x160
[76490.593762]  __netif_receive_skb_core+0x2ae/0xc80
[76490.593764]  __netif_receive_skb_one_core+0x37/0x90
[76490.593767]  netif_receive_skb_internal+0x3b/0xb0
[76490.593769]  napi_gro_receive+0x4b/0x90
[76490.593771]  rtl8169_poll+0x220/0x640
[76490.593773]  net_rx_action+0x110/0x2d0
[76490.593775]  __do_softirq+0xd7/0x21f
[76490.593778]  irq_exit+0x9b/0xa0
[76490.593780]  do_IRQ+0x49/0xd0
[76490.593782]  common_interrupt+0xf/0xf
[76490.593784]  </IRQ>
[76490.593786] RIP: 0010:acpi_idle_do_entry+0x3c/0x50
[76490.593788] Code: 04 ec 48 8b 15 a9 c9 6a 01 ed 5d c3 65 48 8b 04 25 c0 14 01 00 48 8b 00 a8 08 75 ee e9 07 00 00 00 0f 00 2d d6 ba 67 00 fb f4 <fa> 5d c3 48 89 ef 5d e9 88 fe ff ff 90 90 90 90 90 90 90 90 41 56
[76490.593790] RSP: 0018:ffffa822000c7e28 EFLAGS: 00000246 ORIG_RAX: ffffffffffffffdc
[76490.593792] RAX: 0000000080004000 RBX: 0000000000000001 RCX: 0000000000000034
[76490.593794] RDX: 4ec4ec4ec4ec4ec5 RSI: ffffffffb2c46c60 RDI: ffff946d7a570064
[76490.593795] RBP: ffff946d7a570064 R08: 000045915aa6cd38 R09: 00000000000003a7
[76490.593797] R10: ffff9472debd9f00 R11: ffff9472debd9ee0 R12: 0000000000000001
[76490.593798] R13: 0000000000000001 R14: ffff946d7a570064 R15: 0000000000000000
[76490.593801]  acpi_idle_enter+0xe1/0x2a0
[76490.593803]  ? tick_nohz_get_sleep_length+0x6b/0xa0
[76490.593806]  cpuidle_enter_state+0xe7/0x2a0
[76490.593808]  cpuidle_enter+0x24/0x40
[76490.593810]  do_idle+0x1b8/0x200
[76490.593813]  cpu_startup_entry+0x14/0x20
[76490.593815]  start_secondary+0x14d/0x180
[76490.593817]  secondary_startup_64+0xa4/0xb0
[76490.593825] TRACE skbuff_ext_cache alloc 0x00000000471d135e inuse=32 fp=0x00000000cb688f98
[76490.593827] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.593829] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.593830] Call Trace:
[76490.593832]  <IRQ>
[76490.593834]  dump_stack+0x46/0x68
[76490.593836]  alloc_debug_processing.cold+0x6c/0x71
[76490.593839]  ___slab_alloc.constprop.0+0x544/0x5a0
[76490.593841]  ? skb_ext_add+0xd5/0x170
[76490.593844]  ? br_pass_frame_up+0x160/0x160
[76490.593846]  ? skb_ext_add+0xd5/0x170
[76490.593848]  kmem_cache_alloc+0x180/0x1a0
[76490.593851]  skb_ext_add+0xd5/0x170
[76490.593853]  br_nf_pre_routing+0x154/0x4d6
[76490.593856]  ? br_nf_forward_ip+0x490/0x490
[76490.593859]  br_handle_frame+0x19f/0x370
[76490.593862]  ? br_pass_frame_up+0x160/0x160
[76490.593864]  __netif_receive_skb_core+0x2ae/0xc80
[76490.593868]  __netif_receive_skb_one_core+0x37/0x90
[76490.593871]  netif_receive_skb_internal+0x3b/0xb0
[76490.593873]  napi_gro_receive+0x4b/0x90
[76490.593875]  rtl8169_poll+0x220/0x640
[76490.593878]  net_rx_action+0x110/0x2d0
[76490.593880]  __do_softirq+0xd7/0x21f
[76490.593883]  irq_exit+0x9b/0xa0
[76490.593885]  do_IRQ+0x49/0xd0
[76490.593887]  common_interrupt+0xf/0xf
[76490.593889]  </IRQ>
[76490.593891] RIP: 0010:acpi_idle_do_entry+0x3c/0x50
[76490.593893] Code: 04 ec 48 8b 15 a9 c9 6a 01 ed 5d c3 65 48 8b 04 25 c0 14 01 00 48 8b 00 a8 08 75 ee e9 07 00 00 00 0f 00 2d d6 ba 67 00 fb f4 <fa> 5d c3 48 89 ef 5d e9 88 fe ff ff 90 90 90 90 90 90 90 90 41 56
[76490.593895] RSP: 0018:ffffa822000c7e28 EFLAGS: 00000246 ORIG_RAX: ffffffffffffffdc
[76490.593897] RAX: 0000000080004000 RBX: 0000000000000001 RCX: 0000000000000034
[76490.593898] RDX: 4ec4ec4ec4ec4ec5 RSI: ffffffffb2c46c60 RDI: ffff946d7a570064
[76490.593900] RBP: ffff946d7a570064 R08: 000045915aa6cd38 R09: 00000000000003a7
[76490.593901] R10: ffff9472debd9f00 R11: ffff9472debd9ee0 R12: 0000000000000001
[76490.593903] R13: 0000000000000001 R14: ffff946d7a570064 R15: 0000000000000000
[76490.593906]  acpi_idle_enter+0xe1/0x2a0
[76490.593908]  ? tick_nohz_get_sleep_length+0x6b/0xa0
[76490.593910]  cpuidle_enter_state+0xe7/0x2a0
[76490.593913]  cpuidle_enter+0x24/0x40
[76490.593915]  do_idle+0x1b8/0x200
[76490.593917]  cpu_startup_entry+0x14/0x20
[76490.593919]  start_secondary+0x14d/0x180
[76490.593921]  secondary_startup_64+0xa4/0xb0
[76490.594024] TRACE skbuff_ext_cache alloc 0x00000000fceded5f inuse=32 fp=0x00000000cb688f98
[76490.594028] CPU: 7 PID: 1802 Comm: transmission-da Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.594029] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.594031] Call Trace:
[76490.594032]  <IRQ>
[76490.594035]  dump_stack+0x46/0x68
[76490.594038]  alloc_debug_processing.cold+0x6c/0x71
[76490.594040]  ___slab_alloc.constprop.0+0x544/0x5a0
[76490.594043]  ? skb_ext_add+0xd5/0x170
[76490.594045]  ? br_pass_frame_up+0x160/0x160
[76490.594047]  ? skb_ext_add+0xd5/0x170
[76490.594050]  kmem_cache_alloc+0x180/0x1a0
[76490.594052]  skb_ext_add+0xd5/0x170
[76490.594055]  br_nf_pre_routing+0x154/0x4d6
[76490.594058]  ? get_page_from_freelist+0xadb/0xdf0
[76490.594060]  br_handle_frame+0x19f/0x370
[76490.594062]  ? br_pass_frame_up+0x160/0x160
[76490.594065]  __netif_receive_skb_core+0x2ae/0xc80
[76490.594068]  __netif_receive_skb_one_core+0x37/0x90
[76490.594070]  netif_receive_skb_internal+0x3b/0xb0
[76490.594072]  napi_gro_receive+0x4b/0x90
[76490.594074]  rtl8169_poll+0x220/0x640
[76490.594076]  net_rx_action+0x110/0x2d0
[76490.594079]  __do_softirq+0xd7/0x21f
[76490.594081]  irq_exit+0x9b/0xa0
[76490.594084]  do_IRQ+0x49/0xd0
[76490.594086]  common_interrupt+0xf/0xf
[76490.594088]  </IRQ>
[76490.594090] RIP: 0033:0x7e423aa7bc03
[76490.594092] Code: 40 0f 85 79 02 00 00 89 f9 4c 89 ee 48 0f af f1 48 01 f0 49 39 c6 0f 85 d5 ea ff ff 48 89 c8 48 c1 e8 06 48 8d 0c c2 c1 e0 06 <29> c7 48 8b 01 41 89 f8 48 0f a3 f8 0f 83 a9 ea ff ff 4d 85 ff 74
[76490.594094] RSP: 002b:000071c3fdc60500 EFLAGS: 00000256 ORIG_RAX: ffffffffffffffdc
[76490.594096] RAX: 0000000000000000 RBX: 0000000000005000 RCX: 00007e1ddd1bc680
[76490.594098] RDX: 00007e1ddd1bc680 RSI: 0000000000000f00 RDI: 0000000000000003
[76490.594099] RBP: 00007e10bb1de200 R08: 0000000000000f00 R09: 00000000000004be
[76490.594101] R10: 00000000000004aa R11: 0000000000000000 R12: 0000000000000010
[76490.594102] R13: 0000000000000500 R14: 0000762562afdf00 R15: 0000000000000500
[76490.594966] TRACE skbuff_ext_cache alloc 0x00000000a5d0b721 inuse=32 fp=0x00000000cb688f98
[76490.594969] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.594970] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.594971] Call Trace:
[76490.594973]  <IRQ>
[76490.594975]  dump_stack+0x46/0x68
[76490.594977]  alloc_debug_processing.cold+0x6c/0x71
[76490.594979]  ___slab_alloc.constprop.0+0x544/0x5a0
[76490.594981]  ? skb_ext_add+0xd5/0x170
[76490.594983]  ? br_dev_xmit+0x254/0x3c0
[76490.594985]  ? skb_ext_add+0xd5/0x170
[76490.594988]  kmem_cache_alloc+0x180/0x1a0
[76490.594990]  skb_ext_add+0xd5/0x170
[76490.594992]  br_nf_pre_routing+0x154/0x4d6
[76490.594993]  br_handle_frame+0x19f/0x370
[76490.594995]  ? br_pass_frame_up+0x160/0x160
[76490.594997]  __netif_receive_skb_core+0x2ae/0xc80
[76490.595000]  __netif_receive_skb_one_core+0x37/0x90
[76490.595002]  netif_receive_skb_internal+0x3b/0xb0
[76490.595003]  napi_gro_receive+0x4b/0x90
[76490.595005]  rtl8169_poll+0x220/0x640
[76490.595007]  net_rx_action+0x110/0x2d0
[76490.595009]  __do_softirq+0xd7/0x21f
[76490.595011]  irq_exit+0x9b/0xa0
[76490.595013]  do_IRQ+0x49/0xd0
[76490.595015]  common_interrupt+0xf/0xf
[76490.595016]  </IRQ>
[76490.595018] RIP: 0010:cpuidle_enter_state+0x120/0x2a0
[76490.595021] Code: e8 c5 27 75 ff 31 ff 49 89 c6 e8 ab 31 75 ff 45 84 ff 74 12 9c 58 f6 c4 02 0f 85 6b 01 00 00 31 ff e8 c4 2d 79 ff fb 45 85 ed <0f> 88 c3 00 00 00 49 63 cd 4c 89 f6 48 8d 04 49 48 29 ee 48 c1 e0
[76490.595024] RSP: 0018:ffffa822000c7e80 EFLAGS: 00000202 ORIG_RAX: ffffffffffffffdc
[76490.595027] RAX: ffff9472debdad80 RBX: ffffffffb2c46c60 RCX: 0000000000000000
[76490.595032] RDX: 0000000000000000 RSI: 000000001fe490a5 RDI: 0000000000000000
[76490.595034] RBP: 000045915ab6ecec R08: 000045915abdc516 R09: 00000000000003a7
[76490.595036] R10: ffff9472debd9f00 R11: ffff9472debd9ee0 R12: ffff9470c892b000
[76490.595037] R13: 0000000000000002 R14: 000045915abdc516 R15: 0000000000000000
[76490.595041]  cpuidle_enter+0x24/0x40
[76490.595044]  do_idle+0x1b8/0x200
[76490.595046]  cpu_startup_entry+0x14/0x20
[76490.595048]  start_secondary+0x14d/0x180
[76490.595050]  secondary_startup_64+0xa4/0xb0
[76490.595067] TRACE skbuff_ext_cache free 0x00000000a5d0b721 inuse=7 fp=0x0000000023accf91
[76490.595069] Object 00000000a5d0b721: e6 37 93 ad b0 dd a2 b9 00 00 00 00 00 00 00 00  .7..............
[76490.595070] Object 00000000c4337319: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.595071] Object 00000000086ffbd2: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.595073] Object 0000000047ea7a71: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.595074] Object 000000000d563d84: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.595075] Object 00000000312a4ac6: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.595077] Object 0000000063f9c762: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.595078] Object 000000008bf815ef: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.595080] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.595081] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.595082] Call Trace:
[76490.595083]  <IRQ>
[76490.595085]  dump_stack+0x46/0x68
[76490.595087]  free_debug_processing.cold+0x55/0x14b
[76490.595089]  ? skb_release_all+0xc/0x30
[76490.595091]  ? skb_release_all+0xc/0x30
[76490.595093]  __slab_free+0x1f0/0x350
[76490.595095]  ? tcp_xmit_retransmit_queue.part.0+0x158/0x260
[76490.595097]  ? tcp_ack+0x8f0/0x1280
[76490.595098]  ? skb_release_all+0xc/0x30
[76490.595100]  kmem_cache_free+0x1e8/0x200
[76490.595102]  skb_release_all+0xc/0x30
[76490.595104]  __kfree_skb+0xc/0x20
[76490.595105]  tcp_data_queue+0x76a/0xc20
[76490.595107]  tcp_rcv_established+0x1d4/0x5f0
[76490.595109]  tcp_v4_do_rcv+0x136/0x1f0
[76490.595111]  tcp_v4_rcv+0xa5d/0xb50
[76490.595113]  ? br_pass_frame_up+0x160/0x160
[76490.595115]  ip_protocol_deliver_rcu+0x26/0x1b0
[76490.595117]  ip_local_deliver_finish+0x4b/0x60
[76490.595118]  ip_local_deliver+0xf4/0x100
[76490.595120]  ? ip_protocol_deliver_rcu+0x1b0/0x1b0
[76490.595122]  ip_sabotage_in+0x5f/0x70
[76490.595125]  nf_hook_slow+0x38/0xa0
[76490.595126]  ip_rcv+0x9f/0xe0
[76490.595128]  ? ip_rcv_finish_core.isra.0+0x340/0x340
[76490.595130]  __netif_receive_skb_one_core+0x81/0x90
[76490.595132]  netif_receive_skb_internal+0x3b/0xb0
[76490.595134]  br_pass_frame_up+0x142/0x160
[76490.595135]  ? br_add_if.cold+0x37/0x37
[76490.595137]  br_handle_frame_finish+0x322/0x440
[76490.595139]  br_nf_hook_thresh+0xf0/0x100
[76490.595141]  ? br_pass_frame_up+0x160/0x160
[76490.595143]  br_nf_pre_routing_finish+0x14e/0x320
[76490.595144]  ? br_pass_frame_up+0x160/0x160
[76490.595146]  br_nf_pre_routing+0x22c/0x4d6
[76490.595148]  ? br_nf_forward_ip+0x490/0x490
[76490.595150]  br_handle_frame+0x19f/0x370
[76490.595152]  ? br_pass_frame_up+0x160/0x160
[76490.595154]  __netif_receive_skb_core+0x2ae/0xc80
[76490.595156]  __netif_receive_skb_one_core+0x37/0x90
[76490.595158]  netif_receive_skb_internal+0x3b/0xb0
[76490.595160]  napi_gro_receive+0x4b/0x90
[76490.595161]  rtl8169_poll+0x220/0x640
[76490.595163]  net_rx_action+0x110/0x2d0
[76490.595165]  __do_softirq+0xd7/0x21f
[76490.595167]  irq_exit+0x9b/0xa0
[76490.595169]  do_IRQ+0x49/0xd0
[76490.595171]  common_interrupt+0xf/0xf
[76490.595172]  </IRQ>
[76490.595174] RIP: 0010:cpuidle_enter_state+0x120/0x2a0
[76490.595176] Code: e8 c5 27 75 ff 31 ff 49 89 c6 e8 ab 31 75 ff 45 84 ff 74 12 9c 58 f6 c4 02 0f 85 6b 01 00 00 31 ff e8 c4 2d 79 ff fb 45 85 ed <0f> 88 c3 00 00 00 49 63 cd 4c 89 f6 48 8d 04 49 48 29 ee 48 c1 e0
[76490.595177] RSP: 0018:ffffa822000c7e80 EFLAGS: 00000202 ORIG_RAX: ffffffffffffffdc
[76490.595179] RAX: ffff9472debdad80 RBX: ffffffffb2c46c60 RCX: 0000000000000000
[76490.595180] RDX: 0000000000000000 RSI: 000000001fe490a5 RDI: 0000000000000000
[76490.595181] RBP: 000045915ab6ecec R08: 000045915abdc516 R09: 00000000000003a7
[76490.595182] R10: ffff9472debd9f00 R11: ffff9472debd9ee0 R12: ffff9470c892b000
[76490.595183] R13: 0000000000000002 R14: 000045915abdc516 R15: 0000000000000000
[76490.595185]  cpuidle_enter+0x24/0x40
[76490.595187]  do_idle+0x1b8/0x200
[76490.595189]  cpu_startup_entry+0x14/0x20
[76490.595191]  start_secondary+0x14d/0x180
[76490.595193]  secondary_startup_64+0xa4/0xb0
[76490.596010] TRACE skbuff_ext_cache alloc 0x00000000a5d0b721 inuse=32 fp=0x00000000cb688f98
[76490.596012] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.596013] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.596014] Call Trace:
[76490.596015]  <IRQ>
[76490.596017]  dump_stack+0x46/0x68
[76490.596019]  alloc_debug_processing.cold+0x6c/0x71
[76490.596021]  ___slab_alloc.constprop.0+0x544/0x5a0
[76490.596023]  ? skb_ext_add+0xd5/0x170
[76490.596024]  ? br_pass_frame_up+0x160/0x160
[76490.596026]  ? skb_ext_add+0xd5/0x170
[76490.596028]  kmem_cache_alloc+0x180/0x1a0
[76490.596030]  skb_ext_add+0xd5/0x170
[76490.596032]  br_nf_pre_routing+0x154/0x4d6
[76490.596034]  br_handle_frame+0x19f/0x370
[76490.596036]  ? br_pass_frame_up+0x160/0x160
[76490.596038]  __netif_receive_skb_core+0x2ae/0xc80
[76490.596040]  __netif_receive_skb_one_core+0x37/0x90
[76490.596042]  netif_receive_skb_internal+0x3b/0xb0
[76490.596043]  napi_gro_receive+0x4b/0x90
[76490.596045]  rtl8169_poll+0x220/0x640
[76490.596046]  net_rx_action+0x110/0x2d0
[76490.596049]  __do_softirq+0xd7/0x21f
[76490.596051]  irq_exit+0x9b/0xa0
[76490.596053]  do_IRQ+0x49/0xd0
[76490.596054]  common_interrupt+0xf/0xf
[76490.596056]  </IRQ>
[76490.596058] RIP: 0010:cpuidle_enter_state+0x120/0x2a0
[76490.596060] Code: e8 c5 27 75 ff 31 ff 49 89 c6 e8 ab 31 75 ff 45 84 ff 74 12 9c 58 f6 c4 02 0f 85 6b 01 00 00 31 ff e8 c4 2d 79 ff fb 45 85 ed <0f> 88 c3 00 00 00 49 63 cd 4c 89 f6 48 8d 04 49 48 29 ee 48 c1 e0
[76490.596061] RSP: 0018:ffffa822000c7e80 EFLAGS: 00000202 ORIG_RAX: ffffffffffffffdc
[76490.596062] RAX: ffff9472debdad80 RBX: ffffffffb2c46c60 RCX: 0000000000000000
[76490.596064] RDX: 0000000000000000 RSI: 000000001fe490a5 RDI: 0000000000000000
[76490.596065] RBP: 000045915acc81c8 R08: 000045915acdb719 R09: 0000000000000181
[76490.596066] R10: ffff9472debd9f00 R11: ffff9472debd9ee0 R12: ffff9470c892b000
[76490.596067] R13: 0000000000000002 R14: 000045915acdb719 R15: 0000000000000000
[76490.596069]  cpuidle_enter+0x24/0x40
[76490.596071]  do_idle+0x1b8/0x200
[76490.596073]  cpu_startup_entry+0x14/0x20
[76490.596075]  start_secondary+0x14d/0x180
[76490.596076]  secondary_startup_64+0xa4/0xb0
[76490.596085] TRACE skbuff_ext_cache free 0x00000000a5d0b721 inuse=7 fp=0x000000000791dd0f
[76490.596086] Object 00000000a5d0b721: e6 37 93 ad b0 dd a2 b9 00 00 00 00 00 00 00 00  .7..............
[76490.596088] Object 00000000c4337319: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.596089] Object 00000000086ffbd2: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.596091] Object 0000000047ea7a71: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.596092] Object 000000000d563d84: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.596093] Object 00000000312a4ac6: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.596095] Object 0000000063f9c762: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.596096] Object 000000008bf815ef: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.596098] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.596099] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.596100] Call Trace:
[76490.596101]  <IRQ>
[76490.596103]  dump_stack+0x46/0x68
[76490.596105]  free_debug_processing.cold+0x55/0x14b
[76490.596107]  ? skb_release_all+0xc/0x30
[76490.596108]  ? skb_release_all+0xc/0x30
[76490.596110]  __slab_free+0x1f0/0x350
[76490.596112]  ? tcp_xmit_retransmit_queue.part.0+0x158/0x260
[76490.596114]  ? tcp_ack+0x8f0/0x1280
[76490.596115]  ? skb_release_all+0xc/0x30
[76490.596117]  kmem_cache_free+0x1e8/0x200
[76490.596119]  skb_release_all+0xc/0x30
[76490.596121]  __kfree_skb+0xc/0x20
[76490.596122]  tcp_data_queue+0x76a/0xc20
[76490.596124]  tcp_rcv_established+0x1d4/0x5f0
[76490.596126]  tcp_v4_do_rcv+0x136/0x1f0
[76490.596128]  tcp_v4_rcv+0xa5d/0xb50
[76490.596129]  ? br_pass_frame_up+0x160/0x160
[76490.596131]  ip_protocol_deliver_rcu+0x26/0x1b0
[76490.596133]  ip_local_deliver_finish+0x4b/0x60
[76490.596134]  ip_local_deliver+0xf4/0x100
[76490.596136]  ? ip_protocol_deliver_rcu+0x1b0/0x1b0
[76490.596138]  ip_sabotage_in+0x5f/0x70
[76490.596140]  nf_hook_slow+0x38/0xa0
[76490.596142]  ip_rcv+0x9f/0xe0
[76490.596143]  ? ip_rcv_finish_core.isra.0+0x340/0x340
[76490.596145]  __netif_receive_skb_one_core+0x81/0x90
[76490.596147]  netif_receive_skb_internal+0x3b/0xb0
[76490.596149]  br_pass_frame_up+0x142/0x160
[76490.596151]  ? br_add_if.cold+0x37/0x37
[76490.596152]  br_handle_frame_finish+0x322/0x440
[76490.596154]  br_nf_hook_thresh+0xf0/0x100
[76490.596156]  ? br_pass_frame_up+0x160/0x160
[76490.596158]  br_nf_pre_routing_finish+0x14e/0x320
[76490.596160]  ? br_pass_frame_up+0x160/0x160
[76490.596162]  br_nf_pre_routing+0x22c/0x4d6
[76490.596164]  ? br_nf_forward_ip+0x490/0x490
[76490.596165]  br_handle_frame+0x19f/0x370
[76490.596167]  ? br_pass_frame_up+0x160/0x160
[76490.596169]  __netif_receive_skb_core+0x2ae/0xc80
[76490.596171]  __netif_receive_skb_one_core+0x37/0x90
[76490.596173]  netif_receive_skb_internal+0x3b/0xb0
[76490.596175]  napi_gro_receive+0x4b/0x90
[76490.596176]  rtl8169_poll+0x220/0x640
[76490.596178]  net_rx_action+0x110/0x2d0
[76490.596180]  __do_softirq+0xd7/0x21f
[76490.596182]  irq_exit+0x9b/0xa0
[76490.596184]  do_IRQ+0x49/0xd0
[76490.596186]  common_interrupt+0xf/0xf
[76490.596187]  </IRQ>
[76490.596189] RIP: 0010:cpuidle_enter_state+0x120/0x2a0
[76490.596191] Code: e8 c5 27 75 ff 31 ff 49 89 c6 e8 ab 31 75 ff 45 84 ff 74 12 9c 58 f6 c4 02 0f 85 6b 01 00 00 31 ff e8 c4 2d 79 ff fb 45 85 ed <0f> 88 c3 00 00 00 49 63 cd 4c 89 f6 48 8d 04 49 48 29 ee 48 c1 e0
[76490.596192] RSP: 0018:ffffa822000c7e80 EFLAGS: 00000202 ORIG_RAX: ffffffffffffffdc
[76490.596194] RAX: ffff9472debdad80 RBX: ffffffffb2c46c60 RCX: 0000000000000000
[76490.596195] RDX: 0000000000000000 RSI: 000000001fe490a5 RDI: 0000000000000000
[76490.596196] RBP: 000045915acc81c8 R08: 000045915acdb719 R09: 0000000000000181
[76490.596197] R10: ffff9472debd9f00 R11: ffff9472debd9ee0 R12: ffff9470c892b000
[76490.596198] R13: 0000000000000002 R14: 000045915acdb719 R15: 0000000000000000
[76490.596201]  cpuidle_enter+0x24/0x40
[76490.596202]  do_idle+0x1b8/0x200
[76490.596204]  cpu_startup_entry+0x14/0x20
[76490.596206]  start_secondary+0x14d/0x180
[76490.596208]  secondary_startup_64+0xa4/0xb0
[76490.597359] TRACE skbuff_ext_cache alloc 0x00000000a5d0b721 inuse=32 fp=0x00000000cb688f98
[76490.597361] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.597363] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.597364] Call Trace:
[76490.597365]  <IRQ>
[76490.597367]  dump_stack+0x46/0x68
[76490.597369]  alloc_debug_processing.cold+0x6c/0x71
[76490.597371]  ___slab_alloc.constprop.0+0x544/0x5a0
[76490.597374]  ? skb_ext_add+0xd5/0x170
[76490.597376]  ? br_dev_xmit+0x254/0x3c0
[76490.597378]  ? skb_ext_add+0xd5/0x170
[76490.597380]  kmem_cache_alloc+0x180/0x1a0
[76490.597382]  skb_ext_add+0xd5/0x170
[76490.597386]  br_nf_pre_routing+0x154/0x4d6
[76490.597389]  br_handle_frame+0x19f/0x370
[76490.597392]  ? br_pass_frame_up+0x160/0x160
[76490.597398]  __netif_receive_skb_core+0x2ae/0xc80
[76490.597402]  ? cpumask_next+0x1a/0x20
[76490.597405]  __netif_receive_skb_one_core+0x37/0x90
[76490.597408]  netif_receive_skb_internal+0x3b/0xb0
[76490.597410]  napi_gro_receive+0x4b/0x90
[76490.597411]  rtl8169_poll+0x220/0x640
[76490.597413]  net_rx_action+0x110/0x2d0
[76490.597415]  __do_softirq+0xd7/0x21f
[76490.597417]  irq_exit+0x9b/0xa0
[76490.597419]  do_IRQ+0x49/0xd0
[76490.597421]  common_interrupt+0xf/0xf
[76490.597422]  </IRQ>
[76490.597424] RIP: 0010:cpuidle_enter_state+0x120/0x2a0
[76490.597426] Code: e8 c5 27 75 ff 31 ff 49 89 c6 e8 ab 31 75 ff 45 84 ff 74 12 9c 58 f6 c4 02 0f 85 6b 01 00 00 31 ff e8 c4 2d 79 ff fb 45 85 ed <0f> 88 c3 00 00 00 49 63 cd 4c 89 f6 48 8d 04 49 48 29 ee 48 c1 e0
[76490.597428] RSP: 0018:ffffa822000c7e80 EFLAGS: 00000202 ORIG_RAX: ffffffffffffffdc
[76490.597429] RAX: ffff9472debdad80 RBX: ffffffffb2c46c60 RCX: 0000000000000000
[76490.597431] RDX: 0000000000000000 RSI: 000000001fe490a5 RDI: 0000000000000000
[76490.597432] RBP: 000045915adf42e5 R08: 000045915ae24ccc R09: 0000000000000174
[76490.597433] R10: ffff9472debd9f00 R11: ffff9472debd9ee0 R12: ffff9470c892b000
[76490.597434] R13: 0000000000000002 R14: 000045915ae24ccc R15: 0000000000000000
[76490.597437]  cpuidle_enter+0x24/0x40
[76490.597439]  do_idle+0x1b8/0x200
[76490.597441]  cpu_startup_entry+0x14/0x20
[76490.597442]  start_secondary+0x14d/0x180
[76490.597444]  secondary_startup_64+0xa4/0xb0
[76490.597896] TRACE skbuff_ext_cache alloc 0x0000000023accf91 inuse=32 fp=0x00000000cb688f98
[76490.597898] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.597899] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.597900] Call Trace:
[76490.597902]  <IRQ>
[76490.597904]  dump_stack+0x46/0x68
[76490.597905]  alloc_debug_processing.cold+0x6c/0x71
[76490.597907]  ___slab_alloc.constprop.0+0x544/0x5a0
[76490.597909]  ? skb_ext_add+0xd5/0x170
[76490.597911]  ? __dev_queue_xmit+0x3bf/0x7d0
[76490.597913]  ? skb_ext_add+0xd5/0x170
[76490.597915]  kmem_cache_alloc+0x180/0x1a0
[76490.597917]  skb_ext_add+0xd5/0x170
[76490.597919]  br_nf_pre_routing+0x154/0x4d6
[76490.597921]  ? ip_output+0x6d/0x100
[76490.597923]  br_handle_frame+0x19f/0x370
[76490.597925]  ? br_pass_frame_up+0x160/0x160
[76490.597927]  __netif_receive_skb_core+0x2ae/0xc80
[76490.597929]  __netif_receive_skb_one_core+0x37/0x90
[76490.597931]  netif_receive_skb_internal+0x3b/0xb0
[76490.597933]  napi_gro_receive+0x4b/0x90
[76490.597934]  rtl8169_poll+0x220/0x640
[76490.597936]  net_rx_action+0x110/0x2d0
[76490.597938]  __do_softirq+0xd7/0x21f
[76490.597940]  irq_exit+0x9b/0xa0
[76490.597942]  do_IRQ+0x49/0xd0
[76490.597943]  common_interrupt+0xf/0xf
[76490.597945]  </IRQ>
[76490.597947] RIP: 0010:cpuidle_enter_state+0x120/0x2a0
[76490.597949] Code: e8 c5 27 75 ff 31 ff 49 89 c6 e8 ab 31 75 ff 45 84 ff 74 12 9c 58 f6 c4 02 0f 85 6b 01 00 00 31 ff e8 c4 2d 79 ff fb 45 85 ed <0f> 88 c3 00 00 00 49 63 cd 4c 89 f6 48 8d 04 49 48 29 ee 48 c1 e0
[76490.597950] RSP: 0018:ffffa822000c7e80 EFLAGS: 00000202 ORIG_RAX: ffffffffffffffdc
[76490.597952] RAX: ffff9472debdad80 RBX: ffffffffb2c46c60 RCX: 0000000000000000
[76490.597953] RDX: 0000000000000000 RSI: 000000001fe490a5 RDI: 0000000000000000
[76490.597954] RBP: 000045915ae8cad2 R08: 000045915aea7f11 R09: 0000000000000174
[76490.597955] R10: ffff9472debd9f00 R11: ffff9472debd9ee0 R12: ffff9470c892b000
[76490.597956] R13: 0000000000000002 R14: 000045915aea7f11 R15: 0000000000000000
[76490.597959]  cpuidle_enter+0x24/0x40
[76490.597960]  do_idle+0x1b8/0x200
[76490.597962]  cpu_startup_entry+0x14/0x20
[76490.597964]  start_secondary+0x14d/0x180
[76490.597966]  secondary_startup_64+0xa4/0xb0
[76490.598859] TRACE skbuff_ext_cache alloc 0x000000000791dd0f inuse=32 fp=0x00000000cb688f98
[76490.598862] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.598863] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.598865] Call Trace:
[76490.598866]  <IRQ>
[76490.598869]  dump_stack+0x46/0x68
[76490.598871]  alloc_debug_processing.cold+0x6c/0x71
[76490.598873]  ___slab_alloc.constprop.0+0x544/0x5a0
[76490.598876]  ? skb_ext_add+0xd5/0x170
[76490.598877]  ? br_pass_frame_up+0x160/0x160
[76490.598879]  ? skb_ext_add+0xd5/0x170
[76490.598881]  kmem_cache_alloc+0x180/0x1a0
[76490.598883]  skb_ext_add+0xd5/0x170
[76490.598885]  br_nf_pre_routing+0x154/0x4d6
[76490.598888]  ? br_nf_forward_ip+0x490/0x490
[76490.598889]  br_handle_frame+0x19f/0x370
[76490.598891]  ? br_pass_frame_up+0x160/0x160
[76490.598893]  __netif_receive_skb_core+0x2ae/0xc80
[76490.598895]  __netif_receive_skb_one_core+0x37/0x90
[76490.598897]  netif_receive_skb_internal+0x3b/0xb0
[76490.598899]  napi_gro_receive+0x4b/0x90
[76490.598901]  rtl8169_poll+0x220/0x640
[76490.598902]  net_rx_action+0x110/0x2d0
[76490.598905]  __do_softirq+0xd7/0x21f
[76490.598907]  irq_exit+0x9b/0xa0
[76490.598909]  do_IRQ+0x49/0xd0
[76490.598910]  common_interrupt+0xf/0xf
[76490.598912]  </IRQ>
[76490.598914] RIP: 0010:acpi_idle_do_entry+0x3c/0x50
[76490.598916] Code: 04 ec 48 8b 15 a9 c9 6a 01 ed 5d c3 65 48 8b 04 25 c0 14 01 00 48 8b 00 a8 08 75 ee e9 07 00 00 00 0f 00 2d d6 ba 67 00 fb f4 <fa> 5d c3 48 89 ef 5d e9 88 fe ff ff 90 90 90 90 90 90 90 90 41 56
[76490.598917] RSP: 0018:ffffa822000c7e28 EFLAGS: 00000246 ORIG_RAX: ffffffffffffffdc
[76490.598919] RAX: 0000000080004000 RBX: 0000000000000001 RCX: 0000000000000034
[76490.598920] RDX: 4ec4ec4ec4ec4ec5 RSI: ffffffffb2c46c60 RDI: ffff946d7a570064
[76490.598921] RBP: ffff946d7a570064 R08: 000045915aec4a62 R09: 0000000000000062
[76490.598922] R10: ffff9472debd9f00 R11: ffff9472debd9ee0 R12: 0000000000000001
[76490.598923] R13: 0000000000000001 R14: ffff946d7a570064 R15: 0000000000000000
[76490.598926]  acpi_idle_enter+0xe1/0x2a0
[76490.598928]  ? tick_nohz_get_sleep_length+0x6b/0xa0
[76490.598930]  cpuidle_enter_state+0xe7/0x2a0
[76490.598932]  cpuidle_enter+0x24/0x40
[76490.598934]  do_idle+0x1b8/0x200
[76490.598936]  cpu_startup_entry+0x14/0x20
[76490.598938]  start_secondary+0x14d/0x180
[76490.598939]  secondary_startup_64+0xa4/0xb0
[76490.598960] TRACE skbuff_ext_cache free 0x000000000791dd0f inuse=9 fp=0x000000003942577c
[76490.598962] Object 000000000791dd0f: e6 33 93 ad b0 dd a2 b9 00 00 00 00 00 00 00 00  .3..............
[76490.598963] Object 000000001bd28b95: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.598965] Object 0000000020862df3: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.598966] Object 00000000565b05a8: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.598968] Object 000000000bcfa0ab: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.598969] Object 000000005f151721: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.598970] Object 00000000d67b3719: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.598971] Object 000000002579589e: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.598973] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.598974] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.598975] Call Trace:
[76490.598976]  <IRQ>
[76490.598978]  dump_stack+0x46/0x68
[76490.598980]  free_debug_processing.cold+0x55/0x14b
[76490.598982]  ? skb_release_all+0xc/0x30
[76490.598984]  ? skb_release_all+0xc/0x30
[76490.598986]  __slab_free+0x1f0/0x350
[76490.598988]  ? tcp_xmit_retransmit_queue.part.0+0x158/0x260
[76490.598989]  ? tcp_ack+0x8f0/0x1280
[76490.598991]  ? skb_release_all+0xc/0x30
[76490.598993]  kmem_cache_free+0x1e8/0x200
[76490.598995]  skb_release_all+0xc/0x30
[76490.598997]  __kfree_skb+0xc/0x20
[76490.598998]  tcp_data_queue+0x76a/0xc20
[76490.599000]  tcp_rcv_established+0x1d4/0x5f0
[76490.599002]  tcp_v4_do_rcv+0x136/0x1f0
[76490.599004]  tcp_v4_rcv+0xa5d/0xb50
[76490.599006]  ? br_pass_frame_up+0x160/0x160
[76490.599007]  ip_protocol_deliver_rcu+0x26/0x1b0
[76490.599009]  ip_local_deliver_finish+0x4b/0x60
[76490.599011]  ip_local_deliver+0xf4/0x100
[76490.599012]  ? ip_protocol_deliver_rcu+0x1b0/0x1b0
[76490.599014]  ip_sabotage_in+0x5f/0x70
[76490.599016]  nf_hook_slow+0x38/0xa0
[76490.599018]  ip_rcv+0x9f/0xe0
[76490.599020]  ? ip_rcv_finish_core.isra.0+0x340/0x340
[76490.599022]  __netif_receive_skb_one_core+0x81/0x90
[76490.599024]  netif_receive_skb_internal+0x3b/0xb0
[76490.599026]  br_pass_frame_up+0x142/0x160
[76490.599027]  ? br_add_if.cold+0x37/0x37
[76490.599029]  br_handle_frame_finish+0x322/0x440
[76490.599031]  br_nf_hook_thresh+0xf0/0x100
[76490.599033]  ? br_pass_frame_up+0x160/0x160
[76490.599035]  br_nf_pre_routing_finish+0x14e/0x320
[76490.599036]  ? br_pass_frame_up+0x160/0x160
[76490.599038]  br_nf_pre_routing+0x22c/0x4d6
[76490.599040]  ? br_nf_forward_ip+0x490/0x490
[76490.599042]  br_handle_frame+0x19f/0x370
[76490.599043]  ? br_pass_frame_up+0x160/0x160
[76490.599045]  __netif_receive_skb_core+0x2ae/0xc80
[76490.599048]  __netif_receive_skb_one_core+0x37/0x90
[76490.599050]  netif_receive_skb_internal+0x3b/0xb0
[76490.599051]  napi_gro_receive+0x4b/0x90
[76490.599053]  rtl8169_poll+0x220/0x640
[76490.599054]  net_rx_action+0x110/0x2d0
[76490.599057]  __do_softirq+0xd7/0x21f
[76490.599059]  irq_exit+0x9b/0xa0
[76490.599060]  do_IRQ+0x49/0xd0
[76490.599062]  common_interrupt+0xf/0xf
[76490.599063]  </IRQ>
[76490.599065] RIP: 0010:acpi_idle_do_entry+0x3c/0x50
[76490.599067] Code: 04 ec 48 8b 15 a9 c9 6a 01 ed 5d c3 65 48 8b 04 25 c0 14 01 00 48 8b 00 a8 08 75 ee e9 07 00 00 00 0f 00 2d d6 ba 67 00 fb f4 <fa> 5d c3 48 89 ef 5d e9 88 fe ff ff 90 90 90 90 90 90 90 90 41 56
[76490.599068] RSP: 0018:ffffa822000c7e28 EFLAGS: 00000246 ORIG_RAX: ffffffffffffffdc
[76490.599070] RAX: 0000000080004000 RBX: 0000000000000001 RCX: 0000000000000034
[76490.599071] RDX: 4ec4ec4ec4ec4ec5 RSI: ffffffffb2c46c60 RDI: ffff946d7a570064
[76490.599072] RBP: ffff946d7a570064 R08: 000045915aec4a62 R09: 0000000000000062
[76490.599073] R10: ffff9472debd9f00 R11: ffff9472debd9ee0 R12: 0000000000000001
[76490.599074] R13: 0000000000000001 R14: ffff946d7a570064 R15: 0000000000000000
[76490.599077]  acpi_idle_enter+0xe1/0x2a0
[76490.599079]  ? tick_nohz_get_sleep_length+0x6b/0xa0
[76490.599081]  cpuidle_enter_state+0xe7/0x2a0
[76490.599082]  cpuidle_enter+0x24/0x40
[76490.599084]  do_idle+0x1b8/0x200
[76490.599086]  cpu_startup_entry+0x14/0x20
[76490.599088]  start_secondary+0x14d/0x180
[76490.599089]  secondary_startup_64+0xa4/0xb0
[76490.599150] TRACE skbuff_ext_cache alloc 0x000000000791dd0f inuse=32 fp=0x00000000cb688f98
[76490.599152] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.599153] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.599154] Call Trace:
[76490.599155]  <IRQ>
[76490.599157]  dump_stack+0x46/0x68
[76490.599159]  alloc_debug_processing.cold+0x6c/0x71
[76490.599161]  ___slab_alloc.constprop.0+0x544/0x5a0
[76490.599163]  ? skb_ext_add+0xd5/0x170
[76490.599165]  ? br_pass_frame_up+0x160/0x160
[76490.599167]  ? skb_ext_add+0xd5/0x170
[76490.599168]  kmem_cache_alloc+0x180/0x1a0
[76490.599170]  skb_ext_add+0xd5/0x170
[76490.599173]  br_nf_pre_routing+0x154/0x4d6
[76490.599175]  ? br_nf_forward_ip+0x490/0x490
[76490.599176]  br_handle_frame+0x19f/0x370
[76490.599178]  ? br_pass_frame_up+0x160/0x160
[76490.599180]  __netif_receive_skb_core+0x2ae/0xc80
[76490.599182]  __netif_receive_skb_one_core+0x37/0x90
[76490.599184]  netif_receive_skb_internal+0x3b/0xb0
[76490.599186]  napi_gro_receive+0x4b/0x90
[76490.599187]  rtl8169_poll+0x220/0x640
[76490.599189]  net_rx_action+0x110/0x2d0
[76490.599191]  __do_softirq+0xd7/0x21f
[76490.599193]  irq_exit+0x9b/0xa0
[76490.599195]  do_IRQ+0x49/0xd0
[76490.599196]  common_interrupt+0xf/0xf
[76490.599198]  </IRQ>
[76490.599199] RIP: 0010:acpi_idle_do_entry+0x3c/0x50
[76490.599201] Code: 04 ec 48 8b 15 a9 c9 6a 01 ed 5d c3 65 48 8b 04 25 c0 14 01 00 48 8b 00 a8 08 75 ee e9 07 00 00 00 0f 00 2d d6 ba 67 00 fb f4 <fa> 5d c3 48 89 ef 5d e9 88 fe ff ff 90 90 90 90 90 90 90 90 41 56
[76490.599202] RSP: 0018:ffffa822000c7e28 EFLAGS: 00000246 ORIG_RAX: ffffffffffffffdc
[76490.599204] RAX: 0000000080004000 RBX: 0000000000000001 RCX: 0000000000000034
[76490.599205] RDX: 4ec4ec4ec4ec4ec5 RSI: ffffffffb2c46c60 RDI: ffff946d7a570064
[76490.599206] RBP: ffff946d7a570064 R08: 000045915afd305a R09: 00000000000000d8
[76490.599207] R10: ffff9472debd9f00 R11: ffff9472debd9ee0 R12: 0000000000000001
[76490.599208] R13: 0000000000000001 R14: ffff946d7a570064 R15: 0000000000000000
[76490.599211]  acpi_idle_enter+0xe1/0x2a0
[76490.599213]  ? tick_nohz_get_sleep_length+0x6b/0xa0
[76490.599215]  cpuidle_enter_state+0xe7/0x2a0
[76490.599216]  cpuidle_enter+0x24/0x40
[76490.599218]  do_idle+0x1b8/0x200
[76490.599220]  cpu_startup_entry+0x14/0x20
[76490.599222]  start_secondary+0x14d/0x180
[76490.599223]  secondary_startup_64+0xa4/0xb0
[76490.600831] TRACE skbuff_ext_cache alloc 0x00000000006a95c1 inuse=32 fp=0x00000000cb688f98
[76490.600834] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.600836] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.600837] Call Trace:
[76490.600839]  <IRQ>
[76490.600842]  dump_stack+0x46/0x68
[76490.600845]  alloc_debug_processing.cold+0x6c/0x71
[76490.600847]  ___slab_alloc.constprop.0+0x544/0x5a0
[76490.600849]  ? skb_ext_add+0xd5/0x170
[76490.600852]  ? br_dev_xmit+0x254/0x3c0
[76490.600854]  ? skb_ext_add+0xd5/0x170
[76490.600856]  kmem_cache_alloc+0x180/0x1a0
[76490.600858]  skb_ext_add+0xd5/0x170
[76490.600860]  br_nf_pre_routing+0x154/0x4d6
[76490.600862]  br_handle_frame+0x19f/0x370
[76490.600864]  ? br_pass_frame_up+0x160/0x160
[76490.600866]  __netif_receive_skb_core+0x2ae/0xc80
[76490.600868]  ? cpumask_next+0x1a/0x20
[76490.600870]  __netif_receive_skb_one_core+0x37/0x90
[76490.600873]  netif_receive_skb_internal+0x3b/0xb0
[76490.600874]  napi_gro_receive+0x4b/0x90
[76490.600876]  rtl8169_poll+0x220/0x640
[76490.600878]  net_rx_action+0x110/0x2d0
[76490.600880]  __do_softirq+0xd7/0x21f
[76490.600882]  irq_exit+0x9b/0xa0
[76490.600884]  do_IRQ+0x49/0xd0
[76490.600886]  common_interrupt+0xf/0xf
[76490.600888]  </IRQ>
[76490.600890] RIP: 0010:cpuidle_enter_state+0x120/0x2a0
[76490.600892] Code: e8 c5 27 75 ff 31 ff 49 89 c6 e8 ab 31 75 ff 45 84 ff 74 12 9c 58 f6 c4 02 0f 85 6b 01 00 00 31 ff e8 c4 2d 79 ff fb 45 85 ed <0f> 88 c3 00 00 00 49 63 cd 4c 89 f6 48 8d 04 49 48 29 ee 48 c1 e0
[76490.600894] RSP: 0018:ffffa822000c7e80 EFLAGS: 00000202 ORIG_RAX: ffffffffffffffdc
[76490.600895] RAX: ffff9472debdad80 RBX: ffffffffb2c46c60 RCX: 0000000000000000
[76490.600897] RDX: 0000000000000000 RSI: 000000001fe490a5 RDI: 0000000000000000
[76490.600898] RBP: 000045915b0d9aef R08: 000045915b173d78 R09: 0000000000000224
[76490.600899] R10: ffff9472debd9f00 R11: ffff9472debd9ee0 R12: ffff9470c892b000
[76490.600900] R13: 0000000000000002 R14: 000045915b173d78 R15: 0000000000000000
[76490.600903]  cpuidle_enter+0x24/0x40
[76490.600905]  do_idle+0x1b8/0x200
[76490.600907]  cpu_startup_entry+0x14/0x20
[76490.600909]  start_secondary+0x14d/0x180
[76490.600911]  secondary_startup_64+0xa4/0xb0
[76490.601523] TRACE skbuff_ext_cache alloc 0x000000003942577c inuse=32 fp=0x00000000cb688f98
[76490.601526] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.601527] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.601528] Call Trace:
[76490.601530]  <IRQ>
[76490.601532]  dump_stack+0x46/0x68
[76490.601534]  alloc_debug_processing.cold+0x6c/0x71
[76490.601537]  ___slab_alloc.constprop.0+0x544/0x5a0
[76490.601539]  ? skb_ext_add+0xd5/0x170
[76490.601541]  ? br_pass_frame_up+0x160/0x160
[76490.601543]  ? skb_ext_add+0xd5/0x170
[76490.601545]  kmem_cache_alloc+0x180/0x1a0
[76490.601547]  skb_ext_add+0xd5/0x170
[76490.601549]  br_nf_pre_routing+0x154/0x4d6
[76490.601551]  ? br_nf_forward_ip+0x490/0x490
[76490.601552]  br_handle_frame+0x19f/0x370
[76490.601554]  ? br_pass_frame_up+0x160/0x160
[76490.601556]  __netif_receive_skb_core+0x2ae/0xc80
[76490.601559]  ? __wake_up_common_lock+0x86/0xb0
[76490.601561]  __netif_receive_skb_one_core+0x37/0x90
[76490.601563]  netif_receive_skb_internal+0x3b/0xb0
[76490.601564]  napi_gro_receive+0x4b/0x90
[76490.601566]  rtl8169_poll+0x220/0x640
[76490.601568]  net_rx_action+0x110/0x2d0
[76490.601570]  __do_softirq+0xd7/0x21f
[76490.601572]  irq_exit+0x9b/0xa0
[76490.601574]  do_IRQ+0x49/0xd0
[76490.601576]  common_interrupt+0xf/0xf
[76490.601577]  </IRQ>
[76490.601580] RIP: 0010:cpuidle_enter_state+0x120/0x2a0
[76490.601582] Code: e8 c5 27 75 ff 31 ff 49 89 c6 e8 ab 31 75 ff 45 84 ff 74 12 9c 58 f6 c4 02 0f 85 6b 01 00 00 31 ff e8 c4 2d 79 ff fb 45 85 ed <0f> 88 c3 00 00 00 49 63 cd 4c 89 f6 48 8d 04 49 48 29 ee 48 c1 e0
[76490.601583] RSP: 0018:ffffa822000c7e80 EFLAGS: 00000202 ORIG_RAX: ffffffffffffffdc
[76490.601585] RAX: ffff9472debdad80 RBX: ffffffffb2c46c60 RCX: 0000000000000000
[76490.601586] RDX: 0000000000000000 RSI: 000000001fe490a5 RDI: 0000000000000000
[76490.601587] RBP: 000045915b19a9e6 R08: 000045915b21cdb4 R09: 0000000000000212
[76490.601588] R10: ffff9472debd9f00 R11: ffff9472debd9ee0 R12: ffff9470c892b000
[76490.601589] R13: 0000000000000002 R14: 000045915b21cdb4 R15: 0000000000000000
[76490.601592]  cpuidle_enter+0x24/0x40
[76490.601594]  do_idle+0x1b8/0x200
[76490.601596]  cpu_startup_entry+0x14/0x20
[76490.601597]  start_secondary+0x14d/0x180
[76490.601599]  secondary_startup_64+0xa4/0xb0
[76490.601797] TRACE skbuff_ext_cache alloc 0x0000000084b967b5 inuse=32 fp=0x00000000cb688f98
[76490.601799] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.601801] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.601802] Call Trace:
[76490.601803]  <IRQ>
[76490.601805]  dump_stack+0x46/0x68
[76490.601807]  alloc_debug_processing.cold+0x6c/0x71
[76490.601809]  ___slab_alloc.constprop.0+0x544/0x5a0
[76490.601811]  ? skb_ext_add+0xd5/0x170
[76490.601813]  ? br_pass_frame_up+0x160/0x160
[76490.601815]  ? skb_ext_add+0xd5/0x170
[76490.601817]  kmem_cache_alloc+0x180/0x1a0
[76490.601819]  skb_ext_add+0xd5/0x170
[76490.601821]  br_nf_pre_routing+0x154/0x4d6
[76490.601823]  ? br_nf_forward_ip+0x490/0x490
[76490.601825]  br_handle_frame+0x19f/0x370
[76490.601826]  ? br_pass_frame_up+0x160/0x160
[76490.601828]  __netif_receive_skb_core+0x2ae/0xc80
[76490.601830]  ? __wake_up_common_lock+0x86/0xb0
[76490.601832]  __netif_receive_skb_one_core+0x37/0x90
[76490.601834]  netif_receive_skb_internal+0x3b/0xb0
[76490.601836]  napi_gro_receive+0x4b/0x90
[76490.601837]  rtl8169_poll+0x220/0x640
[76490.601839]  net_rx_action+0x110/0x2d0
[76490.601841]  __do_softirq+0xd7/0x21f
[76490.601843]  irq_exit+0x9b/0xa0
[76490.601845]  do_IRQ+0x49/0xd0
[76490.601847]  common_interrupt+0xf/0xf
[76490.601848]  </IRQ>
[76490.601850] RIP: 0010:cpuidle_enter_state+0x120/0x2a0
[76490.601852] Code: e8 c5 27 75 ff 31 ff 49 89 c6 e8 ab 31 75 ff 45 84 ff 74 12 9c 58 f6 c4 02 0f 85 6b 01 00 00 31 ff e8 c4 2d 79 ff fb 45 85 ed <0f> 88 c3 00 00 00 49 63 cd 4c 89 f6 48 8d 04 49 48 29 ee 48 c1 e0
[76490.601853] RSP: 0018:ffffa822000c7e80 EFLAGS: 00000202 ORIG_RAX: ffffffffffffffdc
[76490.601855] RAX: ffff9472debdad80 RBX: ffffffffb2c46c60 RCX: 0000000000000000
[76490.601856] RDX: 0000000000000000 RSI: 000000001fe490a5 RDI: 0000000000000000
[76490.601857] RBP: 000045915b25ccb0 R08: 000045915b2605c5 R09: 0000000000000212
[76490.601858] R10: ffff9472debd9f00 R11: ffff9472debd9ee0 R12: ffff9470c892b000
[76490.601859] R13: 0000000000000002 R14: 000045915b2605c5 R15: 0000000000000000
[76490.601862]  cpuidle_enter+0x24/0x40
[76490.601864]  do_idle+0x1b8/0x200
[76490.601865]  cpu_startup_entry+0x14/0x20
[76490.601867]  start_secondary+0x14d/0x180
[76490.601869]  secondary_startup_64+0xa4/0xb0
[76490.601878] TRACE skbuff_ext_cache alloc 0x0000000071510478 inuse=32 fp=0x00000000cb688f98
[76490.601880] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.601881] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.601882] Call Trace:
[76490.601883]  <IRQ>
[76490.601885]  dump_stack+0x46/0x68
[76490.601887]  alloc_debug_processing.cold+0x6c/0x71
[76490.601889]  ___slab_alloc.constprop.0+0x544/0x5a0
[76490.601891]  ? skb_ext_add+0xd5/0x170
[76490.601893]  ? br_pass_frame_up+0x160/0x160
[76490.601895]  ? skb_ext_add+0xd5/0x170
[76490.601897]  kmem_cache_alloc+0x180/0x1a0
[76490.601898]  skb_ext_add+0xd5/0x170
[76490.601901]  br_nf_pre_routing+0x154/0x4d6
[76490.601903]  ? br_nf_forward_ip+0x490/0x490
[76490.601904]  br_handle_frame+0x19f/0x370
[76490.601906]  ? br_pass_frame_up+0x160/0x160
[76490.601908]  __netif_receive_skb_core+0x2ae/0xc80
[76490.601910]  ? __wake_up_common_lock+0x86/0xb0
[76490.601912]  __netif_receive_skb_one_core+0x37/0x90
[76490.601914]  netif_receive_skb_internal+0x3b/0xb0
[76490.601915]  napi_gro_receive+0x4b/0x90
[76490.601917]  rtl8169_poll+0x220/0x640
[76490.601919]  net_rx_action+0x110/0x2d0
[76490.601921]  __do_softirq+0xd7/0x21f
[76490.601923]  irq_exit+0x9b/0xa0
[76490.601924]  do_IRQ+0x49/0xd0
[76490.601926]  common_interrupt+0xf/0xf
[76490.601927]  </IRQ>
[76490.601929] RIP: 0010:cpuidle_enter_state+0x120/0x2a0
[76490.601931] Code: e8 c5 27 75 ff 31 ff 49 89 c6 e8 ab 31 75 ff 45 84 ff 74 12 9c 58 f6 c4 02 0f 85 6b 01 00 00 31 ff e8 c4 2d 79 ff fb 45 85 ed <0f> 88 c3 00 00 00 49 63 cd 4c 89 f6 48 8d 04 49 48 29 ee 48 c1 e0
[76490.601932] RSP: 0018:ffffa822000c7e80 EFLAGS: 00000202 ORIG_RAX: ffffffffffffffdc
[76490.601934] RAX: ffff9472debdad80 RBX: ffffffffb2c46c60 RCX: 0000000000000000
[76490.601935] RDX: 0000000000000000 RSI: 000000001fe490a5 RDI: 0000000000000000
[76490.601936] RBP: 000045915b25ccb0 R08: 000045915b2605c5 R09: 0000000000000212
[76490.601937] R10: ffff9472debd9f00 R11: ffff9472debd9ee0 R12: ffff9470c892b000
[76490.601939] R13: 0000000000000002 R14: 000045915b2605c5 R15: 0000000000000000
[76490.601941]  cpuidle_enter+0x24/0x40
[76490.601943]  do_idle+0x1b8/0x200
[76490.601945]  cpu_startup_entry+0x14/0x20
[76490.601946]  start_secondary+0x14d/0x180
[76490.601948]  secondary_startup_64+0xa4/0xb0
[76490.602629] TRACE skbuff_ext_cache alloc 0x00000000910e4c96 inuse=32 fp=0x00000000cb688f98
[76490.602631] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.602633] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.602634] Call Trace:
[76490.602635]  <IRQ>
[76490.602638]  dump_stack+0x46/0x68
[76490.602640]  alloc_debug_processing.cold+0x6c/0x71
[76490.602642]  ___slab_alloc.constprop.0+0x544/0x5a0
[76490.602644]  ? skb_ext_add+0xd5/0x170
[76490.602646]  ? br_pass_frame_up+0x160/0x160
[76490.602648]  ? skb_ext_add+0xd5/0x170
[76490.602650]  kmem_cache_alloc+0x180/0x1a0
[76490.602652]  skb_ext_add+0xd5/0x170
[76490.602654]  br_nf_pre_routing+0x154/0x4d6
[76490.602656]  ? br_nf_forward_ip+0x490/0x490
[76490.602658]  br_handle_frame+0x19f/0x370
[76490.602659]  ? br_pass_frame_up+0x160/0x160
[76490.602662]  __netif_receive_skb_core+0x2ae/0xc80
[76490.602664]  __netif_receive_skb_one_core+0x37/0x90
[76490.602666]  netif_receive_skb_internal+0x3b/0xb0
[76490.602668]  napi_gro_receive+0x4b/0x90
[76490.602669]  rtl8169_poll+0x220/0x640
[76490.602671]  net_rx_action+0x110/0x2d0
[76490.602673]  __do_softirq+0xd7/0x21f
[76490.602675]  irq_exit+0x9b/0xa0
[76490.602677]  do_IRQ+0x49/0xd0
[76490.602679]  common_interrupt+0xf/0xf
[76490.602680]  </IRQ>
[76490.602682] RIP: 0010:acpi_idle_do_entry+0x3c/0x50
[76490.602684] Code: 04 ec 48 8b 15 a9 c9 6a 01 ed 5d c3 65 48 8b 04 25 c0 14 01 00 48 8b 00 a8 08 75 ee e9 07 00 00 00 0f 00 2d d6 ba 67 00 fb f4 <fa> 5d c3 48 89 ef 5d e9 88 fe ff ff 90 90 90 90 90 90 90 90 41 56
[76490.602686] RSP: 0018:ffffa822000c7e28 EFLAGS: 00000246 ORIG_RAX: ffffffffffffffdc
[76490.602688] RAX: 0000000080004000 RBX: 0000000000000001 RCX: 0000000000000034
[76490.602689] RDX: 4ec4ec4ec4ec4ec5 RSI: ffffffffb2c46c60 RDI: ffff946d7a570064
[76490.602690] RBP: ffff946d7a570064 R08: 000045915b295fa3 R09: 0000000000000212
[76490.602691] R10: ffff9472debd9f00 R11: ffff9472debd9ee0 R12: 0000000000000001
[76490.602692] R13: 0000000000000001 R14: ffff946d7a570064 R15: 0000000000000000
[76490.602695]  acpi_idle_enter+0xe1/0x2a0
[76490.602697]  ? tick_nohz_get_sleep_length+0x6b/0xa0
[76490.602699]  cpuidle_enter_state+0xe7/0x2a0
[76490.602701]  cpuidle_enter+0x24/0x40
[76490.602703]  do_idle+0x1b8/0x200
[76490.602704]  cpu_startup_entry+0x14/0x20
[76490.602706]  start_secondary+0x14d/0x180
[76490.602708]  secondary_startup_64+0xa4/0xb0
[76490.602723] TRACE skbuff_ext_cache free 0x00000000910e4c96 inuse=14 fp=0x0000000071dfcd4c
[76490.602725] Object 00000000910e4c96: 66 33 93 ad b0 dd a2 b9 00 00 00 00 00 00 00 00  f3..............
[76490.602726] Object 000000004642f523: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.602728] Object 000000002cbfa797: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.602729] Object 00000000d018177c: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.602730] Object 000000007e1ed34a: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.602731] Object 0000000087222ec4: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.602733] Object 000000002c08d395: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.602734] Object 000000004d4e971f: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.602736] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.602737] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.602738] Call Trace:
[76490.602739]  <IRQ>
[76490.602741]  dump_stack+0x46/0x68
[76490.602743]  free_debug_processing.cold+0x55/0x14b
[76490.602745]  ? skb_release_all+0xc/0x30
[76490.602746]  ? skb_release_all+0xc/0x30
[76490.602748]  __slab_free+0x1f0/0x350
[76490.602750]  ? tcp_xmit_retransmit_queue.part.0+0x158/0x260
[76490.602752]  ? tcp_ack+0x8f0/0x1280
[76490.602754]  ? skb_release_all+0xc/0x30
[76490.602756]  kmem_cache_free+0x1e8/0x200
[76490.602758]  skb_release_all+0xc/0x30
[76490.602759]  __kfree_skb+0xc/0x20
[76490.602761]  tcp_data_queue+0x76a/0xc20
[76490.602763]  tcp_rcv_established+0x1d4/0x5f0
[76490.602765]  tcp_v4_do_rcv+0x136/0x1f0
[76490.602766]  tcp_v4_rcv+0xa5d/0xb50
[76490.602768]  ? br_pass_frame_up+0x160/0x160
[76490.602770]  ip_protocol_deliver_rcu+0x26/0x1b0
[76490.602772]  ip_local_deliver_finish+0x4b/0x60
[76490.602773]  ip_local_deliver+0xf4/0x100
[76490.602775]  ? ip_protocol_deliver_rcu+0x1b0/0x1b0
[76490.602777]  ip_sabotage_in+0x5f/0x70
[76490.602779]  nf_hook_slow+0x38/0xa0
[76490.602781]  ip_rcv+0x9f/0xe0
[76490.602782]  ? ip_rcv_finish_core.isra.0+0x340/0x340
[76490.602784]  __netif_receive_skb_one_core+0x81/0x90
[76490.602786]  netif_receive_skb_internal+0x3b/0xb0
[76490.602788]  br_pass_frame_up+0x142/0x160
[76490.602790]  ? br_add_if.cold+0x37/0x37
[76490.602791]  br_handle_frame_finish+0x322/0x440
[76490.602793]  br_nf_hook_thresh+0xf0/0x100
[76490.602795]  ? br_pass_frame_up+0x160/0x160
[76490.602797]  br_nf_pre_routing_finish+0x14e/0x320
[76490.602799]  ? br_pass_frame_up+0x160/0x160
[76490.602801]  br_nf_pre_routing+0x22c/0x4d6
[76490.602803]  ? br_nf_forward_ip+0x490/0x490
[76490.602804]  br_handle_frame+0x19f/0x370
[76490.602806]  ? br_pass_frame_up+0x160/0x160
[76490.602808]  __netif_receive_skb_core+0x2ae/0xc80
[76490.602810]  __netif_receive_skb_one_core+0x37/0x90
[76490.602813]  netif_receive_skb_internal+0x3b/0xb0
[76490.602814]  napi_gro_receive+0x4b/0x90
[76490.602816]  rtl8169_poll+0x220/0x640
[76490.602817]  net_rx_action+0x110/0x2d0
[76490.602819]  __do_softirq+0xd7/0x21f
[76490.602821]  irq_exit+0x9b/0xa0
[76490.602823]  do_IRQ+0x49/0xd0
[76490.602825]  common_interrupt+0xf/0xf
[76490.602826]  </IRQ>
[76490.602828] RIP: 0010:acpi_idle_do_entry+0x3c/0x50
[76490.602830] Code: 04 ec 48 8b 15 a9 c9 6a 01 ed 5d c3 65 48 8b 04 25 c0 14 01 00 48 8b 00 a8 08 75 ee e9 07 00 00 00 0f 00 2d d6 ba 67 00 fb f4 <fa> 5d c3 48 89 ef 5d e9 88 fe ff ff 90 90 90 90 90 90 90 90 41 56
[76490.602832] RSP: 0018:ffffa822000c7e28 EFLAGS: 00000246 ORIG_RAX: ffffffffffffffdc
[76490.602833] RAX: 0000000080004000 RBX: 0000000000000001 RCX: 0000000000000034
[76490.602834] RDX: 4ec4ec4ec4ec4ec5 RSI: ffffffffb2c46c60 RDI: ffff946d7a570064
[76490.602836] RBP: ffff946d7a570064 R08: 000045915b295fa3 R09: 0000000000000212
[76490.602837] R10: ffff9472debd9f00 R11: ffff9472debd9ee0 R12: 0000000000000001
[76490.602838] R13: 0000000000000001 R14: ffff946d7a570064 R15: 0000000000000000
[76490.602840]  acpi_idle_enter+0xe1/0x2a0
[76490.602842]  ? tick_nohz_get_sleep_length+0x6b/0xa0
[76490.602844]  cpuidle_enter_state+0xe7/0x2a0
[76490.602846]  cpuidle_enter+0x24/0x40
[76490.602848]  do_idle+0x1b8/0x200
[76490.602850]  cpu_startup_entry+0x14/0x20
[76490.602852]  start_secondary+0x14d/0x180
[76490.602853]  secondary_startup_64+0xa4/0xb0
[76490.603306] TRACE skbuff_ext_cache alloc 0x00000000910e4c96 inuse=32 fp=0x00000000cb688f98
[76490.603308] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.603310] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.603311] Call Trace:
[76490.603312]  <IRQ>
[76490.603314]  dump_stack+0x46/0x68
[76490.603316]  alloc_debug_processing.cold+0x6c/0x71
[76490.603318]  ___slab_alloc.constprop.0+0x544/0x5a0
[76490.603320]  ? skb_ext_add+0xd5/0x170
[76490.603322]  ? br_dev_xmit+0x254/0x3c0
[76490.603324]  ? skb_ext_add+0xd5/0x170
[76490.603326]  kmem_cache_alloc+0x180/0x1a0
[76490.603328]  skb_ext_add+0xd5/0x170
[76490.603330]  br_nf_pre_routing+0x154/0x4d6
[76490.603332]  br_handle_frame+0x19f/0x370
[76490.603333]  ? br_pass_frame_up+0x160/0x160
[76490.603335]  __netif_receive_skb_core+0x2ae/0xc80
[76490.603338]  __netif_receive_skb_one_core+0x37/0x90
[76490.603340]  netif_receive_skb_internal+0x3b/0xb0
[76490.603341]  napi_gro_receive+0x4b/0x90
[76490.603343]  rtl8169_poll+0x220/0x640
[76490.603344]  net_rx_action+0x110/0x2d0
[76490.603347]  __do_softirq+0xd7/0x21f
[76490.603349]  irq_exit+0x9b/0xa0
[76490.603350]  do_IRQ+0x49/0xd0
[76490.603352]  common_interrupt+0xf/0xf
[76490.603353]  </IRQ>
[76490.603355] RIP: 0010:acpi_idle_do_entry+0x3c/0x50
[76490.603357] Code: 04 ec 48 8b 15 a9 c9 6a 01 ed 5d c3 65 48 8b 04 25 c0 14 01 00 48 8b 00 a8 08 75 ee e9 07 00 00 00 0f 00 2d d6 ba 67 00 fb f4 <fa> 5d c3 48 89 ef 5d e9 88 fe ff ff 90 90 90 90 90 90 90 90 41 56
[76490.603359] RSP: 0018:ffffa822000c7e28 EFLAGS: 00000246 ORIG_RAX: ffffffffffffffdc
[76490.603360] RAX: 0000000080004000 RBX: 0000000000000001 RCX: 0000000000000034
[76490.603362] RDX: 4ec4ec4ec4ec4ec5 RSI: ffffffffb2c46c60 RDI: ffff946d7a570064
[76490.603363] RBP: ffff946d7a570064 R08: 000045915b3c9005 R09: 000000000000010c
[76490.603364] R10: ffff9472debd9f00 R11: ffff9472debd9ee0 R12: 0000000000000001
[76490.603365] R13: 0000000000000001 R14: ffff946d7a570064 R15: 0000000000000000
[76490.603367]  acpi_idle_enter+0xe1/0x2a0
[76490.603369]  ? tick_nohz_get_sleep_length+0x6b/0xa0
[76490.603371]  cpuidle_enter_state+0xe7/0x2a0
[76490.603373]  cpuidle_enter+0x24/0x40
[76490.603375]  do_idle+0x1b8/0x200
[76490.603377]  cpu_startup_entry+0x14/0x20
[76490.603379]  start_secondary+0x14d/0x180
[76490.603380]  secondary_startup_64+0xa4/0xb0
[76490.603413] TRACE skbuff_ext_cache alloc 0x00000000ec70464c inuse=32 fp=0x00000000cb688f98
[76490.603415] CPU: 7 PID: 1802 Comm: transmission-da Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.603416] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.603417] Call Trace:
[76490.603419]  <IRQ>
[76490.603421]  dump_stack+0x46/0x68
[76490.603422]  alloc_debug_processing.cold+0x6c/0x71
[76490.603425]  ___slab_alloc.constprop.0+0x544/0x5a0
[76490.603427]  ? skb_ext_add+0xd5/0x170
[76490.603428]  ? br_pass_frame_up+0x160/0x160
[76490.603430]  ? skb_ext_add+0xd5/0x170
[76490.603432]  kmem_cache_alloc+0x180/0x1a0
[76490.603435]  skb_ext_add+0xd5/0x170
[76490.603438]  br_nf_pre_routing+0x154/0x4d6
[76490.603440]  ? br_nf_forward_ip+0x490/0x490
[76490.603442]  br_handle_frame+0x19f/0x370
[76490.603448]  ? br_pass_frame_up+0x160/0x160
[76490.603453]  __netif_receive_skb_core+0x2ae/0xc80
[76490.603456]  __netif_receive_skb_one_core+0x37/0x90
[76490.603458]  netif_receive_skb_internal+0x3b/0xb0
[76490.603460]  napi_gro_receive+0x4b/0x90
[76490.603462]  rtl8169_poll+0x220/0x640
[76490.603463]  net_rx_action+0x110/0x2d0
[76490.603466]  __do_softirq+0xd7/0x21f
[76490.603468]  irq_exit+0x9b/0xa0
[76490.603470]  do_IRQ+0x49/0xd0
[76490.603471]  common_interrupt+0xf/0xf
[76490.603472]  </IRQ>
[76490.603474] RIP: 0033:0x60679723fedb
[76490.603476] Code: 8b 93 58 02 00 00 48 8b b3 50 02 00 00 0f b7 c5 48 85 d2 74 7d 48 21 f0 4c 8b 24 c2 4d 85 e4 74 71 41 f7 44 24 18 ff ff ff 7f <74> 08 41 80 7c 24 1b 00 79 5e 49 8b 74 24 08 48 89 df e8 8e fd ff
[76490.603477] RSP: 002b:000071c3fdc604e0 EFLAGS: 00000202 ORIG_RAX: ffffffffffffffdc
[76490.603479] RAX: 000000000000002c RBX: 000075e7a1da4900 RCX: 00000000000034b2
[76490.603480] RDX: 0000762562b46200 RSI: 000000000000007f RDI: 000071c3fdc604e0
[76490.603481] RBP: 00000000000034ac R08: 0000000000000000 R09: 00000000000034b1
[76490.603482] R10: 0000000000000000 R11: 000073278bf17448 R12: 00007635a2c19e00
[76490.603483] R13: 0000000000000566 R14: 00007635a2f78600 R15: 000075e7a1da4900
[76490.603492] TRACE skbuff_ext_cache free 0x00000000ec70464c inuse=15 fp=0x0000000071dfcd4c
[76490.603494] Object 00000000ec70464c: 66 3e 93 ad b0 dd a2 b9 00 00 00 00 00 00 00 00  f>..............
[76490.603495] Object 000000000746fb74: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.603496] Object 00000000d8be4c43: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.603498] Object 0000000019ae3f30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.603499] Object 00000000b2fe550c: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.603500] Object 000000005f1f8258: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.603502] Object 000000001eb78ff6: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.603503] Object 000000009d57e761: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.603505] CPU: 7 PID: 1802 Comm: transmission-da Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.603506] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.603507] Call Trace:
[76490.603508]  <IRQ>
[76490.603510]  dump_stack+0x46/0x68
[76490.603512]  free_debug_processing.cold+0x55/0x14b
[76490.603514]  ? skb_release_all+0xc/0x30
[76490.603516]  ? skb_release_all+0xc/0x30
[76490.603518]  __slab_free+0x1f0/0x350
[76490.603519]  ? tcp_xmit_retransmit_queue.part.0+0x158/0x260
[76490.603521]  ? tcp_ack+0x8f0/0x1280
[76490.603523]  ? skb_release_all+0xc/0x30
[76490.603525]  kmem_cache_free+0x1e8/0x200
[76490.603527]  skb_release_all+0xc/0x30
[76490.603528]  __kfree_skb+0xc/0x20
[76490.603530]  tcp_data_queue+0x76a/0xc20
[76490.603532]  tcp_rcv_established+0x1d4/0x5f0
[76490.603534]  tcp_v4_do_rcv+0x136/0x1f0
[76490.603535]  tcp_v4_rcv+0xa5d/0xb50
[76490.603537]  ? br_pass_frame_up+0x160/0x160
[76490.603539]  ip_protocol_deliver_rcu+0x26/0x1b0
[76490.603540]  ip_local_deliver_finish+0x4b/0x60
[76490.603542]  ip_local_deliver+0xf4/0x100
[76490.603543]  ? ip_protocol_deliver_rcu+0x1b0/0x1b0
[76490.603545]  ip_sabotage_in+0x5f/0x70
[76490.603547]  nf_hook_slow+0x38/0xa0
[76490.603549]  ip_rcv+0x9f/0xe0
[76490.603550]  ? ip_rcv_finish_core.isra.0+0x340/0x340
[76490.603552]  __netif_receive_skb_one_core+0x81/0x90
[76490.603555]  netif_receive_skb_internal+0x3b/0xb0
[76490.603556]  br_pass_frame_up+0x142/0x160
[76490.603558]  ? br_add_if.cold+0x37/0x37
[76490.603560]  br_handle_frame_finish+0x322/0x440
[76490.603562]  br_nf_hook_thresh+0xf0/0x100
[76490.603563]  ? br_pass_frame_up+0x160/0x160
[76490.603565]  br_nf_pre_routing_finish+0x14e/0x320
[76490.603567]  ? br_pass_frame_up+0x160/0x160
[76490.603569]  br_nf_pre_routing+0x22c/0x4d6
[76490.603571]  ? br_nf_forward_ip+0x490/0x490
[76490.603573]  br_handle_frame+0x19f/0x370
[76490.603574]  ? br_pass_frame_up+0x160/0x160
[76490.603576]  __netif_receive_skb_core+0x2ae/0xc80
[76490.603579]  __netif_receive_skb_one_core+0x37/0x90
[76490.603581]  netif_receive_skb_internal+0x3b/0xb0
[76490.603582]  napi_gro_receive+0x4b/0x90
[76490.603584]  rtl8169_poll+0x220/0x640
[76490.603585]  net_rx_action+0x110/0x2d0
[76490.603587]  __do_softirq+0xd7/0x21f
[76490.603589]  irq_exit+0x9b/0xa0
[76490.603591]  do_IRQ+0x49/0xd0
[76490.603593]  common_interrupt+0xf/0xf
[76490.603594]  </IRQ>
[76490.603596] RIP: 0033:0x60679723fedb
[76490.603597] Code: 8b 93 58 02 00 00 48 8b b3 50 02 00 00 0f b7 c5 48 85 d2 74 7d 48 21 f0 4c 8b 24 c2 4d 85 e4 74 71 41 f7 44 24 18 ff ff ff 7f <74> 08 41 80 7c 24 1b 00 79 5e 49 8b 74 24 08 48 89 df e8 8e fd ff
[76490.603598] RSP: 002b:000071c3fdc604e0 EFLAGS: 00000202 ORIG_RAX: ffffffffffffffdc
[76490.603600] RAX: 000000000000002c RBX: 000075e7a1da4900 RCX: 00000000000034b2
[76490.603601] RDX: 0000762562b46200 RSI: 000000000000007f RDI: 000071c3fdc604e0
[76490.603602] RBP: 00000000000034ac R08: 0000000000000000 R09: 00000000000034b1
[76490.603603] R10: 0000000000000000 R11: 000073278bf17448 R12: 00007635a2c19e00
[76490.603604] R13: 0000000000000566 R14: 00007635a2f78600 R15: 000075e7a1da4900
[76490.603614] TRACE skbuff_ext_cache alloc 0x00000000ec70464c inuse=32 fp=0x00000000cb688f98
[76490.603616] CPU: 7 PID: 1802 Comm: transmission-da Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.603618] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.603619] Call Trace:
[76490.603620]  <IRQ>
[76490.603622]  dump_stack+0x46/0x68
[76490.603624]  alloc_debug_processing.cold+0x6c/0x71
[76490.603626]  ___slab_alloc.constprop.0+0x544/0x5a0
[76490.603628]  ? skb_ext_add+0xd5/0x170
[76490.603629]  ? br_pass_frame_up+0x160/0x160
[76490.603631]  ? skb_ext_add+0xd5/0x170
[76490.603633]  kmem_cache_alloc+0x180/0x1a0
[76490.603635]  skb_ext_add+0xd5/0x170
[76490.603637]  br_nf_pre_routing+0x154/0x4d6
[76490.603639]  ? br_nf_forward_ip+0x490/0x490
[76490.603641]  br_handle_frame+0x19f/0x370
[76490.603643]  ? br_pass_frame_up+0x160/0x160
[76490.603645]  __netif_receive_skb_core+0x2ae/0xc80
[76490.603647]  __netif_receive_skb_one_core+0x37/0x90
[76490.603649]  netif_receive_skb_internal+0x3b/0xb0
[76490.603650]  napi_gro_receive+0x4b/0x90
[76490.603652]  rtl8169_poll+0x220/0x640
[76490.603653]  net_rx_action+0x110/0x2d0
[76490.603656]  __do_softirq+0xd7/0x21f
[76490.603658]  irq_exit+0x9b/0xa0
[76490.603659]  do_IRQ+0x49/0xd0
[76490.603661]  common_interrupt+0xf/0xf
[76490.603662]  </IRQ>
[76490.603664] RIP: 0033:0x60679723fedb
[76490.603666] Code: 8b 93 58 02 00 00 48 8b b3 50 02 00 00 0f b7 c5 48 85 d2 74 7d 48 21 f0 4c 8b 24 c2 4d 85 e4 74 71 41 f7 44 24 18 ff ff ff 7f <74> 08 41 80 7c 24 1b 00 79 5e 49 8b 74 24 08 48 89 df e8 8e fd ff
[76490.603667] RSP: 002b:000071c3fdc604e0 EFLAGS: 00000202 ORIG_RAX: ffffffffffffffdc
[76490.603668] RAX: 000000000000002c RBX: 000075e7a1da4900 RCX: 00000000000034b2
[76490.603670] RDX: 0000762562b46200 RSI: 000000000000007f RDI: 000071c3fdc604e0
[76490.603671] RBP: 00000000000034ac R08: 0000000000000000 R09: 00000000000034b1
[76490.603672] R10: 0000000000000000 R11: 000073278bf17448 R12: 00007635a2c19e00
[76490.603673] R13: 0000000000000566 R14: 00007635a2f78600 R15: 000075e7a1da4900
[76490.603680] TRACE skbuff_ext_cache free 0x00000000ec70464c inuse=15 fp=0x0000000089127560
[76490.603682] Object 00000000ec70464c: 66 3e 93 ad b0 dd a2 b9 00 00 00 00 00 00 00 00  f>..............
[76490.603683] Object 000000000746fb74: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.603685] Object 00000000d8be4c43: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.603686] Object 0000000019ae3f30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.603687] Object 00000000b2fe550c: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.603689] Object 000000005f1f8258: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.603690] Object 000000001eb78ff6: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.603691] Object 000000009d57e761: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.603693] CPU: 7 PID: 1802 Comm: transmission-da Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.603694] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.603695] Call Trace:
[76490.603696]  <IRQ>
[76490.603698]  dump_stack+0x46/0x68
[76490.603700]  free_debug_processing.cold+0x55/0x14b
[76490.603702]  ? skb_release_all+0xc/0x30
[76490.603704]  ? skb_release_all+0xc/0x30
[76490.603706]  __slab_free+0x1f0/0x350
[76490.603707]  ? tcp_xmit_retransmit_queue.part.0+0x158/0x260
[76490.603709]  ? tcp_ack+0x8f0/0x1280
[76490.603711]  ? skb_release_all+0xc/0x30
[76490.603713]  kmem_cache_free+0x1e8/0x200
[76490.603714]  skb_release_all+0xc/0x30
[76490.603716]  __kfree_skb+0xc/0x20
[76490.603718]  tcp_data_queue+0x76a/0xc20
[76490.603720]  tcp_rcv_established+0x1d4/0x5f0
[76490.603721]  tcp_v4_do_rcv+0x136/0x1f0
[76490.603723]  tcp_v4_rcv+0xa5d/0xb50
[76490.603725]  ? br_pass_frame_up+0x160/0x160
[76490.603727]  ip_protocol_deliver_rcu+0x26/0x1b0
[76490.603728]  ip_local_deliver_finish+0x4b/0x60
[76490.603730]  ip_local_deliver+0xf4/0x100
[76490.603732]  ? ip_protocol_deliver_rcu+0x1b0/0x1b0
[76490.603734]  ip_sabotage_in+0x5f/0x70
[76490.603736]  nf_hook_slow+0x38/0xa0
[76490.603737]  ip_rcv+0x9f/0xe0
[76490.603739]  ? ip_rcv_finish_core.isra.0+0x340/0x340
[76490.603741]  __netif_receive_skb_one_core+0x81/0x90
[76490.603743]  netif_receive_skb_internal+0x3b/0xb0
[76490.603745]  br_pass_frame_up+0x142/0x160
[76490.603746]  ? br_add_if.cold+0x37/0x37
[76490.603748]  br_handle_frame_finish+0x322/0x440
[76490.603750]  br_nf_hook_thresh+0xf0/0x100
[76490.603752]  ? br_pass_frame_up+0x160/0x160
[76490.603754]  br_nf_pre_routing_finish+0x14e/0x320
[76490.603755]  ? br_pass_frame_up+0x160/0x160
[76490.603757]  br_nf_pre_routing+0x22c/0x4d6
[76490.603759]  ? br_nf_forward_ip+0x490/0x490
[76490.603761]  br_handle_frame+0x19f/0x370
[76490.603763]  ? br_pass_frame_up+0x160/0x160
[76490.603765]  __netif_receive_skb_core+0x2ae/0xc80
[76490.603767]  __netif_receive_skb_one_core+0x37/0x90
[76490.603769]  netif_receive_skb_internal+0x3b/0xb0
[76490.603771]  napi_gro_receive+0x4b/0x90
[76490.603772]  rtl8169_poll+0x220/0x640
[76490.603774]  net_rx_action+0x110/0x2d0
[76490.603776]  __do_softirq+0xd7/0x21f
[76490.603778]  irq_exit+0x9b/0xa0
[76490.603780]  do_IRQ+0x49/0xd0
[76490.603782]  common_interrupt+0xf/0xf
[76490.603783]  </IRQ>
[76490.603784] RIP: 0033:0x60679723fedb
[76490.603786] Code: 8b 93 58 02 00 00 48 8b b3 50 02 00 00 0f b7 c5 48 85 d2 74 7d 48 21 f0 4c 8b 24 c2 4d 85 e4 74 71 41 f7 44 24 18 ff ff ff 7f <74> 08 41 80 7c 24 1b 00 79 5e 49 8b 74 24 08 48 89 df e8 8e fd ff
[76490.603787] RSP: 002b:000071c3fdc604e0 EFLAGS: 00000202 ORIG_RAX: ffffffffffffffdc
[76490.603789] RAX: 000000000000002c RBX: 000075e7a1da4900 RCX: 00000000000034b2
[76490.603790] RDX: 0000762562b46200 RSI: 000000000000007f RDI: 000071c3fdc604e0
[76490.603791] RBP: 00000000000034ac R08: 0000000000000000 R09: 00000000000034b1
[76490.603792] R10: 0000000000000000 R11: 000073278bf17448 R12: 00007635a2c19e00
[76490.603793] R13: 0000000000000566 R14: 00007635a2f78600 R15: 000075e7a1da4900
[76490.604523] TRACE skbuff_ext_cache alloc 0x00000000ec70464c inuse=32 fp=0x00000000cb688f98
[76490.604525] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.604526] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.604527] Call Trace:
[76490.604528]  <IRQ>
[76490.604530]  dump_stack+0x46/0x68
[76490.604532]  alloc_debug_processing.cold+0x6c/0x71
[76490.604534]  ___slab_alloc.constprop.0+0x544/0x5a0
[76490.604536]  ? skb_ext_add+0xd5/0x170
[76490.604538]  ? br_dev_xmit+0x254/0x3c0
[76490.604540]  ? skb_ext_add+0xd5/0x170
[76490.604542]  kmem_cache_alloc+0x180/0x1a0
[76490.604544]  skb_ext_add+0xd5/0x170
[76490.604546]  br_nf_pre_routing+0x154/0x4d6
[76490.604548]  br_handle_frame+0x19f/0x370
[76490.604549]  ? br_pass_frame_up+0x160/0x160
[76490.604551]  __netif_receive_skb_core+0x2ae/0xc80
[76490.604553]  ? __wake_up_common_lock+0x86/0xb0
[76490.604555]  __netif_receive_skb_one_core+0x37/0x90
[76490.604558]  netif_receive_skb_internal+0x3b/0xb0
[76490.604559]  napi_gro_receive+0x4b/0x90
[76490.604561]  rtl8169_poll+0x220/0x640
[76490.604562]  net_rx_action+0x110/0x2d0
[76490.604564]  __do_softirq+0xd7/0x21f
[76490.604566]  irq_exit+0x9b/0xa0
[76490.604568]  do_IRQ+0x49/0xd0
[76490.604570]  common_interrupt+0xf/0xf
[76490.604571]  </IRQ>
[76490.604573] RIP: 0010:cpuidle_enter_state+0x120/0x2a0
[76490.604575] Code: e8 c5 27 75 ff 31 ff 49 89 c6 e8 ab 31 75 ff 45 84 ff 74 12 9c 58 f6 c4 02 0f 85 6b 01 00 00 31 ff e8 c4 2d 79 ff fb 45 85 ed <0f> 88 c3 00 00 00 49 63 cd 4c 89 f6 48 8d 04 49 48 29 ee 48 c1 e0
[76490.604577] RSP: 0018:ffffa822000c7e80 EFLAGS: 00000202 ORIG_RAX: ffffffffffffffdc
[76490.604578] RAX: ffff9472debdad80 RBX: ffffffffb2c46c60 RCX: 0000000000000000
[76490.604579] RDX: 0000000000000000 RSI: 000000001fe490a5 RDI: 0000000000000000
[76490.604580] RBP: 000045915b4983ec R08: 000045915b4f9dd7 R09: 00000000000000f4
[76490.604582] R10: ffff9472debd9f00 R11: ffff9472debd9ee0 R12: ffff9470c892b000
[76490.604583] R13: 0000000000000002 R14: 000045915b4f9dd7 R15: 0000000000000000
[76490.604586]  cpuidle_enter+0x24/0x40
[76490.604589]  do_idle+0x1b8/0x200
[76490.604593]  cpu_startup_entry+0x14/0x20
[76490.604599]  start_secondary+0x14d/0x180
[76490.604601]  secondary_startup_64+0xa4/0xb0
[76490.605651] TRACE skbuff_ext_cache alloc 0x0000000071dfcd4c inuse=32 fp=0x00000000cb688f98
[76490.605655] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.605656] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.605657] Call Trace:
[76490.605659]  <IRQ>
[76490.605662]  dump_stack+0x46/0x68
[76490.605665]  alloc_debug_processing.cold+0x6c/0x71
[76490.605667]  ___slab_alloc.constprop.0+0x544/0x5a0
[76490.605669]  ? skb_ext_add+0xd5/0x170
[76490.605671]  ? br_pass_frame_up+0x160/0x160
[76490.605673]  ? skb_ext_add+0xd5/0x170
[76490.605675]  kmem_cache_alloc+0x180/0x1a0
[76490.605677]  skb_ext_add+0xd5/0x170
[76490.605679]  br_nf_pre_routing+0x154/0x4d6
[76490.605682]  ? br_nf_forward_ip+0x490/0x490
[76490.605683]  br_handle_frame+0x19f/0x370
[76490.605685]  ? br_pass_frame_up+0x160/0x160
[76490.605687]  __netif_receive_skb_core+0x2ae/0xc80
[76490.605689]  ? __wake_up_common_lock+0x86/0xb0
[76490.605691]  __netif_receive_skb_one_core+0x37/0x90
[76490.605693]  netif_receive_skb_internal+0x3b/0xb0
[76490.605695]  napi_gro_receive+0x4b/0x90
[76490.605697]  rtl8169_poll+0x220/0x640
[76490.605698]  net_rx_action+0x110/0x2d0
[76490.605701]  __do_softirq+0xd7/0x21f
[76490.605703]  irq_exit+0x9b/0xa0
[76490.605705]  do_IRQ+0x49/0xd0
[76490.605707]  common_interrupt+0xf/0xf
[76490.605708]  </IRQ>
[76490.605710] RIP: 0010:cpuidle_enter_state+0x120/0x2a0
[76490.605713] Code: e8 c5 27 75 ff 31 ff 49 89 c6 e8 ab 31 75 ff 45 84 ff 74 12 9c 58 f6 c4 02 0f 85 6b 01 00 00 31 ff e8 c4 2d 79 ff fb 45 85 ed <0f> 88 c3 00 00 00 49 63 cd 4c 89 f6 48 8d 04 49 48 29 ee 48 c1 e0
[76490.605714] RSP: 0018:ffffa822000c7e80 EFLAGS: 00000202 ORIG_RAX: ffffffffffffffdc
[76490.605716] RAX: ffff9472debdad80 RBX: ffffffffb2c46c60 RCX: 0000000000000000
[76490.605717] RDX: 0000000000000000 RSI: 000000001fe490a5 RDI: 0000000000000000
[76490.605718] RBP: 000045915b55b974 R08: 000045915b60c6f5 R09: 00000000000000f4
[76490.605719] R10: ffff9472debd9f00 R11: ffff9472debd9ee0 R12: ffff9470c892b000
[76490.605720] R13: 0000000000000002 R14: 000045915b60c6f5 R15: 0000000000000000
[76490.605723]  cpuidle_enter+0x24/0x40
[76490.605725]  do_idle+0x1b8/0x200
[76490.605727]  cpu_startup_entry+0x14/0x20
[76490.605729]  start_secondary+0x14d/0x180
[76490.605731]  secondary_startup_64+0xa4/0xb0
[76490.605870] TRACE skbuff_ext_cache alloc 0x0000000089127560 inuse=32 fp=0x00000000cb688f98
[76490.605873] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.605874] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.605875] Call Trace:
[76490.605877]  <IRQ>
[76490.605879]  dump_stack+0x46/0x68
[76490.605880]  alloc_debug_processing.cold+0x6c/0x71
[76490.605883]  ___slab_alloc.constprop.0+0x544/0x5a0
[76490.605896]  ? skb_ext_add+0xd5/0x170
[76490.605899]  ? br_pass_frame_up+0x160/0x160
[76490.605901]  ? skb_ext_add+0xd5/0x170
[76490.605903]  kmem_cache_alloc+0x180/0x1a0
[76490.605905]  skb_ext_add+0xd5/0x170
[76490.605907]  br_nf_pre_routing+0x154/0x4d6
[76490.605909]  ? br_nf_forward_ip+0x490/0x490
[76490.605911]  br_handle_frame+0x19f/0x370
[76490.605912]  ? br_pass_frame_up+0x160/0x160
[76490.605914]  __netif_receive_skb_core+0x2ae/0xc80
[76490.605917]  __netif_receive_skb_one_core+0x37/0x90
[76490.605919]  netif_receive_skb_internal+0x3b/0xb0
[76490.605920]  napi_gro_receive+0x4b/0x90
[76490.605922]  rtl8169_poll+0x220/0x640
[76490.605923]  net_rx_action+0x110/0x2d0
[76490.605925]  __do_softirq+0xd7/0x21f
[76490.605927]  irq_exit+0x9b/0xa0
[76490.605929]  do_IRQ+0x49/0xd0
[76490.605931]  common_interrupt+0xf/0xf
[76490.605932]  </IRQ>
[76490.605934] RIP: 0010:acpi_idle_do_entry+0x3c/0x50
[76490.605936] Code: 04 ec 48 8b 15 a9 c9 6a 01 ed 5d c3 65 48 8b 04 25 c0 14 01 00 48 8b 00 a8 08 75 ee e9 07 00 00 00 0f 00 2d d6 ba 67 00 fb f4 <fa> 5d c3 48 89 ef 5d e9 88 fe ff ff 90 90 90 90 90 90 90 90 41 56
[76490.605937] RSP: 0018:ffffa822000c7e28 EFLAGS: 00000246 ORIG_RAX: ffffffffffffffdc
[76490.605939] RAX: 0000000080004000 RBX: 0000000000000001 RCX: 0000000000000034
[76490.605940] RDX: 4ec4ec4ec4ec4ec5 RSI: ffffffffb2c46c60 RDI: ffff946d7a570064
[76490.605941] RBP: ffff946d7a570064 R08: 000045915b63f32a R09: 000000000000012a
[76490.605942] R10: ffff9472debd9f00 R11: ffff9472debd9ee0 R12: 0000000000000001
[76490.605944] R13: 0000000000000001 R14: ffff946d7a570064 R15: 0000000000000000
[76490.605946]  acpi_idle_enter+0xe1/0x2a0
[76490.605948]  ? tick_nohz_get_sleep_length+0x6b/0xa0
[76490.605950]  cpuidle_enter_state+0xe7/0x2a0
[76490.605952]  cpuidle_enter+0x24/0x40
[76490.605954]  do_idle+0x1b8/0x200
[76490.605956]  cpu_startup_entry+0x14/0x20
[76490.605957]  start_secondary+0x14d/0x180
[76490.605959]  secondary_startup_64+0xa4/0xb0
[76490.606005] TRACE skbuff_ext_cache free 0x0000000089127560 inuse=17 fp=0x00000000659a7fb1
[76490.606007] Object 0000000089127560: e6 32 93 ad b0 dd a2 b9 00 00 00 00 00 00 00 00  .2..............
[76490.606009] Object 00000000fe7da010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.606010] Object 000000005f5a4c53: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.606011] Object 0000000091022981: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.606013] Object 000000004f1f47d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.606014] Object 00000000e7e965ca: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.606015] Object 0000000086af8f4a: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.606016] Object 00000000ba7bee5b: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.606018] CPU: 7 PID: 1802 Comm: transmission-da Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.606020] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.606021] Call Trace:
[76490.606023]  dump_stack+0x46/0x68
[76490.606025]  free_debug_processing.cold+0x55/0x14b
[76490.606027]  ? skb_release_all+0xc/0x30
[76490.606029]  ? skb_release_all+0xc/0x30
[76490.606031]  __slab_free+0x1f0/0x350
[76490.606034]  ? __check_object_size+0x91/0x127
[76490.606036]  ? __skb_datagram_iter+0x2a0/0x2a0
[76490.606038]  ? __skb_datagram_iter+0x6b/0x2a0
[76490.606040]  ? __skb_datagram_iter+0x2a0/0x2a0
[76490.606041]  ? skb_release_all+0xc/0x30
[76490.606043]  kmem_cache_free+0x1e8/0x200
[76490.606045]  skb_release_all+0xc/0x30
[76490.606047]  __kfree_skb+0xc/0x20
[76490.606049]  tcp_recvmsg+0x407/0xad0
[76490.606052]  inet_recvmsg+0x6b/0xf0
[76490.606055]  sock_read_iter+0x92/0xf0
[76490.606058]  do_iter_readv_writev+0x1c1/0x1f0
[76490.606060]  do_iter_read+0xed/0x1b0
[76490.606062]  vfs_readv+0xb8/0x100
[76490.606064]  do_readv+0x73/0x120
[76490.606066]  do_syscall_64+0x8a/0x488
[76490.606069]  ? prandom_u32+0x14/0x20
[76490.606070]  ? do_syscall_64+0x2b/0x488
[76490.606072]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[76490.606074] RIP: 0033:0x7e423a2c62cd
[76490.606076] Code: 28 89 54 24 1c 48 89 74 24 10 89 7c 24 08 e8 6a f8 f8 ff 8b 54 24 1c 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 13 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 2f 44 89 c7 48 89 44 24 08 e8 9e f8 f8 ff 48
[76490.606077] RSP: 002b:000071c3fdc61a00 EFLAGS: 00000293 ORIG_RAX: 0000000000000013
[76490.606079] RAX: ffffffffffffffda RBX: 000075683db8a6e0 RCX: 00007e423a2c62cd
[76490.606080] RDX: 0000000000000001 RSI: 000071c3fdc61a40 RDI: 000000000000003f
[76490.606081] RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000044
[76490.606082] R10: 0000000000000fd0 R11: 0000000000000293 R12: 000000000000003f
[76490.606083] R13: 000071c3fdc61a38 R14: 000071c3fdc61a40 R15: 0000606797215270
[76490.606089] TRACE skbuff_ext_cache alloc 0x00000000659a7fb1 inuse=32 fp=0x00000000cb688f98
[76490.606091] CPU: 7 PID: 1802 Comm: transmission-da Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.606092] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.606093] Call Trace:
[76490.606094]  <IRQ>
[76490.606096]  dump_stack+0x46/0x68
[76490.606098]  alloc_debug_processing.cold+0x6c/0x71
[76490.606100]  ___slab_alloc.constprop.0+0x544/0x5a0
[76490.606102]  ? skb_ext_add+0xd5/0x170
[76490.606104]  ? br_pass_frame_up+0x160/0x160
[76490.606106]  ? skb_ext_add+0xd5/0x170
[76490.606108]  kmem_cache_alloc+0x180/0x1a0
[76490.606110]  skb_ext_add+0xd5/0x170
[76490.606112]  br_nf_pre_routing+0x154/0x4d6
[76490.606114]  ? br_nf_forward_ip+0x490/0x490
[76490.606115]  br_handle_frame+0x19f/0x370
[76490.606117]  ? br_pass_frame_up+0x160/0x160
[76490.606119]  __netif_receive_skb_core+0x2ae/0xc80
[76490.606121]  __netif_receive_skb_one_core+0x37/0x90
[76490.606123]  netif_receive_skb_internal+0x3b/0xb0
[76490.606125]  napi_gro_receive+0x4b/0x90
[76490.606126]  rtl8169_poll+0x220/0x640
[76490.606128]  net_rx_action+0x110/0x2d0
[76490.606130]  __do_softirq+0xd7/0x21f
[76490.606132]  irq_exit+0x9b/0xa0
[76490.606134]  do_IRQ+0x49/0xd0
[76490.606136]  common_interrupt+0xf/0xf
[76490.606137]  </IRQ>
[76490.606139] RIP: 0010:_raw_spin_unlock_irqrestore+0xe/0x20
[76490.606141] Code: c1 3e 4e ff ff ff 7f 5b 44 89 e8 5d 41 5c 41 5d 41 5e c3 90 90 90 90 90 90 90 90 90 55 48 89 fd 53 48 89 f3 c6 45 00 00 53 9d <5b> 5d c3 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 53 48 89 fb
[76490.606142] RSP: 0018:ffffa82203a6f968 EFLAGS: 00000282 ORIG_RAX: ffffffffffffffdc
[76490.606144] RAX: 0000000000000001 RBX: 0000000000000282 RCX: 0000000000000006
[76490.606145] RDX: 00000000000000bb RSI: 0000000000000282 RDI: ffff9472db470e80
[76490.606146] RBP: ffff9472db470e80 R08: 0000000000000005 R09: 00000000000f64c8
[76490.606147] R10: 0000000000000058 R11: ffffa82203a6f6d8 R12: ffff946c62f71e00
[76490.606148] R13: ffffffffb1a4f55c R14: ffff9472db4c01c0 R15: ffff946c62f71e00
[76490.606150]  ? skb_release_all+0xc/0x30
[76490.606152]  free_debug_processing+0x1a0/0x1f0
[76490.606154]  ? skb_release_all+0xc/0x30
[76490.606156]  ? skb_release_all+0xc/0x30
[76490.606158]  __slab_free+0x1f0/0x350
[76490.606159]  ? __check_object_size+0x91/0x127
[76490.606162]  ? __skb_datagram_iter+0x2a0/0x2a0
[76490.606163]  ? __skb_datagram_iter+0x6b/0x2a0
[76490.606166]  ? __skb_datagram_iter+0x2a0/0x2a0
[76490.606167]  ? skb_release_all+0xc/0x30
[76490.606169]  kmem_cache_free+0x1e8/0x200
[76490.606171]  skb_release_all+0xc/0x30
[76490.606173]  __kfree_skb+0xc/0x20
[76490.606175]  tcp_recvmsg+0x407/0xad0
[76490.606177]  inet_recvmsg+0x6b/0xf0
[76490.606179]  sock_read_iter+0x92/0xf0
[76490.606181]  do_iter_readv_writev+0x1c1/0x1f0
[76490.606183]  do_iter_read+0xed/0x1b0
[76490.606185]  vfs_readv+0xb8/0x100
[76490.606187]  do_readv+0x73/0x120
[76490.606189]  do_syscall_64+0x8a/0x488
[76490.606191]  ? prandom_u32+0x14/0x20
[76490.606192]  ? do_syscall_64+0x2b/0x488
[76490.606194]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[76490.606196] RIP: 0033:0x7e423a2c62cd
[76490.606197] Code: 28 89 54 24 1c 48 89 74 24 10 89 7c 24 08 e8 6a f8 f8 ff 8b 54 24 1c 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 13 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 2f 44 89 c7 48 89 44 24 08 e8 9e f8 f8 ff 48
[76490.606198] RSP: 002b:000071c3fdc61a00 EFLAGS: 00000293 ORIG_RAX: 0000000000000013
[76490.606200] RAX: ffffffffffffffda RBX: 000075683db8a6e0 RCX: 00007e423a2c62cd
[76490.606201] RDX: 0000000000000001 RSI: 000071c3fdc61a40 RDI: 000000000000003f
[76490.606202] RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000044
[76490.606203] R10: 0000000000000fd0 R11: 0000000000000293 R12: 000000000000003f
[76490.606204] R13: 000071c3fdc61a38 R14: 000071c3fdc61a40 R15: 0000606797215270
[76490.609906] TRACE skbuff_ext_cache alloc 0x0000000089127560 inuse=32 fp=0x00000000cb688f98
[76490.609912] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.609913] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.609915] Call Trace:
[76490.609917]  <IRQ>
[76490.609921]  dump_stack+0x46/0x68
[76490.609924]  alloc_debug_processing.cold+0x6c/0x71
[76490.609927]  ___slab_alloc.constprop.0+0x544/0x5a0
[76490.609930]  ? skb_ext_add+0xd5/0x170
[76490.609933]  ? br_dev_xmit+0x254/0x3c0
[76490.609935]  ? skb_ext_add+0xd5/0x170
[76490.609938]  kmem_cache_alloc+0x180/0x1a0
[76490.609940]  skb_ext_add+0xd5/0x170
[76490.609942]  br_nf_pre_routing+0x154/0x4d6
[76490.609944]  br_handle_frame+0x19f/0x370
[76490.609945]  ? br_pass_frame_up+0x160/0x160
[76490.609948]  __netif_receive_skb_core+0x2ae/0xc80
[76490.609950]  ? cpumask_next+0x1a/0x20
[76490.609952]  __netif_receive_skb_one_core+0x37/0x90
[76490.609954]  netif_receive_skb_internal+0x3b/0xb0
[76490.609956]  napi_gro_receive+0x4b/0x90
[76490.609957]  rtl8169_poll+0x220/0x640
[76490.609959]  net_rx_action+0x110/0x2d0
[76490.609961]  __do_softirq+0xd7/0x21f
[76490.609964]  irq_exit+0x9b/0xa0
[76490.609966]  do_IRQ+0x49/0xd0
[76490.609968]  common_interrupt+0xf/0xf
[76490.609969]  </IRQ>
[76490.609971] RIP: 0010:acpi_idle_do_entry+0x3c/0x50
[76490.609973] Code: 04 ec 48 8b 15 a9 c9 6a 01 ed 5d c3 65 48 8b 04 25 c0 14 01 00 48 8b 00 a8 08 75 ee e9 07 00 00 00 0f 00 2d d6 ba 67 00 fb f4 <fa> 5d c3 48 89 ef 5d e9 88 fe ff ff 90 90 90 90 90 90 90 90 41 56
[76490.609975] RSP: 0018:ffffa822000c7e28 EFLAGS: 00000246 ORIG_RAX: ffffffffffffffdc
[76490.609976] RAX: 0000000080004000 RBX: 0000000000000001 RCX: 0000000000000034
[76490.609978] RDX: 4ec4ec4ec4ec4ec5 RSI: ffffffffb2c46c60 RDI: ffff946d7a570064
[76490.609979] RBP: ffff946d7a570064 R08: 000045915b97f231 R09: 0000000000000048
[76490.609980] R10: ffff9472debd9f00 R11: ffff9472debd9ee0 R12: 0000000000000001
[76490.609981] R13: 0000000000000001 R14: ffff946d7a570064 R15: 0000000000000000
[76490.609984]  acpi_idle_enter+0xe1/0x2a0
[76490.609986]  ? tick_nohz_get_sleep_length+0x6b/0xa0
[76490.609989]  cpuidle_enter_state+0xe7/0x2a0
[76490.609991]  cpuidle_enter+0x24/0x40
[76490.609993]  do_idle+0x1b8/0x200
[76490.609995]  cpu_startup_entry+0x14/0x20
[76490.609997]  start_secondary+0x14d/0x180
[76490.609998]  secondary_startup_64+0xa4/0xb0
[76490.610591] TRACE skbuff_ext_cache alloc 0x000000007c77ee89 inuse=32 fp=0x00000000cb688f98
[76490.610595] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.610596] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.610597] Call Trace:
[76490.610599]  <IRQ>
[76490.610602]  dump_stack+0x46/0x68
[76490.610605]  alloc_debug_processing.cold+0x6c/0x71
[76490.610607]  ___slab_alloc.constprop.0+0x544/0x5a0
[76490.610609]  ? skb_ext_add+0xd5/0x170
[76490.610611]  ? br_pass_frame_up+0x160/0x160
[76490.610613]  ? skb_ext_add+0xd5/0x170
[76490.610615]  kmem_cache_alloc+0x180/0x1a0
[76490.610617]  skb_ext_add+0xd5/0x170
[76490.610620]  br_nf_pre_routing+0x154/0x4d6
[76490.610622]  ? br_nf_forward_ip+0x490/0x490
[76490.610623]  br_handle_frame+0x19f/0x370
[76490.610625]  ? br_pass_frame_up+0x160/0x160
[76490.610627]  __netif_receive_skb_core+0x2ae/0xc80
[76490.610630]  __netif_receive_skb_one_core+0x37/0x90
[76490.610632]  netif_receive_skb_internal+0x3b/0xb0
[76490.610633]  napi_gro_receive+0x4b/0x90
[76490.610635]  rtl8169_poll+0x220/0x640
[76490.610637]  net_rx_action+0x110/0x2d0
[76490.610639]  __do_softirq+0xd7/0x21f
[76490.610642]  irq_exit+0x9b/0xa0
[76490.610644]  do_IRQ+0x49/0xd0
[76490.610646]  common_interrupt+0xf/0xf
[76490.610648]  </IRQ>
[76490.610650] RIP: 0010:acpi_idle_do_entry+0x3c/0x50
[76490.610652] Code: 04 ec 48 8b 15 a9 c9 6a 01 ed 5d c3 65 48 8b 04 25 c0 14 01 00 48 8b 00 a8 08 75 ee e9 07 00 00 00 0f 00 2d d6 ba 67 00 fb f4 <fa> 5d c3 48 89 ef 5d e9 88 fe ff ff 90 90 90 90 90 90 90 90 41 56
[76490.610653] RSP: 0018:ffffa822000c7e28 EFLAGS: 00000246 ORIG_RAX: ffffffffffffffdc
[76490.610655] RAX: 0000000080004000 RBX: 0000000000000001 RCX: 0000000000000034
[76490.610656] RDX: 4ec4ec4ec4ec4ec5 RSI: ffffffffb2c46c60 RDI: ffff946d7a570064
[76490.610657] RBP: ffff946d7a570064 R08: 000045915ba4b108 R09: 00000000000002ef
[76490.610658] R10: ffff9472debd9f00 R11: ffff9472debd9ee0 R12: 0000000000000001
[76490.610659] R13: 0000000000000001 R14: ffff946d7a570064 R15: 0000000000000000
[76490.610662]  acpi_idle_enter+0xe1/0x2a0
[76490.610664]  ? tick_nohz_get_sleep_length+0x6b/0xa0
[76490.610666]  cpuidle_enter_state+0xe7/0x2a0
[76490.610668]  cpuidle_enter+0x24/0x40
[76490.610670]  do_idle+0x1b8/0x200
[76490.610672]  cpu_startup_entry+0x14/0x20
[76490.610674]  start_secondary+0x14d/0x180
[76490.610676]  secondary_startup_64+0xa4/0xb0
[76490.610701] TRACE skbuff_ext_cache free 0x000000007c77ee89 inuse=19 fp=0x0000000016a3c1d0
[76490.610703] Object 000000007c77ee89: e6 35 93 ad b0 dd a2 b9 00 00 00 00 00 00 00 00  .5..............
[76490.610705] Object 0000000051273dda: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.610706] Object 00000000da20373c: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.610707] Object 0000000090d73475: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.610708] Object 00000000c786abf5: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.610710] Object 00000000140d2150: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.610711] Object 000000007bfddb89: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.610712] Object 00000000a262ef77: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.610714] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.610715] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.610716] Call Trace:
[76490.610718]  <IRQ>
[76490.610720]  dump_stack+0x46/0x68
[76490.610722]  free_debug_processing.cold+0x55/0x14b
[76490.610724]  ? skb_release_all+0xc/0x30
[76490.610725]  ? skb_release_all+0xc/0x30
[76490.610727]  __slab_free+0x1f0/0x350
[76490.610729]  ? tcp_xmit_retransmit_queue.part.0+0x158/0x260
[76490.610731]  ? tcp_ack+0x8f0/0x1280
[76490.610733]  ? skb_release_all+0xc/0x30
[76490.610735]  kmem_cache_free+0x1e8/0x200
[76490.610737]  skb_release_all+0xc/0x30
[76490.610738]  __kfree_skb+0xc/0x20
[76490.610740]  tcp_data_queue+0x76a/0xc20
[76490.610744]  tcp_rcv_established+0x1d4/0x5f0
[76490.610747]  tcp_v4_do_rcv+0x136/0x1f0
[76490.610749]  tcp_v4_rcv+0xa5d/0xb50
[76490.610751]  ? br_pass_frame_up+0x160/0x160
[76490.610754]  ip_protocol_deliver_rcu+0x26/0x1b0
[76490.610756]  ip_local_deliver_finish+0x4b/0x60
[76490.610758]  ip_local_deliver+0xf4/0x100
[76490.610760]  ? ip_protocol_deliver_rcu+0x1b0/0x1b0
[76490.610763]  ip_sabotage_in+0x5f/0x70
[76490.610765]  nf_hook_slow+0x38/0xa0
[76490.610767]  ip_rcv+0x9f/0xe0
[76490.610770]  ? ip_rcv_finish_core.isra.0+0x340/0x340
[76490.610772]  __netif_receive_skb_one_core+0x81/0x90
[76490.610775]  netif_receive_skb_internal+0x3b/0xb0
[76490.610777]  br_pass_frame_up+0x142/0x160
[76490.610779]  ? br_add_if.cold+0x37/0x37
[76490.610781]  br_handle_frame_finish+0x322/0x440
[76490.610784]  br_nf_hook_thresh+0xf0/0x100
[76490.610786]  ? br_pass_frame_up+0x160/0x160
[76490.610788]  br_nf_pre_routing_finish+0x14e/0x320
[76490.610790]  ? br_pass_frame_up+0x160/0x160
[76490.610793]  br_nf_pre_routing+0x22c/0x4d6
[76490.610795]  ? br_nf_forward_ip+0x490/0x490
[76490.610796]  br_handle_frame+0x19f/0x370
[76490.610798]  ? br_pass_frame_up+0x160/0x160
[76490.610801]  __netif_receive_skb_core+0x2ae/0xc80
[76490.610803]  __netif_receive_skb_one_core+0x37/0x90
[76490.610806]  netif_receive_skb_internal+0x3b/0xb0
[76490.610807]  napi_gro_receive+0x4b/0x90
[76490.610809]  rtl8169_poll+0x220/0x640
[76490.610811]  net_rx_action+0x110/0x2d0
[76490.610814]  __do_softirq+0xd7/0x21f
[76490.610816]  irq_exit+0x9b/0xa0
[76490.610818]  do_IRQ+0x49/0xd0
[76490.610820]  common_interrupt+0xf/0xf
[76490.610822]  </IRQ>
[76490.610824] RIP: 0010:acpi_idle_do_entry+0x3c/0x50
[76490.610826] Code: 04 ec 48 8b 15 a9 c9 6a 01 ed 5d c3 65 48 8b 04 25 c0 14 01 00 48 8b 00 a8 08 75 ee e9 07 00 00 00 0f 00 2d d6 ba 67 00 fb f4 <fa> 5d c3 48 89 ef 5d e9 88 fe ff ff 90 90 90 90 90 90 90 90 41 56
[76490.610828] RSP: 0018:ffffa822000c7e28 EFLAGS: 00000246 ORIG_RAX: ffffffffffffffdc
[76490.610831] RAX: 0000000080004000 RBX: 0000000000000001 RCX: 0000000000000034
[76490.610832] RDX: 4ec4ec4ec4ec4ec5 RSI: ffffffffb2c46c60 RDI: ffff946d7a570064
[76490.610834] RBP: ffff946d7a570064 R08: 000045915ba4b108 R09: 00000000000002ef
[76490.610835] R10: ffff9472debd9f00 R11: ffff9472debd9ee0 R12: 0000000000000001
[76490.610836] R13: 0000000000000001 R14: ffff946d7a570064 R15: 0000000000000000
[76490.610838]  acpi_idle_enter+0xe1/0x2a0
[76490.610840]  ? tick_nohz_get_sleep_length+0x6b/0xa0
[76490.610843]  cpuidle_enter_state+0xe7/0x2a0
[76490.610844]  cpuidle_enter+0x24/0x40
[76490.610846]  do_idle+0x1b8/0x200
[76490.610848]  cpu_startup_entry+0x14/0x20
[76490.610850]  start_secondary+0x14d/0x180
[76490.610852]  secondary_startup_64+0xa4/0xb0
[76490.610864] TRACE skbuff_ext_cache alloc 0x000000007c77ee89 inuse=32 fp=0x00000000cb688f98
[76490.610866] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.610867] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.610868] Call Trace:
[76490.610869]  <IRQ>
[76490.610871]  dump_stack+0x46/0x68
[76490.610873]  alloc_debug_processing.cold+0x6c/0x71
[76490.610875]  ___slab_alloc.constprop.0+0x544/0x5a0
[76490.610877]  ? skb_ext_add+0xd5/0x170
[76490.610879]  ? br_pass_frame_up+0x160/0x160
[76490.610881]  ? skb_ext_add+0xd5/0x170
[76490.610883]  kmem_cache_alloc+0x180/0x1a0
[76490.610885]  skb_ext_add+0xd5/0x170
[76490.610887]  br_nf_pre_routing+0x154/0x4d6
[76490.610889]  ? br_nf_forward_ip+0x490/0x490
[76490.610890]  br_handle_frame+0x19f/0x370
[76490.610892]  ? br_pass_frame_up+0x160/0x160
[76490.610894]  __netif_receive_skb_core+0x2ae/0xc80
[76490.610896]  __netif_receive_skb_one_core+0x37/0x90
[76490.610898]  netif_receive_skb_internal+0x3b/0xb0
[76490.610900]  napi_gro_receive+0x4b/0x90
[76490.610902]  rtl8169_poll+0x220/0x640
[76490.610903]  net_rx_action+0x110/0x2d0
[76490.610905]  __do_softirq+0xd7/0x21f
[76490.610907]  irq_exit+0x9b/0xa0
[76490.610909]  do_IRQ+0x49/0xd0
[76490.610911]  common_interrupt+0xf/0xf
[76490.610912]  </IRQ>
[76490.610914] RIP: 0010:acpi_idle_do_entry+0x3c/0x50
[76490.610916] Code: 04 ec 48 8b 15 a9 c9 6a 01 ed 5d c3 65 48 8b 04 25 c0 14 01 00 48 8b 00 a8 08 75 ee e9 07 00 00 00 0f 00 2d d6 ba 67 00 fb f4 <fa> 5d c3 48 89 ef 5d e9 88 fe ff ff 90 90 90 90 90 90 90 90 41 56
[76490.610917] RSP: 0018:ffffa822000c7e28 EFLAGS: 00000246 ORIG_RAX: ffffffffffffffdc
[76490.610919] RAX: 0000000080004000 RBX: 0000000000000001 RCX: 0000000000000034
[76490.610920] RDX: 4ec4ec4ec4ec4ec5 RSI: ffffffffb2c46c60 RDI: ffff946d7a570064
[76490.610921] RBP: ffff946d7a570064 R08: 000045915ba4b108 R09: 00000000000002ef
[76490.610922] R10: ffff9472debd9f00 R11: ffff9472debd9ee0 R12: 0000000000000001
[76490.610924] R13: 0000000000000001 R14: ffff946d7a570064 R15: 0000000000000000
[76490.610928]  acpi_idle_enter+0xe1/0x2a0
[76490.610951]  ? tick_nohz_get_sleep_length+0x6b/0xa0
[76490.610955]  cpuidle_enter_state+0xe7/0x2a0
[76490.610958]  cpuidle_enter+0x24/0x40
[76490.610961]  do_idle+0x1b8/0x200
[76490.610964]  cpu_startup_entry+0x14/0x20
[76490.610967]  start_secondary+0x14d/0x180
[76490.610970]  secondary_startup_64+0xa4/0xb0
[76490.610981] TRACE skbuff_ext_cache free 0x000000007c77ee89 inuse=19 fp=0x0000000093b56932
[76490.610983] Object 000000007c77ee89: e6 35 93 ad b0 dd a2 b9 00 00 00 00 00 00 00 00  .5..............
[76490.610985] Object 0000000051273dda: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.610987] Object 00000000da20373c: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.610988] Object 0000000090d73475: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.610990] Object 00000000c786abf5: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.610992] Object 00000000140d2150: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.610993] Object 000000007bfddb89: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.610995] Object 00000000a262ef77: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[76490.610997] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.610999] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.611001] Call Trace:
[76490.611002]  <IRQ>
[76490.611004]  dump_stack+0x46/0x68
[76490.611007]  free_debug_processing.cold+0x55/0x14b
[76490.611010]  ? skb_release_all+0xc/0x30
[76490.611012]  ? skb_release_all+0xc/0x30
[76490.611014]  __slab_free+0x1f0/0x350
[76490.611016]  ? tcp_xmit_retransmit_queue.part.0+0x158/0x260
[76490.611018]  ? tcp_ack+0x8f0/0x1280
[76490.611021]  ? skb_release_all+0xc/0x30
[76490.611023]  kmem_cache_free+0x1e8/0x200
[76490.611026]  skb_release_all+0xc/0x30
[76490.611028]  __kfree_skb+0xc/0x20
[76490.611030]  tcp_data_queue+0x76a/0xc20
[76490.611032]  tcp_rcv_established+0x1d4/0x5f0
[76490.611035]  tcp_v4_do_rcv+0x136/0x1f0
[76490.611037]  tcp_v4_rcv+0xa5d/0xb50
[76490.611039]  ? br_pass_frame_up+0x160/0x160
[76490.611041]  ip_protocol_deliver_rcu+0x26/0x1b0
[76490.611044]  ip_local_deliver_finish+0x4b/0x60
[76490.611046]  ip_local_deliver+0xf4/0x100
[76490.611048]  ? ip_protocol_deliver_rcu+0x1b0/0x1b0
[76490.611051]  ip_sabotage_in+0x5f/0x70
[76490.611053]  nf_hook_slow+0x38/0xa0
[76490.611055]  ip_rcv+0x9f/0xe0
[76490.611057]  ? ip_rcv_finish_core.isra.0+0x340/0x340
[76490.611059]  __netif_receive_skb_one_core+0x81/0x90
[76490.611061]  netif_receive_skb_internal+0x3b/0xb0
[76490.611062]  br_pass_frame_up+0x142/0x160
[76490.611064]  ? br_add_if.cold+0x37/0x37
[76490.611066]  br_handle_frame_finish+0x322/0x440
[76490.611068]  br_nf_hook_thresh+0xf0/0x100
[76490.611070]  ? br_pass_frame_up+0x160/0x160
[76490.611072]  br_nf_pre_routing_finish+0x14e/0x320
[76490.611073]  ? br_pass_frame_up+0x160/0x160
[76490.611075]  br_nf_pre_routing+0x22c/0x4d6
[76490.611077]  ? br_nf_forward_ip+0x490/0x490
[76490.611079]  br_handle_frame+0x19f/0x370
[76490.611081]  ? br_pass_frame_up+0x160/0x160
[76490.611083]  __netif_receive_skb_core+0x2ae/0xc80
[76490.611085]  __netif_receive_skb_one_core+0x37/0x90
[76490.611087]  netif_receive_skb_internal+0x3b/0xb0
[76490.611089]  napi_gro_receive+0x4b/0x90
[76490.611090]  rtl8169_poll+0x220/0x640
[76490.611094]  net_rx_action+0x110/0x2d0
[76490.611097]  __do_softirq+0xd7/0x21f
[76490.611100]  irq_exit+0x9b/0xa0
[76490.611102]  do_IRQ+0x49/0xd0
[76490.611105]  common_interrupt+0xf/0xf
[76490.611106]  </IRQ>
[76490.611108] RIP: 0010:acpi_idle_do_entry+0x3c/0x50
[76490.611111] Code: 04 ec 48 8b 15 a9 c9 6a 01 ed 5d c3 65 48 8b 04 25 c0 14 01 00 48 8b 00 a8 08 75 ee e9 07 00 00 00 0f 00 2d d6 ba 67 00 fb f4 <fa> 5d c3 48 89 ef 5d e9 88 fe ff ff 90 90 90 90 90 90 90 90 41 56
[76490.611112] RSP: 0018:ffffa822000c7e28 EFLAGS: 00000246 ORIG_RAX: ffffffffffffffdc
[76490.611114] RAX: 0000000080004000 RBX: 0000000000000001 RCX: 0000000000000034
[76490.611115] RDX: 4ec4ec4ec4ec4ec5 RSI: ffffffffb2c46c60 RDI: ffff946d7a570064
[76490.611116] RBP: ffff946d7a570064 R08: 000045915ba4b108 R09: 00000000000002ef
[76490.611118] R10: ffff9472debd9f00 R11: ffff9472debd9ee0 R12: 0000000000000001
[76490.611120] R13: 0000000000000001 R14: ffff946d7a570064 R15: 0000000000000000
[76490.611122]  acpi_idle_enter+0xe1/0x2a0
[76490.611125]  ? tick_nohz_get_sleep_length+0x6b/0xa0
[76490.611127]  cpuidle_enter_state+0xe7/0x2a0
[76490.611129]  cpuidle_enter+0x24/0x40
[76490.611131]  do_idle+0x1b8/0x200
[76490.611133]  cpu_startup_entry+0x14/0x20
[76490.611136]  start_secondary+0x14d/0x180
[76490.611137]  secondary_startup_64+0xa4/0xb0
[76490.611143] TRACE skbuff_ext_cache alloc 0x000000007c77ee89 inuse=32 fp=0x00000000cb688f98
[76490.611145] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G                T 5.4.0-rc3-ARCH #2
[76490.611147] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
[76490.611148] Call Trace:
[76490.611150]  <IRQ>
[76490.611152]  dump_stack+0x46/0x68
[76490.611154]  alloc_debug_processing.cold+0x6c/0x71
[76490.611157]  ___slab_alloc.constprop.0+0x544/0x5a0
[76490.611159]  ? skb_ext_add+0xd5/0x170
[76490.611161]  ? br_pass_frame_up+0x160/0x160
[76490.611164]  ? skb_ext_add+0xd5/0x170
[76490.611166]  kmem_cache_alloc+0x180/0x1a0
[76490.611169]  skb_ext_add+0xd5/0x170
[76490.611171]  br_nf_pre_routing+0x154/0x4d6
[76490.611174]  ? br_nf_forward_ip+0x490/0x490
[76490.611176]  br_handle_frame+0x19f/0x370
[76490.611179]  ? br_pass_frame_up+0x160/0x160
[76490.611181]  __netif_receive_skb_core+0x2ae/0xc80
[76490.611183]  __netif_receive_skb_one_core+0x37/0x90
[76490.611185]  netif_receive_skb_internal+0x3b/0xb0
[76490.611187]  napi_gro_receive+0x4b/0x90
[76490.611188]  rtl8169_poll+0x220/0x640
[76490.611190]  net_rx_action+0x110/0x2d0
[76490.611192]  __do_softirq+0xd7/0x21f
[76490.611194]  irq_exit+0x9b/0xa0
[76490.611196]  do_IRQ+0x49/0xd0
[76490.611198]  common_interrupt+0xf/0xf
[76490.611199]  </IRQ>
[76490.611201] RIP: 0010:acpi_idle_do_entry+0x3c/0x50
[76490.611202] Code: 04 ec 48 8b 15 a9 c9 6a 01 ed 5d c3 65 48 8b 04 25 c0 14 01 00 48 8b 00 a8 08 75 ee e9 07 00 00 00 0f 00 2d d6 ba 67 00 fb f4 <fa> 5d c3 48 89 ef 5d e9 88 fe ff ff 90 90 90 90 90 90 90 90 41 56
[76490.611204] RSP: 0018:ffffa822000c7e28 EFLAGS: 00000246 ORIG_RAX: ffffffffffffffdc
[76490.611205] RAX: 0000000080004000 RBX: 0000000000000001 RCX: 0000000000000034
[76490.611206] RDX: 4ec4ec4ec4ec4ec5 RSI: ffffffffb2c46c60 RDI: ffff946d7a570064
[76490.611207] RBP: ffff946d7a570064 R08: 000045915ba4b108 R09: 00000000000002ef
[76490.611209] R10: ffff9472debd9f00 R11: ffff9472debd9ee0 R12: 0000000000000001
[76490.611210] R13: 0000000000000001 R14: ffff946d7a570064 R15: 0000000000000000
[76490.611212]  acpi_idle_enter+0xe1/0x2a0
[76490.611214]  ? tick_nohz_get_sleep_length+0x6b/0xa0
[76490.611216]  cpuidle_enter_state+0xe7/0x2a0
[76490.611218]  cpuidle_enter+0x24/0x40
[76490.611219]  do_idle+0x1b8/0x200
[76490.611221]  cpu_startup_entry+0x14/0x20
[76490.611223]  start_secondary+0x14d/0x180
[76490.611224]  secondary_startup_64+0xa4/0xb0

--MP_/ATeF16.Qk1ukxCl/3HOOUGP--
