Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1FC2F35BF
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 17:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392507AbhALQ2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 11:28:24 -0500
Received: from www62.your-server.de ([213.133.104.62]:39698 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404607AbhALQ2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 11:28:24 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kzMWD-00016u-DA; Tue, 12 Jan 2021 17:27:41 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kzMWD-000DeF-6R; Tue, 12 Jan 2021 17:27:41 +0100
Subject: Re: [PATCH v3 bpf-next 5/7] bpf: support BPF ksym variables in kernel
 modules
To:     Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     kernel-team@fb.com, Hao Luo <haoluo@google.com>,
        Yonghong Song <yhs@fb.com>
References: <20210112075520.4103414-1-andrii@kernel.org>
 <20210112075520.4103414-6-andrii@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <4155ef59-9e5e-f596-f22b-ecd4bde73e85@iogearbox.net>
Date:   Tue, 12 Jan 2021 17:27:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210112075520.4103414-6-andrii@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26047/Tue Jan 12 13:33:56 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/12/21 8:55 AM, Andrii Nakryiko wrote:
> Add support for directly accessing kernel module variables from BPF programs
> using special ldimm64 instructions. This functionality builds upon vmlinux
> ksym support, but extends ldimm64 with src_reg=BPF_PSEUDO_BTF_ID to allow
> specifying kernel module BTF's FD in insn[1].imm field.
> 
> During BPF program load time, verifier will resolve FD to BTF object and will
> take reference on BTF object itself and, for module BTFs, corresponding module
> as well, to make sure it won't be unloaded from under running BPF program. The
> mechanism used is similar to how bpf_prog keeps track of used bpf_maps.
> 
> One interesting change is also in how per-CPU variable is determined. The
> logic is to find .data..percpu data section in provided BTF, but both vmlinux
> and module each have their own .data..percpu entries in BTF. So for module's
> case, the search for DATASEC record needs to look at only module's added BTF
> types. This is implemented with custom search function.
> 
> Acked-by: Yonghong Song <yhs@fb.com>
> Acked-by: Hao Luo <haoluo@google.com>
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
[...]
> +
> +struct module *btf_try_get_module(const struct btf *btf)
> +{
> +	struct module *res = NULL;
> +#ifdef CONFIG_DEBUG_INFO_BTF_MODULES
> +	struct btf_module *btf_mod, *tmp;
> +
> +	mutex_lock(&btf_module_mutex);
> +	list_for_each_entry_safe(btf_mod, tmp, &btf_modules, list) {
> +		if (btf_mod->btf != btf)
> +			continue;
> +
> +		if (try_module_get(btf_mod->module))
> +			res = btf_mod->module;

One more thought (follow-up would be okay I'd think) ... when a module references
a symbol from another module, it similarly needs to bump the refcount of the module
that is owning it and thus disallowing to unload for that other module's lifetime.
That usage dependency is visible via /proc/modules however, so if unload doesn't work
then lsmod allows a way to introspect that to the user. This seems to be achieved via
resolve_symbol() where it records its dependency/usage. Would be great if we could at
some point also include the BPF prog name into that list so that this is more obvious.
Wdyt?

> +		break;
> +	}
> +	mutex_unlock(&btf_module_mutex);
> +#endif
> +
> +	return res;
> +}
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 261f8692d0d2..69c3c308de5e 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -2119,6 +2119,28 @@ static void bpf_free_used_maps(struct bpf_prog_aux *aux)
>   	kfree(aux->used_maps);
>   }
>   
> +void __bpf_free_used_btfs(struct bpf_prog_aux *aux,
> +			  struct btf_mod_pair *used_btfs, u32 len)
> +{
> +#ifdef CONFIG_BPF_SYSCALL
> +	struct btf_mod_pair *btf_mod;
> +	u32 i;
> +
> +	for (i = 0; i < len; i++) {
> +		btf_mod = &used_btfs[i];
> +		if (btf_mod->module)
> +			module_put(btf_mod->module);
> +		btf_put(btf_mod->btf);
> +	}
> +#endif
> +}
