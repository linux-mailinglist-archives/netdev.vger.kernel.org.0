Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 880A021DE46
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 19:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729784AbgGMRLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 13:11:45 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:55634 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728466AbgGMRLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 13:11:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594660302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZlprtXJWI0Kc9ipD9Ri9S4uqmWTXXaIuUJO58RLmYI0=;
        b=T9hxT/7dR08i74DKlfnJP1m3lP2Dy7fpL2auGcFBO8ka3I8bpdBsPKq2qaqrSsFpvmPkQ0
        GfiwWgOl3iITzs/w5kfGO9VRsqiceVyozNFpB8oxVlOhGpPCHdPr7M+F+g5xKSY8Oygtvk
        Kq1qWB0iCiRiTZyWzBNUQExZKqPB/6k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-VMAS8b57MCWZwaUnyCcAKQ-1; Mon, 13 Jul 2020 13:11:40 -0400
X-MC-Unique: VMAS8b57MCWZwaUnyCcAKQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B34BB800685;
        Mon, 13 Jul 2020 17:11:38 +0000 (UTC)
Received: from new-host-6 (unknown [10.40.194.133])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 408915BAD5;
        Mon, 13 Jul 2020 17:11:36 +0000 (UTC)
Message-ID: <69a3407fa53431bebfd937a579b4f270a129395c.camel@redhat.com>
Subject: Re: [PATCH net-next v3 1/4] net/sched: Add skb->hash field editing
 via act_skbedit
From:   Davide Caratti <dcaratti@redhat.com>
To:     Ariel Levkovich <lariel@mellanox.com>, netdev@vger.kernel.org
Cc:     jiri@resnulli.us, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        Jiri Pirko <jiri@mellanox.com>
In-Reply-To: <20200711212848.20914-2-lariel@mellanox.com>
References: <20200711212848.20914-1-lariel@mellanox.com>
         <20200711212848.20914-2-lariel@mellanox.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Mon, 13 Jul 2020 19:11:35 +0200
MIME-Version: 1.0
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2020-07-12 at 00:28 +0300, Ariel Levkovich wrote:
> Extend act_skbedit api to allow writing into skb->hash
> field.
> 
[...]

> Usage example:
> 
> $ tc filter add dev ens1f0_0 ingress \
> prio 1 chain 0 proto ip \
> flower ip_proto tcp \
> action skbedit hash asym_l4 basis 5 \
> action goto chain 2

hello Ariel, thanks for the patch!

> Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  include/net/tc_act/tc_skbedit.h        |  2 ++
>  include/uapi/linux/tc_act/tc_skbedit.h |  7 +++++
>  net/sched/act_skbedit.c                | 38 ++++++++++++++++++++++++++
>  3 files changed, 47 insertions(+)

this diffstat is ok for l4 hash calculation :)

> diff --git a/include/net/tc_act/tc_skbedit.h b/include/net/tc_act/tc_skbedit.h
> index 00bfee70609e..44a8a4625556 100644
> --- a/include/net/tc_act/tc_skbedit.h
> +++ b/include/net/tc_act/tc_skbedit.h
> @@ -18,6 +18,8 @@ struct tcf_skbedit_params {
>  	u32 mask;
>  	u16 queue_mapping;
>  	u16 ptype;
> +	u32 hash_alg;
> +	u32 hash_basis;
>  	struct rcu_head rcu;
>  };
>  
> diff --git a/include/uapi/linux/tc_act/tc_skbedit.h b/include/uapi/linux/tc_act/tc_skbedit.h
> index 800e93377218..5877811b093b 100644
> --- a/include/uapi/linux/tc_act/tc_skbedit.h
> +++ b/include/uapi/linux/tc_act/tc_skbedit.h
> @@ -29,6 +29,11 @@
>  #define SKBEDIT_F_PTYPE			0x8
>  #define SKBEDIT_F_MASK			0x10
>  #define SKBEDIT_F_INHERITDSFIELD	0x20
> +#define SKBEDIT_F_HASH			0x40
> +
> +enum {
> +	TCA_SKBEDIT_HASH_ALG_ASYM_L4,
> +};

nit:

it's a common practice, when specifying enums in the uAPI, to set the
first value  "UNSPEC", and last one as "MAX":

enum {
	TCA_SKBEDIT_HASH_ALG_UNSPEC,
	TCA_SKBEDIT_HASH_ALG_ASYM_L4,
	__TCA_SKBEDIT_HASH_ALG_MAX
};

see below the rationale:

>  struct tc_skbedit {
>  	tc_gen;
> @@ -45,6 +50,8 @@ enum {
>  	TCA_SKBEDIT_PTYPE,
>  	TCA_SKBEDIT_MASK,
>  	TCA_SKBEDIT_FLAGS,
> +	TCA_SKBEDIT_HASH,
> +	TCA_SKBEDIT_HASH_BASIS,
>  	__TCA_SKBEDIT_MAX
>  };
>  #define TCA_SKBEDIT_MAX (__TCA_SKBEDIT_MAX - 1)
> diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
> index b125b2be4467..2cc66c798afb 100644
> --- a/net/sched/act_skbedit.c
> +++ b/net/sched/act_skbedit.c
> @@ -66,6 +66,20 @@ static int tcf_skbedit_act(struct sk_buff *skb, const struct tc_action *a,
>  	}
>  	if (params->flags & SKBEDIT_F_PTYPE)
>  		skb->pkt_type = params->ptype;
> +
> +	if (params->flags & SKBEDIT_F_HASH) {
> +		u32 hash;
> +
> +		hash = skb_get_hash(skb);
> +		/* If a hash basis was provided, add it into
> +		 * hash calculation here and re-set skb->hash
> +		 * to the new result with sw_hash indication
> +		 * and keeping the l4 hash indication.
> +		 */
> +		hash = jhash_1word(hash, params->hash_basis);
> +		__skb_set_sw_hash(skb, hash, skb->l4_hash);
> +	}

in this way you don't need to define a value in 'flags'
(SKBEDIT_F_HASH), you just need to check if params->hash_alg is not
zero:
	if (params->hash_alg) {
		....
	}

>  	return action;
>  
>  err:
> @@ -91,6 +105,8 @@ static const struct nla_policy skbedit_policy[TCA_SKBEDIT_MAX + 1] = {
>  	[TCA_SKBEDIT_PTYPE]		= { .len = sizeof(u16) },
>  	[TCA_SKBEDIT_MASK]		= { .len = sizeof(u32) },
>  	[TCA_SKBEDIT_FLAGS]		= { .len = sizeof(u64) },
> +	[TCA_SKBEDIT_HASH]		= { .len = sizeof(u32) },
> +	[TCA_SKBEDIT_HASH_BASIS]	= { .len = sizeof(u32) },
>  };
>  
>  static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
> @@ -107,6 +123,7 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
>  	struct tcf_skbedit *d;
>  	u32 flags = 0, *priority = NULL, *mark = NULL, *mask = NULL;
>  	u16 *queue_mapping = NULL, *ptype = NULL;
> +	u32 hash_alg, hash_basis = 0;
>  	bool exists = false;
>  	int ret = 0, err;
>  	u32 index;
> @@ -156,6 +173,17 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
>  			flags |= SKBEDIT_F_INHERITDSFIELD;
>  	}
>  
> +	if (tb[TCA_SKBEDIT_HASH] != NULL) {
> +		hash_alg = nla_get_u32(tb[TCA_SKBEDIT_HASH]);
> +		if (hash_alg > TCA_SKBEDIT_HASH_ALG_ASYM_L4)
> +			return -EINVAL;

moreover, even without doing the strict validation, when somebody in the
future will extend the uAPI, he will not need to change the line above.
The following test will validate all good values of hash_alg:

	if (!hash_alg || hash_alg >= __TCA_SKBEDIT_HASH_ALG_MAX) {
		NL_SET_ERR_MSG_MOD(extack, "hash_alg is out of range");
		return -EINVAL;
 	}

WDYT?

thanks!
-- 
davide


