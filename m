Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2740463BD62
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 10:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbiK2J5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 04:57:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231950AbiK2J5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 04:57:01 -0500
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CAFF34;
        Tue, 29 Nov 2022 01:56:59 -0800 (PST)
Received: from ip5b412258.dynamic.kabel-deutschland.de ([91.65.34.88] helo=diego.localnet)
        by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <heiko@sntech.de>)
        id 1ozxM0-0002sF-3D; Tue, 29 Nov 2022 10:56:40 +0100
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     Chukun Pan <amadeus@jmu.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Wu <david.wu@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] dt-bindings: net: rockchip-dwmac: add rk3568 xpcs compatible
Date:   Tue, 29 Nov 2022 10:56:39 +0100
Message-ID: <4692527.5fSG56mABF@diego>
In-Reply-To: <6f601615-deab-a1df-b951-dca8467039f8@linaro.org>
References: <20221129072714.22880-1-amadeus@jmu.edu.cn> <6f601615-deab-a1df-b951-dca8467039f8@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_PASS,
        T_SPF_HELO_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Dienstag, 29. November 2022, 09:49:08 CET schrieb Krzysztof Kozlowski:
> On 29/11/2022 08:27, Chukun Pan wrote:
> > The gmac of RK3568 supports RGMII/SGMII/QSGMII interface.
> > This patch adds a compatible string for the required clock.
> > 
> > Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
> > ---
> >  Documentation/devicetree/bindings/net/rockchip-dwmac.yaml | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml b/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
> > index 42fb72b6909d..36b1e82212e7 100644
> > --- a/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
> > +++ b/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
> > @@ -68,6 +68,7 @@ properties:
> >          - mac_clk_rx
> >          - aclk_mac
> >          - pclk_mac
> > +        - pclk_xpcs
> >          - clk_mac_ref
> >          - clk_mac_refout
> >          - clk_mac_speed
> > @@ -90,6 +91,11 @@ properties:
> >        The phandle of the syscon node for the peripheral general register file.
> >      $ref: /schemas/types.yaml#/definitions/phandle
> >  
> > +  rockchip,xpcs:
> > +    description:
> > +      The phandle of the syscon node for the peripheral general register file.
> 
> You used the same description as above, so no, you cannot have two
> properties which are the same. syscons for GRF are called
> "rockchip,grf", aren't they?

Not necessarily :-) .

The GRF is Rockchip's way of not sorting their own invented
additional registers. (aka a bunch of registers 

While on the older models there only ever was the one GRF
as dumping ground, newer SoCs now end up with multiple ones :-)

These are still iomem areas separate from the actual device-iomem they
work with/for but SoCs like the rk3568 now have at least 13 of them.


_But_ for the patch in question I fail to see what this set does at all.
The rk3568 (only) has XPCS_CON0 and XPCS_STATUS in its PIPE_GRF syscon
(according to the TRM), but the patch2 does strange things with
offset calculations and names that do not seem to have a match in the TRM.

So definitely more explanation on what happens here would be necessary.

Heiko






