Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A089049AA68
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 05:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1325570AbiAYDhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 22:37:46 -0500
Received: from prt-mail.chinatelecom.cn ([42.123.76.228]:41063 "EHLO
        chinatelecom.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S3418734AbiAYCPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 21:15:06 -0500
HMM_SOURCE_IP: 172.18.0.218:47440.867916151
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-112.38.63.33 (unknown [172.18.0.218])
        by chinatelecom.cn (HERMES) with SMTP id AD18B280120;
        Tue, 25 Jan 2022 10:14:52 +0800 (CST)
X-189-SAVE-TO-SEND: sunshouxin@chinatelecom.cn
Received: from  ([172.18.0.218])
        by app0025 with ESMTP id e0540388d85e46bb8c77434da3cdff77 for jay.vosburgh@canonical.com;
        Tue, 25 Jan 2022 10:14:55 CST
X-Transaction-ID: e0540388d85e46bb8c77434da3cdff77
X-Real-From: sunshouxin@chinatelecom.cn
X-Receive-IP: 172.18.0.218
X-MEDUSA-Status: 0
Sender: sunshouxin@chinatelecom.cn
Message-ID: <e23303ba-1892-a72b-3f54-d512abd540c0@chinatelecom.cn>
Date:   Tue, 25 Jan 2022 10:14:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v8] net: bonding: Add support for IPV6 ns/na to
 balance-alb/balance-tlb mode
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, nikolay@nvidia.com,
        huyd12@chinatelecom.cn
References: <20220125002954.94405-1-sunshouxin@chinatelecom.cn>
 <26803.1643073023@famine>
From:   =?UTF-8?B?5a2Z5a6I6ZGr?= <sunshouxin@chinatelecom.cn>
In-Reply-To: <26803.1643073023@famine>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/1/25 9:10, Jay Vosburgh 写道:
> Sun Shouxin <sunshouxin@chinatelecom.cn> wrote:
>
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
>> drivers/net/bonding/bond_alb.c | 37 +++++++++++++++++++++++++++++++++-
>> 1 file changed, 36 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
>> index 533e476988f2..d4d8670643e9 100644
>> --- a/drivers/net/bonding/bond_alb.c
>> +++ b/drivers/net/bonding/bond_alb.c
>> @@ -1269,6 +1269,34 @@ static int alb_set_mac_address(struct bonding *bond, void *addr)
>> 	return res;
>> }
>>
>> +/* determine if the packet is NA or NS */
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
>> +	ip6hdr = ipv6_hdr(skb);
>> +	if (ip6hdr->nexthdr == IPPROTO_ICMPV6) {
>> +		if (!pskb_may_pull(skb, sizeof(struct ipv6hdr) + sizeof(struct icmp6hdr)))
>> +			return true;
>> +
>> +		hdr = icmp6_hdr(skb);
>> +		return __alb_determine_nd(hdr);
>> +	}
>> +
>> +	return false;
>> +}
>> +
>> /************************ exported alb functions ************************/
>>
>> int bond_alb_initialize(struct bonding *bond, int rlb_enabled)
>> @@ -1348,8 +1376,10 @@ struct slave *bond_xmit_tlb_slave_get(struct bonding *bond,
>> 	/* Do not TX balance any multicast or broadcast */
>> 	if (!is_multicast_ether_addr(eth_data->h_dest)) {
>> 		switch (skb->protocol) {
>> -		case htons(ETH_P_IP):
>> 		case htons(ETH_P_IPV6):
>> +			if (alb_determine_nd(skb, bond))
>> +				break;
> 	I missed this before, but the new expectation is to have a
> "fallthrough;" statement when intentionally falling through to the next
> case.  See include/linux/compiler_attributes.h.
>
> 	That nit aside, this still looks fine to me.
>
> 	-J


Thanks your comment, I'll adjust it and send out V9 soon.


>> +		case htons(ETH_P_IP):
>> 			hash_index = bond_xmit_hash(bond, skb);
>> 			if (bond->params.tlb_dynamic_lb) {
>> 				tx_slave = tlb_choose_channel(bond,
>> @@ -1446,6 +1476,11 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
>> 			break;
>> 		}
>>
>> +		if (alb_determine_nd(skb, bond)) {
>> +			do_tx_balance = false;
>> +			break;
>> +		}
>> +
>> 		hash_start = (char *)&ip6hdr->daddr;
>> 		hash_size = sizeof(ip6hdr->daddr);
>> 		break;
>>
>> base-commit: dd81e1c7d5fb126e5fbc5c9e334d7b3ec29a16a0
>> -- 
>> 2.27.0
>>
> ---
> 	-Jay Vosburgh, jay.vosburgh@canonical.com
