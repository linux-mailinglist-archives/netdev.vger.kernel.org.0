Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB1FB529A56
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 09:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240671AbiEQHDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 03:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240732AbiEQHCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 03:02:20 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [217.70.178.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32EE9473A0;
        Tue, 17 May 2022 00:02:01 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id A1ADA10000B;
        Tue, 17 May 2022 07:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652770920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9KazaW1SkFx7SybTXPFRmtUBoimvEisxPHGbF+BGpFc=;
        b=R5CTzLA4Ubtz8fYfQ2SDt3yt3caIj3yrtuf0wjEBNuwsMPcn30DzUr5KYbk4TNHmWe5fGn
        PceQ1IHai4j++s5NU/WJqjbOkn2Legv9KSeORmjtH8o9pkGx3aFTRfx+W7+ZT9URZnolio
        rdvxiV4rfaQVB4ISVYv/iuthulsjxDhJH3SrSqohMvKj6qwxjd0LAicq3OjeHg35EOYnlx
        n46ipD/l/baalEMoG1wmOkd/dNPzNzBChI9l0XUYPajQTBeBpIpPdUb3AhJZpwaMbDJqQa
        h3H3Vpkf1+E6oKnbD4wWfESDyqbNcBgFMRC22ANt+DxSQlDY99MkW97sHrc7qQ==
Date:   Tue, 17 May 2022 09:01:56 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v2 2/5] net: dsa: add out-of-band tagging
 protocol
Message-ID: <20220517090156.3fde5a8f@pc-20.home>
In-Reply-To: <20220514224002.vvmd43lnjkbsw2g3@skbuf>
References: <20220514150656.122108-1-maxime.chevallier@bootlin.com>
        <20220514150656.122108-3-maxime.chevallier@bootlin.com>
        <20220514224002.vvmd43lnjkbsw2g3@skbuf>
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

Hi Vlad,

On Sat, 14 May 2022 22:40:03 +0000
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> On Sat, May 14, 2022 at 05:06:53PM +0200, Maxime Chevallier wrote:
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
> > 
> > Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> > ---  
> 
> Why put the DSA pseudo-header at skb->head rather than push it using
> skb_push()? I thought you were going to check for the presence of a
> DSA header using something like skb->mac_len == ETH_HLEN + tag len,
> but right now it sounds like treating garbage in the headroom as a
> valid DSA tag is indeed a potential problem. If you can't sort that
> out using information from the header offsets alone, maybe an skb
> extension is required?

Indeed, I thought of that, the main reason is that pushing/poping in
itself is not enough, you also have to move the whole mac_header to
leave room for the tag, and then re-set it in it's original location.
There's nothing wrong with this, but it looked a bit cumbersome just to
insert a dummy tag that gets removed rightaway. Does that make sense ?

But yes I would really like to get a way to know wether the tag is
there or not, I'll dig a bit more to see if I can find a way to get
this info from the various skb offsets in a reliable way.

Thanks,

Maxime
