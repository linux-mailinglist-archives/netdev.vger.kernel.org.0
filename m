Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A01450F949
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 11:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348036AbiDZJ5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 05:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348051AbiDZJ5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 05:57:37 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CCE275DC;
        Tue, 26 Apr 2022 02:15:41 -0700 (PDT)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Knbkv4bynz67X5R;
        Tue, 26 Apr 2022 17:12:55 +0800 (CST)
Received: from [10.122.132.241] (10.122.132.241) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Tue, 26 Apr 2022 11:15:37 +0200
Message-ID: <900bcd7c-bca2-7855-211a-dfc8c37b236c@huawei.com>
Date:   Tue, 26 Apr 2022 12:15:36 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [RFC PATCH v4 03/15] landlock: landlock_find/insert_rule
 refactoring (TCP port 0)
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>,
        <willemdebruijn.kernel@gmail.com>
CC:     <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>, <anton.sirazetdinov@huawei.com>
References: <20220309134459.6448-1-konstantin.meskhidze@huawei.com>
 <20220309134459.6448-4-konstantin.meskhidze@huawei.com>
 <bc44f11f-0eaa-a5f6-c5dc-1d36570f1be1@digikod.net>
 <6535183b-5fad-e3a9-1350-d22122205be6@huawei.com>
 <92d498f0-c598-7413-6b7c-d19c5aec6cab@digikod.net>
 <cb30248d-a8ae-c366-2c9f-2ab0fe44cc9a@huawei.com>
 <90a20548-39f6-6e84-efb1-8ef3ad992255@digikod.net>
 <212ac1b3-b78b-4030-1f3d-f5cd1001bb7d@huawei.com>
 <0e5afeaf-0569-d0b5-b701-0f611d103732@digikod.net>
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
In-Reply-To: <0e5afeaf-0569-d0b5-b701-0f611d103732@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhreml752-chm.china.huawei.com (10.201.108.202) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



4/12/2022 2:07 PM, Mickaël Salaün пишет:
> 
> On 23/03/2022 09:41, Konstantin Meskhidze wrote:
>>
>>
>> 3/22/2022 4:24 PM, Mickaël Salaün пишет:
>>>
> 
> [...]
>>> The remaining question is: should we need to accept 0 as a valid TCP 
>>> port? Can it be used? How does the kernel handle it?
>>
>>   I agree that must be a check for port 0 in add_rule_net_service(), 
>> cause unlike most port numbers, port 0 is a reserved port in TCP/IP 
>> networking, meaning that it should not be used in TCP or UDP messages.
>> Also network traffic sent across the internet to hosts listening on 
>> port 0 might be generated from network attackers or accidentally by 
>> applications programmed incorrectly.
>> Source: https://www.lifewire.com/port-0-in-tcp-and-udp-818145
> 
> OK, so denying this port by default without a way to allow it should not 
> be an issue. I guess an -EINVAL error would make sense when trying to 
> allow this port. This should be documented in a comment (with a link to 
> the RFC/section) and a dedicated test should check that behavior.
> 
> What is the behavior of firewalls (e.g. Netfiler) when trying to filter 
> port 0?

To be honest I don't know. I'm trying to check it.
>  
> This doesn't seem to be settle though: 
> https://www.austingroupbugs.net/view.php?id=1068
> 
> Interesting article: 
> https://z3r0trust.medium.com/socket-programming-the-bizarre-tcp-ip-port-0-saga-fcfbc0e0a276 
  Thanks. I will check.
> 
> .
