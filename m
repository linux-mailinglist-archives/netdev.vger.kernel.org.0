Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A059240AD0
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 17:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbgHJPvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 11:51:51 -0400
Received: from mx.wizbit.be ([87.237.14.2]:38186 "EHLO mx.wizbit.be"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbgHJPvu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 11:51:50 -0400
Received: from [87.237.14.4] (87-237-14-7.powered-by.benesol.be [87.237.14.7])
        by wizbit.localdomain (Postfix) with ESMTP id BBF746003;
        Mon, 10 Aug 2020 17:51:48 +0200 (CEST)
Message-ID: <5F316D22.6080908@mail.wizbit.be>
Date:   Mon, 10 Aug 2020 17:52:02 +0200
From:   Bram Yvakh <bram-yvahk@mail.wizbit.be>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>, xmu@redhat.com
Subject: Re: [PATCH ipsec] xfrmi: drop ignore_df check before updating pmtu
References: <70e7c2a65afed5de117dbc16082def459bd39d93.1596531053.git.sd@queasysnail.net> <5F295578.4040004@mail.wizbit.be> <20200807144701.GC906370@bistromath.localdomain> <5F2D7615.6090802@mail.wizbit.be> <20200810122020.GA1128331@bistromath.localdomain>
In-Reply-To: <20200810122020.GA1128331@bistromath.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>>> and just run ping on it. ping sets DF, we want an exception
>>> to be created, but this test prevents it.
>>>   
>>>       
>> As I said dropping the test currently doesn't make sense to me.
>> I would expect that the 'ignore_df' flag is not set on the device, and
>> if it's set then I would expect things to work.
>>     
>
> ignore_df is a property of the packet (skb), not of the device. Only
> gre tunnels have an ignore_df property, not vti or xfrmi.
>   
Correct, I noticed my 'typo' after mail was submitted.

>>> The packet ends up being dropped in xfrm_output_one because of the mtu
>>> check in xfrm4_tunnel_check_size.
>>>   
>>>       
>> That's the bit that does not (yet) make senes to me..
>> Looking at net-next/master (bfdd5aaa54b0a44d9df550fe4c9db7e1470a11b8)
>>
>> ||
>>
>> 	static int xfrm4_tunnel_check_size(struct sk_buff *skb)
>> 	{
>> 		int mtu, ret = 0;
>> 	
>> 		if (IPCB(skb)->flags & IPSKB_XFRM_TUNNEL_SIZE)
>> 			goto out;
>> 	
>> 		if (!(ip_hdr(skb)->frag_off & htons(IP_DF)) || skb->ignore_df)
>> 			goto out;
>> 	
>> 		mtu = dst_mtu(skb_dst(skb));
>> 		if ((!skb_is_gso(skb) && skb->len > mtu) ||
>> 		    (skb_is_gso(skb) &&
>> 		     !skb_gso_validate_network_len(skb, ip_skb_dst_mtu(skb->sk, skb)))) {
>> 			skb->protocol = htons(ETH_P_IP);
>> 	
>> 			if (skb->sk)
>> 				xfrm_local_error(skb, mtu);
>> 			else
>> 				icmp_send(skb, ICMP_DEST_UNREACH,
>> 					  ICMP_FRAG_NEEDED, htonl(mtu));
>> 			ret = -EMSGSIZE;
>> 		}
>> 	out:
>> 		return ret;
>> 	}
>>
>> *If* skb->ignore_df is set then it *skips* the mtu check.
>>     
>
> If the packet doesn't have the DF bit set (so the stack can fragment
> the packet at will), or if the stack decided that it can ignore it and
> fragment anyway, there's no need to check the mtu, because we'll
> fragment the packet when we need. Otherwise, we're not allowed to
> fragment, so we have to check the packet's size against the mtu.
>   
Agreed.
>   
>> In other words: 'xfrm4_tunnel_check_size' only cares about the mtu if ignore_df isn't set.
>> The original code in 'xfrmi_xmit2': only checks the mtu if ignore_df isn't set. (-> looks consistent)
>>     
>
> Except that we reset skb->ignore_df in between (just after the mtu
> handling in xfrmi_xmit2, via xfrmi_scrub_packet).
>   
Thanks, that's a bit that was not clear to me;
> Why should we care about whether we can fragment the packet that's
> being transmitted over a tunnel? We're not fragmenting it, we're going
> to encapsulate it inside another IP header, and then we'll have to
> fragment that outer IP packet.
>   
Agreed, but then it makes a bit less sense to be.
If we don't care if we can fragment the packet then why are we checking
the packet size?

Also, assume:
- ignore_df is set on the skb
- packet size is > mtu

Then with your patch applied the code will now send
ICMP_FRAG_NEEDED/ICMPV6_PKT_TOOBIG icmp which to me doesn't make sense
since the stack decided that the packet can be fragmented.
So in what case would in then be appropriate to send the
ICMP_FPRAG_NEEDED to the client? (which is very likely not expecting a
ICMP_FRAG_NEEDED icmp)
But thinking about it some more: I would also expect to see the
'(ip_hdr(skb)->frag_off & htons(IP_DF))' check... (because again: if the
packet says it's ok to fragment then it will not expect/handle a
ICMP_FRAG_NEEDED icmp)

(And a side-note: as to why would we care about fragmentation when we're
going to encapsulate it? *I* wouldn't care but last time I tried to
raise an issue/patch with failing to encapsulate IPv6 in IPv6 (with
xfrm) when pmtu is 1280 (min IPv6 mtu)  I was mostly ignored)

