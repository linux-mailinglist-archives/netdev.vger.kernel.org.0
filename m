Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7E88BAC41
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 02:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390062AbfIWAqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 20:46:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58730 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730677AbfIWAqS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Sep 2019 20:46:18 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D0F6F85A07;
        Mon, 23 Sep 2019 00:46:16 +0000 (UTC)
Received: from [10.72.12.112] (ovpn-12-112.pek2.redhat.com [10.72.12.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F25575DD64;
        Mon, 23 Sep 2019 00:46:06 +0000 (UTC)
Subject: Re: [PATCH net-next] tuntap: Fallback to automq on TUNSETSTEERINGEBPF
 prog negative return
To:     Matt Cover <werekraken@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
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
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <0f4541d9-a405-6185-7e54-112dc9188146@redhat.com>
Date:   Mon, 23 Sep 2019 08:46:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAGyo_hqGbFdt1PoDrmo=S5iTO8TwbrbtOJtbvGT1WrFFMLwk-Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Mon, 23 Sep 2019 00:46:17 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/9/23 上午1:43, Matt Cover wrote:
> On Sun, Sep 22, 2019 at 5:37 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>> On Fri, Sep 20, 2019 at 11:58:43AM -0700, Matthew Cover wrote:
>>> Treat a negative return from a TUNSETSTEERINGEBPF bpf prog as a signal
>>> to fallback to tun_automq_select_queue() for tx queue selection.
>>>
>>> Compilation of this exact patch was tested.
>>>
>>> For functional testing 3 additional printk()s were added.
>>>
>>> Functional testing results (on 2 txq tap device):
>>>
>>>    [Fri Sep 20 18:33:27 2019] ========== tun no prog ==========
>>>    [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returned '-1'
>>>    [Fri Sep 20 18:33:27 2019] tuntap: tun_automq_select_queue() ran
>>>    [Fri Sep 20 18:33:27 2019] ========== tun prog -1 ==========
>>>    [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() returned '-1'
>>>    [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returned '-1'
>>>    [Fri Sep 20 18:33:27 2019] tuntap: tun_automq_select_queue() ran
>>>    [Fri Sep 20 18:33:27 2019] ========== tun prog 0 ==========
>>>    [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() returned '0'
>>>    [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returned '0'
>>>    [Fri Sep 20 18:33:27 2019] ========== tun prog 1 ==========
>>>    [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() returned '1'
>>>    [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returned '1'
>>>    [Fri Sep 20 18:33:27 2019] ========== tun prog 2 ==========
>>>    [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() returned '2'
>>>    [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returned '0'
>>>
>>> Signed-off-by: Matthew Cover <matthew.cover@stackpath.com>
>>
>> Could you add a bit more motivation data here?
> Thank you for these questions Michael.
>
> I'll plan on adding the below information to the
> commit message and submitting a v2 of this patch
> when net-next reopens. In the meantime, it would
> be very helpful to know if these answers address
> some of your concerns.
>
>> 1. why is this a good idea
> This change allows TUNSETSTEERINGEBPF progs to
> do any of the following.
>   1. implement queue selection for a subset of
>      traffic (e.g. special queue selection logic
>      for ipv4, but return negative and use the
>      default automq logic for ipv6)


Well, using ebpf means it need to take care of all the cases. E.g you 
can easily implement the fallback through eBPF as well.


>   2. determine there isn't sufficient information
>      to do proper queue selection; return
>      negative and use the default automq logic
>      for the unknown


Same as above.


>   3. implement a noop prog (e.g. do
>      bpf_trace_printk() then return negative and
>      use the default automq logic for everything)


ditto.


>
>> 2. how do we know existing userspace does not rely on existing behaviour
> Prior to this change a negative return from a
> TUNSETSTEERINGEBPF prog would have been cast
> into a u16 and traversed netdev_cap_txqueue().
>
> In most cases netdev_cap_txqueue() would have
> found this value to exceed real_num_tx_queues
> and queue_index would be updated to 0.
>
> It is possible that a TUNSETSTEERINGEBPF prog
> return a negative value which when cast into a
> u16 results in a positive queue_index less than
> real_num_tx_queues. For example, on x86_64, a
> return value of -65535 results in a queue_index
> of 1; which is a valid queue for any multiqueue
> device.
>
> It seems unlikely, however as stated above is
> unfortunately possible, that existing
> TUNSETSTEERINGEBPF programs would choose to
> return a negative value rather than return the
> positive value which holds the same meaning.
>
> It seems more likely that future
> TUNSETSTEERINGEBPF programs would leverage a
> negative return and potentially be loaded into
> a kernel with the old behavior.


Yes, eBPF can return probably wrong value, but what kernel did is just 
to make sure it doesn't harm anything.

I would rather just drop the packet in this case.

Thanks


>
>> 3. why doesn't userspace need a way to figure out whether it runs on a kernel with and
>>     without this patch
> There may be some value in exposing this fact
> to the ebpf prog loader. What is the standard
> practice here, a define?
>
>>
>> thanks,
>> MST
>>
>>> ---
>>>   drivers/net/tun.c | 20 +++++++++++---------
>>>   1 file changed, 11 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>>> index aab0be4..173d159 100644
>>> --- a/drivers/net/tun.c
>>> +++ b/drivers/net/tun.c
>>> @@ -583,35 +583,37 @@ static u16 tun_automq_select_queue(struct tun_struct *tun, struct sk_buff *skb)
>>>        return txq;
>>>   }
>>>
>>> -static u16 tun_ebpf_select_queue(struct tun_struct *tun, struct sk_buff *skb)
>>> +static int tun_ebpf_select_queue(struct tun_struct *tun, struct sk_buff *skb)
>>>   {
>>>        struct tun_prog *prog;
>>>        u32 numqueues;
>>> -     u16 ret = 0;
>>> +     int ret = -1;
>>>
>>>        numqueues = READ_ONCE(tun->numqueues);
>>>        if (!numqueues)
>>>                return 0;
>>>
>>> +     rcu_read_lock();
>>>        prog = rcu_dereference(tun->steering_prog);
>>>        if (prog)
>>>                ret = bpf_prog_run_clear_cb(prog->prog, skb);
>>> +     rcu_read_unlock();
>>>
>>> -     return ret % numqueues;
>>> +     if (ret >= 0)
>>> +             ret %= numqueues;
>>> +
>>> +     return ret;
>>>   }
>>>
>>>   static u16 tun_select_queue(struct net_device *dev, struct sk_buff *skb,
>>>                            struct net_device *sb_dev)
>>>   {
>>>        struct tun_struct *tun = netdev_priv(dev);
>>> -     u16 ret;
>>> +     int ret;
>>>
>>> -     rcu_read_lock();
>>> -     if (rcu_dereference(tun->steering_prog))
>>> -             ret = tun_ebpf_select_queue(tun, skb);
>>> -     else
>>> +     ret = tun_ebpf_select_queue(tun, skb);
>>> +     if (ret < 0)
>>>                ret = tun_automq_select_queue(tun, skb);
>>> -     rcu_read_unlock();
>>>
>>>        return ret;
>>>   }
>>> --
>>> 1.8.3.1
