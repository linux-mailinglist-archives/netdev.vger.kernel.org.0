Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACBDA1877FF
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 04:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgCQDKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 23:10:46 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45124 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726803AbgCQDKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 23:10:46 -0400
Received: by mail-qk1-f194.google.com with SMTP id c145so30152616qke.12;
        Mon, 16 Mar 2020 20:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xytRqayxQuC5eMurSet0/Fcn3iTENtGu+EYSbqGw130=;
        b=FmkrITYHFTvNr2BFMCHmyNzEbaygEXkRwYT+8L0le+HLxl7aGPYi36zK0x7FfTwSwB
         uZb59tI0dw8kYrxot+xGA3E0atoOHLXnDg8yjGywR3tFsrMUZAgS7rsKgUzzrRFsqd3U
         UuTgqQCIWnkl0sX1kPaECVc/M2Bv3iWdvE0TVecs9OBdTxt/DSu42AMmUgkkxz07mwar
         vjvvu7NBP9WWChqr5SkBnBvXL2eeHdzSIUK7vUNFt+AyTmP0FKg2g4KqFG1YW54J9ynC
         6qnTG5K+o1V/6vBZB+Lfr7jqPol3wCokdknh0ecTlMiEOsBfz74g3L+YuTxysQg5ZkUa
         AxzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xytRqayxQuC5eMurSet0/Fcn3iTENtGu+EYSbqGw130=;
        b=d/6Q3TVCC6Rhr/PQtoWt3o4dYCMftxwWclvUVzLngXbAeTD7EubMs7L8LlGjl4ZoyG
         wotdiImTMMmdG/K8gbvEKrAf+zo5oeAjM7NrDIExmJqmKcCITJ6SYck6I4TvLchg37id
         yv6BTgRwxVRT0AJXS74PC7KO4EqG2vnoutmWDqewZ5TWvWV6/AlQXNJCxttEQgu8LL/v
         XLgLGUAwcPATc1UywztMAMeiQP1yVzN0ePFKaDH2hCGU6f5OmBqKMuiJmHcBqVCbLPS1
         lBLdfvPZToXqVD0hm7F64N/lKR1weAZdTu284lFAF6aC1pwnW5iklX19bhCwiZhyl4Xa
         1EpQ==
X-Gm-Message-State: ANhLgQ3oedVauUvxM1aSusP49Pw867efEZw7nXZd7wHPv0LKUeU+NEgm
        CIFEMcqbc3ilqcWMYxoLaGnprFfhjG9+99MasPgEXcVG
X-Google-Smtp-Source: ADFU+vsxWiPD6zajQiVO96SdqcjDR+VfTl8TzIOFs4++mO88cdmCIZd5MLG43yOIn7OfsmfddPz3GyqCL0uQlTwBZ7c=
X-Received: by 2002:ae9:c011:: with SMTP id u17mr2924638qkk.92.1584414642995;
 Mon, 16 Mar 2020 20:10:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200317011654.zkx5r7so53skowlc@google.com>
In-Reply-To: <20200317011654.zkx5r7so53skowlc@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 16 Mar 2020 20:10:31 -0700
Message-ID: <CAEf4BzYTJqWU++QnQupxFBWGSMPfGt6r-5u9jbeLnEF2ipw+Mw@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: Support llvm-objcopy and llvm-objdump for
 vmlinux BTF
To:     Fangrui Song <maskray@google.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        clang-built-linux@googlegroups.com,
        Stanislav Fomichev <sdf@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 16, 2020 at 6:17 PM Fangrui Song <maskray@google.com> wrote:
>
> Simplify gen_btf logic to make it work with llvm-objcopy and
> llvm-objdump.  We just need to retain one section .BTF. To do so, we can
> use a simple objcopy --only-section=.BTF instead of jumping all the
> hoops via an architecture-less binary file.
>
> We use a dd comment to change the e_type field in the ELF header from
> ET_EXEC to ET_REL so that .btf.vmlinux.bin.o will be accepted by lld.
>
> Fixes: df786c9b9476 ("bpf: Force .BTF section start to zero when dumping from vmlinux")
> Cc: Stanislav Fomichev <sdf@google.com>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Tested-by: Nick Desaulniers <ndesaulniers@google.com>
> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> Link: https://github.com/ClangBuiltLinux/linux/issues/871
> Signed-off-by: Fangrui Song <maskray@google.com>
> ---
>  scripts/link-vmlinux.sh | 13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)
>
> diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> index dd484e92752e..84be8d7c361d 100755
> --- a/scripts/link-vmlinux.sh
> +++ b/scripts/link-vmlinux.sh
> @@ -120,18 +120,9 @@ gen_btf()
>
>         info "BTF" ${2}
>         vmlinux_link ${1}
> -       LLVM_OBJCOPY=${OBJCOPY} ${PAHOLE} -J ${1}

Is it really tested? Seems like you just dropped .BTF generation step
completely...

>
> -       # dump .BTF section into raw binary file to link with final vmlinux
> -       bin_arch=$(LANG=C ${OBJDUMP} -f ${1} | grep architecture | \
> -               cut -d, -f1 | cut -d' ' -f2)
> -       bin_format=$(LANG=C ${OBJDUMP} -f ${1} | grep 'file format' | \
> -               awk '{print $4}')
> -       ${OBJCOPY} --change-section-address .BTF=0 \
> -               --set-section-flags .BTF=alloc -O binary \
> -               --only-section=.BTF ${1} .btf.vmlinux.bin
> -       ${OBJCOPY} -I binary -O ${bin_format} -B ${bin_arch} \
> -               --rename-section .data=.BTF .btf.vmlinux.bin ${2}
> +       # Extract .BTF section, change e_type to ET_REL, to link with final vmlinux
> +       ${OBJCOPY} --only-section=.BTF ${1} ${2} && printf '\1' | dd of=${2} conv=notrunc bs=1 seek=16
>  }
>
>  # Create ${2} .o file with all symbols from the ${1} object file
> --
> 2.25.1.481.gfbce0eb801-goog
