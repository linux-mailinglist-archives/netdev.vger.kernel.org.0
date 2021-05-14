Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE34C380BEA
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 16:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbhENOg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 10:36:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40406 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232602AbhENOg1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 10:36:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IV/HYlORdZOCxULJI/pTtQheQDugC76J0lIyqFBzpFo=; b=pvzo+R9ipZ7GocujYtaMAxlVpc
        bUoWJBsbyFwTjcYf4geD5MeYnW0wADB7ipv3qeHW8+Vm3Me8vxJv7SQYTY9ICjpo+yrB7svpmkb7Z
        NpTuWzHWSiiqYWGYU24Uh6kXtyM+KdWl/mwDUaPtDMNd10aHOl0Ut6Rln3c+MSFXvcIg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lhYuG-004CHB-CT; Fri, 14 May 2021 16:35:12 +0200
Date:   Fri, 14 May 2021 16:35:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Stefan Chulski <stefanc@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: mvpp2: incorrect max mtu?
Message-ID: <YJ6KoBEoEDb0VC7a@lunn.ch>
References: <20210514130018.GC12395@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210514130018.GC12395@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 02:00:18PM +0100, Russell King (Oracle) wrote:
> Hi all,
> 
> While testing out the 10G speeds on my Macchiatobin platforms, the first
> thing I notice is that they only manage about 1Gbps at a MTU of 1500.
> As expected, this increases when the MTU is increased - a MTU of 9000
> works, and gives a useful performance boost.
> 
> Then comes the obvious question - what is the maximum MTU.
> 
> #define MVPP2_BM_JUMBO_FRAME_SIZE       10432   /* frame size 9856 */
> 
> So, one may assume that 9856 is the maximum. However:
> 
> # ip li set dev eth0 mtu 9888
> # ip li set dev eth0 mtu 9889
> Error: mtu greater than device maximum.

Hi Russell

It all seems inconsistent:

https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c#L6879

	/* MTU range: 68 - 9704 */
	dev->min_mtu = ETH_MIN_MTU;
	/* 9704 == 9728 - 20 and rounding to 8 */
	dev->max_mtu = MVPP2_BM_JUMBO_PKT_SIZE;

Maybe this comment is correct, the code is now wrong, and the MAX MTU
should be 9704?

      Andrew
