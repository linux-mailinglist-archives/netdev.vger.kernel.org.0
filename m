Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6946358C43B
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 09:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235914AbiHHHlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 03:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239232AbiHHHkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 03:40:53 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CE87EA188;
        Mon,  8 Aug 2022 00:40:50 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.188:35708.210023178
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-182.42.224.56 (unknown [172.18.0.188])
        by chinatelecom.cn (HERMES) with SMTP id F276528009E;
        Mon,  8 Aug 2022 15:40:40 +0800 (CST)
X-189-SAVE-TO-SEND: sunshouxin@chinatelecom.cn
Received: from  ([172.18.0.188])
        by app0023 with ESMTP id b08883f68b494bb590f1e44e66e496b3 for huyd12@chinatelecom.cn;
        Mon, 08 Aug 2022 15:40:46 CST
X-Transaction-ID: b08883f68b494bb590f1e44e66e496b3
X-Real-From: sunshouxin@chinatelecom.cn
X-Receive-IP: 172.18.0.188
X-MEDUSA-Status: 0
Sender: sunshouxin@chinatelecom.cn
Subject: Re: [PATCH] net:bonding:support balance-alb interface with vlan to
 bridge
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        huyd12@chinatelecom.cn
References: <20220805074556.70297-1-sunshouxin@chinatelecom.cn>
 <3917.1659727127@famine>
From:   "sunshouxin@chinatelecom.cn" <sunshouxin@chinatelecom.cn>
Message-ID: <e557c459-3337-6e5e-d6b5-28a89513b919@chinatelecom.cn>
Date:   Mon, 8 Aug 2022 15:40:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <3917.1659727127@famine>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/8/6 3:18, Jay Vosburgh 写道:
> Sun Shouxin <sunshouxin@chinatelecom.cn> wrote:
>
>> In my test, balance-alb bonding with two slaves eth0 and eth1,
>> and then Bond0.150 is created with vlan id attached bond0.
>> After adding bond0.150 into one linux bridge, I noted that Bond0,
>> bond0.150 and  bridge were assigned to the same MAC as eth0.
>> Once bond0.150 receives a packet whose dest IP is bridge's
>> and dest MAC is eth1's, the linux bridge cannot process it as expected.
>> The patch fix the issue, and diagram as below:
>>
>> eth1(mac:eth1_mac)--bond0(balance-alb,mac:eth0_mac)--eth0(mac:eth0_mac)
>>       		      |
>>       		   bond0.150(mac:eth0_mac)
>>       		      |
>>       	           bridge(ip:br_ip, mac:eth0_mac)--other port
> 	In principle, since 567b871e5033, the bond alb mode shouldn't be
> load balancing incoming traffic for an IP address arriving via a bridge
> configured above the bond.
>
> 	Looking at it, there's logic in rlb_arp_xmit to exclude the
> bridge-over-bond case, but it relies on the MAC of traffic arriving via
> the bridge being different from the bond's MAC.  I suspect this is
> because 567b871e5033 was intended to manage traffic originating from
> other bridge ports, and didn't consider the case of the bridge itself
> when the bridge MAC equals the bond MAC.
>
> 	The bridge MAC will equal the bond MAC if the bond is the first
> port added to the bridge, because the bridge will normally adopt the MAC
> of the first port added (unless manually set to something else).
>
> 	I think the correct fix here is to update the test in
> rlb_arp_xmit to properly exclude all bridge traffic (i.e., handle the
> bridge MAC == bond MAC case), not to alter the destination MAC address
> in incoming traffic.
>
> 	-J


Thanks your warm instruction, I'll resend patch as your suggestion.

   -Sun


>
>> Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
>> Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
>> ---
>> drivers/net/bonding/bond_main.c | 20 ++++++++++++++++++++
>> 1 file changed, 20 insertions(+)
>>
>> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>> index e75acb14d066..6210a9c7ca76 100644
>> --- a/drivers/net/bonding/bond_main.c
>> +++ b/drivers/net/bonding/bond_main.c
>> @@ -1537,9 +1537,11 @@ static rx_handler_result_t bond_handle_frame(struct sk_buff **pskb)
>> 	struct sk_buff *skb = *pskb;
>> 	struct slave *slave;
>> 	struct bonding *bond;
>> +	struct net_device *vlan;
>> 	int (*recv_probe)(const struct sk_buff *, struct bonding *,
>> 			  struct slave *);
>> 	int ret = RX_HANDLER_ANOTHER;
>> +	unsigned int headroom;
>>
>> 	skb = skb_share_check(skb, GFP_ATOMIC);
>> 	if (unlikely(!skb))
>> @@ -1591,6 +1593,24 @@ static rx_handler_result_t bond_handle_frame(struct sk_buff **pskb)
>> 				  bond->dev->addr_len);
>> 	}
>>
>> +	if (skb_vlan_tag_present(skb)) {
>> +		if (BOND_MODE(bond) == BOND_MODE_ALB && skb->pkt_type == PACKET_HOST) {
>> +			vlan = __vlan_find_dev_deep_rcu(bond->dev, skb->vlan_proto,
>> +							skb_vlan_tag_get(skb) & VLAN_VID_MASK);
>> +			if (vlan) {
>> +				if (vlan->priv_flags & IFF_BRIDGE_PORT) {
>> +					headroom = skb->data - skb_mac_header(skb);
>> +					if (unlikely(skb_cow_head(skb, headroom))) {
>> +						kfree_skb(skb);
>> +						return RX_HANDLER_CONSUMED;
>> +					}
>> +					bond_hw_addr_copy(eth_hdr(skb)->h_dest, vlan->dev_addr,
>> +							  vlan->addr_len);
>> +				}
>> +			}
>> +		}
>> +	}
>> +
>> 	return ret;
>> }
>>
>> -- 
>> 2.27.0
>>
> ---
> 	-Jay Vosburgh, jay.vosburgh@canonical.com
