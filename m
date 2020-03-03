Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A21E81779E7
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 16:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728953AbgCCPGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 10:06:51 -0500
Received: from mail-db8eur05on2067.outbound.protection.outlook.com ([40.107.20.67]:28408
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728022AbgCCPGv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 10:06:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X9YVTytQOMV/DEeYV1N1gb8p6yyMcMSmUDfGreLNY49LmfoKGVdAm6feaQLipGi7kfY/PUbMfq9k3ILzud33hzozGqAEgC0apuXB76X6+aHTRvAniv/yzR9Q/QnfYDIL/Z/ZwIT1sRc/nW/hwMoJYi4iGRCjxxMoC+dq+PglPCp36l9tjUCDvDi7zjYh2vkHPlsB0pwdZUjmZ37zhBrLBiA8uMRNyQ/2SwtoYEgTdol0LyQl4sf/PTKH/Xz3KKcJquofLDstLn/xaqeCg4G4hMkGDDQ/D3Snu+2RkAJf8uDI/VU8Ltp9QX+AQe9PX/7w23+OV640GqU90V3hg/EQWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=neG+lBsb6gm728quM6ditkTlWTYhErpa2CHOFtu0Rp4=;
 b=JHx4g8GJ6bPFcZ9fEpLzvAwYdm9rXPHUDEyQOQ+YxgoXngfc97eGynUPAy60C6o789978wuFixVYswl6b4sk6KcyHTp7qdvlo9LA1swJErMVgeZaFF8xUJuTX9WXB6mK7R33vHuZ+v4lsUHsUhGK4rugH+zrnqYGOxbHBSrLw0s01PmOVPT0miAdz41b1BVbAPc9x3ohwZG2uUSAh0Il5J5lzHP51YK3E/sbVrSvqm8uaL7ugu4Y6Rv3LlbEoNqfUIQYKXwOH7Nip40Dhj7bWVjBAyFk/YLTrkqqfy66zE2Jkr5GZdr2ZJEprXGq0O+CYMrMEgdLr0/Dkmh1md5xyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=neG+lBsb6gm728quM6ditkTlWTYhErpa2CHOFtu0Rp4=;
 b=QXp+aQHUFpc25fu4EUNJ5TagWUZM2BPm4gnNDzN0mQg9tti9sDizBeLgGK0NmbZ7cL+T/0NjlQws0Zg+WDfr9L+KHjGNR1ZFIokMUe+hRDGNLO+ddawpI5gGeiECRwI+0b4TnNxODR6NpQEaEZuYG+uWJOOcRch//+65DIghAhA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (20.177.36.78) by
 AM6PR05MB6487.eurprd05.prod.outlook.com (20.179.18.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14; Tue, 3 Mar 2020 15:06:43 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4%7]) with mapi id 15.20.2772.019; Tue, 3 Mar 2020
 15:06:43 +0000
Subject: Re: [PATCH net-next v5 3/3] net/sched: act_ct: Software offload of
 established flows
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
References: <1583245281-25999-1-git-send-email-paulb@mellanox.com>
 <1583245281-25999-4-git-send-email-paulb@mellanox.com>
 <7844f674-e2f1-8744-92c9-10452fe977b7@cumulusnetworks.com>
From:   Paul Blakey <paulb@mellanox.com>
Message-ID: <d63e7cb3-3890-eac2-b6b7-b967e5abac71@mellanox.com>
Date:   Tue, 3 Mar 2020 17:06:37 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <7844f674-e2f1-8744-92c9-10452fe977b7@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR06CA0029.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::42) To AM6PR05MB5096.eurprd05.prod.outlook.com
 (2603:10a6:20b:11::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.223.6.3] (193.47.165.251) by AM0PR06CA0029.eurprd06.prod.outlook.com (2603:10a6:208:ab::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15 via Frontend Transport; Tue, 3 Mar 2020 15:06:42 +0000
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5698f3fc-143c-4eee-848d-08d7bf847c19
X-MS-TrafficTypeDiagnostic: AM6PR05MB6487:|AM6PR05MB6487:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB6487004B2937A80771728975CFE40@AM6PR05MB6487.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:298;
X-Forefront-PRVS: 03319F6FEF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(376002)(346002)(39860400002)(396003)(189003)(199004)(66556008)(66946007)(16576012)(66476007)(110136005)(2616005)(316002)(956004)(5660300002)(6636002)(2906002)(36756003)(8676002)(53546011)(8936002)(31686004)(6486002)(81166006)(478600001)(31696002)(26005)(186003)(6666004)(81156014)(86362001)(16526019)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6487;H:AM6PR05MB5096.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EKKKEriXG4q7Jm7nE7S63T9zJLARMYFZa7cadTu8McI9iC3bZ3q5xCE/Fcha0Da6rrspKjv3UpfLwrcYEsLXxIHoK+knZC7MZdciaN+zexN/rgfsFrRb4eb7I4+BKz3DX1FFOX7yMalAA8fxP6LRrvrdKMllhc6di0AgV4lV3vuuRN7+PH63fKEcwvmss40/O96zr3pmHVVr/QoLlI2bMPlcN5JhCWBBWaWFYyIjPQKjOmzcU1PSUBNrhXwPQPu9JKpWifO2ozMeaN0llfhPqS1bat/ERi65FkpTXTvUBPEvLstSEH8BI70iFJHp+DZijNIFvvkYhkcagO7U3RQWSH5o7vCQTuYbForAHa2nzDdikw6OIKT2LZMGP77LRPNwjB/vjUJGUhCJNGgF4aRJvH7Nri2jjHMgOWbyaoHXK6EtnbL2kobCc9hNaQMz4ku8
X-MS-Exchange-AntiSpam-MessageData: rs5ShPnqQYsyoWnY/t+LptQiMFfQq6Uc6sfgUrgBL1GBVPGPzCd+corH17ikqeT/fGMtW18j7qm7HQKCta0tzkHlJ3rqXZj+I3frjrYc2wPoUaC+dX3iThzdt0P4juCFKNZ4OIfKZPFJqexKiv0Wlw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5698f3fc-143c-4eee-848d-08d7bf847c19
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2020 15:06:43.6269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T7oHo2jMPMVmPHbCs0lU8YJAvOxuYPjj0eKmYZmfQzqAs3RMrRJ3SUc8LAAz8Z11uHbE23rKLnXYe1uCZAHdcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6487
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/3/2020 4:30 PM, Nikolay Aleksandrov wrote:
> On 03/03/2020 16:21, Paul Blakey wrote:
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
>>   v4->v5:
>>    Re-read ip/ip6 header after pulling as skb ptrs may change
>>    Use pskb_network_may_pull instaed of pskb_may_pull
>>   v1->v2:
>>    Add !skip_add curly braces
>>    Removed extra setting thoff again
>>    Check tcp proto outside of tcf_ct_flow_table_check_tcp
>>
>>  net/sched/act_ct.c | 162 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 160 insertions(+), 2 deletions(-)
>>
> Hi Paul,
> Thanks for making the changes, I have two more questions below, missed these changes
> on my previous review, sorry about that.
>
>> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
>> index 2ab38431..5aff5e7 100644
>> --- a/net/sched/act_ct.c
>> +++ b/net/sched/act_ct.c
>> @@ -186,6 +186,157 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
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
>> +	if (!pskb_network_may_pull(skb, sizeof(*iph)))
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
>> +	if (!pskb_network_may_pull(skb, thoff + sizeof(*ports)))
>> +		return false;
>> +
>> +	iph = ip_hdr(skb);
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
>> +	if (!pskb_network_may_pull(skb, sizeof(*ip6h)))
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
>> +	if (!pskb_network_may_pull(skb, thoff + sizeof(*ports)))
>> +		return false;
>> +
>> +	ip6h = ipv6_hdr(skb);
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
> Sorry, I missed this spot in my previous review, but shouldn't this follow the
> same logic for the pull ?
Yes, will fix.
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
> I'm a bit confused about this part, above you treat the skb based on the family
> but down here it's always IPv4 ?

Right,Ill move the tcp check to inside filler funcs.

Thanks!

>
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
>> @@ -554,6 +705,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>>  	struct nf_hook_state state;
>>  	int nh_ofs, err, retval;
>>  	struct tcf_ct_params *p;
>> +	bool skip_add = false;
>>  	struct nf_conn *ct;
>>  	u8 family;
>>  
>> @@ -603,6 +755,11 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
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
>> @@ -620,6 +777,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>>  			goto out_push;
>>  	}
>>  
>> +do_nat:
>>  	ct = nf_ct_get(skb, &ctinfo);
>>  	if (!ct)
>>  		goto out_push;
>> @@ -637,10 +795,10 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
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
