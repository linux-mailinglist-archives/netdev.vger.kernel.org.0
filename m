Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB972993C
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 15:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403861AbfEXNsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 09:48:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55954 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403809AbfEXNsz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 09:48:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bdm8kgXmeh9EF5AOQiQM32qgv2w2u6Wxm0nFHm8Ro9c=; b=U5RHUHJv8X8iYT4p4utPOVNhvL
        lhdLXlGiQCfmCjjAY9dxWArxBVjjfujLqrStsr2yedxxLcj0jFAKfgD/X0tcLHU9IlaB6RDGwtK0D
        /bOWGRlOcgkkCMSayMDzT+wRgijnK+orwZQPUdmiYtOCG4LGlawmCc12+rvVFR1B1a44=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hUAYx-00019j-Ak; Fri, 24 May 2019 15:48:47 +0200
Date:   Fri, 24 May 2019 15:48:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yash Shah <yash.shah@sifive.com>
Cc:     mark.rutland@arm.com, devicetree@vger.kernel.org,
        aou@eecs.berkeley.edu, netdev@vger.kernel.org,
        Palmer Dabbelt <palmer@sifive.com>,
        linux-kernel@vger.kernel.org, nicolas.ferre@microchip.com,
        Sachin Ghadi <sachin.ghadi@sifive.com>, robh+dt@kernel.org,
        Paul Walmsley <paul.walmsley@sifive.com>, ynezz@true.cz,
        linux-riscv@lists.infradead.org, davem@davemloft.net
Subject: Re: [PATCH 2/2] net: macb: Add support for SiFive FU540-C000
Message-ID: <20190524134847.GF2979@lunn.ch>
References: <1558611952-13295-1-git-send-email-yash.shah@sifive.com>
 <1558611952-13295-3-git-send-email-yash.shah@sifive.com>
 <20190523145417.GD19369@lunn.ch>
 <CAJ2_jOE0-zK1csRNeiAmag9kEbvOGhbvRa-5ESYif7e15gpRcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ2_jOE0-zK1csRNeiAmag9kEbvOGhbvRa-5ESYif7e15gpRcQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 24, 2019 at 10:22:06AM +0530, Yash Shah wrote:
> On Thu, May 23, 2019 at 8:24 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > +static int fu540_macb_tx_set_rate(struct clk_hw *hw, unsigned long rate,
> > > +                               unsigned long parent_rate)
> > > +{
> > > +     rate = fu540_macb_tx_round_rate(hw, rate, &parent_rate);
> > > +     iowrite32(rate != 125000000, mgmt->reg);
> >
> > That looks odd. Writing the result of a comparison to a register?
> 
> The idea was to write "1" to the register if the value of rate is
> anything else than 125000000.

I'm not a language lawyer. Is it guaranteed that an expression like
this returns 1? Any value !0 is true, so maybe it actually returns 42?

> To make it easier to read, I will change this to below:
>     - iowrite32(rate != 125000000, mgmt->reg);
>     + if (rate != 125000000)
>     +     iowrite32(1, mgmt->reg);
>     + else
>     +     iowrite32(0, mgmt->reg);
> 
> Hope that's fine. Thanks for your comment

Yes, that is good.

     Andrew
