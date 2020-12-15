Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A27C52DB79D
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 01:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgLPABP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 19:01:15 -0500
Received: from www62.your-server.de ([213.133.104.62]:44754 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727745AbgLOXXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 18:23:51 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kpJeu-0005YW-C4; Wed, 16 Dec 2020 00:23:08 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kpJeu-000KOi-5E; Wed, 16 Dec 2020 00:23:08 +0100
Subject: Re: [Patch bpf-next v2 2/5] bpf: introduce timeout map
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Dongdong Wang <wangdongdong.6@bytedance.com>
References: <20201214201118.148126-1-xiyou.wangcong@gmail.com>
 <20201214201118.148126-3-xiyou.wangcong@gmail.com>
 <CAEf4BzZa15kMT+xEO9ZBmS-1=E85+k02zeddx+a_N_9+MOLhkQ@mail.gmail.com>
 <CAM_iQpVR_owLgZp1tYJyfWco-s4ov_ytL6iisg3NmtyPBdbO2Q@mail.gmail.com>
 <CAEf4BzbyHHDrECCEjrSC3A5X39qb_WZaU_3_qNONP+vHAcUzuQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1de72112-d2b8-24c5-de29-0d3dfd361f16@iogearbox.net>
Date:   Wed, 16 Dec 2020 00:23:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzbyHHDrECCEjrSC3A5X39qb_WZaU_3_qNONP+vHAcUzuQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26018/Tue Dec 15 15:37:09 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/15/20 11:03 PM, Andrii Nakryiko wrote:
> On Tue, Dec 15, 2020 at 12:06 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>>
>> On Tue, Dec 15, 2020 at 11:27 AM Andrii Nakryiko
>> <andrii.nakryiko@gmail.com> wrote:
>>>
>>> On Mon, Dec 14, 2020 at 12:17 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>>>>
>>>> From: Cong Wang <cong.wang@bytedance.com>
>>>>
>>>> This borrows the idea from conntrack and will be used for conntrack in
>>>> bpf too. Each element in a timeout map has a user-specified timeout
>>>> in secs, after it expires it will be automatically removed from the map.
[...]
>>>>          char key[] __aligned(8);
>>>>   };
>>>>
>>>> @@ -143,6 +151,7 @@ static void htab_init_buckets(struct bpf_htab *htab)
>>>>
>>>>          for (i = 0; i < htab->n_buckets; i++) {
>>>>                  INIT_HLIST_NULLS_HEAD(&htab->buckets[i].head, i);
>>>> +               atomic_set(&htab->buckets[i].pending, 0);
>>>>                  if (htab_use_raw_lock(htab)) {
>>>>                          raw_spin_lock_init(&htab->buckets[i].raw_lock);
>>>>                          lockdep_set_class(&htab->buckets[i].raw_lock,
>>>> @@ -431,6 +440,14 @@ static int htab_map_alloc_check(union bpf_attr *attr)
>>>>          return 0;
>>>>   }
>>>>
>>>> +static void htab_sched_gc(struct bpf_htab *htab, struct bucket *b)
>>>> +{
>>>> +       if (atomic_fetch_or(1, &b->pending))
>>>> +               return;
>>>> +       llist_add(&b->gc_node, &htab->gc_list);
>>>> +       queue_work(system_unbound_wq, &htab->gc_work);
>>>> +}
>>>
>>> I'm concerned about each bucket being scheduled individually... And
>>> similarly concerned that each instance of TIMEOUT_HASH will do its own
>>> scheduling independently. Can you think about the way to have a
>>> "global" gc/purging logic, and just make sure that buckets that need
>>> processing would be just internally chained together. So the purging
>>> routing would iterate all the scheduled hashmaps, and within each it
>>> will have a linked list of buckets that need processing? And all that
>>> is done just once each GC period. Not N times for N maps or N*M times
>>> for N maps with M buckets in each.
>>
>> Our internal discussion went to the opposite actually, people here argued
>> one work is not sufficient for a hashtable because there would be millions
>> of entries (max_entries, which is also number of buckets). ;)
> 
> I was hoping that it's possible to expire elements without iterating
> the entire hash table every single time, only items that need to be
> processed. Hashed timing wheel is one way to do something like this,
> kernel has to solve similar problems with timeouts as well, why not
> taking inspiration there?

Couldn't this map be coupled with LRU map for example through flag on map
creation so that the different LRU map flavors can be used with it? For BPF
CT use case we do rely on LRU map to purge 'inactive' entries once full. I
wonder if for that case you then still need to schedule a GC at all.. e.g.
if you hit the condition time_after_eq64(now, entry->expires) you'd just
re-link the expired element from the public htab to e.g. the LRU's local
CPU's free/pending-list instead.

Thanks,
Daniel
