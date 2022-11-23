Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E992635082
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 07:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236053AbiKWGeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 01:34:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234531AbiKWGeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 01:34:11 -0500
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7856EA13B;
        Tue, 22 Nov 2022 22:34:09 -0800 (PST)
Message-ID: <ac5a7f9d-1bbf-db28-e494-44ac47a48fe6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1669185247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SVw20rYD6Mue02Eb3eFUXamAprymEclFbit/6QXRA/Y=;
        b=iJ+2RgLbYQy6UsY3m6uQ/VKf5k2JBbG1o1CtF82Z5foykQbtc4AE7b8KWvbGs5sTuB67ih
        JfXaSIE7gDK0wY/pHOK4BGck7Z4c3HKQptI9q7bF6pTSRs3AKizv5FVDZ5B7q5nzvy50Ct
        gHfPXHGqmCXQ2cvQaNRgh1pKkge9d4o=
Date:   Tue, 22 Nov 2022 22:34:02 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v2 2/8] bpf: XDP metadata RX kfuncs
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
References: <20221121182552.2152891-1-sdf@google.com>
 <20221121182552.2152891-3-sdf@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20221121182552.2152891-3-sdf@google.com>
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

On 11/21/22 10:25 AM, Stanislav Fomichev wrote:
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -2576,6 +2576,7 @@ static void bpf_prog_free_deferred(struct work_struct *work)
>   	} else {
>   		bpf_jit_free(aux->prog);
>   	}
> +	dev_put(aux->xdp_netdev);

I think dev_put needs to be done during unregister_netdevice event also. 
Otherwise, a loaded bpf prog may hold the dev for a long time.  May be there is 
ideas in offload.c.

[ ... ]

> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 35972afb6850..ece7f9234b2d 100644
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
> @@ -2579,6 +2580,20 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
>   	prog->aux->sleepable = attr->prog_flags & BPF_F_SLEEPABLE;
>   	prog->aux->xdp_has_frags = attr->prog_flags & BPF_F_XDP_HAS_FRAGS;
>   
> +	if (attr->prog_flags & BPF_F_XDP_HAS_METADATA) {
> +		/* Reuse prog_ifindex to bind to the device
> +		 * for XDP metadata kfuncs.
> +		 */
> +		prog->aux->offload_requested = false;
> +
> +		prog->aux->xdp_netdev = dev_get_by_index(current->nsproxy->net_ns,
> +							 attr->prog_ifindex);
> +		if (!prog->aux->xdp_netdev) {
> +			err = -EINVAL;
> +			goto free_prog;
> +		}
> +	}

