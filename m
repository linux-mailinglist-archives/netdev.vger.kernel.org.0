Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37E55165B43
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 11:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbgBTKMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 05:12:49 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:57708 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726813AbgBTKMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 05:12:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=OG5r+Z1kVqBBTnKoPze/0wPANbtqdHz4rPgy9yzKFus=; b=y7QW6563fx/d3noU+gussdYGY
        tQUEWGhyIJVR6uHTsmlBXi9BV602SixpJshd+SEKqpCkYMaSA5YTOOwg7XmoEMzPPb9eAot825Sya
        C8RfDoxkij9JlYjMmUEDsJN4Cp13IzGv+db/cUt2o2tMbNiwv05gyVjkf6B04ulYkSKzfjdKJIIGi
        TR0ijcKCEVbCym9F1GbU8kNu4aRHjL6NApADrIh16axB5I34H+JbZGn5MDJtPE4QMRJFgMMzZRUpu
        lwYg9iQ+G3hO8mAxqFZT9hIBQJVPnHK06wg7o3E378m2ht3H31UfGtQsGo6qoBw3hUcdq+rFqSJx5
        YhtQiRd/w==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:50338)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j4iou-0002bS-4e; Thu, 20 Feb 2020 10:12:36 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j4ioq-0002Ky-8j; Thu, 20 Feb 2020 10:12:32 +0000
Date:   Thu, 20 Feb 2020 10:12:32 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Joel Johnson <mrjoel@lixil.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Baruch Siach <baruch@tkos.co.il>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Rob Herring <robh@kernel.org>, netdev@vger.kernel.org
Subject: Re: mvneta: comphy regression with SolidRun ClearFog
Message-ID: <20200220101232.GU25745@shell.armlinux.org.uk>
References: <af7602ae737cbc21ce7f01318105ae73@lixil.net>
 <20200219092227.GR25745@shell.armlinux.org.uk>
 <8099d231594f1785e7149e4c6c604a5c@lixil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8099d231594f1785e7149e4c6c604a5c@lixil.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 06:49:51AM -0700, Joel Johnson wrote:
> On 2020-02-19 02:22, Russell King - ARM Linux admin wrote:
> > On Tue, Feb 18, 2020 at 10:14:48PM -0700, Joel Johnson wrote:
> > > In updating recently I'm encountering a regression with the mvneta
> > > driver on
> > > SolidRun ClearFog Base devices. I originally filed the bug with Debian
> > > (https://bugs.debian.org/951409) since I was using distro provided
> > > packages,
> > > but after further investigation I have isolated the issue as related
> > > to
> > > comphy support added during development for kernel version 5.1.
> > > 
> > > When booting stock kernels up to 5.0 everything works as expected
> > > with three
> > > ethernet devices identified and functional. However, running any
> > > kernel 5.1
> > > or later, I only have a single ethernet device available. The single
> > > device
> > > available appears to be the one attached to the SoC itself and not
> > > connected
> > > via SerDes lanes using comphy, i.e. the one defined at
> > > f1070000.ethernet.
> > > 
> > > With some log/diff assisted bisecting, I've been able to confirm
> > > that the
> > > "tipping point" changeset is f548ced15f90, which actually performs
> > > the DT
> > > change for the ClearFog family of devices. That's the commit at
> > > which the
> > > failure starts, but is just the final enablement of the added
> > > feature in the
> > > overall series. I've also tested booting the same kernel binary
> > > (including
> > > up to v5.6-rc1) and only swapping the dtb for one excluding the
> > > problematic
> > > commit and confirmed that simply changing the dtb results in all three
> > > devices being functional, albeit obviously without comphy support.
> > 
> > Does debian have support for the comphy enabled in their kernel,
> > which is controlled by CONFIG_PHY_MVEBU_A38X_COMPHY ?
> 
> Well, doh! I stared at the patch series for way to long, but the added
> Kconfig symbol failed to register mentally somehow. I had been using the
> last known good Debian config with make olddefconfig, but it obviously
> wasn't included in earlier configs and not enabled by default.
> 
> I tested a build with v5.6-rc1 and actually enabled the platform driver and
> it worked as expected, including log output of "configuring for sgmii link
> mode". Back to moving forward on other testing. Sorry for the noise, I'll
> update the Debian bug with a patch to enable the config symbol for armmp
> kernels.
> 
> Many thanks to you and Willy Tarreau for pointing out my glaring omission!

Thanks for letting us know that you've fixed it now.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
