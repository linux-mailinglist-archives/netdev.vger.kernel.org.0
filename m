Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD14A16403D
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 10:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgBSJWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 04:22:45 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40034 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbgBSJWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 04:22:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=2gmw5/9ku0lPrufppHRIvdpYWfVdw6IxhC1tSWasJ1c=; b=Xbq/0U78QKnv0b62Wvl6lMzLm
        B/FLaDW5+HkPwJGMTeR+RQqvTXrXiwcGRqEcUOBwwC9Gqhab6eTJQ4dTkQiUalktx2cmVGb/bDJfO
        PZBI0yp1iJO7koKijqpP/99yCVPGt85jmtg2FMwAiMKXEwESSqwLqcd4p2Owwkot4RhEu9q3JrjQ4
        9OJZV+sDgz/BDEpBb6mj6ZbamX9PIGZrl3zvrgdRj/HvEaLH/NnjHiK61VYk3F8VXkCMQGNqsLOV8
        B6KqdA6v84lWOiGAFK/fVskw1dgeVvOcFxuFLKAxxbDyyH3lo4jnMmc+vw6vlpypIgidRTJHfrnZd
        5i6FqHoiw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:49888)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j4LYs-0004Sb-Pb; Wed, 19 Feb 2020 09:22:30 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j4LYp-0001KX-Cp; Wed, 19 Feb 2020 09:22:27 +0000
Date:   Wed, 19 Feb 2020 09:22:27 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Joel Johnson <mrjoel@lixil.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Baruch Siach <baruch@tkos.co.il>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Rob Herring <robh@kernel.org>, netdev@vger.kernel.org
Subject: Re: mvneta: comphy regression with SolidRun ClearFog
Message-ID: <20200219092227.GR25745@shell.armlinux.org.uk>
References: <af7602ae737cbc21ce7f01318105ae73@lixil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af7602ae737cbc21ce7f01318105ae73@lixil.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 10:14:48PM -0700, Joel Johnson wrote:
> In updating recently I'm encountering a regression with the mvneta driver on
> SolidRun ClearFog Base devices. I originally filed the bug with Debian
> (https://bugs.debian.org/951409) since I was using distro provided packages,
> but after further investigation I have isolated the issue as related to
> comphy support added during development for kernel version 5.1.
> 
> When booting stock kernels up to 5.0 everything works as expected with three
> ethernet devices identified and functional. However, running any kernel 5.1
> or later, I only have a single ethernet device available. The single device
> available appears to be the one attached to the SoC itself and not connected
> via SerDes lanes using comphy, i.e. the one defined at f1070000.ethernet.
> 
> With some log/diff assisted bisecting, I've been able to confirm that the
> "tipping point" changeset is f548ced15f90, which actually performs the DT
> change for the ClearFog family of devices. That's the commit at which the
> failure starts, but is just the final enablement of the added feature in the
> overall series. I've also tested booting the same kernel binary (including
> up to v5.6-rc1) and only swapping the dtb for one excluding the problematic
> commit and confirmed that simply changing the dtb results in all three
> devices being functional, albeit obviously without comphy support.

Does debian have support for the comphy enabled in their kernel,
which is controlled by CONFIG_PHY_MVEBU_A38X_COMPHY ?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
