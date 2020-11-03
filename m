Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 494AE2A4D32
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729002AbgKCRi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:38:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727857AbgKCRiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:38:24 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C32C0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 09:38:24 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id gn41so8115241ejc.4
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 09:38:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pEBR8a7ixzu2FpGFoZ4IF+Oqmhgep+kswC35KsdGBsc=;
        b=ebRdMJYeDSsFHhwqlY7OJfGED779HfVrfKOzMeKnlyR8fKeX3VkYTou3c5JeZtI4A1
         GtAnsplUPjUgcZD0fTyJ/zvy+KZ3eWNW18LljnwqdPPBiNG1hOVxqXVToT6Mvh074R3G
         WNqwaICMDBRrBiAwXXw2asmo9rZMp8uO/YI8IFok21nxwnkX1uON7oBKcvwCbtWqrVuE
         vwvxo+btys18PvCeZ7Q70tMat9biAaLLhgxvMQQ5Q/tPuPfMr37HnNXBKmCqgy65cJ69
         HA8A3Mo9UJ1jqEtcd0aUV59CxLYaDT0TPf7a0N8o7j6UMSy38uextCnQB/paxSSpEHf0
         0+pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pEBR8a7ixzu2FpGFoZ4IF+Oqmhgep+kswC35KsdGBsc=;
        b=QbjDrV6ReBUzuuEch0xGkdDzUFy4tjCv8T1MPY2W+NSFviXENfEzX6oTOaaOItp4Qo
         1NtiMfpeAoa+9ruwXWjq+FVO8yRhQB3AprVieE0qsHMMmxwmu3N0b46Wz3hxVZwDD8uN
         Xc1nbTs0Em+d2SKrzKdM0O8wateE++3IPP6o0T1hWoEh5a1cSMuV8I14fMuNKZFX6/Zo
         ltx9T/jCcsZDBgvvnXJyt8bKNz57iklX+XB81MUOR0mRAtUNcFNhUM0+ErpejVJaZOvO
         eIwhxY0PHKms/j0dfX9prHFZVEdNRDL1kZzGkPIVA3Q2UAk3UFM6gbCXIEyC/qc0kraT
         x9XQ==
X-Gm-Message-State: AOAM532npDlF6dUuF/hsg++va2Ug57dgCX+DnmTEfPI6Z8dPrluqirJg
        a+xfPCAXPrrItV7VN9iECP8=
X-Google-Smtp-Source: ABdhPJx98ZroMwp4uOCq/s5ILIH/5pOO1M4ND38ZJfFjt+32GQPLlLEQKLrLy6avvhHGozA6Zh7tEg==
X-Received: by 2002:a17:906:1fc9:: with SMTP id e9mr14460795ejt.319.1604425103171;
        Tue, 03 Nov 2020 09:38:23 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id x2sm12465064edr.65.2020.11.03.09.38.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 09:38:22 -0800 (PST)
Date:   Tue, 3 Nov 2020 19:38:21 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "james.jurack@ametek.com" <james.jurack@ametek.com>
Subject: Re: [PATCH net v2 1/2] gianfar: Replace skb_realloc_headroom with
 skb_cow_head for PTP
Message-ID: <20201103173821.ikb43tgydfgl3r5l@skbuf>
References: <fa12d66e-de52-3e2e-154c-90c775bb4fe4@ametek.com>
 <20201029081057.8506-1-claudiu.manoil@nxp.com>
 <20201103161319.wisvmjbdqhju6vyh@skbuf>
 <2b0606ef-71d2-cc85-98db-1e16cc63c9d2@linux.ibm.com>
 <AM0PR04MB67540916FABD7D801C9DF82496110@AM0PR04MB6754.eurprd04.prod.outlook.com>
 <20201103091226.2d82c90c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20201103172441.2xyyr3dkabtgfeao@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103172441.2xyyr3dkabtgfeao@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 03, 2020 at 07:24:41PM +0200, Vladimir Oltean wrote:
> On Tue, Nov 03, 2020 at 09:12:26AM -0800, Jakub Kicinski wrote:
> > While it is something to be fixed - is anything other than pktgen
> > making use of IFF_TX_SKB_SHARING? Are you running pktgen, Vladimir?
> 
> Nope, just iperf3 TCP and PTP. The problem is actually with PTP, I've
> been testing gianfar with just TCP for a long while.

Now it fails like this too, under exactly the same traffic load:

[  113.937369] 8<--- cut here ---
[  113.940474] Unable to handle kernel NULL pointer dereference at virtual address 00000004
[  113.948569] pgd = 4340cf4f
[  113.951282] [00000004] *pgd=80000080204003, *pmd=00000000
[  113.956692] Internal error: Oops: a07 [#1] SMP ARM
[  113.961459] Modules linked in:
[  113.964500] CPU: 0 PID: 9 Comm: ksoftirqd/0 Not tainted 5.10.0-rc1-00297-g2d388e050508-dirty #709
[  113.973322] Hardware name: Freescale LS1021A
[  113.977574] PC is at __qdisc_run+0x2c4/0x5fc
[  113.981819] LR is at __qdisc_run+0x408/0x5fc
[  113.986061] pc : [<c1158a44>]    lr : [<c1158b88>]    psr: 600f0013
[  113.992291] sp : c28f1988  ip : 200f0013  fp : 0000002c
[  113.997484] r10: c265ae20  r9 : 00000000  r8 : c2f38700
[  114.002677] r7 : 00000040  r6 : c4d9d900  r5 : c3d3b05c  r4 : c3d3b000
[  114.009167] r3 : 00000000  r2 : c28f1d30  r1 : 00000000  r0 : c3d3b05c
[  114.015657] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[  114.022752] Control: 30c5387d  Table: 84936540  DAC: fffffffd
[  114.028468] Process ksoftirqd/0 (pid: 9, stack limit = 0xb7de1ef0)
[  114.034613] Stack: (0xc28f1988 to 0xc28f2000)
[  114.038946] 1980:                   00000000 00000001 7dfff8a0 c3d3b040 c265ae20 ffffe000
[  114.047081] 19a0: c240675c 00000000 c4d5d138 c4d5d138 c3d3b000 c2406708 00000000 c2f7a000
[  114.055216] 19c0: c2f38600 00010a22 0000002c c10fd2c8 c2fc36a0 c4aab50c c4d5d138 c1229434
[  114.063351] 19e0: 000048af c1f2c684 c2fc3400 fffffff4 00000000 c2406708 00000000 c2feb540
[  114.071485] 1a00: 00000000 e5243720 00000000 c3d5c600 00000000 c4d5d138 c2406708 00000010
[  114.079620] 1a20: c3d5c68c 0000feca 00000000 c11ca978 c4d5d138 c2619480 c4909500 c11cba48
[  114.087755] 1a40: 0201a8c0 e5243720 00000000 c4d5d138 c2406708 c2619480 c2f7a000 c4909500
[  114.095890] 1a60: 00000000 467d5a22 00000000 c11cd44c c3daa280 00000001 00000004 00000002
[  114.104024] 1a80: 00000000 c2f7a000 c4909500 c2619480 c11cbb4c e5243720 000010f8 c4d5d138
[  114.112159] 1aa0: c4909500 c49097a0 00000045 00000000 c2619480 c3daa280 c4d5d080 c11cce10
[  114.120294] 1ac0: c2406708 c11e4ab8 c28f1ba0 c28f1ba0 00001004 c2406708 00071bdc e5243720
[  114.128429] 1ae0: 7e069980 c4909500 c4d5d138 ffffb750 0000fe88 c4d5d150 c2406708 0000002d
[  114.136564] 1b00: c4d5d080 c11eae60 00000000 c28f1b34 c49095fc 00034ac8 86afd1b0 0000001a
[  114.144698] 1b20: 7e069980 0000fb00 7e0660f0 00000000 7e06aa78 00000002 00000000 00000000
[  114.152832] 1b40: df8ce62b b9533703 00000000 e5243720 000005a8 00000000 c4d5d080 001b8e30
[  114.160967] 1b60: 0000fe88 7e06aa78 000005a8 00000000 c4909500 c11ec5b8 b23f0684 00000000
[  114.169102] 1b80: 00000000 c4909604 00000000 0000002d fff9aed0 ffffffff 00010001 00000107
[  114.177237] 1ba0: 000005a8 00034ac8 001b8e30 00034ac8 c2406708 000005a8 00000020 c4909500
[  114.185372] 1bc0: c4d9d900 c4909500 00000020 c4b07874 00000020 c2619480 c4909500 c11ed500
[  114.193507] 1be0: 00000a20 b9533703 00000020 c4909500 c4d9d900 c2406708 00000020 c11e732c
[  114.201642] 1c00: c2f9c674 e5243720 00000000 c4909500 c4d9d900 c3e1b280 00000000 c2406708
[  114.209776] 1c20: c4b07860 c2619480 c4909500 c11f363c 00000000 00000001 c4909500 c11f5004
[  114.217911] 1c40: 00072680 c1f2c684 c2fc3800 c2fc3840 00000001 c2406708 c236fcd8 c2406708
[  114.226046] 1c60: c4909500 c2fc3804 00000000 00000000 00000000 c28f1cd0 00000000 e5243720
[  114.234181] 1c80: 00000000 c2623100 c4d9d900 c240a074 c2619480 00000000 c3e1b280 c28f1d84
[  114.242315] 1ca0: c4d9d900 c11c6e94 00000001 c11991b0 c4d9d900 c2406708 c2619480 00000001
[  114.250450] 1cc0: c28f1d84 c11c7188 c4d9d900 c11c7288 00000001 c28f1c02 c2f7a000 00000000
[  114.258585] 1ce0: 00000000 c2619480 c11c713c e5243720 c2619480 c4d9d840 c4d9d840 c28f1d30
[  114.266720] 1d00: 00000000 c11c61e4 c28f1d84 c28f1d84 c28f1d84 c28f1d30 c28f1d84 c11c682c
[  114.274855] 1d20: c240a95c c2619480 00000008 c2406708 c4d9d840 c4d9dd80 c2f7a000 00000000
[  114.282990] 1d40: 00000000 c2619480 c11c6694 e5243720 c28f1dcc c28f1dd4 c4d9dd80 c2f7a000
[  114.291125] 1d60: c2619480 c28f1dd4 c2f7a000 c2619480 c28f1d84 c11c7458 c28f1dd4 c2406708
[  114.299260] 1d80: c4d9dd80 c28f1d84 c28f1d84 e5243720 c2f7a608 c2f7a68c c28f1dd4 c240a95c
[  114.307395] 1da0: 00000000 c2f7a000 00000000 c2f7a000 c2f7a68c c10ff4d8 00000000 c2406708
[  114.315530] 1dc0: 00000000 00000000 c2f7a000 c2f7a68c c240a95c c28f1dd4 c28f1dd4 e5243720
[  114.323665] 1de0: 00000800 c2f7a68c c2f7a68c c2f7a68c 00000000 c2406708 c2700acc c28f0000
[  114.331800] 1e00: 00000000 c10ff78c 00000000 c4b0a840 c2f7a580 c28f1e14 c28f1e14 c2f7a000
[  114.339935] 1e20: c2f7a000 e5243720 00000800 c2f7a608 c2f7a68c c2f7a608 00000000 c2403d00
[  114.348070] 1e40: 00000001 c28f1ecc c265ac80 c10ff9c4 c2f7a608 00000000 c2f7a608 c11007b4
[  114.356205] 1e60: 00000004 00000040 c2f7aa18 c2f7aa38 c2403d00 c2f7a608 00000004 f088a000
[  114.364340] 1e80: 00000040 c2403d00 0000012c c28f1ecc c265ac80 c0d51014 c2f7a608 00000001
[  114.372475] 1ea0: 00000040 ffffb752 c2403d00 c110091c c2406708 eb3adb80 c2370b80 2903d000
[  114.380609] 1ec0: ffffe000 c240675c 00000000 c28f1ecc c28f1ecc c28f1ed4 c28f1ed4 e5243720
[  114.388744] 1ee0: c2403080 c240308c 00000001 00000001 00000003 ffffe000 c2654040 00000100
[  114.396879] 1f00: c2403080 c04013f0 00000000 c1404b34 c2364390 c236fdc0 c240675c 00000009
[  114.405014] 1f20: c236431c ffffb751 c2403d00 c1608070 04208040 c28db200 ffffe000 c28ab240
[  114.413149] 1f40: ffffe000 00000000 00000001 c24261a4 00000002 00000000 c28ab2e4 c0450180
[  114.421284] 1f60: c28ab240 c047022c c28ab2c0 c28ab280 00000000 c28f0000 c047011c c28ab240
[  114.429418] 1f80: c28cbe34 c046c5c4 00000001 c28ab280 c046c478 00000000 00000000 00000000
[  114.437552] 1fa0: 00000000 00000000 00000000 c0400278 00000000 00000000 00000000 00000000
[  114.445687] 1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[  114.453821] 1fe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
[  114.461968] [<c1158a44>] (__qdisc_run) from [<c10fd2c8>] (__dev_queue_xmit+0x238/0x998)
[  114.469935] [<c10fd2c8>] (__dev_queue_xmit) from [<c11ca978>] (ip_finish_output2+0x3c8/0x658)
[  114.478418] [<c11ca978>] (ip_finish_output2) from [<c11cd44c>] (ip_output+0xd8/0x15c)
[  114.486209] [<c11cd44c>] (ip_output) from [<c11cce10>] (__ip_queue_xmit+0x154/0x3dc)
[  114.493914] [<c11cce10>] (__ip_queue_xmit) from [<c11eae60>] (__tcp_transmit_skb+0x558/0xaf8)
[  114.502397] [<c11eae60>] (__tcp_transmit_skb) from [<c11ec5b8>] (tcp_write_xmit+0x230/0x1148)
[  114.510879] [<c11ec5b8>] (tcp_write_xmit) from [<c11ed500>] (__tcp_push_pending_frames+0x30/0x114)
[  114.519793] [<c11ed500>] (__tcp_push_pending_frames) from [<c11e732c>] (tcp_rcv_established+0x524/0x690)
[  114.529226] [<c11e732c>] (tcp_rcv_established) from [<c11f363c>] (tcp_v4_do_rcv+0x84/0x19c)
[  114.537537] [<c11f363c>] (tcp_v4_do_rcv) from [<c11f5004>] (tcp_v4_rcv+0xa78/0xb58)
[  114.545157] [<c11f5004>] (tcp_v4_rcv) from [<c11c6e94>] (ip_protocol_deliver_rcu+0x30/0x2d8)
[  114.553555] [<c11c6e94>] (ip_protocol_deliver_rcu) from [<c11c7188>] (ip_local_deliver_finish+0x4c/0x5c)
[  114.562989] [<c11c7188>] (ip_local_deliver_finish) from [<c11c7288>] (ip_local_deliver+0xf0/0xfc)
[  114.571817] [<c11c7288>] (ip_local_deliver) from [<c11c61e4>] (ip_sublist_rcv_finish+0x44/0x5c)
[  114.580474] [<c11c61e4>] (ip_sublist_rcv_finish) from [<c11c682c>] (ip_sublist_rcv+0x154/0x174)
[  114.589130] [<c11c682c>] (ip_sublist_rcv) from [<c11c7458>] (ip_list_rcv+0x104/0x124)
[  114.596922] [<c11c7458>] (ip_list_rcv) from [<c10ff4d8>] (__netif_receive_skb_list_core+0x150/0x23c)
[  114.606010] [<c10ff4d8>] (__netif_receive_skb_list_core) from [<c10ff78c>] (netif_receive_skb_list_internal+0x1c8/0x2cc)
[  114.616825] [<c10ff78c>] (netif_receive_skb_list_internal) from [<c10ff9c4>] (gro_normal_list.part.45+0x14/0x28)
[  114.626949] [<c10ff9c4>] (gro_normal_list.part.45) from [<c11007b4>] (napi_complete_done+0x1a0/0x1e8)
[  114.636125] [<c11007b4>] (napi_complete_done) from [<c0d51014>] (gfar_poll_rx_sq+0x4c/0xa4)
[  114.644436] [<c0d51014>] (gfar_poll_rx_sq) from [<c110091c>] (net_rx_action+0x120/0x40c)
[  114.652488] [<c110091c>] (net_rx_action) from [<c04013f0>] (__do_softirq+0x130/0x3b8)
[  114.660282] [<c04013f0>] (__do_softirq) from [<c0450180>] (run_ksoftirqd+0x2c/0x38)
[  114.667903] [<c0450180>] (run_ksoftirqd) from [<c047022c>] (smpboot_thread_fn+0x110/0x1a8)
[  114.676127] [<c047022c>] (smpboot_thread_fn) from [<c046c5c4>] (kthread+0x14c/0x150)
[  114.683831] [<c046c5c4>] (kthread) from [<c0400278>] (ret_from_fork+0x14/0x3c)
[  114.691012] Exception stack(0xc28f1fb0 to 0xc28f1ff8)
[  114.696034] 1fa0:                                     00000000 00000000 00000000 00000000
[  114.704168] 1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[  114.712301] 1fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[  114.718881] Code: e5842048 e8960006 e5863000 e5863004 (e5812004)
[  114.725028] ---[ end trace 489a617e8b1805c4 ]---
[  114.729636] Kernel panic - not syncing: Fatal exception in interrupt
[  114.735958] CPU1: stopping
[  114.738652] CPU: 1 PID: 223 Comm: iperf3 Tainted: G      D           5.10.0-rc1-00297-g2d388e050508-dirty #709
[  114.748598] Hardware name: Freescale LS1021A
[  114.752854] [<c04120b8>] (unwind_backtrace) from [<c040c554>] (show_stack+0x10/0x14)
[  114.760561] [<c040c554>] (show_stack) from [<c13fac7c>] (dump_stack+0xc8/0xdc)
[  114.767749] [<c13fac7c>] (dump_stack) from [<c040f83c>] (do_handle_IPI+0x320/0x33c)
[  114.775367] [<c040f83c>] (do_handle_IPI) from [<c040f870>] (ipi_handler+0x18/0x20)
[  114.782902] [<c040f870>] (ipi_handler) from [<c04b0028>] (handle_percpu_devid_fasteoi_ipi+0x80/0x150)
[  114.792079] [<c04b0028>] (handle_percpu_devid_fasteoi_ipi) from [<c04a981c>] (generic_handle_irq+0x34/0x44)
[  114.801773] [<c04a981c>] (generic_handle_irq) from [<c04a9e08>] (__handle_domain_irq+0x5c/0xb4)
[  114.810430] [<c04a9e08>] (__handle_domain_irq) from [<c08f89dc>] (gic_handle_irq+0x94/0xb4)
[  114.818741] [<c08f89dc>] (gic_handle_irq) from [<c0400c38>] (__irq_svc+0x58/0x74)
[  114.826181] Exception stack(0xc4d69d78 to 0xc4d69dc0)
[  114.831202] 9d60:                                                       c4909570 00000000
[  114.839337] 9d80: 000075bf 000075be c4d69e20 c4909500 c4909500 bef959bc 00000068 ffffe000
[  114.847472] 9da0: bef959bc c10d9448 c4d69f08 c4d69dc8 c10da6a4 c14097c8 800e0013 ffffffff
[  114.855609] [<c0400c38>] (__irq_svc) from [<c14097c8>] (_raw_spin_lock_bh+0x44/0x58)
[  114.863314] [<c14097c8>] (_raw_spin_lock_bh) from [<c10da6a4>] (lock_sock_fast+0x10/0x5c)
[  114.871452] [<c10da6a4>] (lock_sock_fast) from [<c11d6980>] (tcp_get_info+0x8c/0x348)
[  114.879244] [<c11d6980>] (tcp_get_info) from [<c11da950>] (do_tcp_getsockopt.constprop.30+0x7ac/0x1150)
[  114.888594] [<c11da950>] (do_tcp_getsockopt.constprop.30) from [<c10d874c>] (__sys_getsockopt+0x94/0x14c)
[  114.898114] [<c10d874c>] (__sys_getsockopt) from [<c04001a0>] (ret_fast_syscall+0x0/0x4c)
[  114.906245] Exception stack(0xc4d69fa8 to 0xc4d69ff0)
[  114.911268] 9fa0:                   bef9595c 00023bd8 00000005 00000006 0000000b bef959bc
[  114.919403] 9fc0: bef9595c 00023bd8 bef95978 00000127 000241b8 bef95970 bef95980 00000001
[  114.927535] 9fe0: b6f203c4 bef95948 b6f099b0 b6bc4b8a
