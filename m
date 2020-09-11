Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFF726761F
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 00:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgIKWqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 18:46:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:45454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbgIKWqb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 18:46:31 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0396A221EB;
        Fri, 11 Sep 2020 22:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599864391;
        bh=JyhM/XBD8Xbv38CbeTDG3AOSRIBF+S7P5HxHOn74gm4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l/5ukrKiAvlSpujmiLhN4ON9zo2SrfLrWa2Qh1idUYciR/YXjZDC/WYVVCCL53nPs
         vnMVrYLxgidAUG/yle61+ajdaC2YNo4CHS4atA9hW8JjcV8Zhs1soCNIeaokhZjfbD
         omI+cJ3Mk8gi1ftTeMPrFWMOGB6Ux+NhIBwmvGxQ=
Date:   Fri, 11 Sep 2020 15:46:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, mkubecek@suse.cz,
        tariqt@nvidia.com, saeedm@nvidia.com,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next 5/8] bnxt: add pause frame stats
Message-ID: <20200911154629.0e2077c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200911154343.2a319485@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200911195258.1048468-1-kuba@kernel.org>
        <20200911195258.1048468-6-kuba@kernel.org>
        <CACKFLin6F=Y0jrJZqA75Oa+QwCyAyHK06_QnuB54-WwOqpG8MA@mail.gmail.com>
        <20200911154343.2a319485@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Sep 2020 15:43:43 -0700 Jakub Kicinski wrote:
> > > +       struct bnxt *bp = netdev_priv(dev);
> > > +       struct rx_port_stats *rx_stats;
> > > +       struct tx_port_stats *tx_stats;
> > > +
> > > +       if (BNXT_VF(bp) || !(bp->flags & BNXT_FLAG_PORT_STATS))
> > > +               return;
> > > +
> > > +       rx_stats = (void *)bp->port_stats.sw_stats;
> > > +       tx_stats = (void *)((unsigned long)bp->port_stats.sw_stats +
> > > +                           BNXT_TX_PORT_STATS_BYTE_OFFSET);
> > > +
> > > +       epstat->rx_pause_frames = rx_stats->rx_pause_frames;
> > > +       epstat->tx_pause_frames = tx_stats->tx_pause_frames;    
> > 
> > This will work, but the types on the 2 sides don't match.  On the
> > right hand side, since you are casting to the hardware struct
> > rx_port_stats and tx_port_stats, the types are __le64.
> > 
> > If rx_stats and tx_stats are *u64 and you use these macros:
> > 
> > BNXT_GET_RX_PORT_STATS64(rx_stats, rx_pause_frames)
> > BNXT_GET_TX_PORT_STATS64(tx_stats, tx_pause_frames)
> > 
> > the results will be the same with native CPU u64 types.  
> 
> Thanks! My build bot just poked me about this as well.
> 
> I don't see any byte swaps in bnxt_get_ethtool_stats() - 
> are they not needed there? I'm slightly confused.

Oof those macros don't byte swap either, even more confused now :)
