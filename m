Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63266433EC4
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 20:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbhJSSxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 14:53:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47402 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230432AbhJSSxd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 14:53:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=XyDOlNEps2PQPz5H4bnK67kSEIkgFEX6exshJ2yzhyM=; b=bA+YYgRDKxKJpD5QHiKoXNPb8i
        cIqAjABUWsHq/iIfvSKyYreq5Kxs+xSTXA4ZgwanMczGCB1iXjvCXY7FCAVMm/mGCVAFgivPU2oJx
        4BrqqGWcvD3CsP4PmU1YrhrEDcW3pl/MeKeno0dn3talGkcsjHxDcdCZvtu8nmgSsjng=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mcuCc-00B7DH-5q; Tue, 19 Oct 2021 20:51:10 +0200
Date:   Tue, 19 Oct 2021 20:51:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: phy: dp83867: introduce critical chip
 default init for non-of platform
Message-ID: <YW8TnjisOh1OEpz+@lunn.ch>
References: <20211013034128.2094426-1-boon.leong.ong@intel.com>
 <20211013034128.2094426-2-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013034128.2094426-2-boon.leong.ong@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 13, 2021 at 11:41:27AM +0800, Ong Boon Leong wrote:
> From: "Lay, Kuan Loon" <kuan.loon.lay@intel.com>
> 
> PHY driver dp83867 has rich supports for OF-platform to fine-tune the PHY
> chip during phy configuration. However, for non-OF platform, certain PHY
> tunable parameters such as IO impedence and RX & TX internal delays are
> critical and should be initialized to its default during PHY driver probe.
> 
> Signed-off-by: Lay, Kuan Loon <kuan.loon.lay@intel.com>
> Co-developed-by: Ong Boon Leong <boon.leong.ong@intel.com>
> Tested-by: Clement <clement@intel.com>
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
> ---
>  drivers/net/phy/dp83867.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
> index 6bbc81ad295f..bb4369b75179 100644
> --- a/drivers/net/phy/dp83867.c
> +++ b/drivers/net/phy/dp83867.c
> @@ -619,6 +619,24 @@ static int dp83867_of_init(struct phy_device *phydev)
>  #else
>  static int dp83867_of_init(struct phy_device *phydev)
>  {
> +	struct dp83867_private *dp83867 = phydev->priv;
> +	u16 delay;

So this is in the stub for when OF is disabled. What about the case
that OF is enabled? I've used DT on x86, even Intel used it for
intel,ce4100 aka falconfalls. So rather than do this in the stub, i
would look at the value of dev->of_node. If it is NULL, do this. That
should always work, and it is how other drivers deal with none OF
cases.

> +	/* Per datasheet, IO impedance is default to 50-ohm, so we set the same
> +	 * here or else the default '0' means highest IO impedence which is wrong.
> +	 */
> +	dp83867->io_impedance = DP83867_IO_MUX_CFG_IO_IMPEDANCE_MIN / 2;
> +

I would prefer you add a new define
DP83867_IO_MUX_CFG_IO_IMPEDANCE_DEFAULT, which then avoids this very
odd looking 1/2 the minimum.

    Andrew
