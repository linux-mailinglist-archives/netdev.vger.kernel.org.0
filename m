Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 625BE4F9ADE
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 18:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbiDHQoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 12:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233492AbiDHQoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 12:44:02 -0400
Received: from smtp-42ac.mail.infomaniak.ch (smtp-42ac.mail.infomaniak.ch [IPv6:2001:1600:4:17::42ac])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 648FB329B2
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 09:41:57 -0700 (PDT)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4KZkYG2P0pzMprsG;
        Fri,  8 Apr 2022 18:41:54 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4KZkYF5TZDzlhSLv;
        Fri,  8 Apr 2022 18:41:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1649436114;
        bh=8xizND76wRObJpb8aCVKF4BbKb864GvEqQKNfgg74Ms=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=oiQ0KZUK0B445T/NDDrfFHEawqQAYLdl19DKK7nQbFoTUf5LqbrpRpM93R/SSojCS
         DWDXm8L6r9Ads5FR+dHu27xrbNZBWKBDauJ5k00BRGCxojxcaZ56HmPqgyud0G1j+q
         ECNKn4fUewzaeIdW++WotPYHnS1b1L9C+xqd07EM=
Message-ID: <0b0ddf78-12fa-ab52-ba3a-c819ed9d2ccd@digikod.net>
Date:   Fri, 8 Apr 2022 18:41:52 +0200
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com, anton.sirazetdinov@huawei.com
References: <20220309134459.6448-1-konstantin.meskhidze@huawei.com>
 <20220309134459.6448-11-konstantin.meskhidze@huawei.com>
 <d3340ed0-fe61-3f00-d7ba-44ece235a319@digikod.net>
 <491d6e96-4bfb-ed97-7eb8-fb18aa144d64@huawei.com>
 <6f631d7c-a2e3-20b3-997e-6b533b748767@digikod.net>
 <2958392e-ba3e-453e-415b-c3869523ea25@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [RFC PATCH v4 10/15] seltest/landlock: add tests for bind() hooks
In-Reply-To: <2958392e-ba3e-453e-415b-c3869523ea25@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,URI_DOTEDU
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 06/04/2022 16:12, Konstantin Meskhidze wrote:
> 
> 
> 4/4/2022 12:44 PM, Mickaël Salaün пишет:
>>
>> On 04/04/2022 10:28, Konstantin Meskhidze wrote:
>>>
>>>
>>> 4/1/2022 7:52 PM, Mickaël Salaün пишет:
>>
>> [...]
>>
>>>>> +static int create_socket(struct __test_metadata *const _metadata)
>>>>> +{
>>>>> +
>>>>> +        int sockfd;
>>>>> +
>>>>> +        sockfd = socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, 0);
>>>>> +        ASSERT_LE(0, sockfd);
>>>>> +        /* Allows to reuse of local address */
>>>>> +        ASSERT_EQ(0, setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, 
>>>>> &one, sizeof(one)));
>>>>
>>>> Why is it required?
>>>
>>>    Without SO_REUSEADDR there is an error that a socket's port is in 
>>> use.
>>
>> I'm sure there is, but why is this port reused? I think this means 
>> that there is an issue in the tests and that could hide potential 
>> issue with the tests (and then with the kernel code). Could you 
>> investigate and find the problem? This would make these tests reliable.
>    The next scenario is possible here:
>    "In order for a network connection to close, both ends have to send 
> FIN (final) packets, which indicate they will not send any additional 
> data, and both ends must ACK (acknowledge) each other's FIN packets. The 
> FIN packets are initiated by the application performing a close(), a 
> shutdown(), or an exit(). The ACKs are handled by the kernel after the 
> close() has completed. Because of this, it is possible for the process 
> to complete before the kernel has released the associated network 
> resource, and this port cannot be bound to another process until the 
> kernel has decided that it is done."
> https://hea-www.harvard.edu/~fine/Tech/addrinuse.html.
> 
> So in this case we have busy port in network selfttest and one of the 
> solution is to set SO_REUSEADDR socket option, "which explicitly allows 
> a process to bind to a port which remains in TIME_WAIT (it still only 
> allows a single process to be bound to that port). This is the both the 
> simplest and the most effective option for reducing the "address already 
> in use" error".

In know what this option does, but I'm wondering what do you need it for 
these tests: which specific line requires it and why? Isn't it a side 
effect of running partial tests? I'm worried that this hides some issues 
in the tests that may make them flaky.


>>
>> Without removing the need to find this issue, the next series should 
>> use a network namespace per test, which will confine such issue from 
>> other tests and the host.
> 
>    So there are 2 options here:
>      1. Using SO_REUSEADDR option
>      2. Using network namespace.
> 
> I prefer the first option - "the simplest and the most effective one"

If SO_REUSEADDR is really required (and justified), then it should be 
used. Either it is required or not, we should use a dedicated network 
namespace for each test anyway. This enables to not mess with the host 
and not be impacted by it neither (e.g. if some process already use such 
ports).


> 
>>
>> [...]
