Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 607EB3F3217
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 19:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233544AbhHTRPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 13:15:46 -0400
Received: from linux.microsoft.com ([13.77.154.182]:36296 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232460AbhHTRPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 13:15:45 -0400
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
        by linux.microsoft.com (Postfix) with ESMTPSA id 391F220C33D2;
        Fri, 20 Aug 2021 10:15:07 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 391F220C33D2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1629479707;
        bh=ItGD9aVsu1rDLYchQmQY7HIG/PkWjPml35jwFsC9TjI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=gLAHZ12gG7OD4P02DER4dsuQ6ShHdj712p31JBnPXUDpJdmwyynsClaErW+hBX1ml
         W8xB9R3dxodSWVI7BhIbnEu8/AaD9v4O2S/JM8jZs9oLBIgq55jNpxbBMre1Faj7nB
         nR8qHRl8RwaMO6/hCcslllOeASDcfkjqqR/OAZag=
Received: by mail-pf1-f178.google.com with SMTP id y190so9175009pfg.7;
        Fri, 20 Aug 2021 10:15:07 -0700 (PDT)
X-Gm-Message-State: AOAM533nswyjIAwVU+3sbD4su2fdqA3wE/wdjbn2Ko4LyXd80Tf/JPKU
        tOw+ycVh32apg2OOwy1xhx9DctsfHXcfc+B4f/k=
X-Google-Smtp-Source: ABdhPJy81Spd4IWqIdXplwtEO4cEl/1X6pGRiInPjnyh9JmPsUTcYQn46QcyBbJ/jukyvIyhIdxZFqpGz5VjHa5QZ9s=
X-Received: by 2002:a63:d456:: with SMTP id i22mr19661572pgj.421.1629479706747;
 Fri, 20 Aug 2021 10:15:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210614022504.24458-1-mcroce@linux.microsoft.com>
 <871r71azjw.wl-maz@kernel.org> <YROmOQ+4Kqukgd6z@orome.fritz.box>
 <202417ef-f8ae-895d-4d07-1f9f3d89b4a4@gmail.com> <87o8a49idp.wl-maz@kernel.org>
 <fe5f99c8-5655-7fbb-a64e-b5f067c3273c@gmail.com> <20210812121835.405d2e37@linux.microsoft.com>
 <874kbuapod.wl-maz@kernel.org> <CAFnufp2=1t2+fmxyGJ0Qu3Z+=wRwAX8faaPvrJdFpFeTS3J7Uw@mail.gmail.com>
 <87wnohqty1.wl-maz@kernel.org> <CAFnufp3xjYqe_iVfbmdjz4-xN2UX_oo3GUw4Z4M_q-R38EN+uQ@mail.gmail.com>
 <87fsv4qdzm.wl-maz@kernel.org> <CAFnufp2T75cvDLUx+ZyPQbkaNeY_S1OJ7KTJe=2EK-qXRNkwyw@mail.gmail.com>
 <87mtpcyrdv.wl-maz@kernel.org>
In-Reply-To: <87mtpcyrdv.wl-maz@kernel.org>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Fri, 20 Aug 2021 19:14:30 +0200
X-Gmail-Original-Message-ID: <CAFnufp0N2MzaTjF95tx9Q1D33z9f9AAK6UHbhU9rhG1ue_r1ug@mail.gmail.com>
Message-ID: <CAFnufp0N2MzaTjF95tx9Q1D33z9f9AAK6UHbhU9rhG1ue_r1ug@mail.gmail.com>
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 20, 2021 at 7:09 PM Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 20 Aug 2021 17:38:14 +0100,
> Matteo Croce <mcroce@linux.microsoft.com> wrote:
> >
> > On Fri, Aug 20, 2021 at 6:26 PM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > On Fri, 20 Aug 2021 11:37:03 +0100,
> > > Matteo Croce <mcroce@linux.microsoft.com> wrote:
> > > >
> > > > On Thu, Aug 19, 2021 at 6:29 PM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > [...]
> > >
> > > > > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> > > > > index fcdb1d20389b..244aa6579ef4 100644
> > > > > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> > > > > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> > > > > @@ -341,7 +341,7 @@ static inline unsigned int stmmac_rx_offset(struct stmmac_priv *priv)
> > > > >         if (stmmac_xdp_is_enabled(priv))
> > > > >                 return XDP_PACKET_HEADROOM + NET_IP_ALIGN;
> > > > >
> > > > > -       return NET_SKB_PAD + NET_IP_ALIGN;
> > > > > +       return 8 + NET_IP_ALIGN;
> > > > >  }
> > > > >
> > > > >  void stmmac_disable_rx_queue(struct stmmac_priv *priv, u32 queue);
> > > > >
> > > > > I don't see the system corrupting packets anymore. Is that exactly
> > > > > what you had in mind? This really seems to point to a basic buffer
> > > > > overflow.
> > >
> > > [...]
> > >
> > > > Sorry, I meant something like:
> > > >
> > > > -       return NET_SKB_PAD + NET_IP_ALIGN;
> > > > +       return 8;
> > > >
> > > > I had some hardware which DMA fails if the receive buffer was not word
> > > > aligned, but this seems not the case, as 8 + NET_IP_ALIGN = 10, and
> > > > it's not aligned too.
> > >
> > > No error in that case either, as expected. Given that NET_SKB_PAD is
> > > likely to expand to 64, it is likely a DMA buffer overflow which
> > > probably only triggers for large-ish packets.
> > >
> > > Now, we're almost at -rc7, and we don't have a solution in sight.
> > >
> > > Can we please revert this until we have an understanding of what is
> > > happening? I'll hopefully have more cycles to work on the issue once
> > > 5.14 is out, and hopefully the maintainers of this driver can chime in
> > > (they have been pretty quiet so far).
> > >
> > > Thanks,
> > >
> > >         M.
> > >
> > > --
> > > Without deviation from the norm, progress is not possible.
> >
> > Last try, what about adding only NET_IP_ALIGN and leaving NET_SKB_PAD?
> >
> > -       return NET_SKB_PAD + NET_IP_ALIGN;
> > +       return NET_IP_ALIGN;
> >
> > I think that alloc_skb adds another NET_SKB_PAD anyway.
>
> I don't see any packet corruption with this. However, this doesn't
> prove that this is correct either. What was the rational for adding
> NET_SKB_PAD the first place?
>

I think it's wrong. The original offset was 0, and to align it to the
boundary we need to add just NET_IP_ALIGN, which is two.
NET_SKB_PAD is a much bigger value, (I think 64), which is used to
reserve space to prepend an header, e.g. with tunnels.

-- 
per aspera ad upstream
