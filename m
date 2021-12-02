Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE66466AFF
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 21:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348828AbhLBUoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 15:44:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348935AbhLBUoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 15:44:03 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA48CC06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 12:40:39 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id x15so3054144edv.1
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 12:40:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kQlS8fKbftCahUb+y2jeM34iHf8rweEtUbKNjTkyrGY=;
        b=UH56rgGZbRNt3PA0CfW45EhBD5JzUAOhMKfzuHM7CyJSAhruy72mQoeSZWpL448hTv
         oeJchIqkIcCMOqeAlNSIpMwOaBe0TnY3Ao6MqlO9t4zRkBYIviVzfkWts1LrWb83/RKa
         kxQrnyuHTo6ywakZmvvS7+2XyTW/oiAsEMl5xdlI/y36MYpgSRJRvsCBJZoXOATREagS
         Rlu13/QexBh66HtBpff6EupuG+B0duMR8nIaqj+DZmLyCVqY+lgmckJXWjBQV+2r0WTk
         j0MRVdRoFywnch0hC3CbzYSIxLNoymH8fy08XQTv/GMFemsaEe10nHgzmf7bUkLoJY+V
         lKCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kQlS8fKbftCahUb+y2jeM34iHf8rweEtUbKNjTkyrGY=;
        b=3emM2CfjVYViQdfgwHEmabQZG39sgZmCGI51hO34DozY+AEztr3lRGYiQjEadXLpx5
         kq/BRH0PLOT+CMoVanXDB3ESnt0rWhB0Sha5InUKzzTpmuPHwnmVmzLZ0d2Yqm4lA0uw
         fFSjj4zGcaDYf+6rlwSeF5GJpEvG7bt/rMUDpuRbBNLSbN6H3OEf18+He+1kudcOjrG1
         7ZnaIIokG5nWU/4PlU1KNZsX39dVWSJovvYDg5v4VwbvtgURazY/uw6MNc37hG6X2jyS
         b+gXaY56iUuPHdZTU4eXHTm0qWSiJxD3m0bx+TT9+8cu9Hol6+8m9AH9gPx0lpz3biin
         rOQQ==
X-Gm-Message-State: AOAM530w89FlSrmDpzYPQa902NuzUwehZcnMPFmWoJRGJ0qT6WocW/gb
        sW/42ZJV3rOdUDdhVoN6lgU=
X-Google-Smtp-Source: ABdhPJyLUuo9Nfz5Nj3B45rr8TbRJrs0GxbcMyTXLlgTowASgWtvZjgNGE98L8bxzHV5dzaJR6t7pg==
X-Received: by 2002:a17:907:2cc4:: with SMTP id hg4mr18036811ejc.112.1638477638156;
        Thu, 02 Dec 2021 12:40:38 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id e26sm513354edr.82.2021.12.02.12.40.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 12:40:37 -0800 (PST)
Date:   Thu, 2 Dec 2021 22:40:36 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        David Laight <David.Laight@aculab.com>
Subject: Re: [PATCH net-next 2/2] net: optimize skb_postpull_rcsum()
Message-ID: <20211202204036.negad3mnrm2gogjd@skbuf>
References: <20211124202446.2917972-1-eric.dumazet@gmail.com>
 <20211124202446.2917972-3-eric.dumazet@gmail.com>
 <20211202131040.rdxzbfwh2slhftg5@skbuf>
 <CANn89iLW4kwKf0x094epVeCaKhB4GtYgbDwE2=Fp0HnW8UdKzw@mail.gmail.com>
 <20211202162916.ieb2wn35z5h4aubh@skbuf>
 <CANn89iJEfDL_3C39Gp9eD=yPDqW4MGcVm7AyUBcTVdakS-X2dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iJEfDL_3C39Gp9eD=yPDqW4MGcVm7AyUBcTVdakS-X2dg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 02, 2021 at 11:32:09AM -0800, Eric Dumazet wrote:
> On Thu, Dec 2, 2021 at 8:29 AM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > On Thu, Dec 02, 2021 at 06:51:47AM -0800, Eric Dumazet wrote:
> > > Hi Vladimir
> > > > I am seeing some errors after this patch, and I am not able to
> > > > understand why. Specifically, __skb_gro_checksum_complete() hits this
> > > > condition:
> > >
> > > There were two patches, one for GRO, one for skb_postpull_rcsum()
> > >
> > > I am a bit confused by your report. Which one is causing problems ?
> >
> > I'm sorry, indeed it seems that I missed to provide that info.
> > Anyway, it is the skb_postpull_rcsum() call from the DSA switch driver,
> > that I pointed to, which seems to be problematic.
> >
> > [  754.211845] mscc_felix 0000:00:00.5 swp0: hw csum failure
> > [  754.217670] skb len=64 headroom=118 headlen=64 tailroom=1546
> > [  754.217670] mac=(84,14) net=(98,20) trans=118
> > [  754.217670] shinfo(txflags=0 nr_frags=0 gso(size=0 type=0 segs=0))
> > [  754.217670] csum(0x0 ip_summed=2 complete_sw=0 valid=0 level=0)
> > [  754.217670] hash(0x0 sw=0 l4=0) proto=0x0800 pkttype=0 iif=9
> > [  754.246905] dev name=swp0 feat=0x0x0002000000195829
> > [  754.253200] skb headroom: 00000000: ef be ad de ef be ad de ef be ad de ef be ad de
> > [  754.261751] skb headroom: 00000010: ef be ad de ef be ad de ef be ad de ef be ad de
> > [  754.269444] skb headroom: 00000020: ef be ad de ef be ad de ef be ad de ef be ad de
> > [  754.277135] skb headroom: 00000030: ef be ad de ef be ad de ef be ad de ef be ad de
> > [  754.284826] skb headroom: 00000040: 88 80 00 0a 00 3e 6b e3 36 a1 01 80 00 00 00 0f
> > [  754.292516] skb headroom: 00000050: 00 10 00 00 d2 ee 27 92 2d 6c 6a b6 a6 22 19 47
> > [  754.300207] skb headroom: 00000060: 08 00 45 00 00 54 2d 7c 00 00 40 01 03 d9 c0 a8
> > [  754.307897] skb headroom: 00000070: 64 02 c0 a8 64 01
> > [  754.312971] skb linear:   00000000: 00 00 60 4d 03 af 00 01 77 eb a8 61 00 00 00 00
> > [  754.320662] skb linear:   00000010: b6 e2 06 00 00 00 00 00 10 11 12 13 14 15 16 17
> > [  754.328352] skb linear:   00000020: 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23 24 25 26 27
> > [  754.336042] skb linear:   00000030: 28 29 2a 2b 2c 2d 2e 2f 30 31 32 33 34 35 36 37
> > [  754.343732] skb tailroom: 00000000: 00 00 00 00 00 00 00 00 00 00 ef be ad de ef be
> > [  754.351423] skb tailroom: 00000010: ad de ef be ad de ef be ad de ef be ad de ef be
> > (irrelevant tailroom trimmed)
> > [  755.088130] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.16.0-rc3-next-20211202-07010-ga9b9500ffaac-dirty #1531
> > [  755.098169] Hardware name: LS1028A RDB Board (DT)
> > [  755.102885] Call trace:
> > [  755.105333]  dump_backtrace+0x0/0x1ac
> > [  755.109016]  show_stack+0x18/0x70
> > [  755.112341]  dump_stack_lvl+0x68/0x84
> > [  755.116022]  dump_stack+0x18/0x34
> > [  755.119345]  netdev_rx_csum_fault+0x60/0x64
> > [  755.123549]  __skb_checksum_complete+0x104/0x10c
> > [  755.128180]  icmp_rcv+0x9c/0x3f0
> > [  755.131421]  ip_protocol_deliver_rcu+0x40/0x220
> > [  755.135965]  ip_local_deliver_finish+0x68/0x84
> > [  755.140421]  ip_local_deliver+0x7c/0x120
> > [  755.144353]  ip_sublist_rcv_finish+0x48/0x70
> > [  755.148643]  ip_sublist_rcv+0x168/0x1f0
> > [  755.152489]  ip_list_rcv+0xf8/0x1a0
> > [  755.155985]  __netif_receive_skb_list_core+0x184/0x214
> > [  755.161142]  netif_receive_skb_list_internal+0x180/0x29c
> > [  755.166471]  napi_complete_done+0x68/0x1bc
> > [  755.170581]  gro_cell_poll+0x80/0xa0
> > [  755.174176]  __napi_poll+0x38/0x184
> > [  755.177674]  net_rx_action+0xe8/0x280
> > [  755.181347]  __do_softirq+0x124/0x2a0
> > [  755.185019]  __irq_exit_rcu+0xe4/0x100
> > [  755.188782]  irq_exit_rcu+0x10/0x1c
> > [  755.192278]  el1_interrupt+0x38/0x84
> > [  755.195864]  el1h_64_irq_handler+0x18/0x24
> > [  755.199972]  el1h_64_irq+0x78/0x7c
> > [  755.203380]  cpuidle_enter_state+0x12c/0x2f0
> > [  755.207671]  cpuidle_enter+0x38/0x50
> > [  755.211256]  do_idle+0x214/0x29c
> > [  755.214495]  cpu_startup_entry+0x24/0x80
> > [  755.218428]  rest_init+0xe4/0xf4
> > [  755.221664]  arch_call_rest_init+0x10/0x1c
> > [  755.225778]  start_kernel+0x628/0x668
> > [  755.229450]  __primary_switched+0xc0/0xc8
> >
> > > > There seems to be a disparity when the skb->csum is calculated by
> > > > skb_postpull_rcsum as zero. Before, it was calculated as 0xffff.
> > >
> > > skb->csum is 32bit, so there are about 2^16 different values for a
> > > given Internet checksum
> >
> > I meant 0xffffffff, sorry. It is visible in the skb_dump output that it
> > was 0xffffffff before and now it is 0.
> >
> > > > Do you have some suggestions as to what may be wrong? Thanks.
> > >
> > > What kind of traffic is triggering the fault ? TCP, UDP, something else ?
> >
> > The simplest to reproduce would be for ICMP. I'm pretty sure I had a
> > stack trace with TCP as well, but I don't seem to be able to reproduce
> > that right now.
> >
> > > Do you have a stack trace to provide, because it is not clear from
> > > where the issue is detected.
>
> Thanks Vladimir
>
> I think that maybe the issue is that the initial skb->csum is zero,
> and the csum_parttial(removed_block) is also zero.
>
> But the initial skb->csum should not be zero if you have a non " all
> zero"  frame.
>
> Can you double check this in drivers/net/ethernet/freescale/enetc/enetc.c ?

To me it looks like the strange part is that the checksum of the removed
block (printed by me as "csum_partial(start, len, 0)" inside
skb_postpull_rcsum()) is the same as the skb->csum itself.

[   66.287583] fsl_enetc 0000:00:00.2 eno2: enetc_get_offloads 991: skb 0xffff4050c3671f00 csum 0x3c1d
[   66.296716] skb csum of 20 bytes (20 to the left of skb->data) using old method: 0x0, new method: 0xffffffff, orig csum 0x3c1d, csum of removed block 0x3c1d
[   66.310786] skb len=84 headroom=98 headlen=84 tailroom=1546
[   66.310786] mac=(84,-6) net=(78,0) trans=78
[   66.310786] shinfo(txflags=0 nr_frags=0 gso(size=0 type=0 segs=0))
[   66.310786] csum(0xffffffff ip_summed=2 complete_sw=0 valid=0 level=0)
[   66.310786] hash(0x0 sw=0 l4=0) proto=0x00f8 pkttype=3 iif=7
[   66.338997] dev name=eno2 feat=0x0x00020100001149a9
[   66.343904] skb headroom: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   66.351600] skb headroom: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   66.359295] skb headroom: 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   66.366990] skb headroom: 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   66.374685] skb headroom: 00000040: 88 80 00 0a 00 38 c1 17 3d 01 01 80 00 00 08 0f
[   66.382379] skb headroom: 00000050: 00 10 00 00 52 f3 98 af f9 8c d2 ee 27 92 2d 6c
[   66.390073] skb headroom: 00000060: 08 00
[   66.394105] skb linear:   00000000: 45 00 00 54 c8 59 40 00 40 01 28 fb c0 a8 64 01
[   66.401799] skb linear:   00000010: c0 a8 64 02 08 00 ee 94 06 98 00 04 03 2e a9 61
[   66.409493] skb linear:   00000020: 00 00 00 00 8b 6c 0c 00 00 00 00 00 10 11 12 13
[   66.417187] skb linear:   00000030: 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23
[   66.424880] skb linear:   00000040: 24 25 26 27 28 29 2a 2b 2c 2d 2e 2f 30 31 32 33
[   66.432574] skb linear:   00000050: 34 35 36 37
[   66.437128] skb tailroom: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   67.181735] fsl_enetc 0000:00:00.2 eno2: ocelot_rcv 131: skb 0xffff4050c3671f00 csum before skb_postpull_rcsum 0x3c1d, after 0xffffffff

This isn't the case for some other traffic streams, here is some iperf3 TCP:

[   52.336847] fsl_enetc 0000:00:00.2 eno2: enetc_get_offloads 991: skb 0xffff4050c44ab500 csum 0x18ce
[   52.345930] fsl_enetc 0000:00:00.2 eno2: enetc_get_offloads 991: skb 0xffff4050c3671f00 csum 0x18ce
[   52.355014] fsl_enetc 0000:00:00.2 eno2: enetc_get_offloads 991: skb 0xffff4050c3671e00 csum 0x18ce
[   52.397629] fsl_enetc 0000:00:00.2 eno2: ocelot_rcv 131: skb 0xffff4050c44ab500 csum before skb_postpull_rcsum 0x18ce, after 0xffffdcb0
[   52.409853] fsl_enetc 0000:00:00.2 eno2: ocelot_rcv 131: skb 0xffff4050c3671f00 csum before skb_postpull_rcsum 0x18ce, after 0xffffdcb0
[   52.422076] fsl_enetc 0000:00:00.2 eno2: ocelot_rcv 131: skb 0xffff4050c3671e00 csum before skb_postpull_rcsum 0x18ce, after 0xffffdcb0

When skb->csum isn't equal to the csum of the removed block, the two
implementations of skb_postpull_rcsum() agree.
