Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDA51D97A1
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 15:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728878AbgESNZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 09:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbgESNZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 09:25:53 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62EA2C08C5C0
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 06:25:53 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id d7so14459640ioq.5
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 06:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=IW3NqoBh+m/rNUE564T2I5YJdaB9/oGa2xXRnMWl9ws=;
        b=JujfHeGwl0ZoYfEcqcBIh73Wwi5gy/PPU/uSX3nPEBs/mvPe+BPfSJRoioiFLEqjPJ
         47OerI1Xw7rtFTK+h05hKdMerWi5Bi07locCgInLUQNU+2pADB66SmP1XP1P+KkeWlB5
         CQ8KEjz4yUSpWUGh/Y2qpk51oJ76u1thQJzQY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=IW3NqoBh+m/rNUE564T2I5YJdaB9/oGa2xXRnMWl9ws=;
        b=fkos/BqszKOT7RD8EMUjaUJ9Kw/JDgkjiPyXODfS462UjtVYUVrIcuVguBdQr/kTu1
         g2Yo11k7ZjYS5Wm/Zn4KtKY/+Qy4VBEqSv0fMSJv9hm6e08u7gAuH6MLNbuKvWKceyhZ
         +kZX2WOmkiZl8sCtpI9djNeWvBKS+xsS3deRpTx/obqYzkLNBBw1GvKMZdzTJ63NGXC+
         hEA9NqLsrw2tj/MBzzjS1Y2u3NvefjIGMAZRN9wEYsG3PZKvXijm1uyD7X01imYk8Po1
         I4PbdZGi6p55vVSgBqp1SuBERNS4QSfOlpuYFEjCgcCrIno7bSgT1Gi07Cdsiu8Puqwt
         gSvA==
X-Gm-Message-State: AOAM5321/8H6RsNAnDUZd3jyTjd//doMDES141pMDiRhLlE+/phZry37
        ZX6X5oZsANABfpooN1fXoMBWGU36j8JUZO1My1OotBSplQHEXg==
X-Google-Smtp-Source: ABdhPJw+glUoG6miHaKXhvjI3oK4410Nwa/LG2KEgIQ8coN173AnPmoc228NBQL9J0tYjdC1Mvj2zxEnQTkIGaB0zh0=
X-Received: by 2002:a6b:3805:: with SMTP id f5mr19631651ioa.156.1589894752238;
 Tue, 19 May 2020 06:25:52 -0700 (PDT)
MIME-Version: 1.0
From:   Preetham Singh <preetham.singh@broadcom.com>
Date:   Tue, 19 May 2020 18:55:41 +0530
Message-ID: <CAHvzTzZKg6pmnyv1kxALfANrMtNVJdAzr5XchNZVzyhzz5HifQ@mail.gmail.com>
Subject: net: bridge vxlan: Kernel Panic while handling vxlan encap frames
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are observing kernel panic while handling vxlan encap frames.
While we checked vxlan driver handling of GRO rx
skb(vxlan_gro_receive), there was no RCU protection.
Can this OOPS happen upon vxlan packet rx due to RCU protection
missing in GRO receive handler?

Below is the stack trace:

[10825.419951] general protection fault: 0000 [#1] SMP
[10825.566671] CPU: 4 PID: 30711 Comm: bash Tainted: G           O
4.9.0-11-2-amd64 #1 Debian 4.9.189-3+deb9u2
[10825.587297] task: ffff8b6571f71000 task.stack: ffffaec30b96c000
[10825.593917] RIP: 0010:[<ffffffffc07c27ee>]  [<ffffffffc07c27ee>]
br_pass_frame_up+0x3e/0x160 [bridge]
[10825.604252] RSP: 0018:ffff8b673fd03c98  EFLAGS: 00010207
[10825.610194] RAX: 021091b841220211 RBX: ffff8b665f3baa00 RCX: ffffd4154dd5789f
[10825.618179] RDX: 000000000000001f RSI: ffff8b65d62c3000 RDI: ffff8b665f3baa00
[10825.626161] RBP: ffff8b66000000f8 R08: 000000000001f158 R09: 000000000000001e
[10825.634142] R10: ffff8b6568f200b4 R11: ffffffff9995e350 R12: ffff8b66000009b8
[10825.642124] R13: 0000000000000001 R14: ffff8b66451768c0 R15: 0000000000000000
[10825.650105] FS:  0000000000000000(0000) GS:ffff8b673fd00000(0000)
knlGS:0000000000000000
[10825.659156] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[10825.665580] CR2: 00007fe56de195d8 CR3: 00000002a69d0000 CR4: 0000000000360670
[10825.673562] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[10825.681542] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[10825.689520] Stack:
[10825.691768]  0000000000000000 ffff8b665f3baa00 0000000002080020
ffff8b66000000f8
000
[10825.708380]  cdf7e86fbdb8e0ae ffff8b665f3baa00 ffff8b65c6f28c00
ffff8b6568f200c8
[10825.716682] Call Trace:
[10825.719418]  <IRQ>
[10825.721563]  [<ffffffffc07c2b4b>] ?
br_handle_frame_finish+0x23b/0x410 [bridge]
[10825.729749]  [<ffffffff99b33934>] ? nf_iterate+0x54/0x60
[10825.735698]  [<ffffffffc07c2d20>] ?
br_handle_frame_finish+0x410/0x410 [bridge]
[10825.743882]  [<ffffffffc07c2e8b>] ? br_handle_frame+0x16b/0x300 [bridge]
[10825.751388]  [<ffffffffc07c2910>] ? br_pass_frame_up+0x160/0x160 [bridge]
[10825.758986]  [<ffffffff99af8e38>] ? __netif_receive_skb_core+0x308/0xa40
[10825.766488]  [<ffffffff99af904d>] ? __netif_receive_skb_core+0x51d/0xa40
[10825.773986]  [<ffffffff9962f240>] ? recalibrate_cpu_khz+0x10/0x10
[10825.780804]  [<ffffffff99af95ef>] ? netif_receive_skb_internal+0x2f/0xa0
[10825.788305]  [<ffffffff99afa438>] ? napi_gro_receive+0xb8/0xe0
[10825.794835]  [<ffffffffc0a80390>] ? gro_cell_poll+0x50/0x90 [vxlan]
[10825.801849]  [<ffffffff99af9e66>] ? net_rx_action+0x246/0x380
[10825.808279]  [<ffffffff99c085ad>] ? __do_softirq+0x10d/0x2b0
[10825.814615]  [<ffffffff996812a2>] ? irq_exit+0xc2/0xd0
[10825.820365]  [<ffffffff99c07637>] ? do_IRQ+0x57/0xe0
[10825.825923]  [<ffffffff99c051de>] ? common_interrupt+0x9e/0x9e
[10825.832443]  <EOI>
[10825.834597]  [<ffffffff997c9d8f>] ? unlink_anon_vmas+0x11f/0x180
[10825.841322]  [<ffffffff997b8742>] ? free_pgtables+0x92/0x120
[10825.847654]  [<ffffffff997c30b0>] ? exit_mmap+0xb0/0x150
[10825.853597]  [<ffffffff99677744>] ? mmput+0x54/0x100
[10825.859149]  [<ffffffff9967f419>] ? do_exit+0x279/0xb60
[10825.865000]  [<ffffffff9967fd7a>] ? do_group_exit+0x3a/0xa0
[10825.871226]  [<ffffffff9967fdf0>] ? SyS_exit_group+0x10/0x10
[10825.877561]  [<ffffffff99603b7d>] ? do_syscall_64+0x8d/0x100
[10825.883898]  [<ffffffff99c048ce>] ? entry_SYSCALL_64_after_swapgs+0x58/0xc6
[10825.891676] Code: 48 48 8b 6f 28 65 48 8b 04 25 28 00 00 00 48 89
44 24 40 31 c0 4c 8d a5 c0 08 00 00 48 8b 85 e0 08 00 00 65 48 03 05
ea a9 84 3f <48> 83 00 01 8b 97 80 00 00 00 48 01 50 08 f6 85 09 02 00
00 01
[10825.913101] RIP  [<ffffffffc07c27ee>] br_pass_frame_up+0x3e/0x160 [bridge]
[10825.920807]  RSP <ffff8b673fd03c98>


Preetham
