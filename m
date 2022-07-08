Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 256EB56BA20
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 14:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237921AbiGHMyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 08:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237713AbiGHMya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 08:54:30 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 194EB1CFEC;
        Fri,  8 Jul 2022 05:54:30 -0700 (PDT)
Received: from fraeml705-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LfY5w53pZz6H8Wy;
        Fri,  8 Jul 2022 20:50:12 +0800 (CST)
Received: from lhreml745-chm.china.huawei.com (10.201.108.195) by
 fraeml705-chm.china.huawei.com (10.206.15.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Fri, 8 Jul 2022 14:54:27 +0200
Received: from [10.122.132.241] (10.122.132.241) by
 lhreml745-chm.china.huawei.com (10.201.108.195) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 8 Jul 2022 13:54:27 +0100
Message-ID: <954fe59f-31c3-cf88-77a4-c0b570eba7fc@huawei.com>
Date:   Fri, 8 Jul 2022 15:54:26 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v6 02/17] landlock: refactors landlock_find/insert_rule
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <anton.sirazetdinov@huawei.com>
References: <20220621082313.3330667-1-konstantin.meskhidze@huawei.com>
 <20220621082313.3330667-3-konstantin.meskhidze@huawei.com>
 <b02d6f95-ea80-b82d-5b7b-6d116a9b5078@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <b02d6f95-ea80-b82d-5b7b-6d116a9b5078@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhreml753-chm.china.huawei.com (10.201.108.203) To
 lhreml745-chm.china.huawei.com (10.201.108.195)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



7/7/2022 7:46 PM, Mickaël Salaün пишет:
> 
> 
> On 21/06/2022 10:22, Konstantin Meskhidze wrote:
>> Adds a new object union to support a socket port
>> rule type. Refactors landlock_insert_rule() and
>> landlock_find_rule() to support coming network
>> modifications. Now adding or searching a rule
>> in a ruleset depends on a rule_type argument
>> provided in refactored functions mentioned above.
>> 
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
>> 
>> Changes since v5:
>> * Formats code with clang-format-14.
>> 
>> Changes since v4:
>> * Refactors insert_rule() and create_rule() functions by deleting
>> rule_type from their arguments list, it helps to reduce useless code.
>> 
>> Changes since v3:
>> * Splits commit.
>> * Refactors landlock_insert_rule and landlock_find_rule functions.
>> * Rename new_ruleset->root_inode.
>> 
>> ---
>>   security/landlock/fs.c      |   7 ++-
>>   security/landlock/ruleset.c | 105 ++++++++++++++++++++++++++----------
>>   security/landlock/ruleset.h |  27 +++++-----
>>   3 files changed, 96 insertions(+), 43 deletions(-)
> 
> [...]
> 
>> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
>> index bd7ab39859bf..a22d132c32a7 100644
>> --- a/security/landlock/ruleset.h
>> +++ b/security/landlock/ruleset.h
>> @@ -53,15 +53,17 @@ struct landlock_rule {
>>   	 */
>>   	struct rb_node node;
>>   	/**
>> -	 * @object: Pointer to identify a kernel object (e.g. an inode).  This
>> -	 * is used as a key for this ruleset element.  This pointer is set once
>> -	 * and never modified.  It always points to an allocated object because
>> -	 * each rule increments the refcount of its object.
>> -	 */
>> -	struct landlock_object *object;
>> -	/**
>> -	 * @num_layers: Number of entries in @layers.
>> +	 * @object: A union to identify either a kernel object (e.g. an inode) or
>> +	 * a raw data value (e.g. a network socket port). This is used as a key
>> +	 * for this ruleset element. This pointer/@object.ptr/ is set once and
>> +	 * never modified. It always points to an allocated object because each
>> +	 * rule increments the refcount of its object (for inodes).;
> 
> Extra ";"

  Yep. It's a silly typo. Thanks.
  Will be removed.
> .
