Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D06A749F137
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 03:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345509AbiA1CqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 21:46:06 -0500
Received: from prt-mail.chinatelecom.cn ([42.123.76.223]:44502 "EHLO
        chinatelecom.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1345463AbiA1CqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 21:46:06 -0500
HMM_SOURCE_IP: 172.18.0.48:47634.1759737222
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-112.38.63.33 (unknown [172.18.0.48])
        by chinatelecom.cn (HERMES) with SMTP id 1F3492801DB;
        Fri, 28 Jan 2022 10:46:00 +0800 (CST)
X-189-SAVE-TO-SEND: +sunshouxin@chinatelecom.cn
Received: from  ([172.18.0.48])
        by app0024 with ESMTP id 74c010a87dc7422ea839aaaa5747819d for j.vosburgh@gmail.com;
        Fri, 28 Jan 2022 10:46:04 CST
X-Transaction-ID: 74c010a87dc7422ea839aaaa5747819d
X-Real-From: sunshouxin@chinatelecom.cn
X-Receive-IP: 172.18.0.48
X-MEDUSA-Status: 0
Sender: sunshouxin@chinatelecom.cn
Message-ID: <2a2c18ff-a2d2-acc2-83fa-b1f37e4c9199@chinatelecom.cn>
Date:   Fri, 28 Jan 2022 10:45:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v10] net: bonding: Add support for IPV6 ns/na to
 balance-alb/balance-tlb mode
To:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jay.vosburgh@canonical.com, nikolay@nvidia.com,
        huyd12@chinatelecom.cn,
        =?UTF-8?B?5a2Z5a6I6ZGr?= <sunshouxin@chinatelecom.cn>
References: <20220128023916.100071-1-sunshouxin@chinatelecom.cn>
From:   =?UTF-8?B?5a2Z5a6I6ZGr?= <sunshouxin@chinatelecom.cn>
In-Reply-To: <20220128023916.100071-1-sunshouxin@chinatelecom.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Any progress？


在 2022/1/28 10:39, Sun Shouxin 写道:
> Since ipv6 neighbor solicitation and advertisement messages
> isn't handled gracefully in bond6 driver, we can see packet
> drop due to inconsistency between mac address in the option
> message and source MAC .
>
> Another examples is ipv6 neighbor solicitation and advertisement
> messages from VM via tap attached to host bridge, the src mac
> might be changed through balance-alb mode, but it is not synced
> with Link-layer address in the option message.
>
> The patch implements bond6's tx handle for ipv6 neighbor
> solicitation and advertisement messages.
>
> Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
> Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
> Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
> ---
> v9->v10:
> - add IPv6 header pull in alb_determine_nd.
> - combine bond_xmit_alb_slave_get's IPv6 header
> pull with alb_determine_nd's
> ---
>   drivers/net/bonding/bond_alb.c | 40 ++++++++++++++++++++++++++++++++--
>   1 file changed, 38 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
> index 533e476988f2..d9da6eb7f5c2 100644
> --- a/drivers/net/bonding/bond_alb.c
> +++ b/drivers/net/bonding/bond_alb.c
> @@ -1269,6 +1269,37 @@ static int alb_set_mac_address(struct bonding *bond, void *addr)
>   	return res;
>   }
>   
> +/* determine if the packet is NA or NS */
> +static bool __alb_determine_nd(struct icmp6hdr *hdr)
> +{
> +	if (hdr->icmp6_type == NDISC_NEIGHBOUR_ADVERTISEMENT ||
> +	    hdr->icmp6_type == NDISC_NEIGHBOUR_SOLICITATION) {
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +static bool alb_determine_nd(struct sk_buff *skb, struct bonding *bond)
> +{
> +	struct ipv6hdr *ip6hdr;
> +	struct icmp6hdr *hdr;
> +
> +	if (!pskb_network_may_pull(skb, sizeof(*ip6hdr)))
> +		return true;
> +
> +	ip6hdr = ipv6_hdr(skb);
> +	if (ip6hdr->nexthdr == IPPROTO_ICMPV6) {
> +		if (!pskb_may_pull(skb, sizeof(*ip6hdr) + sizeof(*hdr)))
> +			return true;
> +
> +		hdr = icmp6_hdr(skb);
> +		return __alb_determine_nd(hdr);
> +	}
> +
> +	return false;
> +}
> +
>   /************************ exported alb functions ************************/
>   
>   int bond_alb_initialize(struct bonding *bond, int rlb_enabled)
> @@ -1348,8 +1379,11 @@ struct slave *bond_xmit_tlb_slave_get(struct bonding *bond,
>   	/* Do not TX balance any multicast or broadcast */
>   	if (!is_multicast_ether_addr(eth_data->h_dest)) {
>   		switch (skb->protocol) {
> -		case htons(ETH_P_IP):
>   		case htons(ETH_P_IPV6):
> +			if (alb_determine_nd(skb, bond))
> +				break;
> +			fallthrough;
> +		case htons(ETH_P_IP):
>   			hash_index = bond_xmit_hash(bond, skb);
>   			if (bond->params.tlb_dynamic_lb) {
>   				tx_slave = tlb_choose_channel(bond,
> @@ -1432,10 +1466,12 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
>   			break;
>   		}
>   
> -		if (!pskb_network_may_pull(skb, sizeof(*ip6hdr))) {
> +		if (alb_determine_nd(skb, bond)) {
>   			do_tx_balance = false;
>   			break;
>   		}
> +
> +		/* The IPv6 header is pulled by alb_determine_nd */
>   		/* Additionally, DAD probes should not be tx-balanced as that
>   		 * will lead to false positives for duplicate addresses and
>   		 * prevent address configuration from working.
>
> base-commit: dd81e1c7d5fb126e5fbc5c9e334d7b3ec29a16a0
