Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 932E54DDAA2
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 14:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236423AbiCRNh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 09:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236746AbiCRNhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 09:37:52 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F9ABF039;
        Fri, 18 Mar 2022 06:36:29 -0700 (PDT)
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nVCmI-00006i-HE; Fri, 18 Mar 2022 14:36:26 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nVCmI-000ITL-5H; Fri, 18 Mar 2022 14:36:26 +0100
Subject: Re: [net-next v10 1/2] net: sched: use queue_mapping to pick tx queue
To:     Paolo Abeni <pabeni@redhat.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf@vger.kernel.org
References: <20220314141508.39952-1-xiangxia.m.yue@gmail.com>
 <20220314141508.39952-2-xiangxia.m.yue@gmail.com>
 <015e903a-f4b4-a905-1cd2-11d10aefec8a@iogearbox.net>
 <CAMDZJNUO9k8xmrJwrXnj+LVG=bEv5Zwe=YkjOqSBrDS348OQfA@mail.gmail.com>
 <7d4b0c51460dec351bbbaf9be85c4a25cb6cec4f.camel@redhat.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f61e4a34-e7e5-198b-dde6-816654775b21@iogearbox.net>
Date:   Fri, 18 Mar 2022 14:36:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <7d4b0c51460dec351bbbaf9be85c4a25cb6cec4f.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26485/Fri Mar 18 09:26:47 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/17/22 9:20 AM, Paolo Abeni wrote:
> On Tue, 2022-03-15 at 20:48 +0800, Tonghao Zhang wrote:
>> On Tue, Mar 15, 2022 at 5:59 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>> On 3/14/22 3:15 PM, xiangxia.m.yue@gmail.com wrote:
>>> [...]
>>>>    include/linux/netdevice.h |  3 +++
>>>>    include/linux/rtnetlink.h |  1 +
>>>>    net/core/dev.c            | 31 +++++++++++++++++++++++++++++--
>>>>    net/sched/act_skbedit.c   |  6 +++++-
>>>>    4 files changed, 38 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>>>> index 0d994710b335..f33fb2d6712a 100644
>>>> --- a/include/linux/netdevice.h
>>>> +++ b/include/linux/netdevice.h
>>>> @@ -3065,6 +3065,9 @@ struct softnet_data {
>>>>        struct {
>>>>                u16 recursion;
>>>>                u8  more;
>>>> +#ifdef CONFIG_NET_EGRESS
>>>> +             u8  skip_txqueue;
>>>> +#endif
>>>>        } xmit;
>>>>    #ifdef CONFIG_RPS
>>>>        /* input_queue_head should be written by cpu owning this struct,
>>>> diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
>>>> index 7f970b16da3a..ae2c6a3cec5d 100644
>>>> --- a/include/linux/rtnetlink.h
>>>> +++ b/include/linux/rtnetlink.h
>>>> @@ -100,6 +100,7 @@ void net_dec_ingress_queue(void);
>>>>    #ifdef CONFIG_NET_EGRESS
>>>>    void net_inc_egress_queue(void);
>>>>    void net_dec_egress_queue(void);
>>>> +void netdev_xmit_skip_txqueue(bool skip);
>>>>    #endif
>>>>
>>>>    void rtnetlink_init(void);
>>>> diff --git a/net/core/dev.c b/net/core/dev.c
>>>> index 75bab5b0dbae..8e83b7099977 100644
>>>> --- a/net/core/dev.c
>>>> +++ b/net/core/dev.c
>>>> @@ -3908,6 +3908,25 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
>>>>
>>>>        return skb;
>>>>    }
>>>> +
>>>> +static struct netdev_queue *
>>>> +netdev_tx_queue_mapping(struct net_device *dev, struct sk_buff *skb)
>>>> +{
>>>> +     int qm = skb_get_queue_mapping(skb);
>>>> +
>>>> +     return netdev_get_tx_queue(dev, netdev_cap_txqueue(dev, qm));
>>>> +}
>>>> +
>>>> +static bool netdev_xmit_txqueue_skipped(void)
>>>> +{
>>>> +     return __this_cpu_read(softnet_data.xmit.skip_txqueue);
>>>> +}
>>>> +
>>>> +void netdev_xmit_skip_txqueue(bool skip)
>>>> +{
>>>> +     __this_cpu_write(softnet_data.xmit.skip_txqueue, skip);
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(netdev_xmit_skip_txqueue);
>>>>    #endif /* CONFIG_NET_EGRESS */
>>>>
>>>>    #ifdef CONFIG_XPS
>>>> @@ -4078,7 +4097,7 @@ struct netdev_queue *netdev_core_pick_tx(struct net_device *dev,
>>>>    static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
>>>>    {
>>>>        struct net_device *dev = skb->dev;
>>>> -     struct netdev_queue *txq;
>>>> +     struct netdev_queue *txq = NULL;
>>>>        struct Qdisc *q;
>>>>        int rc = -ENOMEM;
>>>>        bool again = false;
>>>> @@ -4106,11 +4125,17 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
>>>>                        if (!skb)
>>>>                                goto out;
>>>>                }
>>>> +
>>>> +             netdev_xmit_skip_txqueue(false);
>>>> +
>>>>                nf_skip_egress(skb, true);
>>>>                skb = sch_handle_egress(skb, &rc, dev);
>>>>                if (!skb)
>>>>                        goto out;
>>>>                nf_skip_egress(skb, false);
>>>> +
>>>> +             if (netdev_xmit_txqueue_skipped())
>>>> +                     txq = netdev_tx_queue_mapping(dev, skb);
>>>>        }
>>>>    #endif
>>>>        /* If device/qdisc don't need skb->dst, release it right now while
>>>> @@ -4121,7 +4146,9 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
>>>>        else
>>>>                skb_dst_force(skb);
>>>>
>>>> -     txq = netdev_core_pick_tx(dev, skb, sb_dev);
>>>> +     if (likely(!txq))
>>>
>>> nit: Drop likely(). If the feature is used from sch_handle_egress(), then this would always be the case.
>> Hi Daniel
>> I think in most case, we don't use skbedit queue_mapping in the
>> sch_handle_egress() , so I add likely in fast path.

Yeah, but then let branch predictor do its work ? We can still change and drop the
likely() once we add support for BPF though..

>>>> +             txq = netdev_core_pick_tx(dev, skb, sb_dev);
>>>> +
>>>>        q = rcu_dereference_bh(txq->qdisc);
>>>
>>> How will the `netdev_xmit_skip_txqueue(true)` be usable from BPF side (see bpf_convert_ctx_access() ->
>>> queue_mapping)?
>> Good questions, In other patch, I introduce the
>> bpf_netdev_skip_txqueue, so we can use netdev_xmit_skip_txqueue in bpf
>> side

Yeah, that bpf_netdev_skip_txqueue() won't fly. It's basically a helper doing quirk for
an implementation detail (aka calling netdev_xmit_skip_txqueue()). Was hoping you have
something better we could use along with the context rewrite of __sk_buff's queue_mapping,
but worst case we need to rework a bit for BPF. :/

Thanks,
Daniel
