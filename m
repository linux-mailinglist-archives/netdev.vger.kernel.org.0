Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 842925362EF
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 14:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351177AbiE0Mot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 08:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352854AbiE0Mom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 08:44:42 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F4B262D;
        Fri, 27 May 2022 05:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=J8SNi+xlam5i/ePvbss3MSpReBh6SlO6/VYkLPgUvLs=; b=vrHJjOSg/l8n8AEf3JITATvM4x
        EiaxIXe6mAKAYMK9FP3I+kwzsvRZr0tHFcwJOnE5BECnTPYgF05jo0HpsAmabrp9o0wfFhriMhxgw
        +0iG15UNwQ7wIw1U2wQ9p3Nb37ZJEYAUi0W8v9CxZ2nNXvuWr5Z3Uzu7egXn7Il/TeSU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nuZJ2-004S8z-9J; Fri, 27 May 2022 14:43:04 +0200
Date:   Fri, 27 May 2022 14:43:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tan Tee Min <tee.min.tan@linux.intel.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Dan Murphy <dmurphy@ti.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Voon Wei Feng <weifeng.voon@intel.com>,
        Sit Michael Wei Hong <michael.wei.hong.sit@intel.com>,
        Ling Pei Lee <pei.lee.ling@intel.com>,
        Looi Hong Aun <hong.aun.looi@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>
Subject: Re: [PATCH net-next v2 1/1] net: phy: dp83867: retrigger SGMII AN
 when link change
Message-ID: <YpDHWMe7aEVWtECd@lunn.ch>
References: <20220526090347.128742-1-tee.min.tan@linux.intel.com>
 <Yo9zTmMduwel8XeZ@lunn.ch>
 <20220527014709.GA26992@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220527014709.GA26992@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 27, 2022 at 09:47:09AM +0800, Tan Tee Min wrote:
> On Thu, May 26, 2022 at 02:32:14PM +0200, Andrew Lunn wrote:
> > On Thu, May 26, 2022 at 05:03:47PM +0800, Tan Tee Min wrote:
> > > This could cause an issue during power up, when PHY is up prior to MAC.
> > > At this condition, once MAC side SGMII is up, MAC side SGMII wouldn`t
> > > receive new in-band message from TI PHY with correct link status, speed
> > > and duplex info.
> > > 
> > > As suggested by TI, implemented a SW solution here to retrigger SGMII
> > > Auto-Neg whenever there is a link change.
> > 
> > Is there a bit in the PHY which reports host side link? There is no
> > point triggering an AN if there is already link.
> > 
> >       Andrew
> 
> Thanks for your comment.
> 
> There is no register bit in TI PHY which reports the SGMII AN link status.
> But, there is a bit that only reports the SGMII AN completion status.
> 
> In this case, the PHY side SGMII AN has been already completed prior to MAC is up.
> So, once MAC side SGMII is up, MAC side SGMII wouldn`t receive any new
> in-band message from TI PHY.

That does not make any sense for how i understand how this should
work.

Say the bootloader brings the MAC up, the SERDES gets sync and AN is
performed between the MAC and the PHY.

Linux takes over, downs the MAC and so the SERDES link is lost. The
PHY should notice this. Later Linux configures the MAC up, the SERDES
link should establish and AN should be performed.

Are you saying that the SERDES link is established, and stays
established, even when the MAC is down?

What is the structure of the host? Does it have a MAC block and a
SERDES block? It could be, the SERDES block is running independent of
the MAC block, and the link is established all the time, even when the
MAC is down. What you are missing is the MAC asking the SERDES block
for the results of the AN when the MAC comes up. So this is actually
an Ethernet driver bug, and you are working around it in the PHY
driver.

Are there registers in the MAC for the SERDES? Can you read the SERDES
link and AN state?

I have seen some MAC/SERDES combinations where you have to manually
move the AN results from the SERDES into the MAC. So could be, your
host will do it automatically is the MAC is up, but it won't do it if
the MAC is down when SERDES AN completes.

I just want to fully understand the issue, because if this is just a
workaround in the PHY, and you change the PHY, you are going to need
the same workaround in the next PHY driver.

    Andrew
