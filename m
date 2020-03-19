Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECD5218AC6B
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 06:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgCSFqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 01:46:04 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:38021 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgCSFqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 01:46:04 -0400
Received: by mail-pj1-f67.google.com with SMTP id m15so515167pje.3
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 22:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ru5neFweJumNPNlzao84Aj5kHcPfSkI6AXdUVCHgqkI=;
        b=ack+gQ09BgNOxheRNxLXssdG8WwF6aMIqMjghX/BYEbpmBzesuWWdlbx+Dy9MbQgym
         KEeRXe5+RHocj0AU8J2OZpDZtlQczPEf1yGD1nUO8h8pFD3d1uI4K4CiS83lb88NBPD0
         FHxO4GUa2nogNvVO31K4V9Pr2PIx8mpIn8AFk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ru5neFweJumNPNlzao84Aj5kHcPfSkI6AXdUVCHgqkI=;
        b=LFfAbfG7CwLUGKKxeM7LDtfiAIxCjtaSyPcO+hNPPC7l1+Pmwjt9HmWPxaZm2nNcgR
         C6tnVm0lh7HFJcPIDzmt3Lh6kJ1pkTWTvGnxjmx0Gh7P21HQEoKs1zB7VNcDg/YZf1/m
         BEm2d/A0kfvqJtYbeVf8xYAmHG7vw5vmqDsgefIuvb1lgP+0OSUZbC6mTbW+QaTLb9HL
         sZgfjskzlCSwVfvT4KjVOrcNNWMn/sIzLhE3fh5YmWvHeLBl2FgSyABRhNpWAs/5dlIC
         b0QpolfBzwvyStv6CqxiCSnWqGt9rdWk2+UZ3w2H1zdvTjKi4+Muhn+AFYFzPTh10yN6
         4e3Q==
X-Gm-Message-State: ANhLgQ2G+OnW36nvf0f7wTuaojzZ9IR/TcxZAeh/jZH0G5cSqzR/Q8Re
        FiqHmFPp7a4p58qVY/xJjkAIDA==
X-Google-Smtp-Source: ADFU+vvl28xd57Avm1nubGBb/R+VAa9+RPK6ULc8sp9uq7zrN9TMCEbtA66Gqme7dndG2/IqxG4aeA==
X-Received: by 2002:a17:90b:370e:: with SMTP id mg14mr441874pjb.16.1584596761585;
        Wed, 18 Mar 2020 22:46:01 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id k24sm904433pgm.61.2020.03.18.22.46.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 22:46:00 -0700 (PDT)
Date:   Wed, 18 Mar 2020 22:45:59 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Fangrui Song <maskray@google.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH bpf-next v6] bpf: Support llvm-objcopy for vmlinux BTF
Message-ID: <202003182245.589A6B5@keescook>
References: <20200318222746.173648-1-maskray@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318222746.173648-1-maskray@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 03:27:46PM -0700, Fangrui Song wrote:
> Simplify gen_btf logic to make it work with llvm-objcopy. The existing
> 'file format' and 'architecture' parsing logic is brittle and does not
> work with llvm-objcopy/llvm-objdump.
> 'file format' output of llvm-objdump>=11 will match GNU objdump, but
> 'architecture' (bfdarch) may not.
> 
> .BTF in .tmp_vmlinux.btf is non-SHF_ALLOC. Add the SHF_ALLOC flag
> because it is part of vmlinux image used for introspection. C code can
> reference the section via linker script defined __start_BTF and
> __stop_BTF. This fixes a small problem that previous .BTF had the
> SHF_WRITE flag (objcopy -I binary -O elf* synthesized .data).
> 
> Additionally, `objcopy -I binary` synthesized symbols
> _binary__btf_vmlinux_bin_start and _binary__btf_vmlinux_bin_stop (not
> used elsewhere) are replaced with more commonplace __start_BTF and
> __stop_BTF.
> 
> Add 2>/dev/null because GNU objcopy (but not llvm-objcopy) warns
> "empty loadable segment detected at vaddr=0xffffffff81000000, is this intentional?"
> 
> We use a dd command to change the e_type field in the ELF header from
> ET_EXEC to ET_REL so that lld will accept .btf.vmlinux.bin.o.  Accepting
> ET_EXEC as an input file is an extremely rare GNU ld feature that lld
> does not intend to support, because this is error-prone.
> 
> The output section description .BTF in include/asm-generic/vmlinux.lds.h
> avoids potential subtle orphan section placement issues and suppresses
> --orphan-handling=warn warnings.
> 
> v6:
> - drop llvm-objdump from the title. We don't run objdump now
> - delete unused local variables: bin_arch, bin_format and bin_file
> - mention in the comment that lld does not allow an ET_EXEC input
> - rename BTF back to .BTF . The section name is assumed by bpftool
> - add output section description to include/asm-generic/vmlinux.lds.h
> - mention cb0cc635c7a9 ("powerpc: Include .BTF section")
> 
> v5:
> - rebase on top of bpf-next/master
> - rename .BTF to BTF
> 
> Fixes: df786c9b9476 ("bpf: Force .BTF section start to zero when dumping from vmlinux")
> Fixes: cb0cc635c7a9 ("powerpc: Include .BTF section")
> Link: https://github.com/ClangBuiltLinux/linux/issues/871
> Signed-off-by: Fangrui Song <maskray@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> Reviewed-by: Stanislav Fomichev <sdf@google.com>
> Tested-by: Stanislav Fomichev <sdf@google.com>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: clang-built-linux@googlegroups.com
> ---
>  arch/powerpc/kernel/vmlinux.lds.S |  6 ------
>  include/asm-generic/vmlinux.lds.h | 15 +++++++++++++++
>  kernel/bpf/btf.c                  |  9 ++++-----
>  kernel/bpf/sysfs_btf.c            | 11 +++++------
>  scripts/link-vmlinux.sh           | 24 ++++++++++--------------
>  5 files changed, 34 insertions(+), 31 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
> index a32d478a7f41..b4c89a1acebb 100644
> --- a/arch/powerpc/kernel/vmlinux.lds.S
> +++ b/arch/powerpc/kernel/vmlinux.lds.S
> @@ -303,12 +303,6 @@ SECTIONS
>  		*(.branch_lt)
>  	}
>  
> -#ifdef CONFIG_DEBUG_INFO_BTF
> -	.BTF : AT(ADDR(.BTF) - LOAD_OFFSET) {
> -		*(.BTF)
> -	}
> -#endif
> -
>  	.opd : AT(ADDR(.opd) - LOAD_OFFSET) {
>  		__start_opd = .;
>  		KEEP(*(.opd))
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index e00f41aa8ec4..39da8d8b561d 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -535,6 +535,7 @@
>  									\
>  	RO_EXCEPTION_TABLE						\
>  	NOTES								\
> +	BTF								\
>  									\
>  	. = ALIGN((align));						\
>  	__end_rodata = .;
> @@ -621,6 +622,20 @@
>  		__stop___ex_table = .;					\
>  	}
>  
> +/*
> + * .BTF
> + */
> +#ifdef CONFIG_DEBUG_INFO_BTF
> +#define BTF								\
> +	.BTF : AT(ADDR(.BTF) - LOAD_OFFSET) {				\
> +		__start_BTF = .;					\
> +		*(.BTF)							\
> +		__stop_BTF = .;						\
> +	}
> +#else
> +#define BTF
> +#endif
> +
>  /*
>   * Init task
>   */
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 50080add2ab9..6f397c4da05e 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -3477,8 +3477,8 @@ static struct btf *btf_parse(void __user *btf_data, u32 btf_data_size,
>  	return ERR_PTR(err);
>  }
>  
> -extern char __weak _binary__btf_vmlinux_bin_start[];
> -extern char __weak _binary__btf_vmlinux_bin_end[];
> +extern char __weak __start_BTF[];
> +extern char __weak __stop_BTF[];
>  extern struct btf *btf_vmlinux;
>  
>  #define BPF_MAP_TYPE(_id, _ops)
> @@ -3605,9 +3605,8 @@ struct btf *btf_parse_vmlinux(void)
>  	}
>  	env->btf = btf;
>  
> -	btf->data = _binary__btf_vmlinux_bin_start;
> -	btf->data_size = _binary__btf_vmlinux_bin_end -
> -		_binary__btf_vmlinux_bin_start;
> +	btf->data = __start_BTF;
> +	btf->data_size = __stop_BTF - __start_BTF;
>  
>  	err = btf_parse_hdr(env);
>  	if (err)
> diff --git a/kernel/bpf/sysfs_btf.c b/kernel/bpf/sysfs_btf.c
> index 7ae5dddd1fe6..3b495773de5a 100644
> --- a/kernel/bpf/sysfs_btf.c
> +++ b/kernel/bpf/sysfs_btf.c
> @@ -9,15 +9,15 @@
>  #include <linux/sysfs.h>
>  
>  /* See scripts/link-vmlinux.sh, gen_btf() func for details */
> -extern char __weak _binary__btf_vmlinux_bin_start[];
> -extern char __weak _binary__btf_vmlinux_bin_end[];
> +extern char __weak __start_BTF[];
> +extern char __weak __stop_BTF[];
>  
>  static ssize_t
>  btf_vmlinux_read(struct file *file, struct kobject *kobj,
>  		 struct bin_attribute *bin_attr,
>  		 char *buf, loff_t off, size_t len)
>  {
> -	memcpy(buf, _binary__btf_vmlinux_bin_start + off, len);
> +	memcpy(buf, __start_BTF + off, len);
>  	return len;
>  }
>  
> @@ -30,15 +30,14 @@ static struct kobject *btf_kobj;
>  
>  static int __init btf_vmlinux_init(void)
>  {
> -	if (!_binary__btf_vmlinux_bin_start)
> +	if (!__start_BTF)
>  		return 0;
>  
>  	btf_kobj = kobject_create_and_add("btf", kernel_kobj);
>  	if (!btf_kobj)
>  		return -ENOMEM;
>  
> -	bin_attr_btf_vmlinux.size = _binary__btf_vmlinux_bin_end -
> -				    _binary__btf_vmlinux_bin_start;
> +	bin_attr_btf_vmlinux.size = __stop_BTF - __start_BTF;
>  
>  	return sysfs_create_bin_file(btf_kobj, &bin_attr_btf_vmlinux);
>  }
> diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> index ac569e197bfa..d09ab4afbda4 100755
> --- a/scripts/link-vmlinux.sh
> +++ b/scripts/link-vmlinux.sh
> @@ -113,9 +113,6 @@ vmlinux_link()
>  gen_btf()
>  {
>  	local pahole_ver
> -	local bin_arch
> -	local bin_format
> -	local bin_file
>  
>  	if ! [ -x "$(command -v ${PAHOLE})" ]; then
>  		echo >&2 "BTF: ${1}: pahole (${PAHOLE}) is not available"
> @@ -133,17 +130,16 @@ gen_btf()
>  	info "BTF" ${2}
>  	LLVM_OBJCOPY=${OBJCOPY} ${PAHOLE} -J ${1}
>  
> -	# dump .BTF section into raw binary file to link with final vmlinux
> -	bin_arch=$(LANG=C ${OBJDUMP} -f ${1} | grep architecture | \
> -		cut -d, -f1 | cut -d' ' -f2)
> -	bin_format=$(LANG=C ${OBJDUMP} -f ${1} | grep 'file format' | \
> -		awk '{print $4}')
> -	bin_file=.btf.vmlinux.bin
> -	${OBJCOPY} --change-section-address .BTF=0 \
> -		--set-section-flags .BTF=alloc -O binary \
> -		--only-section=.BTF ${1} $bin_file
> -	${OBJCOPY} -I binary -O ${bin_format} -B ${bin_arch} \
> -		--rename-section .data=.BTF $bin_file ${2}
> +	# Create ${2} which contains just .BTF section but no symbols. Add
> +	# SHF_ALLOC because .BTF will be part of the vmlinux image. --strip-all
> +	# deletes all symbols including __start_BTF and __stop_BTF, which will
> +	# be redefined in the linker script. Add 2>/dev/null to suppress GNU
> +	# objcopy warnings: "empty loadable segment detected at ..."
> +	${OBJCOPY} --only-section=.BTF --set-section-flags .BTF=alloc,readonly \
> +		--strip-all ${1} ${2} 2>/dev/null
> +	# Change e_type to ET_REL so that it can be used to link final vmlinux.
> +	# Unlike GNU ld, lld does not allow an ET_EXEC input.
> +	printf '\1' | dd of=${2} conv=notrunc bs=1 seek=16 status=none
>  }
>  
>  # Create ${2} .o file with all symbols from the ${1} object file
> -- 
> 2.25.1.481.gfbce0eb801-goog
> 

-- 
Kees Cook
