Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9196150F9DD
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 12:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348649AbiDZKOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 06:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348524AbiDZKNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 06:13:22 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE38422815E;
        Tue, 26 Apr 2022 02:36:04 -0700 (PDT)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KncBQ6f6Cz6GD0N;
        Tue, 26 Apr 2022 17:33:18 +0800 (CST)
Received: from [10.122.132.241] (10.122.132.241) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Tue, 26 Apr 2022 11:36:00 +0200
Message-ID: <fa5f59e9-0abf-3238-87f5-55a8f3a22131@huawei.com>
Date:   Tue, 26 Apr 2022 12:35:59 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [RFC PATCH v4 10/15] seltest/landlock: add tests for bind() hooks
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>, <anton.sirazetdinov@huawei.com>
References: <20220309134459.6448-1-konstantin.meskhidze@huawei.com>
 <20220309134459.6448-11-konstantin.meskhidze@huawei.com>
 <d3340ed0-fe61-3f00-d7ba-44ece235a319@digikod.net>
 <491d6e96-4bfb-ed97-7eb8-fb18aa144d64@huawei.com>
 <6f631d7c-a2e3-20b3-997e-6b533b748767@digikod.net>
 <2958392e-ba3e-453e-415b-c3869523ea25@huawei.com>
 <0b0ddf78-12fa-ab52-ba3a-c819ed9d2ccd@digikod.net>
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
In-Reply-To: <0b0ddf78-12fa-ab52-ba3a-c819ed9d2ccd@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhreml752-chm.china.huawei.com (10.201.108.202) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,URI_DOTEDU autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



4/8/2022 7:41 PM, Mickaël Salaün пишет:
> 
> On 06/04/2022 16:12, Konstantin Meskhidze wrote:
>>
>>
>> 4/4/2022 12:44 PM, Mickaël Salaün пишет:
>>>
>>> On 04/04/2022 10:28, Konstantin Meskhidze wrote:
>>>>
>>>>
>>>> 4/1/2022 7:52 PM, Mickaël Salaün пишет:
>>>
>>> [...]
>>>
>>>>>> +static int create_socket(struct __test_metadata *const _metadata)
>>>>>> +{
>>>>>> +
>>>>>> +        int sockfd;
>>>>>> +
>>>>>> +        sockfd = socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, 0);
>>>>>> +        ASSERT_LE(0, sockfd);
>>>>>> +        /* Allows to reuse of local address */
>>>>>> +        ASSERT_EQ(0, setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, 
>>>>>> &one, sizeof(one)));
>>>>>
>>>>> Why is it required?
>>>>
>>>>    Without SO_REUSEADDR there is an error that a socket's port is in 
>>>> use.
>>>
>>> I'm sure there is, but why is this port reused? I think this means 
>>> that there is an issue in the tests and that could hide potential 
>>> issue with the tests (and then with the kernel code). Could you 
>>> investigate and find the problem? This would make these tests reliable.
>>    The next scenario is possible here:
>>    "In order for a network connection to close, both ends have to send 
>> FIN (final) packets, which indicate they will not send any additional 
>> data, and both ends must ACK (acknowledge) each other's FIN packets. 
>> The FIN packets are initiated by the application performing a close(), 
>> a shutdown(), or an exit(). The ACKs are handled by the kernel after 
>> the close() has completed. Because of this, it is possible for the 
>> process to complete before the kernel has released the associated 
>> network resource, and this port cannot be bound to another process 
>> until the kernel has decided that it is done."
>> https://hea-www.harvard.edu/~fine/Tech/addrinuse.html.
>>
>> So in this case we have busy port in network selfttest and one of the 
>> solution is to set SO_REUSEADDR socket option, "which explicitly 
>> allows a process to bind to a port which remains in TIME_WAIT (it 
>> still only allows a single process to be bound to that port). This is 
>> the both the simplest and the most effective option for reducing the 
>> "address already in use" error".
> 
> In know what this option does, but I'm wondering what do you need it for 
> these tests: which specific line requires it and why? Isn't it a side 
> effect of running partial tests? I'm worried that this hides some issues 
> in the tests that may make them flaky.
> 
   I need it cause we have a possibility here that process (launching 
tests) has to wait the kernel's releasing the associated network socket 
after closing it.
> 
>>>
>>> Without removing the need to find this issue, the next series should 
>>> use a network namespace per test, which will confine such issue from 
>>> other tests and the host.
>>
>>    So there are 2 options here:
>>      1. Using SO_REUSEADDR option
>>      2. Using network namespace.
>>
>> I prefer the first option - "the simplest and the most effective one"
> 
> If SO_REUSEADDR is really required (and justified), then it should be 
> used. Either it is required or not, we should use a dedicated network 
> namespace for each test anyway. This enables to not mess with the host 
> and not be impacted by it neither (e.g. if some process already use such 
> ports).
> 
   Ok. I update the code.
> 
>>
>>>
>>> [...]
> .
