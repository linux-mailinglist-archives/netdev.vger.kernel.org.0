Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB443278C87
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 17:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729323AbgIYPY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 11:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728678AbgIYPY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 11:24:27 -0400
Received: from mail.buslov.dev (mail.buslov.dev [IPv6:2001:19f0:5001:2e3f:5400:1ff:feed:a259])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A601DC0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 08:24:27 -0700 (PDT)
Received: from vlad-x1g6 (unknown [IPv6:2a0b:2bc3:193f:1:a5fe:a7d6:6345:fe8d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.buslov.dev (Postfix) with ESMTPSA id 516BB20B41;
        Fri, 25 Sep 2020 18:24:22 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=buslov.dev; s=2019;
        t=1601047462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CsDnlGwoLEAOt5uP1AbU2izGCrkoukLcQEo5gj5Jh+A=;
        b=LOgLwBjRvUn+S1mbBOTEeQL05zPhRb0lQeU82DyVfPh367/4rQFpijw9SWDIM7BBZXnjER
        /aBa9tN7LeJz2KMVwnPHzQ3iCBQY8TfXkEmB98O6SmjIYyioh1o7mOqVRmGn28NeFB/LEp
        Sc1+027aPtLS/u4YU9iA5iXHN9lRFUuN3gdjcxqX+Q96cG/g/RBg86fjlHz3bKnIK9//gQ
        bCye9pAr7mZY2EBopQ2Vy0IjuaNfIahEMIAb0Ax3kTB0sUWdTvykpeZy+T0u4sWSp/UzYv
        KA96TKt1S+k8NlK9KYNIPi9s4+zq1usbZDyPCfrATpsJw8xkdX3AegBeX3EsMA==
References: <20200923035624.7307-1-xiyou.wangcong@gmail.com> <20200923035624.7307-2-xiyou.wangcong@gmail.com>
User-agent: mu4e 1.4.13; emacs 26.3
From:   Vlad Buslov <vlad@buslov.dev>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [Patch net 1/2] net_sched: defer tcf_idr_insert() in tcf_action_init_1()
In-reply-to: <20200923035624.7307-2-xiyou.wangcong@gmail.com>
Date:   Fri, 25 Sep 2020 18:24:21 +0300
Message-ID: <877dsh98wq.fsf@buslov.dev>
MIME-Version: 1.0
Content-Type: text/plain
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=vlad@buslov.dev smtp.mailfrom=vlad@buslov.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 23 Sep 2020 at 06:56, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> All TC actions call tcf_idr_insert() for new action at the end
> of their ->init(), so we can actually move it to a central place
> in tcf_action_init_1().
>
> And once the action is inserted into the global IDR, other parallel
> process could free it immediately as its refcnt is still 1, so we can
> not fail after this, we need to move it after the goto action
> validation to avoid handling the failure case after insertion.
>
> This is found during code review, is not directly triggered by syzbot.
> And this prepares for the next patch.
>
> Cc: Vlad Buslov <vladbu@mellanox.com>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---

Hi Cong,

Thanks for fixing this!

>  include/net/act_api.h      |  2 --
>  net/sched/act_api.c        | 38 ++++++++++++++++++++------------------
>  net/sched/act_bpf.c        |  4 +---
>  net/sched/act_connmark.c   |  1 -
>  net/sched/act_csum.c       |  3 ---
>  net/sched/act_ct.c         |  2 --
>  net/sched/act_ctinfo.c     |  3 ---
>  net/sched/act_gact.c       |  2 --
>  net/sched/act_gate.c       |  3 ---
>  net/sched/act_ife.c        |  3 ---
>  net/sched/act_ipt.c        |  2 --
>  net/sched/act_mirred.c     |  2 --
>  net/sched/act_mpls.c       |  2 --
>  net/sched/act_nat.c        |  3 ---
>  net/sched/act_pedit.c      |  2 --
>  net/sched/act_police.c     |  2 --
>  net/sched/act_sample.c     |  2 --
>  net/sched/act_simple.c     |  2 --
>  net/sched/act_skbedit.c    |  2 --
>  net/sched/act_skbmod.c     |  2 --
>  net/sched/act_tunnel_key.c |  3 ---
>  net/sched/act_vlan.c       |  2 --
>  22 files changed, 21 insertions(+), 66 deletions(-)
>
> diff --git a/include/net/act_api.h b/include/net/act_api.h
> index cb382a89ea58..87214927314a 100644
> --- a/include/net/act_api.h
> +++ b/include/net/act_api.h
> @@ -166,8 +166,6 @@ int tcf_idr_create_from_flags(struct tc_action_net *tn, u32 index,
>  			      struct nlattr *est, struct tc_action **a,
>  			      const struct tc_action_ops *ops, int bind,
>  			      u32 flags);
> -void tcf_idr_insert(struct tc_action_net *tn, struct tc_action *a);
> -
>  void tcf_idr_cleanup(struct tc_action_net *tn, u32 index);
>  int tcf_idr_check_alloc(struct tc_action_net *tn, u32 *index,
>  			struct tc_action **a, int bind);
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index 063d8aaf2900..0030f00234ee 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -467,17 +467,6 @@ int tcf_idr_create_from_flags(struct tc_action_net *tn, u32 index,
>  }
>  EXPORT_SYMBOL(tcf_idr_create_from_flags);
>  
> -void tcf_idr_insert(struct tc_action_net *tn, struct tc_action *a)
> -{
> -	struct tcf_idrinfo *idrinfo = tn->idrinfo;
> -
> -	mutex_lock(&idrinfo->lock);
> -	/* Replace ERR_PTR(-EBUSY) allocated by tcf_idr_check_alloc */
> -	WARN_ON(!IS_ERR(idr_replace(&idrinfo->action_idr, a, a->tcfa_index)));
> -	mutex_unlock(&idrinfo->lock);
> -}
> -EXPORT_SYMBOL(tcf_idr_insert);
> -
>  /* Cleanup idr index that was allocated but not initialized. */
>  
>  void tcf_idr_cleanup(struct tc_action_net *tn, u32 index)
> @@ -902,6 +891,16 @@ static const struct nla_policy tcf_action_policy[TCA_ACT_MAX + 1] = {
>  	[TCA_ACT_HW_STATS]	= NLA_POLICY_BITFIELD32(TCA_ACT_HW_STATS_ANY),
>  };
>  
> +static void tcf_idr_insert(struct tc_action *a)
> +{
> +	struct tcf_idrinfo *idrinfo = a->idrinfo;
> +
> +	mutex_lock(&idrinfo->lock);
> +	/* Replace ERR_PTR(-EBUSY) allocated by tcf_idr_check_alloc */
> +	WARN_ON(!IS_ERR(idr_replace(&idrinfo->action_idr, a, a->tcfa_index)));
> +	mutex_unlock(&idrinfo->lock);
> +}
> +
>  struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
>  				    struct nlattr *nla, struct nlattr *est,
>  				    char *name, int ovr, int bind,
> @@ -989,6 +988,16 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
>  	if (err < 0)
>  		goto err_mod;
>  
> +	if (TC_ACT_EXT_CMP(a->tcfa_action, TC_ACT_GOTO_CHAIN) &&
> +	    !rcu_access_pointer(a->goto_chain)) {
> +		tcf_action_destroy_1(a, bind);
> +		NL_SET_ERR_MSG(extack, "can't use goto chain with NULL chain");
> +		return ERR_PTR(-EINVAL);
> +	}

I don't think calling tcf_action_destoy_1() is enough here. Since you
moved this block before assigning cookie and releasing the module, you
also need to release them manually in addition to destroying the action
instance.

> +
> +	if (err == ACT_P_CREATED)
> +		tcf_idr_insert(a);
> +
>  	if (!name && tb[TCA_ACT_COOKIE])
>  		tcf_set_action_cookie(&a->act_cookie, cookie);
>  
> @@ -1002,13 +1011,6 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
>  	if (err != ACT_P_CREATED)
>  		module_put(a_o->owner);
>  
> -	if (TC_ACT_EXT_CMP(a->tcfa_action, TC_ACT_GOTO_CHAIN) &&
> -	    !rcu_access_pointer(a->goto_chain)) {
> -		tcf_action_destroy_1(a, bind);
> -		NL_SET_ERR_MSG(extack, "can't use goto chain with NULL chain");
> -		return ERR_PTR(-EINVAL);
> -	}
> -
>  	return a;
>  
>  err_mod:

[...]

