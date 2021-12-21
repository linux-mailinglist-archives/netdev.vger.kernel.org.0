Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA0847BCE9
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 10:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235247AbhLUJcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 04:32:42 -0500
Received: from prt-mail.chinatelecom.cn ([42.123.76.227]:54630 "EHLO
        chinatelecom.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229548AbhLUJcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 04:32:42 -0500
HMM_SOURCE_IP: 172.18.0.188:53564.1306040808
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-10.133.11.244 (unknown [172.18.0.188])
        by chinatelecom.cn (HERMES) with SMTP id E18552800BA;
        Tue, 21 Dec 2021 17:32:35 +0800 (CST)
X-189-SAVE-TO-SEND: sunshouxin@chinatelecom.cn
Received: from  ([172.18.0.188])
        by app0023 with ESMTP id 58ffa9142fe443bea319c962c45ef6ee for jay.vosburgh@canonical.com;
        Tue, 21 Dec 2021 17:32:37 CST
X-Transaction-ID: 58ffa9142fe443bea319c962c45ef6ee
X-Real-From: sunshouxin@chinatelecom.cn
X-Receive-IP: 172.18.0.188
X-MEDUSA-Status: 0
Sender: sunshouxin@chinatelecom.cn
Message-ID: <098b2c59-d2e9-7bb1-2ca2-353d7f9c644f@chinatelecom.cn>
Date:   Tue, 21 Dec 2021 17:32:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v4] net: bonding: Add support for IPV6 ns/na to
 balance-alb mode
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, huyd12@chinatelecom.cn
References: <20211220152455.37413-1-sunshouxin@chinatelecom.cn>
 <31773.1640033306@famine>
From:   =?UTF-8?B?5a2Z5a6I6ZGr?= <sunshouxin@chinatelecom.cn>
In-Reply-To: <31773.1640033306@famine>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/12/21 4:48, Jay Vosburgh 写道:
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
>>                          \      /
>>                           server
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
> 	Should the above state "forward it to Leaf-1 by Tunnel3", not
> "to Tunnel1"?  Presumably Leaf-1 would then forward a packet with NIC1
> MAC destination directly to NIC1.  You mention VXLAN split horizon
> below, but I'm unclear on exactly why that results in a failure to
> forward vs selecting a suboptimal path.
>
> 	My overall concern here is that this is a complex solution for a
> very specific configuration, and I'm not sure exactly which piece is
> doing something wrong (i.e., is Border-Leaf correct in selecting
> Tunnel2?).
>
> 	And, further, this topology is outside the scope of what the tlb
> / alb modes were designed around (which was interfacing with a single
> switch, not a distributed switch topology as shown above); alb's inbound
> load balancing in particular wasn't set up for IPv6 (it only modifies
> ARPs to assign peers to specific bonding interfaces).  That's not to say
> that we can't fix up the IPv6 support, but I don't want to eventually
> have a collection of band-aids for specific corner cases.


Let's foucs on the patch, anyway, the mac in ns/na option message should
be the consistent with the source mac address as the arp handle.
So, I think it is necessecy to fix it.


>
> 	Also, on thinking about it, I'm unsure why the tlb mode would
> not exhibit the same issue, since you're not altering the alb inbound
> load balancer (the "tailored ARP per peer" logic), just the regular
> transmit side, which is largely the same for tlb.  Have you tested
> balance-tlb mode?


I've just tested it on my side as your suggestion, I can see the issue
also affect tlb mode and send off V5 for tlb soon.


>
> 	Lastly, Eric's question about not altering the original skb
> isn't explictly addressed that I can see (although it seems Eric was
> concerned about received packets, and this is modifying packets being
> transmitted).  The code looks like it shouldn't modify NS/NA packets
> that are being forwarded through the bond (the bond_slave_has_mac_rx
> test), but is it possible for a locally originating NS/NA to be a clone?
>
> 	-J


Yes, the patch focus mainly on trasmitting instead of receiving.
As to skb clone,I don't know what's considition need to be considered,
but I wonder if we should consider it?


>> However, this traffic forward will be failure due to split
>> horizon of VxLAN tunnels.
>>
>> Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
>> Reported-by: kernel test robot <lkp@intel.com>
>> Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
>> ---
>> drivers/net/bonding/bond_alb.c | 132 +++++++++++++++++++++++++++++++++
>> 1 file changed, 132 insertions(+)
>>
>> diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
>> index 533e476988f2..e8d6d1f2f540 100644
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
>> @@ -1269,6 +1270,120 @@ static int alb_set_mac_address(struct bonding *bond, void *addr)
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
>> +			lladdr = ndisc_opt_addr_data(nd_opt, dev);
>> +			break;
>> +
>> +		default:
>> +			lladdr = NULL;
>> +			break;
>> +		}
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
>> +			return;
>> +		}
>> +		ndoptlen -= l;
>> +		nd_opt = ((void *)nd_opt) + l;
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
>> +	struct icmp6hdr *hdr;
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
>> @@ -1415,6 +1530,7 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
>> 	}
>> 	case ETH_P_IPV6: {
>> 		const struct ipv6hdr *ip6hdr;
>> +		struct icmp6hdr *hdr;
>>
>> 		/* IPv6 doesn't really use broadcast mac address, but leave
>> 		 * that here just in case.
>> @@ -1446,6 +1562,21 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
>> 			break;
>> 		}
>>
>> +		if (ip6hdr->nexthdr == IPPROTO_ICMPV6) {
>> +			hdr = icmp6_hdr(skb);
>> +			if (alb_determine_nd(hdr)) {
>> +				u8 *lladdr;
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
>> @@ -1489,6 +1620,7 @@ netdev_tx_t bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
>> 	struct slave *tx_slave = NULL;
>>
>> 	tx_slave = bond_xmit_alb_slave_get(bond, skb);
>> +	alb_set_nd_option(skb, bond, tx_slave);
>> 	return bond_do_alb_xmit(skb, bond, tx_slave);
>> }
>>
>>
>> base-commit: a7904a538933c525096ca2ccde1e60d0ee62c08e
>> -- 
>> 2.27.0
>>
> ---
> 	-Jay Vosburgh, jay.vosburgh@canonical.com
