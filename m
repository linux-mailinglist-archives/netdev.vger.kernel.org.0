Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E99D553849
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 18:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbiFUQ7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 12:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiFUQ7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 12:59:06 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA431CB1C
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 09:59:05 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id o23so9049427ljg.13
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 09:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=afy4eMgBXCIabtl8QML/Y7RM9FY8FZmgpNvIiiD2B20=;
        b=XWRpLFjqOXt90xNFK34pVC27R5LWQVhyvNK2xPMNcgxHP+QIzfAYEa1OBrTUUD6qeT
         NlkFM7pOrT0b2uXhusYO7qm3JzdzTK5D7YWPiGvCOroOWz556TOheS8TsakJe9vz3ujK
         EQW7mEex3/2Rxa1iNlfyKDDNKpdmeyvX83Rvs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=afy4eMgBXCIabtl8QML/Y7RM9FY8FZmgpNvIiiD2B20=;
        b=SuUSU6lCrigWaZUavK5k71ggXljst0Hki85Ka+2BOLTlTujPLKwF9Pgg/ahoYxxY/t
         lTNOnjnU9nIi+1bUsOCOb3SUWcuHA/y3aIl4TlYV9MJv/5H0gDAV09Li3LyM9CRdPI1/
         y3H0ZU/vFHSDyIy5Wiy6sK8MF3iUQb86TIjLNj2HJ2EvGoCq6r3gMRU8ZNHQxMspZv7l
         bGWvdfzkzC75MpGp0VFVMu3glVF9XBlbxNCwrA7Y1N63Nqvnbs85lP0lFI+nJnRbAEht
         K5YVfo3qRQO4n7nEWHlRGVpYObXwI03oF2QV7RkD7CsL2V6dOWYcaeIpzx3Vvg9/KkMF
         vkyg==
X-Gm-Message-State: AJIora8Ij6IqKgvUtjCwZmFYxJBew2yGoy/Wb5bwpMW0b6amu8aw2Nly
        ORYvqKeg/ogRb6B2JYnVpjriEN59mTW2n8auJPNTX5b9+XoY3ktT
X-Google-Smtp-Source: AGRyM1s/1StHe9ij4B4yz6AwPcmGdxUHIPiHYwFwAya0qNFtPAn2iOKt31opKnuSBWSGJcDnoIlltH53QbM8XsXuxYs=
X-Received: by 2002:a2e:b603:0:b0:25a:6dbc:c6f7 with SMTP id
 r3-20020a2eb603000000b0025a6dbcc6f7mr6106413ljn.300.1655830743751; Tue, 21
 Jun 2022 09:59:03 -0700 (PDT)
MIME-Version: 1.0
From:   Frank Hofmann <fhofmann@cloudflare.com>
Date:   Tue, 21 Jun 2022 17:58:52 +0100
Message-ID: <CABEBQi=ySE-ta5r_Rin4xN7XwrZ-GR7NaqDPUGXzJNTitbmb3g@mail.gmail.com>
Subject: [Q]: "kernel BUG at net/core/skbuff.c:2185!" - known issue ?
To:     netdev@vger.kernel.org
Cc:     kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,PLING_QUERY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

we're seeing BUG splats with stacks like:

[6514198.051700][   C75] ------------[ cut here ]------------
[6514198.066833][   C75] kernel BUG at net/core/skbuff.c:2194!
[6514198.081919][   C75] invalid opcode: 0000 [#1] SMP NOPTI
[6514198.096676][   C75] CPU: 75 PID: 0 Comm: swapper/75 Tainted: G
       O      5.15.32-cloudflare-2022.3.17 #1 [6514198.125512][   C75]
Hardware name: HYVE EDGE-METAL-GEN10/HS-1811DLite1, BIOS V2.80-sig
03/21/2022 [6514198.152869][   C75] RIP:
0010:__pskb_pull_tail+0x3b6/0x3d0 [6514198.167637][   C75] Code: 34 3a
e8 6d fc ff ff 48 8b 7c 24 08 48 85 c0 75 b9 48 89 df e8 cb cf ff ff
48 83 c4 10 31 c0 5b 41 5c 41 5d 41 5e 41 5f 5d c3 <0f> 0b 4a 8d 14 06
44 0f b6 7a 02 e9 94 fe ff ff 4c 89 f7 31 db e9 [6514198.214396][
C75] RSP: 0018:ffff93accd5fc9a8 EFLAGS: 00010282 [6514198.229430][
C75] RAX: 00000000fffffff2 RBX: 00000000000005e8 RCX: 00000000000005b4
[6514198.246318][   C75] RDX: ffff91ac797d2100 RSI: ffff91ac797d2000
RDI: 0000000000000ec0 [6514198.263075][   C75] RBP: ffff93accd5fc9e0
R08: 0000000000001000 R09: 0000000000000001 [6514198.263079][   C75]
R10: ffff91ac797d2000 R11: 0000000000000002 R12: ffff9190c0b08ae0
[6514198.263081][   C75] R13: 00000000000005b4 R14: ffffffffc05673b8
R15: ffff93accd5fcb60 [6514198.263082][   C75] FS:
0000000000000000(0000) GS:ffff91b03fcc0000(0000)
knlGS:0000000000000000 [6514198.263084][   C75] CS:  0010 DS: 0000 ES:
0000 CR0: 0000000080050033 [6514198.263086][   C75] CR2:
000000c002d8d000 CR3: 0000002c8aaa8000 CR4: 0000000000350ee0
[6514198.263088][   C75] Call Trace: [6514198.263091][   C75]  <IRQ>
[6514198.390262][   C75]  skb_ensure_writable+0x85/0xa0
[6514198.402710][   C75]  tcpmss_mangle_packet+0x77/0x4d0 [xt_TCPMSS]
[6514198.402719][   C75]  ? ip_set_test+0xaa/0x170 [ip_set]
[6514198.428794][   C75]  ? set_match_v4+0xa0/0xd0 [xt_set]
[6514198.441327][   C75]  tcpmss_tg4+0x31/0x9b [xt_TCPMSS]
[6514198.441335][   C75]  ipt_do_table+0x300/0x650 [ip_tables]
[6514198.465724][   C75]  nf_hook_slow+0x41/0xb0 [6514198.476603][
C75]  ip_output+0xdb/0x120 [6514198.476611][   C75]  ?
__ip_finish_output+0x1a0/0x1a0 [6514198.476615][   C75]
__ip_queue_xmit+0x172/0x400 [6514198.509393][   C75]  ?
sk_stream_alloc_skb+0x63/0x2b0 [6514198.520494][   C75]
__tcp_transmit_skb+0xa38/0xbd0 [6514198.531274][   C75]
__tcp_retransmit_skb+0x181/0x890 [6514198.542055][   C75]  ?
enqueue_task_fair+0xf5/0x680 [6514198.552537][   C75]  ?
bbr_set_state+0x75/0x80 [tcp_bbr] [6514198.563453][   C75]
tcp_retransmit_skb+0x12/0x80 [6514198.573731][   C75]
tcp_retransmit_timer+0x392/0x950 [6514198.584262][   C75]
tcp_write_timer_handler+0x16c/0x250 [6514198.594954][   C75]
tcp_write_timer+0x8d/0xc0 [6514198.604714][   C75]  ?
tcp_write_timer_handler+0x250/0x250 [6514198.615264][   C75]
call_timer_fn+0x26/0xf0 [6514198.624515][   C75]
__run_timers.part.0+0x1b3/0x220 [6514198.634459][   C75]  ?
__hrtimer_run_queues+0x152/0x270 [6514198.644429][   C75]  ?
recalibrate_cpu_khz+0x10/0x10 [6514198.653992][   C75]  ?
ktime_get+0x38/0xa0 [6514198.662585][   C75]
run_timer_softirq+0x56/0xd0 [6514198.671645][   C75]
__do_softirq+0xbf/0x25c [6514198.680310][   C75]
irq_exit_rcu+0x7f/0xa0 [6514198.688834][   C75]
sysvec_apic_timer_interrupt+0x72/0x90

it's not a "frequent" occurrance; about once per month across our
fleet, different systems / different locations.

The codepath is always the same, TCP retransmit -> mangle hook tcp_mss
-> __pksb_pull_tail, and hits the splat at
https://elixir.bootlin.com/linux/v5.15.32/source/net/core/skbuff.c#L2194

Also context: Our kernel is "almost-stock" 5.15.32 - we carry less
than ten feature and driver patches that aren't mainlined or
backported to linux-stable. We touch net/core/filter.c for BPF socket
lookup enhancements not in linux-stable yet, but no other changes to
net/core vs. mainline.

Is this known ?

I've stumbled over this report from last year, where the same BUG()
line was hit but via a different codepath,
https://www.spinics.net/lists/netdev/msg768712.html - not noticed a
follow up there though.

Thanks in advance,
Frank Hofmann
