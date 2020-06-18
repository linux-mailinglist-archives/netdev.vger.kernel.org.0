Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C331FFED5
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 01:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgFRXm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 19:42:58 -0400
Received: from www62.your-server.de ([213.133.104.62]:49030 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbgFRXm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 19:42:57 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jm4BL-0008RY-6J; Fri, 19 Jun 2020 01:42:55 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jm4BK-000VEZ-S3; Fri, 19 Jun 2020 01:42:54 +0200
Subject: Re: [PATCH net-next 1/3] net/sched: Introduce action hash
To:     Ariel Levkovich <lariel@mellanox.com>, netdev@vger.kernel.org
Cc:     jiri@resnulli.us, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, ast@kernel.org,
        Jiri Pirko <jiri@mellanox.com>, bpf@vger.kernel.org
References: <20200618221548.3805-1-lariel@mellanox.com>
 <20200618221548.3805-2-lariel@mellanox.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <830de215-ec74-1c96-4a41-7b07608e3407@iogearbox.net>
Date:   Fri, 19 Jun 2020 01:42:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200618221548.3805-2-lariel@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25847/Thu Jun 18 14:58:52 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/19/20 12:15 AM, Ariel Levkovich wrote:
> Allow setting a hash value to a packet for a future match.
> 
> The action will determine the packet's hash result according to
> the selected hash type.
> 
> The first option is to select a basic asymmetric l4 hash calculation
> on the packet headers which will either use the skb->hash value as
> if such was already calculated and set by the device driver, or it
> will perform the kernel jenkins hash function on the packet which will
> generate the result otherwise.
> 
> The other option is for user to provide an BPF program which is
> dedicated to calculate the hash. In such case the program is loaded
> and used by tc to perform the hash calculation and provide it to
> the hash action to be stored in skb->hash field.

The commit description is a bit misleading, since setting a custom skb->hash
from BPF program can be done already via {cls,act}_bpf from *within* BPF in
tc for ~3 years by now via [0].

   [0] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ded092cd73c2c56a394b936f86897f29b2e131c0

> The BPF option can be useful for future HW offload support of the hash
> calculation by emulating the HW hash function when it's different than
> the kernel's but yet we want to maintain consistency between the SW and
> the HW.

... use case should say 'dummy SW module for HW offload'. ;-/

> Usage is as follows:
> 
> $ tc filter add dev ens1f0_0 ingress \
> prio 1 chain 0 proto ip \
> flower ip_proto tcp \
> action hash bpf object-file <bpf file> \
> action goto chain 2
[...]
> 
> Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
[...]
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
> +		break;
> +	case TCA_HASH_ALG_BPF:
> +		__skb_push(skb, skb->mac_len);
> +		bpf_compute_data_pointers(skb);
> +		hash = BPF_PROG_RUN(p->prog, skb);
> +		__skb_pull(skb, skb->mac_len);
> +		/* The BPF program hash function type is
> +		 * unknown so only the sw hash bit is set.
> +		 */
> +		__skb_set_sw_hash(skb, hash, false);

Given this runs BPF_PROG_TYPE_SCHED_ACT-typed programs, act_hash.c now becomes
pretty much another clone of {cls,act}_bpf.c with the full feature set in terms
of what it can do with the program, like header mangling, encap/decap, setting
tunnel keys, cloning + redirecting skbs, etc. This is rather misleading given you
basically would only want the direct pkt access bits and plain insns for calc'ing
the hash, but none of the other features.

> +		break;
> +	}
> +
> +	return action;
> +}
[...]
> +static int tcf_hash_bpf_init(struct nlattr **tb, struct tcf_hash_params *params)
> +{
> +	struct bpf_prog *fp;
> +	char *name = NULL;
> +	u32 bpf_fd;
> +
> +	bpf_fd = nla_get_u32(tb[TCA_HASH_BPF_FD]);
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
