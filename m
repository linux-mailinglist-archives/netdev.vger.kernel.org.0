Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73BF165F841
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 01:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235740AbjAFAlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 19:41:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235623AbjAFAlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 19:41:13 -0500
Received: from out-247.mta0.migadu.com (out-247.mta0.migadu.com [IPv6:2001:41d0:1004:224b::f7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6381054D87
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 16:41:11 -0800 (PST)
Message-ID: <2795feb1-c968-b588-6a4c-9716afd8ecf2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1672965668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DCetod+Tkx15F+pJNS7nDOL6jC7i12c59IQP74mv1y8=;
        b=bH0L/MpMn3CAiFR3YXI5WE1p6Qw/YBZ+u292mSee+KGlGY95rXzkmV8d4LnlX5uYrTFZfp
        KS+gDpXsC7zZ1sI+g25hsAf9ZK+neXtsfeUKzj9PkYP+czxnmpHTvzp0B+X6v1pLAODzMr
        z7ZTdgtuQemQmODuNr8Hhd0r3TxI9vI=
Date:   Thu, 5 Jan 2023 16:41:01 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v6 05/17] bpf: Introduce device-bound XDP
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
References: <20230104215949.529093-1-sdf@google.com>
 <20230104215949.529093-6-sdf@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20230104215949.529093-6-sdf@google.com>
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

On 1/4/23 1:59 PM, Stanislav Fomichev wrote:
> @@ -199,12 +197,12 @@ int bpf_prog_offload_init(struct bpf_prog *prog, union bpf_attr *attr)
>   	    attr->prog_type != BPF_PROG_TYPE_XDP)
>   		return -EINVAL;
>   
> -	if (attr->prog_flags)
> +	if (attr->prog_flags & ~BPF_F_XDP_DEV_BOUND_ONLY)
>   		return -EINVAL;
>   
> -	offload = kzalloc(sizeof(*offload), GFP_USER);

The kzalloc is still needed. Although a latter patch added it bad, it is better 
not to miss it in the first place.

> -	if (!offload)
> -		return -ENOMEM;
> +	if (attr->prog_type == BPF_PROG_TYPE_SCHED_CLS &&
> +	    attr->prog_flags & BPF_F_XDP_DEV_BOUND_ONLY)
> +		return -EINVAL;
>   
>   	offload->prog = prog;
>   

