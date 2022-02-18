Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FBF14BC2E1
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 00:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240185AbiBRXa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 18:30:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240182AbiBRXa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 18:30:57 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744FAEB164;
        Fri, 18 Feb 2022 15:30:40 -0800 (PST)
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nLChz-0008on-0I; Sat, 19 Feb 2022 00:30:39 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nLChy-000QNe-Pa; Sat, 19 Feb 2022 00:30:38 +0100
Subject: Re: [PATCH bpf-next] bpftool: Remove usage of reallocarray()
To:     =?UTF-8?Q?Mauricio_V=c3=a1squez?= <mauricio@kinvolk.io>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>
References: <20220218203906.317687-1-mauricio@kinvolk.io>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <0958851a-2ff7-d51c-0e90-1c3e04207529@iogearbox.net>
Date:   Sat, 19 Feb 2022 00:30:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220218203906.317687-1-mauricio@kinvolk.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26457/Fri Feb 18 10:25:22 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/18/22 9:39 PM, Mauricio Vásquez wrote:
> This commit fixes a compilation error on systems with glibc < 2.26 [0]:
> 
> ```
> In file included from main.h:14:0,
>                   from gen.c:24:
> linux/tools/include/tools/libc_compat.h:11:21: error: attempt to use poisoned "reallocarray"
>   static inline void *reallocarray(void *ptr, size_t nmemb, size_t size)
> ```
> 
> This happens because gen.c pulls <bpf/libbpf_internal.h>, and then
> <tools/libc_compat.h> (through main.h). When
> COMPAT_NEED_REALLOCARRAY is set, libc_compat.h defines reallocarray()
> which libbpf_internal.h poisons with a GCC pragma.
> 
> This follows the same approach of libbpf in commit
> 029258d7b228 ("libbpf: Remove any use of reallocarray() in libbpf").
> 
> Reported-by: Quentin Monnet <quentin@isovalent.com>
> Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
> 
> [0]: https://lore.kernel.org/bpf/3bf2bd49-9f2d-a2df-5536-bc0dde70a83b@isovalent.com/
[...]
> + * Copied from tools/lib/bpf/libbpf_internal.h
> + */
> +static inline void *bpftool_reallocarray(void *ptr, size_t nmemb, size_t size)
> +{
> +	size_t total;
> +
> +#if __has_builtin(__builtin_mul_overflow)
> +	if (unlikely(__builtin_mul_overflow(nmemb, size, &total)))
> +		return NULL;
> +#else
> +	if (size == 0 || nmemb > ULONG_MAX / size)
> +		return NULL;
> +	total = nmemb * size;
> +#endif
> +	return realloc(ptr, total);
> +}

Can't we just reuse libbpf_reallocarray() given we copy over libbpf_internal.h
anyway via a9caaba399f9 ("bpftool: Implement "gen min_core_btf" logic")?

Thanks,
Daniel
