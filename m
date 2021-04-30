Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC4E437034A
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 23:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbhD3V6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 17:58:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48680 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229915AbhD3V63 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Apr 2021 17:58:29 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lcb8j-001s1W-5i; Fri, 30 Apr 2021 23:57:37 +0200
Date:   Fri, 30 Apr 2021 23:57:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Don Bollinger <don@thebollingers.org>
Cc:     'Moshe Shemesh' <moshe@nvidia.com>,
        'Michal Kubecek' <mkubecek@suse.cz>,
        'Jakub Kicinski' <kuba@kernel.org>, netdev@vger.kernel.org,
        'Vladyslav Tarasiuk' <vladyslavt@nvidia.com>
Subject: Re: [PATCH ethtool-next 0/4] Extend module EEPROM API
Message-ID: <YIx9UaSckIraOQCC@lunn.ch>
References: <1619162596-23846-1-git-send-email-moshe@nvidia.com>
 <008301d73e03$1196abb0$34c40310$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <008301d73e03$1196abb0$34c40310$@thebollingers.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> There are routine functions to configure the devices that require writing
> appropriate values to various registers.  Byte 26 allows software control of
> low power mode, squelch and software reset.  Page 10h is full of Lane and
> Data Path Control registers.

These all sounds like foot canons when in user space control. I would
expect the MAC and or SFP driver to make use of these features, no
need to export them to user space, at least not in a raw format. I
could however imagine ethtool commands to manipulate specific
features, passing the request to the MAC to perform, so it knows what
is going on.
 
> Beyond the spec, but allowed by the spec, there are vendor specific
> capabilities like firmware download that require bulk write (up to 128 bytes
> per write).

This one is not so easy. Since it is vendor specific, we need to
consider how to actually make it vendor generic from Ethtool, or maybe
devlink. Maybe code in the kernel which matches on the vendor string
in the SFP EEPROM, and provides a standardized API towards ethtool,
and does whatever magic is needed towards the SFP. But it gets messy
when you don't have direct access to the SFP, there is a layer of
firmware in the middle, which is often the case.

	 Andrew
