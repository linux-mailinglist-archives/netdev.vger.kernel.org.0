Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9611890DB
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 22:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbgCQVzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 17:55:33 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46912 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbgCQVzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 17:55:33 -0400
Received: by mail-pl1-f196.google.com with SMTP id r3so2169541pls.13
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 14:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zn81+2/mHk8JESolQzJ6TzVtfsQLsPwXnqDsT+ejuXo=;
        b=kvPHVjN5VLJkY+zPwBfaI5ugUbGUW07j5+5opHWYkQGT4WA/KGQKux1S124XYMUSv2
         K1ZokW++9IUPnAV+pBMkNj0u6mXPgOcfA4YezcauwrKvu+AmUzLUVpfYZC0HfiQ04caQ
         wuLtUJld5XJkXQ0+ZYDsg1InZOs6yNdKCKrUU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zn81+2/mHk8JESolQzJ6TzVtfsQLsPwXnqDsT+ejuXo=;
        b=NRWhSdr9rbFjvnY0qrThqGSgZHoGUx8FX4ESM+6AvdvTXBRB+ahLOoQ/7/nK49WVF9
         1b8ZsBtQWNaw8KSEP65w/8kBLcrL+xZXrx/jhXIc4uwiNBTZ7BWXCdCzL3rzCFYspiaK
         DGoPrUA4lSDfP10UHhDzLxXY/LXmHjHVlY3QsES3WxnWOS1MdjBCqoSsHq/WcrCJuVsc
         LCmsl3Qm3sbtJT6ZJuhI4Xtz/qQRh3r3sUIsmWMDNdItR0YeR2D3X52D6OWZYcNAb0Cs
         4Qpcb/P5hDVeu4gK3Qubees3xjBvDZSTAK8KkokURldCmKN0LcUzxb3PlnekYx2jX7z/
         eFdQ==
X-Gm-Message-State: ANhLgQ04unEw4ESkWJQhqVHMhYDbghESdTlPiCXLzfpvrmq8DV1BX3+w
        YhTu5irszgs9/p/4Gg4qa+sFaQ==
X-Google-Smtp-Source: ADFU+vuDoOd7dNeJ1bq2Y8mMWgKcKIJumLJz07tfVH+Hr+m45zVJeDmANfwyhsAW8q5z87Z+gY14kA==
X-Received: by 2002:a17:902:7298:: with SMTP id d24mr778151pll.134.1584482131815;
        Tue, 17 Mar 2020 14:55:31 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id g2sm3507364pgi.20.2020.03.17.14.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 14:55:31 -0700 (PDT)
Date:   Tue, 17 Mar 2020 14:55:30 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Fangrui Song <maskray@google.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        clang-built-linux@googlegroups.com,
        Stanislav Fomichev <sdf@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH bpf-next v5] bpf: Support llvm-objcopy and llvm-objdump
 for vmlinux BTF
Message-ID: <202003171451.6B11E25636@keescook>
References: <20200317211649.o4fzaxrzy6qxvz4f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317211649.o4fzaxrzy6qxvz4f@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 02:16:49PM -0700, Fangrui Song wrote:
> Simplify gen_btf logic to make it work with llvm-objcopy and llvm-objdump.
> The existing 'file format' and 'architecture' parsing logic is brittle
> and does not work with llvm-objcopy/llvm-objdump.
> 
> .BTF in .tmp_vmlinux.btf is non-SHF_ALLOC. Add the SHF_ALLOC flag and
> rename .BTF to BTF so that C code can reference the section via linker
> synthesized __start_BTF and __stop_BTF. This fixes a small problem that
> previous .BTF had the SHF_WRITE flag. Additionally, `objcopy -I binary`
> synthesized symbols _binary__btf_vmlinux_bin_start and
> _binary__btf_vmlinux_bin_start (not used elsewhere) are replaced with
> more common __start_BTF and __stop_BTF.

I'm glad to see the name change benefit here. Just reducing the number
of execs in this path is only worth this change, IMO. Going from 2
objdump and 2 objcopy calls to a single objcopy is very nice. :)

> 
> Add 2>/dev/null because GNU objcopy (but not llvm-objcopy) warns
> "empty loadable segment detected at vaddr=0xffffffff81000000, is this intentional?"
> 
> We use a dd command to change the e_type field in the ELF header from
> ET_EXEC to ET_REL so that lld will accept .btf.vmlinux.bin.o.  Accepting
> ET_EXEC as an input file is an extremely rare GNU ld feature that lld
> does not intend to support, because this is error-prone.

Nice ELF trick. :)

> 
> Fixes: df786c9b9476 ("bpf: Force .BTF section start to zero when dumping from vmlinux")
> Cc: Stanislav Fomichev <sdf@google.com>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> Link: https://github.com/ClangBuiltLinux/linux/issues/871
> Signed-off-by: Fangrui Song <maskray@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  kernel/bpf/btf.c        |  9 ++++-----
>  kernel/bpf/sysfs_btf.c  | 11 +++++------
>  scripts/link-vmlinux.sh | 17 ++++++-----------
>  3 files changed, 15 insertions(+), 22 deletions(-)
> 
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 50080add2ab9..6f397c4da05e 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -3477,8 +3477,8 @@ static struct btf *btf_parse(void __user *btf_data, u32 btf_data_size,
>  	return ERR_PTR(err);
>  }
> -extern char __weak _binary__btf_vmlinux_bin_start[];
> -extern char __weak _binary__btf_vmlinux_bin_end[];
> +extern char __weak __start_BTF[];
> +extern char __weak __stop_BTF[];
>  extern struct btf *btf_vmlinux;
>  #define BPF_MAP_TYPE(_id, _ops)
> @@ -3605,9 +3605,8 @@ struct btf *btf_parse_vmlinux(void)
>  	}
>  	env->btf = btf;
> -	btf->data = _binary__btf_vmlinux_bin_start;
> -	btf->data_size = _binary__btf_vmlinux_bin_end -
> -		_binary__btf_vmlinux_bin_start;
> +	btf->data = __start_BTF;
> +	btf->data_size = __stop_BTF - __start_BTF;
>  	err = btf_parse_hdr(env);
>  	if (err)
> diff --git a/kernel/bpf/sysfs_btf.c b/kernel/bpf/sysfs_btf.c
> index 7ae5dddd1fe6..3b495773de5a 100644
> --- a/kernel/bpf/sysfs_btf.c
> +++ b/kernel/bpf/sysfs_btf.c
> @@ -9,15 +9,15 @@
>  #include <linux/sysfs.h>
>  /* See scripts/link-vmlinux.sh, gen_btf() func for details */
> -extern char __weak _binary__btf_vmlinux_bin_start[];
> -extern char __weak _binary__btf_vmlinux_bin_end[];
> +extern char __weak __start_BTF[];
> +extern char __weak __stop_BTF[];
>  static ssize_t
>  btf_vmlinux_read(struct file *file, struct kobject *kobj,
>  		 struct bin_attribute *bin_attr,
>  		 char *buf, loff_t off, size_t len)
>  {
> -	memcpy(buf, _binary__btf_vmlinux_bin_start + off, len);
> +	memcpy(buf, __start_BTF + off, len);
>  	return len;
>  }
> @@ -30,15 +30,14 @@ static struct kobject *btf_kobj;
>  static int __init btf_vmlinux_init(void)
>  {
> -	if (!_binary__btf_vmlinux_bin_start)
> +	if (!__start_BTF)
>  		return 0;
>  	btf_kobj = kobject_create_and_add("btf", kernel_kobj);
>  	if (!btf_kobj)
>  		return -ENOMEM;
> -	bin_attr_btf_vmlinux.size = _binary__btf_vmlinux_bin_end -
> -				    _binary__btf_vmlinux_bin_start;
> +	bin_attr_btf_vmlinux.size = __stop_BTF - __start_BTF;
>  	return sysfs_create_bin_file(btf_kobj, &bin_attr_btf_vmlinux);
>  }
> diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> index ac569e197bfa..ae2048625f1e 100755
> --- a/scripts/link-vmlinux.sh
> +++ b/scripts/link-vmlinux.sh
> @@ -133,17 +133,12 @@ gen_btf()
>  	info "BTF" ${2}
>  	LLVM_OBJCOPY=${OBJCOPY} ${PAHOLE} -J ${1}
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
> +	# Extract .BTF, add SHF_ALLOC, rename to BTF so that we can reference
> +	# it via linker synthesized __start_BTF and __stop_BTF. Change e_type
> +	# to ET_REL so that it can be used to link final vmlinux.
> +	${OBJCOPY} --only-section=.BTF --set-section-flags .BTF=alloc,readonly \
> +		--rename-section .BTF=BTF ${1} ${2} 2>/dev/null && \
> +		printf '\1' | dd of=${2} conv=notrunc bs=1 seek=16 status=none
>  }
>  # Create ${2} .o file with all symbols from the ${1} object file
> -- 
> 2.25.1.481.gfbce0eb801-goog

-- 
Kees Cook
