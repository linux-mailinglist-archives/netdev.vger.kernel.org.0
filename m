Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78DBB267614
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 00:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725926AbgIKWns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 18:43:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:42200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbgIKWnp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 18:43:45 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0447221EB;
        Fri, 11 Sep 2020 22:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599864225;
        bh=L5srl0C0YPGfWSG/wmRxyc+BV9d41Nv1l/TtgodMBVY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cVjaEyu+E6WE9X0IpyBHV5eCts1FEDVFkDHxJ0oZ2EF9V80a0AEIcP28pkZsQobl0
         15J4luAx3lo34/tNNNue/keSrYH264Jy+c+m44z+GhYOhO/IFubqvuZmECxbUNkLTX
         OGTuUeYQ7UtI0mFm4SmVzNLHZw5XGENW26SO0QBM=
Date:   Fri, 11 Sep 2020 15:43:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, mkubecek@suse.cz,
        tariqt@nvidia.com, saeedm@nvidia.com,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next 5/8] bnxt: add pause frame stats
Message-ID: <20200911154343.2a319485@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CACKFLin6F=Y0jrJZqA75Oa+QwCyAyHK06_QnuB54-WwOqpG8MA@mail.gmail.com>
References: <20200911195258.1048468-1-kuba@kernel.org>
        <20200911195258.1048468-6-kuba@kernel.org>
        <CACKFLin6F=Y0jrJZqA75Oa+QwCyAyHK06_QnuB54-WwOqpG8MA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Sep 2020 15:34:24 -0700 Michael Chan wrote:
> On Fri, Sep 11, 2020 at 12:53 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > These stats are already reported in ethtool -S.
> > Hopefully they are equivalent to standard stats?  
> 
> Yes.
> 
> >
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> >  .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 19 +++++++++++++++++++
> >  1 file changed, 19 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> > index d0928334bdc8..b5de242766e3 100644
> > --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> > +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> > @@ -1778,6 +1778,24 @@ static void bnxt_get_pauseparam(struct net_device *dev,
> >         epause->tx_pause = !!(link_info->req_flow_ctrl & BNXT_LINK_PAUSE_TX);
> >  }
> >
> > +static void bnxt_get_pause_stats(struct net_device *dev,
> > +                                struct ethtool_pause_stats *epstat)
> > +{
> > +       struct bnxt *bp = netdev_priv(dev);
> > +       struct rx_port_stats *rx_stats;
> > +       struct tx_port_stats *tx_stats;
> > +
> > +       if (BNXT_VF(bp) || !(bp->flags & BNXT_FLAG_PORT_STATS))
> > +               return;
> > +
> > +       rx_stats = (void *)bp->port_stats.sw_stats;
> > +       tx_stats = (void *)((unsigned long)bp->port_stats.sw_stats +
> > +                           BNXT_TX_PORT_STATS_BYTE_OFFSET);
> > +
> > +       epstat->rx_pause_frames = rx_stats->rx_pause_frames;
> > +       epstat->tx_pause_frames = tx_stats->tx_pause_frames;  
> 
> This will work, but the types on the 2 sides don't match.  On the
> right hand side, since you are casting to the hardware struct
> rx_port_stats and tx_port_stats, the types are __le64.
> 
> If rx_stats and tx_stats are *u64 and you use these macros:
> 
> BNXT_GET_RX_PORT_STATS64(rx_stats, rx_pause_frames)
> BNXT_GET_TX_PORT_STATS64(tx_stats, tx_pause_frames)
> 
> the results will be the same with native CPU u64 types.

Thanks! My build bot just poked me about this as well.

I don't see any byte swaps in bnxt_get_ethtool_stats() - 
are they not needed there? I'm slightly confused.
