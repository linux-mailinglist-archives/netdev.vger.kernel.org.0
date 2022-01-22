Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01000496977
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 03:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbiAVCsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 21:48:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbiAVCsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 21:48:03 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C189C06173B;
        Fri, 21 Jan 2022 18:48:03 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 187so9464612pga.10;
        Fri, 21 Jan 2022 18:48:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8k//EGYARWFYfi+4UhyOPO5EkW3yRaXLzIGT1w5hcYk=;
        b=Jj+5PlZH651DEorUwIwXbjmmO8ahaqnhHuSbds4b1fh8sT0q/FQTrLvLcyisZXnD3k
         QXpsRfK7g5vFxHjEquuIbP+pjuVKuYD/rcThbCZfJ55xf6o6HYpF2cZo23n5SEo4imS3
         x5Dxpm/BtsZFfuGePMcfSi2ooSHtW/Y+NXcFi0CCstzB8zvwJhZBQjNcib66NPkrCEjz
         xfOf7v6llVfRj51ISdacBs68t9/pA8ggNjHfY6/Bj4n17iyLRuRfY/rtYVKbxbzB4dh3
         3lxt3diOSc3RfRz1pPSPM6aH0hjQd+zg2ezgSCtmXheDPuqbB9Zip3J8ip9JZ7OxycyV
         sk3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8k//EGYARWFYfi+4UhyOPO5EkW3yRaXLzIGT1w5hcYk=;
        b=XsKWwqbDcFZoAKt/1y0DOckh5xFLdiiJgib+NupY5crbChH5oC/mNGGbO+4J/Z9wUc
         NYf8Y2yqdJab5EBp+cRrGe4/vaGmbU+LSS+Lmw6D4hAF9MK1HNXT0WxipvkMxAmOi37j
         2NZzC6yrAKipBUfRBCzqqd1MJfMDYyEkH9J1GxEAkXlCjlW/BFJq4m5wtVOgsVCIfTqa
         a51ofvkmzgOUrV1OOghWqIXnXrcNmbS/t0MgijPRBHVsyzGnmUt+sICHhstz66G8xFWL
         k3o/LmmOsupu00WqbWmvWfitsw09rIs8g6iDiOU3JPxRYFNK+7IHK7zFp11jHIAW5aY1
         nMJQ==
X-Gm-Message-State: AOAM533R43/A5npMT8WN+w898cQ0TFPC/bRt4ds29T7m2jlYBpFQbGlw
        qxAvEZ7r6WYPAZ8VrunYw3/a/xfBliV+TTxMNYs=
X-Google-Smtp-Source: ABdhPJwut3siHc6zIJuQUKzsAI8eo3tKxOv1gdPuWsE4npYABDwLgSQ7bnUgURBzNrPzPevwl93v1bVOA283bAf6oBQ=
X-Received: by 2002:a63:be49:: with SMTP id g9mr4782142pgo.375.1642819682689;
 Fri, 21 Jan 2022 18:48:02 -0800 (PST)
MIME-Version: 1.0
References: <20220122005644.802352-1-colin.foster@in-advantage.com>
 <20220122005644.802352-2-colin.foster@in-advantage.com> <CAADnVQK8xrQ92+=wm8AoDkC93SEKz3G=CoOnkPgvs=spJk5UZA@mail.gmail.com>
 <20220122022047.GA803138@euler>
In-Reply-To: <20220122022047.GA803138@euler>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 21 Jan 2022 18:47:51 -0800
Message-ID: <CAADnVQ+UqKMfn+ZxgOkBcXidBWUGJDugU7gCEV+rGS6wscZjJw@mail.gmail.com>
Subject: Re: [net RFC v1 1/1] page_pool: fix NULL dereference crash
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 6:20 PM Colin Foster
<colin.foster@in-advantage.com> wrote:
>
> On Fri, Jan 21, 2022 at 05:13:28PM -0800, Alexei Starovoitov wrote:
> > On Fri, Jan 21, 2022 at 4:57 PM Colin Foster
> > <colin.foster@in-advantage.com> wrote:
> > >
> > > Check for the existence of page pool params before dereferencing. This can
> > > cause crashes in certain conditions.
> >
> > In what conditions?
> > Out of tree driver?
>
> Hi Alexei,
>
> Thanks for the quick response.
>
> I'm actively working on a DSA driver that is currently out-of-tree, but
> trying to get it into mainline. But I'm not convinced that's the
> problem...
>
> I'm using a beagelebone black with the cpsw_new driver. There are two
> tweaks to that driver: the default vlan port is 10 and 11 so there's no
> conflict between cpsw_new and DSA, and the ndev->max_mtu / rx_packet_max
> have been increased to 1600 to allow for DSA frames larger than the
> standard MTU of 1500.
>
> My focus is on the DSA driver, but the crash happens as soon as I run
> "ip link set eth0 up" which is invoking the cpsw_new driver. Therefore I
> suspect that the issue is not directly related to the DSA section
> (ocelot / felix, much of which uses code that is mainline)
>
> As I suggested, I haven't dug into what is going on around the
> page_pool yet. If there is something that is pre-loading memory at 1500
> byte intervals and I broke that, that's entirely on me.
>
> [ removes 1600 byte MTU patch and pool patch ]
>
> I can confirm it still crashes when I don't modify the MTU in the
> cpsw_new driver... so that doesn't seem to be it. That crash log is
> below.
>
>
> # ip link set eth0 up
> [   18.074704] cpsw-switch 4a100000.switch: starting ndev. mode: dual_mac
> [   18.174286] SMSC LAN8710/LAN8720 4a101000.mdio:00: attached PHY driver (mii_bus:phy_addr=4a101000.mdio:00, irq=POLL)
> [   18.185458] 8<--- cut here ---
> [   18.188554] Unable to handle kernel paging request at virtual address c3104440
> [   18.195819] [c3104440] *pgd=8300041e(bad)
> [   18.199885] Internal error: Oops: 8000000d [#1] SMP ARM
> [   18.205148] Modules linked in:
> [   18.208233] CPU: 0 PID: 168 Comm: ip Not tainted 5.16.0-05302-g8bd405e6e8a0-dirty #265
> [   18.216201] Hardware name: Generic AM33XX (Flattened Device Tree)
> [   18.222328] PC is at 0xc3104440
> [   18.225500] LR is at __page_pool_alloc_pages_slow+0xbc/0x2e0
> [   18.231222] pc : [<c3104440>]    lr : [<c0ee06c8>]    psr: a00b0013
> [   18.237523] sp : c3104440  ip : 00000020  fp : c219e580
> [   18.242778] r10: c1a04d54  r9 : 00000000  r8 : 00000000
> [   18.248032] r7 : c36b9000  r6 : 00000000  r5 : c36b9084  r4 : 00000000
> [   18.254595] r3 : c07a399c  r2 : 00000000  r1 : c325784c  r0 : dfa48bc0
> [   18.261162] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
> [   18.268343] Control: 10c5387d  Table: 836f0019  DAC: 00000051
> [   18.274119] Register r0 information: non-slab/vmalloc memory
> [   18.279825] Register r1 information: non-slab/vmalloc memory
> [   18.285523] Register r2 information: NULL pointer
> [   18.290260] Register r3 information: non-slab/vmalloc memory
> [   18.295957] Register r4 information: NULL pointer
> [   18.300693] Register r5 information: slab kmalloc-1k start c36b9000 pointer offset 132 size 1024
> [   18.309569] Register r6 information: NULL pointer
> [   18.314306] Register r7 information: slab kmalloc-1k start c36b9000 pointer offset 0 size 1024
> [   18.322999] Register r8 information: NULL pointer
> [   18.327736] Register r9 information: NULL pointer
> [   18.332473] Register r10 information: non-slab/vmalloc memory
> [   18.338257] Register r11 information: slab kmalloc-4k start c219e000 pointer offset 1408 size 4096
> [   18.347301] Register r12 information: non-paged memory
> [   18.352475] Process ip (pid: 168, stack limit = 0x7eb0d4ab)
> [   18.358089] Stack: (0xc3104440 to 0xc3258000)
> (too big a stack to show)
>
>
> I can confirm that it crashes on net-next/master as well:
> commit fe8152b38d3a, using the same DTB that defines the cpsw_new port
> as the DSA master. Relevant DTS snippet from my in-development driver:
>
> +&spi0 {
> +       #address-cells = <1>;
> +       #size-cells = <0>;
> +       status = "okay";
> +
> +       ocelot-chip@0 {
> +               compatible = "mscc,vsc7512_mfd_spi";
> +               spi-max-frequency = <2500000>;
> +               reg = <0>;
> +
> +               ethernet-switch@0 {
> +                       compatible = "mscc,vsc7512-ext-switch";
> +                       ports {
> +                               #address-cells = <1>;
> +                               #size-cells = <0>;
> +
> +                               port@0 {
> +                                       reg = <0>;
> +                                       label = "cpu";
> +                                       status = "okay";
> +                                       ethernet = <&mac_sw>;
> +                                       phy-handle = <&sw_phy0>;
> +                                       phy-mode = "internal";
> +                               };
>
>
> I was hoping for an "oh, if a switch is set up in DSA the page_pool gets
> set up this way" type scenario. I fully understand that might not be the
> case, and the issue could be in something I'm doing incorrectly - it
> certainly wouldn't be the first time.
>
> If this patch doesn't make sense I can look deeper. As mentioned, I'm
> working to get this accepted upstream, so I'll have to figure it out one
> way or another.

With !pool tweak the patch makes sense.

Toke, wdyt?
