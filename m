Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD3D207075
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 11:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390066AbgFXJxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 05:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389824AbgFXJxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 05:53:31 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B39C061573;
        Wed, 24 Jun 2020 02:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=UD+1Xv/MOWXYVyYCQmjzlHQ0Ovj7IvpeGpqz5TdCACA=; b=rHSUoUR6QQjHln0pIvcW9wMkS
        aJjXKcGWTWcAvBAm6qllBNSKmXfmbKTYvjs/WRBeCu6NoGhskjqKzaE/MwE+LpJ9TEx4hqa/GdC6x
        x7MPQpGAcKLc9thyom2QTI4gJYy4Ml+IwdlVXDt/wICe3gwfuoyb0yHyVku9vr8m0HdRoNcQegJx3
        r0iQTSnlD+9xHOKxtUMj720aodHnn6pHDZ5SOh8Md5MZDSSKdJ8itZ7OpAGAElYReCdDXQk+yIe+S
        9QJ+Y4rhHMrS0iWu6/O2nRfosZ3F38uYpmoi5NxkaRjQ03Gf5fB6RwWr8LI/D4uXgWS88CwkPqFez
        IS3tpeklg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59052)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jo25y-0002ph-Bg; Wed, 24 Jun 2020 10:53:30 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jo25x-0001qT-TS; Wed, 24 Jun 2020 10:53:29 +0100
Date:   Wed, 24 Jun 2020 10:53:29 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel@pengutronix.de
Subject: Re: [PATCH 1/2] net: ethernet: mvneta: Do not error out in non
 serdes modes
Message-ID: <20200624095329.GY1551@shell.armlinux.org.uk>
References: <20200624070045.8878-1-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624070045.8878-1-s.hauer@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 24, 2020 at 09:00:44AM +0200, Sascha Hauer wrote:
> In mvneta_config_interface() the RGMII modes are catched by the default
> case which is an error return. The RGMII modes are valid modes for the
> driver, so instead of returning an error add a break statement to return
> successfully.
> 
> This avoids this warning for non comphy SoCs which use RGMII, like
> SolidRun Clearfog:
> 
> WARNING: CPU: 0 PID: 268 at drivers/net/ethernet/marvell/mvneta.c:3512 mvneta_start_dev+0x220/0x23c
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

Fixes: b4748553f53f ("net: ethernet: mvneta: Fix Serdes configuration for SoCs without comphy")
Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>

Thanks.

> ---
>  drivers/net/ethernet/marvell/mvneta.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index af60001728481..c4552f868157c 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -3571,7 +3571,7 @@ static int mvneta_config_interface(struct mvneta_port *pp,
>  				    MVNETA_HSGMII_SERDES_PROTO);
>  			break;
>  		default:
> -			return -EINVAL;
> +			break;
>  		}
>  	}
>  
> -- 
> 2.27.0
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
