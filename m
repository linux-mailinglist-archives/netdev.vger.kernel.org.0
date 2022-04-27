Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6169051252C
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 00:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236068AbiD0WU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 18:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiD0WU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 18:20:26 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5CCA496A8;
        Wed, 27 Apr 2022 15:17:13 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 4090B2224E;
        Thu, 28 Apr 2022 00:17:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1651097832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KZxv+ND74jZFakl/W5jjwXzeN0ncd5RrSaX/5eCEVgA=;
        b=B67NSfE4oeqpT1dv3/7Wx1liIee+2qOveDspLbFHeBGtZUqKWhOlvbcBalqaA5+6MZR4Yc
        e+t0SkNIIb3wLH46nZmPtN9XcXj1O8ecvTAKo0SJJ6a1xNRpUkexqYzE1JlIhhVg2Pkj6k
        shA3Vnp29YarqdbrTqqYb/02hYT1ly0=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 28 Apr 2022 00:17:12 +0200
From:   Michael Walle <michael@walle.cc>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1 3/3] net: phy: micrel: add coma mode GPIO
In-Reply-To: <cef1c3f7-06e3-f0dd-10ce-513f35fef3d0@gmail.com>
References: <20220427214406.1348872-1-michael@walle.cc>
 <20220427214406.1348872-4-michael@walle.cc>
 <652a5d64-4f06-7ac8-a792-df0a4b43686f@gmail.com>
 <635fd80542e089722e506bba0ff390ff@walle.cc>
 <cef1c3f7-06e3-f0dd-10ce-513f35fef3d0@gmail.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <c9214b4cdf308b951a2da797898f3dcd@walle.cc>
X-Sender: michael@walle.cc
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-04-28 00:12, schrieb Florian Fainelli:
> On 4/27/22 15:08, Michael Walle wrote:
>> Am 2022-04-28 00:06, schrieb Florian Fainelli:
>>> On 4/27/2022 2:44 PM, Michael Walle wrote:
>>>> The LAN8814 has a coma mode pin which puts the PHY into isolate and
>>>> power-dowm mode. Unfortunately, the mode cannot be disabled by a
>> s/dowm/down/
>> 
>>>> register. Usually, the input pin has a pull-up and connected to a 
>>>> GPIO
>>>> which can then be used to disable the mode. Try to get the GPIO and
>>>> deassert it.
>>> 
>>> Poor choice of word, how about deep sleep, dormant, super isolate?
>> 
>> Which one do you mean? Super isolate sounded like broadcom wording ;)
> 
> Coma is not a great term to use IMHO. Yes Super isolate (tm) is a
> Broadcom thing, and you can come out of super isolate mode with
> register writes, so maybe not the best suggestion.

I didn't come up with that name. It's all in the datasheets and it's
actually already used grep for "COMA_MODE" in phy/mscc. (Yes on that
one you can actually disable it with register access..). Even if
it is not a great name (which I agree), I'd use the same naming as
the datasheet and esp. the pin name.

-michael
