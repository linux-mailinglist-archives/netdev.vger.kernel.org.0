Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95863C18C2
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 19:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhGHSCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 14:02:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46608 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229469AbhGHSCE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 14:02:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=XeccN3vO+kZBO9cGBrJoTHdPFyuWAmPfbzHVpOaC8fY=; b=tppSSr1NFt4b3TicbMLi3prqV7
        Tn8oeifOWd4GI2qI54qN9Ho9tkVDidYizFDE8nee7HL63OcsHFl4F3kCb7GnxUWDp13QbVRQni+uG
        gBfsyDrdZ87ctOD/qIqPVI2Q8aE27YciBlSdJdyOfnw3jdfq1mp7FRwGDbaUs0CqCQpo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m1YIq-00CfWD-E0; Thu, 08 Jul 2021 19:59:12 +0200
Date:   Thu, 8 Jul 2021 19:59:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Carlos Bilbao <bilbao@vt.edu>
Cc:     davem@davemloft.net, Joe Perches <joe@perches.com>,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH net-next v2] drivers: ethernet: tulip: Fix indentation of
 printk
Message-ID: <YOc88LkI3KsiyaZF@lunn.ch>
References: <1884900.usQuhbGJ8B@iron-maiden>
 <5183009.Sb9uPGUboI@iron-maiden>
 <ccf9f07a72c911652d24ceb6c6e925f834f1d338.camel@perches.com>
 <4352381.cEBGB3zze1@iron-maiden>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4352381.cEBGB3zze1@iron-maiden>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 08, 2021 at 01:48:24PM -0400, Carlos Bilbao wrote:
> Fix indentation of printk that starts at the beginning of the line and does
> not have a KERN_<LEVEL>.
> 
> Signed-off-by: Carlos Bilbao <bilbao@vt.edu>
> ---
>  drivers/net/ethernet/dec/tulip/de4x5.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/dec/tulip/de4x5.c b/drivers/net/ethernet/dec/tulip/de4x5.c
> index b125d7faefdf..0d8ddfdd5c09 100644
> --- a/drivers/net/ethernet/dec/tulip/de4x5.c
> +++ b/drivers/net/ethernet/dec/tulip/de4x5.c
> @@ -3169,7 +3169,7 @@ dc2114x_autoconf(struct net_device *dev)
>  
>      default:
>  	lp->tcount++;
> -printk("Huh?: media:%02x\n", lp->media);
> +	printk(KERN_NOTICE "Huh?: media:%02x\n", lp->media);
>  	lp->media = INIT;
>  	break;
>      }

Since this is a network driver, and you have a net_device structure,
the best practice is to use

netdev_notice(dev, "Huh?: media:%02x\n", lp->media);

You could go through this driver and change all printk() to
netdev_dbg(), netdev_err(), netdev_info etc.  The advantage of these
calls is that they make it clear which network interface is outputting
the message.

Other subsystems have similar calls. If there are not subsystem
specific print functions, but you have a struct device, it is best to
use dev_err(), dev_dbg(), dev_info() etc. These functions will make it
clear which device is printing the message.

	      Andrew
