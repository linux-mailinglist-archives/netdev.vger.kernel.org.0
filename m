Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA5F214E01
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 18:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgGEQkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 12:40:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726538AbgGEQkO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 12:40:14 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3864720737;
        Sun,  5 Jul 2020 16:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593967214;
        bh=21PGPZ/zqFrCAJxy1r0Lq7k9+YXIEdcbrWxkFpQjI5c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rXnhvXdO00MsCvocrbzOObiAyGvfaIVZqwwcsfu/X/FR9Y4WMZXtryUqW7cUSkMVa
         J9d9g0Lra7/xjYqyBMnc0gQGq+2ReLeGA+CFTYWmqk/QojfUXERcHklpImm7JE2QSQ
         ONhjtLwDnDd02DD+VGyQwXOe7eRSApHWpW2oTbT0=
Date:   Sun, 5 Jul 2020 09:40:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 6/8] bnxt_en: Implement ethtool -X to set
 indirection table.
Message-ID: <20200705094012.7f4fcd89@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CACKFLikqj3pV6NCKiYqZaO4m3H7a301WmuyZO0VHzL+ifC4GhA@mail.gmail.com>
References: <1593760787-31695-1-git-send-email-michael.chan@broadcom.com>
        <1593760787-31695-7-git-send-email-michael.chan@broadcom.com>
        <20200703163726.63321b67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CACKFLikqj3pV6NCKiYqZaO4m3H7a301WmuyZO0VHzL+ifC4GhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Jul 2020 17:31:59 -0700 Michael Chan wrote:
> > >       bp->rx_nr_rings = rx_rings;
> > >       bp->cp_nr_rings = cp;
> > >
> > > @@ -8265,7 +8269,8 @@ int bnxt_reserve_rings(struct bnxt *bp, bool irq_re_init)
> > >                       rc = bnxt_init_int_mode(bp);
> > >               bnxt_ulp_irq_restart(bp, rc);
> > >       }
> > > -     bnxt_set_dflt_rss_indir_tbl(bp);
> > > +     if (!netif_is_rxfh_configured(bp->dev))
> > > +             bnxt_set_dflt_rss_indir_tbl(bp);
> > >
> > >       if (rc) {
> > >               netdev_err(bp->dev, "ring reservation/IRQ init failure rc: %d\n", rc);
> > > diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> > > index 46f3978..9098818 100644
> > > --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> > > +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> > > @@ -926,6 +926,13 @@ static int bnxt_set_channels(struct net_device *dev,
> > >               return rc;
> > >       }
> > >
> > > +     if (bnxt_get_nr_rss_ctxs(bp, req_rx_rings) !=
> > > +         bnxt_get_nr_rss_ctxs(bp, bp->rx_nr_rings) &&
> > > +         (dev->priv_flags & IFF_RXFH_CONFIGURED)) {  
> >
> > In this case copy the old values over and zero-fill the new rings.  
> 
> If the existing RSS table has 128 entries and a custom map.  And now
> the table needs to expand to 192 entries with 64 new entries, we
> cannot just copy, right?  The weights will all be messed up if we try.
> I think requiring the user to change back to default or force it back
> to default are the only sane options.

I see it now, you're right.
