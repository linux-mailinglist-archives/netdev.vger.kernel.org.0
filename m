Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2435352B5F8
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 11:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233963AbiERJSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 05:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234007AbiERJSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 05:18:46 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 432AD22B1E;
        Wed, 18 May 2022 02:18:45 -0700 (PDT)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4L36l561PZz6GDHr;
        Wed, 18 May 2022 17:14:57 +0800 (CST)
Received: from [10.122.132.241] (10.122.132.241) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Wed, 18 May 2022 11:18:42 +0200
Message-ID: <10c4935d-0ed1-a355-c0e2-64abdae17afc@huawei.com>
Date:   Wed, 18 May 2022 12:18:40 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v5 03/15] landlock: merge and inherit function refactoring
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <anton.sirazetdinov@huawei.com>
References: <20220516152038.39594-1-konstantin.meskhidze@huawei.com>
 <20220516152038.39594-4-konstantin.meskhidze@huawei.com>
 <72c37309-3535-8119-b701-193ccc75e74e@digikod.net>
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
In-Reply-To: <72c37309-3535-8119-b701-193ccc75e74e@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhreml752-chm.china.huawei.com (10.201.108.202) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



5/17/2022 11:14 AM, Mickaël Salaün пишет:
> 
> 
> On 16/05/2022 17:20, Konstantin Meskhidze wrote:
>> Merge_ruleset() and inherit_ruleset() functions were
>> refactored to support new rule types. This patch adds
>> tree_merge() and tree_copy() helpers. Each has
>> rule_type argument to choose a particular rb_tree
>> structure in a ruleset.
>>
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
>>
>> Changes since v3:
>> * Split commit.
>> * Refactoring functions:
>>     -insert_rule.
>>     -merge_ruleset.
>>     -tree_merge.
>>     -inherit_ruleset.
>>     -tree_copy.
>>     -free_rule.
>>
>> Changes since v4:
>> * None
>>
>> ---
>>   security/landlock/ruleset.c | 144 ++++++++++++++++++++++++------------
>>   1 file changed, 98 insertions(+), 46 deletions(-)
>>
>> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
>> index f079a2a320f1..4b4c9953bb32 100644
>> --- a/security/landlock/ruleset.c
>> +++ b/security/landlock/ruleset.c
>> @@ -112,12 +112,16 @@ static struct landlock_rule *create_rule(
>>       return new_rule;
>>   }
>>
>> -static void free_rule(struct landlock_rule *const rule)
>> +static void free_rule(struct landlock_rule *const rule, const u16 
>> rule_type)
>>   {
>>       might_sleep();
>>       if (!rule)
>>           return;
>> -    landlock_put_object(rule->object.ptr);
>> +    switch (rule_type) {
>> +    case LANDLOCK_RULE_PATH_BENEATH:
>> +        landlock_put_object(rule->object.ptr);
>> +        break;
>> +    }
>>       kfree(rule);
>>   }
>>
>> @@ -227,12 +231,12 @@ static int insert_rule(struct landlock_ruleset 
>> *const ruleset,
>>               new_rule = create_rule(object_ptr, 0, &this->layers,
>>                              this->num_layers,
>>                              &(*layers)[0]);
>> +            if (IS_ERR(new_rule))
>> +                return PTR_ERR(new_rule);
>> +            rb_replace_node(&this->node, &new_rule->node, 
>> &ruleset->root_inode);
>> +            free_rule(this, rule_type);
>>               break;
>>           }
>> -        if (IS_ERR(new_rule))
>> -            return PTR_ERR(new_rule);
>> -        rb_replace_node(&this->node, &new_rule->node, 
>> &ruleset->root_inode);
>> -        free_rule(this);
>>           return 0;
>>       }
>>
>> @@ -243,13 +247,12 @@ static int insert_rule(struct landlock_ruleset 
>> *const ruleset,
>>       switch (rule_type) {
>>       case LANDLOCK_RULE_PATH_BENEATH:
>>           new_rule = create_rule(object_ptr, 0, layers, num_layers, 
>> NULL);
>> +        if (IS_ERR(new_rule))
>> +            return PTR_ERR(new_rule);
>> +        rb_link_node(&new_rule->node, parent_node, walker_node);
>> +        rb_insert_color(&new_rule->node, &ruleset->root_inode);
>>           break;
>>       }
>> -    if (IS_ERR(new_rule))
>> -        return PTR_ERR(new_rule);
>> -    rb_link_node(&new_rule->node, parent_node, walker_node);
>> -    rb_insert_color(&new_rule->node, &ruleset->root_inode);
>> -    ruleset->num_rules++;
> 
> Why removing this last line?

  Thank you for noticing that. Its my mistake during refactoring the 
code. Selftests did not show it.

> .
