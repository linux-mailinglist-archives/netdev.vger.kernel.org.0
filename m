Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1047C36684A
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 11:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238487AbhDUJnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 05:43:21 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3950 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238011AbhDUJnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 05:43:20 -0400
Received: from localhost (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FQFsL4GxBz5spQ;
        Wed, 21 Apr 2021 17:40:22 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 DGGEML402-HUB.china.huawei.com (10.3.17.38) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Wed, 21 Apr 2021 17:42:13 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Wed, 21 Apr
 2021 17:42:12 +0800
Subject: Re: [PATCH net] net: fix use-after-free when UDP GRO with shared
 fraglist
To:     Dongseok Yi <dseok.yi@samsung.com>,
        'Willem de Bruijn' <willemdebruijn.kernel@gmail.com>
CC:     "'David S. Miller'" <davem@davemloft.net>,
        'Jakub Kicinski' <kuba@kernel.org>,
        'Miaohe Lin' <linmiaohe@huawei.com>,
        'Willem de Bruijn' <willemb@google.com>,
        'Paolo Abeni' <pabeni@redhat.com>,
        'Florian Westphal' <fw@strlen.de>,
        'Al Viro' <viro@zeniv.linux.org.uk>,
        'Guillaume Nault' <gnault@redhat.com>,
        'Steffen Klassert' <steffen.klassert@secunet.com>,
        "'Yadu Kishore'" <kyk.segfault@gmail.com>,
        'Marco Elver' <elver@google.com>,
        "'Network Development'" <netdev@vger.kernel.org>,
        'LKML' <linux-kernel@vger.kernel.org>, <namkyu78.kim@samsung.com>
References: <CGME20210104085750epcas2p1a5b22559d87df61ef3c8215ae0b470b5@epcas2p1.samsung.com>
 <1609750005-115609-1-git-send-email-dseok.yi@samsung.com>
 <CAF=yD-+bDdYg7X+WpP14w3fbv+JewySpdCbjdwWXB-syCwQ9uQ@mail.gmail.com>
 <017f01d6e3cb$698246a0$3c86d3e0$@samsung.com>
 <CAF=yD-Lg92JdpCU8CEQnutzi4VyS67_VNfAniRU=RxDvfYMruw@mail.gmail.com>
 <019b01d6e3dc$9a940330$cfbc0990$@samsung.com>
 <18999f48-7dc8-e859-8629-3b5cab764faa@huawei.com>
 <04f601d734b3$f5ca86c0$e15f9440$@samsung.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <e84b4a2b-a009-7c8c-c6c7-57f82ab74a59@huawei.com>
Date:   Wed, 21 Apr 2021 17:42:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <04f601d734b3$f5ca86c0$e15f9440$@samsung.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme718-chm.china.huawei.com (10.1.199.114) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/4/19 8:35, Dongseok Yi wrote:
> On Sat, Apr 17, 2021 at 11:44:35AM +0800, Yunsheng Lin wrote:
>>
>> On 2021/1/6 11:32, Dongseok Yi wrote:
>>> On 2021-01-06 12:07, Willem de Bruijn wrote:
>>>>
>>>> On Tue, Jan 5, 2021 at 8:29 PM Dongseok Yi <dseok.yi@samsung.com> wrote:
>>>>>
>>>>> On 2021-01-05 06:03, Willem de Bruijn wrote:
>>>>>>
>>>>>> On Mon, Jan 4, 2021 at 4:00 AM Dongseok Yi <dseok.yi@samsung.com> wrote:
>>>>>>>
>>>>>>> skbs in frag_list could be shared by pskb_expand_head() from BPF.
>>>>>>
>>>>>> Can you elaborate on the BPF connection?
>>>>>
>>>>> With the following registered ptypes,
>>>>>
>>>>> /proc/net # cat ptype
>>>>> Type Device      Function
>>>>> ALL           tpacket_rcv
>>>>> 0800          ip_rcv.cfi_jt
>>>>> 0011          llc_rcv.cfi_jt
>>>>> 0004          llc_rcv.cfi_jt
>>>>> 0806          arp_rcv
>>>>> 86dd          ipv6_rcv.cfi_jt
>>>>>
>>>>> BPF checks skb_ensure_writable between tpacket_rcv and ip_rcv
>>>>> (or ipv6_rcv). And it calls pskb_expand_head.
>>>>>
>>>>> [  132.051228] pskb_expand_head+0x360/0x378
>>>>> [  132.051237] skb_ensure_writable+0xa0/0xc4
>>>>> [  132.051249] bpf_skb_pull_data+0x28/0x60
>>>>> [  132.051262] bpf_prog_331d69c77ea5e964_schedcls_ingres+0x5f4/0x1000
>>>>> [  132.051273] cls_bpf_classify+0x254/0x348
>>>>> [  132.051284] tcf_classify+0xa4/0x180
>>>>
>>>> Ah, you have a BPF program loaded at TC. That was not entirely obvious.
>>>>
>>>> This program gets called after packet sockets with ptype_all, before
>>>> those with a specific protocol.
>>>>
>>>> Tcpdump will have inserted a program with ptype_all, which cloned the
>>>> skb. This triggers skb_ensure_writable -> pskb_expand_head ->
>>>> skb_clone_fraglist -> skb_get.
>>>>
>>>>> [  132.051294] __netif_receive_skb_core+0x590/0xd28
>>>>> [  132.051303] __netif_receive_skb+0x50/0x17c
>>>>> [  132.051312] process_backlog+0x15c/0x1b8
>>>>>
>>>>>>
>>>>>>> While tcpdump, sk_receive_queue of PF_PACKET has the original frag_list.
>>>>>>> But the same frag_list is queued to PF_INET (or PF_INET6) as the fraglist
>>>>>>> chain made by skb_segment_list().
>>>>>>>
>>>>>>> If the new skb (not frag_list) is queued to one of the sk_receive_queue,
>>>>>>> multiple ptypes can see this. The skb could be released by ptypes and
>>>>>>> it causes use-after-free.
>>>>>>
>>>>>> If I understand correctly, a udp-gro-list skb makes it up the receive
>>>>>> path with one or more active packet sockets.
>>>>>>
>>>>>> The packet socket will call skb_clone after accepting the filter. This
>>>>>> replaces the head_skb, but shares the skb_shinfo and thus frag_list.
>>>>>>
>>>>>> udp_rcv_segment later converts the udp-gro-list skb to a list of
>>>>>> regular packets to pass these one-by-one to udp_queue_rcv_one_skb.
>>>>>> Now all the frags are fully fledged packets, with headers pushed
>>>>>> before the payload. This does not change their refcount anymore than
>>>>>> the skb_clone in pf_packet did. This should be 1.
>>>>>>
>>>>>> Eventually udp_recvmsg will call skb_consume_udp on each packet.
>>>>>>
>>>>>> The packet socket eventually also frees its cloned head_skb, which triggers
>>>>>>
>>>>>>   kfree_skb_list(shinfo->frag_list)
>>>>>>     kfree_skb
>>>>>>       skb_unref
>>>>>>         refcount_dec_and_test(&skb->users)
>>>>>
>>>>> Every your understanding is right, but
>>>>>
>>>>>>
>>>>>>>
>>>>>>> [ 4443.426215] ------------[ cut here ]------------
>>>>>>> [ 4443.426222] refcount_t: underflow; use-after-free.
>>>>>>> [ 4443.426291] WARNING: CPU: 7 PID: 28161 at lib/refcount.c:190
>>>>>>> refcount_dec_and_test_checked+0xa4/0xc8
>>>>>>> [ 4443.426726] pstate: 60400005 (nZCv daif +PAN -UAO)
>>>>>>> [ 4443.426732] pc : refcount_dec_and_test_checked+0xa4/0xc8
>>>>>>> [ 4443.426737] lr : refcount_dec_and_test_checked+0xa0/0xc8
>>>>>>> [ 4443.426808] Call trace:
>>>>>>> [ 4443.426813]  refcount_dec_and_test_checked+0xa4/0xc8
>>>>>>> [ 4443.426823]  skb_release_data+0x144/0x264
>>>>>>> [ 4443.426828]  kfree_skb+0x58/0xc4
>>>>>>> [ 4443.426832]  skb_queue_purge+0x64/0x9c
>>>>>>> [ 4443.426844]  packet_set_ring+0x5f0/0x820
>>>>>>> [ 4443.426849]  packet_setsockopt+0x5a4/0xcd0
>>>>>>> [ 4443.426853]  __sys_setsockopt+0x188/0x278
>>>>>>> [ 4443.426858]  __arm64_sys_setsockopt+0x28/0x38
>>>>>>> [ 4443.426869]  el0_svc_common+0xf0/0x1d0
>>>>>>> [ 4443.426873]  el0_svc_handler+0x74/0x98
>>>>>>> [ 4443.426880]  el0_svc+0x8/0xc
>>>>>>>
>>>>>>> Fixes: 3a1296a38d0c (net: Support GRO/GSO fraglist chaining.)
>>>>>>> Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
>>>>>>> ---
>>>>>>>  net/core/skbuff.c | 20 +++++++++++++++++++-
>>>>>>>  1 file changed, 19 insertions(+), 1 deletion(-)
>>>>>>>
>>>>>>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>>>>>>> index f62cae3..1dcbda8 100644
>>>>>>> --- a/net/core/skbuff.c
>>>>>>> +++ b/net/core/skbuff.c
>>>>>>> @@ -3655,7 +3655,8 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
>>>>>>>         unsigned int delta_truesize = 0;
>>>>>>>         unsigned int delta_len = 0;
>>>>>>>         struct sk_buff *tail = NULL;
>>>>>>> -       struct sk_buff *nskb;
>>>>>>> +       struct sk_buff *nskb, *tmp;
>>>>>>> +       int err;
>>>>>>>
>>>>>>>         skb_push(skb, -skb_network_offset(skb) + offset);
>>>>>>>
>>>>>>> @@ -3665,11 +3666,28 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
>>>>>>>                 nskb = list_skb;
>>>>>>>                 list_skb = list_skb->next;
>>>>>>>
>>>>>>> +               err = 0;
>>>>>>> +               if (skb_shared(nskb)) {
>>>>>>
>>>>>> I must be missing something still. This does not square with my
>>>>>> understanding that the two sockets are operating on clones, with each
>>>>>> frag_list skb having skb->users == 1.
>>>>>>
>>>>>> Unless the packet socket patch previously also triggered an
>>>>>> skb_unclone/pskb_expand_head, as that call skb_clone_fraglist, which
>>>>>> calls skb_get on each frag_list skb.
>>>>>
>>>>> A cloned skb after tpacket_rcv cannot go through skb_ensure_writable
>>>>> with the original shinfo. pskb_expand_head reallocates the shinfo of
>>>>> the skb and call skb_clone_fraglist. skb_release_data in
>>>>> pskb_expand_head could not reduce skb->users of the each frag_list skb
>>>>> if skb_shinfo(skb)->dataref == 2.
>>>>>
>>>>> After the reallocation, skb_shinfo(skb)->dataref == 1 but each frag_list
>>>>> skb could have skb->users == 2.
>>
>> Hi, Dongseok
>>    I understand there is liner head data shared between the frag_list skb in the
>> cloned skb(cloned by pf_packet?) and original skb, which should not be shared
>> when skb_segment_list() converts the frag_list skb into regular packet.
>>
>>    But both skb->users of original and cloned skb is one(skb_shinfo(skb)->dataref
>> is one for both skb too), and skb->users of each fraglist skb is two because both
>> original and cloned skb is linking to the same fraglist pointer, and there is
>> "skb_shinfo(skb)->frag_list = NULL" for original skb in the begin of skb_segment_list(),
>> if kfree_skb() is called with original skb, the fraglist skb will not be freed.
>> If kfree_skb is called with original skb,cloned skb and each fraglist skb here, the
>> reference counter for three of them seem right here, so why is there a refcount_t
>> warning in the commit log? am I missing something obvious here?
>>
>> Sorry for bringing up this thread again.
> 
> A skb which detects use-after-free was not a part of frag_list. Please
> check the commit msg once again.

I checked the commit msg again, but still have not figured it out yet:)

So I tried to see if I understand the skb'reference counting correctly:

skb->user is used to reference counting the "struct sk_buff", and
skb_shinfo(skb)->dataref is used to reference counting head data.

skb_clone(): allocate a sperate "struct sk_buff" but share the head data
             with the original skb, so skb_shinfo()->dataref need
             incrmenting.

pskb_expand_head(): allocate a sperate head data(which includes the space
                    for skb_shinfo(skb)), since the original head data
		    and the new head data' skb_shinfo()->frag_list both
                    point to the same fraglist skb, so each fraglist_skb's
		    skb->users need incrmenting, and original head data's
		    skb_shinfo() need decrmenting.


So after pf_packet called skb_clone() and pskb_expand_head(), we have:

    old skb              new skb
      |                     |
      |                     |
old head data         new head data
        \                   /
          \                /
           \              /
             \           /
              \         /
             fraglist_skb1 -> fraglist_skb2 -> fraglist_skb3 .....

So both old and new skb' skb->user is one, both old and new head data's
skb_shinfo()->dataref is one, and both old and new head data'
skb_shinfo()->frag_list points to fraglist_skb1, and each fraglist_skb's
skb->user is two.

Each fraglist_skb points to a head data, and its skb_shinfo()->dataref
is one too.

Suppose old skb is called with skb_segment_list(), without this patch,
we have:

                         new skb
                            |
                            |
                     new head data
                            /
                           /
                          /
                         /
                        /
       old skb -> fraglist_skb1 -> fraglist_skb2 -> fraglist_skb3 .....
          |
          |
    old head data

And old skb and each fraglist_skb become a regular packet, so freeing
the old skb, new skb and each fraglist_skb here do not seems to have
any reference counting problem, because each fraglist_skb's skb->user
is two, right?

> 
> Both sk_receive_queue of PF_PACKET and PF_INET (or PF_INET6) can have
> a link for the same frag_skbs chain. 

Does "frag_skbs chain" means fraglist_skb1? It seems only new head data's
skb_shinfo()->frag_list points to fraglist_skb1


If a new skb (*not frags*) is
> queued to one of the sk_receive_queue, multiple ptypes can see and
> release this. It causes use-after-free.

Does "a new skb" mean each fraglist_skb after skb_segment_list()? Or other
new incoming skb?

I am not so familiar with the PF_PACKET and PF_INET, so still have hard
time figuring how the reference counting goes wrong here:)

> 
>>
>>>>
>>>> Yes, that makes sense. skb_clone_fraglist just increments the
>>>> frag_list skb's refcounts.
>>>>
>>>> skb_segment_list must create an unshared struct sk_buff before it
>>>> changes skb data to insert the protocol headers.
>>>>
> 
> 
> 
> .
> 

