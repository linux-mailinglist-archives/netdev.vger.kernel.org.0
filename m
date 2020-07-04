Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B625421425F
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 02:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgGDAcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 20:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726455AbgGDAcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 20:32:11 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F53CC061794
        for <netdev@vger.kernel.org>; Fri,  3 Jul 2020 17:32:11 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id q198so30209040qka.2
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 17:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IV6J4twbSiX1md/8mS1KjdLC0/whBPRgo74LkpDDBF0=;
        b=FC62Lxb9Al7W3vLklcBK1V2nfEkz3bPRleC0SZa593XWeudClQMPwLfyUQvhO+biNw
         d6KVYdwNY/BIG3WqcHDz6MCNeU1g9VIdUUswMPJeWv37Rtvf7q/Ey4RZL+hP0hPKbUF6
         x/FmXcs4xWHs9+Zka5wcE6vJ8okxQw19sWjjw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IV6J4twbSiX1md/8mS1KjdLC0/whBPRgo74LkpDDBF0=;
        b=s+leh1LsYJCecnO1DZtmublnaAI4KUK0p72q8dUYgljDdYBZNRAHbsDdtBnELTRuE+
         /6pGgJUlgdXgWv66GNE/L/5tcmIELcjXkIEZnB7Kn7XiGjRX/WzCRZbWLs3Eq03FqDUp
         JxisDaWJaFaO6HQ2MGM8Mjc5G6AltFF+/56no8GF193u2FH8Cgn1j7/OEt8GeGYG8TNe
         n2bClXbNlHUKnyv2th/57/a8iKpCLvllK/JDaKUFGsOPMh01gUABnCBryubcExH2YeNc
         hiAtBQ4mXvHCAvFuXElX6WDDc1y6nLQvnwlr1aJzvaDQjw3cJs9712RrY5C16LnJOCC7
         lTgA==
X-Gm-Message-State: AOAM531DcGkO8BgVEczY8k9CYsIJKVYLbv2vy0pKCl74JGLuREJdGbfe
        aGaC72BtzsDbwd/7uf3gLQts12gmY1ak8oE9CVewNRmc
X-Google-Smtp-Source: ABdhPJwMJKogpfxWtJu22NLU7zW/lDTmg7d2tm0/LhCyqvaeNySPMNMMJhCjvY0NVWit59NrGpPzqKBr/3AqSVoXuCg=
X-Received: by 2002:a37:4050:: with SMTP id n77mr36975852qka.431.1593822730152;
 Fri, 03 Jul 2020 17:32:10 -0700 (PDT)
MIME-Version: 1.0
References: <1593760787-31695-1-git-send-email-michael.chan@broadcom.com>
 <1593760787-31695-7-git-send-email-michael.chan@broadcom.com> <20200703163726.63321b67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200703163726.63321b67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Fri, 3 Jul 2020 17:31:59 -0700
Message-ID: <CACKFLikqj3pV6NCKiYqZaO4m3H7a301WmuyZO0VHzL+ifC4GhA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 6/8] bnxt_en: Implement ethtool -X to set
 indirection table.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 3, 2020 at 4:37 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri,  3 Jul 2020 03:19:45 -0400 Michael Chan wrote:
> > diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> > index 6c90a94..0edb692 100644
> > --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> > +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> > @@ -6061,6 +6061,10 @@ static int __bnxt_reserve_rings(struct bnxt *bp)
> >               rx = rx_rings << 1;
> >       cp = sh ? max_t(int, tx, rx_rings) : tx + rx_rings;
> >       bp->tx_nr_rings = tx;
> > +
> > +     /* Reset the RSS indirection if we cannot reserve all the RX rings */
> > +     if (rx_rings != bp->rx_nr_rings)
> > +             bp->dev->priv_flags &= ~IFF_RXFH_CONFIGURED;
>
> Ethtool core will check that if user set RSS table explicitly and now
> changes ring count - the RSS table will not point to rings which will
> no longer exist. IOW if RSS table is set we're likely increasing the
> number of rings, and I'd venture to guess that the FW is not gonna give
> us less rings than we previously had. So it seems like we may be
> clearing the flag, and the RSS table unnecessarily here.

Right, the user most likely wants to increase the rings with RSS map
already set.  The user can decrease rings too if the higher rings
don't have any weight.  We call bnxt_check_rings() to see if firmware
has the requested rings before we proceed.  Once we proceed, we're
committed and if firmware cannot give us the rings it promised
earlier, the RSS map may no longer be valid if the rings are even
fewer than what we had before.  This is rare, as I said earlier, but
it can happen, especially on the VFs.  The resources are less
guaranteed on the VFs.

>
> What I was suggesting, was that it perhaps be better to modulo the
> number or rings in __bnxt_fill_hw_rss_tbl* by the actual table size,
> but leave the user-set RSS table in place. That'd be the lowest LoC.
>
> Also I still think that there should be a warning printed when FW gave
> us less rings than expected.

Sure, we can add some warnings if we don't warn already.

>
> >       bp->rx_nr_rings = rx_rings;
> >       bp->cp_nr_rings = cp;
> >
> > @@ -8265,7 +8269,8 @@ int bnxt_reserve_rings(struct bnxt *bp, bool irq_re_init)
> >                       rc = bnxt_init_int_mode(bp);
> >               bnxt_ulp_irq_restart(bp, rc);
> >       }
> > -     bnxt_set_dflt_rss_indir_tbl(bp);
> > +     if (!netif_is_rxfh_configured(bp->dev))
> > +             bnxt_set_dflt_rss_indir_tbl(bp);
> >
> >       if (rc) {
> >               netdev_err(bp->dev, "ring reservation/IRQ init failure rc: %d\n", rc);
> > diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> > index 46f3978..9098818 100644
> > --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> > +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> > @@ -926,6 +926,13 @@ static int bnxt_set_channels(struct net_device *dev,
> >               return rc;
> >       }
> >
> > +     if (bnxt_get_nr_rss_ctxs(bp, req_rx_rings) !=
> > +         bnxt_get_nr_rss_ctxs(bp, bp->rx_nr_rings) &&
> > +         (dev->priv_flags & IFF_RXFH_CONFIGURED)) {
>
> In this case copy the old values over and zero-fill the new rings.

If the existing RSS table has 128 entries and a custom map.  And now
the table needs to expand to 192 entries with 64 new entries, we
cannot just copy, right?  The weights will all be messed up if we try.
I think requiring the user to change back to default or force it back
to default are the only sane options.

>
> > +             netdev_warn(dev, "RSS table size change required, RSS table entries must be default to proceed\n");
> > +             return -EINVAL;
> > +     }
> > +
> >       if (netif_running(dev)) {
> >               if (BNXT_PF(bp)) {
> >                       /* TODO CHIMP_FW: Send message to all VF's
> > @@ -1315,6 +1322,35 @@ static int bnxt_get_rxfh(struct net_device *dev, u32 *indir, u8 *key,
> >       return 0;
> >  }
> >
> > +static int bnxt_set_rxfh(struct net_device *dev, const u32 *indir,
> > +                      const u8 *key, const u8 hfunc)
> > +{
> > +     struct bnxt *bp = netdev_priv(dev);
> > +     int rc = 0;
> > +
> > +     if (hfunc && hfunc != ETH_RSS_HASH_TOP)
> > +             return -EOPNOTSUPP;
> > +
> > +     if (key)
> > +             return -EOPNOTSUPP;
> > +
> > +     if (indir) {
> > +             u32 i, pad, tbl_size = bnxt_get_rxfh_indir_size(dev);
> > +
> > +             for (i = 0; i < tbl_size; i++)
> > +                     bp->rss_indir_tbl[i] = indir[i];
> > +             pad = bp->rss_indir_tbl_entries - tbl_size;
> > +             if (pad)
> > +                     memset(&bp->rss_indir_tbl[i], 0, pad * sizeof(u16));
> > +     }
>
> I see in patch 4 there is a:
>
>         bool no_rss = !(vnic->flags & BNXT_VNIC_RSS_FLAG);
>
> Should there be some check here to only allow users to change the
> indirection table if RSS is supported / allowed?

RSS is always supported on the function.  The first VNIC hw structure
that we allocate always supports RSS.  We allocate additional VNICs
for aRFS and those VNICs do not use RSS and the BNXT_VNIC_RSS_FLAG
will not be set on those VNICs.  That's what the code in patch 4 is
doing.  The bp->rss_indir_tbl always applies to the first VNIC that
supports RSS.
