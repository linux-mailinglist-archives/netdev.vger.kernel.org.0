Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 233CB449CEC
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 21:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238454AbhKHUOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 15:14:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:35318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231251AbhKHUOB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 15:14:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF69260234;
        Mon,  8 Nov 2021 20:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636402276;
        bh=rEhGYaNhEjOwF3udFY6tXD+7DrAWIkpttgy+7HoR1tU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y9w0lTil+unC2FCt3Pd3O202/5SxrND+4WcKH3p9Z2H2N5+wxn+Dy/+d4djm0iGbW
         uFWQjQWTUnWfS7bG4Udikz5BZuQcvaZKCFYNvHURe1UjhRZKyYAJCo5RGGmw88jAvx
         I2+A+hxFnE7Qmxnm46Um1cZKlpFJB+Dnty2We9kVtWlxeJphppE3Io+YZTGuTf1ZF9
         xfVh4F5rQ4+HFXOTcgE9iHGnu8heOlEkgT9vAT3qCAmVsz5/6g5wFzjeRWGT1SRY3K
         oYthfGTHH6BVwmmZ5ugGZKqjk7R8q3fXVMc64JumVidBT0N39LU2LtAVuSMAklVudd
         dG0ZmGQERQgMA==
Date:   Mon, 8 Nov 2021 21:11:10 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/5] leds: trigger: add API for HW offloading of
 triggers
Message-ID: <20211108211110.4ad78e41@thinkpad>
In-Reply-To: <YYmAQDIBGxPXCNff@lunn.ch>
References: <20211108002500.19115-1-ansuelsmth@gmail.com>
        <20211108002500.19115-2-ansuelsmth@gmail.com>
        <YYkuZwQi66slgfTZ@lunn.ch>
        <YYk/Pbm9ZZ/Ikckg@Ansuel-xps.localdomain>
        <20211108171312.0318b960@thinkpad>
        <YYliclrZuxG/laIh@lunn.ch>
        <20211108185637.21b63d40@thinkpad>
        <YYmAQDIBGxPXCNff@lunn.ch>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Nov 2021 20:53:36 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

> > I guess I will have to work on this again ASAP or we will end up with
> > solution that I don't like.
> > 
> > Nonetheless, what is your opinion about offloading netdev trigger vs
> > introducing another trigger?  
> 
> It is a solution that fits the general pattern, do it in software, and
> offload it if possible.
> 
> However, i'm not sure the software solution actually works very well.
> At least for switches. The two DSA drivers which implement
> get_stats64() simply copy the cached statistics. The XRS700X updates
> its cached values every 3000ms. The ar9331 is the same. Those are the
> only two switch drivers which implement get_stats64 and none implement
> get_stats. There was also was an issue that get_stats64() cannot
> perform blocking calls. I don't remember if that was fixed, but if
> not, get_stats64() is going to be pretty useless on switches.
> 
> We also need to handle drivers which don't actually implement
> dev_get_stats(). That probably means only supporting offloads, all
> modes which cannot be offloaded need to be rejected. This is pretty
> much the same case of software control of the LEDs is not possible.
> Unfortunately, dev_get_stats() does not return -EOPNOTSUPP, you need
> to look at dev->netdev_ops->ndo_get_stats64 and
> dev->netdev_ops->ndo_get_stats.
> 
> Are you working on Marvell switches? Have you implemented
> get_stats64() for mv88e6xxx? How often do you poll the hardware for
> the stats?
> 
> Given this, i think we need to bias the API so that it very likely
> ends up offloading, if offloading is available.

I am working with Marvell PHYs and Marvell switches. I am aware of the
problem that SW netdev does not work for switches because we don't have
uptodate data.

It seems to me that yes, if the user wants to blink the LEDs on
activity on switch port, the netdev trigger should only work in offload
mode and only on LEDs that are connected to switch pins, unless we
implement a mechanism to get statistics at lest 10 times a second
(which could maybe be done on marvell switches by reading the registers
via ethernet frames instead of MDIO).

Marvell switches don't seem to support rx only / tx only activity
blinking, only rx/tx. I think this could be solved by making rx/tx
sysfs files for netdev trigger behave so that writing to one would also
write to another.

But since currently netdev trigger does not work for these switches, I
think making it so that it works at least to some fashion (in HW
supported modes) would still be better that current situation.

I will try to look into this, maybe work together with Ansuel.

Marek
