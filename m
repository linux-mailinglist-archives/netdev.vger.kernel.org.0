Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2F565C336
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 16:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237979AbjACPmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 10:42:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237990AbjACPmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 10:42:08 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D3211C02;
        Tue,  3 Jan 2023 07:42:06 -0800 (PST)
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pCjQN-000MYy-O6; Tue, 03 Jan 2023 16:41:59 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1pCjQN-00068a-1Y; Tue, 03 Jan 2023 16:41:59 +0100
Subject: Re: [bpf-next v1] bpf: drop deprecated bpf_jit_enable == 2
To:     xxmy@infragraf.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.or, loongarch@lists.linux.dev,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        sparclinux@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Hou Tao <houtao1@huawei.com>
References: <20230103132454.94242-1-xxmy@infragraf.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <cf475fe0-9961-d768-fae3-04f640855dab@iogearbox.net>
Date:   Tue, 3 Jan 2023 16:41:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20230103132454.94242-1-xxmy@infragraf.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.7/26770/Tue Jan  3 09:59:01 2023)
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/3/23 2:24 PM, xxmy@infragraf.org wrote:
> From: Tonghao Zhang <xxmy@infragraf.org>
> 
> The x86_64 can't dump the valid insn in this way. A test BPF prog
> which include subprog:
> 
> $ llvm-objdump -d subprog.o
> Disassembly of section .text:
> 0000000000000000 <subprog>:
>         0:	18 01 00 00 73 75 62 70 00 00 00 00 72 6f 67 00	r1 = 29114459903653235 ll
>         2:	7b 1a f8 ff 00 00 00 00	*(u64 *)(r10 - 8) = r1
>         3:	bf a1 00 00 00 00 00 00	r1 = r10
>         4:	07 01 00 00 f8 ff ff ff	r1 += -8
>         5:	b7 02 00 00 08 00 00 00	r2 = 8
>         6:	85 00 00 00 06 00 00 00	call 6
>         7:	95 00 00 00 00 00 00 00	exit
> Disassembly of section raw_tp/sys_enter:
> 0000000000000000 <entry>:
>         0:	85 10 00 00 ff ff ff ff	call -1
>         1:	b7 00 00 00 00 00 00 00	r0 = 0
>         2:	95 00 00 00 00 00 00 00	exit
> 
> kernel print message:
> [  580.775387] flen=8 proglen=51 pass=3 image=ffffffffa000c20c from=kprobe-load pid=1643
> [  580.777236] JIT code: 00000000: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
> [  580.779037] JIT code: 00000010: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
> [  580.780767] JIT code: 00000020: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
> [  580.782568] JIT code: 00000030: cc cc cc
> 
> $ bpf_jit_disasm
> 51 bytes emitted from JIT compiler (pass:3, flen:8)
> ffffffffa000c20c + <x>:
>     0:	int3
>     1:	int3
>     2:	int3
>     3:	int3
>     4:	int3
>     5:	int3
>     ...
> 
> Until bpf_jit_binary_pack_finalize is invoked, we copy rw_header to header
> and then image/insn is valid. BTW, we can use the "bpftool prog dump" JITed instructions.
> 
> * clean up the doc
> * remove bpf_jit_disasm tool
> * set bpf_jit_enable only 0 or 1.
> 
> Signed-off-by: Tonghao Zhang <xxmy@infragraf.org>
> Suggested-by: Alexei Starovoitov <ast@kernel.org>
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
> Cc: Hou Tao <houtao1@huawei.com>
> ---
>   Documentation/admin-guide/sysctl/net.rst |   2 +-
>   Documentation/networking/filter.rst      |  98 +------
>   arch/arm/net/bpf_jit_32.c                |   4 -
>   arch/arm64/net/bpf_jit_comp.c            |   4 -
>   arch/loongarch/net/bpf_jit.c             |   4 -
>   arch/mips/net/bpf_jit_comp.c             |   3 -
>   arch/powerpc/net/bpf_jit_comp.c          |  11 -
>   arch/riscv/net/bpf_jit_core.c            |   3 -
>   arch/s390/net/bpf_jit_comp.c             |   4 -
>   arch/sparc/net/bpf_jit_comp_32.c         |   3 -
>   arch/sparc/net/bpf_jit_comp_64.c         |  13 -
>   arch/x86/net/bpf_jit_comp.c              |   3 -
>   arch/x86/net/bpf_jit_comp32.c            |   3 -
>   net/core/sysctl_net_core.c               |  14 +-
>   tools/bpf/.gitignore                     |   1 -
>   tools/bpf/Makefile                       |  10 +-
>   tools/bpf/bpf_jit_disasm.c               | 332 -----------------------
>   17 files changed, 8 insertions(+), 504 deletions(-)
>   delete mode 100644 tools/bpf/bpf_jit_disasm.c
> 
> diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
> index 6394f5dc2303..45d3d965276c 100644
> --- a/Documentation/admin-guide/sysctl/net.rst
> +++ b/Documentation/admin-guide/sysctl/net.rst
> @@ -87,7 +87,7 @@ Values:
>   
>   	- 0 - disable the JIT (default value)
>   	- 1 - enable the JIT
> -	- 2 - enable the JIT and ask the compiler to emit traces on kernel log.
> +	- 2 - deprecated in linux 6.2

I'd make it more clear in the docs and reword it as follows (also, it'll be in 6.3, not 6.2):

	- 2 - enable the JIT and ask the compiler to emit traces on kernel log.
	      (deprecated since v6.3, use ``bpftool prog dump jited id <id>`` instead)

>   
>   bpf_jit_harden
>   --------------
[...]
> diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
> index 5b1ce656baa1..731a2eb0f68e 100644
> --- a/net/core/sysctl_net_core.c
> +++ b/net/core/sysctl_net_core.c
> @@ -275,16 +275,8 @@ static int proc_dointvec_minmax_bpf_enable(struct ctl_table *table, int write,
>   
>   	tmp.data = &jit_enable;
>   	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
> -	if (write && !ret) {
> -		if (jit_enable < 2 ||
> -		    (jit_enable == 2 && bpf_dump_raw_ok(current_cred()))) {
> -			*(int *)table->data = jit_enable;
> -			if (jit_enable == 2)
> -				pr_warn("bpf_jit_enable = 2 was set! NEVER use this in production, only for JIT debugging!\n");
> -		} else {
> -			ret = -EPERM;
> -		}
> -	}
> +	if (write && !ret)
> +		*(int *)table->data = jit_enable;
>   
>   	if (write && ret && min == max)
>   		pr_info_once("CONFIG_BPF_JIT_ALWAYS_ON is enabled, bpf_jit_enable is permanently set to 1.\n");
> @@ -395,7 +387,7 @@ static struct ctl_table net_core_table[] = {
>   		.extra2		= SYSCTL_ONE,
>   # else
>   		.extra1		= SYSCTL_ZERO,
> -		.extra2		= SYSCTL_TWO,
> +		.extra2		= SYSCTL_ONE,

I'd leave it at SYSCTL_TWO to avoid breakage, just that the semantics of 2 will be the same
as 1 going forward.

>   # endif
>   	},
>   # ifdef CONFIG_HAVE_EBPF_JIT
