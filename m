Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7AB313D0A0
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 00:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730523AbgAOXTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 18:19:39 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40196 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726513AbgAOXTj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 18:19:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=om+XDgmT/HasblOlQJMaFnMBZQDtEHgJob8myvB/iL4=; b=RdYPEzcOaAhRIB+TK9A2lOQjmk
        6oUBaDFE9kzDiGMQgI/o9m4ZA65U07klDMnyT7c9zckloskpb/daMsn606OTV1wYspOWBo7NY9tx9
        ZdqXIgWG+ZTVlRupOwQ3myITTPT7l252lStk0Krk/hD33mpxlZ87Lv9eRuU6MSBVoEmI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1irrwa-0002Qm-Ig; Thu, 16 Jan 2020 00:19:24 +0100
Date:   Thu, 16 Jan 2020 00:19:24 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, cphealy@gmail.com,
        rmk+kernel@armlinux.org.uk, Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2] net: phy: Maintain MDIO device and bus
 statistics
Message-ID: <20200115231924.GF2475@lunn.ch>
References: <20200115204228.26094-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200115204228.26094-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 12:42:20PM -0800, Florian Fainelli wrote:
> We maintain global statistics for an entire MDIO bus, as well as broken
> down, per MDIO bus address statistics. Given that it is possible for
> MDIO devices such as switches to access MDIO bus addressies for which
> there is not a mdio_device instance created (therefore not a a
> corresponding device directory in sysfs either), we also maintain
> per-address statistics under the statistics folder. The layout looks
> like this:
> 
> /sys/class/mdio_bus/../statistics/
> 	transfers
> 	errrors
> 	writes
> 	reads
> 	transfers_<addr>
> 	errors_<addr>
> 	writes_<addr>
> 	reads_<addr>
> 
> When a mdio_device instance is registered, a statistics/ folder is
> created with the tranfers, errors, writes and reads attributes which
> point to the appropriate MDIO bus statistics structure.
> 
> Statistics are 64-bit unsigned quantities and maintained through the
> u64_stats_sync.h helper functions.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> Changes in v2:
> 
> - tracked per MDIO address statististics in separate attributes

Hi Florian

This is much better. Here is an MDIO bus with a Marvel MV88E6390

andrew@zii-devel-c-bidi:/sys/class/mdio_bus/0.1/statistics$ awk ' { print FILENAME " " $0  } ' transfers_? transfers_?? transfers
transfers_0 93
transfers_1 80
transfers_2 80
transfers_3 80
transfers_4 102
transfers_5 18
transfers_6 7
transfers_7 7
transfers_8 7
transfers_9 7
transfers_10 82
transfers_11 0
transfers_12 0
transfers_13 0
transfers_14 0
transfers_15 0
transfers_16 0
transfers_17 0
transfers_18 0
transfers_19 0
transfers_20 0
transfers_21 0
transfers_22 0
transfers_23 0
transfers_24 0
transfers_25 0
transfers_26 0
transfers_27 288
transfers_28 3328
transfers_29 0
transfers_30 0
transfers_31 0
transfers 4179

As you can see, there are transfers on a number of addresses.

I've not looked at the code yet, but i can give:

Tested-by: Andrew Lunn <andrew@lunn.ch>

I will review the code soon.

    Andrew
