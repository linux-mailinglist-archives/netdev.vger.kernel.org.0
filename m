Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACD5495A0F
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 07:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378757AbiAUGiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 01:38:20 -0500
Received: from prt-mail.chinatelecom.cn ([42.123.76.222]:32849 "EHLO
        chinatelecom.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1378752AbiAUGiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 01:38:20 -0500
HMM_SOURCE_IP: 172.18.0.218:42762.813230127
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-10.133.11.244 (unknown [172.18.0.218])
        by chinatelecom.cn (HERMES) with SMTP id 41CE12800B7;
        Fri, 21 Jan 2022 14:38:04 +0800 (CST)
X-189-SAVE-TO-SEND: sunshouxin@chinatelecom.cn
Received: from  ([172.18.0.218])
        by app0025 with ESMTP id 6f463a4339bf40e6a8ba36f414a7b440 for jay.vosburgh@canonical.com;
        Fri, 21 Jan 2022 14:38:08 CST
X-Transaction-ID: 6f463a4339bf40e6a8ba36f414a7b440
X-Real-From: sunshouxin@chinatelecom.cn
X-Receive-IP: 172.18.0.218
X-MEDUSA-Status: 0
Sender: sunshouxin@chinatelecom.cn
Message-ID: <661de9e7-216d-dfd1-afdc-3c58a88739c3@chinatelecom.cn>
Date:   Fri, 21 Jan 2022 14:38:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v6] net: bonding: Add support for IPV6 ns/na to
 balance-alb/balance-tlb mode
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, huyd12@chinatelecom.cn
References: <20220118073317.82968-1-sunshouxin@chinatelecom.cn>
 <29469.1642746326@famine>
From:   =?UTF-8?B?5a2Z5a6I6ZGr?= <sunshouxin@chinatelecom.cn>
In-Reply-To: <29469.1642746326@famine>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/1/21 14:25, Jay Vosburgh 写道:
> Sun Shouxin <sunshouxin@chinatelecom.cn> wrote:
>
>> Since ipv6 neighbor solicitation and advertisement messages
>> isn't handled gracefully in bonding6 driver, we can see packet
>> drop due to inconsistency bewteen mac address in the option
>> message and source MAC .
>>
>> Another examples is ipv6 neighbor solicitation and advertisement
>> messages from VM via tap attached to host brighe, the src mac
>> mighe be changed through balance-alb mode, but it is not synced
>> with Link-layer address in the option message.
>>
>> The patch implements bond6's tx handle for ipv6 neighbor
>> solicitation and advertisement messages.
> 	As previously discussed, this looks reasonable to me to resolve
> the described MAC discrepancy.  One minor nit is a couple of misspelled
> words in the description above, "brighe" and "mighe."
>
> Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
>
> 	-J


Thanks your comment, I'll adjust it and send out V7 soon.


>
>> Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
>> Reported-by: kernel test robot <lkp@intel.com>
>> Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
>> ---
>> drivers/net/bonding/bond_alb.c | 36 ++++++++++++++++++++++++++++++++++
>> 1 file changed, 36 insertions(+)
>>
>> diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
>> index 533e476988f2..82b7071840b1 100644
>> --- a/drivers/net/bonding/bond_alb.c
>> +++ b/drivers/net/bonding/bond_alb.c
>> @@ -1269,6 +1269,34 @@ static int alb_set_mac_address(struct bonding *bond, void *addr)
>> 	return res;
>> }
>>
>> +/*determine if the packet is NA or NS*/
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
>> +		ip6hdr = ipv6_hdr(skb);
>> +		if (ip6hdr->nexthdr == IPPROTO_ICMPV6) {
>> +			hdr = icmp6_hdr(skb);
>> +			if (__alb_determine_nd(hdr))
>> +				return true;
>> +		}
>> +	}
>> +
>> +	return false;
>> +}
>> +
>> /************************ exported alb functions ************************/
>>
>> int bond_alb_initialize(struct bonding *bond, int rlb_enabled)
>> @@ -1350,6 +1378,9 @@ struct slave *bond_xmit_tlb_slave_get(struct bonding *bond,
>> 		switch (skb->protocol) {
>> 		case htons(ETH_P_IP):
>> 		case htons(ETH_P_IPV6):
>> +			if (alb_determine_nd(skb, bond))
>> +				break;
>> +
>> 			hash_index = bond_xmit_hash(bond, skb);
>> 			if (bond->params.tlb_dynamic_lb) {
>> 				tx_slave = tlb_choose_channel(bond,
>> @@ -1446,6 +1477,11 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
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
>> base-commit: 79e06c4c4950be2abd8ca5d2428a8c915aa62c24
>> -- 
>> 2.27.0
>>
> ---
> 	-Jay Vosburgh, jay.vosburgh@canonical.com
