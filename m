Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53FAA2BC1D5
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 20:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbgKUTuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 14:50:23 -0500
Received: from smtprelay0079.hostedemail.com ([216.40.44.79]:56188 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728402AbgKUTuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 14:50:22 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 9CD14127B;
        Sat, 21 Nov 2020 19:50:20 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2393:2525:2560:2563:2682:2685:2828:2859:2902:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4605:5007:7903:9025:10004:10400:10848:11026:11232:11233:11657:11658:11783:11914:12043:12048:12297:12438:12679:12740:12895:13069:13311:13357:13439:13894:14181:14659:14721:21080:21451:21627:21939:30012:30046:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:102,LUA_SUMMARY:none
X-HE-Tag: knee97_180892727356
X-Filterd-Recvd-Size: 2999
Received: from XPS-9350.home (unknown [47.151.128.180])
        (Authenticated sender: joe@perches.com)
        by omf17.hostedemail.com (Postfix) with ESMTPA;
        Sat, 21 Nov 2020 19:50:18 +0000 (UTC)
Message-ID: <de5b16cf3fdac1f783e291acc325b78368653ec5.camel@perches.com>
Subject: Re: [PATCH 072/141] can: peak_usb: Fix fall-through warnings for
 Clang
From:   Joe Perches <joe@perches.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Date:   Sat, 21 Nov 2020 11:50:17 -0800
In-Reply-To: <bf3dbc5c-c34e-b3ef-abb6-0c88d8a90332@pengutronix.de>
References: <cover.1605896059.git.gustavoars@kernel.org>
         <aab7cf16bf43cc7c3e9c9930d2dae850c1d07a3c.1605896059.git.gustavoars@kernel.org>
         <bf3dbc5c-c34e-b3ef-abb6-0c88d8a90332@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2020-11-21 at 14:17 +0100, Marc Kleine-Budde wrote:
> On 11/20/20 7:34 PM, Gustavo A. R. Silva wrote:
> > In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
> > by explicitly adding a break statement instead of letting the code fall
> > through to the next case.
> > 
> > Link: https://github.com/KSPP/linux/issues/115
> > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
[]
> > diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
[]
> > @@ -299,6 +299,8 @@ static void peak_usb_write_bulk_callback(struct urb *urb)
> >  		if (net_ratelimit())
> >  			netdev_err(netdev, "Tx urb aborted (%d)\n",
> >  				   urb->status);
> > +		break;
> > +
> >  	case -EPROTO:
> >  	case -ENOENT:
> >  	case -ECONNRESET:
> > 
> 
> What about moving the default to the end if the case, which is more common anyways:
> 
> diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
[]
> @@ -295,16 +295,16 @@ static void peak_usb_write_bulk_callback(struct urb *urb)
>                 netif_trans_update(netdev);
>                 break;
>  
> 
> -       default:
> -               if (net_ratelimit())
> -                       netdev_err(netdev, "Tx urb aborted (%d)\n",
> -                                  urb->status);
>         case -EPROTO:
>         case -ENOENT:
>         case -ECONNRESET:
>         case -ESHUTDOWN:
> -
>                 break;
> +
> +       default:
> +               if (net_ratelimit())
> +                       netdev_err(netdev, "Tx urb aborted (%d)\n",
> +                                  urb->status);

That's fine and is more generally used style but this
default: case should IMO also end with a break;

+		break;

>         }


