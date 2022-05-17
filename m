Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 771B4529A69
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 09:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236942AbiEQHG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 03:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237414AbiEQHG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 03:06:26 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199464705F;
        Tue, 17 May 2022 00:06:21 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 8621F1BF208;
        Tue, 17 May 2022 07:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652771180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2rLEx70yzvrqG4/Ise9vI9V8nSXM1Frwmx1mdqkERhE=;
        b=duFvGAKbqh8rXUz9MaAsmD2XkaLfk9AQ5INJEpHN1wo+gAxBYSo/EC6zn530l08SZtSwOI
        YQK8mHSettKoXun/6Gr/EpxQSmED83Nr5AtL5ORYQSu3uvaAiWfnaM5mLTMClfyGN7igYy
        6HLGet6HPuZHsaHJRqzr3JPDhTS6aQNHRyzLHOPXyp3bakoaJ98u2fhf0X5Cfsad7aTvHj
        BCQmYd+Nfto7XLYfLTvN0dIq0jJA8RRbzwwXaxshZbBPxAUy9Pkdo1mUx2B4OY3YWs9tZO
        lV/eDq148g6Le/C9p5D8EjicLAP9GIbcv9qatxYrpQedwxmlmmberSFBF0uGTg==
Date:   Tue, 17 May 2022 09:06:15 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v2 2/5] net: dsa: add out-of-band tagging
 protocol
Message-ID: <20220517090615.34b82d28@pc-20.home>
In-Reply-To: <89c52305-71da-843e-b6c5-77648fb2f4d3@gmail.com>
References: <20220514150656.122108-1-maxime.chevallier@bootlin.com>
        <20220514150656.122108-3-maxime.chevallier@bootlin.com>
        <89c52305-71da-843e-b6c5-77648fb2f4d3@gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Sat, 14 May 2022 09:33:44 -0700
Florian Fainelli <f.fainelli@gmail.com> wrote:

> Hi Maxime,
> 
> On 5/14/2022 8:06 AM, Maxime Chevallier wrote:
> > This tagging protocol is designed for the situation where the link
> > between the MAC and the Switch is designed such that the Destination
> > Port, which is usually embedded in some part of the Ethernet
> > Header, is sent out-of-band, and isn't present at all in the
> > Ethernet frame.
> > 
> > This can happen when the MAC and Switch are tightly integrated on an
> > SoC, as is the case with the Qualcomm IPQ4019 for example, where
> > the DSA tag is inserted directly into the DMA descriptors. In that
> > case, the MAC driver is responsible for sending the tag to the
> > switch using the out-of-band medium. To do so, the MAC driver needs
> > to have the information of the destination port for that skb.
> > 
> > This out-of-band tagging protocol is using the very beggining of
> > the skb headroom to store the tag. The drawback of this approch is
> > that the headroom isn't initialized upon allocating it, therefore
> > we have a chance that the garbage data that lies there at
> > allocation time actually ressembles a valid oob tag. This is only
> > problematic if we are sending/receiving traffic on the master port,
> > which isn't a valid DSA use-case from the beggining. When dealing
> > from traffic to/from a slave port, then the oob tag will be
> > initialized properly by the tagger or the mac driver through the
> > use of the dsa_oob_tag_push() call.  
> 
> What I like about your approach is that you have aligned the way an
> out of band switch tag is communicated to the networking stack the
> same way that an "in-band" switch tag would be communicated. I think
> this is a good way forward to provide the out of band tag and I don't
> think it creates a performance problem because the Ethernet frame is
> hot in the cache (dma_unmap_single()) and we already have an
> "expensive" read of the DMA descriptor in coherent memory anyway.
> 
> You could possibly optimize the data flow a bit to limit the amount
> of sk_buff data movement by asking your Ethernet controller to DMA
> into the data buffer N bytes into the beginning of the data buffer.
> That way, if you have reserved say, 2 bytes at the front data buffer
> you can deposit the QCA tag there and you do not need to push,
> process the tag, then pop it, just process and pop. Consider using
> the 2byte stuffing that the Ethernet controller might be adding to
> the beginning of the Ethernet frame to align the IP header on a
> 4-byte boundary to provide the tag in there?
> 
> If we want to have a generic out of band tagger like you propose, it 
> seems to me that we will need to invent a synthetic DSA tagging
> format which is the largest common denominator of the out of band
> tags that we want to support. We could imagine being more compact in
> the representation for instance by using an u8 for storing a bitmask
> of ports (works for both RX and TX then) and another u8 for various
> packet forwarding reasons.

Thanks, that was my initial idea indeed. Having a generic tagger that
can be re-used would be great IMO. I'll modify the format as you
propose, and also give a try to you approach of DMA'ing 2 bytes forward
so that the tag location is already allocated, that's a nice idea.

> Then we would request the various Ethernet MAC drivers to marshall
> their proprietary tag into the DSA synthetic one on receive, and
> unmarshall it on transmit.
> 
> Another approach IMHO which maybe helps the maintainability of the
> code moving forward as well as ensuring that all Ethernet switch
> tagging code lives in one place, is to teach each tagger driver how
> to optimize their data paths to minimize the amount of data movements
> and checksum re-calculations, this is what I had in mind a few years
> ago:
> 
> https://lore.kernel.org/lkml/1438322920.20182.144.camel@edumazet-glaptop2.roam.corp.google.com/T/
> 
> This might scale a little less well, and maybe this makes too many 
> assumptions as to where and how the checksums are calculated on the 
> packet contents, but at least, you don't have logic processing the
> same type of switch tag scattered between the Ethernet MAC drivers
> (beyond copying/pushing) and DSA switch taggers.

That would definitely fit well with this tagger, I didn't know about
that series !

Thanks for the review,

Maxime

> I would like to hear other's opinion on this.

