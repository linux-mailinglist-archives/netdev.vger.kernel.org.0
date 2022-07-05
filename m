Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AED255667AB
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 12:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbiGEKTU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 5 Jul 2022 06:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbiGEKTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 06:19:19 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 60EF613FB2;
        Tue,  5 Jul 2022 03:19:17 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1A4EE23A;
        Tue,  5 Jul 2022 03:19:17 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CE2B13F792;
        Tue,  5 Jul 2022 03:19:14 -0700 (PDT)
Date:   Tue, 5 Jul 2022 11:19:06 +0100
From:   Andre Przywara <andre.przywara@arm.com>
To:     Samuel Holland <samuel@sholland.org>
Cc:     Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v12 1/7] dt-bindings: arm: sunxi: Add H616 EMAC
 compatible
Message-ID: <20220705111906.3c553f23@donnerap.cambridge.arm.com>
In-Reply-To: <b2661412-5fce-a20d-c7c4-6df58efdb930@sholland.org>
References: <20220701112453.2310722-1-andre.przywara@arm.com>
        <20220701112453.2310722-2-andre.przywara@arm.com>
        <b2661412-5fce-a20d-c7c4-6df58efdb930@sholland.org>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 4 Jul 2022 18:53:14 -0500
Samuel Holland <samuel@sholland.org> wrote:

Hi Samuel,

> On 7/1/22 6:24 AM, Andre Przywara wrote:
> > The Allwinner H616 contains an "EMAC" Ethernet MAC compatible to the A64
> > version.
> > 
> > Add it to the list of compatible strings.
> > 
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > ---
> >  .../devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml       | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
> > index 6a4831fd3616c..87f1306831cc9 100644
> > --- a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
> > +++ b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
> > @@ -22,6 +22,7 @@ properties:
> >            - enum:
> >                - allwinner,sun20i-d1-emac
> >                - allwinner,sun50i-h6-emac
> > +              - allwinner,sun50i-h616-emac  
> 
> The H616 manual has register fields for an internal PHY, like H3. Are these not
> hooked up for either EMAC?

Which register fields do you mean, exactly? The H616 uses the same
internal PHY solution as the H6: an AC200 die co-packaged on the carrier
(or whatever integration solution they actually chose). The difference to
the H6 is that EMAC0 is hardwired to the external RGMII pins, whereas EMAC1
is hardwired to the internal AC200 RMII pins.
From all I could see that does not impact the actual MAC IP: both are the
same as in the H6, or A64, for that matter.

There is one twist, though: the second EMAC uses a separate EMAC clock
register in the syscon. I came up with this patch to support that:
https://github.com/apritzel/linux/commit/078f591017794a0ec689345b0eeb7150908cf85a
That extends the syscon to take an optional(!) index. So EMAC0 works
exactly like before (both as "<&syscon>;", or "<&syscon 0>;", but for EMAC1
we need the index: "<&syscon 4>;".
But in my opinion this should not affect the MAC binding, at least not for
MAC0. And I think we should get away without a different compatible string
for EMAC1, since the MAC IP is technically the same, it's just the
connection that is different.
In any case I think this does not affect the level of support we promise
today: EMAC0 with an external PHY only.

Cheers,
Andre

> 
> >            - const: allwinner,sun50i-a64-emac
> >  
> >    reg:
> >   
> 

