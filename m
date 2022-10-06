Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3ABB5F6EBE
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 22:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbiJFUPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 16:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231382AbiJFUPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 16:15:23 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BCDD25D6;
        Thu,  6 Oct 2022 13:15:22 -0700 (PDT)
Message-ID: <d3041f61-2f3c-dee7-0129-bc18179d7520@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1665087320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xMVw6/ID68hyIXZxYR7QhiC1+wgbvniI2Ek3IkAjYis=;
        b=Ri4aiTuU08fytnxBZ7cHA/MdZ688L7Rh1Zwk8G0ulHN3/w18jMwBlAQqTGVGuXkj1do2GA
        Cd1tMK9qcZP8oemRreWiA0PiV/+294xQf6l/ySNSeaDlhlDi75Xwc6EbSuNo+5Q9qYZYFR
        GEGNMZmYFDk358CMUMEB4vOL+1DZvVg=
Date:   Thu, 6 Oct 2022 13:15:17 -0700
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next 01/10] bpf: Add initial fd-based API to attach tc
 BPF programs
Content-Language: en-US
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     razor@blackwall.org, ast@kernel.org, andrii@kernel.org,
        john.fastabend@gmail.com, joannelkoong@gmail.com, memxor@gmail.com,
        toke@redhat.com, joe@cilium.io, netdev@vger.kernel.org,
        bpf <bpf@vger.kernel.org>
References: <20221004231143.19190-1-daniel@iogearbox.net>
 <20221004231143.19190-2-daniel@iogearbox.net>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20221004231143.19190-2-daniel@iogearbox.net>
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

On 10/4/22 4:11 PM, Daniel Borkmann wrote:
>   static int bpf_prog_detach(const union bpf_attr *attr)
>   {
> @@ -3527,6 +3531,9 @@ static int bpf_prog_detach(const union bpf_attr *attr)
>   		return -EINVAL;
>   
>   	ptype = attach_type_to_prog_type(attr->attach_type);
> +	if (ptype != BPF_PROG_TYPE_SCHED_CLS &&
> +	    (attr->attach_flags || attr->replace_bpf_fd))

It seems no ptype is using the attach_flags in detach. xtc_prog_detach() is also 
not using it.  Should it be checked regardless of the ptype instead?

> +		return -EINVAL;
>   
>   	switch (ptype) {
>   	case BPF_PROG_TYPE_SK_MSG:
> @@ -3545,6 +3552,8 @@ static int bpf_prog_detach(const union bpf_attr *attr)
>   	case BPF_PROG_TYPE_SOCK_OPS:
>   	case BPF_PROG_TYPE_LSM:
>   		return cgroup_bpf_prog_detach(attr, ptype);
> +	case BPF_PROG_TYPE_SCHED_CLS:
> +		return xtc_prog_detach(attr);
>   	default:
>   		return -EINVAL;
>   	}
> @@ -3598,6 +3607,9 @@ static int bpf_prog_query(const union bpf_attr *attr,
>   	case BPF_SK_MSG_VERDICT:
>   	case BPF_SK_SKB_VERDICT:
>   		return sock_map_bpf_prog_query(attr, uattr);
> +	case BPF_NET_INGRESS:
> +	case BPF_NET_EGRESS:
> +		return xtc_prog_query(attr, uattr);
>   	default:
>   		return -EINVAL;
>   	}

