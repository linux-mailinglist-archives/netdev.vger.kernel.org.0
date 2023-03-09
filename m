Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38B0E6B2F7D
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 22:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbjCIVVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 16:21:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbjCIVV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 16:21:28 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 718ACFCF13
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 13:21:22 -0800 (PST)
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[IPv6:::1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <ejo@pengutronix.de>)
        id 1paNhQ-0000Jh-Ml; Thu, 09 Mar 2023 22:21:20 +0100
Message-ID: <1ddba1fb34117e1da149eaef5e9f60e4a715e393.camel@pengutronix.de>
Subject: Kernel crashes reproducibly  in __wake_up_common list iteration
From:   Enrico =?ISO-8859-1?Q?J=F6rns?= <ejo@pengutronix.de>
To:     linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Cc:     kernel <kernel@pengutronix.de>, ejo <ejo@pengutronix.de>
Date:   Thu, 09 Mar 2023 22:21:20 +0100
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1+deb11u1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: ejo@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

during network communication on an i.MX6Q I can reproducibly let the kernel
crash with different vanilla kernel versions. The latest tested is 6.2 but
I have also seen the crash on the other kernel versions tested (5.19 and
6.1).

The crash seems to be independent from the FEC since it can be reproduced with
both the i.MX FEC as well as with a USB-to-Ethernet adapter.
The problem triggers unreliably, but always with much network traffic.

With KASAN enabled, I also see a null-ptr-deref BUG right before the crash
happens.
All stack traces produced so far have in common that they start somewhere in the
network stack and end in __wake_up_common. The code location that crashes
dereferences the pointer curr, so the list &wq_head->head is probably corrupted.

See two example logs below (first with KASAN). Note that they also contain a
bridge device in this specific log but it can also be reproduced without that.

Does that ring a bell for someone? Any hints for further debugging this?

Thanks in advance and best regards

Enrico

[18976.955576] ==================================================================
[18976.962846] BUG: KASAN: null-ptr-deref in __wake_up_common+0xab/0x140
[18976.969360] Read of size 4 at addr 00000100 by task systemd-network/314
[18976.976011] 
[18976.977524] CPU: 0 PID: 314 Comm: systemd-network Not tainted 6.2.1 #1
[18976.984097] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[18976.990658]  unwind_backtrace from show_stack+0xb/0xc
[18976.995776]  show_stack from dump_stack_lvl+0x2b/0x34
[18977.000899]  dump_stack_lvl from print_report+0x383/0x388
[18977.006358]  print_report from kasan_report+0x6b/0x8c
[18977.011466]  kasan_report from __wake_up_common+0xab/0x140
[18977.017017]  __wake_up_common from __wake_up_common_lock+0xa7/0xdc
[18977.023266]  __wake_up_common_lock from __wake_up_sync_key+0x11/0x18
[18977.029683]  __wake_up_sync_key from sock_def_readable+0x31/0x54
[18977.035756]  sock_def_readable from tcp_rcv_established+0x6a9/0x8a4
[18977.042088]  tcp_rcv_established from tcp_v4_do_rcv+0x19d/0x250
[18977.048068]  tcp_v4_do_rcv from tcp_v4_rcv+0xd11/0xdd4
[18977.053264]  tcp_v4_rcv from ip_protocol_deliver_rcu+0x23/0x1dc
[18977.059260]  ip_protocol_deliver_rcu from ip_local_deliver_finish+0xc5/0xe4
[18977.066294]  ip_local_deliver_finish from ip_local_deliver+0x10f/0x11c
[18977.072888]  ip_local_deliver from ip_rcv+0xd1/0xe0
[18977.077831]  ip_rcv from __netif_receive_skb_one_core+0xab/0xc8
[18977.083828]  __netif_receive_skb_one_core from netif_receive_skb+0x8f/0x114
[18977.090858]  netif_receive_skb from br_handle_frame_finish+0x1c5/0x6dc
[18977.097451]  br_handle_frame_finish from br_handle_frame+0x1cf/0x288
[18977.103860]  br_handle_frame from __netif_receive_skb_core+0x2e9/0xcf8
[18977.110448]  __netif_receive_skb_core from __netif_receive_skb_list_core+0x165/0x2ac
[18977.118261]  __netif_receive_skb_list_core from netif_receive_skb_list_internal+0x2ad/0x3e0
[18977.126684]  netif_receive_skb_list_internal from napi_complete_done+0xed/0x2c0
[18977.134061]  napi_complete_done from r8152_poll+0x7db/0x99c
[18977.139705]  r8152_poll from __napi_poll+0x35/0x174
[18977.144646]  __napi_poll from net_rx_action+0x201/0x3ac
[18977.149934]  net_rx_action from __do_softirq+0x12f/0x2d4
[18977.155311]  __do_softirq from irq_exit+0xc1/0xec
[18977.160077]  irq_exit from call_with_stack+0xd/0x10
[18977.165022] ==================================================================
[18977.172292] 8<--- cut here ---
[18977.175366] Unable to handle kernel NULL pointer dereference at virtual address 00000100 when
read
[18977.184357] [00000100] *pgd=00000000
[18977.187976] Internal error: Oops: 5 [#1] SMP THUMB2
[18977.192885] Modules linked in:
[18977.195975] CPU: 0 PID: 314 Comm: systemd-network Tainted: G    B              6.2.1 #1
[18977.204021] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[18977.210575] PC is at __wake_up_common+0xaa/0x140
[18977.215246] LR is at kasan_report+0x71/0x8c
[18977.219467] pc : [<8016e492>]    lr : [<8024c465>]    psr: 200301b3
[18977.225763] sp : 8181f190  ip : 00000000  fp : 00000010
[18977.231016] r10: 00000001  r9 : 000000f4  r8 : 8389a984
[18977.236269] r7 : 8026dfcd  r6 : 00000000  r5 : 00000100  r4 : 000000f4
[18977.242823] r3 : 00000000  r2 : 85360000  r1 : 815f1e80  r0 : 00000001
[18977.249381] Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA Thumb  Segment none
[18977.256814] Control: 50c5387d  Table: 135dc04a  DAC: 00000051
[18977.262584] Register r0 information: non-paged memory
[18977.267679] Register r1 information: non-slab/vmalloc memory
[18977.273381] Register r2 information: slab task_struct start 85360000 pointer offset 0 size 2368
[18977.282176] Register r3 information: NULL pointer
[18977.286920] Register r4 information: non-paged memory
[18977.292009] Register r5 information: non-paged memory
[18977.297098] Register r6 information: NULL pointer
[18977.301840] Register r7 information: non-slab/vmalloc memory
[18977.307540] Register r8 information: slab sock_inode_cache start 8389a940 pointer offset 68 size
576
[18977.316765] Register r9 information: non-paged memory
[18977.321854] Register r10 information: non-paged memory
[18977.327030] Register r11 information: zero-size pointer
[18977.332292] Register r12 information: NULL pointer
[18977.337120] Process systemd-network (pid: 314, stack limit = 0xb2403e78)
[18977.343853] Stack: (0x8181f190 to 0x81820000)
[18977.348245] f180:                                     00000001 00000001 80b94893 00000001
[18977.356464] f1a0: 000000c3 8389a980 8181f260 00000010 00000001 8181f200 00030113 8016e5cf
[18977.364684] f1c0: 000000c3 8181f200 82ce186c 85360000 00000001 6f303e3c 843f032c 8017c16f
[18977.372900] f1e0: 41b58ab3 810a8890 8016e528 8021500b 8181f220 00000000 00000000 00000000
[18977.381116] f200: 00000000 00000000 00000000 00000100 00000122 00000000 8935b300 802319c7
[18977.389332] f220: 6b1d4cfa 00000004 011d4e10 00000000 00000004 00000000 00000d89 0000092b
[18977.397546] f240: 00000d89 00000bd6 00000000 00000001 00000002 459557d1 00000001 00000000
[18977.405763] f260: 8d168100 8024be4f 70a2d020 808bcea7 816398c0 32431275 843f0000 843f0000
[18977.413980] f280: 8389a980 843f00e0 8389a984 843f0100 60030113 6f303e60 85360000 8016eaa9
[18977.422195] f2a0: 000000c3 843f0100 60030113 808ed735 808ed705 843f0000 89f0cf00 00000000
[18977.430412] f2c0: 8181f360 80a05b69 00000014 89f0cf28 89f0cfa4 89f0cf50 89f0cf18 00000014
[18977.438628] f2e0: 2e3b6000 80a2ad1f 8d168300 00000000 85360000 8024be35 00000001 85656000
[18977.446844] f300: 41b58ab3 811287fc 80a054c0 8024c009 8024a9a1 80a2ad1f 80a2b451 80914b47
[18977.455061] f320: 80914c00 80ae26e5 80ae2dcb 8091408d 8091503d 80915431 809159d9 807b5deb
[18977.463278] f340: 80915be1 8091607d 8010141b 8012b4cd 80b503a1 809b48d7 20070133 00000000
[18977.471494] f360: 00000018 80a12065 84790cc0 32431275 815a8600 89f0cf00 843f0000 815a8600
[18977.479710] f380: 84790cc0 843f0070 843f00d4 00000006 89f0cf9c 80a140a5 89f0cf00 843f0000
[18977.487926] f3a0: 00000000 843f007c 8181f4a0 6f303e84 00000001 80a166d5 0000001c 00000000
[18977.496141] f3c0: 00000000 8091f9d5 00000000 00000a20 81a41800 85360000 011b53c9 843f0414
[18977.504358] f3e0: 000000f2 014e8e9e 89f0cfa4 8181f4a0 6f303e84 89f0cf94 89f0cf0c 81669a00
[18977.512572] f400: 808ebbf1 8d168304 8d168300 00000000 0000000a 85360000 00000000 00000000
[18977.520790] f420: 41b58ab3 81128cfc 80a159c4 8187c400 8d168300 8181f4a0 80a2ad1f 32431275
[18977.529007] f440: 41b58ab3 81129560 80a20118 00000004 8181f500 824914e0 843f0000 843f000c
[18977.537224] f460: 00000000 809e73b1 000050ea 80a2ad1f 970aa8c0 230aa8c0 bffe50ea 85360000
[18977.545440] f480: 00000538 843f0054 81669a00 81669ca4 6f303e94 843f0014 8181f4e0 ffffffff
[18977.553657] f4a0: 41b58ab3 810a7ce0 809e71a4 0108a8c0 81669a00 32431275 8181f628 80f029a0
[18977.561872] f4c0: 89f0cf00 81309a7c 81669a00 00000000 809da7d5 89f0cf90 00000000 809da41b
[18977.570088] f4e0: 0108a8c0 808fc5c9 00030193 89f0cf00 8935b450 8935b464 81669a00 89f0cf94
[18977.578305] f500: 809da7d5 809da699 89f0cf00 6f303ea8 8181f5c0 8306e000 85360000 809da7c7
[18977.586521] f520: 89f0cf70 970aa8c0 000050ea 809d0b73 809d0b49 89f0cf00 843f0000 80a1598d
[18977.594738] f540: 41b58ab3 810e8870 809da6b8 00000000 02cca6cc 89f0cf18 00030193 89f0cf00
[18977.602954] f560: 8935b450 81669a00 00000000 89f0cf48 89f0cfa0 89f0cf94 00000000 809d935d
[18977.611171] f580: 89f0cf94 8024d36f 89f0cf00 8306e000 8935b400 809d9ff5 85360000 89f0cf00
[18977.619388] f5a0: 8306e000 20040000 81669a00 8306e000 809da7d5 89f0cf90 00000000 32431275
[18977.627605] f5c0: 6f303ebc 8181f660 89f0cf00 85360000 8306e000 809da8a5 c0008280 32431275
[18977.635821] f5e0: 41b58ab3 810e8870 809da7d4 818e7400 89f0cf00 835e4200 818e744d b804d120
[18977.644037] f600: 00000001 807ea1b9 8310830c 85360000 00030193 6f303ec4 b804e420 8310834e
[18977.652255] f620: 41b58ab3 815e2420 b804e180 83418968 8310830c ffffff8d 8310830c 00000000
[18977.660472] f640: b804e420 8310834e 00004000 83418968 83108350 00000001 8300100c 8181f6e4
[18977.668688] f660: 00000004 32431275 00000000 6f303ed4 8181f720 32431275 6f303ed4 89f0cf00
[18977.676905] f680: 81309f68 85360000 8306e000 80914b47 c0010200 8306e5d8 85360000 8306e5e4
[18977.685121] f6a0: 41b58ab3 81118d44 80914a9c 84767800 8264de4d b804d180 00000000 807ea1b9
[18977.693337] f6c0: 41b58ab3 81131740 80ade420 83418a20 81309f68 85360000 8d168300 815e2420
[18977.701552] f6e0: 89f0cf00 000039eb 83418a48 83418a90 815e2420 00000000 b804e420 00000000
[18977.709769] f700: 83418800 83418a24 08000000 807eaa01 84708b4c 8181f7a4 00000004 0000beca
[18977.717986] f720: 00000000 8181f7a0 8306e5f0 32431275 8306e5d4 6f303eec 89f0cf00 85360000
[18977.726202] f740: 8181f7e0 89f0cf10 89f0cf1f 80914c8f 85360000 8306e5e4 6f303ef0 84767861
[18977.734419] f760: 41b58ab3 81118d6c 80914c00 af6272d0 8181f8c8 6f303ef4 83418a24 8017c155
[18977.742636] f780: 41b58ab3 81131740 80ade420 8896d969 83418a48 83418a90 815e2420 000f4240
[18977.750852] f7a0: 01cd0e00 0000beca 815e2420 8012af39 00000001 00000000 83418800 32431275
[18977.759067] f7c0: 08000000 00000001 8306e000 9b0a7ee1 00000001 89f0cf00 00000106 89f0cf90
[18977.767284] f7e0: 00000000 80ae250b 00000001 32431275 6f303f08 89f0cf00 6f303f08 84708b40
[18977.775500] f800: 001c7fb0 8306e5c0 89f0cf1f 80ae26e5 00000000 827d0824 827d086c 85360000
[18977.783715] f820: 89f0cf96 89f0cfa0 00000000 00000000 00000042 8306e5cc 81307b04 00000000
[18977.791931] f840: 41b58ab3 8113196c 80ae2520 80c1dd00 80c1dda0 807cf3b3 00000003 8365ec00
[18977.800147] f860: 8527c8a8 8017c0a1 81307350 8017fe77 8306e67c 32431275 00000006 82ce1800
[18977.808364] f880: 00000001 82ce1824 82ce186c 82ce1824 82ce1848 2e3b6000 2e3b6000 8017c16f
[18977.816580] f8a0: 0000d5e7 82ce1800 00000001 8017c1dd 0287eaf1 805dd97d 82ce1800 8126f318
[18977.824797] f8c0: 81318800 8018142f 801812a9 82ce1800 85360000 812712c8 81307350 8147d820
[18977.833013] f8e0: f4000100 80b94893 00000000 4804e480 00000010 32431275 00000000 89f0cf00
[18977.841229] f900: 00000000 8935b442 8935b400 00000042 84559514 8306e5c0 8181fa20 80ae2dcb
[18977.849446] f920: 85360000 849d4f00 8181fb60 89f0cf00 00000000 80ae2bfd 83c32048 89f0cf08
[18977.857661] f940: 81272dd8 83c32000 8181fa20 8091408d 00000001 83c32000 8166a280 00000000
[18977.865878] f960: 81272dd8 8181fac0 85360000 6f303f30 8130818c 8181fad0 00000001 81820000
[18977.874094] f980: 41b58ab3 81118d24 80913da4 8010dd07 815d83d0 8181fa10 8181fa20 8010deb3
[18977.882310] f9a0: 8181fb04 807eb00f 8181fb00 00000000 89f0cf00 00000000 00000060 807ee903
[18977.890527] f9c0: 00000060 b804e480 00000000 818e7400 00000001 b804e488 b804e4b4 8024d36f
[18977.898744] f9e0: b804e4b8 80110335 b804e0f8 807eea67 ffffffff 83418968 849d4f00 40008d80
[18977.906960] fa00: 818e741c 4804e480 818e740c 83418a1c 00000081 849d4f2c 8181fb60 849d4f00
[18977.915178] fa20: 10030113 8181fb00 83418a1c 80b94893 00000001 32431275 10030113 89f0cf00
[18977.923393] fa40: 8181fb20 83c3264c 89f0cd00 8181fae0 00000000 89f0cd00 00000000 8091503d
[18977.931610] fa60: 8181fb20 83c32000 83c3264c 00000000 8181fac0 8181fad0 b804e1e0 8264de00
[18977.939826] fa80: 6f303f54 85360000 8264de4d 85360000 00004000 81b625d0 81b62564 1228c000
[18977.948042] faa0: 41b58ab3 81118d98 80914ed8 000000a0 00000098 815e2420 8181fb40 00000000
[18977.956258] fac0: 89f0cf00 811060bc 807f13f0 b6db6db7 00000000 8019e6dd 83f22f98 b78dc41c
[18977.964475] fae0: 8181fae0 8181fae0 802356e8 85360000 8181fb60 8010a5af 8441b708 81820000
[18977.972692] fb00: b804e0f8 b804e0f8 8181fffc 808bcea7 816398c0 801a5395 58b93c98 00001142
[18977.980908] fb20: bd599d68 32431275 00000a20 83c3264c 83c3264c 89f0cf00 00000000 8181fc20
[18977.989125] fb40: 83c3264c 816698e0 85360214 80915431 81b62410 816698e0 85360000 8130818c
[18977.997341] fb60: 849d4f3c 00000000 85360000 85360214 85360000 6f303f70 849d4f28 8341885c
[18978.005557] fb80: 41b58ab3 81118dd4 80915184 807d16e5 00000000 32431275 00000000 00000001
[18978.013773] fba0: 00000a20 00000a20 85360000 8341c000 83f22f98 b78dc41c 83c325c8 8024be35
[18978.021990] fbc0: 8181fbc0 8181fbc0 8024be27 8024be4f 8024bdbd 807d2ea5 807b1367 807b5f21
[18978.030206] fbe0: 41b58ab3 81104118 807d157c 8012b4cd 80b503a1 80b503a1 80b503a1 80b94893
[18978.038422] fc00: 41b58ab3 80a1d579 807f0820 00000014 11241850 00000111 815d7440 89f0ce18
[18978.046639] fc20: 00000000 89f0ce60 af62c0b0 00000050 00000064 32431275 00000000 83c325c8
[18978.054855] fc40: 6f303f94 83c325d0 00000000 8181fd00 83c32654 00000001 83c3264c 809159d9
[18978.063072] fc60: 8935a842 6f303f94 8935a856 8181fd00 0000b19c 85360000 80eff720 80eff724
[18978.071288] fc80: 849d4f00 8341b000 83450b00 ffffff81 849d4f28 849d4f3c 00000000 807d311b
[18978.079502] fca0: 41b58ab3 81118e14 809158ec 00000000 00000000 00000002 849d4f30 00000a20
[18978.087719] fcc0: 00000002 32431275 af627c10 83c325c0 83f22f80 00000a20 849d4f00 83c326a4
[18978.095935] fce0: 83c325c4 00000000 83f22f90 807b4c8f 00004000 8228c000 c0008280 32431275
[18978.104150] fd00: 9b1a4faf 8181fde0 8181fe20 8181fde0 b795e81c 00000298 00000008 0000004b
[18978.112367] fd20: 83c325c8 807b5deb 00000047 00000080 00000004 8d340248 8181fde0 83c3276c
[18978.120582] fd40: 83f22f80 849d4f00 00000040 8181fe20 87f4aa98 8181fde0 00000000 00000100
[18978.128798] fd60: 83c3275c 85781758 87f4aa9c 83c326a4 83c32764 8181fde0 00000000 83c32734
[18978.137015] fd80: 83c3273c 83c325c0 8181fde4 6f303fb8 85360000 b795e81c 83c328a4 87f4aa84
[18978.145232] fda0: 83c3273c 82199380 6f303fc0 8181fe60 8181fdc8 80b94893 00000003 82199380
[18978.153448] fdc0: 41b58ab3 81102b90 807b5610 81306f50 80030193 00000003 82199b2c 82199388
[18978.161664] fde0: 8181fde0 8181fde0 853608fc 81642e40 00000002 808bcea7 813f9b48 801a61d9
[18978.169881] fe00: 41b58ab3 810a7df0 801524e0 00001142 68b9e4e4 00000001 9c39c590 32431275
[18978.178097] fe20: 00000000 00000001 83c325c8 00000040 83c325d0 8181fef0 8181ff00 af628f8c
[18978.186313] fe40: 83c325cc 80915be1 8181ff20 00000000 6aa246d8 83c325c8 af628dc0 8181ff60
[18978.194529] fe60: 8181fef0 8181ff00 8181ff00 8091607d 827377ac 8181ff00 0000012c 81272dc0
[18978.202745] fe80: 2e3b6000 81305d40 001c7fb2 81305d40 8181ff20 af628f80 85360000 6f303fd8
[18978.210962] fea0: 85360000 80b94893 827377b0 8016e675 6f303fd8 8061a29d 85360000 806472bd
[18978.219178] fec0: 41b58ab3 81118e40 80915e7c 815f4c80 81307114 81307114 00000000 001c7fb0
[18978.227394] fee0: 824361ac ffffffff 00000000 af628400 81307100 32431275 af628990 83418800
[18978.235611] ff00: 8181ff00 8181ff00 82ce186c 82ce1800 815d7981 32431275 80c1dda0 824361a8
[18978.243827] ff20: 8181ff20 8181ff20 af625290 af625294 00000040 32431275 00000000 00000000
[18978.252044] ff40: 824361a8 81272080 af625290 af625294 00000040 8012ae8d 82ce1848 32431275
[18978.260259] ff60: 2e3b6000 8130508c 40000003 00000004 8126f328 85360004 81305080 85360000
[18978.268476] ff80: 2e3b6000 8010141b 81318800 8018142f 801812a9 00000100 8181ff88 81305080
[18978.276691] ffa0: 8126f318 00000003 00000005 81272080 8126f28c 81272080 001c7fb1 81305d40
[18978.284907] ffc0: 80c13000 00400100 2e3b6000 81638700 2e3b6000 8181fff0 8441b708 811bf77c
[18978.293123] ffe0: 85360000 811bf778 6f8836f4 8012b4cd 8024c8be 80030033 ffffffff 80b503a1
[18978.301332]  __wake_up_common from __wake_up_common_lock+0xa7/0xdc
[18978.307592]  __wake_up_common_lock from __wake_up_sync_key+0x11/0x18
[18978.314007]  __wake_up_sync_key from sock_def_readable+0x31/0x54
[18978.320076]  sock_def_readable from tcp_rcv_established+0x6a9/0x8a4
[18978.326403]  tcp_rcv_established from tcp_v4_do_rcv+0x19d/0x250
[18978.332382]  tcp_v4_do_rcv from tcp_v4_rcv+0xd11/0xdd4
[18978.337583]  tcp_v4_rcv from ip_protocol_deliver_rcu+0x23/0x1dc
[18978.343575]  ip_protocol_deliver_rcu from ip_local_deliver_finish+0xc5/0xe4
[18978.350607]  ip_local_deliver_finish from ip_local_deliver+0x10f/0x11c
[18978.357202]  ip_local_deliver from ip_rcv+0xd1/0xe0
[18978.362142]  ip_rcv from __netif_receive_skb_one_core+0xab/0xc8
[18978.368132]  __netif_receive_skb_one_core from netif_receive_skb+0x8f/0x114
[18978.375161]  netif_receive_skb from br_handle_frame_finish+0x1c5/0x6dc
[18978.381752]  br_handle_frame_finish from br_handle_frame+0x1cf/0x288
[18978.388159]  br_handle_frame from __netif_receive_skb_core+0x2e9/0xcf8
[18978.394750]  __netif_receive_skb_core from __netif_receive_skb_list_core+0x165/0x2ac
[18978.402562]  __netif_receive_skb_list_core from netif_receive_skb_list_internal+0x2ad/0x3e0
[18978.410982]  netif_receive_skb_list_internal from napi_complete_done+0xed/0x2c0
[18978.418359]  napi_complete_done from r8152_poll+0x7db/0x99c
[18978.423999]  r8152_poll from __napi_poll+0x35/0x174
[18978.428939]  __napi_poll from net_rx_action+0x201/0x3ac
[18978.434225]  net_rx_action from __do_softirq+0x12f/0x2d4
[18978.439600]  __do_softirq from irq_exit+0xc1/0xec
[18978.444363]  irq_exit from call_with_stack+0xd/0x10
[18978.449318] Code: 4628 46a1 f0de fa15 (68e4) 45a8 
[18978.454139] ---[ end trace 0000000000000000 ]---
[18978.458783] Kernel panic - not syncing: Fatal exception in interrupt
[18978.465164] CPU1: stopping
[18978.467901] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G    B D            6.2.1 #1
[18978.475253] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[18978.481808]  unwind_backtrace from show_stack+0xb/0xc
[18978.486920]  show_stack from dump_stack_lvl+0x2b/0x34
[18978.492031]  dump_stack_lvl from do_handle_IPI+0xf3/0x118
[18978.497491]  do_handle_IPI from ipi_handler+0x13/0x18
[18978.502587]  ipi_handler from handle_percpu_devid_irq+0x95/0x12c
[18978.508656]  handle_percpu_devid_irq from generic_handle_domain_irq+0x27/0x30
[18978.515849]  generic_handle_domain_irq from gic_handle_irq+0x79/0x8c
[18978.522268]  gic_handle_irq from generic_handle_arch_irq+0x21/0x30
[18978.528509]  generic_handle_arch_irq from __irq_svc+0x6b/0x9c
[18978.534308] Exception stack(0x81823de0 to 0x81823e28)
[18978.539398] 3de0: 00000005 843f007c 6f87e00f 00007afc 843f007c 00007aff 843f007c 8194f504
[18978.547611] 3e00: 843f0000 00000000 80a104b5 af631640 00000000 81823e30 80b94b29 80b94b22
[18978.555814] 3e20: 80070133 ffffffff
[18978.559326]  __irq_svc from _raw_spin_lock+0x26/0x3c
[18978.564353]  _raw_spin_lock from tcp_delack_timer+0x19/0x108
[18978.570073]  tcp_delack_timer from call_timer_fn.constprop.0+0x1b/0x6c
[18978.576658]  call_timer_fn.constprop.0 from run_timer_softirq+0x667/0x6f4
[18978.583495]  run_timer_softirq from __do_softirq+0x12f/0x2d4
[18978.589204]  __do_softirq from irq_exit+0xc1/0xec
[18978.593964]  irq_exit from call_with_stack+0xd/0x10
[18978.598902] CPU2: stopping
[18978.601642] CPU: 2 PID: 576 Comm: TCPConnectorMUE Tainted: G    B D            6.2.1 #1
[18978.609685] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[18978.616241]  unwind_backtrace from show_stack+0xb/0xc
[18978.621350]  show_stack from dump_stack_lvl+0x2b/0x34
[18978.626458]  dump_stack_lvl from do_handle_IPI+0xf3/0x118
[18978.631916]  do_handle_IPI from ipi_handler+0x13/0x18
[18978.637015]  ipi_handler from handle_percpu_devid_irq+0x95/0x12c
[18978.643078]  handle_percpu_devid_irq from generic_handle_domain_irq+0x27/0x30
[18978.650267]  generic_handle_domain_irq from gic_handle_irq+0x79/0x8c
[18978.656677]  gic_handle_irq from generic_handle_arch_irq+0x21/0x30
[18978.662919]  generic_handle_arch_irq from call_with_stack+0xd/0x10
[18978.669166] CPU3: stopping
[18978.671906] CPU: 3 PID: 569 Comm: MsgProc Tainted: G    B D            6.2.1 #1
[18978.679255] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[18978.685812]  unwind_backtrace from show_stack+0xb/0xc
[18978.690926]  show_stack from dump_stack_lvl+0x2b/0x34
[18978.696038]  dump_stack_lvl from do_handle_IPI+0xf3/0x118
[18978.701493]  do_handle_IPI from ipi_handler+0x13/0x18
[18978.706589]  ipi_handler from handle_percpu_devid_irq+0x95/0x12c
[18978.712652]  handle_percpu_devid_irq from generic_handle_domain_irq+0x27/0x30
[18978.719841]  generic_handle_domain_irq from gic_handle_irq+0x79/0x8c
[18978.726248]  gic_handle_irq from generic_handle_arch_irq+0x21/0x30
[18978.732492]  generic_handle_arch_irq from call_with_stack+0xd/0x10
[18978.738748] ---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---




[  618.776029] 8<--- cut here ---
[  618.779109] Unable to handle kernel paging request at virtual address a971a970
[  618.786338] [a971a970] *pgd=3961141e(bad)
[  618.790364] Internal error: Oops: 8000000d [#1] SMP THUMB2
[  618.795857] Modules linked in: iptable_filter ip_tables x_tables nvmem_imx_ocotp edt_ft5x06
coda_vpu v4l2_jpeg videobuf2_vmalloc videobuf2_dma_contig videobuf2_memops imx_vdoa v4l2_mem2mem
videobuf2_v4l2 videobuf2_common imx6q_cpufreq configfs
[  618.817502] CPU: 0 PID: 748 Comm: MsgProc Not tainted 6.1.11-20230210-1 #1
[  618.824388] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[  618.830922] PC is at 0xa971a970
[  618.834072] LR is at __wake_up_common+0x4d/0xc8
[  618.838629] pc : [<a971a970>]    lr : [<8014aed1>]    psr: 400701b3
[  618.844901] sp : 8100daf0  ip : 85416838  fp : 000000c3
[  618.850131] r10: 00000010  r9 : 00000001  r8 : 824bca44
[  618.855361] r7 : 00000000  r6 : a971a971  r5 : 00000000  r4 : 83a1fb9c
[  618.861893] r3 : 000000c3  r2 : 00000010  r1 : 00000001  r0 : 85416838
[  618.868427] Flags: nZcv  IRQs off  FIQs on  Mode SVC_32  ISA Thumb  Segment none
[  618.875832] Control: 50c5387d  Table: 1793404a  DAC: 00000051
[  618.881582] Register r0 information: slab sock_inode_cache start 85416800 pointer offset 56
[  618.889960] Register r1 information: non-paged memory
[  618.895022] Register r2 information: zero-size pointer
[  618.900168] Register r3 information: non-paged memory
[  618.905226] Register r4 information: non-slab/vmalloc memory
[  618.910893] Register r5 information: NULL pointer
[  618.915604] Register r6 information: non-slab/vmalloc memory
[  618.921272] Register r7 information: NULL pointer
[  618.925983] Register r8 information: slab sock_inode_cache start 824bca00 pointer offset 68
[  618.934356] Register r9 information: non-paged memory
[  618.939414] Register r10 information: zero-size pointer
[  618.944647] Register r11 information: non-paged memory
[  618.949792] Register r12 information: slab sock_inode_cache start 85416800 pointer offset 56
[  618.958251] Process MsgProc (pid: 748, stack limit = 0xb9248283)
[  618.964266] Stack: (0x8100daf0 to 0x8100e000)
[  618.968632] dae0:                                     00000000 00000001 116fef61 00000001
[  618.976820] db00: 60070113 824bca40 00000010 00000001 8100db28 000000c3 8213e880 8014af93
[  618.985007] db20: 000000c3 8100db28 00000000 00000000 00000000 8100db34 8100db34 a98976d8
[  618.993192] db40: 00000000 84de0000 822f0600 8213e880 00000000 00000014 00000125 8213e880
[  619.001378] db60: 84c77124 8014b275 000000c3 84de0000 822f0600 8060abe1 84de0000 806b5463
[  619.009564] db80: 00000001 00000000 00010001 00000000 00000125 a98976d8 84c77124 84de0000
[  619.017750] dba0: 822f0600 84c77124 8213e880 00000014 00000125 8213e880 84c77124 806b5d3b
[  619.025936] dbc0: 0052b5f9 a98976d8 00007c9b 84de0000 822f0600 811dcd80 80e86080 84c77110
[  619.034122] dbe0: 00000001 8213e880 84c77124 806be549 822f0600 84de0000 00000000 806bfb0d
[  619.042307] dc00: 00000090 801e53d7 00000001 00000001 ffffffff 80d08280 00000000 80609bdd
[  619.050493] dc20: 80c4ed94 00000001 00000000 80e0e907 80a67420 80d05068 83962840 00000009
[  619.058678] dc40: 00000001 80c4ed94 00000000 a98976d8 8220ce80 808a0010 822f0600 80d07c2c
[  619.066863] dc60: 80e86080 00000000 00000000 00000000 80d0672c 8069be51 00000000 8315b400
[  619.075048] dc80: 822f0600 80e86080 00000110 80e86080 00000201 830be5c0 00000003 8069c03d
[  619.083233] dca0: 8213e880 80e86080 00000201 822f0600 8213e880 8069c0d3 00000001 822f0201
[  619.091418] dcc0: 830be000 00000000 00000000 80e86080 8069bfdd a98976d8 830be000 830be000
[  619.099603] dce0: 822f0600 8213e880 80e86080 8069c13f 000017b9 811dce80 830be5d4 a98976d8
[  619.107788] dd00: 82148000 8213e880 00000000 a98976d8 8213e880 8213e880 8069c0dd 830be000
[  619.115973] dd20: 8213e880 8062450f 00000000 822f0600 80d08118 a98976d8 822f0600 8213e880
[  619.124158] dd40: 00000000 806245b9 00000001 00000000 8213e880 a98976d8 833cd000 822f0600
[  619.132343] dd60: 833cd000 8073a8af 00000000 00000000 00000147 833cd0a8 830be67c 00000000
[  619.140528] dd80: 00000030 00000000 ff7dd218 80659221 822f0600 a98976d8 822f0600 0000beca
[  619.148713] dda0: 84c77102 00000102 84c77000 833cd000 82293000 8073abe5 82293000 822f0600
[  619.156899] ddc0: 8100ddf0 00000001 80c4eb58 8073aaed 80e868b4 80623e07 00000000 00000000
[  619.165084] dde0: 8100de4c 8213e880 80d0632c 8100de50 822f0600 821486ec 821486ec 8213e880
[  619.173270] de00: 00000000 80e86014 8213e880 a98976d8 80100009 00000000 822f0600 8100de54
[  619.181455] de20: ff7dd29c ff7dd29c 00000000 82293000 00000000 8062478b 82152000 ff7dd29c
[  619.189640] de40: 00000000 8213e880 82148000 822f0600 00000000 8100de54 8100de54 a98976d8
[  619.197826] de60: 00000014 00000000 ff7dd29c ff7dd29c ff7dd29c 8213e880 00000000 80e86014
[  619.206010] de80: 8213e880 80624965 00000000 8213e880 822f0600 8100de94 8100de94 00000000
[  619.214195] dea0: 00000000 a98976d8 00000008 ff7dd29c 00000001 ff7dd218 ff7dd208 00000000
[  619.222380] dec0: 36a21000 00000001 b766fd00 80624ce5 84c77f00 ff7dd218 ff7dd208 00000000
[  619.230565] dee0: 36a21000 ff7dd218 00000001 00000040 ff7dd208 00000000 36a21000 80d03d40
[  619.238751] df00: b766fd00 80659277 00000001 ff7dd218 00000040 8100df5b 8100df5c 80624e07
[  619.246936] df20: 00000000 80611c1f 822f0c00 8100df5b 0000012c b766fb40 ff7dd218 0000012c
[  619.255120] df40: 00000000 80625083 c0cd8000 00007c87 8213e880 80c4eb40 0052b5f9 8100df5c
[  619.263305] df60: 8100df5c 8100df64 8100df64 a98976d8 8213e880 40000003 00000000 00000003
[  619.271490] df80: 80d0308c 8213e880 00000100 80d03080 8100df98 801013c7 000065ef 812c1700
[  619.279675] dfa0: 80d0d0c0 80d03080 80c4b318 00000009 80c4de00 80c4b28c 80c4de00 00007c86
[  619.287861] dfc0: 80d03d40 809cab08 00400040 80801218 80413335 767af14c 20070030 ffffffff
[  619.296046] dfe0: 86e6bfa8 80c4b044 73505ef8 00000010 73505cb8 80120813 767af14c 8077ec69
[  619.304237]  __wake_up_common from __wake_up_common_lock+0x47/0x6c
[  619.310451]  __wake_up_common_lock from __wake_up_sync_key+0x11/0x18
[  619.316828]  __wake_up_sync_key from sock_def_readable+0x21/0x38
[  619.322865]  sock_def_readable from tcp_data_queue+0x2fb/0x9a8
[  619.328733]  tcp_data_queue from tcp_rcv_established+0x12b/0x4f0
[  619.334765]  tcp_rcv_established from tcp_v4_do_rcv+0xe1/0x154
[  619.340624]  tcp_v4_do_rcv from tcp_v4_rcv+0x7f5/0x880
[  619.345780]  tcp_v4_rcv from ip_protocol_deliver_rcu+0x21/0x1ac
[  619.351725]  ip_protocol_deliver_rcu from ip_local_deliver_finish+0x61/0x78
[  619.358710]  ip_local_deliver_finish from ip_local_deliver+0x7f/0x88
[  619.365086]  ip_local_deliver from ip_rcv+0x63/0x6c
[  619.369984]  ip_rcv from __netif_receive_skb_one_core+0x2f/0x40
[  619.375929]  __netif_receive_skb_one_core from netif_receive_skb+0x3d/0x94
[  619.382820]  netif_receive_skb from br_handle_frame_finish+0x12b/0x368
[  619.389370]  br_handle_frame_finish from br_handle_frame+0xf9/0x15c
[  619.395654]  br_handle_frame from __netif_receive_skb_core+0x1af/0x888
[  619.402200]  __netif_receive_skb_core from __netif_receive_skb_list_core+0x8f/0x120
[  619.409872]  __netif_receive_skb_list_core from netif_receive_skb_list_internal+0x149/0x1e8
[  619.418238]  netif_receive_skb_list_internal from napi_complete_done+0x4d/0x154
[  619.425565]  napi_complete_done from gro_cell_poll+0x53/0x5c
[  619.431243]  gro_cell_poll from __napi_poll+0x1b/0x104
[  619.436396]  __napi_poll from net_rx_action+0xd3/0x198
[  619.441549]  net_rx_action from __do_softirq+0xd7/0x1c8
[  619.446794]  __do_softirq from irq_exit+0x73/0x98
[  619.451524]  irq_exit from call_with_stack+0xd/0x10
[  619.456430] Code: 0000 0000 0000 0000 (0000) 0000 
[  619.461226] ---[ end trace 0000000000000000 ]---
[  619.465848] Kernel panic - not syncing: Fatal exception in interrupt
[  619.472214] CPU3: stopping
[  619.474931] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G      D            6.1.11-20230210-1 #1
[  619.483294] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[  619.489829]  unwind_backtrace from show_stack+0xb/0xc
[  619.494904]  show_stack from dump_stack_lvl+0x2b/0x34
[  619.499975]  dump_stack_lvl from do_handle_IPI+0xcb/0xf4
[  619.505304]  do_handle_IPI from ipi_handler+0x13/0x18
[  619.510370]  ipi_handler from handle_percpu_devid_irq+0x4b/0xc4
[  619.516315]  handle_percpu_devid_irq from generic_handle_domain_irq+0x15/0x20
[  619.523470]  generic_handle_domain_irq from gic_handle_irq+0x5f/0x70
[  619.529853]  gic_handle_irq from generic_handle_arch_irq+0x27/0x34
[  619.536055]  generic_handle_arch_irq from call_with_stack+0xd/0x10
[  620.444512] SMP: failed to stop secondary CPUs
[  620.448962] ---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---




-- 
Pengutronix e.K.                           | Enrico Jörns                |
Embedded Linux Consulting & Support        | https://www.pengutronix.de/ |
Steuerwalder Str. 21                       | Phone: +49-5121-206917-180  |
31137 Hildesheim, Germany                  | Fax:   +49-5121-206917-9    |

