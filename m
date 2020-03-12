Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04524182F71
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 12:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgCLLlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 07:41:36 -0400
Received: from foss.arm.com ([217.140.110.172]:60960 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbgCLLlg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 07:41:36 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1ACA331B;
        Thu, 12 Mar 2020 04:41:35 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 11AB33F67D;
        Thu, 12 Mar 2020 04:41:33 -0700 (PDT)
Date:   Thu, 12 Mar 2020 11:41:31 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Radhey Shyam Pandey <radheys@xilinx.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Michal Simek <michals@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/14] net: axienet: Add mii-tool support
Message-ID: <20200312114131.070d9a1c@donnerap.cambridge.arm.com>
In-Reply-To: <CH2PR02MB700089E502A8C146D71C67C8C7350@CH2PR02MB7000.namprd02.prod.outlook.com>
References: <20200110115415.75683-1-andre.przywara@arm.com>
 <20200110115415.75683-10-andre.przywara@arm.com>
 <CH2PR02MB700089E502A8C146D71C67C8C7350@CH2PR02MB7000.namprd02.prod.outlook.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jan 2020 06:12:10 +0000
Radhey Shyam Pandey <radheys@xilinx.com> wrote:

Hi,

(sorry, forgot to send this out before posting v2)

> > -----Original Message-----
> > From: Andre Przywara <andre.przywara@arm.com>
> > Sent: Friday, January 10, 2020 5:24 PM
> > To: David S . Miller <davem@davemloft.net>; Radhey Shyam Pandey
> > <radheys@xilinx.com>
> > Cc: Michal Simek <michals@xilinx.com>; Robert Hancock
> > <hancock@sedsystems.ca>; netdev@vger.kernel.org; linux-arm-
> > kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> > Subject: [PATCH 09/14] net: axienet: Add mii-tool support
> > 
> > mii-tool is useful for debugging, and all it requires to work is to wire
> > up the ioctl ops function pointer.
> > Add this to the axienet driver to enable mii-tool.
> > 
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > ---
> >  drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> > b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> > index 7a747345e98e..64f799f3d248 100644
> > --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> > +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> > @@ -1152,6 +1152,16 @@ static void axienet_poll_controller(struct net_device
> > *ndev)
> >  }
> >  #endif
> > 
> > +static int axienet_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
> > +{
> > +	struct axienet_local *lp = netdev_priv(dev);
> > +
> > +	if (!netif_running(dev))
> > +		return -EINVAL;  
> 
> I think phy ioctl should be allowed even if the device is not up. 
> Or is there any specific reason for keeping it?

I found that some of the drivers check this (macb, stmmac), while others (dpaa2, mvneta, mvpp2, mtk_eth) don't. I don't know the reasons for that, so I play safe here.
Happy to change this if someone provides some rationale.

Cheers,
Andre.

> 
> > +
> > +	return phylink_mii_ioctl(lp->phylink, rq, cmd);
> > +}
> > +
> >  static const struct net_device_ops axienet_netdev_ops = {
> >  	.ndo_open = axienet_open,
> >  	.ndo_stop = axienet_stop,
> > @@ -1159,6 +1169,7 @@ static const struct net_device_ops
> > axienet_netdev_ops = {
> >  	.ndo_change_mtu	= axienet_change_mtu,
> >  	.ndo_set_mac_address = netdev_set_mac_address,
> >  	.ndo_validate_addr = eth_validate_addr,
> > +	.ndo_do_ioctl = axienet_ioctl,
> >  	.ndo_set_rx_mode = axienet_set_multicast_list,
> >  #ifdef CONFIG_NET_POLL_CONTROLLER
> >  	.ndo_poll_controller = axienet_poll_controller,
> > --
> > 2.17.1  
> 

