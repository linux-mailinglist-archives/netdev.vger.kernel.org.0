Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECB635299F3
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 08:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236599AbiEQGyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 02:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235513AbiEQGyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 02:54:06 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A82A126567;
        Mon, 16 May 2022 23:54:03 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 68338FF803;
        Tue, 17 May 2022 06:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652770440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LSRSBOWx0X3UM1Ake1VNIh+NUfX/y6+vqtFaURfJuPo=;
        b=IzCag1a/2/Oiqmxyp/nm3xkf4F2qFuTTBqkI3I9j44abhdGXKoOzszw2tDuUJr0sJCgOw4
        hSTRCZ2qu+jSA/YAlXPprl6h7o97SxaybLE9dlvZ7VKTjAVODeTiSAbQmiv4Lt2n7K0bqE
        EbaCuMIJPWevm5/Oko/dQdJvZ7G8houWWIlPT8ZZFcetvVK52nK5mapuxjpuiYMXMuDSyX
        +TcbKy7YOyYlJnO1PEfUkGNxqWSUuQvMSHtqzayxPzdje+U76A6hc2psOjGap3KWZd3bpj
        HvARvrUJ0YXO8dSpf5W49+QaLWy8JjOOaO1VMFLQ1US96DeItNdgRZ+8bJeDeQ==
Date:   Tue, 17 May 2022 08:53:55 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v2 2/5] net: dsa: add out-of-band tagging
 protocol
Message-ID: <20220517085355.4fab54b3@pc-20.home>
In-Reply-To: <20220516122048.70e238a2@kernel.org>
References: <20220514150656.122108-1-maxime.chevallier@bootlin.com>
        <20220514150656.122108-3-maxime.chevallier@bootlin.com>
        <20220516122048.70e238a2@kernel.org>
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

Hello Jakub,

On Mon, 16 May 2022 12:20:48 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> On Sat, 14 May 2022 17:06:53 +0200 Maxime Chevallier wrote:
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
> 
> This must had been asked on v1 but there's no trace of it in the
> current submission afaict...

No you're correct, this wasn't explained.

> If the tag is passed in the descriptor how is this not a pure
> switchdev driver? The explanation must be preserved somehow.

The main reason is that although the MAC and switch are rightly coupled
on that platform, the switch is actually a QC8K that can live on it's
own, as an external switch. Here, it's just a slightly modified version
of this IP.

The same goes for the MAC IP, but so far we don't support any other
platform that have the MAC as a standalone controller. As far as we can
tell, platforms that have this MAC also include a QCA8K, but the
datasheet also mentions other modes (like outputing RGMII).

Is this valid to have it as a standalone ethernet driver in that
situation ?

Thanks,

Maxime
