Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87CB55A3E27
	for <lists+netdev@lfdr.de>; Sun, 28 Aug 2022 16:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiH1OmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Aug 2022 10:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiH1OmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Aug 2022 10:42:12 -0400
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29FC22E9EA;
        Sun, 28 Aug 2022 07:42:09 -0700 (PDT)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id CD1F022D1;
        Sun, 28 Aug 2022 16:42:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1661697727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dqBAZqXYDvhzoXmHe6e4y35S0OHJDpcUa6j95Hgzs9U=;
        b=oAEZbSk6W/fng85Hmx1hfGvezRZQdnn/W3FvzlQ1CJ2nHzZPXUo68i0K45RNp0KULGblgk
        ZR+kaPBLcDmrgh6MrCqQqzAnUeWsC49R9qT656pA3ziBKJgi5TIBPTMOkdR6QI3gVUJ+pa
        UxxMaMCRXX9RByGYCZADVFuyhd95Jqvks509r6OfaC1teRW0pFDxdEk/EP9xb6R1ddtmEq
        NLANKNnVcXLW4s1v80eTAUSWYUwySN71KTQgl3j4aJ6LOHqw3rv17qPtCdc5bkB6ArM6M5
        pjSok52jP0J63L+38jWEvwCvxbH8QOGp/zequszdEmfw8cDMatcwyWyzr5wlrg==
MIME-Version: 1.0
Date:   Sun, 28 Aug 2022 16:42:07 +0200
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
Subject: Re: [RFC PATCH v1 12/14] nvmem: layouts: rewrite the u-boot-env
 driver as a NVMEM layout
In-Reply-To: <f830543b-9b66-5785-60f8-27ea05d49eee@milecki.pl>
References: <20220825214423.903672-1-michael@walle.cc>
 <20220825214423.903672-13-michael@walle.cc>
 <f830543b-9b66-5785-60f8-27ea05d49eee@milecki.pl>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <3b8a14fe018973dc5450192cce6851e2@walle.cc>
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

Am 2022-08-28 16:04, schrieb Rafał Miłecki:
> On 25.08.2022 23:44, Michael Walle wrote:
>> Instead of hardcoding the underlying access method mtd_read() and
>> duplicating all the error handling, rewrite the driver as a nvmem
>> layout which just uses nvmem_device_read() and thus works with any
>> NVMEM device.
>> 
>> But because this is now not a device anymore, the compatible string
>> will have to be changed so the device will still be probed:
>>    compatible = "u-boot,env";
>> to
>>    compatible = "u-boot,env", "nvmem-cells";
>> 
>> "nvmem-cells" will tell the mtd layer to register a nvmem_device().
>> "u-boot,env" will tell the NVMEM that it should apply the u-boot
>> environment layout to the NVMEM device.
> 
> That's fishy but maybe we can ignore backward compatibility at
> point.

As mentioned in the cover letter, this is why this is an RFC. I
didn't see any users in the device tree, nor can I see how this
would have been used anyway, because you cannot find a cell by
its device tree node, because none is registered. So maybe we
can still change the compatible string.

-michael

> Still you need to update DT binding.

