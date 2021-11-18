Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1793455CDE
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 14:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbhKRNpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 08:45:05 -0500
Received: from fgw20-4.mail.saunalahti.fi ([62.142.5.107]:59423 "EHLO
        fgw20-4.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230349AbhKRNpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 08:45:04 -0500
X-Greylist: delayed 964 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Nov 2021 08:45:04 EST
Received: from darkstar.musicnaut.iki.fi (85-76-67-64-nat.elisa-mobile.fi [85.76.67.64])
        by fgw20.mail.saunalahti.fi (Halon) with ESMTP
        id 0fb7db22-4873-11ec-8d6d-005056bd6ce9;
        Thu, 18 Nov 2021 15:25:57 +0200 (EET)
Date:   Thu, 18 Nov 2021 15:25:56 +0200
From:   Aaro Koskinen <aaro.koskinen@iki.fi>
To:     Johannes Berg <johannes.berg@intel.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [BISECTED REGRESSION] Wireless networking kernel crashes
Message-ID: <20211118132556.GD334428@darkstar.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I have tried to upgrade my wireless AP (Raspberry Pi with rt2x00usb)
from v5.9 to the current mainline, but now it keeps crashing every hour
or so, basically making my wireless network unusable.

I have bisected this to:

commit 03c3911d2d67a43ad4ffd15b534a5905d6ce5c59
Author: Ryder Lee <ryder.lee@mediatek.com>
Date:   Thu Jun 17 18:31:12 2021 +0200

    mac80211: call ieee80211_tx_h_rate_ctrl() when dequeue

With the previous commit the system stays up for weeks...

I just tried today's mainline, and it crashed after 10 minutes:

[  603.545437] ------------[ cut here ]------------
[  603.550148] WARNING: CPU: 1 PID: 45 at include/net/mac80211.h:2742 rt2x00queue_create_tx_descriptor+0x4b0/0x4c8
[  603.560378] CPU: 1 PID: 45 Comm: kworker/u8:1 Not tainted 5.16.0-rc1-rpi32-los_25d00-00021-g42eb8fdac2fc #1
[  603.570200] Hardware name: BCM2835
[  603.573649] Workqueue: phy0 rt2x00usb_work_rxdone
[  603.578459] [<b010bec8>] (unwind_backtrace) from [<b0109f14>] (show_stack+0x10/0x14)
[  603.586277] [<b0109f14>] (show_stack) from [<b06f5f14>] (dump_stack_lvl+0x40/0x4c)
[  603.593924] [<b06f5f14>] (dump_stack_lvl) from [<b06ed554>] (__warn+0xa0/0xc8)
[  603.601226] [<b06ed554>] (__warn) from [<b06ed5d8>] (warn_slowpath_fmt+0x5c/0xc8)
[  603.608808] [<b06ed5d8>] (warn_slowpath_fmt) from [<b0463ea4>] (rt2x00queue_create_tx_descriptor+0x4b0/0x4c8)
[  603.618841] [<b0463ea4>] (rt2x00queue_create_tx_descriptor) from [<b046481c>] (rt2x00queue_write_tx_frame+0x34/0x454)
[  603.629540] [<b046481c>] (rt2x00queue_write_tx_frame) from [<b0462564>] (rt2x00mac_tx+0x8c/0x360)
[  603.638542] [<b0462564>] (rt2x00mac_tx) from [<b06ac828>] (ieee80211_tx_frags+0x158/0x22c)
[  603.646894] [<b06ac828>] (ieee80211_tx_frags) from [<b06adffc>] (__ieee80211_tx.constprop.0+0x60/0x154)
[  603.656369] [<b06adffc>] (__ieee80211_tx.constprop.0) from [<b06b18ac>] (ieee80211_tx+0x114/0x144)
[  603.665406] [<b06b18ac>] (ieee80211_tx) from [<b06b46f8>] (ieee80211_tx_pending+0xb8/0x298)
[  603.673837] [<b06b46f8>] (ieee80211_tx_pending) from [<b012450c>] (tasklet_action_common.constprop.0+0xc0/0xd8)
[  603.684011] [<b012450c>] (tasklet_action_common.constprop.0) from [<b01012c4>] (__do_softirq+0xc4/0x23c)
[  603.693606] [<b01012c4>] (__do_softirq) from [<b0123e60>] (do_softirq+0x60/0x68)
[  603.701079] [<b0123e60>] (do_softirq) from [<b0123f30>] (__local_bh_enable_ip+0xc8/0xdc)
[  603.709251] [<b0123f30>] (__local_bh_enable_ip) from [<b0461694>] (rt2x00lib_rxdone+0x2c0/0x650)
[  603.718111] [<b0461694>] (rt2x00lib_rxdone) from [<b04662c4>] (rt2x00usb_work_rxdone+0x50/0x9c)
[  603.726879] [<b04662c4>] (rt2x00usb_work_rxdone) from [<b01364bc>] (process_one_work+0x1c4/0x408)
[  603.735832] [<b01364bc>] (process_one_work) from [<b0136728>] (worker_thread+0x28/0x4dc)
[  603.744002] [<b0136728>] (worker_thread) from [<b013bf64>] (kthread+0x158/0x184)
[  603.751516] [<b013bf64>] (kthread) from [<b0100148>] (ret_from_fork+0x14/0x2c)
[  603.758836] Exception stack(0xb13edfb0 to 0xb13edff8)
[  603.763941] dfa0:                                     00000000 00000000 00000000 00000000
[  603.772159] dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[  603.780382] dfe0: 00000000 00000000 00000000 00000000 00000013 00000000
[  603.787081] ---[ end trace 55e1e82e78938beb ]---
[  603.791783] 8<--- cut here ---
[  603.794883] Unable to handle kernel NULL pointer dereference at virtual address 00000006
[  603.803057] [00000006] *pgd=00000000
[  603.806730] Internal error: Oops: 17 [#1] PREEMPT SMP ARM
[  603.812177] CPU: 1 PID: 45 Comm: kworker/u8:1 Tainted: G        W         5.16.0-rc1-rpi32-los_25d00-00021-g42eb8fdac2fc #1
[  603.823361] Hardware name: BCM2835
[  603.826807] Workqueue: phy0 rt2x00usb_work_rxdone
[  603.831595] PC is at rt2x00queue_create_tx_descriptor+0x424/0x4c8
[  603.837739] LR is at rt2x00queue_create_tx_descriptor+0x4b0/0x4c8
[  603.843879] pc : [<b0463e18>]    lr : [<b0463ea4>]    psr: 60000013
[  603.850199] sp : b13edc98  ip : 00000000  fp : 00000002
[  603.855486] r10: b13edda4  r9 : 00000002  r8 : 00000000
[  603.860744] r7 : b23cc7a0  r6 : b23c7760  r5 : b115c300  r4 : b13edcc0
[  603.867317] r3 : 00000000  r2 : 00000000  r1 : b0cc0858  r0 : 00000000
[  603.873897] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[  603.881096] Control: 10c5387d  Table: 025e806a  DAC: 00000051
[  603.886877] Register r0 information: NULL pointer
[  603.891653] Register r1 information: non-slab/vmalloc memory
[  603.897385] Register r2 information: NULL pointer
[  603.902137] Register r3 information: NULL pointer
[  603.906892] Register r4 information: non-slab/vmalloc memory
[  603.912608] Register r5 information: slab skbuff_head_cache start b115c300 pointer offset 0 size 48
[  603.921776] Register r6 information: slab kmalloc-8k start b23c6000 pointer offset 5984 size 8192
[  603.930735] Register r7 information: slab kmalloc-4k start b23cc000 pointer offset 1952 size 4096
[  603.939686] Register r8 information: NULL pointer
[  603.944434] Register r9 information: non-paged memory
[  603.949540] Register r10 information: non-slab/vmalloc memory
[  603.955333] Register r11 information: non-paged memory
[  603.960522] Register r12 information: NULL pointer
[  603.965375] Process kworker/u8:1 (pid: 45, stack limit = 0x90ded79a)
[  603.971786] Stack: (0xb13edc98 to 0xb13ee000)
[  603.976196] dc80:                                                       b10e7d08 00000000
[  603.984429] dca0: b115c300 b13edd58 b10e7d08 b046481c ec896000 80150003 b0537a48 b1d83f00
[  603.992681] dcc0: 00000088 001805c0 00000000 00000000 00000000 00000000 00000000 00000000
[  604.000926] dce0: 00000000 00000000 00000000 b0b05e88 0000f8a0 b115c300 b23c6500 b23c7760
[  604.009158] dd00: b13edd58 b10e7d08 00000002 b13edda4 00000002 b0462564 00000000 00000000
[  604.017393] dd20: 00000000 00000000 00000000 b13edda4 b23c6500 b04624d8 00000001 00000000
[  604.025630] dd40: b23c6a1c b13edda4 00000002 b06ac828 b23c2d48 b23cc7a0 b23cc7a0 b0b05e88
[  604.033869] dd60: b115c300 b115c300 b13edda4 b23c2540 00000001 b23c6500 b23c2540 b23c6724
[  604.042114] dd80: b23c6500 b06adffc 00000001 b23c6500 b115c300 00000000 b23c2540 b06b18ac
[  604.050343] dda0: 00000000 b13edda4 b13edda4 00000000 00000000 b23c6500 b23c2540 b23cc000
[  604.058570] ddc0: b20ee800 00000000 00000002 b0b05e88 b115c300 b23c6b84 20000013 b23c6a1c
[  604.066816] dde0: 00000000 b06b46f8 b23c6504 00000002 00000001 8015000f b21c2780 00000000
[  604.075066] de00: b23c6c68 b0b05e88 00000000 b23c6c64 00000000 ec8332b0 b0abdec0 00000040
[  604.083304] de20: 40000006 b13ede48 00000006 b012450c 00000000 b0b03098 00000101 b0b03080
[  604.091555] de40: b12a8000 b01012c4 b12d3ac8 b23c6500 b13ede74 0000000a 0004a1b9 04208060
[  604.099805] de60: 00000100 60000013 b23c7760 b1e92b40 b2241300 00000000 00000100 b21e0505
[  604.108040] de80: b0cba7b0 b0123e60 00000001 b0123f30 b12d3ac8 b0461694 b12a8280 ec836340
[  604.116265] dea0: 00000000 00000000 00000000 ffffffcd 00000018 00000000 0000000c 00000000
[  604.124514] dec0: 00000000 00000000 00000004 00000000 00000000 00000000 00000000 b0b05e88
[  604.132754] dee0: b23c7b80 b13edf04 b1006200 b21e0500 00000000 00000100 b21e0505 b04662c4
[  604.140991] df00: b13edf4c 00000028 b10e7d60 b0b03d00 b23c7760 b0471008 b23c7760 b23c7b90
[  604.149233] df20: b23c7b80 b0b05e88 b1006200 b23c7b80 b1201a00 b01364bc b1006218 b0b03d00
[  604.157470] df40: b1201a00 b1006200 b1201a18 b1006218 b0b03d00 00000088 b1006200 b0136728
[  604.165695] df60: 00000000 b1207e80 00000000 b1207ec0 b12a8000 b0136700 b1201a00 b1073ec4
[  604.173924] df80: b1207ee0 b013bf64 00000000 b1207e80 b013be0c 00000000 00000000 00000000
[  604.182161] dfa0: 00000000 00000000 00000000 b0100148 00000000 00000000 00000000 00000000
[  604.190406] dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[  604.198638] dfe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
[  604.206856] [<b0463e18>] (rt2x00queue_create_tx_descriptor) from [<b046481c>] (rt2x00queue_write_tx_frame+0x34/0x454)
[  604.217572] [<b046481c>] (rt2x00queue_write_tx_frame) from [<b0462564>] (rt2x00mac_tx+0x8c/0x360)
[  604.226521] [<b0462564>] (rt2x00mac_tx) from [<b06ac828>] (ieee80211_tx_frags+0x158/0x22c)
[  604.234894] [<b06ac828>] (ieee80211_tx_frags) from [<b06adffc>] (__ieee80211_tx.constprop.0+0x60/0x154)
[  604.244388] [<b06adffc>] (__ieee80211_tx.constprop.0) from [<b06b18ac>] (ieee80211_tx+0x114/0x144)
[  604.253424] [<b06b18ac>] (ieee80211_tx) from [<b06b46f8>] (ieee80211_tx_pending+0xb8/0x298)
[  604.261852] [<b06b46f8>] (ieee80211_tx_pending) from [<b012450c>] (tasklet_action_common.constprop.0+0xc0/0xd8)
[  604.272022] [<b012450c>] (tasklet_action_common.constprop.0) from [<b01012c4>] (__do_softirq+0xc4/0x23c)
[  604.281581] [<b01012c4>] (__do_softirq) from [<b0123e60>] (do_softirq+0x60/0x68)
[  604.289048] [<b0123e60>] (do_softirq) from [<b0123f30>] (__local_bh_enable_ip+0xc8/0xdc)
[  604.297207] [<b0123f30>] (__local_bh_enable_ip) from [<b0461694>] (rt2x00lib_rxdone+0x2c0/0x650)
[  604.306079] [<b0461694>] (rt2x00lib_rxdone) from [<b04662c4>] (rt2x00usb_work_rxdone+0x50/0x9c)
[  604.314872] [<b04662c4>] (rt2x00usb_work_rxdone) from [<b01364bc>] (process_one_work+0x1c4/0x408)
[  604.323825] [<b01364bc>] (process_one_work) from [<b0136728>] (worker_thread+0x28/0x4dc)
[  604.331988] [<b0136728>] (worker_thread) from [<b013bf64>] (kthread+0x158/0x184)
[  604.339464] [<b013bf64>] (kthread) from [<b0100148>] (ret_from_fork+0x14/0x2c)
[  604.346756] Exception stack(0xb13edfb0 to 0xb13edff8)
[  604.351873] dfa0:                                     00000000 00000000 00000000 00000000
[  604.360112] dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[  604.368335] dfe0: 00000000 00000000 00000000 00000000 00000013 00000000
[  604.375013] Code: e283303a e7913103 e5933004 e0833102 (e5d38006) 

A.
