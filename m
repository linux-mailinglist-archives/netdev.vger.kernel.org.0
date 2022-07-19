Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC01857A2E7
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 17:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237773AbiGSPZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 11:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233726AbiGSPZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 11:25:46 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D28240A0;
        Tue, 19 Jul 2022 08:25:45 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id z23so27847096eju.8;
        Tue, 19 Jul 2022 08:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZH7Pn/I57bUXWGtdU7bf61RroXUjVX251kWCY9hsq4Y=;
        b=UzC/7xvopJVsdv4jGEBq7Tu9ikuO292arAqnpQ2ZVsAceyfPUCVZcdWYAi990sEklL
         /Qrq6zYv6QrfMYoNlYWyzJdKqSsnQHVBtV1ouUjeF5y8gB0EbdsI0DnoEI/MyUE5kyP7
         57XKUbiEcCjX9w8hYQLVdQH3xbh/Xay54IipVmAlw7p9ZW05KEmShvf+uCEeOw7VHOrG
         01dlbrAY0kqao12sE1/wPCS0nhzjFuEVY8VlyDlbOSmzLd1FEiznk+fZpWlRczAe3Skh
         EHeRu8tXebfjb5zQ6hUs8mQjdcu0VgKsSM/DYKTkQD9Xp+p+u/ZMiK/0szWaBLppvuq7
         AB1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZH7Pn/I57bUXWGtdU7bf61RroXUjVX251kWCY9hsq4Y=;
        b=N1nqDHTNzCNFKLIOxczsNi4o83m4xabZGsvQFgNv1NUZd1S2Tl/3ubNdT3AX/WBysH
         TfJkgIHbJBcpiQHzFFgeeTCn9ov6VAsn0Ege17el6HsMYXd1u5eFTTpO9ndcz7ScH++O
         7+yjN5iqkMps271afCKIWJQTBXACGZDrco2EvzryDn4MP2xHqNyZryXD/fYYM1GZN2gc
         9MlBfcCNJMsaQF22Mb0xrHdisTwit+uwiwJqdxPF0jDWzUqhZzU1E3ToyNISQn06T4lK
         SiI00Gw08QXxV7MhOaXGlmoaABP4Bd1ckYoJYboi1b0QynDP9Mp//7Q6XpZD7Rkp1Cs8
         AkiQ==
X-Gm-Message-State: AJIora89Df7Ma6fUW5lAxeYa4QfozuYZFZuGj3SCgtUrZhneHdHKlbZE
        OhkmX5cyNyAmRtrwAuqaLoo=
X-Google-Smtp-Source: AGRyM1vatk5TFzxFEFwNt9LS2/4BdxUT9VICrFNvS8bqC/Uv8jcKr5XKGx9RSbKWcCXHBrrbqPW8UQ==
X-Received: by 2002:a17:906:5d04:b0:722:f46c:b891 with SMTP id g4-20020a1709065d0400b00722f46cb891mr31704110ejt.4.1658244343619;
        Tue, 19 Jul 2022 08:25:43 -0700 (PDT)
Received: from skbuf ([188.27.185.104])
        by smtp.gmail.com with ESMTPSA id a15-20020a1709066d4f00b00715705dd23asm6772150ejt.89.2022.07.19.08.25.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 08:25:42 -0700 (PDT)
Date:   Tue, 19 Jul 2022 18:25:39 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        Shawn Guo <shawnguo@kernel.org>, UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [RFC PATCH net-next 0/9] net: pcs: Add support for devices
 probed in the "usual" manner
Message-ID: <20220719152539.i43kdp7nolbp2vnp@skbuf>
References: <20220711160519.741990-1-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711160519.741990-1-sean.anderson@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sean,

On Mon, Jul 11, 2022 at 12:05:10PM -0400, Sean Anderson wrote:
> For a long time, PCSs have been tightly coupled with their MACs. For
> this reason, the MAC creates the "phy" or mdio device, and then passes
> it to the PCS to initialize. This has a few disadvantages:
> 
> - Each MAC must re-implement the same steps to look up/create a PCS
> - The PCS cannot use functions tied to device lifetime, such as devm_*.
> - Generally, the PCS does not have easy access to its device tree node
> 
> I'm not sure if these are terribly large disadvantages. In fact, I'm not
> sure if this series provides any benefit which could not be achieved
> with judicious use of helper functions. In any case, here it is.
> 
> NB: Several (later) patches in this series should not be applied. See
> the notes in each commit for details on when they can be applied.

Sorry to burst your bubble, but the networking drivers on NXP LS1028A
(device tree at arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi, drivers
at drivers/net/ethernet/freescale/enetc/ and drivers/net/dsa/ocelot/)
do not use the Lynx PCS through a pcs-handle, because the Lynx PCS in
fact has no backing OF node there, nor do the internal MDIO buses of the
ENETC and of the switch.

It seems that I need to point this out explicitly: you need to provide
at least a working migration path to your PCS driver model. Currently
there isn't one, and as a result, networking is broken on the LS1028A
with this patch set.
