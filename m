Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FAD0449F38
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 00:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241034AbhKHX4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 18:56:21 -0500
Received: from mga05.intel.com ([192.55.52.43]:3677 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238960AbhKHX4U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 18:56:20 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10162"; a="318543939"
X-IronPort-AV: E=Sophos;i="5.87,218,1631602800"; 
   d="scan'208";a="318543939"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2021 15:53:33 -0800
X-IronPort-AV: E=Sophos;i="5.87,218,1631602800"; 
   d="scan'208";a="451673779"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.10])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2021 15:53:33 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vedang Patel <vedang.patel@intel.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] net/sched: sch_taprio: fix undefined behavior in
 ktime_mono_to_any
In-Reply-To: <20211108180815.1822479-1-eric.dumazet@gmail.com>
References: <20211108180815.1822479-1-eric.dumazet@gmail.com>
Date:   Mon, 08 Nov 2021 15:53:33 -0800
Message-ID: <87sfw6mcg2.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

Eric Dumazet <eric.dumazet@gmail.com> writes:

> From: Eric Dumazet <edumazet@google.com>
>
> 1) if q->tk_offset == TK_OFFS_MAX, then get_tcp_tstamp() calls
>    ktime_mono_to_any() with out-of-bound value.
>
> 2) if q->tk_offset is changed in taprio_parse_clockid(),
>    taprio_get_time() might also call ktime_mono_to_any()
>    with out-of-bound value as sysbot found:
>
> UBSAN: array-index-out-of-bounds in kernel/time/timekeeping.c:908:27
> index 3 is out of range for type 'ktime_t *[3]'
> CPU: 1 PID: 25668 Comm: kworker/u4:0 Not tainted 5.15.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: bat_events batadv_iv_send_outstanding_bat_ogm_packet
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>  ubsan_epilogue+0xb/0x5a lib/ubsan.c:151
>  __ubsan_handle_out_of_bounds.cold+0x62/0x6c lib/ubsan.c:291
>  ktime_mono_to_any+0x1d4/0x1e0 kernel/time/timekeeping.c:908
>  get_tcp_tstamp net/sched/sch_taprio.c:322 [inline]
>  get_packet_txtime net/sched/sch_taprio.c:353 [inline]
>  taprio_enqueue_one+0x5b0/0x1460 net/sched/sch_taprio.c:420
>  taprio_enqueue+0x3b1/0x730 net/sched/sch_taprio.c:485
>  dev_qdisc_enqueue+0x40/0x300 net/core/dev.c:3785
>  __dev_xmit_skb net/core/dev.c:3869 [inline]
>  __dev_queue_xmit+0x1f6e/0x3630 net/core/dev.c:4194
>  batadv_send_skb_packet+0x4a9/0x5f0 net/batman-adv/send.c:108
>  batadv_iv_ogm_send_to_if net/batman-adv/bat_iv_ogm.c:393 [inline]
>  batadv_iv_ogm_emit net/batman-adv/bat_iv_ogm.c:421 [inline]
>  batadv_iv_send_outstanding_bat_ogm_packet+0x6d7/0x8e0 net/batman-adv/bat_iv_ogm.c:1701
>  process_one_work+0x9b2/0x1690 kernel/workqueue.c:2298
>  worker_thread+0x658/0x11f0 kernel/workqueue.c:2445
>  kthread+0x405/0x4f0 kernel/kthread.c:327
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
>
> Fixes: 7ede7b03484b ("taprio: make clock reference conversions easier")
> Fixes: 54002066100b ("taprio: Adjust timestamps for TCP packets")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> Cc: Vedang Patel <vedang.patel@intel.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> ---

I just tested this and it indeed fixes a crash when the user tries to
configure the txtime-assisted mode using CLOCK_MONOTONIC.

Reviewed-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>


Cheers,
-- 
Vinicius
