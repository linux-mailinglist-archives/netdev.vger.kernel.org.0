Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE3F547A86D
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 12:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbhLTLNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 06:13:08 -0500
Received: from prt-mail.chinatelecom.cn ([42.123.76.223]:45587 "EHLO
        chinatelecom.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230507AbhLTLNH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 06:13:07 -0500
HMM_SOURCE_IP: 172.18.0.218:52586.20223611
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-10.133.11.244 (unknown [172.18.0.218])
        by chinatelecom.cn (HERMES) with SMTP id 7329C280079;
        Mon, 20 Dec 2021 19:12:58 +0800 (CST)
X-189-SAVE-TO-SEND: sunshouxin@chinatelecom.cn
Received: from  ([172.18.0.218])
        by app0025 with ESMTP id c37ff802d4c54c6a938ea277d782c28e for jay.vosburgh@canonical.com;
        Mon, 20 Dec 2021 19:13:01 CST
X-Transaction-ID: c37ff802d4c54c6a938ea277d782c28e
X-Real-From: sunshouxin@chinatelecom.cn
X-Receive-IP: 172.18.0.218
X-MEDUSA-Status: 0
Sender: sunshouxin@chinatelecom.cn
Message-ID: <085c3477-3fff-7de6-cf0f-7fe33bae71cd@chinatelecom.cn>
Date:   Mon, 20 Dec 2021 19:12:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v3] net: bonding: Add support for IPV6 ns/na
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, huyd12@chinatelecom.cn
References: <20211217164829.31388-1-sunshouxin@chinatelecom.cn>
 <15944.1639782565@famine>
From:   =?UTF-8?B?5a2Z5a6I6ZGr?= <sunshouxin@chinatelecom.cn>
In-Reply-To: <15944.1639782565@famine>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/12/18 7:09, Jay Vosburgh 写道:
> 	For clarity, please add "to balance-alb mode" to the Subject.
Thanks your comment, I'll adjust it and send out V4 soon.
>
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
>>
>>                         Border-Leaf
>>                         /        \
>>                        /          \
>>                     Tunnel1    Tunnel2
>>                      /              \
>>                     /                \
>>                   Leaf-1--Tunnel3--Leaf-2
>>                     \                /
>>                      \              /
>>                       \            /
>>                        \          /
>>                        NIC1    NIC2
>>                         \      /
>>                         server
>>
>> We can see in our lab the Border-Leaf receives occasionally
>> a NA packet which is assigned to NIC1 mac in ND/NS option
>> message, but actaully send out via NIC2 mac due to tx-alb,
>> as a result, it will cause inconsistency between MAC table
>> and ND Table in Border-Leaf, i.e, NIC1 = Tunnel2 in ND table
>> and  NIC1 = Tunnel1 in mac table.
>>
>> And then, Border-Leaf starts to forward packet destinated
>> to the Server, it will only check the ND table entry in some
>> switch to encapsulate the destination MAC of the message as
>> NIC1 MAC, and then send it out from Tunnel2 by ND table.
>> Then, Leaf-2 receives the packet, it notices the destination
>> MAC of message is NIC1 MAC and should forword it to Tunne1
>> by Tunnel3.
>>
>> However, this traffic forward will be failure due to split
>> horizon of VxLAN tunnels.
> 	I believe I understand what problem you're trying to solve here,
> but the solution seems to be incomplete, as (from our prior discussion)
> a rebalance event for balance-alb will apparently induce the same
> problem.  Granted, those do not occur frequently (only when interfaces
> are added to the bond, or an interface link state changes), but have you
> tested what happens if NIC1 or NIC2 (or in a situation with more than
> two interfaces) undergoes a link state change?
The code in the bond_xmit_alb_slave_get should act for ns/na in the 
rebalance.
what's more, with NIC1/NIC2 link state change, I don't observe abnormal 
scene.
>
>> Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
>> Reviewed-by: Jay Vosburgh<jay.vosburgh@canonical.com>
> 	I did not include this signoff tag in my prior message.  Please
> do not include such tags unless explicitly provided by the relevant
> person.  Discussion on the mailing list is not equivalent to providing
> the tag; please review Documentation/process/submitting-patches.rst.
Thanks your comment, I'll adjust it.
>
>> Reviewed-by: Eric Dumazet<eric.dumazet@gmail.com>
>> Reported-by: kernel test robot <lkp@intel.com>
>> Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
>> ---
>> drivers/net/bonding/bond_alb.c | 131 +++++++++++++++++++++++++++++++++
>> 1 file changed, 131 insertions(+)
>>
>> diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
>> index 533e476988f2..b14017364594 100644
>> --- a/drivers/net/bonding/bond_alb.c
>> +++ b/drivers/net/bonding/bond_alb.c
>> @@ -22,6 +22,7 @@
>> #include <asm/byteorder.h>
>> #include <net/bonding.h>
>> #include <net/bond_alb.h>
>> +#include <net/ndisc.h>
>>
>> static const u8 mac_v6_allmcast[ETH_ALEN + 2] __long_aligned = {
>> 	0x33, 0x33, 0x00, 0x00, 0x00, 0x01
>> @@ -1269,6 +1270,119 @@ static int alb_set_mac_address(struct bonding *bond, void *addr)
>> 	return res;
>> }
>>
>> +/*determine if the packet is NA or NS*/
>> +static bool alb_determine_nd(struct icmp6hdr *hdr)
>> +{
>> +	if (hdr->icmp6_type == NDISC_NEIGHBOUR_ADVERTISEMENT ||
>> +	    hdr->icmp6_type == NDISC_NEIGHBOUR_SOLICITATION) {
>> +		return true;
>> +	}
>> +
>> +	return false;
>> +}
>> +
>> +static void alb_change_nd_option(struct sk_buff *skb, void *data)
>> +{
>> +	struct nd_msg *msg = (struct nd_msg *)skb_transport_header(skb);
>> +	struct nd_opt_hdr *nd_opt = (struct nd_opt_hdr *)msg->opt;
>> +	struct net_device *dev = skb->dev;
>> +	struct icmp6hdr *icmp6h = icmp6_hdr(skb);
>> +	struct ipv6hdr *ip6hdr = ipv6_hdr(skb);
>> +	u8 *lladdr = NULL;
>> +	u32 ndoptlen = skb_tail_pointer(skb) - (skb_transport_header(skb) +
>> +				offsetof(struct nd_msg, opt));
>> +
>> +	while (ndoptlen) {
>> +		int l;
>> +
>> +		switch (nd_opt->nd_opt_type) {
>> +		case ND_OPT_SOURCE_LL_ADDR:
>> +		case ND_OPT_TARGET_LL_ADDR:
>> +		lladdr = ndisc_opt_addr_data(nd_opt, dev);
>> +		break;
>> +
>> +		default:
>> +		lladdr = NULL;
>> +		break;
>> +		}
> 	The above block is indented incorrectly (the "lladdr" and
> "break" lines should be further in).
Thanks your comment, I'll adjust it.
>
>> +
>> +		l = nd_opt->nd_opt_len << 3;
>> +
>> +		if (ndoptlen < l || l == 0)
>> +			return;
>> +
>> +		if (lladdr) {
>> +			memcpy(lladdr, data, dev->addr_len);
>> +			icmp6h->icmp6_cksum = 0;
>> +
>> +			icmp6h->icmp6_cksum = csum_ipv6_magic(&ip6hdr->saddr,
>> +							      &ip6hdr->daddr,
>> +						ntohs(ip6hdr->payload_len),
>> +						IPPROTO_ICMPV6,
>> +						csum_partial(icmp6h,
>> +							     ntohs(ip6hdr->payload_len), 0));
>> +		}
>> +		ndoptlen -= l;
>> +		nd_opt = ((void *)nd_opt) + l;
> 	If I'm reading RFC 4861 section 4.4 correctly, a Neighbor
> Advertisement will only have ND_OPT_TARGET_LL_ADDR, and a Neighbor
> Solicitation will only have ND_OPT_SOURCE_LL_ADDR.  Assuming that's a
> correct reading, can the above break out of the loop after processing
> the first TARGET or SOURCE option seen?
Thanks your comment, I'll adjust it.
>
>> +	}
>> +}
>> +
>> +static u8 *alb_get_lladdr(struct sk_buff *skb)
>> +{
>> +	struct nd_msg *msg = (struct nd_msg *)skb_transport_header(skb);
>> +	struct nd_opt_hdr *nd_opt = (struct nd_opt_hdr *)msg->opt;
>> +	struct net_device *dev = skb->dev;
>> +	u8 *lladdr = NULL;
>> +	u32 ndoptlen = skb_tail_pointer(skb) - (skb_transport_header(skb) +
>> +				offsetof(struct nd_msg, opt));
>> +
>> +	while (ndoptlen) {
>> +		int l;
>> +
>> +		switch (nd_opt->nd_opt_type) {
>> +		case ND_OPT_SOURCE_LL_ADDR:
>> +		case ND_OPT_TARGET_LL_ADDR:
>> +			lladdr = ndisc_opt_addr_data(nd_opt, dev);
>> +			break;
>> +
>> +		default:
>> +			break;
>> +		}
>> +
>> +		l = nd_opt->nd_opt_len << 3;
>> +
>> +		if (ndoptlen < l || l == 0)
>> +			return NULL;
>> +
>> +		if (lladdr)
>> +			return lladdr;
>> +
>> +		ndoptlen -= l;
>> +		nd_opt = ((void *)nd_opt) + l;
>> +	}
>> +
>> +	return lladdr;
>> +}
>> +
>> +static void alb_set_nd_option(struct sk_buff *skb, struct bonding *bond,
>> +			      struct slave *tx_slave)
>> +{
>> +	struct ipv6hdr *ip6hdr;
>> +	struct icmp6hdr *hdr = NULL;
> 	hdr does not need to be initialized, as it's always assigned to
> before being inspected.
Thanks your comment, I'll adjust it.
>
>> +
>> +	if (skb->protocol == htons(ETH_P_IPV6)) {
>> +		if (tx_slave && tx_slave !=
>> +		    rcu_access_pointer(bond->curr_active_slave)) {
>> +			ip6hdr = ipv6_hdr(skb);
>> +			if (ip6hdr->nexthdr == IPPROTO_ICMPV6) {
>> +				hdr = icmp6_hdr(skb);
>> +				if (alb_determine_nd(hdr))
>> +					alb_change_nd_option(skb, tx_slave->dev->dev_addr);
>> +			}
>> +		}
>> +	}
>> +}
>> +
>> /************************ exported alb functions ************************/
>>
>> int bond_alb_initialize(struct bonding *bond, int rlb_enabled)
>> @@ -1415,6 +1529,7 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
>> 	}
>> 	case ETH_P_IPV6: {
>> 		const struct ipv6hdr *ip6hdr;
>> +		struct icmp6hdr *hdr = NULL;
> 	As above, hdr does not need to be initialized.
>
> 	-J
Thanks your comment, I'll adjust it.
>
>> 		/* IPv6 doesn't really use broadcast mac address, but leave
>> 		 * that here just in case.
>> @@ -1446,6 +1561,21 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
>> 			break;
>> 		}
>>
>> +		if (ip6hdr->nexthdr == IPPROTO_ICMPV6) {
>> +			hdr = icmp6_hdr(skb);
>> +			if (alb_determine_nd(hdr)) {
>> +				u8 *lladdr = NULL;
>> +
>> +				lladdr = alb_get_lladdr(skb);
>> +				if (lladdr) {
>> +					if (!bond_slave_has_mac_rx(bond, lladdr)) {
>> +						do_tx_balance = false;
>> +						break;
>> +					}
>> +				}
>> +			}
>> +		}
>> +
>> 		hash_start = (char *)&ip6hdr->daddr;
>> 		hash_size = sizeof(ip6hdr->daddr);
>> 		break;
>> @@ -1489,6 +1619,7 @@ netdev_tx_t bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
>> 	struct slave *tx_slave = NULL;
>>
>> 	tx_slave = bond_xmit_alb_slave_get(bond, skb);
>> +	alb_set_nd_option(skb, bond, tx_slave);
>> 	return bond_do_alb_xmit(skb, bond, tx_slave);
>> }
>>
>>
>> base-commit: 6441998e2e37131b0a4c310af9156d79d3351c16
>> -- 
>> 2.34.1
>>
> ---
> 	-Jay Vosburgh, jay.vosburgh@canonical.com
