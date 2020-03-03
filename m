Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59A0017772A
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 14:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729361AbgCCNbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 08:31:46 -0500
Received: from mail-eopbgr70071.outbound.protection.outlook.com ([40.107.7.71]:63616
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728349AbgCCNbq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 08:31:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LFTxtCVRttGcafCFPryNq72S2nLuy4Rw/15l3bcw3UH4AUqUy3CZtqaL3UXflaeb0hOAuy9aEdSUZLOByeiNo2iZ3RjruNmkx/wsi9W21BF6ax370b6VaIsamub8P9//SxzlGK+JL8aPnWfDKwe5oTq++mkp8D9Amg/ElT7PhPBjbnqLALkmSUinYlw+zTefTco85V+nDDIfS3CafPX5fCom0hxc2w9dvsP7wPjPfrjupMbKcLrWhv3WhX6eVRNDH4USKxHq2ZwoZ6SBLK72GgwHZbJgpIPaXXgok1fdW9K1+okMpB/AG1kzhPFHQXSvBGmijfc1OaGN8rw8lGniBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J9BQW4RQycKPw0IwzEGp/v7fMj2aTeqmi7hqbG71UPE=;
 b=DquDBVse0gUjSdeQ07FtwY/26FI+3k7R2f+uKPntrNuzsLqgI7UFiezkX/3q6ekebL+0JpLlzF46PZjYxtHSJaYdJoWWcXJsveYxv9Xlqc8G2Ogt9dok4f7uAB7/rKtkrJiGtOpDfRpjNK/rH5hT4YmxOe9aE420Pp/a9Pz7qHkm5y9ky4hmh+vTIgHzZdTRzMgCHyLBxmmAa9hZ1kovQPtY3wCfvc37mRDkiUIs4lwCG12vRza1330litI1mBcMy9zL21PduQS4fM4nNgK0Qj0Z0zyOm6a03o67gBvKedkyj4XnsELzI4GO3zZeBv3f5xBnHx1kk4Lt/MQNXETP5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J9BQW4RQycKPw0IwzEGp/v7fMj2aTeqmi7hqbG71UPE=;
 b=j7E+kq4UF+qMpeJ6GfLFFJytW8oywcnto1GhhpnaCk1LuIZJF8JDKA35S7HMZ7SDeOX+GfQMv8W57qnPLC7ZnapiwF5vfc6Eh8rHT/H4tg0oQnv2be1jCiDQpL0amts+1Hm45U9G3khxdMNrHWD/nn4VmO/3hNwRzhXBeg8VV0M=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (20.177.36.78) by
 AM6PR05MB4904.eurprd05.prod.outlook.com (20.177.33.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14; Tue, 3 Mar 2020 13:31:41 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4%7]) with mapi id 15.20.2772.019; Tue, 3 Mar 2020
 13:31:41 +0000
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
From:   Paul Blakey <paulb@mellanox.com>
Message-ID: <5cfe38ec-fd47-1846-fe84-433df3554a1b@mellanox.com>
Date:   Tue, 3 Mar 2020 15:31:34 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <3f174fcb-0636-22d2-8d1c-e0e4981aab95@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR01CA0024.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:69::37) To AM6PR05MB5096.eurprd05.prod.outlook.com
 (2603:10a6:20b:11::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.223.6.3] (193.47.165.251) by AM0PR01CA0024.eurprd01.prod.exchangelabs.com (2603:10a6:208:69::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.18 via Frontend Transport; Tue, 3 Mar 2020 13:31:39 +0000
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 23b613bf-43a0-4888-0db0-08d7bf77351a
X-MS-TrafficTypeDiagnostic: AM6PR05MB4904:|AM6PR05MB4904:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB4904E28DC0D2CBE3DF379C39CFE40@AM6PR05MB4904.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:66;
X-Forefront-PRVS: 03319F6FEF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(376002)(396003)(366004)(39860400002)(199004)(189003)(53546011)(16526019)(956004)(186003)(2616005)(26005)(36756003)(6666004)(5660300002)(66556008)(66476007)(66946007)(8936002)(6486002)(8676002)(81166006)(81156014)(478600001)(2906002)(110136005)(316002)(16576012)(52116002)(6636002)(86362001)(31686004)(31696002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4904;H:AM6PR05MB5096.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: skch6l1tndyLbgZosWs8gXUMIJHJPuG+O/AoWlx8ikq1DDS1qa05genZ6FgHvv2bpGJ+V15HtXLgt1js3VBy3Qr0299T5EovLSjfi4poNdhxiud+au4Pg1e2j+ISMZRuDVhY7z0zvJbODJlB1qNvkJMGKCr0VmTeQm+tha2dfLdm6U82KwrGp6iYDdzVbQZA2wYHN7c0dpKjIO60FAuM8Sh+rCP/UiGsWYwBOdYSpaQfCAEMMNGH12KHCBHF6gGxO4h8b2mVKpRmRzKy9JjMCEFtBLShdMIga1vCxWW/muM9VI1bn7BtYr3/APRIoo0K6rg+BivIDuVIFYt6FzpMhGR7RPgicGZhCJ9mTroirGxR1UAHnhpClazf2jyzIJuTlXZzKUhxb8jr+bni0KRFVUm+BMTvOR+OOlfjQ/IgrL6LE0fQOgHKasrMQIvSZJoc
X-MS-Exchange-AntiSpam-MessageData: rpQMyUD7DWregNnj/edDsTSiAsK8g72F1yUFfB1p6vrLMj0O6VDjRJBwz4tA6tr1xA73wEsA9XbhV9OUHuB7MwHQ3Y9PfSUhUdhWm9Tarc7mA3FXcXl5L8KVKxo2rXF5vqaI7ps+WKiK+ahOzhOZ8w==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23b613bf-43a0-4888-0db0-08d7bf77351a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2020 13:31:41.1066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KIKN9skyziC9HVHWXcB6nHvCxhbdTClAhu5x9ELw5SVVRsLkAWRy1PnWME7xeV0hgLy+YxFagsPfIk119OBL/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4904
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/3/2020 3:10 PM, Nikolay Aleksandrov wrote:
> On 03/03/2020 14:52, Paul Blakey wrote:
>> Offload nf conntrack processing by looking up the 5-tuple in the
>> zone's flow table.
>>
>> The nf conntrack module will process the packets until a connection is
>> in established state. Once in established state, the ct state pointer
>> (nf_conn) will be restored on the skb from a successful ft lookup.
>>
>> Signed-off-by: Paul Blakey <paulb@mellanox.com>
>> Acked-by: Jiri Pirko <jiri@mellanox.com>
>> ---
>> Changelog:
>>   v1->v2:
>>    Add !skip_add curly braces
>>    Removed extra setting thoff again
>>    Check tcp proto outside of tcf_ct_flow_table_check_tcp
>>
>>  net/sched/act_ct.c | 160 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 158 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
>> index 6ad0553..2017f8f 100644
>> --- a/net/sched/act_ct.c
>> +++ b/net/sched/act_ct.c
>> @@ -186,6 +186,155 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
>>  	tcf_ct_flow_table_add(ct_ft, ct, tcp);
>>  }
>>  
>> +static bool
>> +tcf_ct_flow_table_fill_tuple_ipv4(struct sk_buff *skb,
>> +				  struct flow_offload_tuple *tuple)
>> +{
>> +	struct flow_ports *ports;
>> +	unsigned int thoff;
>> +	struct iphdr *iph;
>> +
>> +	if (!pskb_may_pull(skb, sizeof(*iph)))
>> +		return false;
>> +
>> +	iph = ip_hdr(skb);
>> +	thoff = iph->ihl * 4;
>> +
>> +	if (ip_is_fragment(iph) ||
>> +	    unlikely(thoff != sizeof(struct iphdr)))
>> +		return false;
>> +
>> +	if (iph->protocol != IPPROTO_TCP &&
>> +	    iph->protocol != IPPROTO_UDP)
>> +		return false;
>> +
>> +	if (iph->ttl <= 1)
>> +		return false;
>> +
>> +	if (!pskb_may_pull(skb, thoff + sizeof(*ports)))
>> +		return false;
>> +
> I think you should reload iph after the pskb_may_pull() call.

Good catch, you're right it might change skb->head.

Thanks, will send v5.

Paul.

>
>> +	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
>> +
>> +	tuple->src_v4.s_addr = iph->saddr;
>> +	tuple->dst_v4.s_addr = iph->daddr;
>> +	tuple->src_port = ports->source;
>> +	tuple->dst_port = ports->dest;
>> +	tuple->l3proto = AF_INET;
>> +	tuple->l4proto = iph->protocol;
>> +
>> +	return true;
>> +}
>> +
>> +static bool
>> +tcf_ct_flow_table_fill_tuple_ipv6(struct sk_buff *skb,
>> +				  struct flow_offload_tuple *tuple)
>> +{
>> +	struct flow_ports *ports;
>> +	struct ipv6hdr *ip6h;
>> +	unsigned int thoff;
>> +
>> +	if (!pskb_may_pull(skb, sizeof(*ip6h)))
>> +		return false;
>> +
>> +	ip6h = ipv6_hdr(skb);
>> +
>> +	if (ip6h->nexthdr != IPPROTO_TCP &&
>> +	    ip6h->nexthdr != IPPROTO_UDP)
>> +		return false;
>> +
>> +	if (ip6h->hop_limit <= 1)
>> +		return false;
>> +
>> +	thoff = sizeof(*ip6h);
>> +	if (!pskb_may_pull(skb, thoff + sizeof(*ports)))
>> +		return false;
> same here
>
>> +
>> +	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
>> +
>> +	tuple->src_v6 = ip6h->saddr;
>> +	tuple->dst_v6 = ip6h->daddr;
>> +	tuple->src_port = ports->source;
>> +	tuple->dst_port = ports->dest;
>> +	tuple->l3proto = AF_INET6;
>> +	tuple->l4proto = ip6h->nexthdr;
>> +
>> +	return true;
>> +}
>> +
>> +static bool tcf_ct_flow_table_check_tcp(struct flow_offload *flow,
>> +					struct sk_buff *skb,
>> +					unsigned int thoff)
>> +{
>> +	struct tcphdr *tcph;
>> +
>> +	if (!pskb_may_pull(skb, thoff + sizeof(*tcph)))
>> +		return false;
>> +
>> +	tcph = (void *)(skb_network_header(skb) + thoff);
>> +	if (unlikely(tcph->fin || tcph->rst)) {
>> +		flow_offload_teardown(flow);
>> +		return false;
>> +	}
>> +
>> +	return true;
>> +}
>> +
>> +static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
>> +				     struct sk_buff *skb,
>> +				     u8 family)
>> +{
>> +	struct nf_flowtable *nf_ft = &p->ct_ft->nf_ft;
>> +	struct flow_offload_tuple_rhash *tuplehash;
>> +	struct flow_offload_tuple tuple = {};
>> +	enum ip_conntrack_info ctinfo;
>> +	struct flow_offload *flow;
>> +	struct nf_conn *ct;
>> +	unsigned int thoff;
>> +	int ip_proto;
>> +	u8 dir;
>> +
>> +	/* Previously seen or loopback */
>> +	ct = nf_ct_get(skb, &ctinfo);
>> +	if ((ct && !nf_ct_is_template(ct)) || ctinfo == IP_CT_UNTRACKED)
>> +		return false;
>> +
>> +	switch (family) {
>> +	case NFPROTO_IPV4:
>> +		if (!tcf_ct_flow_table_fill_tuple_ipv4(skb, &tuple))
>> +			return false;
>> +		break;
>> +	case NFPROTO_IPV6:
>> +		if (!tcf_ct_flow_table_fill_tuple_ipv6(skb, &tuple))
>> +			return false;
>> +		break;
>> +	default:
>> +		return false;
>> +	}
>> +
>> +	tuplehash = flow_offload_lookup(nf_ft, &tuple);
>> +	if (!tuplehash)
>> +		return false;
>> +
>> +	dir = tuplehash->tuple.dir;
>> +	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
>> +	ct = flow->ct;
>> +
>> +	ctinfo = dir == FLOW_OFFLOAD_DIR_ORIGINAL ? IP_CT_ESTABLISHED :
>> +						    IP_CT_ESTABLISHED_REPLY;
>> +
>> +	thoff = ip_hdr(skb)->ihl * 4;
>> +	ip_proto = ip_hdr(skb)->protocol;
>> +	if (ip_proto == IPPROTO_TCP &&
>> +	    !tcf_ct_flow_table_check_tcp(flow, skb, thoff))
>> +		return false;
>> +
>> +	nf_conntrack_get(&ct->ct_general);
>> +	nf_ct_set(skb, ct, ctinfo);
>> +
>> +	return true;
>> +}
>> +
>>  static int tcf_ct_flow_tables_init(void)
>>  {
>>  	return rhashtable_init(&zones_ht, &zones_params);
>> @@ -554,6 +703,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>>  	struct nf_hook_state state;
>>  	int nh_ofs, err, retval;
>>  	struct tcf_ct_params *p;
>> +	bool skip_add = false;
>>  	struct nf_conn *ct;
>>  	u8 family;
>>  
>> @@ -603,6 +753,11 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>>  	 */
>>  	cached = tcf_ct_skb_nfct_cached(net, skb, p->zone, force);
>>  	if (!cached) {
>> +		if (!commit && tcf_ct_flow_table_lookup(p, skb, family)) {
>> +			skip_add = true;
>> +			goto do_nat;
>> +		}
>> +
>>  		/* Associate skb with specified zone. */
>>  		if (tmpl) {
>>  			ct = nf_ct_get(skb, &ctinfo);
>> @@ -620,6 +775,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>>  			goto out_push;
>>  	}
>>  
>> +do_nat:
>>  	ct = nf_ct_get(skb, &ctinfo);
>>  	if (!ct)
>>  		goto out_push;
>> @@ -637,10 +793,10 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>>  		 * even if the connection is already confirmed.
>>  		 */
>>  		nf_conntrack_confirm(skb);
>> +	} else if (!skip_add) {
>> +		tcf_ct_flow_table_process_conn(p->ct_ft, ct, ctinfo);
>>  	}
>>  
>> -	tcf_ct_flow_table_process_conn(p->ct_ft, ct, ctinfo);
>> -
>>  out_push:
>>  	skb_push_rcsum(skb, nh_ofs);
>>  
>>
