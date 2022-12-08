Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C263764673A
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 03:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbiLHCrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 21:47:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiLHCro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 21:47:44 -0500
Received: from out-56.mta0.migadu.com (out-56.mta0.migadu.com [91.218.175.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2ACC6441
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 18:47:41 -0800 (PST)
Message-ID: <391b9abf-c53a-623c-055f-60768c716baa@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1670467659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IIYKsr4/6Gpoa1mkM2XNv70TpZrSLQlv0FyfF+HDb0Y=;
        b=DwdUCE8Dwr+/vVfmx0bgkSt3UkhQMhVL9hBKr/+QREzCEszDibyuaCFhpUpVH9m7xCuHcl
        nB3RwY0Wow3U6ZceiWTtC4bn4X/5MbHokz5BNGXMKkyX/dVicl/QcSUJQo9lhtgvAd8evD
        NT1BtyVKhMubBmJj5OjjOt0EoH2BJ+M=
Date:   Wed, 7 Dec 2022 18:47:33 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v3 03/12] bpf: XDP metadata RX kfuncs
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
References: <20221206024554.3826186-1-sdf@google.com>
 <20221206024554.3826186-4-sdf@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20221206024554.3826186-4-sdf@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/5/22 6:45 PM, Stanislav Fomichev wrote:
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 55dbc68bfffc..c24aba5c363b 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -409,4 +409,33 @@ void xdp_attachment_setup(struct xdp_attachment_info *info,
>   
>   #define DEV_MAP_BULK_SIZE XDP_BULK_QUEUE_SIZE
>   
> +#define XDP_METADATA_KFUNC_xxx	\
> +	XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED, \
> +			   bpf_xdp_metadata_rx_timestamp_supported) \
> +	XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_TIMESTAMP, \
> +			   bpf_xdp_metadata_rx_timestamp) \
> +	XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_HASH_SUPPORTED, \
> +			   bpf_xdp_metadata_rx_hash_supported) \
> +	XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_HASH, \
> +			   bpf_xdp_metadata_rx_hash) \
> +
> +enum {
> +#define XDP_METADATA_KFUNC(name, str) name,
> +XDP_METADATA_KFUNC_xxx
> +#undef XDP_METADATA_KFUNC
> +MAX_XDP_METADATA_KFUNC,
> +};
> +
> +#ifdef CONFIG_NET

I think this is no longer needed because xdp_metadata_kfunc_id() is only used in 
offload.c which should be CONFIG_NET only.

> +u32 xdp_metadata_kfunc_id(int id);
> +#else
> +static inline u32 xdp_metadata_kfunc_id(int id) { return 0; }
> +#endif
> +
> +struct xdp_md;
> +bool bpf_xdp_metadata_rx_timestamp_supported(const struct xdp_md *ctx);
> +u64 bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx);
> +bool bpf_xdp_metadata_rx_hash_supported(const struct xdp_md *ctx);
> +u32 bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx);
> +
>   #endif /* __LINUX_NET_XDP_H__ */
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index f89de51a45db..790650a81f2b 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -1156,6 +1156,11 @@ enum bpf_link_type {
>    */
>   #define BPF_F_XDP_HAS_FRAGS	(1U << 5)
>   
> +/* If BPF_F_XDP_HAS_METADATA is used in BPF_PROG_LOAD command, the loaded
> + * program becomes device-bound but can access it's XDP metadata.
> + */
> +#define BPF_F_XDP_HAS_METADATA	(1U << 6)
> +

[ ... ]

> diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
> index f5769a8ecbee..bad8bab916eb 100644
> --- a/kernel/bpf/offload.c
> +++ b/kernel/bpf/offload.c
> @@ -41,7 +41,7 @@ struct bpf_offload_dev {
>   struct bpf_offload_netdev {
>   	struct rhash_head l;
>   	struct net_device *netdev;
> -	struct bpf_offload_dev *offdev;
> +	struct bpf_offload_dev *offdev; /* NULL when bound-only */
>   	struct list_head progs;
>   	struct list_head maps;
>   	struct list_head offdev_netdevs;
> @@ -58,6 +58,12 @@ static const struct rhashtable_params offdevs_params = {
>   static struct rhashtable offdevs;
>   static bool offdevs_inited;
>   
> +static int __bpf_offload_init(void);
> +static int __bpf_offload_dev_netdev_register(struct bpf_offload_dev *offdev,
> +					     struct net_device *netdev);
> +static void __bpf_offload_dev_netdev_unregister(struct bpf_offload_dev *offdev,
> +						struct net_device *netdev);
> +
>   static int bpf_dev_offload_check(struct net_device *netdev)
>   {
>   	if (!netdev)
> @@ -87,13 +93,17 @@ int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr)
>   	    attr->prog_type != BPF_PROG_TYPE_XDP)
>   		return -EINVAL;
>   
> -	if (attr->prog_flags)
> +	if (attr->prog_flags & ~BPF_F_XDP_HAS_METADATA)
>   		return -EINVAL;
>   
>   	offload = kzalloc(sizeof(*offload), GFP_USER);
>   	if (!offload)
>   		return -ENOMEM;
>   
> +	err = __bpf_offload_init();
> +	if (err)
> +		return err;
> +
>   	offload->prog = prog;
>   
>   	offload->netdev = dev_get_by_index(current->nsproxy->net_ns,
> @@ -102,11 +112,25 @@ int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr)
>   	if (err)
>   		goto err_maybe_put;
>   
> +	prog->aux->offload_requested = !(attr->prog_flags & BPF_F_XDP_HAS_METADATA);
> +

If I read the set correctly, bpf prog can either use metadata kfunc or offload 
but not both. It is fine to start with only supporting metadata kfunc when there 
is no offload but will be useful to understand the reason. I assume an offloaded 
bpf prog should still be able to call the bpf helpers like adjust_head/tail and 
the same should go for any kfunc?

Also, the BPF_F_XDP_HAS_METADATA feels like it is acting more like 
BPF_F_XDP_DEV_BOUND_ONLY.

>   	down_write(&bpf_devs_lock);
>   	ondev = bpf_offload_find_netdev(offload->netdev);
>   	if (!ondev) {
> -		err = -EINVAL;
> -		goto err_unlock;
> +		if (!prog->aux->offload_requested) {

nit. bpf_prog_is_offloaded(prog->aux)

> +			/* When only binding to the device, explicitly
> +			 * create an entry in the hashtable. See related
> +			 * maybe_remove_bound_netdev.
> +			 */
> +			err = __bpf_offload_dev_netdev_register(NULL, offload->netdev);
> +			if (err)
> +				goto err_unlock;
> +			ondev = bpf_offload_find_netdev(offload->netdev);
> +		}
> +		if (!ondev) {
> +			err = -EINVAL;
> +			goto err_unlock;
> +		}
>   	}
>   	offload->offdev = ondev->offdev;
>   	prog->aux->offload = offload;
> @@ -209,6 +233,19 @@ bpf_prog_offload_remove_insns(struct bpf_verifier_env *env, u32 off, u32 cnt)
>   	up_read(&bpf_devs_lock);
>   }
>   
> +static void maybe_remove_bound_netdev(struct net_device *dev)
> +{
> +	struct bpf_offload_netdev *ondev;
> +
> +	rtnl_lock();
> +	down_write(&bpf_devs_lock);
> +	ondev = bpf_offload_find_netdev(dev);
> +	if (ondev && !ondev->offdev && list_empty(&ondev->progs))
> +		__bpf_offload_dev_netdev_unregister(NULL, dev);
> +	up_write(&bpf_devs_lock);
> +	rtnl_unlock();
> +}
> +
>   static void __bpf_prog_offload_destroy(struct bpf_prog *prog)
>   {
>   	struct bpf_prog_offload *offload = prog->aux->offload;
> @@ -226,10 +263,17 @@ static void __bpf_prog_offload_destroy(struct bpf_prog *prog)
>   
>   void bpf_prog_offload_destroy(struct bpf_prog *prog)
>   {
> +	struct net_device *netdev = NULL;
> +
>   	down_write(&bpf_devs_lock);
> -	if (prog->aux->offload)
> +	if (prog->aux->offload) {
> +		netdev = prog->aux->offload->netdev;
>   		__bpf_prog_offload_destroy(prog);
> +	}
>   	up_write(&bpf_devs_lock);
> +
> +	if (netdev)

May be I have missed a refcnt or lock somewhere.  Is it possible that netdev may 
have been freed?

> +		maybe_remove_bound_netdev(netdev);
>   }
>   

[ ... ]

> +void *bpf_offload_resolve_kfunc(struct bpf_prog *prog, u32 func_id)
> +{
> +	const struct net_device_ops *netdev_ops;
> +	void *p = NULL;
> +
> +	down_read(&bpf_devs_lock);
> +	if (!prog->aux->offload || !prog->aux->offload->netdev)
> +		goto out;
> +
> +	netdev_ops = prog->aux->offload->netdev->netdev_ops;
> +
> +	if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED))
> +		p = netdev_ops->ndo_xdp_rx_timestamp_supported;
> +	else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP))
> +		p = netdev_ops->ndo_xdp_rx_timestamp;
> +	else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_HASH_SUPPORTED))
> +		p = netdev_ops->ndo_xdp_rx_hash_supported;
> +	else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_HASH))
> +		p = netdev_ops->ndo_xdp_rx_hash;
> +	/* fallback to default kfunc when not supported by netdev */
> +out:
> +	up_read(&bpf_devs_lock);
> +
> +	return p;
> +}
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 13bc96035116..b345a273f7d0 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2491,7 +2491,8 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
>   				 BPF_F_TEST_STATE_FREQ |
>   				 BPF_F_SLEEPABLE |
>   				 BPF_F_TEST_RND_HI32 |
> -				 BPF_F_XDP_HAS_FRAGS))
> +				 BPF_F_XDP_HAS_FRAGS |
> +				 BPF_F_XDP_HAS_METADATA))
>   		return -EINVAL;
>   
>   	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&
> @@ -2575,7 +2576,7 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
>   	prog->aux->attach_btf = attach_btf;
>   	prog->aux->attach_btf_id = attr->attach_btf_id;
>   	prog->aux->dst_prog = dst_prog;
> -	prog->aux->offload_requested = !!attr->prog_ifindex;
> +	prog->aux->dev_bound = !!attr->prog_ifindex;
>   	prog->aux->sleepable = attr->prog_flags & BPF_F_SLEEPABLE;
>   	prog->aux->xdp_has_frags = attr->prog_flags & BPF_F_XDP_HAS_FRAGS;
>   
> @@ -2598,7 +2599,7 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
>   	atomic64_set(&prog->aux->refcnt, 1);
>   	prog->gpl_compatible = is_gpl ? 1 : 0;
>   
> -	if (bpf_prog_is_offloaded(prog->aux)) {
> +	if (bpf_prog_is_dev_bound(prog->aux)) {
>   		err = bpf_prog_offload_init(prog, attr);
>   		if (err)
>   			goto free_prog_sec;
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index fc4e313a4d2e..00951a59ee26 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -15323,6 +15323,24 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
>   		return -EINVAL;
>   	}
>   
> +	*cnt = 0;
> +
> +	if (resolve_prog_type(env->prog) == BPF_PROG_TYPE_XDP) {

hmmm...does it need BPF_PROG_TYPE_XDP check? Is the below 
bpf_prog_is_dev_bound() and the eariler 
'register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &xdp_metadata_kfunc_set)' good enough?

> +		if (bpf_prog_is_offloaded(env->prog->aux)) {
> +			verbose(env, "no metadata kfuncs offload\n");
> +			return -EINVAL;
> +		}
> +
> +		if (bpf_prog_is_dev_bound(env->prog->aux)) {
> +			void *p = bpf_offload_resolve_kfunc(env->prog, insn->imm);
> +
> +			if (p) {
> +				insn->imm = BPF_CALL_IMM(p);
> +				return 0;
> +			}
> +		}
> +	}
> +


