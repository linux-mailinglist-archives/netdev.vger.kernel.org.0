Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E578E1044BC
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 21:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbfKTUE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 15:04:57 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33749 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727085AbfKTUE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 15:04:56 -0500
Received: by mail-pf1-f195.google.com with SMTP id c184so300081pfb.0
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 12:04:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Y+1wuJYMQ10mHJA/44qVGN2EGVVV8HEerzpWcaIVFvM=;
        b=jUvs+/uTSSDmIc2Rh23Poe71/n1n8AivouumBR0Db9e8Dzyocg2B3eIhqmqYXO17iO
         lC3mg1EygkoymHZ8pleziyYjWS2uu2146W50VqGdYURjwXbO5zuPwHzrx03b5LgsWoPw
         5vwaC93AmGhirhJxq95aYwjd5nwz5qRsvD0VJNhflciYIierQZ5w4JJwSIwYBHQckzsO
         jKRvapuwLBLl2kI4GTKGG9/vlCqWI0XiTMLCMtJRSnt1xJm4h7gNmqkwuHtcGgfIgkKH
         YNcTrXTkk/9NUirt7O8TC43I4tIm/i/QscOTIZoBAgx26rKXRIFIQFw1/njLpqB8YmCA
         or/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y+1wuJYMQ10mHJA/44qVGN2EGVVV8HEerzpWcaIVFvM=;
        b=P+jcnNOewdQKgWoXtSelO/qsPteo8Y6unBR5IwIgwB0ArSYDV0W1/8yu/oyMPjW5d7
         mcLrWGDOqQDVGFxaswFAf+TL16utC3XdqHlPa08UBb59aI4bHCf5YdJE8WVvwcm0qAlX
         BJcEuAtSQoo9nwk6Yb/F+Y2DpsQFqivGCeyIFBGJtMaAh3PCIiGIeHVob8vkYGA1refG
         GDN22vALyXqWDwNdi2JIvM6LcjI+HUrPN4mt6FNnH51fKDtGlQO7PTLH9MPUVouxYnOH
         It35zz3soPS+IuLWBCFGN5CSUm/Sw+mcv3dQHCk4yb1nfTeJ4GlSMV8j/BMr2oK4da01
         YNGQ==
X-Gm-Message-State: APjAAAVAICMopNPK3H6T7ZeYrltCflquXjzzv8KHNm+YRk6uYwZtPqeJ
        sIKuH6lmZLjTyl1GqUKeS4U=
X-Google-Smtp-Source: APXvYqwjTbCQHT0tP1xb2u+q9VSASSwnBfI8GRbHdNBlR4UYOSZH3rCqo40PlkbXITn4o5c6m1XyeQ==
X-Received: by 2002:a65:628f:: with SMTP id f15mr5249252pgv.91.1574280296018;
        Wed, 20 Nov 2019 12:04:56 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id f19sm208219pfk.109.2019.11.20.12.04.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2019 12:04:55 -0800 (PST)
Subject: Re: possible race in __inet_lookup_established()
To:     Michal Kubecek <mkubecek@suse.cz>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>, Firo Yang <firo.yang@suse.com>
References: <20191120083919.GH27852@unicorn.suse.cz>
 <CANn89iJYXh7AwK8_Aiz3wXqugG0icPNW6OPsPxwOvpH90kr+Ew@mail.gmail.com>
 <20191120181046.GA29650@unicorn.suse.cz>
 <CANn89iLfX2CYKU7hPZkPTNiUoCUyW2PLznsVnxomu4JEWmkefQ@mail.gmail.com>
 <20191120195226.GB29650@unicorn.suse.cz>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <e9d19a66-94af-b4e8-255d-38a8cdc6f218@gmail.com>
Date:   Wed, 20 Nov 2019 12:04:53 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191120195226.GB29650@unicorn.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/20/19 11:52 AM, Michal Kubecek wrote:
> On Wed, Nov 20, 2019 at 11:13:09AM -0800, Eric Dumazet wrote:
>> On Wed, Nov 20, 2019 at 10:10 AM Michal Kubecek <mkubecek@suse.cz> wrote:
>>>
>>> On Wed, Nov 20, 2019 at 08:12:10AM -0800, Eric Dumazet wrote:
>>>> On Wed, Nov 20, 2019 at 12:39 AM Michal Kubecek <mkubecek@suse.cz> wrote:
>>>>
>>>>> Hello Eric,
>>>>>
>>>>> we are investigating a crash in socket lookup in a distribution kernel
>>>>> based on v4.12 but the possible problem we found seems to also apply to
>>>>> current mainline (or net) code.
>>>>>
>>>>> The common pattern is:
>>>>>
>>>>> - the crash always happens in __inet_lookup_established() in
>>>>>
>>>>>         sk_nulls_for_each_rcu(sk, node, &head->chain) {
>>>>>                 if (sk->sk_hash != hash)     <-----------------
>>>>>                         continue;
>>>>>
>>>>>   as sk is an invalid pointer; in particular, &sk->sk_nulls_node is null
>>>>>   so dereferencing sk->sk_hash faults
>>>>>
>>>>> - the reason is that previous sk value pointed to a listening socket
>>>>>   rather than an established one; as listening socket uses sk_node, end
>>>>>   of the chain is marked by a null pointer which is not detected as
>>>>>   a chain end by sk_nulls_for_each_rcu()
>>>>>
>>>>> - there is no socket matching skb which is a TCP pure ACK having
>>>>>   127.0.0.1 as both source and destination
>>>>>
>>>>> - the chain pointed to by head variable is empty
>>>>>
>>>>> Firo Yang came with the theory that this could be a race between socket
>>>>> lookup and freing the socket and replacing it with a listening one:
>>>>>
>>>>> 1. CPU A gets a pointer to an established socket as sk in the
>>>>> sk_nulls_for_each_rcu() loop in __inet_lookup_established() but does not
>>>>> thake a reference to it.
>>>>>
>>>>> 2. CPU B frees the socket
>>>>>
>>>>> 3. Slab object pointed to by sk is reused for a new listening socket.
>>>>> This socket has null sk->sk_node->next which uses the same spot as
>>>>> sk->sk_nulls_node->next
>>>>>
>>>>> 4. CPU A tests sk->sk_nulls_node->next with is_a_nulls() (false) and
>>>>> follows the pointer, resulting in a fault dereferencing sk->sk_hash.
>>>>>
>>>>> Unless we missed something, there is no protection against established
>>>>> socket being freed and replaced by a new listening one while
>>>>> __inet_lookup_established() has a pointer to it. The RCU loop only
>>>>> prevents the slab object being reused for a different slab cache or
>>>>> something completely different but as established and listening sockets
>>>>> share the same slab cache, it does not protect us from switching from
>>>>> established to listening.
>>>>>
>>>>> As far as I can say, this kind of race could have happened for quite
>>>>> long but before your commit ou3b24d854cb35 ("tcp/dccp: do not touch
>>>>> listener sk_refcnt under synflood"), the worst that could happen would
>>>>> be switching to a chain in listener lookup table, following it to its
>>>>> end and then (most likely) restarting the lookup or failing. Now that
>>>>> established and listening sockets use different list types, replacing
>>>>> one with the other can be deadly.
>>>>>
>>>>> Do you agree that this race is possible or is there something we missed
>>>>> that would prevent it?
>>>>>
>>>> A listener is hashed on icsk_listen_portaddr_node, so I do not see how a
>>>> listener could be found in the establish chain ?
>>>
>>> It is not really in the chain. What we suspect is that between sk is
>>> assigned pointer to an established socket in __inet_lookup_established()
>>> and using sk->sk_nulls_node->next to go to the next (or stop if it's odd
>>> nulls value), this established socket could be freed and its slab object
>>> reused for a listening socket. As listening sockets no longer use a
>>> nulls hashlist but a normal hashlist, in the most common case where the
>>> socket is last in the chain, sk->sk_node->next (which occupies the same
>>> place as sk->sk_nulls_node->next) would be NULL so that is_a_nulls()
>>> does not recognize the chain end and the loop would go on to next socket
>>> in the chain.
>>>
>>
>> I hear you, but where is the sk->sk_nulls_node->next would be set to
>> NULL exactly ?
> 
> In __inet_hash() when the new listening socket is inserted into the
> listening hashtable:
> 
> 	if (IS_ENABLED(CONFIG_IPV6) && sk->sk_reuseport &&
> 		sk->sk_family == AF_INET6)
> 		hlist_add_tail_rcu(&sk->sk_node, &ilb->head);
> 	else
> 		hlist_add_head_rcu(&sk->sk_node, &ilb->head);
> 
> If the chain is empty, sk->sk_node->next will be set to NULL by either
> branch. And even if it's not, the loop in __inet_lookup_established()
> would follow the chain from listening hashtable and still get to the
> NULL end marker eventually.


Oh right, I was confused by icsk_listen_portaddr_node, but listener use two
hashes...

Do you have a patch, or do you want me to work on a fix ?

