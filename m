Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D07D50FFCC
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 15:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348362AbiDZOAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 10:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237966AbiDZOAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 10:00:47 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB2E161E91;
        Tue, 26 Apr 2022 06:57:38 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 6E9B7C0009;
        Tue, 26 Apr 2022 13:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1650981457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QXillSlDec+QdBFHMoazEsDlgZIJ8YMeOCBMwuPfphY=;
        b=brrKEe1cOheWxjqRfbu7MAq3yJXJavO8aHcrCe5VVAzM2yOYy/K/h+eccWo7D1Gl1mQh1g
        34f6LXnicgZ6ZvQDxNlx+g81sODKX/Yj3vVznMa6DFjBbdvehpqOTjz82hhWV1z4LTRV52
        g4bJUjcMPWLwrXoqSf7n1YlEgxAq7bQGgUwJhOYQgY+trLFNE09E0WnT47jnCcOqlhUjAC
        i2tnWLqwySW0S2F0GXg3Ob/uLVKU/Y6EVWYjG0FJoQC6zRRgUQt742stDIEqL7mHQIZmUe
        f4FziQHt4KpucEWziEjzQ3lW4+XeVtAG953iVobc/dUtKqa93uh/O9D3k3gKgA==
Date:   Tue, 26 Apr 2022 15:57:32 +0200
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
Subject: Re: [PATCH net-next 2/5] net: dsa: add out-of-band tagging protocol
Message-ID: <20220426155732.223e0446@pc-19.home>
In-Reply-To: <68c4710d-013e-85e0-154d-413f4e13b27e@gmail.com>
References: <20220422180305.301882-1-maxime.chevallier@bootlin.com>
 <20220422180305.301882-3-maxime.chevallier@bootlin.com>
 <68c4710d-013e-85e0-154d-413f4e13b27e@gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Florian,

On Fri, 22 Apr 2022 11:28:30 -0700
Florian Fainelli <f.fainelli@gmail.com> wrote:

Thanks for the review :)

> On 4/22/22 11:03, Maxime Chevallier wrote:
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
> > This tagging protocol relies on a new set of fields in skb->shinfo
> > to transmit the dsa tagging information to and from the MAC driver.
> > 
> > Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>  
> 
> First off, I am not a big fan of expanding skb::shared_info because
> it is sensitive to cache line sizes and is critical for performance
> at much higher speeds, I would expect Eric and Jakub to not be
> terribly happy about it.

No problem, I'm testing with the skb->cb approach as you suggested and
see how it goes.

> The Broadcom systemport (bcmsysport.c) has a mode where it can
> extract the Broadcom tag and put it in front of the actual packet
> contents which appears to be very similar here. From there on, you
> can have two strategies:
> 
> - have the Ethernet controller mangle the packet contents such that
> the QCA tag is located in front of the actual Ethernet frame and
> create a new tagging protocol variant for QCA, similar to the
> TAG_BRCM versus TAG_BRCM_PREPEND
> 
> - provide the necessary information for the tagger to work using an
> out of band mechanism, which is what you have done, in which case,
> maybe you can use skb->cb[] instead of using skb::shared_info?

One of the reason why I chose the second is to support possible future
cases where another controller would face a similar situation, and also
make use of the out-of-band tagger.

I understand that it's not very elegant in the sense that this breaks
the nice tagging model we have, but adding/removing data before the
payload also seems convoluted to achieve the same thing :) It seems
that this approach comes with a bit of an overhead since it implies
mangling the skb a bit, but I've yet to test this myself.

That's actually what I wanted your opinion on, it also seems like
Andrew likes the idea of putting the tag ahead of the frame to stick
with the actual model.

I don't have strong feelings myself on the way of doing this, I'm
looking for an approach that is efficient but yet easily maintainable.

Thanks,

Maxime
