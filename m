Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F397C634252
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 18:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234410AbiKVRRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 12:17:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232665AbiKVRRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 12:17:15 -0500
Received: from smtp-bc0f.mail.infomaniak.ch (smtp-bc0f.mail.infomaniak.ch [45.157.188.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C4C78189;
        Tue, 22 Nov 2022 09:17:13 -0800 (PST)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4NGrXl5C5RzMqFlf;
        Tue, 22 Nov 2022 18:17:11 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4NGrXl0z1kzMppB8;
        Tue, 22 Nov 2022 18:17:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1669137431;
        bh=P+IUgH4nyscpfUnyctWIrg0KUE05NslDqW8Y/LDZpUA=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=DqKmNL5wf/uL3kr+Z4KJUKawpibnFEcLsjYEXFE+pBFTNJm6VhhKmJm7oxfeomNMJ
         FQ4vP5jUeaFMr2Fm1IpSyqBlMmALwlqfqDLXsfSWW9fH0RufRxCPvrenCq6D8Fngk4
         UL27qgTs0dy10193flsnIx85obphfivUyATAgdKc=
Message-ID: <acd844ba-07b2-8a14-0089-77b3c4dcb68b@digikod.net>
Date:   Tue, 22 Nov 2022 18:17:10 +0100
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v8 02/12] landlock: Refactor
 landlock_find_rule/insert_rule
Content-Language: en-US
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, artem.kuzin@huawei.com
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
 <20221021152644.155136-3-konstantin.meskhidze@huawei.com>
 <5c6c99f7-4218-1f79-477e-5d943c9809fd@digikod.net>
In-Reply-To: <5c6c99f7-4218-1f79-477e-5d943c9809fd@digikod.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 17/11/2022 19:41, Mickaël Salaün wrote:
> 
> On 21/10/2022 17:26, Konstantin Meskhidze wrote:

[...]

>> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
>> index f2ad932d396c..608ab356bc3e 100644
>> --- a/security/landlock/ruleset.h
>> +++ b/security/landlock/ruleset.h
>> @@ -49,6 +49,46 @@ struct landlock_layer {
>>    	access_mask_t access;
>>    };
>>
>> +/**
>> + * union landlock_key - Key of a ruleset's red-black tree
>> + */
>> +union landlock_key {
>> +	/**
>> +	 * @object: Pointer to identify a kernel object (e.g. an inode).
>> +	 */
>> +	struct landlock_object *object;
>> +	/**
>> +	 * @data: A raw data value to identify a network socket port.
> 
> "Raw data to identify an arbitrary 32-bit value (e.g. a TCP port)."
> 
> 
>> +	 */
>> +	uintptr_t data;
>> +};
>> +
>> +/**
>> + * enum landlock_key_type - Type of &union landlock_key
>> + */
>> +enum landlock_key_type {
>> +	/**
>> +	 * @LANDLOCK_KEY_INODE: Type of &landlock_ruleset.root_inode's node
>> +	 * keys.
>> +	 */
>> +	LANDLOCK_KEY_INODE = 1,
>> +};
>> +
>> +/**
>> + * struct landlock_id - Unique rule identifier for a ruleset
>> + */
>> +struct landlock_id {
>> +	/**
>> +	 * @key: A union to identify either a kernel object (e.g. an inode) or
>> +	 * a raw data value (e.g. a network socket port).
> 
> "a 32-bit value (e.g. a TCP port)."

Instead:
@key: Identifies either a kernel object (e.g. an inode) or a raw value 
(e.g. a TCP port).

> 
> 
>> +	 */
>> +	union landlock_key key;
>> +	/**
>> +	 * @type: A enumerator to identify the type of landlock_ruleset's root tree.

@type: Type of a landlock_ruleset's root tree.


>> +	 */
>> +	const enum landlock_key_type type;
>> +};
