Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBC1910A691
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 23:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbfKZWap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 17:30:45 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:43909 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbfKZWao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 17:30:44 -0500
Received: by mail-qk1-f196.google.com with SMTP id p14so17697453qkm.10;
        Tue, 26 Nov 2019 14:30:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FidiGMTsMCOfAb66c4tFbCAZdT7KiDhevD7/dwITgV8=;
        b=LPFsT3ybGxrGHR7YiIe/SZHFAhsD/gogqGoNweGBLMWJhopsNs6cnMLuZvd2gVsjcR
         PWZPFhrvn6jwEWUGLEIP2/WVmyKCjtPtAEPgud//keEwmuFhngZr9VSyObxF12fcqFSb
         jsrtOyimJqY3b7mCnGXR4PGZNxqE8mdsE+bjpx8M4Dfi+Xi11XbrijFko3LD2H0jCE+X
         I0WzEVK3LBSWyNeo8bIraqXf4rxgmNeoekUilZQQkNKwPpSQWmRI0n+A5Z1vF+ayixln
         c/xISodWw3KxTQua/1wu3aBARbx9e9NhTWprxlaiRNKE//YfIenUidLnzQJMKSZhgVPW
         BEUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FidiGMTsMCOfAb66c4tFbCAZdT7KiDhevD7/dwITgV8=;
        b=CQGDpPUfAOsXOpWw+SP69qgcFkxZ3pdwB+d5TF2IjTw2+JUZ23UJQMxB7oAHlYdwsA
         beuzmRHtmZ5EziaJP/5XSUqyBI6gpcQBx9RTdlpIAerJ7ZsY8bXOtYtFGXswEucLe9H2
         AUKjXASR7WIIgXi31/xXCpx43FjLGcXM6F49BE820pMogEsLLifASwsoGlKra5JBcscb
         gjYO0AmsE1jRl18YtFxTC4tflFOYvhGlC61Lcy4P9FskqcOiLLPo0aYGc9hx0Kqakxl/
         b5PgKufP72F6C0aogLKiQS3ZJ+gSACZfy2St/PqS62BP4pQ/A6q+lYbbqf+qkgG0PrdF
         Z66A==
X-Gm-Message-State: APjAAAVKQArJmgG5GrsmZnuuDaNTBxZsg7F+CQXitnNOcMxz0ptpQ1jg
        lXtfbPGdZd4O9TluU9blhilHp5RIO3Pac+jJd08=
X-Google-Smtp-Source: APXvYqyz2SG0uyjPjg+wOg3Tp5fHd1mnGuVGYUHa42GU8BN/y1U66GVxwaJhKR6ykCZAL3xbxPtRwZjM5Q8CMSNeQuY=
X-Received: by 2002:a37:a685:: with SMTP id p127mr889065qke.449.1574807442878;
 Tue, 26 Nov 2019 14:30:42 -0800 (PST)
MIME-Version: 1.0
References: <20191126174221.200522-1-sdf@google.com>
In-Reply-To: <20191126174221.200522-1-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 26 Nov 2019 14:30:31 -0800
Message-ID: <CAEf4BzZ+e4vnW7Gconhq3AJ5od=TULAZC=-+UANFDGXcWCoOSA@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: support pre-2.25-binutils objcopy for vmlinux BTF
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 26, 2019 at 9:56 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> If vmlinux BTF generation fails, but CONFIG_DEBUG_INFO_BTF is set,
> .BTF section of vmlinux is empty and kernel will prohibit
> BPF loading and return "in-kernel BTF is malformed".
>
> --dump-section argument to binutils' objcopy was added in version 2.25.
> When using pre-2.25 binutils, BTF generation silently fails. Convert
> to --only-section which is present on pre-2.25 binutils.
>
> Documentation/process/changes.rst states that binutils 2.21+
> is supported, not sure those standards apply to BPF subsystem.
>
> Fixes: 341dfcf8d78ea ("btf: expose BTF info through sysfs")
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

Looks good, still works for me :)

Tested-by: Andrii Nakryiko <andriin@fb.com>

>  scripts/link-vmlinux.sh | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> index 06495379fcd8..c56ba91f52b0 100755
> --- a/scripts/link-vmlinux.sh
> +++ b/scripts/link-vmlinux.sh
> @@ -127,7 +127,8 @@ gen_btf()
>                 cut -d, -f1 | cut -d' ' -f2)
>         bin_format=$(LANG=C ${OBJDUMP} -f ${1} | grep 'file format' | \
>                 awk '{print $4}')
> -       ${OBJCOPY} --dump-section .BTF=.btf.vmlinux.bin ${1} 2>/dev/null
> +       ${OBJCOPY} --set-section-flags .BTF=alloc -O binary \
> +               --only-section=.BTF ${1} .btf.vmlinux.bin 2>/dev/null
>         ${OBJCOPY} -I binary -O ${bin_format} -B ${bin_arch} \
>                 --rename-section .data=.BTF .btf.vmlinux.bin ${2}
>  }
> --
> 2.24.0.432.g9d3f5f5b63-goog
>
