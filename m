Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 586F0645400
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 07:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiLGG31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 01:29:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiLGG30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 01:29:26 -0500
Received: from smtp.smtpout.orange.fr (smtp-26.smtpout.orange.fr [80.12.242.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8C85986C
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 22:29:23 -0800 (PST)
Received: from [192.168.1.18] ([86.243.100.34])
        by smtp.orange.fr with ESMTPA
        id 2nvjps6kw1LdI2nvjpWyzz; Wed, 07 Dec 2022 07:29:20 +0100
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 07 Dec 2022 07:29:20 +0100
X-ME-IP: 86.243.100.34
Message-ID: <3ac4ee1a-b6ad-283d-6747-1b2e15fb27f3@wanadoo.fr>
Date:   Wed, 7 Dec 2022 07:29:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: Re: [PATCH] packet: Don't include <linux/rculist.h>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
References: <adc33d6c7dd01e29c848b9519b6a601219ba6780.1670086158.git.christophe.jaillet@wanadoo.fr>
 <CANn89i+YnmoAunWzwG1KvCH0WUOCXfA6SztW3Xdf0vN4QktRGQ@mail.gmail.com>
Content-Language: fr, en-US
In-Reply-To: <CANn89i+YnmoAunWzwG1KvCH0WUOCXfA6SztW3Xdf0vN4QktRGQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 05/12/2022 à 06:24, Eric Dumazet a écrit :
> On Sat, Dec 3, 2022 at 5:49 PM Christophe JAILLET
> <christophe.jaillet@wanadoo.fr> wrote:
>>
>> There is no need to include <linux/rculist.h> here.
>>
>> Prefer the less invasive <linux/types.h> which is needed for 'hlist_head'.
>>
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>> ---
>> Let see if build-bots agree with me!
>>
> 
> net/packet/af_packet.c does not explicitly include linux/rculist.h
> 
> It might be provided by include/linux/netdevice.h, but I wonder if
> this is best practice.

At least, it is not what I expect.

My goal is to avoid some unneeded includes AND the related indirect 
needed includes that are buried somewhere in the dependency hell.

I missed the one in af_packet.c

I'll repost a v2 with the fix for af_packet.c (and double-check if some 
other are also needed)

> 
>> Just declaring 'struct mutex' and 'struct hlist_head' would also be an
>> option.
> 
> I do not get it, see [1]

Just forget about it.

Requirement for:
    struct my_struct {
           struct another_struct            x;

and
    struct my_struct {
           struct another_struct            *x;
                                           ~~~
are not the same, even if 'my_struct' is not used at all...

(*ashamed *)

CJ

> 
>> It would remove the need of any include, but is more likely to break
>> something.
> 
> I do not see why you are even trying this ?
> 
>> ---
>>   include/net/netns/packet.h | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/net/netns/packet.h b/include/net/netns/packet.h
>> index aae69bb43cde..74750865df36 100644
>> --- a/include/net/netns/packet.h
>> +++ b/include/net/netns/packet.h
>> @@ -5,8 +5,8 @@
>>   #ifndef __NETNS_PACKET_H__
>>   #define __NETNS_PACKET_H__
>>
>> -#include <linux/rculist.h>
>>   #include <linux/mutex.h>
>> +#include <linux/types.h>
>>
>>   struct netns_packet {
>>          struct mutex            sklist_lock;
> 
> [1] Definition of 'struct mutex' is definitely needed here.
> 
>> --
>> 2.34.1
>>
> 

