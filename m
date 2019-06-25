Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 365105282C
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 11:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728769AbfFYJfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 05:35:45 -0400
Received: from www62.your-server.de ([213.133.104.62]:37232 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728422AbfFYJfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 05:35:45 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hfhrV-0005rc-5L; Tue, 25 Jun 2019 11:35:37 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hfhrU-000CZQ-VC; Tue, 25 Jun 2019 11:35:36 +0200
Subject: Re: Removing skb_orphan() from ip_rcv_core()
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Joe Stringer <joe@wand.net.nz>, Florian Westphal <fw@strlen.de>
Cc:     netdev <netdev@vger.kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Flavio Leitner <fbl@redhat.com>, ast@kernel.org
References: <CAOftzPisP-3jN8drC6RXcTigXJjdwEnvTRvTHR-Kv4LKn4rhQQ@mail.gmail.com>
 <20190621205935.og7ajx57j7usgycq@breakpoint.cc>
 <CAOftzPi5SO_tZeoEs1Apd5np=Sd2fFUPm1oome_31=rMqSD-=g@mail.gmail.com>
 <b6baadcb-29af-82f1-bebe-56d5f45b12e6@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <4deff7d7-cc10-090d-86f2-850148fdf032@iogearbox.net>
Date:   Tue, 25 Jun 2019 11:35:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <b6baadcb-29af-82f1-bebe-56d5f45b12e6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25491/Tue Jun 25 10:02:48 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/25/2019 08:37 AM, Eric Dumazet wrote:
> On 6/24/19 8:17 PM, Joe Stringer wrote:
>> On Fri, Jun 21, 2019 at 1:59 PM Florian Westphal <fw@strlen.de> wrote:
>>>
>>> Joe Stringer <joe@wand.net.nz> wrote:
>>>> As discussed during LSFMM, I've been looking at adding something like
>>>> an `skb_sk_assign()` helper to BPF so that logic similar to TPROXY can
>>>> be implemented with integration into other BPF logic, however
>>>> currently any attempts to do so are blocked by the skb_orphan() call
>>>> in ip_rcv_core() (which will effectively ignore any socket assign
>>>> decision made by the TC BPF program).
>>>>
>>>> Recently I was attempting to remove the skb_orphan() call, and I've
>>>> been trying different things but there seems to be some context I'm
>>>> missing. Here's the core of the patch:
>>>>
>>>> diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
>>>> index ed97724c5e33..16aea980318a 100644
>>>> --- a/net/ipv4/ip_input.c
>>>> +++ b/net/ipv4/ip_input.c
>>>> @@ -500,8 +500,6 @@ static struct sk_buff *ip_rcv_core(struct sk_buff
>>>> *skb, struct net *net)
>>>>        memset(IPCB(skb), 0, sizeof(struct inet_skb_parm));
>>>>        IPCB(skb)->iif = skb->skb_iif;
>>>>
>>>> -       /* Must drop socket now because of tproxy. */
>>>> -       skb_orphan(skb);
>>>>
>>>>        return skb;
>>>>
>>>> The statement that the socket must be dropped because of tproxy
>>>> doesn't make sense to me, because the PRE_ROUTING hook is hit after
>>>> this, which will call into the tproxy logic and eventually
>>>> nf_tproxy_assign_sock() which already does the skb_orphan() itself.
>>>
>>> in comment: s/tproxy/skb_steal_sock/
>>
>> For reference, I was following the path like this:
>>
>> ip_rcv()
>> ( -> ip_rcv_core() for skb_orphan)
>> -> NF_INET_PRE_ROUTING hook
>> (... invoke iptables hooks)
>> -> iptable_mangle_hook()
>> -> ipt_do_table()
>> ... -> tproxy_tg4()
>> ... -> nf_tproxy_assign_sock()
>> -> skb_orphan()
>> (... finish iptables processing)
>> ( -> ip_rcv_finish())
>> ( ... -> ip_rcv_finish_core() for early demux / route lookup )
>> (... -> dst_input())
>> (... -> tcp_v4_rcv())
>> ( -> __inet_lookup_skb())
>> ( -> skb_steal_sock() )
>>
>>> at least thats what I concluded a few years ago when I looked into
>>> the skb_oprhan() need.
>>>
>>> IIRC some device drivers use skb->sk for backpressure, so without this
>>> non-tcp socket would be stolen by skb_steal_sock.
>>
>> Do you happen to recall which device drivers? Or have some idea of a
>> list I could try to go through? Are you referring to virtual drivers
>> like veth or something else?
>>
>>> We also recently removed skb orphan when crossing netns:
>>>
>>> commit 9c4c325252c54b34d53b3d0ffd535182b744e03d
>>> Author: Flavio Leitner <fbl@redhat.com>
>>> skbuff: preserve sock reference when scrubbing the skb.
>>>
>>> So thats another case where this orphan is needed.
>>
>> Presumably the orphan is only needed in this case if the packet
>> crosses a namespace and then is subsequently passed back into the
>> stack?
> 
> Yes, I understand we do not want the skb_orphan() when 'srubing' the skb.
> 
> But we want the skb_orphan() right before the packet is reinjected in ingress path. 
> 
>>> What could be done is adding some way to delay/defer the orphaning
>>> further, but we would need at the very least some annotation for
>>> skb_steal_sock to know when the skb->sk is really from TPROXY or
>>> if it has to orphan.
>>
>> Eric mentions in another response to this thread that skb_orphan()
>> should be called from any ndo_start_xmit() which sends traffic back
>> into the stack. With that, presumably we would be pushing the
>> orphaning earlier such that the only way that the skb->sk ref can be
>> non-NULL around this point in receive would be because it was
>> specifically set by some kind of tproxy logic?
>>
>>> Same for the safety check in the forwarding path.
>>> Netfilter modules need o be audited as well, they might make assumptions
>>> wrt. skb->sk being inet sockets (set by local stack or early demux).
>>>
>>>> However, if I drop these lines then I end up causing sockets to
>>>> release references too many times. Seems like if we don't orphan the
>>>> skb here, then later logic assumes that we have one more reference
>>>> than we actually have, and decrements the count when it shouldn't
>>>> (perhaps the skb_steal_sock() call in __inet_lookup_skb() which seems
>>>> to assume we always have a reference to the socket?)
>>>
>>> We might be calling the wrong destructor (i.e., the one set by tcp
>>> receive instead of the one set at tx time)?
>>
>> Hmm, interesting thought. Sure enough, with a bit of bpftrace
>> debugging we find it's tcp_wfree():
>>
>> $ cat ip_rcv.bt
>> #include <linux/skbuff.h>
>>
>> kprobe:ip_rcv {
>>        $sk = ((struct sk_buff *)arg0)->sk;
>>        $des = ((struct sk_buff *)arg0)->destructor;
>>        if ($sk) {
>>                if ($des) {
>>                        printf("received %s on %s with sk destructor %s
>> set\n", str(arg0), str(arg1), ksym($des));
>>                        @ip4_stacks[kstack] = count();
>>                }
>>        }
>> }
>> $ sudo bpftrace ip_rcv.bt
>> Attaching 1 probe...
>> received  on eth0 with sk destructor tcp_wfree set
>> ^C
>>
>> @ip4_stacks[
>>    ip_rcv+1
>>    __netif_receive_skb+24
>>    process_backlog+179
>>    net_rx_action+304
>>    __do_softirq+220
>>    do_softirq_own_stack+42
>>    do_softirq.part.17+70
>>    __local_bh_enable_ip+101
>>    ip_finish_output2+421
>>    __ip_finish_output+187
>>    ip_finish_output+44
>>    ip_output+109
>>    ip_local_out+59
>>    __ip_queue_xmit+368
>>    ip_queue_xmit+16
>>    __tcp_transmit_skb+1303
>>    tcp_connect+2758
>>    tcp_v4_connect+1135
>>    __inet_stream_connect+214
>>    inet_stream_connect+59
>>    __sys_connect+237
>>    __x64_sys_connect+26
>>    do_syscall_64+90
>>    entry_SYSCALL_64_after_hwframe+68
>> ]: 1
>>
>> Is there a solution here where we call the destructor if it's not
>> sock_efree()? When the socket is later stolen, it will only return the
>> reference via a call to sock_put(), so presumably at that point in the
>> stack we already assume that the skb->destructor is not one of these
>> other destructors (otherwise we wouldn't release the resources
>> correctly).
> 
> What was the driver here ? In any case, the following patch should help.
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index eeacebd7debbe6a55daedb92f00afd48051ebaf8..5075b4b267af7057f69fcb935226fce097a920e2 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -3699,6 +3699,7 @@ static __always_inline int ____dev_forward_skb(struct net_device *dev,
>                 return NET_RX_DROP;
>         }
>  
> +       skb_orphan(skb);
>         skb_scrub_packet(skb, true);
>         skb->priority = 0;
>         return 0;
> 

But wasn't the whole point of 9c4c325252c5 ("skbuff: preserve sock reference when
scrubbing the skb.") to defer orphaning to as late as possible? If I'm not missing
anything, then above would reintroduce the issues that 9c4c325252c5 was trying to
solve wrt TSQ/XPS/etc when skb was sent via veth based data path to cross netns and
then forwarded to phys dev for transmission; meaning, skb->sk is lost at the point
of dev_queue_xmit() for the latter. A side-effect this would also have is that this
changes behavior again for tc egress programs sitting on phys dev (e.g. querying
sock cookie or other related features).

Thanks,
Daniel
