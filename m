Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC8F3A477D
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 19:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbhFKRKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 13:10:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59688 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229510AbhFKRKI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 13:10:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=6T7kZ03xwL1KC1iS1k0e4hpoEerlMg9oGroEXRU3uws=; b=SBj2jLq9tpzGW2hPfTQC71h8jE
        BOfHdzo63YZbgLOrNV1z5XGwNW8ENW+dNGbW2JS10MJx5VUH10VR2MGHRKXqAmOh3gYMQ0FbddMHv
        WzhvXt9WZy3eAjFtoi8MJSRtzJDXtEmyzWocp5lq5pMuFnObOJBvKJdZzHmG2slOGjYU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lrkdU-008t06-LY; Fri, 11 Jun 2021 19:08:00 +0200
Date:   Fri, 11 Jun 2021 19:08:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     "jiri@nvidia.com" <jiri@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Subject: Re: [PATCH net-next 10/11] net: marvell: prestera: add storm control
 (rate limiter) implementation
Message-ID: <YMOYcHleEOjmnqjt@lunn.ch>
References: <20210609151602.29004-1-oleksandr.mazur@plvision.eu>
 <20210609151602.29004-11-oleksandr.mazur@plvision.eu>
 <YMIIcgKjIH5V+Exf@lunn.ch>
 <AM0P190MB0738E3909FB0EA0031A24F07E4349@AM0P190MB0738.EURP190.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0P190MB0738E3909FB0EA0031A24F07E4349@AM0P190MB0738.EURP190.PROD.OUTLOOK.COM>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 01:19:13PM +0000, Oleksandr Mazur wrote:
> >>  On Wed, Jun 09, 2021 at 06:16:00PM +0300, Oleksandr Mazur wrote:
> > Storm control (BUM) provides a mechanism to limit rate of ingress
> > > port traffic (matched by type). Devlink port parameter API is used:
> > > driver registers a set of per-port parameters that can be accessed to both
> > > get/set per-port per-type rate limit.
> > > Add new FW command - RATE_LIMIT_MODE_SET.
> 
> > Hi Oleksandr
> 
> > Just expanding on the two comments you already received about this.
> 
> > We often see people miss that switchdev is about. It is not about
> > writing switch drivers. It is about writing network stack
> > accelerators. You take a feature of the Linux network stack and you
> > accelerate it by offloading it to the hardware. So look around the
> > network stack and see how you configure it to perform rate limiting of
> > broadcast traffic ingress. Once you have found a suitable mechanism,
> > accelerate it via offloading.
> 
> > If you find Linux has no way to perform a feature the hardware could
> > accelerate, you first need to add a pure software version of that
> > feature to the network stack, and then add acceleration support for
> > it.
> 
> 
> Hello Andrew, Ido, Nikolay,
> I appreciate your time and comments provided over this patchset, though i have a few questions to ask, if you don't mind:
> 

> 1. Does it mean that in order to support storm control in switchdev
> driver i need to implement software storm control in bridge driver,
> and then using the switchdev attributes (notifiers) mechanism
> offload the configuration itself to the HW?

Hi Oleksandr

Not necessarily. Is storm control anything more than ingress packet
matching and rate limiting?

I'm not TC expert, but look for example at
https://man7.org/linux/man-pages/man8/tc-police.8.html

and the example:

# tc qdisc add dev eth0 handle ffff: ingress
# tc filter add dev eth0 parent ffff: u32 \
                   match u32 0 0 \
                   police rate 1mbit burst 100k

Replace the "match u32 0 0" with something which matches on broadcast
frames.  Maybe "flower dst_mac ff:ff:ff:ff:ff:ff"

So there is a software solution. Now accelerate it.

> 2. Is there any chance of keeping devlink solution untill the
> discussed (storm control implemented in the bridge driver) mechanism
> will be ready/implemented?

No. Please do it correctly from the beginning. No hacks.

    Andrew
