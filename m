Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 309A5185C20
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 12:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbgCOLB5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 15 Mar 2020 07:01:57 -0400
Received: from cmccmta3.chinamobile.com ([221.176.66.81]:9059 "EHLO
        cmccmta3.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728234AbgCOLB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 07:01:57 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.9]) by rmmx-syy-dmz-app12-12012 (RichMail) with SMTP id 2eec5e6e0b0862b-c9319; Sun, 15 Mar 2020 19:01:28 +0800 (CST)
X-RM-TRANSID: 2eec5e6e0b0862b-c9319
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from [10.0.0.249] (unknown[112.0.145.8])
        by rmsmtp-syy-appsvr05-12005 (RichMail) with SMTP id 2ee55e6e0b07b40-1577c;
        Sun, 15 Mar 2020 19:01:28 +0800 (CST)
X-RM-TRANSID: 2ee55e6e0b07b40-1577c
Content-Type: text/plain; charset=gb2312
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH] ipvs: optimize tunnel dumps for icmp errors
From:   Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
In-Reply-To: <alpine.LFD.2.21.2003151003190.3987@ja.home.ssi.bg>
Date:   Sun, 15 Mar 2020 19:01:26 +0800
Cc:     Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <B4979BD7-480A-43B3-B693-B7839FAF08D2@cmss.chinamobile.com>
References: <1584253087-8316-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
 <alpine.LFD.2.21.2003151003190.3987@ja.home.ssi.bg>
To:     Julian Anastasov <ja@ssi.bg>
X-Mailer: Apple Mail (2.3273)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On 2020年3月15日, at 下午4:17, Julian Anastasov <ja@ssi.bg> wrote:
> 
> 
> 	Hello,
> 
> On Sun, 15 Mar 2020, Haishuang Yan wrote:
> 
>> After strip GRE/UDP tunnel header for icmp errors, it's better to show
>> "ICMP for GRE/UDP" instead of "ICMP for IPIP" in debug message.
>> 
>> Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
>> ---
>> net/netfilter/ipvs/ip_vs_core.c | 41 +++++++++++++++++++++++------------------
>> 1 file changed, 23 insertions(+), 18 deletions(-)
>> 
>> diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
>> index 512259f..f39ae6b 100644
>> --- a/net/netfilter/ipvs/ip_vs_core.c
>> +++ b/net/netfilter/ipvs/ip_vs_core.c
> 
>> @@ -1703,8 +1707,8 @@ static int ipvs_gre_decap(struct netns_ipvs *ipvs, struct sk_buff *skb,
>> 		return NF_ACCEPT; /* The packet looks wrong, ignore */
>> 	raddr = (union nf_inet_addr *)&cih->daddr;
>> 
>> -	/* Special case for errors for IPIP packets */
>> -	ipip = false;
>> +	/* Special case for errors for IPIP/UDP/GRE tunnel packets */
>> +	tunnel = false;
> 
> 	At this point it is safe to store cih->protocol in some new
> var, eg. outer_proto...
> 
>> @@ -1809,17 +1813,18 @@ static int ipvs_gre_decap(struct netns_ipvs *ipvs, struct sk_buff *skb,
>> 			u32 mtu = ntohs(ic->un.frag.mtu);
>> 			__be16 frag_off = cih->frag_off;
>> 
>> -			/* Strip outer IP and ICMP, go to IPIP header */
>> +			/* Strip outer IP and ICMP, go to IPIP/UDP/GRE header */
>> 			if (pskb_pull(skb, ihl + sizeof(_icmph)) == NULL)
>> -				goto ignore_ipip;
>> +				goto ignore_tunnel;
>> 			offset2 -= ihl + sizeof(_icmph);
>> 			skb_reset_network_header(skb);
>> -			IP_VS_DBG(12, "ICMP for IPIP %pI4->%pI4: mtu=%u\n",
>> -				&ip_hdr(skb)->saddr, &ip_hdr(skb)->daddr, mtu);
>> +			IP_VS_DBG(12, "ICMP for %s %pI4->%pI4: mtu=%u\n",
>> +				  ip_vs_proto_name(cih->protocol),
> 
> 	Because here cih points to the embedded UDP/TCP/SCTP IP header, so
> we can not see GRE here. Or it is even better if we do not add more code 
> to ip_vs_proto_name(), just use char *outer_proto and assign it with 
> "IPIP" (where ipip was set) and "UDP"/"GRE" (where ulen was set) and print
> outer_proto here.
Yes, you’re right. I will send v2 commit according to your suggestion, thanks
very much.

> 
>> +				  &ip_hdr(skb)->saddr, &ip_hdr(skb)->daddr, mtu);
> 
> Regards
> 
> --
> Julian Anastasov <ja@ssi.bg>
> 



