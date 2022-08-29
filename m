Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF1B05A44E8
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 10:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbiH2IWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 04:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiH2IWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 04:22:11 -0400
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85FCB558D0;
        Mon, 29 Aug 2022 01:22:09 -0700 (PDT)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id C076F38F;
        Mon, 29 Aug 2022 10:22:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1661761327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aWdMO7HBaULAwUHXrb+Mf/kwJlQruPZflZyMNyYcZy4=;
        b=CD3VkiRpKq0rQSPmmXnVXYP8HnHoxnx+bT+s2OvBKmt9f+8sFGH65IjJMd7coGj0rRqGo/
        NvdsJOR8IGTHkWeA2w8ZOaNVa6f8f2gBt+641QwWTeUbpb90BJnWTmhimh6YTBOmILZte4
        2FoGkGQKq9xDiH2ByQu2PMODzhtYG7EuE70HO/DLaJcBHDrk0b2/QHfjAQkn7msTBCI7e/
        FUbwj6tQ3/INVlIkQeWiWNbwsaJp/xji6fE4QeCcbRF7TtTItcfSBbd+yDz0W7cKwdQ4IQ
        Ez27rLoMsce/IEQ2PPZlAwXzYnEQuq8b8BakidZVHJQACEKlpI+tmYC7I3se5Q==
MIME-Version: 1.0
Date:   Mon, 29 Aug 2022 10:22:07 +0200
From:   Michael Walle <michael@walle.cc>
To:     =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Frank Rowand <frowand.list@gmail.com>,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>
Subject: Re: [PATCH v1 00/14] nvmem: core: introduce NVMEM layouts
In-Reply-To: <768ff63a-54f5-9cde-e888-206cdf018df3@milecki.pl>
References: <20220825214423.903672-1-michael@walle.cc>
 <768ff63a-54f5-9cde-e888-206cdf018df3@milecki.pl>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <267821eee5dcab79fd0ecebe0d9f8b0c@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Am 2022-08-28 17:05, schrieb Rafał Miłecki:
> On 25.08.2022 23:44, Michael Walle wrote:
>> This is now the third attempt to fetch the MAC addresses from the VPD
>> for the Kontron sl28 boards. Previous discussions can be found here:
>> https://lore.kernel.org/lkml/20211228142549.1275412-1-michael@walle.cc/
>> 
>> 
>> NVMEM cells are typically added by board code or by the devicetree. 
>> But
>> as the cells get more complex, there is (valid) push back from the
>> devicetree maintainers to not put that handling in the devicetree.
> 
> I dropped the ball waiting for Rob's reponse in the
> [PATCH 0/2] dt-bindings: nvmem: support describing cells
> https://lore.kernel.org/linux-arm-kernel/0b7b8f7ea6569f79524aea1a3d783665@walle.cc/T/
> 
> Before we go any further can we have a clear answer from Rob (or
> Krzysztof now too?):
> 
> 
> Is there any point in having bindings like:
> 
> compatible = "mac-address";
> 
> for NVMEM cells nodes? So systems (Linux, U-Boot) can handle them in a
> more generic way?
> 
> 
> Or do we prefer more conditional drivers code (or layouts code as in
> this Michael's proposal) that will handle cells properly based on their
> names?

What do you mean by "based on their names?".

> I'm not arguing for any solution. I just want to make sure we choose 
> the
> right way to proceed.

With the 'compatible = "mac-address"', how would you detect what kind
of transformation you need to apply? You could guess ascii, yes. But
swapping bytes? You cannot guess that. So you'd need additional 
information
coming from the device tree. But Rob was quite clear that this shouldn't
be in the device tree:

| I still don't think trying to encode transformations of data into the 
DT
| is right approach.

https://lore.kernel.org/linux-devicetree/YaZ5JNCFeKcdIfu8@robh.at.kernel.org/

He also mention that the compatible should be on the nvmem device level
and should use specific compatible strings:
https://lore.kernel.org/linux-devicetree/CAL_JsqL55mZJ6jUyQACer2pKMNDV08-FgwBREsJVgitnuF18Cg@mail.gmail.com/

And IMHO that makes sense, because it matches the hardware and not any
NVMEM cells which is the *content* of a memory device.

And as you see in the sl28vpd layout, it allows you to do much more, 
like
checking for integrity, and make it future proof by supporting different
versions of this sl28vpd layout.

What if you use it with the u-boot,env? You wouldn't need it because
u-boot,env will already know how to interpret it as an ascii string
(and it also know the offset). In this sense, u-boot,env is already a
compatible string describing the content of a NVMEM device (and the
compatible string is at the device level).

>> Therefore, introduce NVMEM layouts. They operate on the NVMEM device 
>> and
>> can add cells during runtime. That way it is possible to add complex
>> cells than it is possible right now with the offset/length/bits
>> description in the device tree. For example, you can have post 
>> processing
>> for individual cells (think of endian swapping, or ethernet offset
>> handling). You can also have cells which have no static offset, like 
>> the
>> ones in an u-boot environment. The last patches will convert the 
>> current
>> u-boot environment driver to a NVMEM layout and lifting the 
>> restriction
>> that it only works with mtd devices. But as it will change the 
>> required
>> compatible strings, it is marked as RFC for now. It also needs to have
>> its device tree schema update which is left out here.
> 
> So do I get it right that we want to have:
> 
> 1. NVMEM drivers for providing I/O access to NVMEM devices
> 2. NVMEM layouts for parsing & NVMEM cells and translating their 
> content
> ?

Correct.

> I guess it sounds good and seems to be a clean solution.

Good to hear :)

> One thing I believe you need to handle is replacing "cell_post_process"
> callback with your layout thing.
> 
> I find it confusing to have
> 1. cell_post_process() CB at NVMEM device level
> 2. post_process() CB at NVMEM cell level

What is wrong with having a callback at both levels?

Granted, in this particular case (it is just used at one place), I still
think that it is the wrong approach to add this transformation in the
driver (in this particular case). The driver is supposed to give you
access to the SoC's fuse box, but it will magically change the content
of a cell if the nvmem consumer named this cell "mac-address" (which
you also found confusing the last time and I do too!).

The driver itself doesn't add any cells on its own, so I cannot register
a .post_process hook there. Therefore, you'd need that post_process hook
on every cell, which is equivalent to have a post_process hook at
device level.

Unless you have a better idea. I'll leave that up to NXP to fix that (or
leave it like that).

-michael
