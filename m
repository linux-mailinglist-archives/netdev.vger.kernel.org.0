Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79232639674
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 15:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiKZOaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 09:30:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiKZOaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 09:30:05 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0AED51B7B6;
        Sat, 26 Nov 2022 06:30:04 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0DBB12B;
        Sat, 26 Nov 2022 06:30:10 -0800 (PST)
Received: from slackpad.lan (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E6D763F587;
        Sat, 26 Nov 2022 06:29:59 -0800 (PST)
Date:   Sat, 26 Nov 2022 14:28:23 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Samuel Holland <samuel@sholland.org>, Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        LABBE Corentin <clabbe.montjoie@gmail.com>,
        Maxime Ripard <mripard@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: [PATCH 2/3] dt-bindings: net: sun8i-emac: Fix snps,dwmac.yaml
 inheritance
Message-ID: <20221126142735.47dcca6d@slackpad.lan>
In-Reply-To: <5b05317d-28cc-bfc8-f415-e6acf453dc7c@linaro.org>
References: <20221125202008.64595-1-samuel@sholland.org>
        <20221125202008.64595-3-samuel@sholland.org>
        <5b05317d-28cc-bfc8-f415-e6acf453dc7c@linaro.org>
Organization: Arm Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 26 Nov 2022 14:26:25 +0100
Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org> wrote:

Hi,

> On 25/11/2022 21:20, Samuel Holland wrote:
> > The sun8i-emac binding extends snps,dwmac.yaml, and should accept all
> > properties defined there, including "mdio", "resets", and "reset-names".
> > However, validation currently fails for these properties because the  
> 
> validation does not fail:
> make dt_binding_check -> no problems
> 
> Maybe you meant that DTS do not pass dtbs_check?

Yes, that's what he meant: If a board actually doesn't have Ethernet
configured, dt-validate complains. I saw this before, but didn't find
any solution.
An example is: $ dt-validate ... sun50i-a64-pinephone-1.2.dtb
arch/arm64/boot/dts/allwinner/sun50i-a64-pinephone-1.2.dtb:
  ethernet@1c30000: Unevaluated properties are not allowed ('resets', 'reset-names', 'mdio' were unexpected)
  From schema: Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml

Why exactly is beyond me, but this patch removes this message.

Cheers,
Andre


> > local binding sets "unevaluatedProperties: false", and snps,dwmac.yaml
> > is only included inside an allOf block. Fix this by referencing
> > snps,dwmac.yaml at the top level.  
> 
> There is nothing being fixed here...
> 
> > 
> > Signed-off-by: Samuel Holland <samuel@sholland.org>
> > ---
> > 
> >  .../devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml     | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
> > index 1432fda3b603..34a47922296d 100644
> > --- a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
> > +++ b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
> > @@ -10,6 +10,8 @@ maintainers:
> >    - Chen-Yu Tsai <wens@csie.org>
> >    - Maxime Ripard <mripard@kernel.org>
> >  
> > +$ref: "snps,dwmac.yaml#"
> > +
> >  properties:
> >    compatible:
> >      oneOf:
> > @@ -60,7 +62,6 @@ required:
> >    - syscon
> >  
> >  allOf:
> > -  - $ref: "snps,dwmac.yaml#"
> >    - if:
> >        properties:
> >          compatible:  
> 
> Best regards,
> Krzysztof
> 
> 

