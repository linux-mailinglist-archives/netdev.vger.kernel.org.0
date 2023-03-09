Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 679606B28FF
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 16:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbjCIPmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 10:42:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbjCIPml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 10:42:41 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8408EE4844;
        Thu,  9 Mar 2023 07:42:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ZrYdnnxQvAR075n/vU2WB9yR1HL51Vpla6jbEfZU5kA=; b=uU0hBX1lqEvsZ9g4NkbZHpqw7E
        6Gl9UjnjslY4z0K5HbqhMHvH3yQYcSusAJGv6jpN0IZHlzlKCKJbge8o1OC2fX020Zd24eErrH1jP
        bkyYAT8p5sO3l6u0RlxU88KXf3XrrH3gq0zyh8Mqejc2Jg7m/868x1A4xQYGV241V8KY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1paIPT-006tH2-6B; Thu, 09 Mar 2023 16:42:27 +0100
Date:   Thu, 9 Mar 2023 16:42:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] dsa: marvell: Correct value of max_frame_size
 variable after validation
Message-ID: <0959097a-35cb-48c1-8e88-5e6c1269852d@lunn.ch>
References: <20230309125421.3900962-1-lukma@denx.de>
 <20230309125421.3900962-7-lukma@denx.de>
 <ZAnnk5MZc0w4VkDE@shell.armlinux.org.uk>
 <20230309154350.0bdc54c8@wsk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309154350.0bdc54c8@wsk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > If I understand this correctly, in patch 4, you add a call to the 6250
> > family to call mv88e6185_g1_set_max_frame_size(), which sets a bit
> > called MV88E6185_G1_CTL1_MAX_FRAME_1632 if the frame size is larger
> > than 1518.
> 
> Yes, correct.
> 
> > 
> > However, you're saying that 6250 has a frame size of 2048. That's
> > fine, but it makes MV88E6185_G1_CTL1_MAX_FRAME_1632 rather misleading
> > as a definition. While the bit may increase the frame size, I think
> > if we're going to do this, then this definition ought to be renamed.
> > 
> 
> I thought about rename, but then I've double checked; register offset
> and exact bit definition is the same as for 6185, so to avoid
> unnecessary code duplication - I've reused the existing function.
> 
> Maybe comment would be just enough?

The driver takes care with its namespace in order to add per switch
family defines. So you can add MV88E6250_G1_CTL1_MAX_FRAME_2048. It
does not matter if it is the same bit. You can also add a
mv88e6250_g1_set_max_frame_size() and it also does not matter if it is
in effect the same as mv88e6185_g1_set_max_frame_size().

We should always make the driver understandably first, compact and
without redundancy second. We are then less likely to get into
situations like this again where it is not clear what MTU a device
actually supports because the code is cryptic.

	 Andrew
