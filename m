Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D785251FCDD
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 14:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234521AbiEIMdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 08:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234456AbiEIMdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 08:33:10 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF132734F4;
        Mon,  9 May 2022 05:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=EjfCEa0TLF8f/I9bli8jlfniBJovZSdwbAn5Oa++DzA=; b=Koa8tVPalAIu3bexYHIhXrbTFN
        tvqrLD17DhSh6hOmIiztzWbxz8ZcLc7UisgrgEqlPh35Umr7E4nA58jNORasJalkMNlFtVWhM2kjD
        dzxcx+1lnfGHkmP5XnTFlWvJ9hO2NTYlW9WyfXPsGgG1+057FDoeXM513XFiK8MvReFs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1no2KN-001wGb-G4; Mon, 09 May 2022 14:17:27 +0200
Date:   Mon, 9 May 2022 14:17:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     alexandre.torgue@foss.st.com, broonie@kernel.org,
        calvin.johnson@oss.nxp.com, davem@davemloft.net,
        edumazet@google.com, hkallweit1@gmail.com,
        jernej.skrabec@gmail.com, joabreu@synopsys.com,
        krzysztof.kozlowski+dt@linaro.org, kuba@kernel.org,
        lgirdwood@gmail.com, linux@armlinux.org.uk, pabeni@redhat.com,
        peppe.cavallaro@st.com, robh+dt@kernel.org, samuel@sholland.org,
        wens@csie.org, netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev
Subject: Re: [PATCH 3/6] dt-bindings: net: Add documentation for phy-supply
Message-ID: <YnkGV8DyTlCuT92R@lunn.ch>
References: <20220509074857.195302-1-clabbe@baylibre.com>
 <20220509074857.195302-4-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509074857.195302-4-clabbe@baylibre.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 07:48:54AM +0000, Corentin Labbe wrote:
> Add entries for the 2 new phy-supply and phy-io-supply.
> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  .../devicetree/bindings/net/ethernet-phy.yaml          | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> index ed1415a4381f..2a6b45ddf010 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> @@ -153,6 +153,16 @@ properties:
>        used. The absence of this property indicates the muxers
>        should be configured so that the external PHY is used.
>  
> +  phy-supply:
> +    description:
> +      Phandle to a regulator that provides power to the PHY. This
> +      regulator will be managed during the PHY power on/off sequence.
> +
> +  phy-io-supply:
> +    description:
> +      Phandle to a regulator that provides power to the PHY. This
> +      regulator will be managed during the PHY power on/off sequence.

If you need two differently named regulators, you need to make it clear
how they differ. My _guess_ would be, you only need the io variant in
order to talk to the PHY registers. However, to talk to a link
partner, you need the other one enabled as well. Which means handling
that regulator probably should be in the PHY driver, so it is enabled
only when the interface is configured up.

     Andrew
