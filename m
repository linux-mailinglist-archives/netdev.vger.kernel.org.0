Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6944531D3C
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 23:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbiEWVAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 17:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiEWVAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 17:00:34 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53BF39156;
        Mon, 23 May 2022 14:00:31 -0700 (PDT)
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ntFAD-00045c-Px; Mon, 23 May 2022 23:00:29 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1ntFAD-000BZ8-9q; Mon, 23 May 2022 23:00:29 +0200
Subject: Re: [PATCH v2] libbpf: Fix determine_ptr_size() guessing
To:     Douglas RAILLARD <douglas.raillard@arm.com>, bpf@vger.kernel.org
Cc:     beata.michalska@arm.com, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
References: <20220523102955.43844-1-douglas.raillard@arm.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <4268b7c5-458e-32cc-36c4-79058be0480e@iogearbox.net>
Date:   Mon, 23 May 2022 23:00:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220523102955.43844-1-douglas.raillard@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26550/Mon May 23 10:05:39 2022)
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/23/22 12:29 PM, Douglas RAILLARD wrote:
> From: Douglas Raillard <douglas.raillard@arm.com>
> 
> One strategy employed by libbpf to guess the pointer size is by finding
> the size of "unsigned long" type. This is achieved by looking for a type
> of with the expected name and checking its size.
> 
> Unfortunately, the C syntax is friendlier to humans than to computers
> as there is some variety in how such a type can be named. Specifically,
> gcc and clang do not use the same name in debug info.

Could you elaborate for the commit msg what both emit differently?

> Lookup all the names for such a type so that libbpf can hope to find the
> information it wants.
> 
> Signed-off-by: Douglas Raillard <douglas.raillard@arm.com>
> ---
>   tools/lib/bpf/btf.c | 15 +++++++++++++--
>   1 file changed, 13 insertions(+), 2 deletions(-)
> 
>   CHANGELOG
> 	v2:
> 		* Added missing case for "long"
> 
> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> index 1383e26c5d1f..ab92b3bc2724 100644
> --- a/tools/lib/bpf/btf.c
> +++ b/tools/lib/bpf/btf.c
> @@ -489,8 +489,19 @@ static int determine_ptr_size(const struct btf *btf)
>   		if (!name)
>   			continue;
>   
> -		if (strcmp(name, "long int") == 0 ||
> -		    strcmp(name, "long unsigned int") == 0) {
> +		if (
> +			strcmp(name, "long") == 0 ||
> +			strcmp(name, "long int") == 0 ||
> +			strcmp(name, "int long") == 0 ||
> +			strcmp(name, "unsigned long") == 0 ||
> +			strcmp(name, "long unsigned") == 0 ||
> +			strcmp(name, "unsigned long int") == 0 ||
> +			strcmp(name, "unsigned int long") == 0 ||
> +			strcmp(name, "long unsigned int") == 0 ||
> +			strcmp(name, "long int unsigned") == 0 ||
> +			strcmp(name, "int unsigned long") == 0 ||
> +			strcmp(name, "int long unsigned") == 0
> +		) {

I was wondering whether strstr(3) or regexec(3) would be better, but then it's
probably not worth it and having the different combinations spelled out is
probably still better. Pls make sure though to stick to kernel coding convention
(similar alignment around strcmp() as the lines you remove).

>   			if (t->size != 4 && t->size != 8)
>   				continue;
>   			return t->size;
> 

Thanks,
Daniel
