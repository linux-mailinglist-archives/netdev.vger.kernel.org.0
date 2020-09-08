Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE052619AE
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 20:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731596AbgIHSZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 14:25:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50582 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730748AbgIHSWZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 14:22:25 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kFiG4-00Dp7f-7W; Tue, 08 Sep 2020 20:22:20 +0200
Date:   Tue, 8 Sep 2020 20:22:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukasz Stelmach <l.stelmach@samsung.com>
Cc:     devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        b.zolnierkie@samsung.com, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org, m.szyprowski@samsung.com
Subject: Re: [PATCH 1/3] net: ax88796c: ASIX AX88796C SPI Ethernet Adapter
 Driver
Message-ID: <20200908182220.GA3290129@lunn.ch>
References: <20200907181854.GD3254313@lunn.ch>
 <CGME20200908174935eucas1p2f24d79b234152148b060c45863e3efeb@eucas1p2.samsung.com>
 <dleftj8sdkqhun.fsf%l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dleftj8sdkqhun.fsf%l.stelmach@samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 08, 2020 at 07:49:20PM +0200, Lukasz Stelmach wrote:
> It was <2020-09-07 pon 20:18>, when Andrew Lunn wrote:
> >> > On Tue, Aug 25, 2020 at 07:03:09PM +0200, Łukasz Stelmach wrote:
> >> >> +++ b/drivers/net/ethernet/asix/ax88796c_ioctl.c
> >> >
> >> > This is an odd filename. The ioctl code is wrong anyway, but there is
> >> > a lot more than ioctl in here. I suggest you give it a new name.
> >> >
> >> 
> >> Sure, any suggestions?
> >
> > Sorry, i have forgotten what is actually contained. 
> 
> IOCTL handler (.ndo_do_ioctl), ethtool ops, and a bunch of hw control
> functions.
> 
> > Does it even need to be a separate file?
> 
> It doesn't need, but I think it makes sense to keep ioctl and ethtool
> stuff in a separate file. Some of the hw control function look like they
> might change after using phylib.

<driver>_ethtool.c is a common file name.

> Good point. I need to figure out how to do it. Can you point (from the
> top fou your head) a driver which does it for a simmilarly integrated
> device?

Being integrated or not makes no difference. The API usage is the
same. drivers/net/usb/smsc95xx.c has an integrated PHY i think.

> I am not arguing to keep the parameter at any cost, but I would really
> like to know if there is a viable alternative for DT and ACPI. This chip
> is for smaller systems which not necessarily implement advanced
> bootloaders (and DT).

What bootload is being used, if not uboot or bearbox?

> According to module.h
> 
> /*
>  * Author(s), use "Name <email>" or just "Name", for multiple
>  * authors use multiple MODULE_AUTHOR() statements/lines.
>  */

Thanks, did not know that.
> >> >> +	struct net_device *ndev = ax_local->ndev;
> >> >> +	int status;
> >> >> +
> >> >> +	do {
> >> >> +		if (!(ax_local->checksum & AX_RX_CHECKSUM))
> >> >> +			break;
> >> >> +
> >> >> +		/* checksum error bit is set */
> >> >> +		if ((rxhdr->flags & RX_HDR3_L3_ERR) ||
> >> >> +		    (rxhdr->flags & RX_HDR3_L4_ERR))
> >> >> +			break;
> >> >> +
> >> >> +		if ((rxhdr->flags & RX_HDR3_L4_TYPE_TCP) ||
> >> >> +		    (rxhdr->flags & RX_HDR3_L4_TYPE_UDP)) {
> >> >> +			skb->ip_summed = CHECKSUM_UNNECESSARY;
> >> >> +		}
> >> >> +	} while (0);
> >> >
> >> >
> >> > ??
> >> >
> >> 
> >> if() break; Should I use goto?
> >
> > Sorry, i was too ambiguous. Why:
> >
> > do {
> > } while (0);
> >
> > It is an odd construct.
> 
> As to "why" — you have correctly spotted, this is a vendor driver I am
> porting. Although it's not like I am trying to avoid any changes, but
> because this driver worked for us on older kernels (v3.10.9) I am trying
> not to touch pieces which IMHO are good enough.

My experience with vendor drivers is you nearly end up rewriting it to
bring it up to mainline standards. I would suggest first setting up
some automated tests, and then make lots of small changes, committed
to git. You can then go backwards and find where regressions have been
introduced and found by the automated tests. And then every so often
squash it all together, ready for submission.

> To avoid using do{}while(0) it requires either goto (instead of breaks),
> nesting those if()s in one another or a humongous single if(). Neither
> looks pretty and the last one is even less readable than
> do()while.

I removed too much context. Does anything useful happen afterwards?
Maybe you can just use return? Or put that code into a helper which
can use return rather than break?

      Andrew
