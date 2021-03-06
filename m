Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6491E32FBB7
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 17:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbhCFQKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Mar 2021 11:10:34 -0500
Received: from mail-eopbgr50066.outbound.protection.outlook.com ([40.107.5.66]:43733
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231149AbhCFQKY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Mar 2021 11:10:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LsoenC1Gp8Ukc5cbCToNiXpB/Sb7UikvH2dKKlimrV4217y4hnN6LtxEQG8GhJkZFVJG+NdlUCArW8LJiraLlVeLxA7nWjPGkcSvLpMqA0Qjjm9231f6L4o6CXRElViHbFh8f3UkNiTsswlmw5VWn8RYwutSVSUT08PpWwuePX6lU5APMTdwst54j5A4MCFeE180I8nrlQUmkeokzgzKCspVKlSWM/pTQOKXy9lTDh0YS19y0MzbRM7vPwkJbi6PU/twcpHzltRaKcBlEcfbtuh9DK2B8a1d7yTPtuqJAV0xb920Y17bSJ4ZhK74w/ji/4MS6J+1mZzZJ1IE/toGBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fALgDFCcQgnLHvo612RbnoM6GmStnjOX/oPwFlNStmc=;
 b=bcU2BXCHrqzG4pkGv3o8UWcne5ksfW/WphQNkeKdN0d5nryV6pCha8X3PHsGCVfoEgJKR3wKrDoKWFmdyt9oXLrtMkZGnA6l0e0h6l6xrU4UyGcLcyvQwXcbAHnt7TKg9bA71eDgGAAIYiCkp4EhDXg3ZQ39wFsDfeLdHTbrlptmURAMnprqcftRSDxqLkwII9Q8lDQj89RqqxiUWJY4oI+VToCIvbYgJVV/Bxx3Hi9WLwvDDW8WPHT37hCfoGF2dRAiH50mcd0gHnAIkcjgiV/DlWQpLglKpdPCbmKTo1VYLKR7ITbag4hpNcixqS4E9xUSrCshKoL+k9Lzw3GAyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nextfour.com; dmarc=pass action=none header.from=nextfour.com;
 dkim=pass header.d=nextfour.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=NextfourGroupOy.onmicrosoft.com;
 s=selector2-NextfourGroupOy-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fALgDFCcQgnLHvo612RbnoM6GmStnjOX/oPwFlNStmc=;
 b=Rs/A1cVgDi20O3qm3v5AJtrw9Gai5KkGTOx5a3ISILDXjeMWVOBznpHQtljqJ4qCtkXVV6371x/0f5TrEAAJsRAQR6CLCdIcN+J1Srou6RhNT29gZS0UugTG5k/bnxOdPl6dTvS1E9+fDTrnZRTrHkdTetoM1JgWOhgBdPcxxYE=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nextfour.com;
Received: from DBAPR03MB6630.eurprd03.prod.outlook.com (2603:10a6:10:194::6)
 by DB7PR03MB3707.eurprd03.prod.outlook.com (2603:10a6:5:f::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3890.28; Sat, 6 Mar 2021 16:10:21 +0000
Received: from DBAPR03MB6630.eurprd03.prod.outlook.com
 ([fe80::708e:9058:61ae:cb9d]) by DBAPR03MB6630.eurprd03.prod.outlook.com
 ([fe80::708e:9058:61ae:cb9d%7]) with mapi id 15.20.3912.025; Sat, 6 Mar 2021
 16:10:21 +0000
Subject: Re: [PATCH net 3/9] netfilter: nf_nat: undo erroneous tcp edemux
 lookup
From:   =?UTF-8?Q?Mika_Penttil=c3=a4?= <mika.penttila@nextfour.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
References: <20210306121223.28711-1-pablo@netfilter.org>
 <20210306121223.28711-4-pablo@netfilter.org>
 <b0d7a77b-a33d-150c-65e2-6caebcec772f@nextfour.com>
Message-ID: <f0e7e495-522f-9916-9771-feac28baecdc@nextfour.com>
Date:   Sat, 6 Mar 2021 18:10:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <b0d7a77b-a33d-150c-65e2-6caebcec772f@nextfour.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [91.145.109.188]
X-ClientProxiedBy: HE1PR0102CA0004.eurprd01.prod.exchangelabs.com
 (2603:10a6:7:14::17) To DBAPR03MB6630.eurprd03.prod.outlook.com
 (2603:10a6:10:194::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.121] (91.145.109.188) by HE1PR0102CA0004.eurprd01.prod.exchangelabs.com (2603:10a6:7:14::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Sat, 6 Mar 2021 16:10:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23025fbf-e260-48c6-eff8-08d8e0ba579b
X-MS-TrafficTypeDiagnostic: DB7PR03MB3707:
X-Microsoft-Antispam-PRVS: <DB7PR03MB370771EB16A370EB333680A283959@DB7PR03MB3707.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vFRH6nMtQcRh1XZ9OppBdxwlaDLw8GsT4w6FdN9ePMQIqTdjUNXQmh9b3X5tpDTnGaYzuk2IjZQ4kxxYLJ4zvLbHPz6XwG1nPKR06yCMRwVNIvl3SArL9cqO8CsHQvByI+M2LPbS6JTE3Gl9SePxclOjfxExY6zUhMGdMqoQl+Y824l8/b9An89V7snWAt7CIY+MosORWKCAzjmdJO+HuFWUy172m6uAacnQcKdpJ4rP7HIlYTbpEAcfUeULk3WjWxEt/EYBYEvWzPyy5D8BMulm0OSCs4fj6xgqqGmBeUKlr+3V3JbsL2pBWE3yJfnReFHnbBuD1UYEsuAyl1RoZoJPF+Ti56z+eBiu56qxDAofbgd3fw/BaS8XIfnWhk4zF+2YfzTKZNQIpTJ/+L4R4HMd9uf2hzQV7AWMUHY8LRhtX4VhlqDsfoFjm7shg7jGjvHmhPr5/6WfbgfxOP6KZ8+JR+5GiG9X7WiGUTajD0tcEbAoapKg6XZzxeLOpo7deXNQtYAgu7H0twrKLsBImXYPMNwuSwKCtShebyXFip6PMR/uSfeoNhebfcvoTKQGdCDGH1+WLYhFyqHATN13wx5XcKrDYVv9jXZKAunmf4ONTIu+U9Z6Dgm3Cj76LKdqn8acOmmo8S0G0zgYok6JsdIeS09JAo1EDdyQtZUddGU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR03MB6630.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39830400003)(376002)(346002)(366004)(396003)(2906002)(5660300002)(31696002)(4326008)(66556008)(86362001)(66476007)(66946007)(8936002)(36756003)(6486002)(956004)(478600001)(31686004)(26005)(316002)(16576012)(83380400001)(16526019)(2616005)(8676002)(186003)(52116002)(966005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RjIreGRUOUhyWk94MGNicmcrQitRb3dXd1M1d2I2S2lyOGZ2YkRSNzdTeXNS?=
 =?utf-8?B?a0dyQkFNUlVmM0tleUg1UncyTEs5S3VzYzNTNENTODA3TmgvaFpwTlhEeG1G?=
 =?utf-8?B?WkV6aTE3T3NpK3RqeWJMVVZHRkJ4cEloNnBMVHBNTmJQZklBR0QzOHRTT0tE?=
 =?utf-8?B?WkJBUXV5bnZFd0hyb0JIY3dXcDNlNndtVTRZWWNjNEQvbEw5Y2QxM2hLWkhE?=
 =?utf-8?B?U0FLamxuaVorODFNSHVZUEJMbm42ajljSjdTS2FVTzZkb1BQazRYb0prRE40?=
 =?utf-8?B?NnJRTURiTy9SbUJZcEZvY2RQQ2VyVHlKZ2EvU1lqcnJyd1hBL2ZWRUt2SkJy?=
 =?utf-8?B?VmJTS21MRXJrVmZOdmtrNllDZ3RNYzdYWEFDd3IwcU5kVDhjWjBKVzdTTUhT?=
 =?utf-8?B?VUc3UjNwbWFzT0ZuMDVXc2dBWWpGamYxMFA4YTRrK2o4UVUyYmVyU1VqRCs3?=
 =?utf-8?B?MWwzSGM3ajgxSllkelBEd3FzUVI5VE95MElJbUdBUmdSamRyd3R6YktSdkJj?=
 =?utf-8?B?OWFGbHFqZWtrYklEVXJoUHhYVGZpc3d0TWdNTll3dWplbSsyNUc4aFc4aU1P?=
 =?utf-8?B?Wk41V0NRSHlMWDhJSjRwNGlJSU9LQjAweVVxdzUrcWlPRDBscWlBaGVDSHMw?=
 =?utf-8?B?UzFEZTROSkxSQlBBdVQybGpHaHkyd1RFRzN3OE9kRWpyZFZEZUxpQmNTZjlD?=
 =?utf-8?B?RVFVUUZQZ0o1aHYwc0oyU3FkRWkwSGR1dVBEOWp5aXFxOVFGVE5KeWpFZHJM?=
 =?utf-8?B?b2xSZmMzb3N2TDUzYURDRkcrL3ZuNUtSSWNUT1NFOG90Y1JWbC9jQzhQeW0y?=
 =?utf-8?B?QlE3cGFwVTBrMFZoQzZUanRCQjRycEVLQU4zalpzc2ZUTjR2RklGeWJrdmc3?=
 =?utf-8?B?Y3ZrT2pqYnNPOEMzWFBhS2NkWTFSSWlHdFNkSXZqdWpScllsQ3QwS0I3eTAy?=
 =?utf-8?B?M2ZpcUQ3TFpqenJSWjBhZTA5dlY4MVdObnBpVjhrajFrT1ZSNTMwMVhScytW?=
 =?utf-8?B?c0pTNHlRdXBjSzFjQUNUcldTZkRxNkduLzNVN1NuT1prTW03d1FncDRDOVc0?=
 =?utf-8?B?WHgvYUgwRkErb3FEbXl0c3lyNk5VWVR4bjdwR1NjTkxyYWROWTNrb1E0U0VN?=
 =?utf-8?B?d0x5YTFMbGR3RXJLNC9GVUZnMTB0MmRna3UrOG5kSDAwV2NqOStwMjRVWEIw?=
 =?utf-8?B?MzVRVVR6Qld4MFBFOERvVUR6SWNDd0I0cmp1bTZkZG9CNUFhNHNIZzNwWEdV?=
 =?utf-8?B?YkM4OWNCSmVCVzlWWk1sdWt6RGx5K1hKOFdBdE9FZmJaK29yRU5IMkl0QjdZ?=
 =?utf-8?B?ZDBneWR4RVJ3VmRYZUUyMmdXc2hjT3ZkTjkvV0VkZHQ1THpaemYwdmx6b3po?=
 =?utf-8?B?bTltRWxrdFExcWlWL2QzSW9oWTE5TmZ0WUx5NmxUUU51azQrbS9QSU5NQnM4?=
 =?utf-8?B?T0ZQclNGcWNjai82dS9Ia3VNVUpXTmdkd2VQRWltLzVkMG9ZYVhyMWxIakcx?=
 =?utf-8?B?c3FrZWpYOVV2ejNCS002NmV5VDBhZTljcVN4TWFUNFhmazNwZnNsRUhUSlA4?=
 =?utf-8?B?VEk2LzE1K3JYLzQ0eWMwU0dHMVo3VndFSW1DeWtlYStvNXpLZVMyQkxnQzBU?=
 =?utf-8?B?TmdUeDB4ejNyVFd6SFdjcktXQUozdnlzWGZUS2ZtT1EzQ21lVTUzOU5HOXhW?=
 =?utf-8?B?d0tCemRPbXNZanZmamppazZlOENBV2Q5WmF3cFFwaGhjOVBUSTVNc2tWeTlC?=
 =?utf-8?Q?JY3sKsotnTmOlgFKcRUmCCTpx9yVRyYOJr0zHBo?=
X-OriginatorOrg: nextfour.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23025fbf-e260-48c6-eff8-08d8e0ba579b
X-MS-Exchange-CrossTenant-AuthSource: DBAPR03MB6630.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2021 16:10:21.2874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 972e95c2-9290-4a02-8705-4014700ea294
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bmcPB6psLNkpe6LmpbZHNldJ2yw0PwyKkxOXa4bFDb6VGNb+DQfm/oeoj989pyXH86n9Gz8RBiKWwtsVzPdzV8izEfUI45Gai1yCI78UmgY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB3707
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6.3.2021 16.49, Mika Penttilä wrote:
>
>
> On 6.3.2021 14.12, Pablo Neira Ayuso wrote:
>> From: Florian Westphal <fw@strlen.de>
>>
>> Under extremely rare conditions TCP early demux will retrieve the wrong
>> socket.
>>
>> 1. local machine establishes a connection to a remote server, S, on port
>>     p.
>>
>>     This gives:
>>     laddr:lport -> S:p
>>     ... both in tcp and conntrack.
>>
>> 2. local machine establishes a connection to host H, on port p2.
>>     2a. TCP stack choses same laddr:lport, so we have
>>     laddr:lport -> H:p2 from TCP point of view.
>>     2b). There is a destination NAT rewrite in place, translating
>>          H:p2 to S:p.  This results in following conntrack entries:
>>
>>     I)  laddr:lport -> S:p  (origin)  S:p -> laddr:lport (reply)
>>     II) laddr:lport -> H:p2 (origin)  S:p -> laddr:lport2 (reply)
>>
>>     NAT engine has rewritten laddr:lport to laddr:lport2 to map
>>     the reply packet to the correct origin.
> Could you eloborate where and how linux nat engine is doing the
>
> laddr:lport to laddr:lport2
>
> rewrite? There's only DST nat and there should be conflict (for reply) 
> in tuple establishment afaik....

Ah I see it is the nat null binding for src to make it unique

>
>
>>
>>     When server sends SYN/ACK to laddr:lport2, the PREROUTING hook
>>     will undo-the SNAT transformation, rewriting IP header to
>>     S:p -> laddr:lport
>>
>>     This causes TCP early demux to associate the skb with the TCP socket
>>     of the first connection.
>>
>>     The INPUT hook will then reverse the DNAT transformation, rewriting
>>     the IP header to H:p2 -> laddr:lport.
>>
>> Because packet ends up with the wrong socket, the new connection
>> never completes: originator stays in SYN_SENT and conntrack entry
>> remains in SYN_RECV until timeout, and responder retransmits SYN/ACK
>> until it gives up.
>>
>> To resolve this, orphan the skb after the input rewrite:
>> Because the source IP address changed, the socket must be incorrect.
>> We can't move the DNAT undo to prerouting due to backwards
>> compatibility, doing so will make iptables/nftables rules to no longer
>> match the way they did.
>>
>> After orphan, the packet will be handed to the next protocol layer
>> (tcp, udp, ...) and that will repeat the socket lookup just like as if
>> early demux was disabled.
>>
>> Fixes: 41063e9dd1195 ("ipv4: Early TCP socket demux.")
>> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1427
>> Signed-off-by: Florian Westphal <fw@strlen.de>
>> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>> ---
>>   net/netfilter/nf_nat_proto.c | 25 +++++++++++++++++++++----
>>   1 file changed, 21 insertions(+), 4 deletions(-)
>>
>> diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
>> index e87b6bd6b3cd..4731d21fc3ad 100644
>> --- a/net/netfilter/nf_nat_proto.c
>> +++ b/net/netfilter/nf_nat_proto.c
>> @@ -646,8 +646,8 @@ nf_nat_ipv4_fn(void *priv, struct sk_buff *skb,
>>   }
>>     static unsigned int
>> -nf_nat_ipv4_in(void *priv, struct sk_buff *skb,
>> -           const struct nf_hook_state *state)
>> +nf_nat_ipv4_pre_routing(void *priv, struct sk_buff *skb,
>> +            const struct nf_hook_state *state)
>>   {
>>       unsigned int ret;
>>       __be32 daddr = ip_hdr(skb)->daddr;
>> @@ -659,6 +659,23 @@ nf_nat_ipv4_in(void *priv, struct sk_buff *skb,
>>       return ret;
>>   }
>>   +static unsigned int
>> +nf_nat_ipv4_local_in(void *priv, struct sk_buff *skb,
>> +             const struct nf_hook_state *state)
>> +{
>> +    __be32 saddr = ip_hdr(skb)->saddr;
>> +    struct sock *sk = skb->sk;
>> +    unsigned int ret;
>> +
>> +    ret = nf_nat_ipv4_fn(priv, skb, state);
>> +
>> +    if (ret == NF_ACCEPT && sk && saddr != ip_hdr(skb)->saddr &&
>> +        !inet_sk_transparent(sk))
>> +        skb_orphan(skb); /* TCP edemux obtained wrong socket */
>> +
>> +    return ret;
>> +}
>> +
>>   static unsigned int
>>   nf_nat_ipv4_out(void *priv, struct sk_buff *skb,
>>           const struct nf_hook_state *state)
>> @@ -736,7 +753,7 @@ nf_nat_ipv4_local_fn(void *priv, struct sk_buff 
>> *skb,
>>   static const struct nf_hook_ops nf_nat_ipv4_ops[] = {
>>       /* Before packet filtering, change destination */
>>       {
>> -        .hook        = nf_nat_ipv4_in,
>> +        .hook        = nf_nat_ipv4_pre_routing,
>>           .pf        = NFPROTO_IPV4,
>>           .hooknum    = NF_INET_PRE_ROUTING,
>>           .priority    = NF_IP_PRI_NAT_DST,
>> @@ -757,7 +774,7 @@ static const struct nf_hook_ops nf_nat_ipv4_ops[] 
>> = {
>>       },
>>       /* After packet filtering, change source */
>>       {
>> -        .hook        = nf_nat_ipv4_fn,
>> +        .hook        = nf_nat_ipv4_local_in,
>>           .pf        = NFPROTO_IPV4,
>>           .hooknum    = NF_INET_LOCAL_IN,
>>           .priority    = NF_IP_PRI_NAT_SRC,
>

