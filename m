Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 916E054EA33
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 21:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378314AbiFPTfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 15:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349272AbiFPTfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 15:35:09 -0400
Received: from smtp.smtpout.orange.fr (smtp08.smtpout.orange.fr [80.12.242.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F401579AB
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 12:35:08 -0700 (PDT)
Received: from [192.168.1.18] ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id 1vGioIvR7NUm11vGionD4h; Thu, 16 Jun 2022 21:35:06 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Thu, 16 Jun 2022 21:35:06 +0200
X-ME-IP: 90.11.190.129
Message-ID: <70ea2718-4979-5587-7f31-2361ae3ff8ad@wanadoo.fr>
Date:   Thu, 16 Jun 2022 21:35:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v2] p54: Fix an error handling path in p54spi_probe()
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Christian Lamparter <chunkeey@gmail.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
References: <297d2547ff2ee627731662abceeab9dbdaf23231.1655068321.git.christophe.jaillet@wanadoo.fr>
 <CAAd0S9DgctqyRx+ppfT6dNntUR-cpySnsYaL=unboQ+qTK2wGQ@mail.gmail.com>
 <f13c3976-2ba0-e16d-0853-5b5b1be16d11@wanadoo.fr>
 <df6b487b-b8b7-44fc-7c2d-e6fd15072c14@gmail.com>
 <20220616103640.GB16517@kadam>
 <9fa854e1-ad88-9c18-ca68-5709dc1c7906@gmail.com>
 <20220616151948.GD16517@kadam>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20220616151948.GD16517@kadam>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 16/06/2022 à 17:19, Dan Carpenter a écrit :
> On Thu, Jun 16, 2022 at 03:13:26PM +0200, Christian Lamparter wrote:
>> On 16/06/2022 12:36, Dan Carpenter wrote:
>>>>> If it deserves a v3 to axe some lines of code, I can do it but, as said
>>>>> previously,
>>>>> v1 is for me the cleaner and more future proof.
>>>>
>>>> Gee, that last sentence about "future proof" is daring.
>>>
>>> The future is vast and unknowable but one thing which is pretty likely
>>> is that Christophe's patch will introduce a static checker warning.  We
>>> really would have expected a to find a release_firmware() in the place
>>> where it was in the original code.  There is a comment there now so no
>>> one is going to re-add the release_firmware() but that's been an issue
>>> in the past.
>>>
>>> I'm sort of surprised that it wasn't a static checker warning already.
>>> Anyway, I'll add this to Smatch check_unwind.c
>>>
>>> +         { "request_firmware", ALLOC, 0, "*$", &int_zero, &int_zero},
>>> +         { "release_firmware", RELEASE, 0, "$"},
>>
>> hmm? I don't follow you there. Why should there be a warning "now"?
>> (I assume you mean with v2 but not with v1?).
> 
> Yep.  Generally, static checkers assume that functions clean up after
> themselves on error paths so there would be a warning in
> p54spi_request_firmware().  This is the easiest kind of static analysis
> to implement and it's the way most kernel error handling is written.
> 
>> If it's because the static
>> checker can't look beyond the function scope then this would be bad news
>> since on the "success" path the firmware will stick around until
>> p54spi_remove().
> 
> Presumably Christophe found this bug with static analysis already but

True, I use a coccinelle script that looks at functions called in 
.remove() functions that are not called in what looks like an error 
handling path in the corresponding probe.

> my guess is that it has a lot of false positives?

This is SOOOO true !
The output is 23k LoC, mostly false positive!

In fact I only checks the diff between the outputs of my coccinelle 
script from time to time.

Looking at only the diff, most of the false positives get ignored and I 
manage to spot ~5-10 issues of this kind in each dev cycle in new code.

CJ

> 
> Eventually the leak in the probe function would be found with static
> analysis as well.  The truth is that there are a lot of leaks so I'm
> already a bit overwhelmed fixing the ones that I know about.
> 
> It would be fairly simple to make a high quality resource leak checker
> which is specific to probe functions.  But the thing is that leaks in
> probe functions are not really exploitable.  Also some devices are
> needed for the system to boot so often the devs don't care about about
> cleaning up...  My motivation is low.
> 
> regards,
> dan carpenter
> 
> 

