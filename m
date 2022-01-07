Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B564873F9
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 09:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345544AbiAGINV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 03:13:21 -0500
Received: from prt-mail.chinatelecom.cn ([42.123.76.228]:35132 "EHLO
        chinatelecom.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1345561AbiAGINT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 03:13:19 -0500
HMM_SOURCE_IP: 172.18.0.218:48104.1743217960
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-10.133.11.244 (unknown [172.18.0.218])
        by chinatelecom.cn (HERMES) with SMTP id D081828016C;
        Fri,  7 Jan 2022 16:13:06 +0800 (CST)
X-189-SAVE-TO-SEND: sunshouxin@chinatelecom.cn
Received: from  ([172.18.0.218])
        by app0025 with ESMTP id 62f87b24bab5456a82627ef55e55c1ef for jay.vosburgh@canonical.com;
        Fri, 07 Jan 2022 16:13:09 CST
X-Transaction-ID: 62f87b24bab5456a82627ef55e55c1ef
X-Real-From: sunshouxin@chinatelecom.cn
X-Receive-IP: 172.18.0.218
X-MEDUSA-Status: 0
Sender: sunshouxin@chinatelecom.cn
Message-ID: <1d483071-a699-8b90-096d-196415c99dca@chinatelecom.cn>
Date:   Fri, 7 Jan 2022 16:13:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v5] net: bonding: Add support for IPV6 ns/na to
 balance-alb/balance-tlb mode
From:   =?UTF-8?B?5a2Z5a6I6ZGr?= <sunshouxin@chinatelecom.cn>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, huyd12@chinatelecom.cn
References: <20211224142512.44182-1-sunshouxin@chinatelecom.cn>
 <24897.1640637370@famine>
 <db66dccf-0c84-d22d-fb2f-f99d3ce2371d@chinatelecom.cn>
 <d257be6c-de77-7fcd-d540-d04d8f9316ee@chinatelecom.cn>
In-Reply-To: <d257be6c-de77-7fcd-d540-d04d8f9316ee@chinatelecom.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi guys

Any comment?

thanks a lot.


在 2022/1/4 16:35, 孙守鑫 写道:
>
> Any comments will be appreciated.
>
>
> 在 2021/12/28 11:01, 孙守鑫 写道:
>>
>> 在 2021/12/28 4:36, Jay Vosburgh 写道:
>>> Sun Shouxin <sunshouxin@chinatelecom.cn> wrote:
>>>
>>>> Since ipv6 neighbor solicitation and advertisement messages
>>>> isn't handled gracefully in bonding6 driver, we can see packet
>>>> drop due to inconsistency bewteen mac address in the option
>>>> message and source MAC .
>>>>
>>>> Another examples is ipv6 neighbor solicitation and advertisement
>>>> messages from VM via tap attached to host brighe, the src mac
>>>> mighe be changed through balance-alb mode, but it is not synced
>>>> with Link-layer address in the option message.
>>>>
>>>> The patch implements bond6's tx handle for ipv6 neighbor
>>>> solicitation and advertisement messages.
>>>     I'm not sure what you've changed here for v5 as there's no
>>> changelog, but I believe the observed problems to be a transmit side
>>> effect (i.e., it is induced by the balance-tlb mode balancing of
>>> outgoing traffic).  As such, the tlb side will rebalance all of the
>>> traffic every ten seconds, so any MAC ND_OPT_*_LL_ADDR option
>>> assignments in the outgoing NS/NA datagrams will only be valid for that
>>> length of time, correct?
>>
>>
>> Yes,  MAC ND_OPT_*_LL_ADDR option assignments in the outgoing NS/NA
>> datagrams will only be valid for that length of time ,and then,
>> it will be inconsistensy in the next ten seconds.
>>
>>
>>>     The topology diagram and example that you've removed from the
>>> commit log with v5 said, in part, that the issue arose because the
>>> LL_ADDR option MAC didn't match the actual source MAC.  Since tlb mode
>>> can reshuffle the flows every ten seconds, how did the proposed 
>>> solution
>>> work reliably?
>>
>>
>> In function alb_set_nd_option, we will change the LL_ADDR option Mac
>> to the source Mac. This could work in this conditon.
>>
>>
>>>
>>>     In any event, my real question is whether simply disabling tlb
>>> balancing for NS/NA datagrams will resolve the observed issues (i.e.,
>>> have bond_xmit_tlb_slave_get return NULL for IPv6 NS/NA datagrams).
>>> Doing so will cause all NS/NA traffic to egress through the active
>>> interface.  There's already a test in your logic to check for the
>>> tx_slave != bond->curr_active_slave, so presumably everything works
>>> correctly if the NS/NA goes out on the curr_active_slave.  If the "edit
>>> NS/NA datagrams" solution works even in the face of rebalance of
>>> traffic, then would simply assigning all NS/NA traffic to the
>>> curr_active_slave eliminate the problem?
>>
>>
>> Yes, assigning all Ns/Na traffic to the curr_active_slave can resolve 
>> the
>> difference between mac in the Ns/Na options with the source mac.
>> But this makes the rlb doesn't work in the alb mode,
>> one interface with bond6 will not receive any ingress packets.
>> It is mismatch Bond6 specification.
>>
>>
>>>
>>>     -J
>>>
>>>> Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
>>>> Reported-by: kernel test robot <lkp@intel.com>
>>>> Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
>>>> ---
>>>> drivers/net/bonding/bond_alb.c | 149 +++++++++++++++++++++++++++++++++
>>>> 1 file changed, 149 insertions(+)
>>>>
>>>> diff --git a/drivers/net/bonding/bond_alb.c 
>>>> b/drivers/net/bonding/bond_alb.c
>>>> index 533e476988f2..485e4863a365 100644
>>>> --- a/drivers/net/bonding/bond_alb.c
>>>> +++ b/drivers/net/bonding/bond_alb.c
>>>> @@ -22,6 +22,8 @@
>>>> #include <asm/byteorder.h>
>>>> #include <net/bonding.h>
>>>> #include <net/bond_alb.h>
>>>> +#include <net/ndisc.h>
>>>> +#include <net/ip6_checksum.h>
>>>>
>>>> static const u8 mac_v6_allmcast[ETH_ALEN + 2] __long_aligned = {
>>>>     0x33, 0x33, 0x00, 0x00, 0x00, 0x01
>>>> @@ -1269,6 +1271,137 @@ static int alb_set_mac_address(struct 
>>>> bonding *bond, void *addr)
>>>>     return res;
>>>> }
>>>>
>>>> +/*determine if the packet is NA or NS*/
>>>> +static bool __alb_determine_nd(struct icmp6hdr *hdr)
>>>> +{
>>>> +    if (hdr->icmp6_type == NDISC_NEIGHBOUR_ADVERTISEMENT ||
>>>> +        hdr->icmp6_type == NDISC_NEIGHBOUR_SOLICITATION) {
>>>> +        return true;
>>>> +    }
>>>> +
>>>> +    return false;
>>>> +}
>>>> +
>>>> +static void alb_change_nd_option(struct sk_buff *skb, void *data)
>>>> +{
>>>> +    struct nd_msg *msg = (struct nd_msg *)skb_transport_header(skb);
>>>> +    struct nd_opt_hdr *nd_opt = (struct nd_opt_hdr *)msg->opt;
>>>> +    struct net_device *dev = skb->dev;
>>>> +    struct icmp6hdr *icmp6h = icmp6_hdr(skb);
>>>> +    struct ipv6hdr *ip6hdr = ipv6_hdr(skb);
>>>> +    u8 *lladdr = NULL;
>>>> +    u32 ndoptlen = skb_tail_pointer(skb) - 
>>>> (skb_transport_header(skb) +
>>>> +                offsetof(struct nd_msg, opt));
>>>> +
>>>> +    while (ndoptlen) {
>>>> +        int l;
>>>> +
>>>> +        switch (nd_opt->nd_opt_type) {
>>>> +        case ND_OPT_SOURCE_LL_ADDR:
>>>> +        case ND_OPT_TARGET_LL_ADDR:
>>>> +            lladdr = ndisc_opt_addr_data(nd_opt, dev);
>>>> +            break;
>>>> +
>>>> +        default:
>>>> +            lladdr = NULL;
>>>> +            break;
>>>> +        }
>>>> +
>>>> +        l = nd_opt->nd_opt_len << 3;
>>>> +
>>>> +        if (ndoptlen < l || l == 0)
>>>> +            return;
>>>> +
>>>> +        if (lladdr) {
>>>> +            memcpy(lladdr, data, dev->addr_len);
>>>> +            icmp6h->icmp6_cksum = 0;
>>>> +
>>>> +            icmp6h->icmp6_cksum = csum_ipv6_magic(&ip6hdr->saddr,
>>>> +                                  &ip6hdr->daddr,
>>>> +                        ntohs(ip6hdr->payload_len),
>>>> +                        IPPROTO_ICMPV6,
>>>> +                        csum_partial(icmp6h,
>>>> + ntohs(ip6hdr->payload_len), 0));
>>>> +            return;
>>>> +        }
>>>> +        ndoptlen -= l;
>>>> +        nd_opt = ((void *)nd_opt) + l;
>>>> +    }
>>>> +}
>>>> +
>>>> +static u8 *alb_get_lladdr(struct sk_buff *skb)
>>>> +{
>>>> +    struct nd_msg *msg = (struct nd_msg *)skb_transport_header(skb);
>>>> +    struct nd_opt_hdr *nd_opt = (struct nd_opt_hdr *)msg->opt;
>>>> +    struct net_device *dev = skb->dev;
>>>> +    u8 *lladdr = NULL;
>>>> +    u32 ndoptlen = skb_tail_pointer(skb) - 
>>>> (skb_transport_header(skb) +
>>>> +                offsetof(struct nd_msg, opt));
>>>> +
>>>> +    while (ndoptlen) {
>>>> +        int l;
>>>> +
>>>> +        switch (nd_opt->nd_opt_type) {
>>>> +        case ND_OPT_SOURCE_LL_ADDR:
>>>> +        case ND_OPT_TARGET_LL_ADDR:
>>>> +            lladdr = ndisc_opt_addr_data(nd_opt, dev);
>>>> +            break;
>>>> +
>>>> +        default:
>>>> +            break;
>>>> +        }
>>>> +
>>>> +        l = nd_opt->nd_opt_len << 3;
>>>> +
>>>> +        if (ndoptlen < l || l == 0)
>>>> +            return NULL;
>>>> +
>>>> +        if (lladdr)
>>>> +            return lladdr;
>>>> +
>>>> +        ndoptlen -= l;
>>>> +        nd_opt = ((void *)nd_opt) + l;
>>>> +    }
>>>> +
>>>> +    return lladdr;
>>>> +}
>>>> +
>>>> +static void alb_set_nd_option(struct sk_buff *skb, struct bonding 
>>>> *bond,
>>>> +                  struct slave *tx_slave)
>>>> +{
>>>> +    struct ipv6hdr *ip6hdr;
>>>> +    struct icmp6hdr *hdr;
>>>> +
>>>> +    if (skb->protocol == htons(ETH_P_IPV6)) {
>>>> +        if (tx_slave && tx_slave !=
>>>> +            rcu_access_pointer(bond->curr_active_slave)) {
>>>> +            ip6hdr = ipv6_hdr(skb);
>>>> +            if (ip6hdr->nexthdr == IPPROTO_ICMPV6) {
>>>> +                hdr = icmp6_hdr(skb);
>>>> +                if (__alb_determine_nd(hdr))
>>>> +                    alb_change_nd_option(skb, 
>>>> tx_slave->dev->dev_addr);
>>>> +            }
>>>> +        }
>>>> +    }
>>>> +}
>>>> +
>>>> +static bool alb_determine_nd(struct sk_buff *skb, struct bonding 
>>>> *bond)
>>>> +{
>>>> +    struct ipv6hdr *ip6hdr;
>>>> +    struct icmp6hdr *hdr;
>>>> +
>>>> +    if (skb->protocol == htons(ETH_P_IPV6)) {
>>>> +        ip6hdr = ipv6_hdr(skb);
>>>> +        if (ip6hdr->nexthdr == IPPROTO_ICMPV6) {
>>>> +            hdr = icmp6_hdr(skb);
>>>> +            if (__alb_determine_nd(hdr))
>>>> +                return true;
>>>> +        }
>>>> +    }
>>>> +
>>>> +    return false;
>>>> +}
>>>> +
>>>> /************************ exported alb functions 
>>>> ************************/
>>>>
>>>> int bond_alb_initialize(struct bonding *bond, int rlb_enabled)
>>>> @@ -1350,6 +1483,9 @@ struct slave *bond_xmit_tlb_slave_get(struct 
>>>> bonding *bond,
>>>>         switch (skb->protocol) {
>>>>         case htons(ETH_P_IP):
>>>>         case htons(ETH_P_IPV6):
>>>> +            if (alb_determine_nd(skb, bond))
>>>> +                break;
>>>> +
>>>>             hash_index = bond_xmit_hash(bond, skb);
>>>>             if (bond->params.tlb_dynamic_lb) {
>>>>                 tx_slave = tlb_choose_channel(bond,
>>>> @@ -1446,6 +1582,18 @@ struct slave *bond_xmit_alb_slave_get(struct 
>>>> bonding *bond,
>>>>             break;
>>>>         }
>>>>
>>>> +        if (alb_determine_nd(skb, bond)) {
>>>> +            u8 *lladdr;
>>>> +
>>>> +            lladdr = alb_get_lladdr(skb);
>>>> +            if (lladdr) {
>>>> +                if (!bond_slave_has_mac_rx(bond, lladdr)) {
>>>> +                    do_tx_balance = false;
>>>> +                    break;
>>>> +                }
>>>> +            }
>>>> +        }
>>>> +
>>>>         hash_start = (char *)&ip6hdr->daddr;
>>>>         hash_size = sizeof(ip6hdr->daddr);
>>>>         break;
>>>> @@ -1489,6 +1637,7 @@ netdev_tx_t bond_alb_xmit(struct sk_buff 
>>>> *skb, struct net_device *bond_dev)
>>>>     struct slave *tx_slave = NULL;
>>>>
>>>>     tx_slave = bond_xmit_alb_slave_get(bond, skb);
>>>> +    alb_set_nd_option(skb, bond, tx_slave);
>>>>     return bond_do_alb_xmit(skb, bond, tx_slave);
>>>> }
>>>>
>>>>
>>>> base-commit: 7a29b11da9651ef6a970e2f6bfd276f053aeb06a
>>>> -- 
>>>> 2.27.0
>>>>
>>> ---
>>>     -Jay Vosburgh, jay.vosburgh@canonical.com
