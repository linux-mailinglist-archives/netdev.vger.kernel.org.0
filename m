Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3C8E5B5F0C
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 19:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbiILRRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 13:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbiILRRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 13:17:18 -0400
Received: from smtp-190b.mail.infomaniak.ch (smtp-190b.mail.infomaniak.ch [185.125.25.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C563ED7D
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 10:17:13 -0700 (PDT)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4MRCvW2kZ2zMqjlr;
        Mon, 12 Sep 2022 19:17:11 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4MRCvV6h0fzMpq1X;
        Mon, 12 Sep 2022 19:17:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1663003031;
        bh=ucTgqWULARNjHjU2dWMNB/J+4JaBT3z196CKuSXCIBE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=YfSDxOoMNvuzfWDBS2CXaMAm6a3Nt+UXSj9kcydJM7kuOHvgs5P18NBHF6da/le1R
         pHVxMVBGx+YAunYmGPmx/YO4c3pHuzhoYW4m+EwP7TSZ44PkgwivAOU6AsNEqo2bjT
         PiwCLQAWGUpiPkawgLK4T0X0pHTu76cyivZwfF8E=
Message-ID: <c5175baa-799f-c9f2-b438-a34d296940bf@digikod.net>
Date:   Mon, 12 Sep 2022 19:17:10 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v7 02/18] landlock: refactor
 landlock_find_rule/insert_rule
Content-Language: en-US
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, anton.sirazetdinov@huawei.com
References: <20220829170401.834298-1-konstantin.meskhidze@huawei.com>
 <20220829170401.834298-3-konstantin.meskhidze@huawei.com>
 <431e5311-7072-3a20-af75-d81907b22d61@digikod.net>
 <282806a0-2168-f171-e801-933e35612d22@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <282806a0-2168-f171-e801-933e35612d22@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 09/09/2022 12:48, Konstantin Meskhidze (A) wrote:
> 
> 
> 9/6/2022 11:07 AM, Mickaël Salaün пишет:

[...]

>>> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
>>> index 647d44284080..bb1408cc8dd2 100644
>>> --- a/security/landlock/ruleset.h
>>> +++ b/security/landlock/ruleset.h
>>> @@ -49,6 +49,33 @@ struct landlock_layer {
>>>    	access_mask_t access;
>>>    };
>>>
>>> +/**
>>> + * union landlock_key - Key of a ruleset's red-black tree
>>> + */
>>> +union landlock_key {
>>> +	struct landlock_object *object;
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
>>> +	union landlock_key key;
>>> +	const enum landlock_key_type type;
>>> +};
>>
>> You can add these new types to Documentation/security/landlock.rst (with
>> this commit). You need to complete all the new field descriptions though
>> (otherwise you'll get Sphinx warnings): object, data, key, type.
> 
>     Sorry I did not get this tip. Can you explain more detailed here,
> about Sphinx warnings?

You need to add comments for all the fields as it is done for other 
structs. The Sphinx warnings come from make htmldocs.
