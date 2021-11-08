Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9ED449CBA
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 20:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238000AbhKHT4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 14:56:31 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:51336 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237891AbhKHT4a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 14:56:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=tkHOqRl65t9wybmGiKhhe/EfI/jcQW1AOyReaAVadCU=; b=fqeyTs0xe5dnBpErQ5uU1VCqWl
        a3T7OuP/xp/XGuaDOLyEt/21UVOpo/jAYTWQqKNsEa/CK6akVxAatzaxHaJekgOAKClQHY5DSmFVr
        qcrXeH8zfrm2hmD728eYgau2CFQgOs1Zg1HXDWDMCInaks3tux+x4nHZQBQYdRJ+qm2c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mkAi0-00CvWI-Ky; Mon, 08 Nov 2021 20:53:36 +0100
Date:   Mon, 8 Nov 2021 20:53:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
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
Message-ID: <YYmAQDIBGxPXCNff@lunn.ch>
References: <20211108002500.19115-1-ansuelsmth@gmail.com>
 <20211108002500.19115-2-ansuelsmth@gmail.com>
 <YYkuZwQi66slgfTZ@lunn.ch>
 <YYk/Pbm9ZZ/Ikckg@Ansuel-xps.localdomain>
 <20211108171312.0318b960@thinkpad>
 <YYliclrZuxG/laIh@lunn.ch>
 <20211108185637.21b63d40@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211108185637.21b63d40@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I guess I will have to work on this again ASAP or we will end up with
> solution that I don't like.
> 
> Nonetheless, what is your opinion about offloading netdev trigger vs
> introducing another trigger?

It is a solution that fits the general pattern, do it in software, and
offload it if possible.

However, i'm not sure the software solution actually works very well.
At least for switches. The two DSA drivers which implement
get_stats64() simply copy the cached statistics. The XRS700X updates
its cached values every 3000ms. The ar9331 is the same. Those are the
only two switch drivers which implement get_stats64 and none implement
get_stats. There was also was an issue that get_stats64() cannot
perform blocking calls. I don't remember if that was fixed, but if
not, get_stats64() is going to be pretty useless on switches.

We also need to handle drivers which don't actually implement
dev_get_stats(). That probably means only supporting offloads, all
modes which cannot be offloaded need to be rejected. This is pretty
much the same case of software control of the LEDs is not possible.
Unfortunately, dev_get_stats() does not return -EOPNOTSUPP, you need
to look at dev->netdev_ops->ndo_get_stats64 and
dev->netdev_ops->ndo_get_stats.

Are you working on Marvell switches? Have you implemented
get_stats64() for mv88e6xxx? How often do you poll the hardware for
the stats?

Given this, i think we need to bias the API so that it very likely
ends up offloading, if offloading is available.

     Andrew

