Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEBF346FB20
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 08:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235145AbhLJHNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 02:13:33 -0500
Received: from prt-mail.chinatelecom.cn ([42.123.76.228]:47035 "EHLO
        chinatelecom.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231245AbhLJHNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 02:13:32 -0500
HMM_SOURCE_IP: 172.18.0.48:58474.897148359
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-10.133.11.244 (unknown [172.18.0.48])
        by chinatelecom.cn (HERMES) with SMTP id 4718E280374;
        Fri, 10 Dec 2021 15:09:31 +0800 (CST)
X-189-SAVE-TO-SEND: sunshouxin@chinatelecom.cn
Received: from  ([172.18.0.48])
        by app0024 with ESMTP id de9b92dc097f4d0baddf5600ea6051b1 for jay.vosburgh@canonical.com;
        Fri, 10 Dec 2021 15:09:44 CST
X-Transaction-ID: de9b92dc097f4d0baddf5600ea6051b1
X-Real-From: sunshouxin@chinatelecom.cn
X-Receive-IP: 172.18.0.48
X-MEDUSA-Status: 0
Sender: sunshouxin@chinatelecom.cn
Message-ID: <d1b97a56-eb68-7e0a-6d0f-4ba04395e915@chinatelecom.cn>
Date:   Fri, 10 Dec 2021 15:09:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] net: bonding: Add support for IPV6 ns/na
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, huyd12@chinatelecom.cn
References: <1639032622-28098-1-git-send-email-sunshouxin@chinatelecom.cn>
 <27832.1639081353@famine>
From:   =?UTF-8?B?5a2Z5a6I6ZGr?= <sunshouxin@chinatelecom.cn>
In-Reply-To: <27832.1639081353@famine>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/12/10 4:22, Jay Vosburgh 写道:
> Sun Shouxin <sunshouxin@chinatelecom.cn> wrote:
>
>> Since ipv6 neighbor solicitation and advertisement messages
>> isn't handled gracefully in bonding6 driver, we can see packet
>> drop due to inconsistency bewteen mac address in the option
>> message and source MAC .
> 	Could you provide a specific example where this occurs?

                       Border-Leaf
                       /        \
                      /          \
                  Tunnel1    Tunnel2
                    /              \
                   /                \
                 Leaf-1--Tunnel3--Leaf-2
                   \                /
                    \              /
                     \            /
                      \          /
                     NIC1    NIC2
                        \      /
                         server

We can see in our lab the Border-Leaf receives occasionally a NA packet 
which is assgined to NIC1 mac in ND/NS option message, but actaully send 
out via NIC2 mac due to tx-alb,
as a result, it will cause inconsistency between MAC table and ND Table 
in Border-Leaf, i.e, NIC1 = Tunnel2 in ND table and  NIC1 = Tunnel1 in 
mac table.

And then, Border-Leaf starts to forward packet destinated to the Server, 
it will only check the ND table entry in some switch to encapsulate the 
destination MAC of the message as NIC1 MAC,
and then send it out from Tunnel2 by ND table.
Then, Leaf-2 receives the packet, it notices the destination MAC of 
message is NIC1 MAC and should forword it to Tunne1 by Tunnel3.
However, this traffic forward will be failure due to split horizon of 
VxLAN tunnels.

>
>> Another examples is ipv6 neighbor solicitation and advertisement
>> messages from VM via tap attached to host brighe, the src mac
>> mighe be changed through balance-alb mode, but it is not synced
>> with Link-layer address in the option message.
> 	What happens if the MAC assignment changes because alb does a
> rebalance?
The same result occurs as above, it just is specific to virtualization 
conext.
In this case, the src mac of packet send out by host is from VM' tap and 
not NIC1/NIC2 in host.
>
>> The patch implements bond6's tx handle for ipv6 neighbor
>> solicitation and advertisement messages.
> 	A few additional minor comments below.
Thanks your comment, I'll adjust it and send out V2 soon.
>
>> Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
>> Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
>> ---
>> drivers/net/bonding/bond_alb.c | 127 +++++++++++++++++++++++++++++++++++++++++
>> 1 file changed, 127 insertions(+)
>>
>> diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
>> index 2ec8e01..01566ba 100644
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
>> @@ -1269,6 +1270,112 @@ static int alb_set_mac_address(struct bonding *bond, void *addr)
>> 	return res;
>> }
>>
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
>> +		break;
>> +		}
>> +
>> +		l = nd_opt->nd_opt_len << 3;
>> +
>> +		if (ndoptlen < l || l == 0)
>> +			return;
>> +
>> +		if (lladdr) {
>> +			memcpy(lladdr, data, dev->addr_len);
>> +			lladdr = NULL;
>> +			icmp6h->icmp6_cksum = 0;
>> +
>> +			icmp6h->icmp6_cksum = csum_ipv6_magic(&ip6hdr->saddr,
>> +							      &ip6hdr->daddr,
>> +						ntohs(ip6hdr->payload_len),
>> +						IPPROTO_ICMPV6,
>> +						csum_partial(icmp6h,
>> +							     ntohs(ip6hdr->payload_len), 0));
>> +			lladdr = NULL;
> 	"lladdr = NULL" could be in the default: case, above, instead of
> being done here (and it's here twice).
>
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
>> +			return lladdr;
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
>> +
>> +	if (tx_slave && tx_slave != rcu_access_pointer(bond->curr_active_slave)) {
>> +		if (ntohs(skb->protocol) == ETH_P_IPV6) {
> 	Nit: use "skb->protocol == htons(ETH_P_IPV6)" as the compiler
> should optimize the htons() of a constant.  Also, you may want to
> consider reordering the tests here, as IPv6 NA/NS traffic is likely to
> be the vast minority.
>
>> +			ip6hdr = ipv6_hdr(skb);
>> +			if (ip6hdr->nexthdr == IPPROTO_ICMPV6) {
>> +				hdr = icmp6_hdr(skb);
>> +				if (hdr->icmp6_type ==
>> +				    NDISC_NEIGHBOUR_ADVERTISEMENT ||
>> +				     hdr->icmp6_type ==
>> +				     NDISC_NEIGHBOUR_SOLICITATION) {
> 	This construct appears twice, perhaps it deserves its own
> boolean-return function?
>
> 	-J
>
>> +					alb_change_nd_option(skb, tx_slave->dev->dev_addr);
>> +				}
>> +			}
>> +		}
>> +	}
>> +}
>> +
>> /************************ exported alb functions ************************/
>>
>> int bond_alb_initialize(struct bonding *bond, int rlb_enabled)
>> @@ -1415,6 +1522,7 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
>> 	}
>> 	case ETH_P_IPV6: {
>> 		const struct ipv6hdr *ip6hdr;
>> +		struct icmp6hdr *hdr = NULL;
>>
>> 		/* IPv6 doesn't really use broadcast mac address, but leave
>> 		 * that here just in case.
>> @@ -1446,6 +1554,24 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
>> 			break;
>> 		}
>>
>> +		if (ip6hdr->nexthdr == IPPROTO_ICMPV6) {
>> +			hdr = icmp6_hdr(skb);
>> +			if (hdr->icmp6_type ==
>> +			    NDISC_NEIGHBOUR_ADVERTISEMENT ||
>> +			    hdr->icmp6_type ==
>> +			    NDISC_NEIGHBOUR_SOLICITATION) {
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
>> @@ -1489,6 +1615,7 @@ netdev_tx_t bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
>> 	struct slave *tx_slave = NULL;
>>
>> 	tx_slave = bond_xmit_alb_slave_get(bond, skb);
>> +	alb_set_nd_option(skb, bond, tx_slave);
>> 	return bond_do_alb_xmit(skb, bond, tx_slave);
>> }
>>
>> -- 
>> 1.8.3.1
>>
> ---
> 	-Jay Vosburgh, jay.vosburgh@canonical.com
