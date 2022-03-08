Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01E744D1B33
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 16:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345286AbiCHPA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 10:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244592AbiCHPA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 10:00:27 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121133917F;
        Tue,  8 Mar 2022 06:59:29 -0800 (PST)
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nRbIu-0007PU-Fm; Tue, 08 Mar 2022 15:59:12 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nRbIu-000R4h-0o; Tue, 08 Mar 2022 15:59:12 +0100
Subject: Re: [PATCH] selftests/bpf: fix array_size.cocci warning
To:     Guo Zhengkui <guozhengkui@vivo.com>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Yucong Sun <sunyucong@gmail.com>,
        Christy Lee <christylee@fb.com>,
        Delyan Kratunov <delyank@fb.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgense?= =?UTF-8?Q?n?= 
        <toke@redhat.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Cc:     zhengkui_guo@outlook.com
References: <20220308091813.28574-1-guozhengkui@vivo.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <cc8cffe8-58ed-27f3-0865-4ac3b2313866@iogearbox.net>
Date:   Tue, 8 Mar 2022 15:59:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220308091813.28574-1-guozhengkui@vivo.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26475/Tue Mar  8 10:31:43 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/8/22 10:17 AM, Guo Zhengkui wrote:
> Fix the array_size.cocci warning in tools/testing/selftests/bpf/
> 
> Use `ARRAY_SIZE(arr)` instead of forms like `sizeof(arr)/sizeof(arr[0])`.
> 
> syscall.c and test_rdonly_maps.c don't contain header files which
> implement ARRAY_SIZE() macro. So I add `#include <linux/kernel.h>`,
> in which ARRAY_SIZE(arr) not only calculates the size of `arr`, but also
> checks that `arr` is really an array (using __must_be_array(arr)).
> 
> Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
[...]
> diff --git a/tools/testing/selftests/bpf/progs/syscall.c b/tools/testing/selftests/bpf/progs/syscall.c
> index e550f728962d..85c6e7849463 100644
> --- a/tools/testing/selftests/bpf/progs/syscall.c
> +++ b/tools/testing/selftests/bpf/progs/syscall.c
> @@ -6,6 +6,7 @@
>   #include <bpf/bpf_tracing.h>
>   #include <../../../tools/include/linux/filter.h>
>   #include <linux/btf.h>
> +#include <linux/kernel.h>
>   
>   char _license[] SEC("license") = "GPL";
>   
> @@ -82,7 +83,7 @@ int bpf_prog(struct args *ctx)
>   	static __u64 value = 34;
>   	static union bpf_attr prog_load_attr = {
>   		.prog_type = BPF_PROG_TYPE_XDP,
> -		.insn_cnt = sizeof(insns) / sizeof(insns[0]),
> +		.insn_cnt = ARRAY_SIZE(insns),
>   	};
>   	int ret;
>   
> diff --git a/tools/testing/selftests/bpf/progs/test_rdonly_maps.c b/tools/testing/selftests/bpf/progs/test_rdonly_maps.c
> index fc8e8a34a3db..ca75aac745a4 100644
> --- a/tools/testing/selftests/bpf/progs/test_rdonly_maps.c
> +++ b/tools/testing/selftests/bpf/progs/test_rdonly_maps.c
> @@ -3,6 +3,7 @@
>   
>   #include <linux/ptrace.h>
>   #include <linux/bpf.h>
> +#include <linux/kernel.h>
>   #include <bpf/bpf_helpers.h>
>   
>   const struct {
> @@ -64,7 +65,7 @@ int full_loop(struct pt_regs *ctx)
>   {
>   	/* prevent compiler to optimize everything out */
>   	unsigned * volatile p = (void *)&rdonly_values.a;
> -	int i = sizeof(rdonly_values.a) / sizeof(rdonly_values.a[0]);
> +	int i = ARRAY_SIZE(rdonly_values.a);
>   	unsigned iters = 0, sum = 0;
>   

There's bpf_util.h with ARRAY_SIZE definition which is used in selftests, pls change to
reuse that one.

Thanks,
Daniel
