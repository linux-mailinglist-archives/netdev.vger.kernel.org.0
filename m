Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8D1B396CBD
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 07:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232707AbhFAFX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 01:23:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:36928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230170AbhFAFXT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 01:23:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0E09610A8;
        Tue,  1 Jun 2021 05:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622524898;
        bh=VbY9+aw50Mw1X+tkAaC/07vtiyWYtYiNQpRbMuWfUGg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YEtKclukGUSHJ8R4id5+fqd/XKNBJbvlPJUhQljkaPpC9oM4Y1XE1N0aG8ylSGJFs
         FoyvuEn6GP2E7Aromq2f4lJ77SQUsJlqaVWS69w3ptaMAbw//EWigvoLbIFk2Hk1/K
         6k8UpCWoZlzNToU1+pGBFVR/Ibd20lo9NYIdcdrMpZx37gu9F689KHRnoxVkYGnj3K
         EQfzTve7V95rZChn3S8kUM5SXK2YtxG4CSTnNOiZ9Rk1f2dkTyiXBkomFxbscfg2nS
         mHRuShS7vhAmvM2QDGpbpkb8uRzvjQErlrFpnGrQVEJ07/6DxO/pdpw7w+2ZioXyXV
         tMa/4MDmuhH7Q==
Date:   Mon, 31 May 2021 22:21:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        linux-kselftest@vger.kernel.org, shuah@kernel.org,
        Ilya Lifshits <ilya.lifshits@broadcom.com>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>
Subject: Re: [PATCH net-next v3 2/3] net/sched: act_vlan: No dump for unset
 priority
Message-ID: <20210531222136.26670598@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210530114052.16483-3-boris.sukholitko@broadcom.com>
References: <20210530114052.16483-1-boris.sukholitko@broadcom.com>
        <20210530114052.16483-3-boris.sukholitko@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 30 May 2021 14:40:51 +0300 Boris Sukholitko wrote:
> diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
> index a108469c664f..ccd1acfa4c55 100644
> --- a/net/sched/act_vlan.c
> +++ b/net/sched/act_vlan.c
> @@ -307,8 +307,8 @@ static int tcf_vlan_dump(struct sk_buff *skb, struct tc_action *a,
>  	    (nla_put_u16(skb, TCA_VLAN_PUSH_VLAN_ID, p->tcfv_push_vid) ||
>  	     nla_put_be16(skb, TCA_VLAN_PUSH_VLAN_PROTOCOL,
>  			  p->tcfv_push_proto) ||
> -	     (nla_put_u8(skb, TCA_VLAN_PUSH_VLAN_PRIORITY,
> -					      p->tcfv_push_prio))))
> +	     (p->tcfv_push_prio_exists &&
> +	      nla_put_u8(skb, TCA_VLAN_PUSH_VLAN_PRIORITY, p->tcfv_push_prio))))
>  		goto nla_put_failure;
>  
>  	if (p->tcfv_action == TCA_VLAN_ACT_PUSH_ETH) {
> @@ -362,10 +362,19 @@ static int tcf_vlan_search(struct net *net, struct tc_action **a, u32 index)
>  
>  static size_t tcf_vlan_get_fill_size(const struct tc_action *act)
>  {
> -	return nla_total_size(sizeof(struct tc_vlan))
> +	struct tcf_vlan *v = to_vlan(act);
> +	struct tcf_vlan_params *p;
> +	size_t ret = nla_total_size(sizeof(struct tc_vlan))
>  		+ nla_total_size(sizeof(u16)) /* TCA_VLAN_PUSH_VLAN_ID */
> -		+ nla_total_size(sizeof(u16)) /* TCA_VLAN_PUSH_VLAN_PROTOCOL */
> -		+ nla_total_size(sizeof(u8)); /* TCA_VLAN_PUSH_VLAN_PRIORITY */
> +		+ nla_total_size(sizeof(u16)); /* TCA_VLAN_PUSH_VLAN_PROTOCOL */
> +
> +	spin_lock_bh(&v->tcf_lock);
> +	p = rcu_dereference_protected(v->vlan_p, lockdep_is_held(&v->tcf_lock));
> +	if (p->tcfv_push_prio_exists)
> +		ret += nla_total_size(sizeof(u8)); /* TCA_VLAN_PUSH_VLAN_PRIORITY */
> +	spin_unlock_bh(&v->tcf_lock);

This jumps out a little bit - if we need to take this lock to inspect
tcf_vlan_params, then I infer its value may change. And if it may
change what guarantees it doesn't change between calculating the skb
length and dumping?

It's common practice to calculate the max skb len required when
attributes are this small.

> +	return ret;
>  }
