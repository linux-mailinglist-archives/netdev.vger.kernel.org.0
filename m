Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 207656E991F
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 18:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234544AbjDTQFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 12:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234321AbjDTQFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 12:05:49 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 083975B83;
        Thu, 20 Apr 2023 09:05:39 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Q2Mr82ljTz6J749;
        Fri, 21 Apr 2023 00:02:48 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 17:05:36 +0100
Message-ID: <c9a0d79b-868d-bdc2-c656-d171a2440074@huawei.com>
Date:   Thu, 20 Apr 2023 19:05:35 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v10 07/13] landlock: Refactor layer helpers
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
References: <20230323085226.1432550-1-konstantin.meskhidze@huawei.com>
 <20230323085226.1432550-8-konstantin.meskhidze@huawei.com>
 <25d2a813-4954-5e35-b13b-c48a8ce08c1a@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <25d2a813-4954-5e35-b13b-c48a8ce08c1a@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml100004.china.huawei.com (7.191.162.219) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



4/16/2023 7:11 PM, Mickaël Salaün пишет:
> 
> On 23/03/2023 09:52, Konstantin Meskhidze wrote:
>> Add new key_type argument to the landlock_init_layer_masks() helper.
>> Add a masks_array_size argument to the landlock_unmask_layers() helper.
>> These modifications support implementing new rule types in the next
>> Landlock versions.
>> 
>> Signed-off-by: Mickaël Salaün <mic@digikod.net>
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
>> 
>> Changes since v9:
>> * Refactors commit message.
>> 
>> Changes since v8:
>> * None.
>> 
>> Changes since v7:
>> * Refactors commit message, adds a co-developer.
>> * Minor fixes.
>> 
>> Changes since v6:
>> * Removes masks_size attribute from init_layer_masks().
>> * Refactors init_layer_masks() with new landlock_key_type.
>> 
>> Changes since v5:
>> * Splits commit.
>> * Formats code with clang-format-14.
>> 
>> Changes since v4:
>> * Refactors init_layer_masks(), get_handled_accesses()
>> and unmask_layers() functions to support multiple rule types.
>> * Refactors landlock_get_fs_access_mask() function with
>> LANDLOCK_MASK_ACCESS_FS mask.
>> 
>> Changes since v3:
>> * Splits commit.
>> * Refactors landlock_unmask_layers functions.
>> 
>> ---
>>   security/landlock/fs.c      | 43 +++++++++++++++++--------------
>>   security/landlock/ruleset.c | 50 +++++++++++++++++++++++++------------
>>   security/landlock/ruleset.h | 17 +++++++------
>>   3 files changed, 67 insertions(+), 43 deletions(-)
>> 
> 
> [...]
> 
>> @@ -629,7 +629,11 @@ bool landlock_unmask_layers(
>>   	return false;
>>   }
>> 
>> -/**
>> +typedef access_mask_t
>> +get_access_mask_t(const struct landlock_ruleset *const ruleset,
>> +		  const u16 layer_level);
>> +
>> +/*
> 
> Please keep the "/**"

   Got it. Thanks.
> 
> 
>>    * landlock_init_layer_masks - Initialize layer masks from an access request
>>    *
>>    * Populates @layer_masks such that for each access right in @access_request,
> .
