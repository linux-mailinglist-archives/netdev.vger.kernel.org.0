Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F01181661E2
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 17:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728567AbgBTQJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 11:09:17 -0500
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:31381 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728493AbgBTQJQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 11:09:16 -0500
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 01KG8uam001235;
        Thu, 20 Feb 2020 17:08:56 +0100
Date:   Thu, 20 Feb 2020 17:08:56 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Joel Johnson <mrjoel@lixil.net>,
        "David S. Miller" <davem@davemloft.net>,
        Baruch Siach <baruch@tkos.co.il>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Rob Herring <robh@kernel.org>, netdev@vger.kernel.org
Subject: Re: mvneta: comphy regression with SolidRun ClearFog
Message-ID: <20200220160856.GA1186@1wt.eu>
References: <af7602ae737cbc21ce7f01318105ae73@lixil.net>
 <20200219092227.GR25745@shell.armlinux.org.uk>
 <8099d231594f1785e7149e4c6c604a5c@lixil.net>
 <20200220101232.GU25745@shell.armlinux.org.uk>
 <9c61fda15f89a69989c0d80fda33ea47@lixil.net>
 <20200220154521.GB25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220154521.GB25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 20, 2020 at 03:45:21PM +0000, Russell King - ARM Linux admin wrote:
> > With the current defaults, it seems like PHY_MVEBU_CP110_COMPHY may be
> > affected in Debian the same way as PHY_MVEBU_A38X_COMPHY, but I don't have
> > available Armada 7K/8K hardware yet to confirm.

On this point I can confirm that my mcbin does require
CONFIG_PHY_MVEBU_CP110_COMPHY to work correctly.

> There is no clear answer to whether should something default to Y,
> M or N - different people have different ideas and different levels
> of frustration with which-ever are picked.
> 
> The root problem is that there are way too many configuration
> options that it's become quite time consuming to put together the
> proper kernel configuration for any particular platform, and things
> get even more interesting when it comes to a kernel supporting
> multiple platforms, where one may wish to avoid having a huge
> kernel image, but want to use modules for the platform specific
> bits.
> 
> I wonder whether we ought to be considering something like:
> 
> menuconfig ARCH_MVEBU_DEFAULTS
> 	tristate "Marvell Engineering Business Unit (MVEBU) SoCs"
> 
> config ARCH_MVEBU
> 	def_bool y if ARCH_MVEBU_DEFAULTS
> 	...
> 
> and then have mvebu drivers default to the state of
> ARCH_MVEBU_DEFAULTS.  That means, if you want to build the
> platform with modular drivers, or built-in drivers there's one top
> level config that will default all the appropriate options that way,
> and any new drivers added later can pick up on the state of that
> option.
> 
> Just a thought.

I found that phys are actually a very obscure area for many users, a
bit like codecs for sound, and that even when you think you know what
you're doing you can get it wrong. Part of the reason is the common
total disconnection between certain phy chips and the places they're
used (sometimes different vendors for the PHY and the MAC), and actually
a very good approach would be to clearly enumerate a list of candidate
platforms instead of families. Typically for A38X and CP110 it's clearly
mentioned in the help messages that they're for Armada 38x/7k/8k but
often it's obscure (e.g. the USB phy descriptions in the same Kconfig
are less easy to figure, such as "28nm SoC" or "Berlin SoCs").

I tend to also agree with Russell you that having an option to turn
on sane defaults for a given platform that's well maintained like
mvebu could save quite some time.

Willy
