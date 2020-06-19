Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DED020187E
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 19:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405783AbgFSQs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 12:48:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32480 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387586AbgFSOkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 10:40:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592577601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8x5pPzHRuQ7vy3zho8hslSw3CNin95A5QClwfR488ng=;
        b=hWS/1aDer2BhTjEntzoasdGcgD2pjIc9WUfJfPNfZD6lvsFHIJ3Zg96B3fyTcf0vAIDTFN
        gpF2x5FO6R/ZZg6VtHBPYxf9DoT/Ql15LQPzXW7fWj/E/QhHGfmm/210p04pe2R54bJTV1
        MyQpUqWlIfn3RfE64SEDTfvrtwpW53A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-cKEJ4l9lPByUuTS9Z4YPUw-1; Fri, 19 Jun 2020 10:39:55 -0400
X-MC-Unique: cKEJ4l9lPByUuTS9Z4YPUw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5CCF61005512;
        Fri, 19 Jun 2020 14:39:53 +0000 (UTC)
Received: from new-host-5 (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA71F71660;
        Fri, 19 Jun 2020 14:39:50 +0000 (UTC)
Message-ID: <6452573463a251b7ec2debc0e5d9d9fad4767352.camel@redhat.com>
Subject: Re: [PATCH net-next 1/3] net/sched: Introduce action hash
From:   Davide Caratti <dcaratti@redhat.com>
To:     Ariel Levkovich <lariel@mellanox.com>, netdev@vger.kernel.org
Cc:     jiri@resnulli.us, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        Jiri Pirko <jiri@mellanox.com>
In-Reply-To: <20200618221548.3805-2-lariel@mellanox.com>
References: <20200618221548.3805-1-lariel@mellanox.com>
         <20200618221548.3805-2-lariel@mellanox.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Fri, 19 Jun 2020 16:39:49 +0200
MIME-Version: 1.0
User-Agent: Evolution 3.36.1 (3.36.1-1.fc32) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello Ariel,

thanks for the patch,

On Fri, 2020-06-19 at 01:15 +0300, Ariel Levkovich wrote:
> Allow setting a hash value to a packet for a future match.
> 
> The action will determine the packet's hash result according to
> the selected hash type.

> The first option is to select a basic asymmetric l4 hash calculation
> on the packet headers which will either use the skb->hash value as
> if such was already calculated and set by the device driver, or it
> will perform the kernel jenkins hash function on the packet which will
> generate the result otherwise.

If I understand correctly, this action is going to change a metadata of
the skb based on some operation done on the packet. Linux has already a
module that does this job, it's act_skbedit.

## proposal ##

Wouldn't it be possible to extend act_skbedit instead of adding a new tc
action? that would save us from some bugs we already encountered in the
past (maybe I saw a couple of them below), and we would also leverage on
the existing tests.

> The other option is for user to provide an BPF program which is
> dedicated to calculate the hash. In such case the program is loaded
> and used by tc to perform the hash calculation and provide it to
> the hash action to be stored in skb->hash field.
> 
> The BPF option can be useful for future HW offload support of the hash
> calculation by emulating the HW hash function when it's different than
> the kernel's but yet we want to maintain consistency between the SW and
> the HW.

Like Daniel noticed, this can be done by act_bpf. Using 'jump' or
'goto_chain' control actions we should get to the same result combining
act_skbedit and act_bpf, wdyt?

> Usage is as follows:
> 
> $ tc filter add dev ens1f0_0 ingress \
> prio 1 chain 0 proto ip \
> flower ip_proto tcp \
> action hash bpf object-file <bpf file> \
> action goto chain 2
> 
> $ tc filter add dev ens1f0_0 ingress \
> prio 1 chain 0 proto ip \
> flower ip_proto udp \
> action hash asym_l4 basis <basis> \
> action goto chain 2
> 
> Matching on the result:
> $ tc filter add dev ens1f0_0 ingress \
> prio 1 chain 2 proto ip \
> flower hash 0x0/0xf  \
> action mirred egress redirect dev ens1f0_1
> 
> $ tc filter add dev ens1f0_0 ingress \
> prio 1 chain 2 proto ip \
> flower hash 0x1/0xf  \
> action mirred egress redirect dev ens1f0_2
> 
> Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  include/net/act_api.h               |   2 +
>  include/net/tc_act/tc_hash.h        |  22 ++
>  include/uapi/linux/pkt_cls.h        |   1 +
>  include/uapi/linux/tc_act/tc_hash.h |  32 +++
>  net/sched/Kconfig                   |  11 +
>  net/sched/Makefile                  |   1 +
>  net/sched/act_hash.c                | 376 ++++++++++++++++++++++++++++
>  net/sched/cls_api.c                 |   1 +
>  8 files changed, 446 insertions(+)
>  create mode 100644 include/net/tc_act/tc_hash.h
>  create mode 100644 include/uapi/linux/tc_act/tc_hash.h
>  create mode 100644 net/sched/act_hash.c
> 
> diff --git a/include/net/act_api.h b/include/net/act_api.h
> index 8c3934880670..b7e5d060bd2f 100644
> --- a/include/net/act_api.h
> +++ b/include/net/act_api.h
> @@ -12,6 +12,8 @@
>  #include <net/net_namespace.h>
>  #include <net/netns/generic.h>
>  
> +#define ACT_BPF_NAME_LEN	256
> +

(BTW, line above seems to be a leftover)

>  struct tcf_idrinfo {
>  	struct mutex	lock;
>  	struct idr	action_idr;
> 
[...]

> new file mode 100644
> index 000000000000..40a5c34f8745
> --- /dev/null
> +++ b/net/sched/act_hash.c
> @@ -0,0 +1,376 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/* -
> + * net/sched/act_hash.c  Hash calculation action
> + *
> + * Author:   Ariel Levkovich <lariel@mellanox.com>
> + */
> +
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/rtnetlink.h>
> +#include <linux/skbuff.h>
> +#include <linux/filter.h>
> +#include <net/netlink.h>
> +#include <net/pkt_sched.h>
> +#include <net/pkt_cls.h>
> +#include <linux/tc_act/tc_hash.h>
> +#include <net/tc_act/tc_hash.h>
> +
> +#define ACT_HASH_BPF_NAME_LEN	256
> +
> +static unsigned int hash_net_id;
> +static struct tc_action_ops act_hash_ops;
> +
> +static int tcf_hash_act(struct sk_buff *skb, const struct tc_action *a,
> +			struct tcf_result *res)
> +{
> +	struct tcf_hash *h = to_hash(a);
> +	struct tcf_hash_params *p;
> +	int action;
> +	u32 hash;
> +
> +	tcf_lastuse_update(&h->tcf_tm);
> +	tcf_action_update_bstats(&h->common, skb);
> +
> +	p = rcu_dereference_bh(h->hash_p);
> +
> +	action = READ_ONCE(h->tcf_action);
> +
> +	switch (p->alg) {
> +	case TCA_HASH_ALG_L4:
> +		hash = skb_get_hash(skb);
> +		/* If a hash basis was provided, add it into
> +		 * hash calculation here and re-set skb->hash
> +		 * to the new result with sw_hash indication
> +		 * and keeping the l4 hash indication.
> +		 */
> +		hash = jhash_1word(hash, p->basis);
> +		__skb_set_sw_hash(skb, hash, skb->l4_hash);

my proposal is to move the above line to the data path of act_skbedit, and
extend the control plane accordingly.

> +		break;
> +	case TCA_HASH_ALG_BPF:

here the code is assuming that the action is at tc ingress. But
theoretically we could install this action also on egress, nobody is
forbidding that.  whouldn't it be better to add proper checks (or using
directly act_bpf with appropriate control action, that already does this
job)?

> +		__skb_push(skb, skb->mac_len);
> +		bpf_compute_data_pointers(skb);
> +		hash = BPF_PROG_RUN(p->prog, skb);
> +		__skb_pull(skb, skb->mac_len);
> +		/* The BPF program hash function type is
> +		 * unknown so only the sw hash bit is set.
> +		 */
> +		__skb_set_sw_hash(skb, hash, false);
> +		break;
> +	}
> +	return action;
> +}
> +
> +static const struct nla_policy hash_policy[TCA_HASH_MAX + 1] = {
> +	[TCA_HASH_PARMS]	= { .type = NLA_EXACT_LEN, .len = sizeof(struct tc_hash) },
> +	[TCA_HASH_ALG]		= { .type = NLA_U32 },
> +	[TCA_HASH_BASIS]	= { .type = NLA_U32 },
> +	[TCA_HASH_BPF_FD]	= { .type = NLA_U32 },
> +	[TCA_HASH_BPF_NAME]	= { .type = NLA_NUL_STRING,
> +				    .len = ACT_HASH_BPF_NAME_LEN },
> +};
> +
> +static int tcf_hash_bpf_init(struct nlattr **tb, struct tcf_hash_params *params)
> +{
> +	struct bpf_prog *fp;
> +	char *name = NULL;
> +	u32 bpf_fd;
> +
> +	bpf_fd = nla_get_u32(tb[TCA_HASH_BPF_FD]);

shouldn't we check for non-NULL tb[TCA_HASH_BPF_FD] to avoid a crash here?
please note, act_bpf does it:

https://elixir.bootlin.com/linux/v5.8-rc1/source/net/sched/act_bpf.c#L337

> +
> +	fp = bpf_prog_get_type(bpf_fd, BPF_PROG_TYPE_SCHED_ACT);
> +	if (IS_ERR(fp))
> +		return PTR_ERR(fp);
> +
> +	if (tb[TCA_HASH_BPF_NAME]) {
> +		name = nla_memdup(tb[TCA_HASH_BPF_NAME], GFP_KERNEL);
> +		if (!name) {
> +			bpf_prog_put(fp);
> +			return -ENOMEM;
> +		}
> +	}
> +
> +	params->bpf_name = name;
> +	params->prog = fp;
> +
> +	return 0;
> +}
> +
> +static void tcf_hash_bpf_cleanup(struct tcf_hash_params *params)
> +{
> +	if (params->prog)
> +		bpf_prog_put(params->prog);
> +
> +	kfree(params->bpf_name);
> +}
> +
> +static int tcf_hash_init(struct net *net, struct nlattr *nla,
> +			 struct nlattr *est, struct tc_action **a,
> +			 int replace, int bind, bool rtnl_held,
> +			 struct tcf_proto *tp, u32 flags,
> +			 struct netlink_ext_ack *extack)
> +{
> +	struct tc_action_net *tn = net_generic(net, hash_net_id);
> +	struct tcf_hash_params *params, old;
> +	struct nlattr *tb[TCA_HASH_MAX + 1];
> +	struct tcf_chain *goto_ch = NULL;
> +	struct tcf_hash_params *p = NULL;
> +	struct tc_hash *parm;
> +	struct tcf_hash *h;
> +	int err, res = 0;
> +	u32 index;
> +
> +	if (!nla) {
> +		NL_SET_ERR_MSG_MOD(extack, "Hash requires attributes to be passed");
> +		return -EINVAL;
> +	}
> +
> +	err = nla_parse_nested(tb, TCA_HASH_MAX, nla, hash_policy, extack);
> +	if (err < 0)
> +		return err;
> +
> +	if (!tb[TCA_HASH_PARMS]) {
> +		NL_SET_ERR_MSG_MOD(extack, "Missing required hash parameters");
> +		return -EINVAL;
> +	}
> +	parm = nla_data(tb[TCA_HASH_PARMS]);
> +	index = parm->index;
> +
> +	err = tcf_idr_check_alloc(tn, &index, a, bind);
> +	if (err < 0)
> +		return err;
> +
> +	if (!err) {
> +		err = tcf_idr_create_from_flags(tn, index, est, a,
> +						&act_hash_ops, bind, flags);
> +		if (err) {
> +			tcf_idr_cleanup(tn, index);
> +			return err;
> +		}
> +		res = ACT_P_CREATED;
> +	} else {
> +		if (bind)
> +			return 0;
> +
> +		if (!replace) {
> +			tcf_idr_release(*a, bind);
> +			return -EEXIST;
> +		}
> +	}
> +	err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
> +	if (err < 0)
> +		goto release_idr;
> +
> +	h = to_hash(*a);
> +
> +	p = kzalloc(sizeof(*p), GFP_KERNEL);
> +	if (unlikely(!p)) {
> +		err = -ENOMEM;
> +		goto cleanup;
> +	}
> +
> +	if (!tb[TCA_HASH_ALG]) {
> +		NL_SET_ERR_MSG_MOD(extack, "Missing hash algorithm selection");
> +		err = -EINVAL;
> +		goto cleanup;
> +	}
> +
> +	p->alg = nla_get_u32(tb[TCA_HASH_ALG]);

I don't understand why of 'p->alg' is assigned and then validated.
Wouldn't it be better to validate it earlier? this would also avoid the
spin_lock unbalance below:

> +	spin_lock_bh(&h->tcf_lock);
> +
> +	switch (p->alg) {
> +	case TCA_HASH_ALG_L4:
> +		break;
> +	case TCA_HASH_ALG_BPF:
> +		if (res != ACT_P_CREATED) {
> +			params = rcu_dereference_protected(h->hash_p, 1);
> +			old.prog = params->prog;
> +			old.bpf_name = params->bpf_name;
> +		}
> +
> +		err = tcf_hash_bpf_init(tb, p);
> +		if (err)
> +			goto cleanup;

shouldn't we spin_unlock_bh() here?
> +
> +		break;
> +	default:
> +		NL_SET_ERR_MSG_MOD(extack, "Hash type not supported");
> +		err = -EINVAL;
> +		goto cleanup;

shouldn't we spin_unlock_bh() here?
> +	}
> +	if (tb[TCA_HASH_BASIS])
> +		p->basis = nla_get_u32(tb[TCA_HASH_BASIS]);
> +
> +	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
> +	p = rcu_replace_pointer(h->hash_p, p,
> +				lockdep_is_held(&h->tcf_lock));
> +	spin_unlock_bh(&h->tcf_lock);
> +
> +	if (goto_ch)
> +		tcf_chain_put_by_act(goto_ch);
> +	if (p)
> +		kfree_rcu(p, rcu);
> +
> +	if (res == ACT_P_CREATED) {
> +		tcf_idr_insert(tn, *a);
> +	} else {
> +		synchronize_rcu();
> +		tcf_hash_bpf_cleanup(&old);
> +	}
> +
> +	return res;
> +
> +cleanup:
> +	if (goto_ch)
> +		tcf_chain_put_by_act(goto_ch);
> +	kfree(p);
> +
> +release_idr:
> +	tcf_idr_release(*a, bind);
> +	return err;
> +}


thank you in advance for any feedback!
-- 
davide

