Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF421448B2
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 01:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728842AbgAVAGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 19:06:06 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:41721 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgAVAGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 19:06:05 -0500
Received: by mail-qk1-f195.google.com with SMTP id x129so4690564qke.8;
        Tue, 21 Jan 2020 16:06:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dLQ+QI++eCjlyAt/BPhwKj9mJwMzoHkPG5/0tL6ZnQU=;
        b=NkUmJmAS/2iCKF4LmTItJ92DYd5DIifuu7d47SeBDHxG7VcscD/iFZprmsKSaYsPGW
         IGj/AWfp0fFt1lPWNoFcMyuOMcbRapp8qLEdY/3BY5naJqorz2dkOBsccg9wHs+k6zq5
         wuXwAG2pIPFJuWwMf5ORAS68nKz7eJkVuFhvd09Xi6AK7Bgt1JyaEc7kbyi2ub023Jqq
         2zmBYQWZR8B7y+l1uM2TuqblpMTtpPSmEjacnV4eW1nxbNxi2Ceh7EX2aBmmOrwFvUSW
         emH3tQ6H+XZYSpxgEJ3aWMrJL7dLtfPGTKPRjlJJDEGn2A+slUOEHMrkhMsdUNTyKj9P
         LK5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dLQ+QI++eCjlyAt/BPhwKj9mJwMzoHkPG5/0tL6ZnQU=;
        b=da9y9qF8QAVUEt3Wfc8koNG79psGjERwt7gcMxM/fxPKTphyJDxJjfHcRLFJEU3D7R
         +1vawcziaXU9I5urlLFk/QxOSjT4vtmmcSIS//+7Fuz5eoS4MeAvYmolC/aM6pabKxn/
         PgJa3TB/2P/DJmZ7XJ8E8IkDnaS1MUI7BGz8o7fyI5vjKZW9GqiddJY/OCmKcNPMgpC5
         YOamN27NrLfZnCqotD6L2vXbDFOewFCg4Nx+Ndo+/tNzftwJngzp7a7ZOTg/sDk2D9Tp
         66dAu1u1IuoF0ENFKupPWtKq8AtSZDyQSPS335s6HwagXjzO+tIj5oNxHNGKxGn7PAhX
         nu9g==
X-Gm-Message-State: APjAAAUoavMcQGB9HkP0cscmA1JodQKZEZkEoYFhAIeT7Al0yC4Xkpai
        LGVWiP1Tc4CmPmXrQCUQ9s86ZL6ZhODcU+JBabd8Wg==
X-Google-Smtp-Source: APXvYqzJ8OTfF01CvmYbMSUlDK0hU2AW4rw/a991qNolBkJLBm7yY/VmVPA6ZpEmHTyJ6GmmwIKrLdrsZCX0CLdBXFk=
X-Received: by 2002:a05:620a:5ae:: with SMTP id q14mr7456752qkq.437.1579651564807;
 Tue, 21 Jan 2020 16:06:04 -0800 (PST)
MIME-Version: 1.0
References: <20200122000110.GA310073@chrisdown.name>
In-Reply-To: <20200122000110.GA310073@chrisdown.name>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 21 Jan 2020 16:05:53 -0800
Message-ID: <CAEf4BzZnOFfw102XiG4yJNTR63fT-_QHFU7QSu2apvrz=i_TWQ@mail.gmail.com>
Subject: Re: [PATCH v2] bpf: btf: Always output invariant hit in pahole DWARF
 to BTF transform
To:     Chris Down <chris@chrisdown.name>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 4:01 PM Chris Down <chris@chrisdown.name> wrote:
>
> When trying to compile with CONFIG_DEBUG_INFO_BTF enabled, I got this
> error:
>
>     % make -s
>     Failed to generate BTF for vmlinux
>     Try to disable CONFIG_DEBUG_INFO_BTF
>     make[3]: *** [vmlinux] Error 1
>
> Compiling again without -s shows the true error (that pahole is
> missing), but since this is fatal, we should show the error
> unconditionally on stderr as well, not silence it using the `info`
> function. With this patch:
>
>     % make -s
>     BTF: .tmp_vmlinux.btf: pahole (pahole) is not available
>     Failed to generate BTF for vmlinux
>     Try to disable CONFIG_DEBUG_INFO_BTF
>     make[3]: *** [vmlinux] Error 1
>
> Signed-off-by: Chris Down <chris@chrisdown.name>
> Cc: Stanislav Fomichev <sdf@google.com>
> Cc: Andrii Nakryiko <andriin@fb.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: bpf@vger.kernel.org
> Cc: kernel-team@fb.com
> ---
>  scripts/link-vmlinux.sh | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>

Looks great, thanks!

Acked-by: Andrii Nakryiko <andriin@fb.com>

> diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> index c287ad9b3a67..bbe9be2bf5ff 100755
> --- a/scripts/link-vmlinux.sh
> +++ b/scripts/link-vmlinux.sh
> @@ -108,13 +108,13 @@ gen_btf()
>         local bin_arch
>
>         if ! [ -x "$(command -v ${PAHOLE})" ]; then
> -               info "BTF" "${1}: pahole (${PAHOLE}) is not available"
> +               echo >&2 "BTF: ${1}: pahole (${PAHOLE}) is not available"
>                 return 1
>         fi
>
>         pahole_ver=$(${PAHOLE} --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/')
>         if [ "${pahole_ver}" -lt "113" ]; then
> -               info "BTF" "${1}: pahole version $(${PAHOLE} --version) is too old, need at least v1.13"
> +               echo >&2 "BTF: ${1}: pahole version $(${PAHOLE} --version) is too old, need at least v1.13"
>                 return 1
>         fi
>
> --
> 2.25.0
>
