Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 359BB17782A
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 15:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbgCCODo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 09:03:44 -0500
Received: from mail-am6eur05on2073.outbound.protection.outlook.com ([40.107.22.73]:6088
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726899AbgCCODn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 09:03:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AOAnxQ5UJJT2F1gIPbQ3KO3aWT1XG+ii8b5r/Loc8cl3YvRJAH4BFiovIq+bHbQ8b2UkMNXgzJd4MU+x6o90QQpp5+v+WoE2UGZdYr02ll0JwEyesJTZFac2h4He4uDFgpdLCdvB9kw9TMtWuBnA+cbEiznw1uP1FgdxkEJaO7UU5V48A860Yj0tZaigegyj6i76pBeJyrzUIfxAOeHzpeMIEhc64s/5EX4hh7x+orK4gd0P66yjzQydVOB6DPmkmA3GIDMACIj/GVO6JwJ+344OA50R0N8RkI8h4MNoHCQ4IIVp4PiksBZ179VqSYDLPjCjz6rsHl1nnjuaJPyMJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=66cAsYgYThsB5Y+JckMD/SrinrjkGN0+7bw0tBptFf8=;
 b=BBmiVen9j0dpjGvcdwxt/u1lzJ2VHrK1eDSlJrPF2aHzMWPe8BwOcJZDIKVhoHjNtgIokyteAKzIrauobm3IAa0lzuuGJuFRhsUU3qAligCmSWcrjQuZ/eyEEh1pEdDOtQ1Y8vNN5khpRTzKXP2/wToGVSBefU/3ZS9A4A2Qk1lJUnf8WlRKVPlntuLGeubZWuPQajKGCCQ1FgyvwQkkFYI9XZ2A4A2/w7+EOhsK66/NcfezpbjYaGe14h9ZTN86/ugTY6Bqh0pWsQxuRIEUOYvb97HmGa6n4lVjdGQtCKJQ1loeZbBjj4doQ4HqCmIu9PtYUnbMRN56K0e/Ah0JdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=66cAsYgYThsB5Y+JckMD/SrinrjkGN0+7bw0tBptFf8=;
 b=oAeu4NKKfnISmT6GvOgsKBbNlOR+9EPXlw8QdPSotG8X/IwzFgTqqch6KazpJ0k/f68FxlmWDp2bW87ydDkiXeftXVwLXXCrcqGk/zA9UcVRNeqdZxOxLcASpOOV9yIU14XJ1la/VUizmDlnNQItiFehasK1InB5Wfz8geaFO3w=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (20.177.36.78) by
 AM6PR05MB5973.eurprd05.prod.outlook.com (20.179.3.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.19; Tue, 3 Mar 2020 14:03:38 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4%7]) with mapi id 15.20.2772.019; Tue, 3 Mar 2020
 14:03:38 +0000
Subject: Re: [PATCH net-next v3 3/3] net/sched: act_ct: Software offload of
 established flows
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
References: <1583239973-3728-1-git-send-email-paulb@mellanox.com>
 <1583239973-3728-4-git-send-email-paulb@mellanox.com>
 <3f174fcb-0636-22d2-8d1c-e0e4981aab95@cumulusnetworks.com>
 <5cfe38ec-fd47-1846-fe84-433df3554a1b@mellanox.com>
 <0ecf03a9-a8f2-afd5-d9a2-a222cc1070d3@cumulusnetworks.com>
From:   Paul Blakey <paulb@mellanox.com>
Message-ID: <c2680b0e-b4c9-9185-523e-9117e2ae79e8@mellanox.com>
Date:   Tue, 3 Mar 2020 16:03:33 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <0ecf03a9-a8f2-afd5-d9a2-a222cc1070d3@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR01CA0135.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::40) To AM6PR05MB5096.eurprd05.prod.outlook.com
 (2603:10a6:20b:11::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.223.6.3] (193.47.165.251) by AM0PR01CA0135.eurprd01.prod.exchangelabs.com (2603:10a6:208:168::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15 via Frontend Transport; Tue, 3 Mar 2020 14:03:36 +0000
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6b184047-5910-429d-327e-08d7bf7babc0
X-MS-TrafficTypeDiagnostic: AM6PR05MB5973:|AM6PR05MB5973:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB59737A784FBB86C98E846A70CFE40@AM6PR05MB5973.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:137;
X-Forefront-PRVS: 03319F6FEF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(136003)(39860400002)(396003)(346002)(189003)(199004)(16576012)(81156014)(8676002)(81166006)(53546011)(956004)(66946007)(16526019)(66476007)(66556008)(2616005)(110136005)(26005)(52116002)(186003)(31696002)(6636002)(86362001)(6486002)(6666004)(31686004)(2906002)(5660300002)(8936002)(36756003)(316002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5973;H:AM6PR05MB5096.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N4QuSh0gpzEOkYvc506jBGTLaGaGCB/OKwI7XsYpqGmk6/85tifKvkEdFPL4SOXoI69rSAx74sZoetDlwJxRR/jj4Kmjv6qftkFxzyBorQJrzU5HyipwQOJQ7gt3iuqNmr4SlZNr39l38Bvck8O4gl9/C3rJvqHgdWb4n0k7QghYkYGCiJ0O2REzIkX7dn89pIPNqF1Z9xAtR+cwYwCo2yw+mzYumOVrl00vuyMV5qVylXmqDFHzlGOWNn/bmpClUfkwhlN09Y1Jou8LiN7klqIhugah1JtEpfg+7K/2hZ7zKK8QPqtOqAv06AA+75v0vTQoGFpYEhYMQ6E8WOT9+BkrXRx3ABw7Pgo3Zd4nsQ083396P0RKiWHFu0smCP5eB4WnX0c3gP1ycUEIRokIoWCLcN7hNzX+jeuw8PgPEAN5p529t6c4XTSxZMDGc4gt
X-MS-Exchange-AntiSpam-MessageData: B9tQqctzP/iK6ZbL/O7NBvp/3YV+/5XEWbBFb4FroYZID4pzcSewr9IY+BBnszvkEO7JW+c+fwpeM7RM2Ru2lcYHt8VHPo8RLuGy1A4bem5KAk+G3cOX5etsy+Gj3W5fe2H0PS1AlIQChdhpyAWUyQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b184047-5910-429d-327e-08d7bf7babc0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2020 14:03:38.1705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D4HM0xATMjvZ4+IMza/4xH7eGCDZlyJ7hr/9YqVjkga2KkHa28kRoId++vtfiuOFVwWw7XzBUnzsWaqYLkF3Nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5973
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/3/2020 3:35 PM, Nikolay Aleksandrov wrote:
> On 03/03/2020 15:31, Paul Blakey wrote:
>> On 3/3/2020 3:10 PM, Nikolay Aleksandrov wrote:
>>> On 03/03/2020 14:52, Paul Blakey wrote:
>>>> Offload nf conntrack processing by looking up the 5-tuple in the
>>>> zone's flow table.
>>>>
>>>> The nf conntrack module will process the packets until a connection is
>>>> in established state. Once in established state, the ct state pointer
>>>> (nf_conn) will be restored on the skb from a successful ft lookup.
>>>>
>>>> Signed-off-by: Paul Blakey <paulb@mellanox.com>
>>>> Acked-by: Jiri Pirko <jiri@mellanox.com>
>>>> ---
>>>> Changelog:
>>>>   v1->v2:
>>>>    Add !skip_add curly braces
>>>>    Removed extra setting thoff again
>>>>    Check tcp proto outside of tcf_ct_flow_table_check_tcp
>>>>
>>>>  net/sched/act_ct.c | 160 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>>>>  1 file changed, 158 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
>>>> index 6ad0553..2017f8f 100644
>>>> --- a/net/sched/act_ct.c
>>>> +++ b/net/sched/act_ct.c
>>>> @@ -186,6 +186,155 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
>>>>  	tcf_ct_flow_table_add(ct_ft, ct, tcp);
>>>>  }
>>>>  
>>>> +static bool
>>>> +tcf_ct_flow_table_fill_tuple_ipv4(struct sk_buff *skb,
>>>> +				  struct flow_offload_tuple *tuple)
>>>> +{
>>>> +	struct flow_ports *ports;
>>>> +	unsigned int thoff;
>>>> +	struct iphdr *iph;
>>>> +
>>>> +	if (!pskb_may_pull(skb, sizeof(*iph)))
>>>> +		return false;
>>>> +
>>>> +	iph = ip_hdr(skb);
>>>> +	thoff = iph->ihl * 4;
>>>> +
>>>> +	if (ip_is_fragment(iph) ||
>>>> +	    unlikely(thoff != sizeof(struct iphdr)))
>>>> +		return false;
>>>> +
>>>> +	if (iph->protocol != IPPROTO_TCP &&
>>>> +	    iph->protocol != IPPROTO_UDP)
>>>> +		return false;
>>>> +
>>>> +	if (iph->ttl <= 1)
>>>> +		return false;
>>>> +
>>>> +	if (!pskb_may_pull(skb, thoff + sizeof(*ports)))
>>>> +		return false;
>>>> +
>>> I think you should reload iph after the pskb_may_pull() call.
>> Good catch, you're right it might change skb->head.
>>
>> Thanks, will send v5.
>>
>> Paul.
>>
> Actually shouldn't the code be using pskb_network_may_pull(), i.e. pskb_may_pull()
> with skb_network_offset(skb) + sizeof(network header) ... ?

you mean pskb_network_may_pull(skb,  thoff + sizeof(ports)) ?

Should act the same as skb is trimmed to network layer by caller (tcf_ct_skb_network_trim())

I can still do this to be more bullet proof, what do you think?


>
>>>> +	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
>>>> +
>>>> +	tuple->src_v4.s_addr = iph->saddr;
>>>> +	tuple->dst_v4.s_addr = iph->daddr;
>>>> +	tuple->src_port = ports->source;
>>>> +	tuple->dst_port = ports->dest;
>>>> +	tuple->l3proto = AF_INET;
>>>> +	tuple->l4proto = iph->protocol;
>>>> +
>>>> +	return true;
>>>> +}
>>>> +
>>>> +static bool
>>>> +tcf_ct_flow_table_fill_tuple_ipv6(struct sk_buff *skb,
>>>> +				  struct flow_offload_tuple *tuple)
>>>> +{
>>>> +	struct flow_ports *ports;
>>>> +	struct ipv6hdr *ip6h;
>>>> +	unsigned int thoff;
>>>> +
>>>> +	if (!pskb_may_pull(skb, sizeof(*ip6h)))
>>>> +		return false;
>>>> +
>>>> +	ip6h = ipv6_hdr(skb);
>>>> +
>>>> +	if (ip6h->nexthdr != IPPROTO_TCP &&
>>>> +	    ip6h->nexthdr != IPPROTO_UDP)
>>>> +		return false;
>>>> +
>>>> +	if (ip6h->hop_limit <= 1)
>>>> +		return false;
>>>> +
>>>> +	thoff = sizeof(*ip6h);
>>>> +	if (!pskb_may_pull(skb, thoff + sizeof(*ports)))
>>>> +		return false;
>>> same here
>>>
>>>> +
>>>> +	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
>>>> +
>>>> +	tuple->src_v6 = ip6h->saddr;
>>>> +	tuple->dst_v6 = ip6h->daddr;
>>>> +	tuple->src_port = ports->source;
>>>> +	tuple->dst_port = ports->dest;
>>>> +	tuple->l3proto = AF_INET6;
>>>> +	tuple->l4proto = ip6h->nexthdr;
>>>> +
>>>> +	return true;
>>>> +}
>>>> +
>>>> +static bool tcf_ct_flow_table_check_tcp(struct flow_offload *flow,
>>>> +					struct sk_buff *skb,
>>>> +					unsigned int thoff)
>>>> +{
>>>> +	struct tcphdr *tcph;
>>>> +
>>>> +	if (!pskb_may_pull(skb, thoff + sizeof(*tcph)))
>>>> +		return false;
>>>> +
>>>> +	tcph = (void *)(skb_network_header(skb) + thoff);
>>>> +	if (unlikely(tcph->fin || tcph->rst)) {
>>>> +		flow_offload_teardown(flow);
>>>> +		return false;
>>>> +	}
>>>> +
>>>> +	return true;
>>>> +}
>>>> +
>>>> +static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
>>>> +				     struct sk_buff *skb,
>>>> +				     u8 family)
>>>> +{
>>>> +	struct nf_flowtable *nf_ft = &p->ct_ft->nf_ft;
>>>> +	struct flow_offload_tuple_rhash *tuplehash;
>>>> +	struct flow_offload_tuple tuple = {};
>>>> +	enum ip_conntrack_info ctinfo;
>>>> +	struct flow_offload *flow;
>>>> +	struct nf_conn *ct;
>>>> +	unsigned int thoff;
>>>> +	int ip_proto;
>>>> +	u8 dir;
>>>> +
>>>> +	/* Previously seen or loopback */
>>>> +	ct = nf_ct_get(skb, &ctinfo);
>>>> +	if ((ct && !nf_ct_is_template(ct)) || ctinfo == IP_CT_UNTRACKED)
>>>> +		return false;
>>>> +
>>>> +	switch (family) {
>>>> +	case NFPROTO_IPV4:
>>>> +		if (!tcf_ct_flow_table_fill_tuple_ipv4(skb, &tuple))
>>>> +			return false;
>>>> +		break;
>>>> +	case NFPROTO_IPV6:
>>>> +		if (!tcf_ct_flow_table_fill_tuple_ipv6(skb, &tuple))
>>>> +			return false;
>>>> +		break;
>>>> +	default:
>>>> +		return false;
>>>> +	}
>>>> +
>>>> +	tuplehash = flow_offload_lookup(nf_ft, &tuple);
>>>> +	if (!tuplehash)
>>>> +		return false;
>>>> +
>>>> +	dir = tuplehash->tuple.dir;
>>>> +	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
>>>> +	ct = flow->ct;
>>>> +
>>>> +	ctinfo = dir == FLOW_OFFLOAD_DIR_ORIGINAL ? IP_CT_ESTABLISHED :
>>>> +						    IP_CT_ESTABLISHED_REPLY;
>>>> +
>>>> +	thoff = ip_hdr(skb)->ihl * 4;
>>>> +	ip_proto = ip_hdr(skb)->protocol;
>>>> +	if (ip_proto == IPPROTO_TCP &&
>>>> +	    !tcf_ct_flow_table_check_tcp(flow, skb, thoff))
>>>> +		return false;
>>>> +
>>>> +	nf_conntrack_get(&ct->ct_general);
>>>> +	nf_ct_set(skb, ct, ctinfo);
>>>> +
>>>> +	return true;
>>>> +}
>>>> +
>>>>  static int tcf_ct_flow_tables_init(void)
>>>>  {
>>>>  	return rhashtable_init(&zones_ht, &zones_params);
>>>> @@ -554,6 +703,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>>>>  	struct nf_hook_state state;
>>>>  	int nh_ofs, err, retval;
>>>>  	struct tcf_ct_params *p;
>>>> +	bool skip_add = false;
>>>>  	struct nf_conn *ct;
>>>>  	u8 family;
>>>>  
>>>> @@ -603,6 +753,11 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>>>>  	 */
>>>>  	cached = tcf_ct_skb_nfct_cached(net, skb, p->zone, force);
>>>>  	if (!cached) {
>>>> +		if (!commit && tcf_ct_flow_table_lookup(p, skb, family)) {
>>>> +			skip_add = true;
>>>> +			goto do_nat;
>>>> +		}
>>>> +
>>>>  		/* Associate skb with specified zone. */
>>>>  		if (tmpl) {
>>>>  			ct = nf_ct_get(skb, &ctinfo);
>>>> @@ -620,6 +775,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>>>>  			goto out_push;
>>>>  	}
>>>>  
>>>> +do_nat:
>>>>  	ct = nf_ct_get(skb, &ctinfo);
>>>>  	if (!ct)
>>>>  		goto out_push;
>>>> @@ -637,10 +793,10 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>>>>  		 * even if the connection is already confirmed.
>>>>  		 */
>>>>  		nf_conntrack_confirm(skb);
>>>> +	} else if (!skip_add) {
>>>> +		tcf_ct_flow_table_process_conn(p->ct_ft, ct, ctinfo);
>>>>  	}
>>>>  
>>>> -	tcf_ct_flow_table_process_conn(p->ct_ft, ct, ctinfo);
>>>> -
>>>>  out_push:
>>>>  	skb_push_rcsum(skb, nh_ofs);
>>>>  
>>>>
