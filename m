Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C093B596A7
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 11:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbfF1I74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 04:59:56 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:47302 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725873AbfF1I7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 04:59:54 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R841e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=zhiyuan2048@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0TVQ6QnS_1561712375;
Received: from houzhiyuandeMacBook-Pro.local(mailfrom:zhiyuan2048@linux.alibaba.com fp:SMTPD_---0TVQ6QnS_1561712375)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 28 Jun 2019 16:59:36 +0800
Subject: Re: [PATCH net-next] net: ipvlan: forward ingress packet to slave's
 l2 in l3s mode
To:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        idosch@mellanox.com, daniel@iogearbox.net, petrm@mellanox.com,
        jiri@mellanox.com, tglx@linutronix.de, linmiaohe@huawei.com
Cc:     zhabin@linux.alibaba.com, caspar@linux.alibaba.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wei.yang1@linux.alibaba.com
References: <20190625064208.2256-1-zhiyuan2048@linux.alibaba.com>
 <24fab1f43190f4994e47da4c2fa3fd622cd4e8ca.camel@redhat.com>
From:   Zhiyuan Hou <zhiyuan2048@linux.alibaba.com>
Message-ID: <07b3b417-c951-b9ce-743d-0fbe50e39c39@linux.alibaba.com>
Date:   Fri, 28 Jun 2019 16:59:35 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <24fab1f43190f4994e47da4c2fa3fd622cd4e8ca.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2019/6/26 下午4:16, Paolo Abeni 写道:
> Hi,
>
> On Tue, 2019-06-25 at 14:42 +0800, Zhiyuan Hou wrote:
>> In ipvlan l3s mode,  ingress packet is switched to slave interface and
>> delivers to l4 stack. This may cause two problems:
>>
>>    1. When slave is in an ns different from master, the behavior of stack
>>    in slave ns may cause confusion for users. For example, iptables, tc,
>>    and other l2/l3 functions are not available for ingress packet.
>>
>>    2. l3s mode is not used for tap device, and cannot support ipvtap. But
>>    in VM or container based VM cases, tap device is a very common device.
>>
>> In l3s mode's input nf_hook, this patch calles the skb_forward_dev() to
>> forward ingress packet to slave and uses nf_conntrack_confirm() to make
>> conntrack work with new mode.
>>
>> Signed-off-by: Zha Bin <zhabin@linux.alibaba.com>
>> Signed-off-by: Zhiyuan Hou <zhiyuan2048@linux.alibaba.com>
>> ---
>>   drivers/net/ipvlan/ipvlan.h     |  9 ++++++++-
>>   drivers/net/ipvlan/ipvlan_l3s.c | 16 ++++++++++++++--
>>   2 files changed, 22 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/ipvlan/ipvlan.h b/drivers/net/ipvlan/ipvlan.h
>> index 3837c897832e..48c814e24c3f 100644
>> --- a/drivers/net/ipvlan/ipvlan.h
>> +++ b/drivers/net/ipvlan/ipvlan.h
>> @@ -172,6 +172,14 @@ void ipvlan_link_delete(struct net_device *dev, struct list_head *head);
>>   void ipvlan_link_setup(struct net_device *dev);
>>   int ipvlan_link_register(struct rtnl_link_ops *ops);
>>   #ifdef CONFIG_IPVLAN_L3S
>> +
>> +#include <net/netfilter/nf_conntrack_core.h>
>> +
>> +static inline int ipvlan_confirm_conntrack(struct sk_buff *skb)
>> +{
>> +	return nf_conntrack_confirm(skb);
>> +}
>> +
>>   int ipvlan_l3s_register(struct ipvl_port *port);
>>   void ipvlan_l3s_unregister(struct ipvl_port *port);
>>   void ipvlan_migrate_l3s_hook(struct net *oldnet, struct net *newnet);
>> @@ -206,5 +214,4 @@ static inline bool netif_is_ipvlan_port(const struct net_device *dev)
>>   {
>>   	return rcu_access_pointer(dev->rx_handler) == ipvlan_handle_frame;
>>   }
>> -
>>   #endif /* __IPVLAN_H */
>> diff --git a/drivers/net/ipvlan/ipvlan_l3s.c b/drivers/net/ipvlan/ipvlan_l3s.c
>> index 943d26cbf39f..ed210002f593 100644
>> --- a/drivers/net/ipvlan/ipvlan_l3s.c
>> +++ b/drivers/net/ipvlan/ipvlan_l3s.c
>> @@ -95,14 +95,26 @@ static unsigned int ipvlan_nf_input(void *priv, struct sk_buff *skb,
>>   {
>>   	struct ipvl_addr *addr;
>>   	unsigned int len;
>> +	int ret = NF_ACCEPT;
>> +	bool success;
>>   
>>   	addr = ipvlan_skb_to_addr(skb, skb->dev);
>>   	if (!addr)
>>   		goto out;
>>   
>> -	skb->dev = addr->master->dev;
>>   	len = skb->len + ETH_HLEN;
>> -	ipvlan_count_rx(addr->master, len, true, false);
>> +
>> +	ret = ipvlan_confirm_conntrack(skb);
>> +	if (ret != NF_ACCEPT) {
>> +		ipvlan_count_rx(addr->master, len, false, false);
>> +		goto out;
>> +	}
>> +
>> +	skb_push_rcsum(skb, ETH_HLEN);
>> +	success = dev_forward_skb(addr->master->dev, skb) == NET_RX_SUCCESS;
> This looks weird to me: if I read the code correctly, the skb will
> traverse twice NF_INET_LOCAL_IN, once due to the l3s hooking and
> another one due to dev_forward_skb().
>
> Also, tc ingreess, etc will run after the first traversing of
> NF_INET_LOCAL_IN.

Yes,  but the skb's device has been modified from the master to slave. 
In most use cases of

ipvlan, the master device and slave device are in different namespace 
(ns), so the second

triggered LOCAL_IN is completely isolated from the first triggered 
LOCAL_IN.


When the master device and slave device are in the same ns, the behavior 
of this patch is

similar to that of L2 over L3 tunnel (forwarding from L3 to L2 device).


Since the device has been modified, the second triggered tc-ingress is 
thus different.

>
> All in all I think that if full l2 processing is required, a different
> mode or a different virtual device should be used.

We can implement it in a new mode, but such a way is similar to the 
current ipvlan l3s mode.

Also, ipvlan l3s mode has two problems described in patch's commit log. 
I think that a more

appropriate solution is to modify ipvlan l3s.

> Cheers,
>
> Paolo
