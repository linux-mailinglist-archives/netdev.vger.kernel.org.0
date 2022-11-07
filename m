Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03C1E61ED0A
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 09:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbiKGIkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 03:40:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbiKGIj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 03:39:58 -0500
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [217.70.178.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5F515709;
        Mon,  7 Nov 2022 00:39:57 -0800 (PST)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id AE13B240012;
        Mon,  7 Nov 2022 08:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1667810395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kt3YaVgos6aTLVWYjMs61pa3ceG8lp2j8XYt+Ucplyw=;
        b=AscLybvqBkKKgJLxu4it0nKtw+XOslDBXsHBsvlHVxB0Quj8CJoOpqRBmXiqfOd1/kasH9
        I+cRuyTQ77O+3UrGUe3ZGeH7rU1c/DtCrPXXS+URrPf5lzaNMrG7+Bc9qi70AWFk/HuaSt
        jolcAbhp1rSvg2qX53A0bk241bSR4UCNLi0r3AMKmZCI5JP75FU80j+GTBU53Iy1XyffQi
        Uv2CTDUq7j4BuVRIrD5Rb5nvrcN87Urg4Q7WbnybzhsxcFFSPae5Z7j42qmFbMKsj+HI3J
        vXojYdsYBdNtD5o2z/B8c6rgd+JXFd3YWUtUB46TeWGWJbN4757yjat0WVARgg==
Date:   Mon, 7 Nov 2022 09:39:50 +0100
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>
Subject: Re: [PATCH net-next v8 3/5] net: dsa: add out-of-band tagging
 protocol
Message-ID: <20221107093950.74de3fa1@pc-8.home>
In-Reply-To: <20221104200530.3bbe18c6@kernel.org>
References: <20221104174151.439008-1-maxime.chevallier@bootlin.com>
        <20221104174151.439008-4-maxime.chevallier@bootlin.com>
        <20221104200530.3bbe18c6@kernel.org>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
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

Hello Jakub,

On Fri, 4 Nov 2022 20:05:30 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> On Fri,  4 Nov 2022 18:41:49 +0100 Maxime Chevallier wrote:
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
> > Add a new tagging protocol based on SKB extensions to convey the
> > information about the destination port to the MAC driver  
> 
> This is what METADATA_HW_PORT_MUX is for, you shouldn't have 
> to allocate a piece of memory for every single packet.

Does this work with DSA ? The information conveyed in the extension is
the DSA port identifier. I'm not familiar at all with
METADATA_HW_PORT_MUX, should we extend that mechanism to convey the
DSA port id ?

I also agree that allocating data isn't the best way to go, but from
the history of this series, we've tried 3 approaches so far :

 - Adding a new field to struct sk_buff, which isn't a good idea
 - Using the skb headroom, but then we can't know for sure is the skb
   contains a DSA tag or not
 - Using skb extensions, that comes with the cost of this memory
   allocation. Is this approach also incorrect then ?

> Also the series doesn't build.

Can you elaborate more ? I can't reproduce the build failure on my
side, and I didn't get any reports from the kbuild bot, are you using a
specific config file ?

Thanks,

Maxime
