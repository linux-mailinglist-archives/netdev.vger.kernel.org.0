Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA87380EC0
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 19:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbhENRWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 13:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231654AbhENRWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 13:22:52 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B7BC061574
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 10:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=hf/FgC7qO5NbYar+qO/nUlU5H+LrckSNa8N1UCGQhSw=; b=smde3aGBjk8S4M8aK5+hXc+qd
        aSvKz8JMsD+Rmjdrbn52zoLTtlyX4tCi5J5C5K/kVAQkbd1xZrDp3WF15kir1oFRZi7uNXCjgIZGl
        ky7hthgslSswO6SoxdM7bD8kk5pbJrAOHJnj447uWUXCxF5nuZvZL3kdndR43N9P8OrOWaZzJfv61
        2ABGPgou9zFSiGUh/am10grrYa1sszTa8aYkVVLfLmyyBNzh6iOArdT1DopmHIPus239AEF6jNIjY
        jwkNYj7jOwOih9RGm8J9b4+38ocbcO04nNdmGncyebMs56ljaJbIawB2iMknWyQWwh5aMrGOmFe4U
        oESCBs3NQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43978)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lhbVK-0008VU-T6; Fri, 14 May 2021 18:21:38 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lhbVK-0004Aq-60; Fri, 14 May 2021 18:21:38 +0100
Date:   Fri, 14 May 2021 18:21:38 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Stefan Chulski <stefanc@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: mvpp2: incorrect max mtu?
Message-ID: <20210514172138.GG12395@shell.armlinux.org.uk>
References: <20210514130018.GC12395@shell.armlinux.org.uk>
 <YJ6KoBEoEDb0VC7a@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJ6KoBEoEDb0VC7a@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 04:35:12PM +0200, Andrew Lunn wrote:
> On Fri, May 14, 2021 at 02:00:18PM +0100, Russell King (Oracle) wrote:
> > Hi all,
> > 
> > While testing out the 10G speeds on my Macchiatobin platforms, the first
> > thing I notice is that they only manage about 1Gbps at a MTU of 1500.
> > As expected, this increases when the MTU is increased - a MTU of 9000
> > works, and gives a useful performance boost.
> > 
> > Then comes the obvious question - what is the maximum MTU.
> > 
> > #define MVPP2_BM_JUMBO_FRAME_SIZE       10432   /* frame size 9856 */
> > 
> > So, one may assume that 9856 is the maximum. However:
> > 
> > # ip li set dev eth0 mtu 9888
> > # ip li set dev eth0 mtu 9889
> > Error: mtu greater than device maximum.
> 
> Hi Russell
> 
> It all seems inconsistent:
> 
> https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c#L6879
> 
> 	/* MTU range: 68 - 9704 */
> 	dev->min_mtu = ETH_MIN_MTU;
> 	/* 9704 == 9728 - 20 and rounding to 8 */
> 	dev->max_mtu = MVPP2_BM_JUMBO_PKT_SIZE;
> 
> Maybe this comment is correct, the code is now wrong, and the MAX MTU
> should be 9704?

Oh, there's more values given elsewhere that disagree, see my reply to
Marcin. I would not be surprised if this was all "confused" about
what the proper value is. Certainly the comment you mention above
disagrees with what is in mvpp2.h

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
