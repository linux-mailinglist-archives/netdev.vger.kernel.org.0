Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A78464C209
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 02:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237008AbiLNByI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 20:54:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiLNByH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 20:54:07 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7282F1929B;
        Tue, 13 Dec 2022 17:54:05 -0800 (PST)
Message-ID: <74e48fc9-8f5d-4183-9f39-c4587c74a74e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1670982843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GNg4/FrMFF9sXTLeG093TYFyexXEX026wSRyByZmxZg=;
        b=LnsGOz/aHRiS0h47bpq4i8GzveVplZ2215QzabqvW9i7hEucZQK4C0LdzxA9PBTrGjl2Jv
        bTZYQZO1UgC/xu9W485A2mtau4vTxm3OMYFv2lNdnKRAjYMRDIssJUF8F4KSe5Gz+cjS1+
        7Hy/40pP7FYC03nDfxoiG7qvtWz8vII=
Date:   Tue, 13 Dec 2022 17:53:58 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v4 05/15] bpf: XDP metadata RX kfuncs
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20221213023605.737383-1-sdf@google.com>
 <20221213023605.737383-6-sdf@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20221213023605.737383-6-sdf@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/12/22 6:35 PM, Stanislav Fomichev wrote:
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index ca22e8b8bd82..de6279725f41 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -2477,6 +2477,8 @@ void bpf_offload_dev_netdev_unregister(struct bpf_offload_dev *offdev,
>   				       struct net_device *netdev);
>   bool bpf_offload_dev_match(struct bpf_prog *prog, struct net_device *netdev);
>   
> +void *bpf_dev_bound_resolve_kfunc(struct bpf_prog *prog, u32 func_id);
> +

This probably requires an inline version for !CONFIG_NET.

> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index d434a994ee04..c3e501e3e39c 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -2097,6 +2097,13 @@ bool bpf_prog_map_compatible(struct bpf_map *map,
>   	if (fp->kprobe_override)
>   		return false;
>   
> +	/* When tail-calling from a non-dev-bound program to a dev-bound one,
> +	 * XDP metadata helpers should be disabled. Until it's implemented,
> +	 * prohibit adding dev-bound programs to tail-call maps.
> +	 */
> +	if (bpf_prog_is_dev_bound(fp->aux))
> +		return false;
> +
>   	spin_lock(&map->owner.lock);
>   	if (!map->owner.type) {
>   		/* There's no owner yet where we could check for
> diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
> index f714c941f8ea..3b6c9023f24d 100644
> --- a/kernel/bpf/offload.c
> +++ b/kernel/bpf/offload.c
> @@ -757,6 +757,29 @@ void bpf_dev_bound_netdev_unregister(struct net_device *dev)
>   	up_write(&bpf_devs_lock);
>   }
>   
> +void *bpf_dev_bound_resolve_kfunc(struct bpf_prog *prog, u32 func_id)
> +{
> +	const struct xdp_metadata_ops *ops;
> +	void *p = NULL;
> +
> +	down_read(&bpf_devs_lock);
> +	if (!prog->aux->offload || !prog->aux->offload->netdev)

This happens when netdev is unregistered in the middle of bpf_prog_load and the 
bpf_offload_dev_match() will eventually fail during dev_xdp_attach()? A comment 
will be useful.

> +		goto out;
> +
> +	ops = prog->aux->offload->netdev->xdp_metadata_ops;
> +	if (!ops)
> +		goto out;
> +
> +	if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP))
> +		p = ops->xmo_rx_timestamp;
> +	else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_HASH))
> +		p = ops->xmo_rx_hash;
> +out:
> +	up_read(&bpf_devs_lock);
> +
> +	return p;
> +}
> +
>   static int __init bpf_offload_init(void)
>   {
>   	int err;
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 203d8cfeda70..e61fe0472b9b 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -15479,12 +15479,35 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
>   			    struct bpf_insn *insn_buf, int insn_idx, int *cnt)
>   {
>   	const struct bpf_kfunc_desc *desc;
> +	void *xdp_kfunc;
>   
>   	if (!insn->imm) {
>   		verbose(env, "invalid kernel function call not eliminated in verifier pass\n");
>   		return -EINVAL;
>   	}
>   
> +	*cnt = 0;
> +
> +	if (xdp_is_metadata_kfunc_id(insn->imm)) {
> +		if (!bpf_prog_is_dev_bound(env->prog->aux)) {

The "xdp_is_metadata_kfunc_id() && (!bpf_prog_is_dev_bound() || 
bpf_prog_is_offloaded())" test should have been done much earlier in 
add_kfunc_call(). Then the later stage of the verifier does not have to keep 
worrying about it like here.

nit. may be rename xdp_is_metadata_kfunc_id() to bpf_dev_bound_kfunc_id() and 
hide the "!bpf_prog_is_dev_bound() || bpf_prog_is_offloaded()" test into 
bpf_dev_bound_kfunc_check(&env->log, env->prog).

The change in fixup_kfunc_call could then become:

	if (bpf_dev_bound_kfunc_id(insn->imm)) {
		xdp_kfunc = bpf_dev_bound_resolve_kfunc(env->prog, insn->imm);
		/* ... */
	}

> +			verbose(env, "metadata kfuncs require device-bound program\n");
> +			return -EINVAL;
> +		}
> +
> +		if (bpf_prog_is_offloaded(env->prog->aux)) {
> +			verbose(env, "metadata kfuncs can't be offloaded\n");
> +			return -EINVAL;
> +		}
> +
> +		xdp_kfunc = bpf_dev_bound_resolve_kfunc(env->prog, insn->imm);
> +		if (xdp_kfunc) {
> +			insn->imm = BPF_CALL_IMM(xdp_kfunc);
> +			return 0;
> +		}
> +
> +		/* fallback to default kfunc when not supported by netdev */
> +	}
> +


