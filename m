Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE1466E739F
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 09:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbjDSHEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 03:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjDSHEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 03:04:14 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382AF1985;
        Wed, 19 Apr 2023 00:04:10 -0700 (PDT)
Received: (Authenticated sender: herve.codina@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id DCDC41C0015;
        Wed, 19 Apr 2023 07:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1681887849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h0B6abn8eVYRAhqcUdwi/N3mg95GJYAXeGF36SP3PmQ=;
        b=BMjo1e8T7SI0mKvcbi0VZ5kfoUSO8YmF4GXuj+wgnuTGXRIVoe3rf5CsSJO0xF8Rw/HMn4
        dDhMcjD47apPhcERNZJPBfmCVQdoA2Q1I1l9vIPBMDQ7AlWm3V+5GXTWDdHCdnwk/plt0q
        isn/+JrqIPkgUjWu73Fg42WZrgaeRRPAMrafcPIc9iNpwVSNZNjRqI1OPS1sdX41rlQ5+5
        N1Oc9dlljQlXPYNGu7egA5+kP8lPLpCsPur9hvh+Majm77h0oTsSA1L+Va7Hrv4mWU0hiF
        Echtr04nb0NnRkQqMWpMWXJ9AJ1Xagb9mmrGAEJ4/MRO90nOMAXVdxaNQKcReQ==
Date:   Wed, 19 Apr 2023 09:04:06 +0200
From:   Herve Codina <herve.codina@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-phy@lists.infradead.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [RFC PATCH 0/4] Add support for QMC HDLC and PHY
Message-ID: <20230419090406.681e0265@bootlin.com>
In-Reply-To: <9e7fe32a-8125-41d5-9f8e-d3e5c6c64584@lunn.ch>
References: <20230323103154.264546-1-herve.codina@bootlin.com>
        <885e4f20-614a-4b8e-827e-eb978480af87@lunn.ch>
        <20230414165504.7da4116f@bootlin.com>
        <c99a99c5-139d-41c5-89a4-0722e0627aea@lunn.ch>
        <20230417121629.63e97b80@bootlin.com>
        <a2615755-f009-4a21-b464-88ec5e58f32a@lunn.ch>
        <20230417173941.0206f696@bootlin.com>
        <9e7fe32a-8125-41d5-9f8e-d3e5c6c64584@lunn.ch>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Mon, 17 Apr 2023 19:22:26 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> > My application (probably a subset of what we can do with E1 lines) does
> > not use signaling.
> > 
> > I don't expose any channel to the user space but just:
> > - One hdlc interface using one timeslot.
> > - One or more dai links (audio channels) that can be used using ALSA library.  
> 
> Well, that obviously does what you need for you application, but it
> does not sound very generic. I don't think you could build a PBX on
> top of that. I'd think you can build an E1 trunk to VoIP gateway.  So
> i also have to wounder how generic vs one specific use case your
> building blocks are.
> 
> Looking at the binding, i assume you could in fact instantiate 32 hdlc
> instances? And that 'transparent' actually means DAI? So you can
> instantiate as many DAI as you want. If you wanted to implement
> signalling, a third type could be added?
> 
> > I thought I was providing a "standardised" API between the HDLC device
> > and the framer. Maybe it was not as complete as you could expect but I had
> > the feeling that it was standardised.  
> 
> You are abusing the Generic PHY interface, for something which is not
> a PHY. Your PHY driver does nothing a PHY driver normally does,
> because you keep arguing the MFD does it all. So to me this is the
> wrong abstraction.
> 
> You need an abstraction of a framer. You do however want a similar API
> to generic PHY. devm_of_framer_optional_get() for the consumer of a
> framer, which looks in DT for a phandle to a device.
> devm_framer_create() which registers a framer provider, your MFD, with
> the framer core. The hdlc driver can then get an instance of the
> framer, and either put a notifier call block on its chain, or register
> a function to be called when there is change in status.
> 
> What i also don't like is you have a very static configuration. You
> are putting configuration into DT, which i'm surprised Rob Herring and
> Krzysztof Kozlowski accepted. How you use E1 slots is not a hardware
> property, it is purely software configuration, so should not be in DT.
> So there should be a mechanism to configure how slots are used. You
> can then dynamically instantiate HDLC interfaces and DAI links. This
> is something which should be in the framer core. But since you have
> managed to get this binding accepted, you can skip this. But
> implementing the basic framer abstraction will give a place holder for
> somebody to implement a much more generic solution in the future.
> 
> 	 Andrew

I can move to a basic framer abstraction as you suggested. At least:
- devm_of_framer_optional_get()
- devm_framer_create()
- framer_notifier_register() or something similar.

Where do you expect to see this framer abstraction and the pef2256
framer part ?
driver/net/wan/framer/, other place ?
I think driver/net/wan/framer/ can be a good place to start as only HDLC
will use this abstraction.

I can use the framer abstraction from the QMC HDLC driver itself or try
to move it to the HDLC core. Do you think it will be interesting to have
it move to the HDLC core ?

Best regards,
Hervé

-- 
Hervé Codina, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
