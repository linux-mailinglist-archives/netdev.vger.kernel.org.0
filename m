Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED3CBAD68
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 07:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389091AbfIWFIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 01:08:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46736 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730271AbfIWFIt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Sep 2019 01:08:49 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 35C50308427D;
        Mon, 23 Sep 2019 05:08:48 +0000 (UTC)
Received: from [10.72.12.37] (ovpn-12-37.pek2.redhat.com [10.72.12.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DAD0A60166;
        Mon, 23 Sep 2019 05:08:37 +0000 (UTC)
Subject: Re: [PATCH net-next] tuntap: Fallback to automq on TUNSETSTEERINGEBPF
 prog negative return
To:     Matt Cover <werekraken@gmail.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com,
        Eric Dumazet <edumazet@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Matthew Cover <matthew.cover@stackpath.com>,
        mail@timurcelik.de, pabeni@redhat.com,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        wangli39@baidu.com, lifei.shirley@bytedance.com,
        tglx@linutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <20190920185843.4096-1-matthew.cover@stackpath.com>
 <20190922080326-mutt-send-email-mst@kernel.org>
 <CAGyo_hqGbFdt1PoDrmo=S5iTO8TwbrbtOJtbvGT1WrFFMLwk-Q@mail.gmail.com>
 <0f4541d9-a405-6185-7e54-112dc9188146@redhat.com>
 <CAGyo_hp-PJUg7GWFK996vqRxn=cCEdE=hcWdYhyf4K-nSU9qYQ@mail.gmail.com>
 <df4ee92f-89e4-70a7-2de8-49fa4acfa08e@redhat.com>
 <CAGyo_hrM8TzTp6L77x-_18XZn+NEcDyZXAxnwgNaCgMBLpCMPg@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <9998f40c-995a-899d-a861-c7788ba6d5dc@redhat.com>
Date:   Mon, 23 Sep 2019 13:08:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAGyo_hrM8TzTp6L77x-_18XZn+NEcDyZXAxnwgNaCgMBLpCMPg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Mon, 23 Sep 2019 05:08:48 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/9/23 上午11:00, Matt Cover wrote:
> On Sun, Sep 22, 2019 at 7:32 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> On 2019/9/23 上午9:20, Matt Cover wrote:
>>> On Sun, Sep 22, 2019 at 5:46 PM Jason Wang <jasowang@redhat.com> wrote:
>>>> On 2019/9/23 上午1:43, Matt Cover wrote:
>>>>> On Sun, Sep 22, 2019 at 5:37 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>>>>>> On Fri, Sep 20, 2019 at 11:58:43AM -0700, Matthew Cover wrote:
>>>>>>> Treat a negative return from a TUNSETSTEERINGEBPF bpf prog as a signal
>>>>>>> to fallback to tun_automq_select_queue() for tx queue selection.
>>>>>>>
>>>>>>> Compilation of this exact patch was tested.
>>>>>>>
>>>>>>> For functional testing 3 additional printk()s were added.
>>>>>>>
>>>>>>> Functional testing results (on 2 txq tap device):
>>>>>>>
>>>>>>>      [Fri Sep 20 18:33:27 2019] ========== tun no prog ==========
>>>>>>>      [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returned '-1'
>>>>>>>      [Fri Sep 20 18:33:27 2019] tuntap: tun_automq_select_queue() ran
>>>>>>>      [Fri Sep 20 18:33:27 2019] ========== tun prog -1 ==========
>>>>>>>      [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() returned '-1'
>>>>>>>      [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returned '-1'
>>>>>>>      [Fri Sep 20 18:33:27 2019] tuntap: tun_automq_select_queue() ran
>>>>>>>      [Fri Sep 20 18:33:27 2019] ========== tun prog 0 ==========
>>>>>>>      [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() returned '0'
>>>>>>>      [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returned '0'
>>>>>>>      [Fri Sep 20 18:33:27 2019] ========== tun prog 1 ==========
>>>>>>>      [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() returned '1'
>>>>>>>      [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returned '1'
>>>>>>>      [Fri Sep 20 18:33:27 2019] ========== tun prog 2 ==========
>>>>>>>      [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() returned '2'
>>>>>>>      [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returned '0'
>>>>>>>
>>>>>>> Signed-off-by: Matthew Cover <matthew.cover@stackpath.com>
>>>>>> Could you add a bit more motivation data here?
>>>>> Thank you for these questions Michael.
>>>>>
>>>>> I'll plan on adding the below information to the
>>>>> commit message and submitting a v2 of this patch
>>>>> when net-next reopens. In the meantime, it would
>>>>> be very helpful to know if these answers address
>>>>> some of your concerns.
>>>>>
>>>>>> 1. why is this a good idea
>>>>> This change allows TUNSETSTEERINGEBPF progs to
>>>>> do any of the following.
>>>>>     1. implement queue selection for a subset of
>>>>>        traffic (e.g. special queue selection logic
>>>>>        for ipv4, but return negative and use the
>>>>>        default automq logic for ipv6)
>>>> Well, using ebpf means it need to take care of all the cases. E.g you
>>>> can easily implement the fallback through eBPF as well.
>>>>
>>> I really think there is value in being
>>> able to implement a scoped special
>>> case while leaving the rest of the
>>> packets in the kernel's hands.
>>
>> This is only work when some fucntion could not be done by eBPF itself
>> and then we can provide the function through eBPF helpers. But this is
>> not the case here.
>>
>>
>>> Having to reimplement automq makes
>>> this hookpoint less accessible to
>>> beginners and experienced alike.
>>
>> Note that automq itself is kind of complicated, it's best effort that is
>> hard to be documented accurately. It has several limitations (e.g flow
>> caches etc.) that may not work well in some conditions.
>>
>> It's not hard to implement a user programmable steering policy through
>> maps which could have much deterministic behavior than automq. The goal
>> of steering ebpf is to get rid of automq completely not partially rely
>> on it.
>>
>> And I don't see how relying on automq can simplify anything.
>>
>> Thanks
>>
> I'm not suggesting that we document automq.
>
> I'm suggesting that we add a return value
> which is documented as signaling to the
> kernel to implement whatever queue
> selection method is used when there is no
> ebpf prog attached.


Again, this only work when there's something that could not be done 
through eBPF. And then we can provide eBPF helper there.


>   That behavior today is
> automq.


Automq is not good, e.g tun_ebpf_select_queue() has already provided a 
fallback, anything that automq can do better than that?


>
> There is nothing about this return value
> which would harder to change the default
> queue selection later. The default already
> exists today when there is no program
> loaded.


The patch depends on incorrect behavior of tuntap (updating flow caches 
when steering prog is set). I think it's wrong to update flow caches 
even when steering program is set which leads extra overhead. Will 
probably submit a patch to disable that behavior.

Thanks


>
>>>>>     2. determine there isn't sufficient information
>>>>>        to do proper queue selection; return
>>>>>        negative and use the default automq logic
>>>>>        for the unknown
>>>> Same as above.
>>>>
>>>>
>>>>>     3. implement a noop prog (e.g. do
>>>>>        bpf_trace_printk() then return negative and
>>>>>        use the default automq logic for everything)
>>>> ditto.
>>>>
>>>>
>>>>>> 2. how do we know existing userspace does not rely on existing behaviour
>>>>> Prior to this change a negative return from a
>>>>> TUNSETSTEERINGEBPF prog would have been cast
>>>>> into a u16 and traversed netdev_cap_txqueue().
>>>>>
>>>>> In most cases netdev_cap_txqueue() would have
>>>>> found this value to exceed real_num_tx_queues
>>>>> and queue_index would be updated to 0.
>>>>>
>>>>> It is possible that a TUNSETSTEERINGEBPF prog
>>>>> return a negative value which when cast into a
>>>>> u16 results in a positive queue_index less than
>>>>> real_num_tx_queues. For example, on x86_64, a
>>>>> return value of -65535 results in a queue_index
>>>>> of 1; which is a valid queue for any multiqueue
>>>>> device.
>>>>>
>>>>> It seems unlikely, however as stated above is
>>>>> unfortunately possible, that existing
>>>>> TUNSETSTEERINGEBPF programs would choose to
>>>>> return a negative value rather than return the
>>>>> positive value which holds the same meaning.
>>>>>
>>>>> It seems more likely that future
>>>>> TUNSETSTEERINGEBPF programs would leverage a
>>>>> negative return and potentially be loaded into
>>>>> a kernel with the old behavior.
>>>> Yes, eBPF can return probably wrong value, but what kernel did is just
>>>> to make sure it doesn't harm anything.
>>>>
>>>> I would rather just drop the packet in this case.
>>>>
>>> In addition to TUN_SSE_ABORT, we can
>>> add TUN_SSE_DROP. That could be made the
>>> default for any undefined negative
>>> return as well.
>>>
>>>> Thanks
>>>>
>>>>
>>>>>> 3. why doesn't userspace need a way to figure out whether it runs on a kernel with and
>>>>>>       without this patch
>>>>> There may be some value in exposing this fact
>>>>> to the ebpf prog loader. What is the standard
>>>>> practice here, a define?
>>>>>
>>>>>> thanks,
>>>>>> MST
>>>>>>
>>>>>>> ---
>>>>>>>     drivers/net/tun.c | 20 +++++++++++---------
>>>>>>>     1 file changed, 11 insertions(+), 9 deletions(-)
>>>>>>>
>>>>>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>>>>>>> index aab0be4..173d159 100644
>>>>>>> --- a/drivers/net/tun.c
>>>>>>> +++ b/drivers/net/tun.c
>>>>>>> @@ -583,35 +583,37 @@ static u16 tun_automq_select_queue(struct tun_struct *tun, struct sk_buff *skb)
>>>>>>>          return txq;
>>>>>>>     }
>>>>>>>
>>>>>>> -static u16 tun_ebpf_select_queue(struct tun_struct *tun, struct sk_buff *skb)
>>>>>>> +static int tun_ebpf_select_queue(struct tun_struct *tun, struct sk_buff *skb)
>>>>>>>     {
>>>>>>>          struct tun_prog *prog;
>>>>>>>          u32 numqueues;
>>>>>>> -     u16 ret = 0;
>>>>>>> +     int ret = -1;
>>>>>>>
>>>>>>>          numqueues = READ_ONCE(tun->numqueues);
>>>>>>>          if (!numqueues)
>>>>>>>                  return 0;
>>>>>>>
>>>>>>> +     rcu_read_lock();
>>>>>>>          prog = rcu_dereference(tun->steering_prog);
>>>>>>>          if (prog)
>>>>>>>                  ret = bpf_prog_run_clear_cb(prog->prog, skb);
>>>>>>> +     rcu_read_unlock();
>>>>>>>
>>>>>>> -     return ret % numqueues;
>>>>>>> +     if (ret >= 0)
>>>>>>> +             ret %= numqueues;
>>>>>>> +
>>>>>>> +     return ret;
>>>>>>>     }
>>>>>>>
>>>>>>>     static u16 tun_select_queue(struct net_device *dev, struct sk_buff *skb,
>>>>>>>                              struct net_device *sb_dev)
>>>>>>>     {
>>>>>>>          struct tun_struct *tun = netdev_priv(dev);
>>>>>>> -     u16 ret;
>>>>>>> +     int ret;
>>>>>>>
>>>>>>> -     rcu_read_lock();
>>>>>>> -     if (rcu_dereference(tun->steering_prog))
>>>>>>> -             ret = tun_ebpf_select_queue(tun, skb);
>>>>>>> -     else
>>>>>>> +     ret = tun_ebpf_select_queue(tun, skb);
>>>>>>> +     if (ret < 0)
>>>>>>>                  ret = tun_automq_select_queue(tun, skb);
>>>>>>> -     rcu_read_unlock();
>>>>>>>
>>>>>>>          return ret;
>>>>>>>     }
>>>>>>> --
>>>>>>> 1.8.3.1
