Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F057B5A8EC0
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 08:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232435AbiIAGwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 02:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232685AbiIAGwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 02:52:07 -0400
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902A71157C0;
        Wed, 31 Aug 2022 23:52:05 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VNxiw1q_1662015119;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0VNxiw1q_1662015119)
          by smtp.aliyun-inc.com;
          Thu, 01 Sep 2022 14:52:00 +0800
Date:   Thu, 1 Sep 2022 14:51:59 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     liuyacan@corp.netease.com
Cc:     davem@davemloft.net, edumazet@google.com, kgraul@linux.ibm.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        ubraun@linux.vnet.ibm.com, pabeni@redhat.com, wenjia@linux.ibm.com,
        wintera@linux.ibm.com
Subject: Re: [PATCH net v4] net/smc: Fix possible access to freed memory in
 link clear
Message-ID: <YxBWj9HdG7SIStjW@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <Yw4bgV6c0LQ6reMc@TonyMac-Alibaba>
 <20220831155303.1758868-1-liuyacan@corp.netease.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831155303.1758868-1-liuyacan@corp.netease.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 31, 2022 at 11:53:03PM +0800, liuyacan@corp.netease.com wrote:
> From: Yacan Liu <liuyacan@corp.netease.com>
> 
> After modifying the QP to the Error state, all RX WR would be completed
> with WC in IB_WC_WR_FLUSH_ERR status. Current implementation does not
> wait for it is done, but destroy the QP and free the link group directly.
> So there is a risk that accessing the freed memory in tasklet context.
> 
> Here is a crash example:
> 
>  BUG: unable to handle page fault for address: ffffffff8f220860
>  #PF: supervisor write access in kernel mode
>  #PF: error_code(0x0002) - not-present page
>  PGD f7300e067 P4D f7300e067 PUD f7300f063 PMD 8c4e45063 PTE 800ffff08c9df060
>  Oops: 0002 [#1] SMP PTI
>  CPU: 1 PID: 0 Comm: swapper/1 Kdump: loaded Tainted: G S         OE     5.10.0-0607+ #23
>  Hardware name: Inspur NF5280M4/YZMB-00689-101, BIOS 4.1.20 07/09/2018
>  RIP: 0010:native_queued_spin_lock_slowpath+0x176/0x1b0
>  Code: f3 90 48 8b 32 48 85 f6 74 f6 eb d5 c1 ee 12 83 e0 03 83 ee 01 48 c1 e0 05 48 63 f6 48 05 00 c8 02 00 48 03 04 f5 00 09 98 8e <48> 89 10 8b 42 08 85 c0 75 09 f3 90 8b 42 08 85 c0 74 f7 48 8b 32
>  RSP: 0018:ffffb3b6c001ebd8 EFLAGS: 00010086
>  RAX: ffffffff8f220860 RBX: 0000000000000246 RCX: 0000000000080000
>  RDX: ffff91db1f86c800 RSI: 000000000000173c RDI: ffff91db62bace00
>  RBP: ffff91db62bacc00 R08: 0000000000000000 R09: c00000010000028b
>  R10: 0000000000055198 R11: ffffb3b6c001ea58 R12: ffff91db80e05010
>  R13: 000000000000000a R14: 0000000000000006 R15: 0000000000000040
>  FS:  0000000000000000(0000) GS:ffff91db1f840000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: ffffffff8f220860 CR3: 00000001f9580004 CR4: 00000000003706e0
>  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>  Call Trace:
>   <IRQ>
>   _raw_spin_lock_irqsave+0x30/0x40
>   mlx5_ib_poll_cq+0x4c/0xc50 [mlx5_ib]
>   smc_wr_rx_tasklet_fn+0x56/0xa0 [smc]
>   tasklet_action_common.isra.21+0x66/0x100
>   __do_softirq+0xd5/0x29c
>   asm_call_irq_on_stack+0x12/0x20
>   </IRQ>
>   do_softirq_own_stack+0x37/0x40
>   irq_exit_rcu+0x9d/0xa0
>   sysvec_call_function_single+0x34/0x80
>   asm_sysvec_call_function_single+0x12/0x20
> 
> Fixes: bd4ad57718cc ("smc: initialize IB transport incl. PD, MR, QP, CQ, event, WR")
> Signed-off-by: Yacan Liu <liuyacan@corp.netease.com>
> 

Thanks for this fixes. I will test it in our environment.

Cheers,
Tony Lu
