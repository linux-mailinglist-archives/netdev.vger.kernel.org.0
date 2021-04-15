Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09A7C360BFB
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 16:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233522AbhDOOi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 10:38:27 -0400
Received: from www62.your-server.de ([213.133.104.62]:41750 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233363AbhDOOiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 10:38:21 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lX37j-000708-Ga; Thu, 15 Apr 2021 16:37:39 +0200
Received: from [85.7.101.30] (helo=pc-6.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lX37i-000EJ3-8n; Thu, 15 Apr 2021 16:37:38 +0200
Subject: Re: [PATCH bpf-next 1/2] bpf: Remove bpf_jit_enable=2 debugging mode
To:     Jianlin Lv <Jianlin.Lv@arm.com>, bpf@vger.kernel.org
Cc:     corbet@lwn.net, ast@kernel.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, davem@davemloft.net, kuba@kernel.org,
        illusionist.neo@gmail.com, linux@armlinux.org.uk,
        zlim.lnx@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        paulburton@kernel.org, tsbogend@alpha.franken.de,
        naveen.n.rao@linux.ibm.com, sandipan@linux.ibm.com,
        mpe@ellerman.id.au, benh@kernel.crashing.org, paulus@samba.org,
        luke.r.nels@gmail.com, xi.wang@gmail.com, bjorn@kernel.org,
        paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, iii@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, udknight@gmail.com,
        mchehab+huawei@kernel.org, dvyukov@google.com, maheshb@google.com,
        horms@verge.net.au, nicolas.dichtel@6wind.com,
        viro@zeniv.linux.org.uk, masahiroy@kernel.org,
        keescook@chromium.org, quentin@isovalent.com, tklauser@distanz.ch,
        grantseltzer@gmail.com, irogers@google.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        sparclinux@vger.kernel.org, iecedge@gmail.com
References: <20210415093250.3391257-1-Jianlin.Lv@arm.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9c4a78d2-f73c-832a-e6e2-4b4daa729e07@iogearbox.net>
Date:   Thu, 15 Apr 2021 16:37:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210415093250.3391257-1-Jianlin.Lv@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26141/Thu Apr 15 13:13:26 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/15/21 11:32 AM, Jianlin Lv wrote:
> For debugging JITs, dumping the JITed image to kernel log is discouraged,
> "bpftool prog dump jited" is much better way to examine JITed dumps.
> This patch get rid of the code related to bpf_jit_enable=2 mode and
> update the proc handler of bpf_jit_enable, also added auxiliary
> information to explain how to use bpf_jit_disasm tool after this change.
> 
> Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>
[...]
> diff --git a/arch/x86/net/bpf_jit_comp32.c b/arch/x86/net/bpf_jit_comp32.c
> index 0a7a2870f111..8d36b4658076 100644
> --- a/arch/x86/net/bpf_jit_comp32.c
> +++ b/arch/x86/net/bpf_jit_comp32.c
> @@ -2566,9 +2566,6 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>   		cond_resched();
>   	}
>   
> -	if (bpf_jit_enable > 1)
> -		bpf_jit_dump(prog->len, proglen, pass + 1, image);
> -
>   	if (image) {
>   		bpf_jit_binary_lock_ro(header);
>   		prog->bpf_func = (void *)image;
> diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
> index c8496c1142c9..990b1720c7a4 100644
> --- a/net/core/sysctl_net_core.c
> +++ b/net/core/sysctl_net_core.c
> @@ -273,16 +273,8 @@ static int proc_dointvec_minmax_bpf_enable(struct ctl_table *table, int write,
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
>   	return ret;
>   }
>   
> @@ -389,7 +381,7 @@ static struct ctl_table net_core_table[] = {
>   		.extra2		= SYSCTL_ONE,
>   # else
>   		.extra1		= SYSCTL_ZERO,
> -		.extra2		= &two,
> +		.extra2		= SYSCTL_ONE,
>   # endif
>   	},
>   # ifdef CONFIG_HAVE_EBPF_JIT
> diff --git a/tools/bpf/bpf_jit_disasm.c b/tools/bpf/bpf_jit_disasm.c
> index c8ae95804728..efa4b17ae016 100644
> --- a/tools/bpf/bpf_jit_disasm.c
> +++ b/tools/bpf/bpf_jit_disasm.c
> @@ -7,7 +7,7 @@
>    *
>    * To get the disassembly of the JIT code, do the following:
>    *
> - *  1) `echo 2 > /proc/sys/net/core/bpf_jit_enable`
> + *  1) Insert bpf_jit_dump() and recompile the kernel to output JITed image into log

Hmm, if we remove bpf_jit_dump(), the next drive-by cleanup patch will be thrown
at bpf@vger stating that bpf_jit_dump() has no in-tree users and should be removed.
Maybe we should be removing bpf_jit_disasm.c along with it as well as bpf_jit_dump()
itself ... I guess if it's ever needed in those rare occasions for JIT debugging we
can resurrect it from old kernels just locally. But yeah, bpftool's jit dump should
suffice for vast majority of use cases.

There was a recent set for ppc32 jit which was merged into ppc tree which will create
a merge conflict with this one [0]. So we would need a rebase and take it maybe during
merge win once the ppc32 landed..

   [0] https://lore.kernel.org/bpf/cover.1616430991.git.christophe.leroy@csgroup.eu/

>    *  2) Load a BPF filter (e.g. `tcpdump -p -n -s 0 -i eth1 host 192.168.20.0/24`)
>    *  3) Run e.g. `bpf_jit_disasm -o` to read out the last JIT code
>    *
> diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
> index 40a88df275f9..98c7eec2923f 100644
> --- a/tools/bpf/bpftool/feature.c
> +++ b/tools/bpf/bpftool/feature.c
> @@ -203,9 +203,6 @@ static void probe_jit_enable(void)
>   		case 1:
>   			printf("JIT compiler is enabled\n");
>   			break;
> -		case 2:
> -			printf("JIT compiler is enabled with debugging traces in kernel logs\n");
> -			break;

This would still need to be there for older kernels ...

>   		case -1:
>   			printf("Unable to retrieve JIT-compiler status\n");
>   			break;
> 

