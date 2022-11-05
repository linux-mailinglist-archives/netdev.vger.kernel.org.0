Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52C7761A72E
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 04:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbiKEDFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 23:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiKEDFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 23:05:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002C521E33;
        Fri,  4 Nov 2022 20:05:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B28E0B82EFE;
        Sat,  5 Nov 2022 03:05:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D3E8C433C1;
        Sat,  5 Nov 2022 03:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667617532;
        bh=Umqv5TifrdYvGAgkEbrHB+9F3i1kl8URY4lxJt5JgnU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RUSpKDoQsUpxmyw84iR9hk2MKXk7x5jXy6Xa0rtAwELAhA9ChEw0eDcSsMpAt0Rsg
         OfQamM2RJW8LILzbI9mqVMpZfYbgHI+gYDBUp7ojOWiwyb87JXWxklp+4LVxXiUEoF
         8+PW9kdzcEkptfjRWbC2D/h1LZBU25kJqE47QqUEUdk5sGBeXBJFToyIKl1LCiKsYx
         R3M47E8D97phyiZzWBgG4LdHQLVwepDiPGLEzSS4zI7Wyx3Rhc6GRBRvAbbZR5vBI5
         P/pAoGO3UqsmiqNYgpye5ZUAlphbI0esHmfAyRGBeqd+DDsryrAhfW2qB8jw1J9K7n
         oAtvm8YGzN60g==
Date:   Fri, 4 Nov 2022 20:05:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
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
Message-ID: <20221104200530.3bbe18c6@kernel.org>
In-Reply-To: <20221104174151.439008-4-maxime.chevallier@bootlin.com>
References: <20221104174151.439008-1-maxime.chevallier@bootlin.com>
        <20221104174151.439008-4-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Nov 2022 18:41:49 +0100 Maxime Chevallier wrote:
> This tagging protocol is designed for the situation where the link
> between the MAC and the Switch is designed such that the Destination
> Port, which is usually embedded in some part of the Ethernet Header, is
> sent out-of-band, and isn't present at all in the Ethernet frame.
> 
> This can happen when the MAC and Switch are tightly integrated on an
> SoC, as is the case with the Qualcomm IPQ4019 for example, where the DSA
> tag is inserted directly into the DMA descriptors. In that case,
> the MAC driver is responsible for sending the tag to the switch using
> the out-of-band medium. To do so, the MAC driver needs to have the
> information of the destination port for that skb.
> 
> Add a new tagging protocol based on SKB extensions to convey the
> information about the destination port to the MAC driver

This is what METADATA_HW_PORT_MUX is for, you shouldn't have 
to allocate a piece of memory for every single packet.

Also the series doesn't build.
