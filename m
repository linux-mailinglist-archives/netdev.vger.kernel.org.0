Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8F35832B
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 15:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbfF0NNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 09:13:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36832 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726059AbfF0NNc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 09:13:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fm7wk5NOwsV3tSIIRbW+oTp2HaLpDSjgRQD483H4QqU=; b=kbVfFFQHklhJKy0JHlX5AToJlk
        y+5q9OgDYo565asgVUAA1WFm4XXHfa4HrsqJJJztyLuvfqGB9gkrV7ak7MDHRYEyVVI3WGkdgjvNc
        yX8gmVr3/yQ56I+gUvohCX0QdzB7v6LM8lBZd1FRuS4stq31y1IWo0AcQpOyiHU+YEdY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hgUDM-0008AZ-0W; Thu, 27 Jun 2019 15:13:24 +0200
Date:   Thu, 27 Jun 2019 15:13:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: mv88e6xxx: wait after reset deactivation
Message-ID: <20190627131323.GA31189@lunn.ch>
References: <92655572ed0c232b490967bed1245d121cc5a299.1561609786.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92655572ed0c232b490967bed1245d121cc5a299.1561609786.git.baruch@tkos.co.il>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 07:29:46AM +0300, Baruch Siach wrote:
> Add a 1ms delay after reset deactivation. Otherwise the chip returns
> bogus ID value. This is observed with 88E6390 (Peridot) chip.
> 
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index f4e2db44ad91..549f528f216c 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -4910,6 +4910,7 @@ static int mv88e6xxx_probe(struct mdio_device *mdiodev)
>  		err = PTR_ERR(chip->reset);
>  		goto out;
>  	}
> +	mdelay(1);
>  
>  	err = mv88e6xxx_detect(chip);
>  	if (err)

Hi Baruch

So your switch is held in reset by default, by the bootloader? So you
need to take it out of reset in order to detect it. Yes, this makes
sense.

However, please use usleep_range(10000, 20000), and only do this if
the GPIO is valid.

Thanks

	Andrew
