Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 067426EAB3C
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 15:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbjDUNH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 09:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232026AbjDUNHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 09:07:24 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA299EC8
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 06:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=yj+4YY3kPwO6XWHUcXcY3tUff4DfYgeV/Is1m2uuu0I=; b=Yi7p0u6bpOTZnGxkmRqG6Dgkh6
        tOvlit+c2y8Xahoj1yNg0Tqfxx+BbU6kAVyRBRC1xluk3Y0CcV9WzfZyXMCod4Ck1HEjlB2yIJqA4
        8JnTGjT2aSpxVK/aMlJwq6K8e3MzDNi/REVt/mqrIm4OkAepPGp1XB+J/8qWJ6J3z3FA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ppq2u-00Asoh-J9; Fri, 21 Apr 2023 14:39:24 +0200
Date:   Fri, 21 Apr 2023 14:39:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Parthiban.Veerasooran@microchip.com
Cc:     ramon.nordin.rodriguez@ferroamp.se, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        olteanv@gmail.com, Jan.Huber@microchip.com
Subject: Re: [PATCH v4] drivers/net/phy: add driver for Microchip LAN867x
 10BASE-T1S PHY
Message-ID: <13cd631b-d368-44c0-a977-55c8a05e396d@lunn.ch>
References: <ZEFqFg9RO+Vsj8Kv@debian>
 <ec8edb01-1cbf-22f4-469c-78d1d60f2a9e@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec8edb01-1cbf-22f4-469c-78d1d60f2a9e@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Do you think it makes sense to probe the driver based on the Revision 
> number as well? because we have two more revisions in the pipeline and 
> each revision has different settings for the initial configuration. If 
> you agree with this, as per the current datasheet this PHY revision is 2 
> means Rev.B1. If you like, I would suggest to use the PHY_ID define as 
> below,

Do the current settings not work at all on future silicon? The words
'optimal performance' have been used when describing what this magic
does. Which suggest it should work, but not optimally?

Unless this is going to cause the magic smoke to escape, i say leave
it as it is until you add explicit support for those revisions.

> > +       /* None of the interrupts in the lan867x phy seem relevant.
> > +        * Other phys inspect the link status and call phy_trigger_machine
> > +        * in the interrupt handler.
> > +        * This phy does not support link status, and thus has no interrupt
> > +        * for it either.
> > +        * So we'll just disable all interrupts on the chip.
> > +        */
> I could see the below in the datasheet section 4.7.
> 
> When the device is in a reset state, the IRQ_N interrupt pin is 
> high-impedance and will be pulled high through an
> external pull-up resistor. Once all device reset sources are deasserted, 
> the device will begin its internal initialization.
> The device will assert the Reset Complete (RESETC) bit in the Status 2 
> (STS2) register to indicate that it has
> completed its internal initialization and is ready for configuration. As 
> the Reset Complete status is non-maskable, the
> IRQ_N pin will always be asserted and driven low following a device reset
> 
> Do you think it makes sense to clear/acknowledge the "reset_done" 
> interrupt by reading the Status 2 register in the interrupt routine?

When interrupt support is added, you should do this. It is normal to
clear all pending interrupt before enabling interrupts, since you
don't want to handle stale interrupts.

The only potential issue here is when somebody has a board which mixes
multiple different PHYs using a shared interrupt. This PHY is going to
block all other PHYs, which maybe do have working interrupt
support. But there is no regression here, it has never worked. So it
is not something which the first version of the driver needs to
handle.

	Andrew
