Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21605BB364
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 22:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiIPUU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 16:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiIPUU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 16:20:57 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB07FA722A;
        Fri, 16 Sep 2022 13:20:54 -0700 (PDT)
Message-ID: <ada17021-83c9-3dad-5992-4885e824ecac@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663359652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TdFPJ/E73gfYJJ71FfMTa2muu9d+Trfydz6NY8WdwhU=;
        b=G8MmkhFSmV3qP2EPiZtkTIjy70MCOmQV3emF9RFbLEOlAT0ii1FP9VsV60b0i32ccZ3WFM
        R8R8wDhxE5MmVK3QAbzkKgZmVwVOvf5vX1rOaCq7y1NE2wVwaNtwdvflhHgHrg8qu0e6sh
        G4GUqGqKuYiQxGTCvwz/6N5tUgdX1GA=
Date:   Fri, 16 Sep 2022 13:20:41 -0700
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next] bpf: Move nf_conn extern declarations to
 filter.h
Content-Language: en-US
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     pablo@netfilter.org, fw@strlen.de, toke@kernel.org,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, memxor@gmail.com
References: <c4cb11c8ffe732b91c175a0fc80d43b2547ca17e.1662920329.git.dxu@dxuuu.xyz>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <c4cb11c8ffe732b91c175a0fc80d43b2547ca17e.1662920329.git.dxu@dxuuu.xyz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/11/22 11:19 AM, Daniel Xu wrote:
> We're seeing the following new warnings on netdev/build_32bit and
> netdev/build_allmodconfig_warn CI jobs:
> 
>      ../net/core/filter.c:8608:1: warning: symbol
>      'nf_conn_btf_access_lock' was not declared. Should it be static?
>      ../net/core/filter.c:8611:5: warning: symbol 'nfct_bsa' was not
>      declared. Should it be static?
> 
> Fix by ensuring extern declaration is present while compiling filter.o.
> 
> Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
> ---
>   include/linux/filter.h                   | 6 ++++++
>   include/net/netfilter/nf_conntrack_bpf.h | 7 +------
>   2 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 527ae1d64e27..96de256b2c8d 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -567,6 +567,12 @@ struct sk_filter {
>   
>   DECLARE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
>   
> +extern struct mutex nf_conn_btf_access_lock;
> +extern int (*nfct_bsa)(struct bpf_verifier_log *log, const struct btf *btf,
> +		       const struct btf_type *t, int off, int size,
> +		       enum bpf_access_type atype, u32 *next_btf_id,
> +		       enum bpf_type_flag *flag);

Can it avoid leaking the nfct specific details like 
'nf_conn_btf_access_lock' and the null checking on 'nfct_bsa' to 
filter.c?  In particular, this code snippet in filter.c:

         mutex_lock(&nf_conn_btf_access_lock);
         if (nfct_bsa)
                 ret = nfct_bsa(log, btf, ....);
	mutex_unlock(&nf_conn_btf_access_lock);


Can the lock and null check be done as one function (eg. 
nfct_btf_struct_access()) in nf_conntrack_bpf.c and use it in filter.c 
instead?

btw, 'bsa' stands for btf_struct_access? It is a bit too short to guess ;)

Also, please add a Fixes tag.

