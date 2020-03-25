Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D40B519306A
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 19:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbgCYSbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 14:31:31 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41970 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727027AbgCYSbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 14:31:31 -0400
Received: by mail-pl1-f194.google.com with SMTP id t16so1128767plr.8;
        Wed, 25 Mar 2020 11:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M66oudythcBmFzgaHHj4NT8FrhMNeWSRLde1HiyDOR8=;
        b=HdIw1VMtWl2/2v1yXgAGAvreoa07Z20PO0djS3sVwAtLM+I7s5xRzIEe35oeHcvOrG
         cwFVGXVUQOJJqneRGY67rC3nCMlhstYrxOCNk0weqkxLAfMWJIviyvLxqy0I/2HLvESk
         44NlcSXlhfC7jowxQIX3LQowQDc9nZyNP4risf6//MlSbccq3ynTm7352WA9eUVpDATC
         VNVcFYALK9g0a+YKJshkj2j6qvZZMMcbQEZn8FyGqUGQJqxMEjOOMWR2ZVKhmKo2jB/+
         nBbJJba1GA0gzI0fFguMwUaZAwc7vQJZYUsuEJUD4ugU390rpOwLqqR97Dwl5LVzGmFv
         SAUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M66oudythcBmFzgaHHj4NT8FrhMNeWSRLde1HiyDOR8=;
        b=Oh5nx/KlzV1eGnZowLrn192fpIYPgAq8k2NIkd04Sdu93DN8hMewDnMNK4GdoLIFpm
         xWLm0IFr7KxWVeTuCMeFRq8gVpwNAEM2mILlAgOCtlF8BhGRlqgSofy1Gj+kn/rety/e
         erSPKynoGySVkSOef1YH/2+3pi2uIdhji9JXNnkZoPiHX80mtWI/HTOi/V473yDBFroP
         oHaRTCno8Q6ibcVoj1fp/DwP7EJzKH2DHaAfR0iZdoU+Ay9a8NHJFDkifPx1x59LcN1n
         VntGTqXcskMmkUx0QCgOKn1PPtvqmUwQnDovaGFVFZ7rLD0Pzs1Q0BaAW59B9IkNAdz9
         khqA==
X-Gm-Message-State: ANhLgQ1sPMWVed55N7+M9SN0qI4+TmZ0jpW323lshkamdlm/cOEpH2fa
        lSvsCHCpNkAFyT3nHyKypRXiRt2r
X-Google-Smtp-Source: ADFU+vssZ5U0bJU3qIeF4S+sN+yu4Z4W+PRBw9CRTewhGgo1Cmv7BvqExtGeQsOKVqHQSE5cQnk4fw==
X-Received: by 2002:a17:902:a9cc:: with SMTP id b12mr4365819plr.177.1585161089735;
        Wed, 25 Mar 2020 11:31:29 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id c15sm17083869pgk.66.2020.03.25.11.31.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2020 11:31:28 -0700 (PDT)
Subject: Re: [PATCH] ipv4: fix a RCU-list lock in fib_triestat_seq_show
To:     Qian Cai <cai@lca.pw>, Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <5e2ed86a-23bc-d3e5-05ad-4e7ed147539c@gmail.com>
 <92C7474D-4592-44BF-B0ED-26253196511E@lca.pw>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <8ae16be2-9c64-245e-0997-805f48078432@gmail.com>
Date:   Wed, 25 Mar 2020 11:31:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <92C7474D-4592-44BF-B0ED-26253196511E@lca.pw>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/25/20 10:34 AM, Qian Cai wrote:
> 
> 
>> On Mar 25, 2020, at 12:13 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>> I would prefer :
>>
>> diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
>> index ff0c24371e3309b3068980f46d1ed743337d2a3e..4b98ffb27136d3b43f179d6b1b42fe84586acc06 100644
>> --- a/net/ipv4/fib_trie.c
>> +++ b/net/ipv4/fib_trie.c
>> @@ -2581,6 +2581,7 @@ static int fib_triestat_seq_show(struct seq_file *seq, void *v)
>>                struct hlist_head *head = &net->ipv4.fib_table_hash[h];
>>                struct fib_table *tb;
>>
>> +               rcu_read_lock();
>>                hlist_for_each_entry_rcu(tb, head, tb_hlist) {
>>                        struct trie *t = (struct trie *) tb->tb_data;
>>                        struct trie_stat stat;
>> @@ -2596,6 +2597,7 @@ static int fib_triestat_seq_show(struct seq_file *seq, void *v)
>>                        trie_show_usage(seq, t->stats);
>> #endif
>>                }
>> +               rcu_read_unlock();
>>        }
>>
>>        return 0;
> 
> I have no strong opinion either way. My initial thought was to save 255 extra lock/unlock with a single lock/unlock, but I am not sure how time-consuming for each iteration of the outer loop could be. If it could take a bit too long, it does make a lot of sense to reduce the critical section.
> 


This file could be quite big in some setups.

Alternatively you could use cond_resched_rcu()

