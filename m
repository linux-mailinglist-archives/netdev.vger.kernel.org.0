Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E95583E99D5
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 22:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbhHKUnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 16:43:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45824 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229589AbhHKUnQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 16:43:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=q+n1yuI6tfHCAtC83moR8iy5qcFue+mNzqMAa4eLOO4=; b=p2s2OPpdR3nzogimrqvYqeOJjy
        svfPjKzrgQ5GBlooxUuYjaPX5lojbpYMQn9rrVaKw8ki2SEej5msMMeZykpLHO8jxE84CVhfLM1SN
        PrVvwk4NHyY7lM8KrTKRVmYw+u5n7qQqz745TjXawKveq/PSohk1R2ggNKern+rYGn2Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mDv3k-00HBN2-Qb; Wed, 11 Aug 2021 22:42:44 +0200
Date:   Wed, 11 Aug 2021 22:42:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        netdev@vger.kernel.org, davem@davemloft.net, mkubecek@suse.cz,
        pali@kernel.org, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 1/8] ethtool: Add ability to control
 transceiver modules' low power mode
Message-ID: <YRQ2RBfOGQKiDOlt@lunn.ch>
References: <YRE7kNndxlGQr+Hw@lunn.ch>
 <YRIqOZrrjS0HOppg@shredder>
 <YRKElHYChti9EeHo@lunn.ch>
 <20210810065954.68036568@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YRLlpCutXmthqtOg@shredder>
 <20210810150544.3fec5086@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YRO1ck4HYWTH+74S@shredder>
 <20210811060343.014724e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YRPgXWKZ2e88J1sn@lunn.ch>
 <YRQnEWeQSE22woIr@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRQnEWeQSE22woIr@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> For the policy we can have these values:
> 
> 1. low: Always transition the module to low power mode
> 2. high: Always transition the module to high power mode
> 3. high-on-up: Transition the module to high power mode when a port
> using it is administratively up. Otherwise, low
> 
> A different policy for up/down seems like an overkill for me.

O.K. The current kernel SFP driver is going to default to high-on-up,
which is what kernel driven copper PHYs also do.

> After a module was connected:
> 
> $ ethtool --show-module swp11
> Module parameters for swp11:
> power-mode-policy high-on-up
> power-mode low
> 
> # ip link set dev swp11 up
> 
> $ ethtool --show-module swp11
> Module parameters for swp11:
> power-mode-policy high-on-up
> low-power high
> 
> # ip link set dev swp11 down

You missed a show here. I expect it to be:

> $ ethtool --show-module swp11
> Module parameters for swp11:
> power-mode-policy high-on-up
> power-mode low

since it is now down.

I suppose we should consider the bigger picture. Is this feature
limited to just SFP modules, or does it make sense to any other sort
of network technology? CAN, bluetooth, 5G, IPoAC?

   Andrew
