Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F000B6374F
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 15:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbfGINxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 09:53:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35280 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726060AbfGINxA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 09:53:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rF3/udvcyshjB0LDHbNdiIWVvUGN8+ja30wB3HYmmOI=; b=QHrPvcm/DhS/WSrw1tKQvGNQWb
        4P1U/BC9wf6pUvoC3JiKZiQ/Bz2PcKNWsKGtWSptBzgYyhgBG6MR8EklVe6EMkq082vEskT8Aj+Ws
        lF5eGiBnZLGKeU1+8VIraTXQ3WyuVcPnctzMq/AhTcAv7511CQmai+vGv4KLtSPN1qqg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hkqYE-0000um-Md; Tue, 09 Jul 2019 15:52:58 +0200
Date:   Tue, 9 Jul 2019 15:52:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Benjamin Beckmeyer <beb@eks-engel.de>
Cc:     netdev@vger.kernel.org
Subject: Re: i.mx6ul with DSA in multi chip addressing mode - no MDIO access
Message-ID: <20190709135258.GC1965@lunn.ch>
References: <20190703155518.GE18473@lunn.ch>
 <d1181129-ec9d-01c1-3102-e1dc5dec0378@eks-engel.de>
 <20190704132756.GB13859@lunn.ch>
 <00b365da-9c7a-a78a-c10a-f031748e0af7@eks-engel.de>
 <20190704155347.GJ18473@lunn.ch>
 <ba64f1f9-14c7-2835-f6e7-0dd07039fb18@eks-engel.de>
 <20190705143647.GC4428@lunn.ch>
 <5e35a41c-be0e-efd4-cb69-cf5c860b872e@eks-engel.de>
 <20190708145733.GA9027@lunn.ch>
 <0d595637-0081-662d-2812-0a174ee1a901@eks-engel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d595637-0081-662d-2812-0a174ee1a901@eks-engel.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Andrew,
> good news first, it seems to be running ;-).

Great.

> 
> The interrupt GPIO pin was not correctly configured in the device tree.
> 
> For now we have around 68 accesses per second, I think this is okay 
> because we even have indirect access, so the bus must be more busy.

That sounds reasonable.

> Why we need access to the bus is because we have some software which was 
> using the DSDT driver and now we want to switch to the UMSD driver.
> But we hope that we can forget about all the UMSD driver stuff and the 
> DSDT driver stuff as well and just use the DSA part from the kernel.
> To be honest, so far I don't know what functions we need from the driver
> which aren't supported by the DSA.

You should take a close look at what you actually need. Using
DSDT/UMSD at the same time as mainline DSA does not sound like a good
idea. One can stomp over the other.

If you do decide to do this, you are going to need to add a new API to
allow DSDT/UMSD to get reliable access to the registers. You need to
take the chip->reg_lock to give you exclusive access to the
indirection registers. That also won't be accepted into mainline. We
don't want user space drivers...

      Andrew
