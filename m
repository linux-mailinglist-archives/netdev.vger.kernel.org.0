Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C013727B4DA
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 20:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgI1S4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 14:56:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22639 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726465AbgI1S4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 14:56:21 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601319380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LX9EkjKXCfWr+uMcns9oRXa7i+EtTGKx0ziQEjnp1u8=;
        b=ZQSoaetal+rBa/CZcU8tT29jG+Dfcnc6LSiFL4sjGkLnzHfzusaTgixhyXr/nGDTpLOAM8
        Khhye1ufjaribvMHW14AYDDgDhiRYKGFILsk6dcDUBG4JEGeEEcRIPHeqYn2CyN4KjaIoZ
        Zds21Q+WCHXsu+W+oynIp7DibH7nJwY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-4f40Pd8FOh2cJP3tL4tUCw-1; Mon, 28 Sep 2020 14:56:14 -0400
X-MC-Unique: 4f40Pd8FOh2cJP3tL4tUCw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6A431DDED;
        Mon, 28 Sep 2020 18:56:12 +0000 (UTC)
Received: from new-host-6 (unknown [10.40.192.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 14CD155763;
        Mon, 28 Sep 2020 18:56:10 +0000 (UTC)
Message-ID: <099865ee80d0a1b14b676eaa20fa7b6160f4dba0.camel@redhat.com>
Subject: Re: [Patch net] net_sched: remove a redundant goto chain check
From:   Davide Caratti <dcaratti@redhat.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     Vlad Buslov <vladbu@mellanox.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
In-Reply-To: <20200928183103.28442-1-xiyou.wangcong@gmail.com>
References: <20200928183103.28442-1-xiyou.wangcong@gmail.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Mon, 28 Sep 2020 20:56:10 +0200
MIME-Version: 1.0
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-09-28 at 11:31 -0700, Cong Wang wrote:
> All TC actions call tcf_action_check_ctrlact() to validate
> goto chain, so this check in tcf_action_init_1() is actually
> redundant. Remove it to save troubles of leaking memory.
> 
> Fixes: e49d8c22f126 ("net_sched: defer tcf_idr_insert() in tcf_action_init_1()")
> Reported-by: Vlad Buslov <vladbu@mellanox.com>
> Suggested-by: Davide Caratti <dcaratti@redhat.com>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---
>  net/sched/act_api.c | 14 --------------
>  1 file changed, 14 deletions(-)
> 
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index 104b47f5184f..5612b336e18e 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -722,13 +722,6 @@ int tcf_action_destroy(struct tc_action *actions[], int bind)
>  	return ret;
>  }
>  
> -static int tcf_action_destroy_1(struct tc_action *a, int bind)
> -{
> -	struct tc_action *actions[] = { a, NULL };
> -
> -	return tcf_action_destroy(actions, bind);
> -}
> -
>  static int tcf_action_put(struct tc_action *p)
>  {
>  	return __tcf_action_put(p, false);
> @@ -1000,13 +993,6 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
>  	if (err < 0)
>  		goto err_mod;
>  
> -	if (TC_ACT_EXT_CMP(a->tcfa_action, TC_ACT_GOTO_CHAIN) &&
> -	    !rcu_access_pointer(a->goto_chain)) {
> -		tcf_action_destroy_1(a, bind);
> -		NL_SET_ERR_MSG(extack, "can't use goto chain with NULL chain");
> -		return ERR_PTR(-EINVAL);
> -	}
> -
>  	if (!name && tb[TCA_ACT_COOKIE])
>  		tcf_set_action_cookie(&a->act_cookie, cookie);
>  

Reviewed-by: Davide Caratti <dcaratti@redhat.com>

thanks!
-- 
davide

