Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4AA661F90
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 08:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233620AbjAIH7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 02:59:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbjAIH7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 02:59:48 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8986DE8D;
        Sun,  8 Jan 2023 23:59:46 -0800 (PST)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Nr5rX4tJDz67lSM;
        Mon,  9 Jan 2023 15:57:16 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Mon, 9 Jan 2023 07:59:44 +0000
Message-ID: <4aa29433-e7f9-f225-5bdf-c80638c936e8@huawei.com>
Date:   Mon, 9 Jan 2023 10:59:43 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v8 07/12] landlock: Add network rules support
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>,
        <linux-sparse@vger.kernel.org>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <artem.kuzin@huawei.com>,
        Linux API <linux-api@vger.kernel.org>,
        "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
 <20221021152644.155136-8-konstantin.meskhidze@huawei.com>
 <49391484-7401-e7c7-d909-3bd6bd024731@digikod.net>
 <9a6ea6ac-525d-e058-5867-0794a99b19a3@huawei.com>
 <47fedda8-a13c-b62f-251f-b62508964bb0@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <47fedda8-a13c-b62f-251f-b62508964bb0@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml100005.china.huawei.com (7.191.160.25) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



1/6/2023 10:22 PM, Mickaël Salaün пишет:
> 
> On 04/01/2023 12:41, Konstantin Meskhidze (A) wrote:
>> 
>> 
>> 11/17/2022 9:43 PM, Mickaël Salaün пишет:
> 
> [...]
> 
>>>>    /**
>>>> @@ -79,6 +91,24 @@ struct landlock_path_beneath_attr {
>>>>    	 */
>>>>    } __attribute__((packed));
>>>>
>>>> +/**
>>>> + * struct landlock_net_service_attr - TCP subnet definition
>>>> + *
>>>> + * Argument of sys_landlock_add_rule().
>>>> + */
>>>> +struct landlock_net_service_attr {
>>>> +	/**
>>>> +	 * @allowed_access: Bitmask of allowed access network for services
>>>> +	 * (cf. `Network flags`_).
>>>> +	 */
>>>> +	__u64 allowed_access;
>>>> +	/**
>>>> +	 * @port: Network port.
>>>> +	 */
>>>> +	__u16 port;
>>>
>>>    From an UAPI point of view, I think the port field should be __be16, as
>>> for sockaddr_in->port and other network-related APIs. This will require
>>> some kernel changes to please sparse: make C=2 security/landlock/ must
>>> not print any warning.
>> 
>>     I have this errors trying to launch sparse checking:
>> 
>>     DESCEND objtool
>>     DESCEND bpf/resolve_btfids
>>     CALL    scripts/checksyscalls.sh
>>     CHK     kernel/kheaders_data.tar.xz
>>     CC      security/landlock/setup.o
>>     CHECK   security/landlock/setup.c
>> ./include/asm-generic/rwonce.h:67:16: error: typename in expression
>> ./include/asm-generic/rwonce.h:67:16: error: Expected ) in function call
>> ./include/asm-generic/rwonce.h:67:16: error: got :
>> ./include/linux/list.h:292:16: error: typename in expression
>> ./include/linux/list.h:292:16: error: Expected ) in function call
>> ./include/linux/list.h:292:16: error: got :
>> 
>> ....
>> 
>> ./include/linux/seqlock.h:682:16: error: Expected ) in function call
>> ./include/linux/seqlock.h:682:16: error: got :
>> ./include/linux/seqlock.h:695:16: error: typename in expression
>> ./include/linux/seqlock.h:695:16: error: Expected ) in function call
>> ./include/linux/seqlock.h:695:16: error: too many errors
>> Segmentation fault (core dumped)
>> make[3]: *** [scripts/Makefile.build:250: security/landlock/setup.o]
>> Error 139
>> make[3]: *** Deleting file 'security/landlock/setup.o'
>> make[3]: *** Waiting for unfinished jobs....
>> Segmentation fault (core dumped)
>> make[3]: *** [scripts/Makefile.build:250: security/landlock/syscalls.o]
>> Error 139
>> make[3]: *** Deleting file 'security/landlock/syscalls.o'
>> make[2]: *** [scripts/Makefile.build:502: security/landlock] Error 2
>> make[1]: *** [scripts/Makefile.build:502: security] Error 2
>> make[1]: *** Waiting for unfinished jobs....
>> make: *** [Makefile:1994: .] Error 2
> 
> I don't know about this error. Did you follow the documentation?
> https://docs.kernel.org/dev-tools/sparse.html#getting-sparse
> 
   Yes, I did as in the documentation. that's strange.
If you dont mind can you please check it when I sent a new patch?

> 
> 
>>>
>>> Using big-endian values as keys (casted to uintptr_t, not strictly
>>> __be16) in the rb-tree should not be an issue because there is no port
>>> range ordering (for now).
>>>
>>> A dedicated test should check that endianness is correct, e.g. by using
>>> different port encoding. This should include passing and failing tests,
>>> but they should work on all architectures (i.e. big or little endian).
> .
