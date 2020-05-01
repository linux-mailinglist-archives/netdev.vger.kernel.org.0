Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4551C20E6
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 00:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgEAWtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 18:49:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37110 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbgEAWtl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 18:49:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=erqGzmSSH5y0r3VB9jCpr4m0raRhuyy0tc14D0hD6ms=; b=UvmrAUNL5bxjdMqf3T+FIL1U1m
        cdbfMZWa/RKAUs41S/U4KTlKv96o6cIUkj0GiLURrTDBKbi6K/OJi/YOu0FVWczES/vHiHMWIm7S2
        5gJaaD7oQtfsxImM7iAzz+DGUY9COJjZOxfa/09TUq0iUFAojY9j5HwDbxwu9gsp+X28=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jUeTR-000aVU-VP; Sat, 02 May 2020 00:49:37 +0200
Date:   Sat, 2 May 2020 00:49:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, fugang.duan@nxp.com, cphealy@gmail.com
Subject: Re: [PATCH net-next v2] net: ethernet: fec: Prevent MII event after
 MII_SPEED write
Message-ID: <20200501224937.GB136749@lunn.ch>
References: <20200429205323.76908-1-andrew@lunn.ch>
 <20200501.152954.1266270078854134704.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501.152954.1266270078854134704.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 01, 2020 at 03:29:54PM -0700, David Miller wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> Date: Wed, 29 Apr 2020 22:53:23 +0200
> 
> > The change to polled IO for MDIO completion assumes that MII events
> > are only generated for MDIO transactions. However on some SoCs writing
> > to the MII_SPEED register can also trigger an MII event. As a result,
> > the next MDIO read has a pending MII event, and immediately reads the
> > data registers before it contains useful data. When the read does
> > complete, another MII event is posted, which results in the next read
> > also going wrong, and the cycle continues.
> > 
> > By writing 0 to the MII_DATA register before writing to the speed
> > register, this MII event for the MII_SPEED is suppressed, and polled
> > IO works as expected.
> > 
> > v2 - Only infec_enet_mii_init()
> > 
> > Fixes: 29ae6bd1b0d8 ("net: ethernet: fec: Replace interrupt driven MDIO with polled IO")
> > Reported-by: Andy Duan <fugang.duan@nxp.com>
> > Suggested-by: Andy Duan <fugang.duan@nxp.com>
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> 
> Hmmm, I reverted the Fixes: tag patch so you'll need to respin this I think.

Ah.

We wanted the fix reverting, but not that the fix was fixing. Sorry,
we were unclear.

   Andrew
