Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3148923F01A
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 17:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgHGPlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 11:41:07 -0400
Received: from mx.wizbit.be ([87.237.14.2]:58032 "EHLO mx.wizbit.be"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbgHGPlG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Aug 2020 11:41:06 -0400
Received: from [87.237.14.4] (87-237-14-7.powered-by.benesol.be [87.237.14.7])
        by wizbit.localdomain (Postfix) with ESMTP id 9CA206003;
        Fri,  7 Aug 2020 17:41:05 +0200 (CEST)
Message-ID: <5F2D7615.6090802@mail.wizbit.be>
Date:   Fri, 07 Aug 2020 17:41:09 +0200
From:   Bram Yvakh <bram-yvahk@mail.wizbit.be>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To:     sd@queasysnail.net
CC:     netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>, xmu@redhat.com
Subject: Re: [PATCH ipsec] xfrmi: drop ignore_df check before updating pmtu
References: <70e7c2a65afed5de117dbc16082def459bd39d93.1596531053.git.sd@queasysnail.net> <5F295578.4040004@mail.wizbit.be> <20200807144701.GC906370@bistromath.localdomain>
In-Reply-To: <20200807144701.GC906370@bistromath.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/08/2020 16:47, Sabrina Dubroca wrote:
> 2020-08-04, 14:32:56 +0200, Bram Yvakh wrote:
>   
>> On 4/08/2020 11:37, Sabrina Dubroca wrote:
>>     
>>> diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
>>> index b615729812e5..ade2eba863b3 100644
>>> --- a/net/xfrm/xfrm_interface.c
>>> +++ b/net/xfrm/xfrm_interface.c
>>> @@ -292,7 +292,7 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
>>>  	}
>>>  
>>>  	mtu = dst_mtu(dst);
>>> -	if (!skb->ignore_df && skb->len > mtu) {
>>> +	if (skb->len > mtu) {
>>>       
[snip]

>
> Yeah, it's the most simple xfrmi setup possible (directly connected by
> a veth),
Thanks, that gives me something to experiment with;
Could you you share what kernel your testing with? (i.e. what
tree/branch/sha)
> and just run ping on it. ping sets DF, we want an exception
> to be created, but this test prevents it.
>   
As I said dropping the test currently doesn't make sense to me.
I would expect that the 'ignore_df' flag is not set on the device, and
if it's set then I would expect things to work.


> The packet ends up being dropped in xfrm_output_one because of the mtu
> check in xfrm4_tunnel_check_size.
>   
That's the bit that does not (yet) make senes to me..
Looking at net-next/master (bfdd5aaa54b0a44d9df550fe4c9db7e1470a11b8)

||

	static int xfrm4_tunnel_check_size(struct sk_buff *skb)
	{
		int mtu, ret = 0;
	
		if (IPCB(skb)->flags & IPSKB_XFRM_TUNNEL_SIZE)
			goto out;
	
		if (!(ip_hdr(skb)->frag_off & htons(IP_DF)) || skb->ignore_df)
			goto out;
	
		mtu = dst_mtu(skb_dst(skb));
		if ((!skb_is_gso(skb) && skb->len > mtu) ||
		    (skb_is_gso(skb) &&
		     !skb_gso_validate_network_len(skb, ip_skb_dst_mtu(skb->sk, skb)))) {
			skb->protocol = htons(ETH_P_IP);
	
			if (skb->sk)
				xfrm_local_error(skb, mtu);
			else
				icmp_send(skb, ICMP_DEST_UNREACH,
					  ICMP_FRAG_NEEDED, htonl(mtu));
			ret = -EMSGSIZE;
		}
	out:
		return ret;
	}

*If* skb->ignore_df is set then it *skips* the mtu check.

In other words: 'xfrm4_tunnel_check_size' only cares about the mtu if ignore_df isn't set.
The original code in 'xfrmi_xmit2': only checks the mtu if ignore_df isn't set. (-> looks consistent)

With your patch: 'xfrmi_xmit2' now always checks the mtu whereas 'xfrm4_tunnel_check_size' only checks it when ignore_df isn't set.


