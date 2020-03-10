Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F01817EEB7
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 03:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgCJCiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 22:38:16 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:37961 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbgCJCiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 22:38:16 -0400
Received: by mail-pj1-f66.google.com with SMTP id a16so780865pju.3
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 19:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vubFlN6vt5FKZJ85gc+LN+8u0ApoaQ2vqaEF0h22X54=;
        b=faVOY51BoeZq0OCjNwMscyfrHMDqP3JUxLzCUBfF267QW/K0Xki1LkCkqx9c6RP8Zy
         FpLx3+RmoaN8ApMfQoYwvzjsD3SbIcERlsb+to443vT+awcWj8W5F6b/EFphaKXfH4ez
         Em23LGbKs3ovS0oy4W5Ih3UyQHtcz1WHbhDcrvnLtlTKOrltnv7zM2dlN/WwpvQxlvD/
         pvjR6QD0Nm6yDaT58oWuPY1t4kGqDoujLXi+5j11nCSfPkCdyo7gtmF4Mc8Iz0n7xsgs
         6MCaRZt6IsXshu2i+UIFfEoVYNTdzj7dMIq18ntPWu+yzww7PG2fQym+GnBRl03eGRrb
         U3XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vubFlN6vt5FKZJ85gc+LN+8u0ApoaQ2vqaEF0h22X54=;
        b=cRHtTQrqYniBmpgo9ojcLGvfOjzOsfZEWOstJCrZ9CZ0iB7MW5geqq+gHPgKbgH2vM
         RIbeZkRqNFyz6p2GMxhF4OXixDk2ImWzfVL++6u1q6ZmO53iXWm2MDoOmQXp7R0ykuwz
         MIihijIF554/XYQcqZu/VpuQ77C51YXdwADNmOdFgpTXXiAVI8dVjOT/zFOfS+BJN6E+
         gm1L0SPdQ3j7Z3VFqbI6Pqr7acOdddamYONETSv1lqYGWG7RlSBEfT/S8GMhRFZaaG/Q
         N9vGLeKiA4AVDZewszpfMbronVhVE5400CAN8UCvy6TWa9LC3RebO6nEM728MbKGuZYF
         AnvQ==
X-Gm-Message-State: ANhLgQ3YRdOfXh9IqS52hGRS6QciKtteYZnuxn1SRbEJZlYD7tg4i/H+
        C06zd+vYyPma23p2unCG4Rs=
X-Google-Smtp-Source: ADFU+vttIJaVy9jEYHAYNI09b94utyBtKWdZerO3pieIuRW/t04hitidDvCHCuxzd9JmmicL9TihYg==
X-Received: by 2002:a17:90b:3692:: with SMTP id mj18mr2352014pjb.170.1583807894748;
        Mon, 09 Mar 2020 19:38:14 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id z4sm43318964pfn.42.2020.03.09.19.38.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2020 19:38:14 -0700 (PDT)
Subject: Re: [PATCH net] ipvlan: add cond_resched_rcu() while processing
 muticast backlog
To:     =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS1?=
         =?UTF-8?B?4KS+4KSwKQ==?= <maheshb@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        syzbot <syzkaller@googlegroups.com>
References: <20200309225702.63695-1-maheshb@google.com>
 <eff143b1-1c88-4ed7-ff59-b25ac0dfd42f@gmail.com>
 <CAF2d9jiRovyHkASL=BO2q3TF1CAfoa_yN9jckF8oS1Czx+x47w@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <4b5f9ff7-12ab-9402-60c1-8a9ee852700d@gmail.com>
Date:   Mon, 9 Mar 2020 19:38:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAF2d9jiRovyHkASL=BO2q3TF1CAfoa_yN9jckF8oS1Czx+x47w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/9/20 7:21 PM, Mahesh Bandewar (महेश बंडेवार) wrote:
> On Mon, Mar 9, 2020 at 6:07 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>>
>>
>> On 3/9/20 3:57 PM, Mahesh Bandewar wrote:
>>> If there are substantial number of slaves created as simulated by
>>> Syzbot, the backlog processing could take much longer and result
>>> into the issue found in the Syzbot report.
>>>
>>
>> ...
>>
>>>
>>> Fixes: ba35f8588f47 (“ipvlan: Defer multicast / broadcast processing to a work-queue”)
>>> Signed-off-by: Mahesh Bandewar <maheshb@google.com>
>>> Reported-by: syzbot <syzkaller@googlegroups.com>
>>> ---
>>>  drivers/net/ipvlan/ipvlan_core.c | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan_core.c
>>> index 53dac397db37..5759e91dec71 100644
>>> --- a/drivers/net/ipvlan/ipvlan_core.c
>>> +++ b/drivers/net/ipvlan/ipvlan_core.c
>>> @@ -277,6 +277,7 @@ void ipvlan_process_multicast(struct work_struct *work)
>>>                       }
>>>                       ipvlan_count_rx(ipvlan, len, ret == NET_RX_SUCCESS, true);
>>>                       local_bh_enable();
>>> +                     cond_resched_rcu();
>>
>> This does not work : If you release rcu_read_lock() here,
>> then the surrounding loop can not be continued without risking use-after-free
>>
> .. but cond_resched_rcu() is nothing but
>       rcu_read_unlock(); cond_resched(); rcu_read_lock();
> 
> isn't that sufficient?

It is buggy.

Think about iterating a list with a spinlock protection.

Then in the middle of the loop, releasing the spinlock and re-acquiring it.

The cursor in the loop might point to freed memory.

Same for rcu really.

> 
>> rcu_read_lock();
>> list_for_each_entry_rcu(ipvlan, &port->ipvlans, pnode) {
>>     ...
>>     cond_resched_rcu();
>>     // after this point bad things can happen
>> }
>>
>>
>> You probably should do instead :
>>
>> diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan_core.c
>> index 30cd0c4f0be0b4d1dea2c0a4d68d0e33d1931ebc..57617ff5565fb87035c13dcf1de9fa5431d04e10 100644
>> --- a/drivers/net/ipvlan/ipvlan_core.c
>> +++ b/drivers/net/ipvlan/ipvlan_core.c
>> @@ -293,6 +293,7 @@ void ipvlan_process_multicast(struct work_struct *work)
>>                 }
>>                 if (dev)
>>                         dev_put(dev);
>> +               cond_resched();
>>         }
> 
> reason this may not work is because the inner loop is for slaves for a
> single packet and if there are 1k slaves, then skb_clone() will be
> called 1k times before doing cond_reched() and the problem may not
> even get mitigated.


The problem that syzbot found is that queuing IPVLAN_QBACKLOG_LIMIT (1000) packets on the backlog
could force the ipvlan_process_multicast() worker to process 1000 packets.

Multiply this by the number of slaves, say 1000 -> 1,000,000 skbs clones.

After the patch, we divide by 1000 the time taken in one invocation,
that should be just good enough.

You do not need to schedule after _each_ clone.

Think about netdev_max_backlog which is set to 1000 : we believe it is fine
to process 1000 packets per round.


