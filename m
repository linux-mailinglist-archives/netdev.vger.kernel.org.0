Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB2B6E0F2F
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 15:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbjDMNtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 09:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbjDMNti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 09:49:38 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D996120;
        Thu, 13 Apr 2023 06:49:34 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pmxKN-0006cO-K0; Thu, 13 Apr 2023 15:49:31 +0200
Message-ID: <87264550-91eb-2d41-e3f3-c3a51425d7a4@leemhuis.info>
Date:   Thu, 13 Apr 2023 15:49:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Content-Language: en-US, de-DE
To:     Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>
Cc:     Linux regressions mailing list <regressions@lists.linux.dev>,
        Saeed Mahameed <saeed@kernel.org>,
        Shay Drory <shayd@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        selinux@vger.kernel.org
References: <CAHC9VhQ7A4+msL38WpbOMYjAqLp0EtOjeLh4Dc6SQtD6OUvCQg@mail.gmail.com>
 <ZCS5oxM/m9LuidL/@x130>
 <CAHC9VhTvQLa=+Ykwmr_Uhgjrc6dfi24ou=NBsACkhwZN7X4EtQ@mail.gmail.com>
 <1c8a70fc-18cb-3da7-5240-b513bf1affb9@leemhuis.info>
 <CAHC9VhT+=DtJ1K1CJDY4=L_RRJSGqRDvnaOdA6j9n+bF7y+36A@mail.gmail.com>
 <20230410054605.GL182481@unreal>
From:   "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
Subject: Re: Potential regression/bug in net/mlx5 driver
In-Reply-To: <20230410054605.GL182481@unreal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1681393775;b250e971;
X-HE-SMSGID: 1pmxKN-0006cO-K0
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10.04.23 07:46, Leon Romanovsky wrote:
> On Sun, Apr 09, 2023 at 07:50:34PM -0400, Paul Moore wrote:
>> On Sun, Apr 9, 2023 at 4:48 AM Linux regression tracking (Thorsten
>> Leemhuis) <regressions@leemhuis.info> wrote:
>>> On 30.03.23 03:27, Paul Moore wrote:
>>>> On Wed, Mar 29, 2023 at 6:20 PM Saeed Mahameed <saeed@kernel.org> wrote:
>>>>> On 28 Mar 19:08, Paul Moore wrote:
>>>>>>
>>>>>> Starting with the v6.3-rcX kernel releases I noticed that my
>>>>>> InfiniBand devices were no longer present under /sys/class/infiniband,
>>>>>> causing some of my automated testing to fail.  It took me a while to
>>>>>> find the time to bisect the issue, but I eventually identified the
>>>>>> problematic commit:
>>>>>>
>>>>>>  commit fe998a3c77b9f989a30a2a01fb00d3729a6d53a4
>>>>>>  Author: Shay Drory <shayd@nvidia.com>
>>>>>>  Date:   Wed Jun 29 11:38:21 2022 +0300
>>>>>>
>>>>>>   net/mlx5: Enable management PF initialization
>>>>>>
>>>>>>   Enable initialization of DPU Management PF, which is a new loopback PF
>>>>>>   designed for communication with BMC.
>>>>>>   For now Management PF doesn't support nor require most upper layer
>>>>>>   protocols so avoid them.
>>>>>>
>>>>>>   Signed-off-by: Shay Drory <shayd@nvidia.com>
>>>>>>   Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
>>>>>>   Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
>>>>>>   Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
>>>>>>
>>>>>> I'm not a mlx5 driver expert so I can't really offer much in the way
>>>>>> of a fix, but as a quick test I did remove the
>>>>>> 'mlx5_core_is_management_pf(...)' calls in mlx5/core/dev.c and
>>>>>> everything seemed to work okay on my test system (or rather the tests
>>>>>> ran without problem).
>>>>>>
>>>>>> If you need any additional information, or would like me to test a
>>>>>> patch, please let me know.
>>>>>
>>>>> Our team is looking into this, the current theory is that you have an old
>>>>> FW that doesn't have the correct capabilities set.
>>>>
>>>> That's very possible; I installed this card many years ago and haven't
>>>> updated the FW once.
>>>>
>>>>  I'm happy to update the FW (do you have a
>>>> pointer/how-to?), but it might be good to identify a fix first as I'm
>>>> guessing there will be others like me ...
>>>
>>> Nothing happened here for about ten days afaics (or was there progress
>>> and I just missed it?). That made me wonder: how sound is Paul's guess
>>> that there will be others that might run into this? If that's likely it
>>> afaics would be good to get this regression fixed before the release,
>>> which is just two or three weeks away.
>>>
>>> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
>>> --
>>> Everything you wanna know about Linux kernel regression tracking:
>>> https://linux-regtracking.leemhuis.info/about/#tldr
>>> If I did something stupid, please tell me, as explained on that page.
>>>
>>> #regzbot poke
>>
>> I haven't seen any updates from the mlx5 driver folks, although I may
>> not have been CC'd?
> 
> We are extremely slow these days due to combination of holidays
> (Easter, Passover, Ramadan, spring break e.t.c).

That's how it is sometimes, no worries. But well, rc7 is only a three
days away and 6.3 thus might be out in 10 days already. Hence allow me
to ask: is it possible to fix this by reverting the culprit now (and
reapplying it later in fixed form). If that's and option I'd say "go for
it", to ensure that revert makes it into rc7 and thus is tested at least
one week before the final (or two, if Linus decides to do a rc8).

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.

#regzbot poke
