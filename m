Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 080242617C4
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 19:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731737AbgIHRmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 13:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731649AbgIHRlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 13:41:16 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E80C061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 10:41:15 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id m1so16195541ilj.10
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 10:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yo0m/fl1bsbi5XrUnv7pYXfGQx7xN3RMtbnGiNGF5oQ=;
        b=aH86ep1dYlBbqUj8l9Uy1hhr82AgxtUkLZteiwhA0aalJL2dBQHCShU7Ddg3YiIIfl
         SIAVRmyrgthRaTj9y//nqFZ/rk2aUXXGei3LX+Qm7A6Vl5bJNaqfMjb/JgnsSmNDq9SK
         oqBDhTxVOU5qVRaAT94czFfCldYrFP+A7mPr9E9dlxQO+DzO5WGrXR0Z8UlBQGsgKjRC
         YryyYCEVxxb4MzSfIIkPQsADr5F4/5RNqoXUuw4TuspAz0mh1FPkEDM2DmZnEve1ZqBL
         HY8HRqQRxVg6o2H/EVFgBoAs2vtpAm652xIwykmQ+5k7Iz1NAHg6qf2tNKzRg8L9KK5e
         z0Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yo0m/fl1bsbi5XrUnv7pYXfGQx7xN3RMtbnGiNGF5oQ=;
        b=TlnxdAOMmxzSak0OU1CHSZG/fry+ZoVsn+UR6DjM0CQdpeuHA7togyEkFH4eiApSXC
         xQDbJMpCJ410Mkvh4NpB4mATpaOrAQSC/KH6iiX6mgzxjcmp3KyBmWMTkZkSIrPmT9i8
         Ah6TmJ37KPOVM6zNcOM/5ll81kMkXanymgvNSnW/2vrl+q5wRbvPoKdc+EsnJRnRqPqH
         9xkH9eW9VFi5Nmf0gebH3dQvBkC5nO/Ry30HNqHejHTlyyb/3jJACdKHl2KTsyGUqqX3
         s+KoGDUn1ZWcVavaQXCxCZNDAKd6E6siBhhPVGdHatJGLpiZ6Y0al5N84PY5jBbA4SnG
         PbsA==
X-Gm-Message-State: AOAM530EWck3QpcbiqRgknhLJujVCKWbnUANbkZbDgcvj6eA/nRZ2LAq
        fK0WflW7lGNDMYvhEUqGn92mLqcKhSsjJA==
X-Google-Smtp-Source: ABdhPJz5zxsLdo/Ety8Rz/zSAQ6s4baqEmR3um494b9kiBB4QKHIwV3qHfEm0+Hfmd2gVPQ4dhjZ1Q==
X-Received: by 2002:a92:c605:: with SMTP id p5mr24102916ilm.194.1599586874967;
        Tue, 08 Sep 2020 10:41:14 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:ec70:7b06:eed6:6e35])
        by smtp.googlemail.com with ESMTPSA id p65sm10973666ill.23.2020.09.08.10.41.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 10:41:14 -0700 (PDT)
Subject: Re: [PATCH net] ipv6: avoid lockdep issue in fib6_del()
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Ben Greear <greearb@candelatech.com>
References: <20200908082023.3690438-1-edumazet@google.com>
 <7f56f2d0-e741-bc24-c671-14e53607be2b@gmail.com>
 <CANn89iLxQB7HQRq7fFBp7DoypkzbTeR-=p_04FoUn9uw-s+jig@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5f95d746-27d0-a7c9-9cff-0cc60b7c1c73@gmail.com>
Date:   Tue, 8 Sep 2020 11:41:13 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CANn89iLxQB7HQRq7fFBp7DoypkzbTeR-=p_04FoUn9uw-s+jig@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/8/20 11:06 AM, Eric Dumazet wrote:
> On Tue, Sep 8, 2020 at 6:50 PM David Ahern <dsahern@gmail.com> wrote:
>>
>> On 9/8/20 2:20 AM, Eric Dumazet wrote:
>>> syzbot reported twice a lockdep issue in fib6_del() [1]
>>> which I think is caused by net->ipv6.fib6_null_entry
>>> having a NULL fib6_table pointer.
>>>
>>> fib6_del() already checks for fib6_null_entry special
>>> case, we only need to return earlier.
>>>
>>> Bug seems to occur very rarely, I have thus chosen
>>> a 'bug origin' that makes backports not too complex.
>>>
>>> [1]
>>> WARNING: suspicious RCU usage
>>> 5.9.0-rc4-syzkaller #0 Not tainted
>>> -----------------------------
>>> net/ipv6/ip6_fib.c:1996 suspicious rcu_dereference_protected() usage!
>>>
>>> other info that might help us debug this:
>>>
>>> rcu_scheduler_active = 2, debug_locks = 1
>>> 4 locks held by syz-executor.5/8095:
>>>  #0: ffffffff8a7ea708 (rtnl_mutex){+.+.}-{3:3}, at: ppp_release+0x178/0x240 drivers/net/ppp/ppp_generic.c:401
>>>  #1: ffff88804c422dd8 (&net->ipv6.fib6_gc_lock){+.-.}-{2:2}, at: spin_trylock_bh include/linux/spinlock.h:414 [inline]
>>>  #1: ffff88804c422dd8 (&net->ipv6.fib6_gc_lock){+.-.}-{2:2}, at: fib6_run_gc+0x21b/0x2d0 net/ipv6/ip6_fib.c:2312
>>>  #2: ffffffff89bd6a40 (rcu_read_lock){....}-{1:2}, at: __fib6_clean_all+0x0/0x290 net/ipv6/ip6_fib.c:2613
>>>  #3: ffff8880a82e6430 (&tb->tb6_lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:359 [inline]
>>>  #3: ffff8880a82e6430 (&tb->tb6_lock){+.-.}-{2:2}, at: __fib6_clean_all+0x107/0x290 net/ipv6/ip6_fib.c:2245
>>>
>>> stack backtrace:
>>> CPU: 1 PID: 8095 Comm: syz-executor.5 Not tainted 5.9.0-rc4-syzkaller #0
>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>>> Call Trace:
>>>  __dump_stack lib/dump_stack.c:77 [inline]
>>>  dump_stack+0x198/0x1fd lib/dump_stack.c:118
>>>  fib6_del+0x12b4/0x1630 net/ipv6/ip6_fib.c:1996
>>>  fib6_clean_node+0x39b/0x570 net/ipv6/ip6_fib.c:2180
>>>  fib6_walk_continue+0x4aa/0x8e0 net/ipv6/ip6_fib.c:2102
>>>  fib6_walk+0x182/0x370 net/ipv6/ip6_fib.c:2150
>>>  fib6_clean_tree+0xdb/0x120 net/ipv6/ip6_fib.c:2230
>>>  __fib6_clean_all+0x120/0x290 net/ipv6/ip6_fib.c:2246
>>
>> This is walking a table and __fib6_clean_all takes the lock for the
>> table (and you can see that above), so puzzling how fib6_del can be
>> called for an entry with NULL fib6_table.
> 
> So you think the test for  (rt == net->ipv6.fib6_null_entry)
> should be replaced by
> 
> BUG_ON(rt == net->ipv6.fib6_null_entry); ?
> 

BUG_ON does not seem right.

Backing out to the callers, why does fib6_clean_node not catch that it
is the root of the table and abort the walk or at least not try to
remove the root? This might be related to the problem Ben has complained
about many times.

If syzbot has only triggered it a few times then I presume no reproducer.
