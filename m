Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9C5639FF3
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 04:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiK1DG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 22:06:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiK1DG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 22:06:57 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31DBB7F2;
        Sun, 27 Nov 2022 19:06:56 -0800 (PST)
Received: from frapeml100005.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NL9KL0NBSz685Yk;
        Mon, 28 Nov 2022 11:03:49 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 frapeml100005.china.huawei.com (7.182.85.132) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 28 Nov 2022 04:06:31 +0100
Received: from [10.122.132.241] (10.122.132.241) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Mon, 28 Nov 2022 03:06:30 +0000
Message-ID: <9f1c28bc-b482-cef3-12bc-b250d3be82a1@huawei.com>
Date:   Mon, 28 Nov 2022 06:06:29 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v8 02/12] landlock: Refactor
 landlock_find_rule/insert_rule
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <artem.kuzin@huawei.com>
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
 <20221021152644.155136-3-konstantin.meskhidze@huawei.com>
 <5c6c99f7-4218-1f79-477e-5d943c9809fd@digikod.net>
 <acd844ba-07b2-8a14-0089-77b3c4dcb68b@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <acd844ba-07b2-8a14-0089-77b3c4dcb68b@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhrpeml500006.china.huawei.com (7.191.161.198) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



11/22/2022 8:17 PM, Mickaël Salaün пишет:
> 
> On 17/11/2022 19:41, Mickaël Salaün wrote:
>> 
>> On 21/10/2022 17:26, Konstantin Meskhidze wrote:
> 
> [...]
> 
>>> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
>>> index f2ad932d396c..608ab356bc3e 100644
>>> --- a/security/landlock/ruleset.h
>>> +++ b/security/landlock/ruleset.h
>>> @@ -49,6 +49,46 @@ struct landlock_layer {
>>>    	access_mask_t access;
>>>    };
>>>
>>> +/**
>>> + * union landlock_key - Key of a ruleset's red-black tree
>>> + */
>>> +union landlock_key {
>>> +	/**
>>> +	 * @object: Pointer to identify a kernel object (e.g. an inode).
>>> +	 */
>>> +	struct landlock_object *object;
>>> +	/**
>>> +	 * @data: A raw data value to identify a network socket port.
>> 
>> "Raw data to identify an arbitrary 32-bit value (e.g. a TCP port)."
>> 
>> 
>>> +	 */
>>> +	uintptr_t data;
>>> +};
>>> +
>>> +/**
>>> + * enum landlock_key_type - Type of &union landlock_key
>>> + */
>>> +enum landlock_key_type {
>>> +	/**
>>> +	 * @LANDLOCK_KEY_INODE: Type of &landlock_ruleset.root_inode's node
>>> +	 * keys.
>>> +	 */
>>> +	LANDLOCK_KEY_INODE = 1,
>>> +};
>>> +
>>> +/**
>>> + * struct landlock_id - Unique rule identifier for a ruleset
>>> + */
>>> +struct landlock_id {
>>> +	/**
>>> +	 * @key: A union to identify either a kernel object (e.g. an inode) or
>>> +	 * a raw data value (e.g. a network socket port).
>> 
>> "a 32-bit value (e.g. a TCP port)."
> 
> Instead:
> @key: Identifies either a kernel object (e.g. an inode) or a raw value
> (e.g. a TCP port).

   Ok. Got it.
> 
>> 
>> 
>>> +	 */
>>> +	union landlock_key key;
>>> +	/**
>>> +	 * @type: A enumerator to identify the type of landlock_ruleset's root tree.
> 
> @type: Type of a landlock_ruleset's root tree.
> 
   Ok. Thanks.
> 
>>> +	 */
>>> +	const enum landlock_key_type type;
>>> +};
> .
