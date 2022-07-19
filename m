Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF8457A353
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 17:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237364AbiGSPiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 11:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbiGSPiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 11:38:18 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA8D599FB;
        Tue, 19 Jul 2022 08:38:17 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id j22so27940641ejs.2;
        Tue, 19 Jul 2022 08:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qnD9woDxfn+LSOscfoHzvBXGTCCBlK5kWUK/hmrm5mc=;
        b=Fk80keQB94yN1hbOFQ/8Ik5Dn9qiQizXFjlxyiFnOIDjj72zZryknDAIRwKat35COn
         +g0IvgCMxP7p10jhYIzT40U5BaoqkG0DTfQu17WaQl7LSW8FbPLWr5beE0bClHN7vfI5
         QX0wRoDtYjxJn3mp/8Utao5/XI+8/wOB29nWOvd5Mof/UnO/Pv3D4ytDzD2qfzp0Kbe8
         aDhWld/Pid6oLQ2LEXnCXrybVDU0psRQKzsCromDxv98lw1l2FKTcgPkGgRuG7QQhIW1
         kfs6zo4Tzg+qSTSQep4w+4prkaQm2Lx2E3nx4DiI6udE/ynQaH1Hc7VAfFKu8qGrudA3
         jygA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qnD9woDxfn+LSOscfoHzvBXGTCCBlK5kWUK/hmrm5mc=;
        b=wPhu2T+vExN/awRsYHO8jSNcEAw4MfldknNk0YS8kgBpqmxZ40Adpx4uNtSECfrF97
         xsAMpHmCeMO4SWd8bAshbZe/M60PsTBxnSSmmD4SWbaHESFPtwphKntgp9k6rBoXkXm0
         y438r2ZZ6tQjSF1yXFSE8ApkbyMDlNAlGKYF3wYl2A1L9dllQM/GssxHaBcyidGSeDXa
         4hKUjLFYXp32iURqWmuGohbTLAVymeUmQumOGpb1WlieBb4yF+bqVlj609EkFhgNcWZk
         cMk6nhMqIf5V2jCAzlUfnRZLpD8szyAUdCCGS6gfN5ir8/2m2CQONxL4StrU01lYsalk
         Tacg==
X-Gm-Message-State: AJIora+yEjypIFwJYLsC/6eyXvBwpGAh7V69c7LbLT8jqtFZw8Ndkhlb
        LMCcRDus7f/GV3pNPfBKhPw=
X-Google-Smtp-Source: AGRyM1sF+tywVSO3QfunBktfmfaVi0fddzmm/dxFRUi3UiykwFMhU7B4f2YxJkBqXVs7l0XmJXPUNw==
X-Received: by 2002:a17:907:16ab:b0:72c:7533:7262 with SMTP id hc43-20020a17090716ab00b0072c75337262mr29330300ejc.288.1658245095723;
        Tue, 19 Jul 2022 08:38:15 -0700 (PDT)
Received: from skbuf ([188.27.185.104])
        by smtp.gmail.com with ESMTPSA id s9-20020a170906a18900b00722e5b234basm6939832ejy.179.2022.07.19.08.38.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 08:38:14 -0700 (PDT)
Date:   Tue, 19 Jul 2022 18:38:11 +0300
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
Message-ID: <20220719153811.izue2q7qff7fjyru@skbuf>
References: <20220711160519.741990-1-sean.anderson@seco.com>
 <20220719152539.i43kdp7nolbp2vnp@skbuf>
 <bec4c9c3-e51b-5623-3cae-6df1a8ce898f@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bec4c9c3-e51b-5623-3cae-6df1a8ce898f@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 11:28:42AM -0400, Sean Anderson wrote:
> Hi Vladimir,
> 
> On 7/19/22 11:25 AM, Vladimir Oltean wrote:
> > Hi Sean,
> > 
> > On Mon, Jul 11, 2022 at 12:05:10PM -0400, Sean Anderson wrote:
> >> For a long time, PCSs have been tightly coupled with their MACs. For
> >> this reason, the MAC creates the "phy" or mdio device, and then passes
> >> it to the PCS to initialize. This has a few disadvantages:
> >> 
> >> - Each MAC must re-implement the same steps to look up/create a PCS
> >> - The PCS cannot use functions tied to device lifetime, such as devm_*.
> >> - Generally, the PCS does not have easy access to its device tree node
> >> 
> >> I'm not sure if these are terribly large disadvantages. In fact, I'm not
> >> sure if this series provides any benefit which could not be achieved
> >> with judicious use of helper functions. In any case, here it is.
> >> 
> >> NB: Several (later) patches in this series should not be applied. See
> >> the notes in each commit for details on when they can be applied.
> > 
> > Sorry to burst your bubble, but the networking drivers on NXP LS1028A
> > (device tree at arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi, drivers
> > at drivers/net/ethernet/freescale/enetc/ and drivers/net/dsa/ocelot/)
> > do not use the Lynx PCS through a pcs-handle, because the Lynx PCS in
> > fact has no backing OF node there, nor do the internal MDIO buses of the
> > ENETC and of the switch.
> > 
> > It seems that I need to point this out explicitly: you need to provide
> > at least a working migration path to your PCS driver model. Currently
> > there isn't one, and as a result, networking is broken on the LS1028A
> > with this patch set.
> > 
> 
> Please refer to patches 4, 5, and 6.

I don't understand, could you be more clear? Are you saying that I
shouldn't have applied patch 9 while testing? When would be a good
moment to apply patch 9?
