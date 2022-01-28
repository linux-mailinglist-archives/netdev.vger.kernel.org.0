Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7B349F89F
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 12:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348197AbiA1LqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 06:46:19 -0500
Received: from prt-mail.chinatelecom.cn ([42.123.76.227]:48082 "EHLO
        chinatelecom.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S237302AbiA1LqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 06:46:19 -0500
HMM_SOURCE_IP: 172.18.0.48:42312.634890243
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-112.38.63.33 (unknown [172.18.0.48])
        by chinatelecom.cn (HERMES) with SMTP id 38D2928008D;
        Fri, 28 Jan 2022 19:46:06 +0800 (CST)
X-189-SAVE-TO-SEND: sunshouxin@chinatelecom.cn
Received: from  ([172.18.0.48])
        by app0024 with ESMTP id e97e0b239a5d42dd90dd67afb5d394c4 for kuba@kernel.org;
        Fri, 28 Jan 2022 19:46:12 CST
X-Transaction-ID: e97e0b239a5d42dd90dd67afb5d394c4
X-Real-From: sunshouxin@chinatelecom.cn
X-Receive-IP: 172.18.0.48
X-MEDUSA-Status: 0
Sender: sunshouxin@chinatelecom.cn
Message-ID: <85c5f9d7-ac78-509e-a1c4-4cb86544f423@chinatelecom.cn>
Date:   Fri, 28 Jan 2022 19:46:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v10] net: bonding: Add support for IPV6 ns/na to
 balance-alb/balance-tlb mode
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jay.vosburgh@canonical.com,
        nikolay@nvidia.com, huyd12@chinatelecom.cn
References: <20220125142418.96167-1-sunshouxin@chinatelecom.cn>
 <20220127184722.60cdb806@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   =?UTF-8?B?5a2Z5a6I6ZGr?= <sunshouxin@chinatelecom.cn>
In-Reply-To: <20220127184722.60cdb806@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Thanks your comment, I'll adjust it and send out v11 soon.


在 2022/1/28 10:47, Jakub Kicinski 写道:
> On Tue, 25 Jan 2022 09:24:18 -0500 Sun Shouxin wrote:
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
>> +	if (!pskb_network_may_pull(skb, sizeof(*ip6hdr)))
>> +		return true;
>> +
>> +	ip6hdr = ipv6_hdr(skb);
>> +	if (ip6hdr->nexthdr == IPPROTO_ICMPV6) {
> 	if (ip6hdr->nexthdr != IPPROTO_ICMPV6)
> 		return false;
>
> This way there's no need to indent the rest of the function.
>
>> +		if (!pskb_may_pull(skb, sizeof(*ip6hdr) + sizeof(*hdr)))
> What happened to the _network part? pskb_network_may_pull(), right?
>
>> +			return true;
>> +
>> +		hdr = icmp6_hdr(skb);
>> +		return __alb_determine_nd(hdr);
> Why create a full helper for this condition? Why not just:
>
> 	return hdr->icmp6_type == NDISC_NEIGHBOUR_ADVERTISEMENT ||
> 	       hdr->icmp6_type == NDISC_NEIGHBOUR_SOLICITATION;
>
>
>> +	}
>> +
>> +	return false;
>> +}
