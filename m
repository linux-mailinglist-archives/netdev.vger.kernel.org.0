Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D52DF1BECF
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 22:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbfEMUqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 16:46:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34553 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbfEMUqs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 16:46:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=LmG3VyQFYbomc90EWhcecuXnWE/KSSmRCpsKK5FHc+Q=; b=rvcXWX2eNs1YZa0gIJ4x6kMZXd
        YOVG0hUDkWYk47L7WzASkJT6YRU3StDaTdFRtyYO+ROv0Egj7dJS6VG4+rCvgg7OHc3ejBiBfxRvg
        Vf+XbOv2bt1t3G4q1JGD3JE2zy6ISqWW/tSXKQAr6xMpcgXDlDuG9LO/+vanSscvxbvo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hQHqL-00040D-UU; Mon, 13 May 2019 22:46:41 +0200
Date:   Mon, 13 May 2019 22:46:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Trent Piepho <tpiepho@impinj.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 5/5] net: phy: dp83867: Use unsigned variables to store
 unsigned properties
Message-ID: <20190513204641.GA12345@lunn.ch>
References: <20190510214550.18657-1-tpiepho@impinj.com>
 <20190510214550.18657-5-tpiepho@impinj.com>
 <49c6afc4-6c5b-51c9-74ab-9a6e8c2460a5@gmail.com>
 <3a42c0cc-4a4b-e168-c03e-1cc13bd2f5d4@gmail.com>
 <1557777496.4229.13.camel@impinj.com>
 <b246b18d-5523-7b8b-9cd0-b8ccb8a511e9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b246b18d-5523-7b8b-9cd0-b8ccb8a511e9@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Perhaps you could tell me if the approach I've taken in patch 3, 
> > "Add ability to disable output clock", and patch 4, "Disable tx/rx
> > delay when not configured", are considered acceptable?  I can conceive
> > of arguments for alternate approaches.  I would like to add support for
> >  these into u-boot too, but typically u-boot follows the kernel DT
> > bindings, so I want to finalize the kernel DT semantics before sending
> > patches to u-boot.
> > 
> I lack experience with these TI PHY's. Maybe Andrew or Florian can advise.

Hi Trent

I already deleted the patches. For patch 3:

+ 	  if (dp83867->clk_output_sel > DP83867_CLK_O_SEL_REF_CLK &&
+	         dp83867->clk_output_sel != DP83867_CLK_O_SEL_OFF) {
+		 	phydev_err(phydev, "ti,clk-output-sel value %u out of range\n",
+				   dp83867->clk_output_sel);
+			return -EINVAL;
+													       }

This last bit looks odd. If it is not OFF, it is invalid?

Are there any in tree users of DP83867_CLK_O_SEL_REF_CLK? We have to
be careful changing its meaning. But if nobody is actually using it...

Patch 4:

This is harder. Ideally we want to fix this. At some point, somebody
is going to want 'rgmii' to actually mean 'rgmii', because that is
what their hardware needs.

Could you add a WARN_ON() for 'rgmii' but the PHY is actually adding a
delay? And add a comment about setting the correct thing in device
tree?  Hopefully we will then get patches correcting DT blobs. And if
we later do need to fix 'rgmii', we will break less board.

> >>> Please note that net-next is closed currently. Please resubmit the
> >>> patches once it's open again, and please annotate them properly
> >>> with net-next.
> > 
> > Sorry, didn't know about this policy.  Been years since I've submitted
> > net patches.  Is there a description somewhere of how this is done? 
> > Googling net-next wasn't helpful.  I gather new patches are only
> > allowed when the kernel merge window is open?  And they can't be queued
> > on patchwork or a topic branch until this happens?

You can post patches while it is closed for review, but add "RFC" in
the subject so it is clear you just want comments. You will still need
to resubmit once it opens up again.

    Andrew
