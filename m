Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3076082C5
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 02:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiJVANY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 20:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiJVANY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 20:13:24 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 356E22A8A44;
        Fri, 21 Oct 2022 17:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666397603; x=1697933603;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SKZR79US94FEM5350Cpj/SexIBQ2tsnbmcsu8rA37B8=;
  b=YSANRW7nH1l3NxA/raVYprFyc9JWEw8eoPfBRpenuHaWtZFKFaykTwoC
   QX+bbEmukoPCd2JY8l4X11N07pLKbizWRuSpAQCR29mrK7ItONl2QC1Gi
   J8k86xpYZH0KZIAFybUw6Uz1YhtW+QsdH1m789amneP65P716pcoKw4FL
   0=;
X-IronPort-AV: E=Sophos;i="5.95,203,1661817600"; 
   d="scan'208";a="143206135"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-21d8d9f4.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2022 00:13:21 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-21d8d9f4.us-west-2.amazon.com (Postfix) with ESMTPS id F165481038;
        Sat, 22 Oct 2022 00:13:20 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Sat, 22 Oct 2022 00:13:20 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.162.134) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Sat, 22 Oct 2022 00:13:16 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <shaozhengchao@huawei.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <jhs@mojatatu.com>,
        <jiri@resnulli.us>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <weiyongjun1@huawei.com>,
        <xiyou.wangcong@gmail.com>, <yuehaibing@huawei.com>,
        <kuniyu@amazon.com>, <sdf@google.com>, <bpf@vger.kernel.org>
Subject: Re: [PATCH net] net: sched: fq_codel: fix null-ptr-deref issue in fq_codel_enqueue()
Date:   Fri, 21 Oct 2022 17:13:08 -0700
Message-ID: <20221022001308.17778-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221021084058.223823-1-shaozhengchao@huawei.com>
References: <20221021084058.223823-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.134]
X-ClientProxiedBy: EX13D44UWC002.ant.amazon.com (10.43.162.169) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Stanislav, bpf

From:   Zhengchao Shao <shaozhengchao@huawei.com>
Date:   Fri, 21 Oct 2022 16:40:58 +0800
> As [0] see, it will cause null-ptr-deref issue.
> The following is the process of triggering the problem:
> fq_codel_enqueue()
> 	...
> 	idx = fq_codel_classify()        --->if idx != 0
> 	flow = &q->flows[idx];
> 	flow_queue_add(flow, skb);       --->add skb to flow[idex]
> 	q->backlogs[idx] += qdisc_pkt_len(skb); --->backlogs = 0
> 	...
> 	fq_codel_drop()          --->set sch->limit = 0, always
> 				     drop packets
> 		...
> 		idx = i          --->because backlogs in every
> 				     flows is 0, so idx = 0
> 		...
> 		flow = &q->flows[idx];   --->get idx=0 flow
> 		...
> 		dequeue_head()
> 			skb = flow->head; --->flow->head = NULL
> 			flow->head = skb->next; --->cause null-ptr-deref
> 
> So, only need to discard the packets whose len is 0 on dropping path of
> enqueue. Then, the correct flow id can be obtained by fq_codel_drop() on
> next enqueuing.
> 
> [0]: https://syzkaller.appspot.com/bug?id=0b84da80c2917757915afa89f7738a9d16ec96c5

This can be caused by BPF, but there seems to be no consensus yet.
https://lore.kernel.org/netdev/CAKH8qBsOMxVaemF0Oy=vE1V0vKO8ORUcVGB5YANS3HdKOhVjjw@mail.gmail.com/

"""
I think the consensus here is that the stack, in general, doesn't
expect the packets like this. So there are probably more broken things
besides fq_codel. Thus, it's better if we remove the ability to
generate them from the bpf side instead of fixing the individual users
like fq_codel.
"""


> 
> Fixes: 4b549a2ef4be ("fq_codel: Fair Queue Codel AQM")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  net/sched/sch_fq_codel.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
> index 99d318b60568..3bbe7f69dfb5 100644
> --- a/net/sched/sch_fq_codel.c
> +++ b/net/sched/sch_fq_codel.c
> @@ -187,6 +187,7 @@ static int fq_codel_enqueue(struct sk_buff *skb, struct Qdisc *sch,
>  	struct fq_codel_sched_data *q = qdisc_priv(sch);
>  	unsigned int idx, prev_backlog, prev_qlen;
>  	struct fq_codel_flow *flow;
> +	struct sk_buff *drop_skb;

We can move this into the if-block below or remove.


>  	int ret;
>  	unsigned int pkt_len;
>  	bool memory_limited;
> @@ -222,6 +223,13 @@ static int fq_codel_enqueue(struct sk_buff *skb, struct Qdisc *sch,
>  
>  	/* save this packet length as it might be dropped by fq_codel_drop() */
>  	pkt_len = qdisc_pkt_len(skb);
> +
> +	/* drop skb if len = 0, so fq_codel_drop could get the right flow idx*/
> +	if (unlikely(!pkt_len)) {
> +		drop_skb = dequeue_head(flow);
> +		__qdisc_drop(drop_skb, to_free);

just            __qdisc_drop(dequeue_head(flow), to_free);


> +		return NET_XMIT_SUCCESS;
> +	}
>  	/* fq_codel_drop() is quite expensive, as it performs a linear search
>  	 * in q->backlogs[] to find a fat flow.
>  	 * So instead of dropping a single packet, drop half of its backlog
> -- 
> 2.17.1

