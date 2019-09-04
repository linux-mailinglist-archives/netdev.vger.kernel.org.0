Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92873A7FAA
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 11:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729229AbfIDJrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 05:47:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38788 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725840AbfIDJrQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 05:47:16 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3BFF830832DC;
        Wed,  4 Sep 2019 09:47:15 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.32.181.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0D91260610;
        Wed,  4 Sep 2019 09:47:11 +0000 (UTC)
Message-ID: <6b56001da1c3795ff9bb18a2aded62dea360faf9.camel@redhat.com>
Subject: Re: [PATCH net-next v3] net: openvswitch: Set OvS recirc_id from
 tc chain index
From:   Davide Caratti <dcaratti@redhat.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Pravin B Shelar <pshelar@ovn.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Justin Pettit <jpettit@nicira.com>,
        Simon Horman <simon.horman@netronome.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@mellanox.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Rony Efraim <ronye@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>
In-Reply-To: <1567517015-10778-2-git-send-email-paulb@mellanox.com>
References: <1567517015-10778-1-git-send-email-paulb@mellanox.com>
         <1567517015-10778-2-git-send-email-paulb@mellanox.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Wed, 04 Sep 2019 11:47:11 +0200
MIME-Version: 1.0
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Wed, 04 Sep 2019 09:47:15 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-09-03 at 16:23 +0300, Paul Blakey wrote:
> Offloaded OvS datapath rules are translated one to one to tc rules,
> for example the following simplified OvS rule:
> 
> recirc_id(0),in_port(dev1),eth_type(0x0800),ct_state(-trk) actions:ct(),recirc(2)
> 
> Will be translated to the following tc rule:
> 
> $ tc filter add dev dev1 ingress \
> 	    prio 1 chain 0 proto ip \
> 		flower tcp ct_state -trk \
> 		action ct pipe \
> 		action goto chain 2

hello Paul!

one small question: 

[... ]

> index 43f5b7e..2fdc746 100644
> --- a/include/net/sch_generic.h
> +++ b/include/net/sch_generic.h
> @@ -274,7 +274,10 @@ struct tcf_result {
>  			unsigned long	class;
>  			u32		classid;
>  		};
> -		const struct tcf_proto *goto_tp;
> +		struct {
> +			const struct tcf_proto *goto_tp;
> +			u32 goto_index;

I don't understand why we need to store another copy of the chain index in
'res.goto_index'.
(see below)

[...]

> index 3397122..c393604 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -27,6 +27,7 @@ static void tcf_action_goto_chain_exec(const struct tc_action *a,
>  {
>  	const struct tcf_chain *chain = rcu_dereference_bh(a->goto_chain);
>  
> +	res->goto_index = chain->index;

I see "a->goto_chain" is used to read the chain index, but I think it's
not needed _ because the chain index is encoded together with the "goto
chain" control action. 

>  	res->goto_tp = rcu_dereference_bh(chain->filter_chain);
>  }
>  
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 671ca90..dd147be 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -1514,6 +1514,18 @@ int tcf_classify(struct sk_buff *skb, const struct tcf_proto *tp,
>  			goto reset;
>  		} else if (unlikely(TC_ACT_EXT_CMP(err, TC_ACT_GOTO_CHAIN))) {
>  			first_tp = res->goto_tp;
> +
> +#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
> +			{
> +				struct tc_skb_ext *ext;
> +
> +				ext = skb_ext_add(skb, TC_SKB_EXT);
> +				if (WARN_ON_ONCE(!ext))
> +					return TC_ACT_SHOT;
> +
> +				ext->chain = res->goto_index;

the value of 'res->goto_index' is already encoded in the control action
'err' (masked with TC_ACT_EXT_VAL_MASK), since TC_ACT_GOTO_CHAIN bits are
not zero.

you can just get rid of res->goto_index, and just do:

	ext->chain = err & TC_ACT_EXT_VAL_MASK;

am I missing something?

thanks!
-- 
davide


