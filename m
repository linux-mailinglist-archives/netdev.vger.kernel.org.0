Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16C1238ACEA
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 13:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241356AbhETLvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 07:51:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:55960 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242666AbhETLrc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 07:47:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1621511170; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A8q+fkSuWfl4pXkgwyhK6ygE0KXVq43LbF4JProMcWQ=;
        b=b6B1/lM0z/Cw4r6XtealbDwhnP3XuTEp9BtAR5mohAmbvgiAu2g9Fx7XGa0bz/96uIi+WY
        PMkIrGhM7UWTYnhbeZkoKSlgu+ZvsDKQO5HeH0pe4umPHJ35PY9UTbe4sD3ZUel46PCNe7
        GGA+FXlZiYnLJ+VkJvTAMzcVWeHALXo=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4EBBAAC4B;
        Thu, 20 May 2021 11:46:10 +0000 (UTC)
Subject: Re: [PATCH] xen-netback: correct success/error reporting for the
 SKB-with-fraglist case
To:     paul@xen.org, Wei Liu <wl@xen.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
References: <4dd5b8ec-a255-7ab1-6dbf-52705acd6d62@suse.com>
 <67bc0728-761b-c3dd-bdd5-1a850ff79fbb@xen.org>
 <76c94541-21a8-7ae5-c4c4-48552f16c3fd@suse.com>
 <17e50fb5-31f7-60a5-1eec-10d18a40ad9a@xen.org>
 <57580966-3880-9e59-5d82-e1de9006aa0c@suse.com>
 <a26c1ecd-e303-3138-eb7e-96f0203ca888@xen.org>
From:   Jan Beulich <jbeulich@suse.com>
Message-ID: <1a522244-4be8-5e33-77c7-4ea5cf130335@suse.com>
Date:   Thu, 20 May 2021 13:46:09 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <a26c1ecd-e303-3138-eb7e-96f0203ca888@xen.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.02.2021 17:23, Paul Durrant wrote:
> On 25/02/2021 14:00, Jan Beulich wrote:
>> On 25.02.2021 13:11, Paul Durrant wrote:
>>> On 25/02/2021 07:33, Jan Beulich wrote:
>>>> On 24.02.2021 17:39, Paul Durrant wrote:
>>>>> On 23/02/2021 16:29, Jan Beulich wrote:
>>>>>> When re-entering the main loop of xenvif_tx_check_gop() a 2nd time, the
>>>>>> special considerations for the head of the SKB no longer apply. Don't
>>>>>> mistakenly report ERROR to the frontend for the first entry in the list,
>>>>>> even if - from all I can tell - this shouldn't matter much as the overall
>>>>>> transmit will need to be considered failed anyway.
>>>>>>
>>>>>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>>>>>>
>>>>>> --- a/drivers/net/xen-netback/netback.c
>>>>>> +++ b/drivers/net/xen-netback/netback.c
>>>>>> @@ -499,7 +499,7 @@ check_frags:
>>>>>>     				 * the header's copy failed, and they are
>>>>>>     				 * sharing a slot, send an error
>>>>>>     				 */
>>>>>> -				if (i == 0 && sharedslot)
>>>>>> +				if (i == 0 && !first_shinfo && sharedslot)
>>>>>>     					xenvif_idx_release(queue, pending_idx,
>>>>>>     							   XEN_NETIF_RSP_ERROR);
>>>>>>     				else
>>>>>>
>>>>>
>>>>> I think this will DTRT, but to my mind it would make more sense to clear
>>>>> 'sharedslot' before the 'goto check_frags' at the bottom of the function.
>>>>
>>>> That was my initial idea as well, but
>>>> - I think it is for a reason that the variable is "const".
>>>> - There is another use of it which would then instead need further
>>>>     amending (and which I believe is at least part of the reason for
>>>>     the variable to be "const").
>>>>
>>>
>>> Oh, yes. But now that I look again, don't you want:
>>>
>>> if (i == 0 && first_shinfo && sharedslot)
>>>
>>> ? (i.e no '!')
>>>
>>> The comment states that the error should be indicated when the first
>>> frag contains the header in the case that the map succeeded but the
>>> prior copy from the same ref failed. This can only possibly be the case
>>> if this is the 'first_shinfo'
>>
>> I don't think so, no - there's a difference between "first frag"
>> (at which point first_shinfo is NULL) and first frag list entry
>> (at which point first_shinfo is non-NULL).
> 
> Yes, I realise I got it backwards. Confusing name but the comment above 
> its declaration does explain.
> 
>>
>>> (which is why I still think it is safe to unconst 'sharedslot' and
>>> clear it).
>>
>> And "no" here as well - this piece of code
>>
>> 		/* First error: if the header haven't shared a slot with the
>> 		 * first frag, release it as well.
>> 		 */
>> 		if (!sharedslot)
>> 			xenvif_idx_release(queue,
>> 					   XENVIF_TX_CB(skb)->pending_idx,
>> 					   XEN_NETIF_RSP_OKAY);
>>
>> specifically requires sharedslot to have the value that was
>> assigned to it at the start of the function (this property
>> doesn't go away when switching from fragments to frag list).
>> Note also how it uses XENVIF_TX_CB(skb)->pending_idx, i.e. the
>> value the local variable pending_idx was set from at the start
>> of the function.
>>
> 
> True, we do have to deal with freeing up the header if the first map 
> error comes on the frag list.
> 
> Reviewed-by: Paul Durrant <paul@xen.org>

Since I've not seen this go into 5.13-rc, may I ask what the disposition
of this is?

Jan
