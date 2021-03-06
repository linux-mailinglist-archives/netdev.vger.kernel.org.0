Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 054CE32FB3F
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 15:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhCFOt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Mar 2021 09:49:28 -0500
Received: from mail-am6eur05on2081.outbound.protection.outlook.com ([40.107.22.81]:26752
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230429AbhCFOtZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Mar 2021 09:49:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SkcZ1sAcAwtcRJEfZTa2hL53NdT7/3pln2kKQB4+J2H+yx/8HnBRsgXN8KQcZJuQv9cULjjwsNj129sbDJo/4KTZMgc2Cm6ktthuiPtJABVtxQCRXUMXICJo+s0rJt7rK17UXi09SuFw/N0VM46f9lONTkgGK3wH6de9EbJfEg7scyi5dbVpuAfkKqBg2wxSpps1vAabEyXY0UPZQIbUl3KZ6ha10z/+jUBtLCltqsi1BacJoZdEoAt81Tl0GI1Cncz4Opi9OKRiPAzmNSCsmAjMwRmcghPVBeqCUd3idFVmLhNKIuzv5rvnOkzGbbemCnFvaavaDqM23Ez0d7LQnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TmBygUKs4nDWCelkFUNvW2RDDl20Of+c7mpTodOysIg=;
 b=GVw1Ilv02vI99aY0/UNBn9G37ijUOpZOhg4IkZh7wprLBnyjuOHLaCXYbvGkM46AnXP9UKUitQASjEkkXlCx9LAynjtgQTc/5IMp+IJFj62VCmfKgfNaMebBehIA5fcEBod6FHM7/JKHp7+rusawlGWcXTNXsqe7MQJ4p8oniPY5rBRgInaqmdHx4fznG7z8Wd3KhIcJwgyllhWdw8o7UU0jtamcBfrFOZBcVimUCkx6QuL4hdFCkBvWaUPhpkxvBhbLnPAxVrYYUWrjT33WYPWi7cqEsG4G5OmbheXSSW14mmPFY/BUY/c1L4OIr2zSVrzy/+l05DxmWhpipXxvaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nextfour.com; dmarc=pass action=none header.from=nextfour.com;
 dkim=pass header.d=nextfour.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=NextfourGroupOy.onmicrosoft.com;
 s=selector2-NextfourGroupOy-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TmBygUKs4nDWCelkFUNvW2RDDl20Of+c7mpTodOysIg=;
 b=EYlTklpVGW1rU9VM3ti+13bNGxoUJrxnHhR+g9uEb0uJWqN3zmg5RH4sTj2Fnat8sAOhYwQ7eog/N8MNs/+C+HA5Yoo2E1KiPbiVEyQgN/qaX5p4NetMBhhM+X4ONYDmqpE5TiutOvHE/e3lSzQ2XeDcFYEZxATzRw8cNc+VQyo=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nextfour.com;
Received: from DBAPR03MB6630.eurprd03.prod.outlook.com (2603:10a6:10:194::6)
 by DB7PR03MB4027.eurprd03.prod.outlook.com (2603:10a6:5:3b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Sat, 6 Mar
 2021 14:49:22 +0000
Received: from DBAPR03MB6630.eurprd03.prod.outlook.com
 ([fe80::708e:9058:61ae:cb9d]) by DBAPR03MB6630.eurprd03.prod.outlook.com
 ([fe80::708e:9058:61ae:cb9d%7]) with mapi id 15.20.3912.025; Sat, 6 Mar 2021
 14:49:22 +0000
Subject: Re: [PATCH net 3/9] netfilter: nf_nat: undo erroneous tcp edemux
 lookup
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
References: <20210306121223.28711-1-pablo@netfilter.org>
 <20210306121223.28711-4-pablo@netfilter.org>
From:   =?UTF-8?Q?Mika_Penttil=c3=a4?= <mika.penttila@nextfour.com>
Message-ID: <b0d7a77b-a33d-150c-65e2-6caebcec772f@nextfour.com>
Date:   Sat, 6 Mar 2021 16:49:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210306121223.28711-4-pablo@netfilter.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [91.145.109.188]
X-ClientProxiedBy: HE1PR0901CA0065.eurprd09.prod.outlook.com
 (2603:10a6:3:45::33) To DBAPR03MB6630.eurprd03.prod.outlook.com
 (2603:10a6:10:194::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.121] (91.145.109.188) by HE1PR0901CA0065.eurprd09.prod.outlook.com (2603:10a6:3:45::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Sat, 6 Mar 2021 14:49:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4cdab371-1c89-4a85-a0a3-08d8e0af0795
X-MS-TrafficTypeDiagnostic: DB7PR03MB4027:
X-Microsoft-Antispam-PRVS: <DB7PR03MB4027B72A237F5FA68DE9EBF283959@DB7PR03MB4027.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yr0VznsDHQIEzAKd5XD2vk1w2tetsYHrsHJW9IyUfGqGd24T4QomcqdBbaV9jNS/6naV9IAQ3HQyW6afhOsxIbNvjFh4XgGSpgdG/DFNFlVBifTk/xLZG7XjhpyKyS3jbANSLZJ6bJgJxIiZg395tNkHB1eufdgom1vNWrRVy4ltRcsm/SPdYheuXC8+rGNe8n+7BPkJg/BnV8nZhj2BVGEgc6WDiJ6RLfJyZQLYONaZz56+Z2vYxl3rKUKLkf5ZRg1diRGxQpsTUuwHpy++YAwFJLSsLlu38Buv1daS6khuPBWeqrLNhuL+9M1pprDYLBKgu3bo+AxmAJh3lK2xE3zftMyVwEWpECVrgsSjnBdcsX7xTJwmwTgx/aHexz8RMzza8lOig3xLE2hwBryQdQTbzhOxou1G9mKFH6qxQ1gh3LetQJq0dk0x9K8PiLds51YjDRWEBsO32ZHdsVH03MTAwy0X4RIjsi49lGJgEyNZjcPgagaEe6nn6laidyCGOvwLhSSkei4NEjimvKS1EDosLluzeRnC515jGxGyyVynC8sjJO01xyGigl2eaavfMm42rfV5EjfgXKSaXJIPeVzwYd9HAPEonhDGNcCtyRVMWzkDyRVOlLhtvemnJcb14oYdgRsPrFpJAgG10KsGaHBpNVHRyXEoO4Sz+sIykPgfEUmXxiOTjsbll6eoyIG1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR03MB6630.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(396003)(39830400003)(366004)(376002)(16576012)(2616005)(956004)(478600001)(8936002)(4326008)(52116002)(31686004)(66556008)(6666004)(36756003)(6486002)(8676002)(316002)(66946007)(86362001)(16526019)(5660300002)(966005)(31696002)(66476007)(2906002)(83380400001)(26005)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?T0VuS1gxS3YyQzAwR1RzWUJMV3lrVWV5dXFKL1VyUE9zTHdYQjBHY3pFMXd4?=
 =?utf-8?B?Y2hjMjBRazBYcVlFdS9KYnAyK0ZuWHZkL3JIVDhVUEZrUHV3M2U1Uk1PcXkr?=
 =?utf-8?B?QWphZGIxQ2gzQ0NzSVBOMEl3cFZ3S1FGNlI3SXY5Wk9UL3ZTTms1ODJtbHNW?=
 =?utf-8?B?VzNMY2RoUEdtek9IUlAwTitLNm9SbHJnVWdwU3dXMzBxOXRmL29KNWFZaWVh?=
 =?utf-8?B?Qm9NL3hicWxuR3EwOWVCNUdVNTFDUDdHc2RTa2ZsUDRKa0RkdURZbGk4UW0x?=
 =?utf-8?B?S3VHVXpHY2tuRjczRFp0dThsQnNqN2NQTnM0Z1VLVVlTMjlDdWdqdjR3K1ND?=
 =?utf-8?B?SEFqOGNaNlpsSlBzZVNyemx3U2xxQlgyZjZUdDB1TjVzaEtVM25ZeTlxbzg0?=
 =?utf-8?B?d2NmQ25aL1hsUVYzSUpmZ1Y1NVE1RS9ZY1phVWhJT1lxckdxakxvL2RxWUs4?=
 =?utf-8?B?c1R4TWJlYnlEVmxjeWZ1K2J5ZEVwc29lWUFyS2pCVWkwSngwNWVTd1BBOTJj?=
 =?utf-8?B?QVJzR2w2ZUY1eVE5cEJ6SXJrVXd1QXJVN1ZjTnZCNUpQQUpQcFVQejQvS0o2?=
 =?utf-8?B?VHZsbUhBaEsyeERCWGtqOXl1SFlPcHQrVUc1OFFLaFg4MzcrTFpzRmdTTm9S?=
 =?utf-8?B?OGJ6c1MrYytmSTRQbzByS1ZheGxBTzR4VG9pdzl1dUNyanRLRlo4UnZXTDgx?=
 =?utf-8?B?QURlbGI3a2pjR0RUZ3FmZHREamJJSDdOV2RqZENFMzcxZ0tuOUVDeExOd1RD?=
 =?utf-8?B?RUJBdGtGb21jN1NyS3hDbU53OXdFN08xVmpza2Z2bFFOa0JlSmZxbGcyV3kr?=
 =?utf-8?B?L055aEovRlZ0YWZIdGhIcFU5M0lQODg2ZVFWTWFPLzBIaGliU0tGZWFMa0RR?=
 =?utf-8?B?R2g3c0xNY2hEQlpqTll4QloyaUZNSjlOY3Q0Tm8vTkpBUGRaZVJ3QS9MMjRo?=
 =?utf-8?B?dFl5dWhpdkdzK3ZlbGtGMVNvcXlVK1Iwd1ZBd0tGb3dqaVFPY2E0S1FJVUJH?=
 =?utf-8?B?YjJQU3hENFpnbERESTdmbjlNNk04Y2NlTVF4UXZKb3NWdmVBeVNmRWNZTU1S?=
 =?utf-8?B?YmRla3NGZUVVU01iWTRhdklzQU5XL1o1b2x4eVQ0M2RydWNaN203VlJJNEN1?=
 =?utf-8?B?MUYwSWtQbGxhU1RKY2t1ajQvQ0M4Mm53aEVhTWdiSllhWlREQVNmM1lSbkoy?=
 =?utf-8?B?aW9iL3YxekxRSkZ4dHFWeHk0Q3JrM1hLUmhQRTlsLy9NMXQ1RjV5MUdKbXFQ?=
 =?utf-8?B?T3RQOExFNTJuWklJdlFneE05SURKQnYrRzhQWmlFeGVNdi9qcTd1KzdlK29a?=
 =?utf-8?B?N0dLOTluKzJCWm5GaWdvS2NYbHRONFdTS0NUQncrajJNQWw1Q2NJRlhKOTY2?=
 =?utf-8?B?bFdsS2hlU21zRCtsYkNQckdpWUVKajBNSXJwUmNhamcyUTBpZDJzdDRwMzZu?=
 =?utf-8?B?TlI5Z3hmczJ5bzI0dXRkTkg5RXo4VjYxdjg0dFkwRzVnYUo4UHNVNGZlZGs0?=
 =?utf-8?B?ZFplWEhPcW5ZTG14eE9YTm93akZjdytWNWFNZ3hDQW5vNkxWSnY2SGNjMGJx?=
 =?utf-8?B?RE4wVGNFNUcyQTJQMzVZVFY3MUs0Qkg2ZVBEUEQ1YittdjdOekZ2aTRSSEtC?=
 =?utf-8?B?NHMwYWhqSXBvdlBEd3NIdnVwV2Z6ckZzeWJheXoxd05hODU5a0V2ZjFRUFg3?=
 =?utf-8?B?V3RyZHlENzhsMWwxd2d2RGFIY1B6YStRL3lHV2hpdWc0YnhwZGdLZUd3OHFT?=
 =?utf-8?Q?YNNuKT1bsqH4+Oteg0AmAKDeHeuuzMENrdcJJLO?=
X-OriginatorOrg: nextfour.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cdab371-1c89-4a85-a0a3-08d8e0af0795
X-MS-Exchange-CrossTenant-AuthSource: DBAPR03MB6630.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2021 14:49:22.7664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 972e95c2-9290-4a02-8705-4014700ea294
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rAqGoRnExRn7O1QZc2D8CY6he3tj5TKbLZLO05JyRzaYLkO0Y4hNkYDQM0IQVVg54k7K9xcwpzbl1FdLrHTuxuJmmnOZG5fuylORS9frM8s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4027
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6.3.2021 14.12, Pablo Neira Ayuso wrote:
> From: Florian Westphal <fw@strlen.de>
>
> Under extremely rare conditions TCP early demux will retrieve the wrong
> socket.
>
> 1. local machine establishes a connection to a remote server, S, on port
>     p.
>
>     This gives:
>     laddr:lport -> S:p
>     ... both in tcp and conntrack.
>
> 2. local machine establishes a connection to host H, on port p2.
>     2a. TCP stack choses same laddr:lport, so we have
>     laddr:lport -> H:p2 from TCP point of view.
>     2b). There is a destination NAT rewrite in place, translating
>          H:p2 to S:p.  This results in following conntrack entries:
>
>     I)  laddr:lport -> S:p  (origin)  S:p -> laddr:lport (reply)
>     II) laddr:lport -> H:p2 (origin)  S:p -> laddr:lport2 (reply)
>
>     NAT engine has rewritten laddr:lport to laddr:lport2 to map
>     the reply packet to the correct origin.
Could you eloborate where and how linux nat engine is doing the

laddr:lport to laddr:lport2

rewrite? There's only DST nat and there should be conflict (for reply) 
in tuple establishment afaik....


>
>     When server sends SYN/ACK to laddr:lport2, the PREROUTING hook
>     will undo-the SNAT transformation, rewriting IP header to
>     S:p -> laddr:lport
>
>     This causes TCP early demux to associate the skb with the TCP socket
>     of the first connection.
>
>     The INPUT hook will then reverse the DNAT transformation, rewriting
>     the IP header to H:p2 -> laddr:lport.
>
> Because packet ends up with the wrong socket, the new connection
> never completes: originator stays in SYN_SENT and conntrack entry
> remains in SYN_RECV until timeout, and responder retransmits SYN/ACK
> until it gives up.
>
> To resolve this, orphan the skb after the input rewrite:
> Because the source IP address changed, the socket must be incorrect.
> We can't move the DNAT undo to prerouting due to backwards
> compatibility, doing so will make iptables/nftables rules to no longer
> match the way they did.
>
> After orphan, the packet will be handed to the next protocol layer
> (tcp, udp, ...) and that will repeat the socket lookup just like as if
> early demux was disabled.
>
> Fixes: 41063e9dd1195 ("ipv4: Early TCP socket demux.")
> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1427
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>   net/netfilter/nf_nat_proto.c | 25 +++++++++++++++++++++----
>   1 file changed, 21 insertions(+), 4 deletions(-)
>
> diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
> index e87b6bd6b3cd..4731d21fc3ad 100644
> --- a/net/netfilter/nf_nat_proto.c
> +++ b/net/netfilter/nf_nat_proto.c
> @@ -646,8 +646,8 @@ nf_nat_ipv4_fn(void *priv, struct sk_buff *skb,
>   }
>   
>   static unsigned int
> -nf_nat_ipv4_in(void *priv, struct sk_buff *skb,
> -	       const struct nf_hook_state *state)
> +nf_nat_ipv4_pre_routing(void *priv, struct sk_buff *skb,
> +			const struct nf_hook_state *state)
>   {
>   	unsigned int ret;
>   	__be32 daddr = ip_hdr(skb)->daddr;
> @@ -659,6 +659,23 @@ nf_nat_ipv4_in(void *priv, struct sk_buff *skb,
>   	return ret;
>   }
>   
> +static unsigned int
> +nf_nat_ipv4_local_in(void *priv, struct sk_buff *skb,
> +		     const struct nf_hook_state *state)
> +{
> +	__be32 saddr = ip_hdr(skb)->saddr;
> +	struct sock *sk = skb->sk;
> +	unsigned int ret;
> +
> +	ret = nf_nat_ipv4_fn(priv, skb, state);
> +
> +	if (ret == NF_ACCEPT && sk && saddr != ip_hdr(skb)->saddr &&
> +	    !inet_sk_transparent(sk))
> +		skb_orphan(skb); /* TCP edemux obtained wrong socket */
> +
> +	return ret;
> +}
> +
>   static unsigned int
>   nf_nat_ipv4_out(void *priv, struct sk_buff *skb,
>   		const struct nf_hook_state *state)
> @@ -736,7 +753,7 @@ nf_nat_ipv4_local_fn(void *priv, struct sk_buff *skb,
>   static const struct nf_hook_ops nf_nat_ipv4_ops[] = {
>   	/* Before packet filtering, change destination */
>   	{
> -		.hook		= nf_nat_ipv4_in,
> +		.hook		= nf_nat_ipv4_pre_routing,
>   		.pf		= NFPROTO_IPV4,
>   		.hooknum	= NF_INET_PRE_ROUTING,
>   		.priority	= NF_IP_PRI_NAT_DST,
> @@ -757,7 +774,7 @@ static const struct nf_hook_ops nf_nat_ipv4_ops[] = {
>   	},
>   	/* After packet filtering, change source */
>   	{
> -		.hook		= nf_nat_ipv4_fn,
> +		.hook		= nf_nat_ipv4_local_in,
>   		.pf		= NFPROTO_IPV4,
>   		.hooknum	= NF_INET_LOCAL_IN,
>   		.priority	= NF_IP_PRI_NAT_SRC,

