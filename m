Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 361B121AAAA
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 00:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgGIWjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 18:39:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56166 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726213AbgGIWjj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 18:39:39 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jtfCa-004OKF-O8; Fri, 10 Jul 2020 00:39:36 +0200
Date:   Fri, 10 Jul 2020 00:39:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: Re: MDIO Debug Interface
Message-ID: <20200709223936.GC1014141@lunn.ch>
References: <C42DZQLTPHM5.2THDSRK84BI3T@wkz-x280>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C42DZQLTPHM5.2THDSRK84BI3T@wkz-x280>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 09, 2020 at 10:47:54PM +0200, Tobias Waldekranz wrote:
> Hi netdev,
> 
> TL;DR: Is something like https://github.com/wkz/mdio-tools a good
> idea?
> 
> The kernel does not, as far as I know, have a low-level debug
> interface to MDIO devices. I.e. something equivalent to i2c-dev or
> spi-dev for example.

Hi Tobias

These APIs exist to allow user space drivers. I don't know how much
that happens now a days, there seems to be a lot of kernel space
drivers for SPI and I2C, but it is still possible to write user space
drivers.

We have never allowed user space drivers for MDIO devices. As a
result, we have pretty good kernel support for PHYs and quite a few L2
switches, and the numbers keep increasing.

But the API you are suggesting sounds like it becomes an easy way for
vendors to run their SDKs in user space, with a small bit of glue code
to this new API. That is something we should avoid.

It is a difficult trade off. Such an API as you suggest does allow for
nice debug tools for driver developers. And i have no problems with
such a tool existing, being out of tree for any developer to use. But
i'm not too happy with it being in mainline because i suspect it will
get abused by vendors.

Something i'm want to look at soon is dumping more of the internal
state of the mv88e6xxx switches. The full ATU and VTU, TCAM etc. I
think devlink region could work for this. And i think the ethtool -d
command could be made a lot better now we have a netlink API. The old
API assumed a single address space. It would be nice to support
multiple address spaces.

The advantage of these APIs is that they cannot be abused by vendors
to write user space drivers. But we can still have reasonably powerful
debug tools built on top of them.

       Andrew
