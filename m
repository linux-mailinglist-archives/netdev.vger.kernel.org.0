Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8CB164E8CA
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 10:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbiLPJqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 04:46:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiLPJqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 04:46:13 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B946D11C1C;
        Fri, 16 Dec 2022 01:46:10 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id BF11115D7;
        Fri, 16 Dec 2022 10:46:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1671183968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S9k3p+tGla8AZA78altCt53cceGmdNh0wK9bpwDdkkc=;
        b=0A7cY46hdof1/UJo6hDmGKUOTyEIy1zAWWFCZK1VZazOQ7jPUxVsdqbtwI35h7fLaERKx9
        OHas81hZtHLmh7ZQRazsX0+RBm2ptUOMCd8Voe8t23KKx0M/qaKi3e/RMdGuhMGT17LykP
        LTdiAFjmAd9O3g6uyOnBfYe6hXgahioDol3MTX1GM51I2xZcsWIz1i6rGkHi06K8wVz3Wd
        ECzhe3aKdbkCrolZBnnneL+KXfmlxutCws+p29OUamjeva98afjoWaeVCUFi35qu31fugZ
        6ZLSxgJ+uqqtNaXGWC9fVjiWyqbku/c2ugHPnUD2JwZ0vdNgRr5UXL+EXjsyFw==
MIME-Version: 1.0
Date:   Fri, 16 Dec 2022 10:46:08 +0100
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Xu Liang <lxu@maxlinear.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v1 4/4] net: phy: mxl-gpy: disable interrupts on
 GPY215 by default
In-Reply-To: <Y4uzYVSRiE9feD01@lunn.ch>
References: <20221202151204.3318592-1-michael@walle.cc>
 <20221202151204.3318592-5-michael@walle.cc> <Y4pHCQrDbXXmOT+A@lunn.ch>
 <69e0468cf192455fd2dc7fc93194a8ff@walle.cc> <Y4uzYVSRiE9feD01@lunn.ch>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <34dc81b01930e594ca4773ddb8c24160@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-12-03 21:36, schrieb Andrew Lunn:
>> > > @@ -290,6 +291,10 @@ static int gpy_probe(struct phy_device *phydev)
>> > >  	phydev->priv = priv;
>> > >  	mutex_init(&priv->mbox_lock);
>> > >
>> > > +	if (gpy_has_broken_mdint(phydev) &&
>> > > +	    !device_property_present(dev,
>> > > "maxlinear,use-broken-interrupts"))
>> > > +		phydev->irq = PHY_POLL;
>> > > +
>> >
>> > I'm not sure of ordering here. It could be phydev->irq is set after
>> > probe. The IRQ is requested as part of phy_connect_direct(), which is
>> > much later.
>> 
>> I've did it that way, because phy_probe() also sets phydev->irq = 
>> PHY_POLL
>> in some cases and the phy driver .probe() is called right after it.
> 
> Yes, it is a valid point to do this check, but on its own i don't
> think it is sufficient.

Care to elaborate a bit? E.g. what is the difference to the case
the phy would have an interrupt described but no .config_intr()
op.

>> > I think a better place for this test is in gpy_config_intr(), return
>> > -EOPNOTSUPP. phy_enable_interrupts() failing should then cause
>> > phy_request_interrupt() to use polling.
>> 
>> Which will then print a warning, which might be misleading.
>> Or we disable the warning if -EOPNOTSUPP is returned?
> 
> Disabling the warning is the right thing to do.

There is more to this. .config_intr() is also used in
phy_init_hw() and phy_drv_supports_irq(). The latter would
still return true in our case. I'm not sure that is correct.

After trying your suggestion, I'm still in favor of somehow
tell the phy core to force polling mode during probe() of the
driver. The same way it's done if there is no .config_intr().

It's not like we'd need change the mode after probe during
runtime. Also with your proposed changed the attachment print
is wrong/misleading as it still prints the original irq instead
of PHY_POLL.

-michael
