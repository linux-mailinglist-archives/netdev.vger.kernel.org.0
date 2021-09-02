Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5A33FF4A1
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 22:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345191AbhIBUIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 16:08:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54068 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231983AbhIBUIy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 16:08:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Gt3zeHnWw3U8+QneEn3jIF6T3ece/2vIGoTVWj+Z/e4=; b=detHc482lludQ9s41A/nqX3VNt
        zu61vALLwts07jdQEu+29nehJFjAxlY6p5QubVguBLFc0zWASHzQAMvW3+CacL599NBR2cLDyzSfw
        SGFTo4uzg6k2HuRynKf0zt5J7qI5ivqFxe2wBQ+J7dv86dB4Rq6aISKc4qScFDY7dD3U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mLt01-0052vS-9S; Thu, 02 Sep 2021 22:07:49 +0200
Date:   Thu, 2 Sep 2021 22:07:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH net-next 0/3] Make the PHY library stop being so
 greedy when binding the generic PHY driver
Message-ID: <YTEvFR2WGQmG3h/C@lunn.ch>
References: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
 <20210902121927.GE22278@shell.armlinux.org.uk>
 <20210902123532.ruvuecxoig67yv5v@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210902123532.ruvuecxoig67yv5v@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The interrupt controller _has_ been set up. The trouble is that the
> interrupt controller has the same OF node as the switch itself, and the
> same OF node. Therefore, fw_devlink waits for the _entire_ switch to
> finish probing, it doesn't have insight into the fact that the
> dependency is just on the interrupt controller.

That seems to be the problem. fw_devlink appears to think probe is an
atomic operation. A device is not probed, or full probed. Where as the
drivers are making use of it being non atomic.

Maybe fw_devlink needs the third state, probing. And when deciding if
a device can be probed and depends on a device which is currently
probing, it looks deeper, follows the phandle and see if the resource
is actually available?

	 Andrew

