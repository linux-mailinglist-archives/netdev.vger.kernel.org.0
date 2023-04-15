Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 499DC6E2F96
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 09:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjDOHxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 03:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjDOHxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 03:53:30 -0400
Received: from sender3-op-o18.zoho.com (sender3-op-o18.zoho.com [136.143.184.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73C37DAF
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 00:53:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1681545196; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=PK0PdkX3EC5tkCq+r3xohXyYXhWcsxUGk5bY/kxkUroXzqhXKPBFn2d6P8MozMiJmoqxmF1Knuc6isjpXn0LbRo9EHNwsq8uazaxzdb8jMYVKXaAwX/+NUtMpLnpNMmS5+1hs6l+mfQzT9VHda+E6qNqscbh8cAqH8O9ppf5jXE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1681545196; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=aFcnsmfz5PLB8XQl8YFmR+J/HLgq3s+zJ2iaBDH+VCc=; 
        b=DvKnU6AmCkB3DhajKHOTFhHZ/qz5EJwWHxZDZnwmTQv1aiMUuePE3+msL0gv7fARpFoG3siK8WkpizccolQdc9/yHjv8eDKOHHFDC6erK93X6iuysLxeM0aMImuUmgI2XjXHw8MHLWhnKuPFX88jxJG+i2yp8XbLtJ15upe+dBQ=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1681545196;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=aFcnsmfz5PLB8XQl8YFmR+J/HLgq3s+zJ2iaBDH+VCc=;
        b=ZIgsHYATy7UR2BO0Iwyu+8OA7gsxrec9HoNgEhyU/cyocN58xdIKGJUsC6i4xz/m
        j+29N5/e0m6c2y0FYEH15Cqa91Pyphd7FXjRnG7mO+glTzddveKpYCFHknLl6zU45qr
        7NpVSoskUrs3Yqt+F7VxRf+1EIElF+gLVQlbPJzE=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1681545194945313.3098148334874; Sat, 15 Apr 2023 00:53:14 -0700 (PDT)
Message-ID: <01fe9c85-f1e0-107a-6fb7-e643fb76544e@arinc9.com>
Date:   Sat, 15 Apr 2023 10:53:10 +0300
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
 <5e10f823-88f1-053a-d691-6bc900bd85a6@arinc9.com>
 <ZDn1QabUsyZj6J0M@makrotopia.org>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <ZDn1QabUsyZj6J0M@makrotopia.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.04.2023 03:52, Daniel Golle wrote:
> On Sat, Apr 15, 2023 at 03:28:55AM +0300, Arınç ÜNAL wrote:
>> On 15.04.2023 02:53, Daniel Golle wrote:
>>> On Sat, Apr 15, 2023 at 02:23:16AM +0300, Arınç ÜNAL wrote:
>>>> On 15.04.2023 01:48, Daniel Golle wrote:
>>>>> On Sat, Apr 15, 2023 at 01:41:07AM +0300, Arınç ÜNAL wrote:
>>>>>> Hey there,
>>>>>>
>>>>>> I've been working on the MT7530 DSA subdriver. While doing some tests, I
>>>>>> realised mt7530_probe() runs twice. I moved enabling the regulators from
>>>>>> mt7530_setup() to mt7530_probe(). Enabling the regulators there ends up
>>>>>> with exception warnings on the first time. It works fine when
>>>>>> mt7530_probe() is run again.
>>>>>>
>>>>>> This should not be an expected behaviour, right? Any ideas how we can make
>>>>>> it work the first time?
>>>>>
>>>>> Can you share the patch or work-in-progress tree which will allow me
>>>>> to reproduce this problem?
>>>>
>>>> I tested this on vanilla 6.3-rc6. There's just the diff below that is
>>>> applied. I encountered it on the standalone MT7530 on my Bananapi BPI-R2. I
>>>> haven't tried it on MCM MT7530 on MT7621 SoC yet.
>>>>
>>>>>
>>>>> It can of course be that regulator driver has not yet been loaded on
>>>>> the first run and -EPROBE_DEFER is returned in that case. Knowing the
>>>>> value of 'err' variable below would hence be valuable information.
>>>>
>>>> Regardless of enabling the regulator on either mt7530_probe() or
>>>> mt7530_setup(), dsa_switch_parse_of() always fails.
>>>
>>> So dsa_switch_parse_of() can return -EPROBE_DEFER if the ethernet
>>> driver responsible for the CPU port has not yet been loaded.
>>>
>>> See net/dsa/dsa.c (inside function dsa_port_parse_of):
>>> [...]
>>> 1232)                master = of_find_net_device_by_node(ethernet);
>>> 1233)                of_node_put(ethernet);
>>> 1234)                if (!master)
>>> 1235)                        return -EPROBE_DEFER;
>>> [...]
>>>
>>> Hence it would be important to include the value of 'err' in your
>>> debugging printf output, as -EPROBE_DEFER can be an expected and
>>> implicitely intended reality and nothing is wrong then.
>>
>> Thanks Daniel. I can't do more tests soon but this is probably what's going
>> on as the logs already indicate that the MediaTek ethernet driver was yet to
>> load.
>>
>> As acknowledged, since running the MT7530 DSA subdriver from scratch is
>> expected if the ethernet driver is not loaded yet, there's not really a
>> problem. Though the switch is reset twice in a short amount of time. I don't
>> think that's very great.
> 
> That's true, and we should try to avoid that.
> 
>>
>> The driver initialisation seems serialised (at least for the drivers built
>> into the kernel) as I tried sleeping for 5 seconds on mt7530_probe() but no
>> other driver was loaded in the meantime so I got the same behaviour.
>>
>> The regulator code will cause a long and nasty exception the first time.
>> Though there's nothing wrong as it does what it's supposed to do on the
>> second run. I'm not sure if that's negligible.
>>
>> Could we at least somehow make the MT7530 DSA subdriver wait until the
>> regulator driver is loaded?
> 
> I assume the regulator-related stackdump is unrelated, but caused by
> cpufreq changes, which had now been fixed by commit 0883426fd07e
> ("cpufreq: mediatek: Raise proc and sram max voltage for MT7622/7623").
> 
> If you are using v6.3-rc6 this commit is still missing there, but
> manually picking it from linux-next should fix it.

I did one better and just did the test on the current linux-next, I get 
exceptions that seem to be identical. I also made sure this commit was 
actually there.

> 
> Let me know if I can help with testing on my farm of MediaTek boards.
> I'm a bit nervous about fixing MT7531BE soon, so deciding if we move
> PLL activation to mt7530_probe() would be essential as it makes the
> fix much easier...

Can you test this branch on MT7531AE, MT7531BE and the switch on MT7988 
SoC? I just need to complete the patch logs, the code won't change much.

https://github.com/arinc9/linux/commits/for-netnext

I'm thinking if we can -EPROBE_DEFER right at the start of 
mt7530_probe(), it should prevent the reset code from running twice, and 
enabling the regulator will run without any exceptions.

I think I can just keep enabling the regulator on mt7530_setup() if I 
can't figure that out. On MT7623NI, the switch stops working after 35 
seconds with these logs. As long as the regulator is enabled before 
this, everything keeps working.

[   35.037200] vusb: disabling
[   35.040089] vmc: disabling
[   35.042856] vmch: disabling
[   35.045709] vgp1: disabling
[   35.049010] vcamaf: disabling

Arınç
