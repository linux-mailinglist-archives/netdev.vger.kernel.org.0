Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 810ED6E2DEC
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 02:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbjDOA3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 20:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjDOA3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 20:29:14 -0400
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EAAB3A96
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 17:29:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1681518540; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=VdsVP3HF/0RejTKXM5VQcgHqSL8JwjklMBRaEoEE8IB9l4NQS/E9sL1ruk5aVU+zrBTBL3dzGBzAYARjRYTgXA2HzoPydJIW6WEtXJs1dPlU2saY039uTEO9PiZEgU4zUHD6oETvNG9MrBe9Ew3sn0vNA40lwwd983HF7vvrnGo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1681518540; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=gWpiuzsjlS7oQ2x64nX7WNs8Hq6acAgUOyLKjKAbC1w=; 
        b=Kw7ap2u/GDrzSyyanEfSXgSM5tcme7u/ckotdeF6idIPFEZc3kZjiJM8qgpyQumnF4sn7T64vG8lir8kx9flD9Hmkjf9nsjyGrFtvncqB63/ij5DOkzl5vETPLGHRStx9wG+vXqYE0EQ2TVwdwcrBxoiOrAit7UKPQT+73WVkfY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1681518540;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=gWpiuzsjlS7oQ2x64nX7WNs8Hq6acAgUOyLKjKAbC1w=;
        b=Iq7MUZXGPmbNk20mrUkwM/ayCpXQMCh19Ra5jS5ldMCQt8t7GKn81XfxUmmW70yo
        39b+uWN8oV7YmGvj6k5JJFPkNuqebd79lIcU53y04p++iwn65LMVoVw8sWBso4w+k0e
        AriQlwgZ2LjV7yUMdDF6i1yXWkYqiIbA+2g8bVtM=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1681518538909637.2529189698847; Fri, 14 Apr 2023 17:28:58 -0700 (PDT)
Message-ID: <5e10f823-88f1-053a-d691-6bc900bd85a6@arinc9.com>
Date:   Sat, 15 Apr 2023 03:28:55 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: mt7530: dsa_switch_parse_of() fails, causes probe code to run
 twice
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com
References: <896514df-af33-6408-8b33-d8fd06e671ef@arinc9.com>
 <ZDnYSVWTUe5NCd1w@makrotopia.org>
 <e10aa146-c307-8a14-3842-ae50ceabf8cc@arinc9.com>
 <ZDnnjcG5uR9gQrUb@makrotopia.org>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <ZDnnjcG5uR9gQrUb@makrotopia.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.04.2023 02:53, Daniel Golle wrote:
> On Sat, Apr 15, 2023 at 02:23:16AM +0300, Arınç ÜNAL wrote:
>> On 15.04.2023 01:48, Daniel Golle wrote:
>>> On Sat, Apr 15, 2023 at 01:41:07AM +0300, Arınç ÜNAL wrote:
>>>> Hey there,
>>>>
>>>> I've been working on the MT7530 DSA subdriver. While doing some tests, I
>>>> realised mt7530_probe() runs twice. I moved enabling the regulators from
>>>> mt7530_setup() to mt7530_probe(). Enabling the regulators there ends up
>>>> with exception warnings on the first time. It works fine when
>>>> mt7530_probe() is run again.
>>>>
>>>> This should not be an expected behaviour, right? Any ideas how we can make
>>>> it work the first time?
>>>
>>> Can you share the patch or work-in-progress tree which will allow me
>>> to reproduce this problem?
>>
>> I tested this on vanilla 6.3-rc6. There's just the diff below that is
>> applied. I encountered it on the standalone MT7530 on my Bananapi BPI-R2. I
>> haven't tried it on MCM MT7530 on MT7621 SoC yet.
>>
>>>
>>> It can of course be that regulator driver has not yet been loaded on
>>> the first run and -EPROBE_DEFER is returned in that case. Knowing the
>>> value of 'err' variable below would hence be valuable information.
>>
>> Regardless of enabling the regulator on either mt7530_probe() or
>> mt7530_setup(), dsa_switch_parse_of() always fails.
> 
> So dsa_switch_parse_of() can return -EPROBE_DEFER if the ethernet
> driver responsible for the CPU port has not yet been loaded.
> 
> See net/dsa/dsa.c (inside function dsa_port_parse_of):
> [...]
> 1232)                master = of_find_net_device_by_node(ethernet);
> 1233)                of_node_put(ethernet);
> 1234)                if (!master)
> 1235)                        return -EPROBE_DEFER;
> [...]
> 
> Hence it would be important to include the value of 'err' in your
> debugging printf output, as -EPROBE_DEFER can be an expected and
> implicitely intended reality and nothing is wrong then.

Thanks Daniel. I can't do more tests soon but this is probably what's 
going on as the logs already indicate that the MediaTek ethernet driver 
was yet to load.

As acknowledged, since running the MT7530 DSA subdriver from scratch is 
expected if the ethernet driver is not loaded yet, there's not really a 
problem. Though the switch is reset twice in a short amount of time. I 
don't think that's very great.

The driver initialisation seems serialised (at least for the drivers 
built into the kernel) as I tried sleeping for 5 seconds on 
mt7530_probe() but no other driver was loaded in the meantime so I got 
the same behaviour.

The regulator code will cause a long and nasty exception the first time. 
Though there's nothing wrong as it does what it's supposed to do on the 
second run. I'm not sure if that's negligible.

Could we at least somehow make the MT7530 DSA subdriver wait until the 
regulator driver is loaded?

Arınç
