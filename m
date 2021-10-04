Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12AD420677
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 09:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbhJDHMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 03:12:40 -0400
Received: from mail-ua1-f43.google.com ([209.85.222.43]:34322 "EHLO
        mail-ua1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbhJDHMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 03:12:39 -0400
Received: by mail-ua1-f43.google.com with SMTP id h4so3434433uaw.1;
        Mon, 04 Oct 2021 00:10:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NehS4x9vrxotRJyJ41VYFHXFtSfSJ320xyu6pnwrcn8=;
        b=QHhbbLGbuU1ynXqfgpJAimMyqYYNfOU57MYZQMn50aBDHf26NElg2zYJgpQxF3f4K4
         0bD4YqzxsHD4/fo+L8rJUCqtLULnbbLf5Nh0EbOMwwJ+tQ91yhUUeMGaO3EDUOLseONY
         E+SSq2uVjwHG+Tduag9FU2fGfJun/98X24ahxAxvLNrqo+zRDxB/NcmFzlsuOeppnRZx
         qTEUMsIeLT3Or0W8qZG4S2IN+ZN7q2ESSUEesmhkx66dkqfVjuEBhNY3xgsJVuHCTOam
         26+w+TvPGAYFRGOFcXwmPic5HMqOeweGMUqzJAcePpcr6IhgzZBpqSn1fAhx3zmQoYNC
         yENg==
X-Gm-Message-State: AOAM530ctXSnNDz5yyOGZI3Ak76sM+XH2I76ZpmTcn4xV4uBWTFGRSVg
        Ba6LhLP5jQAv2r5ROgZAvAalsafasG1AN/nN+bM=
X-Google-Smtp-Source: ABdhPJzhA5Oq6J7Hv25tWrQGVqJC1Y3PIkFd1GKZ7cgsHPA6JZA3vL2jblUfB0/e/hrVAN2cWFOsFlWsvoLSUZH7c3Y=
X-Received: by 2002:ab0:16d4:: with SMTP id g20mr5398774uaf.114.1633331450525;
 Mon, 04 Oct 2021 00:10:50 -0700 (PDT)
MIME-Version: 1.0
References: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
 <20211001150636.7500-5-biju.das.jz@bp.renesas.com> <b4c87a6d-014f-0170-feb5-20079c7d5761@omp.ru>
 <OS0PR01MB59224497C081231E9CC334B986AD9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
In-Reply-To: <OS0PR01MB59224497C081231E9CC334B986AD9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 4 Oct 2021 09:10:39 +0200
Message-ID: <CAMuHMdXSeCA+27xiXAgwRUi4wFukXkrttTvnEGhZAtq7p_trCw@mail.gmail.com>
Subject: Re: [PATCH 04/10] ravb: Add support for RZ/G2L SoC
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Biju,

On Sun, Oct 3, 2021 at 8:51 AM Biju Das <biju.das.jz@bp.renesas.com> wrote:
> > Subject: Re: [PATCH 04/10] ravb: Add support for RZ/G2L SoC
> > On 10/1/21 6:06 PM, Biju Das wrote:
> > > RZ/G2L SoC has Gigabit Ethernet IP consisting of Ethernet controller
> > > (E-MAC), Internal TCP/IP Offload Engine (TOE) and Dedicated Direct
> > > memory access controller (DMAC).
> > >
> > > This patch adds compatible string for RZ/G2L and fills up the
> > > ravb_hw_info struct. Function stubs are added which will be used by
> > > gbeth_hw_info and will be filled incrementally.
> >
> >    I've always been against this patch -- we get a support for the GbEther
> > whihc doesn't work after this patch. I believe we should have the GbEther
> > support in the last patch. of the overall series.
>
> This is the common practice. We use bricks to build a wall. The function stubs are just
> Bricks.
>
> After filling stubs, we will add SoC dt and board DT, after that one will get GBsupport on
> RZ/G2L platform.

Not "after", but "in parallel".  The stubs will be filled in through
the netdev tree (1), while SoC DT and board DT will go through the
renesas-devel and soc trees (2).

So our main worry is: what happens if you have (2) but not (1)?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
