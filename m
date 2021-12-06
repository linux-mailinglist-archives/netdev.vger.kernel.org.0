Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2CF46AB51
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 23:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356438AbhLFWUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 17:20:38 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:41644 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236193AbhLFWUi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 17:20:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=3wUdirpLgfqEulF5xwd0x8sGfafbtoytr3bxGTPtAHY=; b=hehgn2zwJOwsSzsPADfIeuTlFH
        6zfNnG38hiAM03xEUi7S+aWK8zs/gHJDvwHQ9sLPhGYcW3A5F7dlZuo7vu1UXB3Dd2TRmIeDKRxcF
        0if3fAoLn/0HvL+1JKMCazfWquH3JjO3x1adhjeEnTRgnE7gtvMfmx8khPwy+lvXNZkg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1muMIE-00FiDp-Dy; Mon, 06 Dec 2021 23:17:06 +0100
Date:   Mon, 6 Dec 2021 23:17:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Martyn Welch <martyn.welch@collabora.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, kernel@collabora.com
Subject: Re: mv88e6240 configuration broken for B850v3
Message-ID: <Ya6L4khOROWo9t8E@lunn.ch>
References: <339f76b66c063d5d3bed5c6827c44307da2e5b9f.camel@collabora.com>
 <20211206185008.7ei67jborz7tx5va@skbuf>
 <3d6c6226e47374cf92d604bc6c711e59d76e3175.camel@collabora.com>
 <20211206193730.oubyveywniyvptfk@skbuf>
 <Ya5tkXU3AXalFRg2@shell.armlinux.org.uk>
 <20211206202308.xoutfymjozfyhhkl@skbuf>
 <Ya53vXp7Wz5YPf7Y@shell.armlinux.org.uk>
 <20211206211341.ppllxa7ve2jdyzt4@skbuf>
 <Ya6ARQBGl2C4Z3il@shell.armlinux.org.uk>
 <20211206215139.fv7xzqbnupk7pxfx@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206215139.fv7xzqbnupk7pxfx@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> static int mv88e6xxx_switch_reset(struct mv88e6xxx_chip *chip)
> {
> 	int err;
> 
> 	err = mv88e6xxx_disable_ports(chip);
> 	if (err)
> 		return err;
> 
> 	mv88e6xxx_hardware_reset(chip);
> 
> 	return mv88e6xxx_software_reset(chip);
> }
> 
> So unless I'm fooled by mentally putting an equality sign between
> mv88e6xxx_switch_reset() and getting rid of whatever a previous kernel
> may have done

A software reset resets the queue controllers and a few other
things. It does not touch the contents of most registers.

A hardware reset, using a GPIO to the reset pin, will reset all
registers. The switch will then read the optional PROM, and that could
set some registers. But hardware reset is not supported by most
boards.

    Andrew
