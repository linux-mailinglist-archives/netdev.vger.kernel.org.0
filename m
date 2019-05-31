Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5AC3164E
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 22:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbfEaUyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 16:54:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46398 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726676AbfEaUyX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 16:54:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=h+UJ3AOdDkMJehGyK0PC/GcOlkiec2Rj4+med35US3k=; b=N3XIeGf5bklODesSg9tiVPDJhp
        Y7/GQHQ34+yN9tIw4pa3wm4VyAgWJMZj9Gr+P4jpR4PH+j4DyBuJsxv5fmYQCm+ZyvtvJttWMjE5l
        TYEl8LQYffoOmJyvmO268JBP3aU99lm9c6rh4V6SRlQ6g6bVpof5ch+rKWhP8aPqmirI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hWoXd-0001BZ-GL; Fri, 31 May 2019 22:54:21 +0200
Date:   Fri, 31 May 2019 22:54:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <hancock@sedsystems.ca>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next] net: phy: Ensure scheduled work is cancelled
 during removal
Message-ID: <20190531205421.GC3154@lunn.ch>
References: <1559330150-30099-1-git-send-email-hancock@sedsystems.ca>
 <1559330150-30099-2-git-send-email-hancock@sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559330150-30099-2-git-send-email-hancock@sedsystems.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Robert

Please make sure you Cc: PHY patches to the PHY maintainers.

Heiner, this one is for you.

	Andrew

On Fri, May 31, 2019 at 01:15:50PM -0600, Robert Hancock wrote:
> It is possible that scheduled work started by the PHY driver is still
> outstanding when phy_device_remove is called if the PHY was initially
> started but never connected, and therefore phy_disconnect is never
> called. phy_stop does not guarantee that the scheduled work is stopped
> because it is called under rtnl_lock. This can cause an oops due to
> use-after-free if the delayed work fires after freeing the PHY device.
> 
> Ensure that the state_queue work is cancelled in both phy_device_remove
> and phy_remove paths.
> 
> Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
> ---
>  drivers/net/phy/phy_device.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 2c879ba..1c90b33 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -877,6 +877,8 @@ int phy_device_register(struct phy_device *phydev)
>   */
>  void phy_device_remove(struct phy_device *phydev)
>  {
> +	cancel_delayed_work_sync(&phydev->state_queue);
> +
>  	device_del(&phydev->mdio.dev);
>  
>  	/* Assert the reset signal */
> -- 
> 1.8.3.1
> 
