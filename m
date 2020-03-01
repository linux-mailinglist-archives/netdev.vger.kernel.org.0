Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3E1E174D61
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 13:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbgCAMuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 07:50:14 -0500
Received: from mail-eopbgr60081.outbound.protection.outlook.com ([40.107.6.81]:55886
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725877AbgCAMuO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Mar 2020 07:50:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hibrzgaEF31KJWxDgAH+hV11idsnlkjDYLcDR+GOFpma8a9RzhUyFo6SxRDLPY3kCWKu6cl689tC8kyrCn3b9DlUcU18gE5cENupE9IrQKGN3/oPVkG96abHuYEHOoQJ3cZSWHrVdE0Q8SQNKyYmfxj70eH4kK3FifY4GAox0JoDAVTr2/9M4Bkhznixv1ctvmD1fBfrSMwQmdE1kPsZWn6upAA7F7nyjfvrknp5tf0hJAgoXpH7QIWFeJH4kkRxquOHxeb7Pg9ca7wOA9/9Bxn1l7rp/RL+fjSdE9SyPg4nv/FIbck+OPpCCMbMVKdBzNm1y/j2HZIIrlYRv2jL/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bm4TQAGAkwwYvfsTGNw8lK34dZrGImTIm411fkWB+9Q=;
 b=bdvPetCycstqd9+H2APmBjB9IRVUc4TJoImsT/MkdGl6bujiBYWKuBleXoA10XRayPEE6ttPA6wOALp3RLQorOHlJ6HUuyWfuRE4kHeCC+xlmRUo/n6+Y4AI2PkBhsy0vDEsU9wNbsTVQbLl6f9YPtcbZMHGREjYyGJ+Tl+tERJfmRwyGTbqoKcbT70ywMGMa2QnIV6EKrWxg3MmjpXkChCAEAlHI9AZGoS7iR/bl7SmH2G7yrqn0JIcLYyttC1WYFj10pDf4y+3UTlpHRAnThn/TaXXr53YvD2/CghDnEVywvDdybeLqiunsKyaLoomut6+SmlcELO4J7H/FtpJjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bm4TQAGAkwwYvfsTGNw8lK34dZrGImTIm411fkWB+9Q=;
 b=Solf7n5T5sPDJf+oKQHffTTsuaS/FpDfHH5D9PbT0pYNqVYgz847ISF3XTAUb/eHy5u+Jvw7EN1GKqtSX1OGJ89HWkqRQfxx4RZFKWQVAjCPOVlsngNvVm8n3yTNbDel7R6kTJoFR2JDr7f7wLxHQkUP6aUMntBEsHxh6imy5KE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (20.177.36.78) by
 AM6PR05MB4248.eurprd05.prod.outlook.com (52.135.168.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.18; Sun, 1 Mar 2020 12:50:10 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4%7]) with mapi id 15.20.2772.019; Sun, 1 Mar 2020
 12:50:10 +0000
Subject: Re: [PATCH net-next 6/6] net/sched: act_ct: Software offload of
 established flows
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
References: <1582458307-17067-1-git-send-email-paulb@mellanox.com>
 <1582458307-17067-7-git-send-email-paulb@mellanox.com>
 <20200228145245.GB2546@localhost.localdomain>
From:   Paul Blakey <paulb@mellanox.com>
Message-ID: <8c15fc40-47cc-cbd4-1663-af189a19e0d8@mellanox.com>
Date:   Sun, 1 Mar 2020 14:50:05 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <20200228145245.GB2546@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: ZRAP278CA0016.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::26) To AM6PR05MB5096.eurprd05.prod.outlook.com
 (2603:10a6:20b:11::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.223.6.3] (193.47.165.251) by ZRAP278CA0016.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Sun, 1 Mar 2020 12:50:09 +0000
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9067d90f-1fab-41c7-02fe-08d7bddf13f7
X-MS-TrafficTypeDiagnostic: AM6PR05MB4248:|AM6PR05MB4248:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB4248138DC29D3BA6408F0CD5CFE60@AM6PR05MB4248.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:514;
X-Forefront-PRVS: 0329B15C8A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(189003)(199004)(81166006)(6486002)(8936002)(81156014)(52116002)(8676002)(53546011)(54906003)(16526019)(2616005)(31696002)(107886003)(31686004)(956004)(16576012)(316002)(26005)(186003)(36756003)(2906002)(86362001)(6916009)(5660300002)(66946007)(66476007)(66556008)(6666004)(4326008)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4248;H:AM6PR05MB5096.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t5oVMsPlahLN/FvmqxuuTsJuphnZAD4RBxOpqA6SVChrtl3u+17ys/C3qAP/0rciB8K+FZkU8Qgs3SeRJB5Op+4fW8d5oNJc/9ZZWBZa9KVAMopdcsn570MwaL3jLwoTZ8f5fSX2M8j6s3HOSWNPE1HjvKyHdx+dyioApcHR6sIFP/Mw8cc+LkOlN0+U+nfa8IAsL8Ppqan+87py42xAFREoz/TKKiMCcN33QnF8+x4DT/6ieA8to5fDW9dHWDhJhXG3fZbk8xuM3M6QPRihI9dDh/B0cAbxyT8X3NzZ1HHUM8ktmVkpN8u1BnDWJFJbPl4kvoFs9w2Z0vOguLW0xErZWU+F/5pU8tc/81O4SgPl2oS2xST5UkG9VQSSIb2lEg+x2bhD89go5WV45qr6qp2Dr1zQHMnarrB4PWSbCjGCjsOD5nHJRWvM37DvnuTS
X-MS-Exchange-AntiSpam-MessageData: +ycX4FL0jWPl6eEaUrlAM8GgIAcHNjnS2QyOmlHQdigfE9i5hb96mGAIqyTwEouDL3aHxMVscgyLkal5ePEYlnzUZdr2yjC5o8FJjr3STEOdp2q0bmiIMdbVhU9Xm+ClxkzbG6af9Dsf9tamECICMg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9067d90f-1fab-41c7-02fe-08d7bddf13f7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2020 12:50:10.8315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JLbALBLfPze/9bif4UTs40h2UyPUzsIdL7Kgq5vnJWMn0zNKlamQ3PMvC4kCemPK6ssS8SmstMilKyBibraPbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4248
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/28/2020 4:52 PM, Marcelo Ricardo Leitner wrote:
> On Sun, Feb 23, 2020 at 01:45:07PM +0200, Paul Blakey wrote:
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
>>  net/sched/act_ct.c | 163 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 160 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
>> index b2bc885..3592e24 100644
>> --- a/net/sched/act_ct.c
>> +++ b/net/sched/act_ct.c
>> @@ -211,6 +211,157 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
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
> [A]
>
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
>> +	thoff = iph->ihl * 4;
> This is not needed, as already done in [A].
Removed
>> +	if (!pskb_may_pull(skb, thoff + sizeof(*ports)))
>> +		return false;
>> +
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
>> +static bool tcf_ct_flow_table_check_tcp(struct flow_offload *flow, int proto,
>> +					struct sk_buff *skb,
>> +					unsigned int thoff)
>> +{
>> +	struct tcphdr *tcph;
>> +
>> +	if (proto != IPPROTO_TCP)
>> +		return true;
> I suppose this is a way to do additional checks for TCP while allowing
> everything, but it does give the feeling that the 'return true' is
> wrong and should have been 'return false' instead. The function name
> works both ways too, at least to me. :-)
>
> Can we have a comment to make it explicit, or a different construct?
> Like, instead of 'return true' here, a 'goto out_ok' and reuse the
> last return.
>
i moved the tcp check outside (different construct)
> These are all my comments on this series. LGTM otherwise. Thanks!
thanks for reviewing.
>
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
>> +	if (!tcf_ct_flow_table_check_tcp(flow, ip_hdr(skb)->protocol, skb,
>> +					 thoff))
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
>> @@ -579,6 +730,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>>  	struct nf_hook_state state;
>>  	int nh_ofs, err, retval;
>>  	struct tcf_ct_params *p;
>> +	bool skip_add = false;
>>  	struct nf_conn *ct;
>>  	u8 family;
>>  
>> @@ -628,6 +780,11 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
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
>> @@ -645,6 +802,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>>  			goto out_push;
>>  	}
>>  
>> +do_nat:
>>  	ct = nf_ct_get(skb, &ctinfo);
>>  	if (!ct)
>>  		goto out_push;
>> @@ -662,9 +820,8 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>>  		 * even if the connection is already confirmed.
>>  		 */
>>  		nf_conntrack_confirm(skb);
>> -	}
>> -
>> -	tcf_ct_flow_table_process_conn(p->ct_ft, ct, ctinfo);
>> +	} else if (!skip_add)
>> +		tcf_ct_flow_table_process_conn(p->ct_ft, ct, ctinfo);
>>  
>>  out_push:
>>  	skb_push_rcsum(skb, nh_ofs);
>> -- 
>> 1.8.3.1
>>
