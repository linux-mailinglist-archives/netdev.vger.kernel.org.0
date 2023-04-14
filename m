Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 954486E2521
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 16:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjDNOG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 10:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjDNOG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 10:06:27 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF2ABB750
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 07:06:02 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pnK27-0007By-7l; Fri, 14 Apr 2023 16:04:11 +0200
Message-ID: <d6990d00-6fd5-cd89-755d-d7f566c574fa@leemhuis.info>
Date:   Fri, 14 Apr 2023 16:04:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
Subject: Re: [PATCH net] bgmac: fix *initial* chip reset to support BCM5358
Content-Language: en-US, de-DE
To:     Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        =?UTF-8?Q?Ricardo_Ca=c3=b1uelo?= <ricardo.canuelo@collabora.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        Jon Mason <jdmason@kudzu.us>,
        Linux kernel regressions list <regressions@lists.linux.dev>
References: <20230227091156.19509-1-zajec5@gmail.com>
 <20230404134613.wtikjp6v63isofoc@rcn-XPS-13-9305>
 <002c1f96-b82f-6be7-2530-68c5ae1d962d@milecki.pl>
 <b7b11a57-9512-cda9-1b15-5dd5aa12f162@gmail.com>
From:   "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
In-Reply-To: <b7b11a57-9512-cda9-1b15-5dd5aa12f162@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1681481163;d4d6c74e;
X-HE-SMSGID: 1pnK27-0007By-7l
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.04.23 14:42, Florian Fainelli wrote:
> On 4/4/2023 6:52 AM, Rafał Miłecki wrote:

>> On 4.04.2023 15:46, Ricardo Cañuelo wrote:
>>> On mar 07-02-2023 23:53:27, Rafał Miłecki wrote:
>>>> While bringing hardware up we should perform a full reset including the
>>>> switch bit (BGMAC_BCMA_IOCTL_SW_RESET aka SICF_SWRST). It's what
>>>> specification says and what reference driver does.
>>>>
>>>> This seems to be critical for the BCM5358. Without this hardware
>>>> doesn't
>>>> get initialized properly and doesn't seem to transmit or receive any
>>>> packets.
>>>>
>>>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>>>
>>> KernelCI found this patch causes a regression in the
>>> bootrr.deferred-probe-empty test [1] on sun8i-h3-libretech-all-h3-cc
>>> [2], see the bisection report for more details [3]
>>>
>>> Does it make sense to you?
>>
>> It doesn't seem to make any sense. I guess that on your platform
>> /sys/kernel/debug/devices_deferred
>> is not empty anymore?
>>
>> Does your platform use Broadcom Ethernet controller at all?
> 
> I do not believe it does, however according to the log, the driver is
> enabled:
> 
> <6>[    1.819466] bgmac_bcma: Broadcom 47xx GBit MAC driver loaded
> 
> but it should not be probing any device since you don't have any
> internal BCMA bus to match gigabit devices with. Later in the log we see:
> 
> 1c22c00.codec    sun4i-codec: Failed to register our card
> 
> and most likely as you already wrote the deferred device list might not
> be empty.

What happened to this? It seems there wasn't any progress since above
mail week. But well, seems to be a odd issue anyway (is that one of
those issues that CI systems find, but don't cause practical issues in
the field?). Hence: can somebody with more knowledge about this please
tell if it this is something I can likely drop from the list of tacked
regressions?

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.

#regzbot poke
