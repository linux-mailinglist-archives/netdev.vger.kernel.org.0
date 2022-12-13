Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D53D464C091
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 00:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236790AbiLMXZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 18:25:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236710AbiLMXZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 18:25:39 -0500
Received: from out-94.mta0.migadu.com (out-94.mta0.migadu.com [IPv6:2001:41d0:1004:224b::5e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B346E85
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 15:25:37 -0800 (PST)
Message-ID: <94d8cd3a-fc07-88aa-94f8-6b08940a2087@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1670973934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d6xG0/lKADN0SB52GMYb9zCvexOtVfuo0FM3nceD6Hg=;
        b=SgPsMVEj9R/6Scaf46X/2CvcIVcdjrCCpob5fTMFQ4n8VR6u/PIVxS3b2C46XfTLcXSg2I
        JnNhHG3wMhBsobH6jgfiUskz3yleb0UN6XG27E9aXV3TH6ndR2Ky7AjbnhC8S8XEe9O5Ww
        q5dle0F4Vcpuvrl2r8xsZmEN22Mu+Gs=
Date:   Tue, 13 Dec 2022 15:25:26 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v4 03/15] bpf: Introduce device-bound XDP
 programs
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
 <20221213023605.737383-4-sdf@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20221213023605.737383-4-sdf@google.com>
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

On 12/12/22 6:35 PM, Stanislav Fomichev wrote:
> New flag BPF_F_XDP_DEV_BOUND_ONLY plus all the infra to have a way
> to associate a netdev with a BPF program at load time.
> 
> Some existing 'offloaded' routines are renamed to 'dev_bound' for
> consistency with the rest.
> 
> Also moved a bunch of code around to avoid forward declarations.

There are too many things in one patch.  It becomes quite hard to follow, eg. I 
have to go back-and-forth a few times within this patch to confirm what change 
is just a move.  Please put the "moved a bunch of code around to avoid forward 
declarations" in one individual patch and also the 
"late_initcall(bpf_offload_init)" change in another individual patch.

[ ... ]

> -int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr)
> +static int __bpf_offload_dev_netdev_register(struct bpf_offload_dev *offdev,
> +					     struct net_device *netdev)
> +{
> +	struct bpf_offload_netdev *ondev;
> +	int err;
> +
> +	ondev = kzalloc(sizeof(*ondev), GFP_KERNEL);
> +	if (!ondev)
> +		return -ENOMEM;
> +
> +	ondev->netdev = netdev;
> +	ondev->offdev = offdev;
> +	INIT_LIST_HEAD(&ondev->progs);
> +	INIT_LIST_HEAD(&ondev->maps);
> +
> +	err = rhashtable_insert_fast(&offdevs, &ondev->l, offdevs_params);
> +	if (err) {
> +		netdev_warn(netdev, "failed to register for BPF offload\n");
> +		goto err_unlock_free;
> +	}
> +
> +	if (offdev)
> +		list_add(&ondev->offdev_netdevs, &offdev->netdevs);
> +	return 0;
> +
> +err_unlock_free:
> +	up_write(&bpf_devs_lock);

No need to handle bpf_devs_lock in the "__" version of the register() helper? 
The goto label probably also needs another name, eg. "err_free".

> +	kfree(ondev);
> +	return err;
> +}
> +

[ ... ]

> +int bpf_prog_dev_bound_init(struct bpf_prog *prog, union bpf_attr *attr)
>   {
>   	struct bpf_offload_netdev *ondev;
>   	struct bpf_prog_offload *offload;
> @@ -87,7 +198,7 @@ int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr)
>   	    attr->prog_type != BPF_PROG_TYPE_XDP)
>   		return -EINVAL;
>   
> -	if (attr->prog_flags)
> +	if (attr->prog_flags & ~BPF_F_XDP_DEV_BOUND_ONLY)
>   		return -EINVAL;
>   
>   	offload = kzalloc(sizeof(*offload), GFP_USER);
> @@ -102,11 +213,25 @@ int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr)
>   	if (err)
>   		goto err_maybe_put;
>   
> +	prog->aux->offload_requested = !(attr->prog_flags & BPF_F_XDP_DEV_BOUND_ONLY);
> +
>   	down_write(&bpf_devs_lock);
>   	ondev = bpf_offload_find_netdev(offload->netdev);
>   	if (!ondev) {
> -		err = -EINVAL;
> -		goto err_unlock;
> +		if (!bpf_prog_is_offloaded(prog->aux)) {
> +			/* When only binding to the device, explicitly
> +			 * create an entry in the hashtable. See related
> +			 * bpf_dev_bound_try_remove_netdev.
> +			 */
> +			err = __bpf_offload_dev_netdev_register(NULL, offload->netdev);
> +			if (err)
> +				goto err_unlock;
> +			ondev = bpf_offload_find_netdev(offload->netdev);
> +		}
> +		if (!ondev) {

nit.  A bit confusing because the "ondev = bpf_offload_find_netdev(...)" above 
should not fail but "!ondev" is tested again here.  I think the intention is to 
fail on the 'bpf_prog_is_offloaded() == true' case. May be:

		if (bpf_prog_is_offloaded(prog->aux)) {
			err = -EINVAL;
			goto err_unlock;
		}
		/* When only binding to the device, explicitly
		 * ...
		 */
		err = __bpf_offload_dev_netdev_register(NULL, offload->netdev);
		if (err)
			goto err_unlock;
		ondev = bpf_offload_find_netdev(offload->netdev);

> +			err = -EINVAL;
> +			goto err_unlock;
> +		}
>   	}
>   	offload->offdev = ondev->offdev;
>   	prog->aux->offload = offload;
> @@ -209,27 +334,28 @@ bpf_prog_offload_remove_insns(struct bpf_verifier_env *env, u32 off, u32 cnt)
>   	up_read(&bpf_devs_lock);
>   }
>   
> -static void __bpf_prog_offload_destroy(struct bpf_prog *prog)
> +static void bpf_dev_bound_try_remove_netdev(struct net_device *dev)
>   {
> -	struct bpf_prog_offload *offload = prog->aux->offload;
> -
> -	if (offload->dev_state)
> -		offload->offdev->ops->destroy(prog);
> +	struct bpf_offload_netdev *ondev;
>   
> -	/* Make sure BPF_PROG_GET_NEXT_ID can't find this dead program */
> -	bpf_prog_free_id(prog, true);
> +	if (!dev)
> +		return;
>   
> -	list_del_init(&offload->offloads);
> -	kfree(offload);
> -	prog->aux->offload = NULL;
> +	ondev = bpf_offload_find_netdev(dev);
> +	if (ondev && !ondev->offdev && list_empty(&ondev->progs))

hmm....list_empty(&ondev->progs) is tested here but will it be empty? ...

> +		__bpf_offload_dev_netdev_unregister(NULL, dev);
>   }
>   
> -void bpf_prog_offload_destroy(struct bpf_prog *prog)
> +void bpf_prog_dev_bound_destroy(struct bpf_prog *prog)
>   {
> +	rtnl_lock();
>   	down_write(&bpf_devs_lock);
> -	if (prog->aux->offload)
> -		__bpf_prog_offload_destroy(prog);
> +	if (prog->aux->offload) {
> +		bpf_dev_bound_try_remove_netdev(prog->aux->offload->netdev);

... the "prog" here is still linked to ondev->progs, right?
because __bpf_prog_dev_bound_destroy() is called later below.

nit. May be the bpf_dev_bound_try_remove_netdev() should be folded/merged back 
into bpf_prog_dev_bound_destroy() to make things more clear.

> +		__bpf_prog_dev_bound_destroy(prog); > +	}
>   	up_write(&bpf_devs_lock);
> +	rtnl_unlock();
>   }

[ ... ]

> +static int __init bpf_offload_init(void)
> +{
> +	int err;
> +
> +	down_write(&bpf_devs_lock);

lock is probably not needed.

> +	err = rhashtable_init(&offdevs, &offdevs_params);
> +	up_write(&bpf_devs_lock);
> +
> +	return err;
> +}
> +
> +late_initcall(bpf_offload_init);

[ ... ]

> diff --git a/net/core/dev.c b/net/core/dev.c
> index 5d51999cba30..194f8116aad4 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -9228,6 +9228,10 @@ static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack *extack
>   			NL_SET_ERR_MSG(extack, "Using offloaded program without HW_MODE flag is not supported");
>   			return -EINVAL;
>   		}
> +		if (bpf_prog_is_dev_bound(new_prog->aux) && !bpf_offload_dev_match(new_prog, dev)) {
> +			NL_SET_ERR_MSG(extack, "Program bound to different device");
> +			return -EINVAL;
> +		}
>   		if (new_prog->expected_attach_type == BPF_XDP_DEVMAP) {
>   			NL_SET_ERR_MSG(extack, "BPF_XDP_DEVMAP programs can not be attached to a device");
>   			return -EINVAL;
> @@ -10813,6 +10817,7 @@ void unregister_netdevice_many_notify(struct list_head *head,
>   		/* Shutdown queueing discipline. */
>   		dev_shutdown(dev);
>   
> +		bpf_dev_bound_netdev_unregister(dev);

Does it matter if bpf_dev_bound_netdev_unregister(dev) is called before 
dev_xdp_uninstall(dev)?  Asking because it seems more logic to unregister dev 
after detaching xdp progs.

>   		dev_xdp_uninstall(dev);
>   
>   		netdev_offload_xstats_disable_all(dev);


