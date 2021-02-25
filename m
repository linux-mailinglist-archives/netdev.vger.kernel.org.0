Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9449B32536C
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 17:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233084AbhBYQYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 11:24:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbhBYQYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 11:24:11 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D85C061574
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 08:23:30 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id o16so5374794wmh.0
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 08:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:reply-to:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GlKFw17HlSadzsLvhkkdjanZrmggScCohCGFmx1NWfg=;
        b=C3jhe/BOKV6oECZihDXiEs05jbwYe6hP8PtR5d5EInbgy2LqWH/sD400gAo66HjCHt
         HG7kGGUhMqJI8YTo6QbS25buhtNUqvbWotZoNrjwsnO9DAnvT99fx3qjb+3IwJGtEI60
         fKMvxk9nB0eRfXwM1YuBOjl9WLZvvjoCeqt+FFUmh2hlccxJ3hWhFFs7qg2e/CnmAnvy
         lP9QmLoFafAhNgRIwJb/d/moC9BqgWa9VD5QM5AG21xiojs9WFg2vUZR+lJrY7iesf39
         jOa2XfJqQUwhbvl0eHEz3w7i2ch7Q/FAkMQ8bbcQJldL7pDJ3sdA9O5mKwyT4AEvSvPa
         qyDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:reply-to:subject:to:cc:references
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=GlKFw17HlSadzsLvhkkdjanZrmggScCohCGFmx1NWfg=;
        b=VK8M5ZmaHh6mLuyoS/z6wVWAyjpySuowmFSLPbEo8gI8lXDF2zRdDQAtSKKhbeJjXz
         6u17g0EnkBurS8xaG9rW5h0YYf0VC40SFs9rRBCMlNi1dj0miZ20kp0IOV3ZFy2VMCLY
         f/2+2hhzAGOrPKdZ+a16q+YlNAzFz2tOyC9T1sC0RpFsAJDnSXpK04jYKYX1tL9FBbcz
         Z3y54s++RTJ32J16kHyg2EPa4c5KFoZxtzHN+4a8nGko2Big3iGEaaPFYAhn6wQSZ3Cl
         PlkQ683VMnJWi91DmODCxJ9GxmBQin4S3JTgrzUl2JrZ3jD89O3PpbV3pRrpX0OZai31
         P/ag==
X-Gm-Message-State: AOAM532cgxRQ/3T93C6/6SR1vDsZzA8tBIf9ZLOiOV9icNJbjtfTw8fQ
        m05tbyaoIbxb80dCKM6PDS6DYgzRaK8=
X-Google-Smtp-Source: ABdhPJxFJpbPBk0sDF7od5u+aATKNxXkfGITmm9sISjxD08kKnyIrfCoDPP7XJYEiZfweO2Ea6etnQ==
X-Received: by 2002:a1c:e903:: with SMTP id q3mr4034403wmc.100.1614270208015;
        Thu, 25 Feb 2021 08:23:28 -0800 (PST)
Received: from ?IPv6:2a00:23c5:5785:9a01:ad9a:ab78:5748:a7ec? ([2a00:23c5:5785:9a01:ad9a:ab78:5748:a7ec])
        by smtp.gmail.com with ESMTPSA id l15sm8132275wmh.21.2021.02.25.08.23.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Feb 2021 08:23:26 -0800 (PST)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Reply-To: paul@xen.org
Subject: Re: [PATCH] xen-netback: correct success/error reporting for the
 SKB-with-fraglist case
To:     Jan Beulich <jbeulich@suse.com>
Cc:     "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Wei Liu <wl@xen.org>
References: <4dd5b8ec-a255-7ab1-6dbf-52705acd6d62@suse.com>
 <67bc0728-761b-c3dd-bdd5-1a850ff79fbb@xen.org>
 <76c94541-21a8-7ae5-c4c4-48552f16c3fd@suse.com>
 <17e50fb5-31f7-60a5-1eec-10d18a40ad9a@xen.org>
 <57580966-3880-9e59-5d82-e1de9006aa0c@suse.com>
Message-ID: <a26c1ecd-e303-3138-eb7e-96f0203ca888@xen.org>
Date:   Thu, 25 Feb 2021 16:23:26 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <57580966-3880-9e59-5d82-e1de9006aa0c@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/02/2021 14:00, Jan Beulich wrote:
> On 25.02.2021 13:11, Paul Durrant wrote:
>> On 25/02/2021 07:33, Jan Beulich wrote:
>>> On 24.02.2021 17:39, Paul Durrant wrote:
>>>> On 23/02/2021 16:29, Jan Beulich wrote:
>>>>> When re-entering the main loop of xenvif_tx_check_gop() a 2nd time, the
>>>>> special considerations for the head of the SKB no longer apply. Don't
>>>>> mistakenly report ERROR to the frontend for the first entry in the list,
>>>>> even if - from all I can tell - this shouldn't matter much as the overall
>>>>> transmit will need to be considered failed anyway.
>>>>>
>>>>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>>>>>
>>>>> --- a/drivers/net/xen-netback/netback.c
>>>>> +++ b/drivers/net/xen-netback/netback.c
>>>>> @@ -499,7 +499,7 @@ check_frags:
>>>>>     				 * the header's copy failed, and they are
>>>>>     				 * sharing a slot, send an error
>>>>>     				 */
>>>>> -				if (i == 0 && sharedslot)
>>>>> +				if (i == 0 && !first_shinfo && sharedslot)
>>>>>     					xenvif_idx_release(queue, pending_idx,
>>>>>     							   XEN_NETIF_RSP_ERROR);
>>>>>     				else
>>>>>
>>>>
>>>> I think this will DTRT, but to my mind it would make more sense to clear
>>>> 'sharedslot' before the 'goto check_frags' at the bottom of the function.
>>>
>>> That was my initial idea as well, but
>>> - I think it is for a reason that the variable is "const".
>>> - There is another use of it which would then instead need further
>>>     amending (and which I believe is at least part of the reason for
>>>     the variable to be "const").
>>>
>>
>> Oh, yes. But now that I look again, don't you want:
>>
>> if (i == 0 && first_shinfo && sharedslot)
>>
>> ? (i.e no '!')
>>
>> The comment states that the error should be indicated when the first
>> frag contains the header in the case that the map succeeded but the
>> prior copy from the same ref failed. This can only possibly be the case
>> if this is the 'first_shinfo'
> 
> I don't think so, no - there's a difference between "first frag"
> (at which point first_shinfo is NULL) and first frag list entry
> (at which point first_shinfo is non-NULL).

Yes, I realise I got it backwards. Confusing name but the comment above 
its declaration does explain.

> 
>> (which is why I still think it is safe to unconst 'sharedslot' and
>> clear it).
> 
> And "no" here as well - this piece of code
> 
> 		/* First error: if the header haven't shared a slot with the
> 		 * first frag, release it as well.
> 		 */
> 		if (!sharedslot)
> 			xenvif_idx_release(queue,
> 					   XENVIF_TX_CB(skb)->pending_idx,
> 					   XEN_NETIF_RSP_OKAY);
> 
> specifically requires sharedslot to have the value that was
> assigned to it at the start of the function (this property
> doesn't go away when switching from fragments to frag list).
> Note also how it uses XENVIF_TX_CB(skb)->pending_idx, i.e. the
> value the local variable pending_idx was set from at the start
> of the function.
> 

True, we do have to deal with freeing up the header if the first map 
error comes on the frag list.

Reviewed-by: Paul Durrant <paul@xen.org>

> Jan
> 

