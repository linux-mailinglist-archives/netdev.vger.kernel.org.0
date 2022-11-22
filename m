Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 138036349E5
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 23:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235078AbiKVWQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 17:16:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233239AbiKVWQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 17:16:44 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB5540471
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 14:16:43 -0800 (PST)
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1oxbZI-000MUg-0A; Tue, 22 Nov 2022 23:16:40 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1oxbZH-000Brd-HP; Tue, 22 Nov 2022 23:16:39 +0100
Subject: Re: [net-next] bpf: avoid the multi checking
To:     xiangxia.m.yue@gmail.com
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>
References: <20221121100521.56601-1-xiangxia.m.yue@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <642514fd-70d3-384a-5b48-323068174997@iogearbox.net>
Date:   Tue, 22 Nov 2022 23:16:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20221121100521.56601-1-xiangxia.m.yue@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.7/26728/Tue Nov 22 09:14:37 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/21/22 11:05 AM, xiangxia.m.yue@gmail.com wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> .map_alloc_check checked bpf_attr::max_entries, and if bpf_attr::max_entries
> == 0, return -EINVAL. bpf_htab::n_buckets will not be 0, while -E2BIG is not
> appropriate.
> 
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Andrii Nakryiko <andrii@kernel.org>
> Cc: Martin KaFai Lau <martin.lau@linux.dev>
> Cc: Song Liu <song@kernel.org>
> Cc: Yonghong Song <yhs@fb.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: KP Singh <kpsingh@kernel.org>
> Cc: Stanislav Fomichev <sdf@google.com>
> Cc: Hao Luo <haoluo@google.com>
> Cc: Jiri Olsa <jolsa@kernel.org>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Pls Cc bpf@vger.kernel.org list and $subj line should target bpf-next.

> ---
>   kernel/bpf/hashtab.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> index 50d254cd0709..22855d6ff6d3 100644
> --- a/kernel/bpf/hashtab.c
> +++ b/kernel/bpf/hashtab.c
> @@ -500,9 +500,10 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
>   		htab->elem_size += round_up(htab->map.value_size, 8);
>   
>   	err = -E2BIG;
> -	/* prevent zero size kmalloc and check for u32 overflow */
> -	if (htab->n_buckets == 0 ||
> -	    htab->n_buckets > U32_MAX / sizeof(struct bucket))
> +	/* avoid zero size and u32 overflow kmalloc.
> +	 * bpf_attr::max_entries checked in .map_alloc_check().
> +	 */
> +	if (htab->n_buckets > U32_MAX / sizeof(struct bucket))

This looks buggy to remove it, this is to guard against the previous
roundup_pow_of_two() on htab->n_buckets.

>   		goto free_htab;
>   
>   	err = -ENOMEM;
> 

