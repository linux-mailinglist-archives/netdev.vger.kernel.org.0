Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 586C43AE9C5
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 15:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbhFUNLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 09:11:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47570 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229651AbhFUNLX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 09:11:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=htXr5+GTGyZJxaugUXnZ7e7qviUalTTBhF0Oq+fysqM=; b=Zvslj/ZMkVwvvFB19uFwtxtMfg
        j0OFcxF9euXqDrFnWNpF3XQMa3P8cliizUOAPYr0OPW9R+A4hoM1s/Npa6wSf5N02ihrs+fpC9Agr
        Bnk6J1q5cE35jzkXlz4pX7l6PRTpD5DPiMCv5BwPr9E4i7TPHGpiOXZKPNhVXgR38npQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lvJfm-00AVQD-FV; Mon, 21 Jun 2021 15:09:06 +0200
Date:   Mon, 21 Jun 2021 15:09:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jian-Hong Pan <jhp@endlessos.org>
Cc:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessos.org,
        linux-rpi-kernel@lists.infradead.org
Subject: Re: [PATCH] net: bcmgenet: Fix attaching to PYH failed on RPi 4B
Message-ID: <YNCPcmEPuwdwoLto@lunn.ch>
References: <20210621103310.186334-1-jhp@endlessos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621103310.186334-1-jhp@endlessos.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 21, 2021 at 06:33:11PM +0800, Jian-Hong Pan wrote:
> The Broadcom UniMAC MDIO bus comes too late. So, GENET cannot find the
> ethernet PHY on UniMAC MDIO bus. This leads GENET fail to attach the
> PHY.
> 
> bcmgenet fd580000.ethernet: GENET 5.0 EPHY: 0x0000
> ...
> could not attach to PHY
> bcmgenet fd580000.ethernet eth0: failed to connect to PHY
> uart-pl011 fe201000.serial: no DMA platform data
> libphy: bcmgenet MII bus: probed
> ...
> unimac-mdio unimac-mdio.-19: Broadcom UniMAC MDIO bus
> 
> This patch makes GENET try to connect the PHY up to 3 times. Also, waits
> a while between each time for mdio-bcm-unimac module's loading and
> probing.

Don't loop. Return -EPROBE_DEFER. The driver core will then probed the
driver again later, by which time, the MDIO bus driver should of
probed.

	Andrew
