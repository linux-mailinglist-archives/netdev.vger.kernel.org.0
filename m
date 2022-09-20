Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 213B35BDC41
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 07:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbiITFVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 01:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbiITFU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 01:20:59 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 731C54DF11;
        Mon, 19 Sep 2022 22:20:57 -0700 (PDT)
Message-ID: <dc251395-78af-2ea3-9049-3b44cb831783@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663651255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TVGJXeiSIPnNsdrflC1unlY5vaATUQ/jFuJkzfR1pHQ=;
        b=btCPPae5EarmsG+9BOWEXhsgz/o3rsduU6OAewWB05fiEuDmdEhsg9roxgZbXBLYSYJRy5
        2rQCzo2ZzUTF5ybbnrwlc5XkMXQw1JpZOtvFMSOFp+oAlA1BYvBeBIMpIgy0uOhE/w8RaP
        /m73rDUTqIEKHTLRGoCZd4VMdBtnEPk=
Date:   Mon, 19 Sep 2022 22:20:47 -0700
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v2 3/3] bpf: Move nf_conn extern declarations to
 filter.h
Content-Language: en-US
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     pablo@netfilter.org, fw@strlen.de, toke@kernel.org,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, memxor@gmail.com
References: <cover.1663616584.git.dxu@dxuuu.xyz>
 <3c00fb8d15d543ae3b5df928c191047145c6b5fe.1663616584.git.dxu@dxuuu.xyz>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <3c00fb8d15d543ae3b5df928c191047145c6b5fe.1663616584.git.dxu@dxuuu.xyz>
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

On 9/19/22 12:44 PM, Daniel Xu wrote:
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
> Fixes: 864b656f82cc ("bpf: Add support for writing to nf_conn:mark")
> Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
> ---
>   include/linux/filter.h                   | 6 ++++++
>   include/net/netfilter/nf_conntrack_bpf.h | 7 +------
>   2 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 75335432fcbc..98e28126c24b 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -567,6 +567,12 @@ struct sk_filter {
>   
>   DECLARE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
>   
> +extern struct mutex nf_conn_btf_access_lock;
> +extern int (*nfct_btf_struct_access)(struct bpf_verifier_log *log, const struct btf *btf,
> +				     const struct btf_type *t, int off, int size,
> +				     enum bpf_access_type atype, u32 *next_btf_id,
> +				     enum bpf_type_flag *flag);
> +
>   typedef unsigned int (*bpf_dispatcher_fn)(const void *ctx,
>   					  const struct bpf_insn *insnsi,
>   					  unsigned int (*bpf_func)(const void *,
> diff --git a/include/net/netfilter/nf_conntrack_bpf.h b/include/net/netfilter/nf_conntrack_bpf.h
> index d1087e4da440..24d1ccc1f8df 100644
> --- a/include/net/netfilter/nf_conntrack_bpf.h
> +++ b/include/net/netfilter/nf_conntrack_bpf.h
> @@ -5,6 +5,7 @@
>   
>   #include <linux/bpf.h>
>   #include <linux/btf.h>
> +#include <linux/filter.h>

The filter.h is only needed by nf_conntrack_bpf.c?  How about moving 
this include to nf_conntrack_bpf.c.  nf_conntrack_bpf.h is included by 
other conntrack core codes.  I would prefer not to spill over 
unnecessary bpf headers to them.  The same goes for the above bpf.h and 
btf.h which are only needed in nf_conntrack_bpf.c also?

>   #include <linux/kconfig.h>
>   #include <linux/mutex.h>

Also, is mutex.h still needed?

>   
> @@ -14,12 +15,6 @@
>   extern int register_nf_conntrack_bpf(void);
>   extern void cleanup_nf_conntrack_bpf(void);
>   
> -extern struct mutex nf_conn_btf_access_lock;
> -extern int (*nfct_btf_struct_access)(struct bpf_verifier_log *log, const struct btf *btf,
> -				     const struct btf_type *t, int off, int size,
> -				     enum bpf_access_type atype, u32 *next_btf_id,
> -				     enum bpf_type_flag *flag);
> -
>   #else
>   
>   static inline int register_nf_conntrack_bpf(void)

