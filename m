Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C948498279
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 15:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238787AbiAXOer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 09:34:47 -0500
Received: from prt-mail.chinatelecom.cn ([42.123.76.222]:58734 "EHLO
        chinatelecom.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S237779AbiAXOer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 09:34:47 -0500
HMM_SOURCE_IP: 172.18.0.218:37604.302679515
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-112.38.63.33 (unknown [172.18.0.218])
        by chinatelecom.cn (HERMES) with SMTP id 7E99928009A;
        Mon, 24 Jan 2022 22:34:35 +0800 (CST)
X-189-SAVE-TO-SEND: sunshouxin@chinatelecom.cn
Received: from  ([172.18.0.218])
        by app0025 with ESMTP id 7f167e02474647c4a9bfcfb9959c7b6e for nikolay@nvidia.com;
        Mon, 24 Jan 2022 22:34:39 CST
X-Transaction-ID: 7f167e02474647c4a9bfcfb9959c7b6e
X-Real-From: sunshouxin@chinatelecom.cn
X-Receive-IP: 172.18.0.218
X-MEDUSA-Status: 0
Sender: sunshouxin@chinatelecom.cn
Message-ID: <f7a4697e-4be0-49c6-caa9-e56b43026654@chinatelecom.cn>
Date:   Mon, 24 Jan 2022 22:34:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v7] net: bonding: Add support for IPV6 ns/na to
 balance-alb/balance-tlb mode
To:     Nikolay Aleksandrov <nikolay@nvidia.com>, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jay.vosburgh@canonical.com, huyd12@chinatelecom.cn
References: <20220121082243.88155-1-sunshouxin@chinatelecom.cn>
 <fb358da0-d255-301d-c39c-8232aa415a38@nvidia.com>
From:   =?UTF-8?B?5a2Z5a6I6ZGr?= <sunshouxin@chinatelecom.cn>
In-Reply-To: <fb358da0-d255-301d-c39c-8232aa415a38@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/1/21 16:52, Nikolay Aleksandrov 写道:
> On 21/01/2022 10:22, Sun Shouxin wrote:
>> Since ipv6 neighbor solicitation and advertisement messages
>> isn't handled gracefully in bond6 driver, we can see packet
>> drop due to inconsistency between mac address in the option
>> message and source MAC .
>>
>> Another examples is ipv6 neighbor solicitation and advertisement
>> messages from VM via tap attached to host bridge, the src mac
>> might be changed through balance-alb mode, but it is not synced
>> with Link-layer address in the option message.
>>
>> The patch implements bond6's tx handle for ipv6 neighbor
>> solicitation and advertisement messages.
>>
>> Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
>> Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
>> Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
>> ---
>>   drivers/net/bonding/bond_alb.c | 36 ++++++++++++++++++++++++++++++++++
>>   1 file changed, 36 insertions(+)
>>
> Hi,
> A few comments below,


Thanks your comment, I'll adjust it and send out V8 soon.


>
>> diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
>> index 533e476988f2..82b7071840b1 100644
>> --- a/drivers/net/bonding/bond_alb.c
>> +++ b/drivers/net/bonding/bond_alb.c
>> @@ -1269,6 +1269,34 @@ static int alb_set_mac_address(struct bonding *bond, void *addr)
>>   	return res;
>>   }
>>   
>> +/*determine if the packet is NA or NS*
> comments should have spaces, /* text */
>
>> +static bool __alb_determine_nd(struct icmp6hdr *hdr)
>> +{
>> +	if (hdr->icmp6_type == NDISC_NEIGHBOUR_ADVERTISEMENT ||
>> +	    hdr->icmp6_type == NDISC_NEIGHBOUR_SOLICITATION) {
>> +		return true;
>> +	}
>> +
>> +	return false;
>> +}
>> +
>> +static bool alb_determine_nd(struct sk_buff *skb, struct bonding *bond)
>> +{
>> +	struct ipv6hdr *ip6hdr;
>> +	struct icmp6hdr *hdr;
>> +
>> +	if (skb->protocol == htons(ETH_P_IPV6)) {
> You can drop this test if you re-arrange the cases in the caller. More below.
>
>> +		ip6hdr = ipv6_hdr(skb);
>> +		if (ip6hdr->nexthdr == IPPROTO_ICMPV6) {
>> +			hdr = icmp6_hdr(skb);
> You have to use pskb_may_pull here, only the IPv6 header is pulled by the caller
> and certain to be in the linear part. Also you have to change one of the callers,
> more below.
>
>> +			if (__alb_determine_nd(hdr))
>> +				return true;
> you can do directly return __alb_determine_nd(hdr) here.
>
>> +		}
>> +	}
>> +
>> +	return false;
>> +}
>> +
>>   /************************ exported alb functions ************************/
>>   
>>   int bond_alb_initialize(struct bonding *bond, int rlb_enabled)
>> @@ -1350,6 +1378,9 @@ struct slave *bond_xmit_tlb_slave_get(struct bonding *bond,>  		switch (skb->protocol) {
>>   		case htons(ETH_P_IP):
>>   		case htons(ETH_P_IPV6):
>> +			if (alb_determine_nd(skb, bond))
>> +				break;
>> +
> You can drop the IPv6 test in alb_determine_nd() if you re-arrange the cases here.
> Something like:
>    		case htons(ETH_P_IPV6):
> 			if (alb_determine_nd(skb, bond))
> 				break;
> 			fallthrough;
>    		case htons(ETH_P_IP):
>
> You should also use pskb_may_pull to make sure the IPv6 header is in the linear part
> and can be accessed.
>
>>   			hash_index = bond_xmit_hash(bond, skb);
>>   			if (bond->params.tlb_dynamic_lb) {
>>   				tx_slave = tlb_choose_channel(bond,
>> @@ -1446,6 +1477,11 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
>>   			break;
>>   		}
>>   
>> +		if (alb_determine_nd(skb, bond)) {
>> +			do_tx_balance = false;
>> +			break;
>> +		}
>> +
>>   		hash_start = (char *)&ip6hdr->daddr;
>>   		hash_size = sizeof(ip6hdr->daddr);
>>   		break;
>>
>> base-commit: 79e06c4c4950be2abd8ca5d2428a8c915aa62c24
> Thanks,
>   Nik
>
