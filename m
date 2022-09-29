Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D32D95EEC19
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 04:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234791AbiI2CvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 22:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234820AbiI2CvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 22:51:03 -0400
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C67ED5E4
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 19:51:00 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VQy6G8p_1664419857;
Received: from 30.221.148.4(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VQy6G8p_1664419857)
          by smtp.aliyun-inc.com;
          Thu, 29 Sep 2022 10:50:58 +0800
Message-ID: <189b8159-c05f-1730-93f3-365999755f72@linux.alibaba.com>
Date:   Thu, 29 Sep 2022 10:50:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:106.0)
 Gecko/20100101 Thunderbird/106.0
Subject: Re: [PATCH net] veth: Avoid drop packets when xdp_redirect performs
To:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
References: <1664267413-75518-1-git-send-email-hengqi@linux.alibaba.com>
 <87wn9proty.fsf@toke.dk>
 <f760701a-fb9d-11e5-f555-ebcf773922c3@linux.alibaba.com>
 <87v8p7r1f2.fsf@toke.dk>
From:   Heng Qi <hengqi@linux.alibaba.com>
In-Reply-To: <87v8p7r1f2.fsf@toke.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-12.2 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/9/28 下午10:58, Toke Høiland-Jørgensen 写道:
> Heng Qi <hengqi@linux.alibaba.com> writes:
>
>> 在 2022/9/27 下午8:20, Toke Høiland-Jørgensen 写道:
>>> Heng Qi <hengqi@linux.alibaba.com> writes:
>>>
>>>> In the current processing logic, when xdp_redirect occurs, it transmits
>>>> the xdp frame based on napi.
>>>>
>>>> If napi of the peer veth is not ready, the veth will drop the packets.
>>>> This doesn't meet our expectations.
>>> Erm, why don't you just enable NAPI? Loading an XDP program is not
>>> needed these days, you can just enable GRO on both peers...
>> In general, we don't expect veth to drop packets when it doesn't mount
>> the xdp program or otherwise, because this is not as expected.
> Well, did you consider that maybe your expectation is wrong? ;)

For users who don't know what other conditions are required for the readiness of napi,
all they can observe is why the packets cannot be sent to the peer veth, which is also
the problem we encountered in the actual case scenarios.


>
>>>> In this context, if napi is not ready, we convert the xdp frame to a skb,
>>>> and then use veth_xmit() to deliver it to the peer veth.
>>>>
>>>> Like the following case:
>>>> Even if veth1's napi cannot be used, the packet redirected from the NIC
>>>> will be transmitted to veth1 successfully:
>>>>
>>>> NIC   ->   veth0----veth1
>>>>    |                   |
>>>> (XDP)             (no XDP)
>>>>
>>>> Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
>>>> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>>>> ---
>>>>    drivers/net/veth.c | 36 +++++++++++++++++++++++++++++++++++-
>>>>    1 file changed, 35 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
>>>> index 466da01..e1f5561 100644
>>>> --- a/drivers/net/veth.c
>>>> +++ b/drivers/net/veth.c
>>>> @@ -469,8 +469,42 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
>>>>    	/* The napi pointer is set if NAPI is enabled, which ensures that
>>>>    	 * xdp_ring is initialized on receive side and the peer device is up.
>>>>    	 */
>>>> -	if (!rcu_access_pointer(rq->napi))
>>>> +	if (!rcu_access_pointer(rq->napi)) {
>>>> +		for (i = 0; i < n; i++) {
>>>> +			struct xdp_frame *xdpf = frames[i];
>>>> +			struct netdev_queue *txq = NULL;
>>>> +			struct sk_buff *skb;
>>>> +			int queue_mapping;
>>>> +			u16 mac_len;
>>>> +
>>>> +			skb = xdp_build_skb_from_frame(xdpf, dev);
>>>> +			if (unlikely(!skb)) {
>>>> +				ret = nxmit;
>>>> +				goto out;
>>>> +			}
>>>> +
>>>> +			/* We need to restore ETH header, because it is pulled
>>>> +			 * in eth_type_trans.
>>>> +			 */
>>>> +			mac_len = skb->data - skb_mac_header(skb);
>>>> +			skb_push(skb, mac_len);
>>>> +
>>>> +			nxmit++;
>>>> +
>>>> +			queue_mapping = skb_get_queue_mapping(skb);
>>>> +			txq = netdev_get_tx_queue(dev, netdev_cap_txqueue(dev, queue_mapping));
>>>> +			__netif_tx_lock(txq, smp_processor_id());
>>>> +			if (unlikely(veth_xmit(skb, dev) != NETDEV_TX_OK)) {
>>>> +				__netif_tx_unlock(txq);
>>>> +				ret = nxmit;
>>>> +				goto out;
>>>> +			}
>>>> +			__netif_tx_unlock(txq);
>>> Locking and unlocking the txq repeatedly for each packet? Yikes! Did you
>>> measure the performance overhead of this?
>> Yes, there are indeed some optimizations that can be done here,
>> like putting the lock outside the loop.
>> But in __dev_queue_xmit(), where each packet sent is also protected by a lock.
> ...which is another reason why this is a bad idea: it's going to perform
> terribly, which means we'll just end up with users wondering why their
> XDP performance is terrible and we're going to have to tell them to turn
> on GRO anyway. So why not do this from the beginning?
>
> If you want to change the default, flipping GRO to be on by default is a
> better solution IMO. I don't actually recall why we didn't do that when
> the support was added, but maybe Paolo remembers?

As I said above in the real case, the user's concern is not why the performance
of xdp becomes bad, but why the data packets are not received.

The default number of veth queues is not num_possible_cpus(). When GRO is enabled
by default, if there is only one veth queue, but multiple CPUs read and write at the
same time, the efficiency of napi is actually very low due to the existence of
production locks and races. On the contrary, the default veth_xmit() each cpu has
its own unique queue, and this way of sending and receiving packets is also efficient.

Thanks.

>
> -Toke

