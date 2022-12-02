Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1494640E34
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 20:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234497AbiLBTIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 14:08:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234187AbiLBTIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 14:08:41 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 203A393827;
        Fri,  2 Dec 2022 11:08:39 -0800 (PST)
Message-ID: <6d0e13eb-63e0-a777-2a27-7f2e02867a13@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1670008117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uVok47OFBEZZM7DL3MNnIdvx1TzDy010/6cy/h3x/YM=;
        b=Cv84JwblirIlBeGmvJp+pyOJUtd7PNeAtvNQXv4BWm3lJ/F8l1lsDSFSfLUZ2W5wcm1xbN
        fsDLDv9GJXouc2SrZIvI9pmGGHbrLKr79q6gSZmZajo3mzY35W8ghKD4sPnRxC04w4sYr1
        YOiePl1314oyCF2tttdcBhndDFdVNno=
Date:   Fri, 2 Dec 2022 11:08:29 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next,v4 2/4] xfrm: interface: Add unstable helpers for
 setting/getting XFRM metadata from TC-BPF
Content-Language: en-US
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        andrii@kernel.org, daniel@iogearbox.net, nicolas.dichtel@6wind.com,
        razor@blackwall.org, mykolal@fb.com, ast@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, shuah@kernel.org, liuhangbin@gmail.com,
        lixiaoyan@google.com
References: <20221202095920.1659332-1-eyal.birger@gmail.com>
 <20221202095920.1659332-3-eyal.birger@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20221202095920.1659332-3-eyal.birger@gmail.com>
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

On 12/2/22 1:59 AM, Eyal Birger wrote:
> +__used noinline
> +int bpf_skb_set_xfrm_info(struct __sk_buff *skb_ctx,
> +			  const struct bpf_xfrm_info *from)
> +{
> +	struct sk_buff *skb = (struct sk_buff *)skb_ctx;
> +	struct metadata_dst *md_dst;
> +	struct xfrm_md_info *info;
> +
> +	if (unlikely(skb_metadata_dst(skb)))
> +		return -EINVAL;
> +
> +	md_dst = this_cpu_ptr(xfrm_md_dst);
> +
> +	info = &md_dst->u.xfrm_info;
> +
> +	info->if_id = from->if_id;
> +	info->link = from->link;
> +	skb_dst_force(skb);
> +	info->dst_orig = skb_dst(skb);
> +
> +	dst_hold((struct dst_entry *)md_dst);
> +	skb_dst_set(skb, (struct dst_entry *)md_dst);


I may be missed something obvious and this just came to my mind,

What stops cleanup_xfrm_interface_bpf() being run while skb is still holding the 
md_dst?

[ ... ]

> +static const struct btf_kfunc_id_set xfrm_interface_kfunc_set = {
> +	.owner = THIS_MODULE,
> +	.set   = &xfrm_ifc_kfunc_set,
> +};
> +
> +int __init register_xfrm_interface_bpf(void)
> +{
> +	int err;
> +
> +	xfrm_md_dst = metadata_dst_alloc_percpu(0, METADATA_XFRM,
> +						GFP_KERNEL);
> +	if (!xfrm_md_dst)
> +		return -ENOMEM;
> +	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS,
> +					&xfrm_interface_kfunc_set);
> +	if (err < 0) {
> +		metadata_dst_free_percpu(xfrm_md_dst);
> +		return err;
> +	}
> +	return 0;
> +}
> +
> +void cleanup_xfrm_interface_bpf(void)
> +{
> +	metadata_dst_free_percpu(xfrm_md_dst);
> +}

