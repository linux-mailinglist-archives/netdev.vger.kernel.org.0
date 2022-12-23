Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7DA36549C4
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 01:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiLWAbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 19:31:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiLWAbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 19:31:35 -0500
Received: from out-211.mta0.migadu.com (out-211.mta0.migadu.com [91.218.175.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25606384
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 16:31:33 -0800 (PST)
Message-ID: <00810419-c76c-32da-16a6-27c1029e3a60@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1671755491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DsSPlAwNaybOVBoScG6VFYhJRF2PMNYvefdoExcTLGI=;
        b=W1nKyLs2CSWdZ6dsxbZULAhv0FLIMyKJgzF2nJ9IIprXuQqcXw0hHCa710dwgDA1q5rNAc
        zOZaiCyMuBRmOdZ+ZUsBcsiXzrtE5Df4BRLra/nEatXPZXoGgejJ/007+Rq49MaBQTyLZB
        mBUSEF2mUi2volOO8byvoqiuxeA77kQ=
Date:   Thu, 22 Dec 2022 16:31:26 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v5 07/17] bpf: XDP metadata RX kfuncs
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
 <20221220222043.3348718-8-sdf@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20221220222043.3348718-8-sdf@google.com>
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

On 12/20/22 2:20 PM, Stanislav Fomichev wrote:
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index bafcb7a3ae6f..6d81b14361e3 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -2097,6 +2097,14 @@ bool bpf_prog_map_compatible(struct bpf_map *map,
>   	if (fp->kprobe_override)
>   		return false;
>   
> +	/* XDP programs inserted into maps are not guaranteed to run on
> +	 * a particular netdev (and can run outside driver context entirely
> +	 * in the case of devmap and cpumap). Until device checks
> +	 * are implemented, prohibit adding dev-bound programs to program maps.
> +	 */
> +	if (bpf_prog_is_dev_bound(fp->aux))
> +		return false;
> +

There is a recent change in the same function in the bpf tree, commit 
1c123c567fb1. fyi.

[ ... ]

> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index fdfdcab4a59d..320451a0be3e 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -2081,6 +2081,22 @@ static struct btf *find_kfunc_desc_btf(struct bpf_verifier_env *env, s16 offset)
>   	return btf_vmlinux ?: ERR_PTR(-ENOENT);
>   }
>   
> +int bpf_dev_bound_kfunc_check(struct bpf_verifier_env *env,
> +			      struct bpf_prog_aux *prog_aux)

nit. Move the dev bound related function to offload.c. &env->log can be passed 
instead of env and then use bpf_log().


Others lgtm.

