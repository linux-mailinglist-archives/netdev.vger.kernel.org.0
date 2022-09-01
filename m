Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 066515A99C2
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 16:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233916AbiIAOLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 10:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233291AbiIAOLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 10:11:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE6A62A9A
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 07:11:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62B7261B11
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 14:11:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9382BC433D7;
        Thu,  1 Sep 2022 14:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662041499;
        bh=rCxD3L+pW8tdPE9AqU6Z/sBqU0qpk4kAIRr3S522oUs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=BvYTzjXbWI6n06ED5BZ30UEwUNCvDLWo3vPHY/7ARo0DRBUMqOMQvTCX2Z9i3xucq
         IdzsnG7sDO6XBil1pDZk2DkGqwLm3Q3rt9KzYT/eLCBLP1KN2t/ABYEivD01wIJ/Js
         qLKN2YVyXhh7t2Gkwk3W0CUFFTCSleZnZChwoEQI6eVqzBerh7Nm9gSz2iHCJQM4o9
         Pv8fr1DbXn+nX6Nifc2SMhxB108IlypSYnAPIa9ycYA4/pDYEFQQLnQB1VP4jKWXOO
         f01R8LW8Ss2bPeUSpM+pBi7FHoKJD55Zr5q6nya8e+8P1xoBwTVrc9eqCMBUYIVeGZ
         ui/Jf2Wre/ITQ==
Message-ID: <3b367f43-7081-18d6-128a-6ad8998099b3@kernel.org>
Date:   Thu, 1 Sep 2022 08:11:38 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH main v2 1/2] macsec: add extended packet number (XPN)
 support
Content-Language: en-US
To:     Emeel Hakim <ehakim@nvidia.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>
Cc:     Tariq Toukan <tariqt@nvidia.com>, Raed Salem <raeds@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20220824091752.25414-1-ehakim@nvidia.com>
 <07bc7668-3107-bea2-58e0-75a77af57f7c@kernel.org>
 <IA1PR12MB6353F9B26B5141F5F6F1EC82AB7B9@IA1PR12MB6353.namprd12.prod.outlook.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <IA1PR12MB6353F9B26B5141F5F6F1EC82AB7B9@IA1PR12MB6353.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/1/22 6:54 AM, Emeel Hakim wrote:
>> -----Original Message-----
>> From: David Ahern <dsahern@kernel.org>
>> Sent: Thursday, 1 September 2022 5:53
>> To: Emeel Hakim <ehakim@nvidia.com>; sd@queasysnail.net
>> Cc: Tariq Toukan <tariqt@nvidia.com>; Raed Salem <raeds@nvidia.com>;
>> netdev@vger.kernel.org
>> Subject: Re: [PATCH main v2 1/2] macsec: add extended packet number (XPN)
>> support
>>
>>
>>
>> On 8/24/22 3:17 AM, Emeel Hakim wrote:
>>> @@ -174,14 +181,34 @@ static int parse_sa_args(int *argcp, char
>>> ***argvp, struct sa_desc *sa)
>>>
>>>       while (argc > 0) {
>>>               if (strcmp(*argv, "pn") == 0) {
>>> -                     if (sa->pn != 0)
>>> +                     if (sa->pn.pn32 != 0)
>>
>> pn64 to cover the entire range? ie., pn and xpn on the same command line.
> 
> Didn’t really get the comment if to have "pn" as the only parameter in the command line or just to save all the packet numbers in a 64-bit variable and preserve the current API , can you please elaborate?
> please notice that kernel has a check for the pn length , it expects 32 bits in case of none extended packet number (xpn), hence passing 64-bit in case of none xpn will fail.  Xpn is a secure channel property where pn is an SA property so during the parsing of the SA command line (which includes the pn) I don’t have a legit way to distinguish between xpn or none xpn cases hence the separation.

you are checking for duplicate pn argument. My comment is that if you
check sa->pn.pn64 you can check for a duplicate xpn and pn where a
command line has an xpn argument with the upper 32bits set folllowed by
a pn argument.

> 
>>
>>>                               duparg2("pn", "pn");
>>>                       NEXT_ARG();
>>> -                     ret = get_u32(&sa->pn, *argv, 0);
>>> +                     ret = get_u32(&sa->pn.pn32, *argv, 0);
>>>                       if (ret)
>>>                               invarg("expected pn", *argv);
>>> -                     if (sa->pn == 0)
>>> +                     if (sa->pn.pn32 == 0)
>>>                               invarg("expected pn != 0", *argv);
>>> +             } else if (strcmp(*argv, "xpn") == 0) {
>>> +                     if (sa->pn.pn64 != 0)
>>> +                             duparg2("xpn", "xpn");

this check right here but above for the "pn" case.


>>> +                     NEXT_ARG();
>>> +                     ret = get_u64(&sa->pn.pn64, *argv, 0);
>>> +                     if (ret)
>>> +                             invarg("expected pn", *argv);
>>> +                     if (sa->pn.pn64 == 0)
>>> +                             invarg("expected pn != 0", *argv);
>>> +                     sa->xpn = true;
>>> +             } else if (strcmp(*argv, "salt") == 0) {
>>> +                     unsigned int len;
>>> +
>>> +                     NEXT_ARG();
>>> +                     if (!hexstring_a2n(*argv, sa->salt, MACSEC_SALT_LEN,
>>> +                                        &len))
>>> +                             invarg("expected salt", *argv);

