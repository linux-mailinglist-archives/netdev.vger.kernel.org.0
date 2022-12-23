Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C269B6549BB
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 01:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbiLWAT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 19:19:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiLWATZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 19:19:25 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792CD215;
        Thu, 22 Dec 2022 16:19:24 -0800 (PST)
Message-ID: <04e1406b-0a31-0109-9a1b-f016e8f23603@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1671754762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+seCcOL2buujU8wktHij9cCoNPW204q8XCrXgclzy5A=;
        b=OyLpgXLg2cn3vyZrqJWhtgEq/FypDFl65L4LEOw6+1lAoikKIYaQHtzLZw08tG4Cag79B6
        LsxnV9k08oSDr3Fl77QukK2o6GzYefdPSBipACnxhmGD5JLU3Q++E6g/Z2VQ1mVSwMEz7+
        mIdCv9yXsYwmUPQbkib3WeTlTN4jQsk=
Date:   Thu, 22 Dec 2022 16:19:15 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v5 05/17] bpf: Introduce device-bound XDP
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
References: <20221220222043.3348718-1-sdf@google.com>
 <20221220222043.3348718-6-sdf@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20221220222043.3348718-6-sdf@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/20/22 2:20 PM, Stanislav Fomichev wrote:
> -int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr)
> +int bpf_prog_dev_bound_init(struct bpf_prog *prog, union bpf_attr *attr)
>   {
>   	struct bpf_offload_netdev *ondev;
>   	struct bpf_prog_offload *offload;
> @@ -199,7 +197,7 @@ int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr)
>   	    attr->prog_type != BPF_PROG_TYPE_XDP)
>   		return -EINVAL;
>   
> -	if (attr->prog_flags)
> +	if (attr->prog_flags & ~BPF_F_XDP_DEV_BOUND_ONLY)
>   		return -EINVAL;
>   
>   	offload = kzalloc(sizeof(*offload), GFP_USER);
> @@ -214,11 +212,23 @@ int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr)
>   	if (err)
>   		goto err_maybe_put;
>   
> +	prog->aux->offload_requested = !(attr->prog_flags & BPF_F_XDP_DEV_BOUND_ONLY);

Just noticed bpf_prog_dev_bound_init() takes BPF_PROG_TYPE_SCHED_CLS.  Not sure 
if there is device match check when attaching BPF_PROG_TYPE_SCHED_CLS.  If not, 
does it make sense to reject dev bound only BPF_PROG_TYPE_SCHED_CLS?

> +
>   	down_write(&bpf_devs_lock);
>   	ondev = bpf_offload_find_netdev(offload->netdev);
>   	if (!ondev) {
> -		err = -EINVAL;
> -		goto err_unlock;
> +		if (bpf_prog_is_offloaded(prog->aux)) {
> +			err = -EINVAL;
> +			goto err_unlock;
> +		}
> +
> +		/* When only binding to the device, explicitly
> +		 * create an entry in the hashtable.
> +		 */
> +		err = __bpf_offload_dev_netdev_register(NULL, offload->netdev);
> +		if (err)
> +			goto err_unlock;
> +		ondev = bpf_offload_find_netdev(offload->netdev);
>   	}
>   	offload->offdev = ondev->offdev;
>   	prog->aux->offload = offload;
> @@ -321,12 +331,41 @@ bpf_prog_offload_remove_insns(struct bpf_verifier_env *env, u32 off, u32 cnt)
>   	up_read(&bpf_devs_lock);
>   }
>   
> -void bpf_prog_offload_destroy(struct bpf_prog *prog)
> +static void __bpf_prog_dev_bound_destroy(struct bpf_prog *prog)
> +{
> +	struct bpf_prog_offload *offload = prog->aux->offload;
> +
> +	if (offload->dev_state)
> +		offload->offdev->ops->destroy(prog);
> +
> +	/* Make sure BPF_PROG_GET_NEXT_ID can't find this dead program */
> +	bpf_prog_free_id(prog, true);
> +
> +	kfree(offload);
> +	prog->aux->offload = NULL;
> +}
> +
> +void bpf_prog_dev_bound_destroy(struct bpf_prog *prog)
>   {
> +	struct bpf_offload_netdev *ondev;
> +	struct net_device *netdev;
> +
> +	rtnl_lock();
>   	down_write(&bpf_devs_lock);
> -	if (prog->aux->offload)
> -		__bpf_prog_offload_destroy(prog);
> +	if (prog->aux->offload) {
> +		list_del_init(&prog->aux->offload->offloads);
> +
> +		netdev = prog->aux->offload->netdev;

After saving the netdev, would it work to call __bpf_prog_offload_destroy() here 
instead of creating an almost identical __bpf_prog_dev_bound_destroy().  The 
idea is to call list_del_init() first but does not need the "offload" around to 
do the __bpf_offload_dev_netdev_unregister()?

> +		if (netdev) {

I am thinking offload->netdev cannot be NULL.  Did I overlook places that reset 
offload->netdev back to NULL?  eg. In bpf_prog_offload_info_fill_ns(), it is not 
checking offload->netdev.

> +			ondev = bpf_offload_find_netdev(netdev);

and ondev should not be NULL too?

I am trying to ensure my understanding that all offload->netdev and ondev should 
be protected by bpf_devs_lock.

> +			if (ondev && !ondev->offdev && list_empty(&ondev->progs))
> +				__bpf_offload_dev_netdev_unregister(NULL, netdev);
> +		}
> +
> +		__bpf_prog_dev_bound_destroy(prog);
> +	}
>   	up_write(&bpf_devs_lock);
> +	rtnl_unlock();
>   }

