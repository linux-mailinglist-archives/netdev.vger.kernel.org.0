Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C59C3B89B4
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 22:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbhF3Ubi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 16:31:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35404 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233899AbhF3Ubh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 16:31:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=QkcoE2+3I9/OrZ/N4k7R/vA0bR0/K0Y+Elz9pgzO1zk=; b=nWi51W+/fn7ciAOVvijHP9R1Ca
        q2elyYuTf7iSbj4rbyTLtBrnMiwyQL8/f6pfZq9E2pI82zaI4eU3l+t8LcHO/gInXpNn3bmK9/d6f
        fW3S6d6sp0Iwr+vSE7AYiHr/OUy60PICZzS8ffr9sWIF7kAu6I1OhiB+Gyqmp9lQoc6w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lygpT-00BhKQ-0g; Wed, 30 Jun 2021 22:29:03 +0200
Date:   Wed, 30 Jun 2021 22:29:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, linux@armlinux.org.uk, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: axienet: Allow phytool access to PCS/PMA
 PHY
Message-ID: <YNzUD/jvgVmh/YvC@lunn.ch>
References: <20210630174022.1016525-1-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630174022.1016525-1-robert.hancock@calian.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 30, 2021 at 11:40:22AM -0600, Robert Hancock wrote:
> Allow phytool ioctl access to read/write registers in the internal
> PCS/PMA PHY if it is enabled.
> 
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>
> ---
>  .../net/ethernet/xilinx/xilinx_axienet_main.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> index 13cd799541aa..41f2c2255118 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -1213,10 +1213,29 @@ static void axienet_poll_controller(struct net_device *ndev)
>  static int axienet_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
>  {
>  	struct axienet_local *lp = netdev_priv(dev);
> +	struct mii_ioctl_data *mii = if_mii(rq);
>  
>  	if (!netif_running(dev))
>  		return -EINVAL;
>  
> +	if (lp->pcs_phy && lp->pcs_phy->addr == mii->phy_id) {
> +		int ret;
> +
> +		switch (cmd) {
> +		case SIOCGMIIREG:
> +			ret = mdiobus_read(lp->pcs_phy->bus, mii->phy_id, mii->reg_num);
> +			if (ret >= 0) {
> +				mii->val_out = ret;
> +				ret = 0;
> +			}
> +			return ret;
> +
> +		case SIOCSMIIREG:
> +			return mdiobus_write(lp->pcs_phy->bus, mii->phy_id,
> +					     mii->reg_num, mii->val_in);
> +		}


I would prefer not to allow write. The kernel should be driving the
hardware, and if user space changes values, the kernel has no idea
about it, and can do the wrong things.

      Andrew
