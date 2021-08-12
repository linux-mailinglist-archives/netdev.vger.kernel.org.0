Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312AE3EA363
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 13:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236751AbhHLLTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 07:19:52 -0400
Received: from linux.microsoft.com ([13.77.154.182]:49880 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232081AbhHLLTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 07:19:50 -0400
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by linux.microsoft.com (Postfix) with ESMTPSA id C111220C171A;
        Thu, 12 Aug 2021 04:19:24 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C111220C171A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1628767164;
        bh=aPwd3twlJLRiZUFCIngPiuLde0SAgrVThrDd2k35pnw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=NLcL5qWFCH2tMkNMMfxsZruq6hPtsol9tREYmHUUXNxI6AlKG+Lm/yO41KiJDCI9K
         +ZgAnCiLzaok4MlA4sSJC5iSDm89lH++Sw8CAUjmY9mIPpJgVkZJqWCNZi4qkb0Xu5
         Jw9cKFNDi2/gi/EnHxFZqJ8fUU/GNbW2MtHw8lWs=
Received: by mail-pj1-f44.google.com with SMTP id 28-20020a17090a031cb0290178dcd8a4d1so7728715pje.0;
        Thu, 12 Aug 2021 04:19:24 -0700 (PDT)
X-Gm-Message-State: AOAM531u38x+CqXX1Jl6w2MA2h4fTVuFIljdvlv1uZh33/8Paw9TxkPu
        eSIueRwlkcZKGO4n1/zkXsS9DFxAcC5nf9ceFOU=
X-Google-Smtp-Source: ABdhPJzWd8kEvYy9tH/IHBkyR9zciGHmNayh6FL82gI1Uy1JILOHNCqGP3dYdAvg3qXPv/SNhL/Tg+7r+zr8evrMONE=
X-Received: by 2002:a17:90a:ad85:: with SMTP id s5mr3758064pjq.187.1628767164221;
 Thu, 12 Aug 2021 04:19:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210614022504.24458-1-mcroce@linux.microsoft.com>
 <871r71azjw.wl-maz@kernel.org> <YROmOQ+4Kqukgd6z@orome.fritz.box>
 <202417ef-f8ae-895d-4d07-1f9f3d89b4a4@gmail.com> <87o8a49idp.wl-maz@kernel.org>
 <fe5f99c8-5655-7fbb-a64e-b5f067c3273c@gmail.com> <20210812121835.405d2e37@linux.microsoft.com>
 <874kbuapod.wl-maz@kernel.org>
In-Reply-To: <874kbuapod.wl-maz@kernel.org>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Thu, 12 Aug 2021 13:18:48 +0200
X-Gmail-Original-Message-ID: <CAFnufp2=1t2+fmxyGJ0Qu3Z+=wRwAX8faaPvrJdFpFeTS3J7Uw@mail.gmail.com>
Message-ID: <CAFnufp2=1t2+fmxyGJ0Qu3Z+=wRwAX8faaPvrJdFpFeTS3J7Uw@mail.gmail.com>
Subject: Re: [PATCH net-next] stmmac: align RX buffers
To:     Marc Zyngier <maz@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Drew Fustini <drew@beagleboard.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Jon Hunter <jonathanh@nvidia.com>,
        Will Deacon <will@kernel.org>
Content-Type: multipart/mixed; boundary="0000000000003f456b05c95ae845"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000003f456b05c95ae845
Content-Type: text/plain; charset="UTF-8"

On Thu, Aug 12, 2021 at 1:05 PM Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 12 Aug 2021 11:18:35 +0100,
> Matteo Croce <mcroce@linux.microsoft.com> wrote:
> >
> > On Thu, 12 Aug 2021 10:48:03 +0200
> > Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> > >
> > >
> > > On 8/11/21 4:16 PM, Marc Zyngier wrote:
> > > > On Wed, 11 Aug 2021 13:53:59 +0100,
> > > > Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > > >
> > > >> Are you sure you do not need to adjust stmmac_set_bfsize(),
> > > >> stmmac_rx_buf1_len() and stmmac_rx_buf2_len() ?
> > > >>
> > > >> Presumably DEFAULT_BUFSIZE also want to be increased by NET_SKB_PAD
> > > >>
> > > >> Patch for stmmac_rx_buf1_len() :
> > > >>
> > > >> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > > >> b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c index
> > > >> 7b8404a21544cf29668e8a14240c3971e6bce0c3..041a74e7efca3436bfe3e17f972dd156173957a9
> > > >> 100644 --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c +++
> > > >> b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c @@ -4508,12
> > > >> +4508,12 @@ static unsigned int stmmac_rx_buf1_len(struct
> > > >> stmmac_priv *priv, /* First descriptor, not last descriptor and
> > > >> not split header */ if (status & rx_not_ls)
> > > >> -               return priv->dma_buf_sz;
> > > >> +               return priv->dma_buf_sz - NET_SKB_PAD -
> > > >> NET_IP_ALIGN;
> > > >>         plen = stmmac_get_rx_frame_len(priv, p, coe);
> > > >>
> > > >>         /* First descriptor and last descriptor and not split
> > > >> header */
> > > >> -       return min_t(unsigned int, priv->dma_buf_sz, plen);
> > > >> +       return min_t(unsigned int, priv->dma_buf_sz - NET_SKB_PAD
> > > >> - NET_IP_ALIGN, plen); }
> > > >>
> > > >>  static unsigned int stmmac_rx_buf2_len(struct stmmac_priv *priv,
> > > >
> > > > Feels like a major deficiency of the original patch. Happy to test a
> > > > more complete patch if/when you have one.
> > >
> > > I wont have time in the immediate future.
> > >
> > > Matteo, if you do not work on a fix, I suggest we revert
> > >  a955318fe67ec0d962760b5ee58e74bffaf649b8 stmmac: align RX buffers
> > >
> > > before a more polished version can be submitted.
> > >
> >
> > Better to use stmmac_rx_offset() so to have the correct length when
> > using XDP. Also, when XDP is enabled, the offset was
> > XDP_PACKET_HEADROOM (i.e. 256 bytes) even before the change, so it
> > could be already broken. Mark, can you try on the Jetson TX2 by
> > attaching an XDP program and see if it works without my change?
>
> Sorry, you'll have to hold my hand here, as I know exactly nothing
> about XDP....
>

Attach the attached object with:

ip link set eth0 xdp object passall.o

This is an empty XDP program, its source:

__attribute__((section("prog"), used))
int xdp_main(struct xdp_md *ctx)
{
       return XDP_PASS;
}

Every packet will pass untouched, but the offset will be shifted from
0 to 256 bytes, which could trigger the problem anyway:

> > A possible fix, which takes in account also the XDP headroom for
> > stmmac_rx_buf1_len() only could be (only compile tested, I don't have
> > the hardware now):
>
> However, this doesn't fix my issue. I still get all sort of
> corruption. Probably stmmac_rx_buf2_len() also need adjusting (it has
> a similar logic as its buf1 counterpart...)
>
> Unless you can fix it very quickly, and given that we're towards the
> end of the cycle, I'd be more comfortable if we reverted this patch.
>

Can it be that the HW can't do DMA on an address which is not word aligned?
What if you replace NET_SKB_PAD with, let's say, 8?

Regards,
-- 
per aspera ad upstream

--0000000000003f456b05c95ae845
Content-Type: application/x-object; name="passall.o"
Content-Disposition: attachment; filename="passall.o"
Content-Transfer-Encoding: base64
Content-ID: <f_ks8tusn90>
X-Attachment-Id: f_ks8tusn90

f0VMRgIBAQAAAAAAAAAAAAEA9wABAAAAAAAAAAAAAAAAAAAAAAAAAGABAAAAAAAAAAAAAEAAAAAA
AEAACAABALcAAAACAAAAlQAAAAAAAABHUEwAAAAAABAAAAAAAAAAAXpSAAh8CwEMAAAAGAAAABgA
AAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAEAPH/AAAA
AAAAAAAAAAAAAAAAAAAAAAADAAMAAAAAAAAAAAAAAAAAAAAAABUAAAARAAQAAAAAAAAAAAAEAAAA
AAAAAAcAAAASAAMAAAAAAAAAAAAQAAAAAAAAABwAAAAAAAAAAQAAAAIAAAAALnRleHQAeGRwX21h
aW4AcHJvZwBfbGljZW5zZQAucmVsLmVoX2ZyYW1lAGtlcm5lbF9wYXNzYWxsLmMALnN0cnRhYgAu
c3ltdGFiAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAA9AAAAAwAAAAAAAAAAAAAAAAAAAAAAAAAQAQAAAAAAAE0AAAAAAAAA
AAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAQAAAAEAAAAGAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAABAAAAABAAAABgAAAAAAAAAAAAAAAAAAAEAA
AAAAAAAAEAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAAAAAAAAAWAAAAAQAAAAMAAAAAAAAAAAAA
AAAAAABQAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAIgAAAAEAAAACAAAA
AAAAAAAAAAAAAAAAWAAAAAAAAAAwAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAAAAAAAAAB4AAAAJ
AAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAEAAAAAAAAAAHAAAABQAAAAgAAAAAAAAAEAAAAAAA
AABFAAAAAgAAAAAAAAAAAAAAAAAAAAAAAACIAAAAAAAAAHgAAAAAAAAAAQAAAAMAAAAIAAAAAAAA
ABgAAAAAAAAA
--0000000000003f456b05c95ae845--
