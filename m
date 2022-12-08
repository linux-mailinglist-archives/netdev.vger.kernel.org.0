Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 616EE646861
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 06:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiLHFA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 00:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiLHFAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 00:00:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08DC987C92;
        Wed,  7 Dec 2022 21:00:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF031B81CB2;
        Thu,  8 Dec 2022 05:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF72C433C1;
        Thu,  8 Dec 2022 05:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670475621;
        bh=sQYq03nBg7pcLjaJBeQDyFU+7cPsXzGvOTUuQd/G5HI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=o7AUIIgrU5v1v/1ZSIXoyYX/N/0iI3bigtfWiPFq2l8E+Ysl7w6spA/Nf+KplL+hF
         sHQ8WG4y7qv3kC9I8KLNlDTIbjCRp5Ip8DHxBtbMfhStdYzTTbwgi0r7pynXQXPdiW
         7eZJEIAxJv9gkNpQ0oYbRTEiaFfjN0q4SchK67GMqishaVXnB5Ktn5s6Bc+KrZpuAJ
         sI+AEqfGPddwANwPWGGIYEI45ngCvqRO6dCFgowklRiRf77bI9r5wk7F05gyQD32Mt
         ZueXTt12xhQnjbtBZUejKJtgcndSiLkt+j4J15x1m6krXgdYCJmaMgR8TqXqpbCqD9
         7sGzMwToL/XaA==
Date:   Wed, 7 Dec 2022 21:00:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 03/12] bpf: XDP metadata RX kfuncs
Message-ID: <20221207210019.41dc9b6b@kernel.org>
In-Reply-To: <20221206024554.3826186-4-sdf@google.com>
References: <20221206024554.3826186-1-sdf@google.com>
        <20221206024554.3826186-4-sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The offload tests still pass after this, right?
TBH I don't remember this code well enough to spot major issues.

On Mon,  5 Dec 2022 18:45:45 -0800 Stanislav Fomichev wrote:
> There is an ndo handler per kfunc, the verifier replaces a call to the
> generic kfunc with a call to the per-device one.
> 
> For XDP, we define a new kfunc set (xdp_metadata_kfunc_ids) which
> implements all possible metatada kfuncs. Not all devices have to
> implement them. If kfunc is not supported by the target device,
> the default implementation is called instead.
> 
> Upon loading, if BPF_F_XDP_HAS_METADATA is passed via prog_flags,
> we treat prog_index as target device for kfunc resolution.

> @@ -2476,10 +2477,18 @@ void bpf_offload_dev_netdev_unregister(struct bpf_offload_dev *offdev,
>  				       struct net_device *netdev);
>  bool bpf_offload_dev_match(struct bpf_prog *prog, struct net_device *netdev);
>  
> +void *bpf_offload_resolve_kfunc(struct bpf_prog *prog, u32 func_id);

There seems to be some mis-naming going on. I expected:

  offloaded =~ nfp
  dev_bound == XDP w/ funcs

*_offload_resolve_kfunc looks misnamed? Unless you want to resolve 
for HW offload?

>  void unpriv_ebpf_notify(int new_state);
>  
>  #if defined(CONFIG_NET) && defined(CONFIG_BPF_SYSCALL)
>  int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr);
> +void bpf_offload_bound_netdev_unregister(struct net_device *dev);

ditto: offload_bound is a mix of terms no?

> @@ -1611,6 +1612,10 @@ struct net_device_ops {
>  	ktime_t			(*ndo_get_tstamp)(struct net_device *dev,
>  						  const struct skb_shared_hwtstamps *hwtstamps,
>  						  bool cycles);
> +	bool			(*ndo_xdp_rx_timestamp_supported)(const struct xdp_md *ctx);
> +	u64			(*ndo_xdp_rx_timestamp)(const struct xdp_md *ctx);
> +	bool			(*ndo_xdp_rx_hash_supported)(const struct xdp_md *ctx);
> +	u32			(*ndo_xdp_rx_hash)(const struct xdp_md *ctx);
>  };

Is this on the fast path? Can we do an indirection?
Put these ops in their own struct and add a pointer to that struct 
in net_device_ops? Purely for grouping reasons because the netdev
ops are getting orders of magnitude past the size where you can
actually find stuff in this struct.

>  	bpf_free_used_maps(aux);
>  	bpf_free_used_btfs(aux);
> -	if (bpf_prog_is_offloaded(aux))
> +	if (bpf_prog_is_dev_bound(aux))
>  		bpf_prog_offload_destroy(aux->prog);

This also looks a touch like a mix of terms (condition vs function
called).

> +static int __bpf_offload_init(void);
> +static int __bpf_offload_dev_netdev_register(struct bpf_offload_dev *offdev,
> +					     struct net_device *netdev);
> +static void __bpf_offload_dev_netdev_unregister(struct bpf_offload_dev *offdev,
> +						struct net_device *netdev);

fwd declarations are yuck

>  static int bpf_dev_offload_check(struct net_device *netdev)
>  {
>  	if (!netdev)
> @@ -87,13 +93,17 @@ int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr)
>  	    attr->prog_type != BPF_PROG_TYPE_XDP)
>  		return -EINVAL;
>  
> -	if (attr->prog_flags)
> +	if (attr->prog_flags & ~BPF_F_XDP_HAS_METADATA)
>  		return -EINVAL;
>  
>  	offload = kzalloc(sizeof(*offload), GFP_USER);
>  	if (!offload)
>  		return -ENOMEM;
>  
> +	err = __bpf_offload_init();
> +	if (err)
> +		return err;

leaks offload

> @@ -209,6 +233,19 @@ bpf_prog_offload_remove_insns(struct bpf_verifier_env *env, u32 off, u32 cnt)
>  	up_read(&bpf_devs_lock);
>  }
>  
> +static void maybe_remove_bound_netdev(struct net_device *dev)
> +{

func name prefix ?

> -struct bpf_offload_dev *
> -bpf_offload_dev_create(const struct bpf_prog_offload_ops *ops, void *priv)
> +static int __bpf_offload_init(void)
>  {
> -	struct bpf_offload_dev *offdev;
>  	int err;
>  
>  	down_write(&bpf_devs_lock);
> @@ -680,12 +740,25 @@ bpf_offload_dev_create(const struct bpf_prog_offload_ops *ops, void *priv)
>  		err = rhashtable_init(&offdevs, &offdevs_params);
>  		if (err) {
>  			up_write(&bpf_devs_lock);
> -			return ERR_PTR(err);
> +			return err;
>  		}
>  		offdevs_inited = true;
>  	}
>  	up_write(&bpf_devs_lock);
>  
> +	return 0;
> +}

Would late_initcall() or some such not work for this?

> diff --git a/net/core/dev.c b/net/core/dev.c
> index 5b221568dfd4..862e03fcffa6 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -9228,6 +9228,10 @@ static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack *extack
>  			NL_SET_ERR_MSG(extack, "Using device-bound program without HW_MODE flag is not supported");

extack should get updated here, I reckon, maybe in previous patch

>  			return -EINVAL;
>  		}
> +		if (bpf_prog_is_dev_bound(new_prog->aux) && !bpf_offload_dev_match(new_prog, dev)) {

bound_dev_match() ?

> +			NL_SET_ERR_MSG(extack, "Cannot attach to a different target device");

different than.. ?

> +			return -EINVAL;
> +		}
>  		if (new_prog->expected_attach_type == BPF_XDP_DEVMAP) {
>  			NL_SET_ERR_MSG(extack, "BPF_XDP_DEVMAP programs can not be attached to a device");
>  			return -EINVAL;
