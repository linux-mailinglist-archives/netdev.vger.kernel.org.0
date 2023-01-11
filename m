Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D210666637
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 23:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236185AbjAKWa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 17:30:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233181AbjAKWay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 17:30:54 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B991C76;
        Wed, 11 Jan 2023 14:30:52 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 06414166C;
        Wed, 11 Jan 2023 23:30:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1673476250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AL3D6fuBAPLwBqIn3nADqpL5RfYmlL7iAJcDIl8hybk=;
        b=UnslZtSR/5gXE7MrC0DSsUaff5dWD5BJ6Cdmi9jtr0d2z1ACC0wJbXBi5roXDUeAXEVeLv
        8XWxCUZ0B+t5QrPPJkkvLdiJaGCynENs94/8if6RIrj2TdmNJIBLpPjB8YeZJRqOImMd2v
        N7dbAt3aY1lD7IXV3adWN+iIO+8zmrnf2O95x5aP55ott4l7vfkD/1ZY+/MsXgnUttaI8M
        ZS0AEDXXmFl4fmuHq0rAr0anb5gOnErC9GAjjXZH993opNbne1owcEvJDWhy0+LOPUXIe4
        7Fc67tocND1rpACUoh+mlNxhEU7W68tgQi0M/GMgX2TXs9TN/PiM/w0KITlRNA==
MIME-Version: 1.0
Date:   Wed, 11 Jan 2023 23:30:49 +0100
From:   Michael Walle <michael@walle.cc>
To:     Rob Herring <robh@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Xu Liang <lxu@maxlinear.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/4] dt-bindings: net: phy: add MaxLinear
 GPY2xx bindings
In-Reply-To: <20230111202639.GA1236027-robh@kernel.org>
References: <20230109123013.3094144-1-michael@walle.cc>
 <20230109123013.3094144-3-michael@walle.cc>
 <20230111202639.GA1236027-robh@kernel.org>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <73f8aad30e0d5c3badbd62030e545ef6@walle.cc>
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

Am 2023-01-11 21:26, schrieb Rob Herring:
> On Mon, Jan 09, 2023 at 01:30:11PM +0100, Michael Walle wrote:
>> Add the device tree bindings for the MaxLinear GPY2xx PHYs, which
>> essentially adds just one flag: maxlinear,use-broken-interrupts.
>> 
>> One might argue, that if interrupts are broken, just don't use
>> the interrupt property in the first place. But it needs to be more
>> nuanced. First, this interrupt line is also used to wake up systems by
>> WoL, which has nothing to do with the (broken) PHY interrupt handling.
> 
> I don't understand how this is useful. If the interrupt line is 
> asserted
> after the 1st interrupt, how is it ever deasserted later on to be
> useful.

Nobody said, that the interrupt line will stay asserted. The broken
behavior is that of the PHY doesn't respond *immediately* with a
deassertion of the interrupt line after the its internal status
register is cleared. Instead there is a random delay of up to 2ms.

There is already a workaround to avoid an interrupt storm by delaying
the ISR until the line is actually cleared. *But* if this line is
a shared one. The line is blocked by these 2ms and important
interrupts (like PTP timestaming) of other devices on this line
will get delayed. Therefore, the only viabale option is to disable
the interrupts handling in the broken PHY altogether. I.e. the line
will never be asserted by the broken PHY.

> In any case, you could use 'wakeup-source' if that's the functionality
> you need. Then just ignore the interrupt if 'wakeup-source' is not
> present.

Right, that would work for the first case. But not if someone really
wants to use interrupts with the PHY, which is still a valid scenario
if it has a dedicated interrupt line.

>> Second and more importantly, there are devicetrees which have this
>> property set. Thus, within the driver we have to switch off interrupt
>> handling by default as a workaround. But OTOH, a systems designer who
>> knows the hardware and knows there are no shared interrupts for 
>> example,
>> can use this new property as a hint to the driver that it can enable 
>> the
>> interrupt nonetheless.
> 
> Pretty sure I said this already, but this schema has no effect. Add an
> extra property to the example and see. No error despite your
> 'unevaluatedProperties: false'. Or drop 'interrupts-extended' and no
> dependency error...

I know, I noticed this the first time I tested the schema. But then
I've looked at all the other PHY binding and not one has a compatible.

I presume if there is a compatible, the devicetrees also need a
compatible. So basically, "required: compatible" in the schema, right?
But that is where the PHY maintainers don't agree.

> You won't get errors as there's no defined way to decide when to apply
> this because it is based on node name or compatible unless you do a
> custom select, but I don't see what you would key off of here...

Actually, in the previous version I've asked why the custom select
of ethernet-phy.yaml doesn't get applied here, when there is a
"allOf: $ref ethernet-phy.yaml".

-michael

> The real answer here is add a compatible. But I'm tired of pointing 
> this
> out to the networking maintainers every damn time. Ethernet PHYs are 
> not
> special.
> 
> Rob
