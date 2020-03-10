Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEE871804F1
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 18:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgCJRhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 13:37:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:39230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726271AbgCJRhM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 13:37:12 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C80E220675;
        Tue, 10 Mar 2020 17:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583861831;
        bh=nYxPFieWECwJ0GDxRqckJ9mb5rNtNlC2Fy6ITJyu4nc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WdJ52dDw7CYsLP3lNJ+kS379oeQZL1LQ/J7abDb5BBRwxp475QuWft53NcYetrBuu
         l/TCpqZE5Lr1NUE5oDyzo+ADl1RZMfWMZOYDPzUeV2/+duC8BVO6cba5xNNcdKeWxW
         g2XI9d61CtAammXOof+aJ9lrzYIZpPRTo0sOSryM=
Date:   Tue, 10 Mar 2020 10:37:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, akiyano@amazon.com,
        netanel@amazon.com, gtzalik@amazon.com, irusskikh@marvell.com,
        f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        rmody@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        aelior@marvell.com, skalluru@marvell.com,
        GR-everest-linux-l2@marvell.com, opendmb@gmail.com,
        siva.kallam@broadcom.com, prashant@broadcom.com,
        mchan@broadcom.com, dchickles@marvell.com, sburla@marvell.com,
        fmanlunas@marvell.com, vishal@chelsio.com,
        ulli.kroll@googlemail.com, linus.walleij@linaro.org
Subject: Re: [PATCH net-next 10/15] net: mlx4: reject unsupported coalescing
 params
Message-ID: <20200310103708.531ddd45@kicinski-fedora-PC1C0HJN>
In-Reply-To: <68c7fee0-baf7-40ec-95c9-9a08f6bd3f60@mellanox.com>
References: <20200310021512.1861626-1-kuba@kernel.org>
        <20200310021512.1861626-11-kuba@kernel.org>
        <68c7fee0-baf7-40ec-95c9-9a08f6bd3f60@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Mar 2020 16:11:16 +0200 Tariq Toukan wrote:
> On 3/10/2020 4:15 AM, Jakub Kicinski wrote:
> > Set ethtool_ops->supported_coalesce_params to let
> > the core reject unsupported coalescing parameters.
> > 
> > This driver did not previously reject unsupported parameters.
> > 
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> >   drivers/net/ethernet/mellanox/mlx4/en_ethtool.c | 4 ++++
> >   1 file changed, 4 insertions(+)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
> > index 8bf1f08fdee2..8a5ea2543670 100644
> > --- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
> > +++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
> > @@ -2121,6 +2121,10 @@ static int mlx4_en_set_phys_id(struct net_device *dev,
> >   }
> >   
> >   const struct ethtool_ops mlx4_en_ethtool_ops = {
> > +	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
> > +				     ETHTOOL_COALESCE_MAX_FRAMES |
> > +				     ETHTOOL_COALESCE_TX_MAX_FRAMES_IRQ |
> > +				     ETHTOOL_COALESCE_PKT_RATE_RX_USECS,  
> Hi Jakub,
> 
> We support several more params:
> 
> ETHTOOL_COALESCE_RX_USECS_LOW
> ETHTOOL_COALESCE_RX_USECS_HIGH
> ETHTOOL_COALESCE_RATE_SAMPLE_INTERVAL
> ETHTOOL_COALESCE_PKT_RATE_LOW
> ETHTOOL_COALESCE_PKT_RATE_HIGH
> ETHTOOL_COALESCE_USE_ADAPTIVE_RX
> ETHTOOL_COALESCE_TX_MAX_FRAMES_LOW
> ETHTOOL_COALESCE_TX_USECS

Most of these defines are groups, actually. Here's what they should
cover:

ETHTOOL_COALESCE_USECS
rx_coalesce_usecs
tx_coalesce_usecs

ETHTOOL_COALESCE_MAX_FRAMES
rx_max_coalesced_frames
tx_max_coalesced_frames

ETHTOOL_COALESCE_TX_MAX_FRAMES_IRQ
tx_max_coalesced_frames_irq

ETHTOOL_COALESCE_PKT_RATE_RX_USECS
use_adaptive_rx_coalesce
rx_coalesce_usecs_low
rx_coalesce_usecs_high
pkt_rate_low
pkt_rate_high
rate_sample_interval

So AFAICS all is covered.

I was wondering if I should name the groups somewhat differently to
make it clear?

> >   	.get_drvinfo = mlx4_en_get_drvinfo,
> >   	.get_link_ksettings = mlx4_en_get_link_ksettings,
> >   	.set_link_ksettings = mlx4_en_set_link_ksettings,
> >   
