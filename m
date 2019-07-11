Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 748C465973
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 16:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728976AbfGKOzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 10:55:46 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:33918 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727612AbfGKOzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 10:55:46 -0400
Received: by mail-yw1-f67.google.com with SMTP id q128so3974418ywc.1;
        Thu, 11 Jul 2019 07:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/wTXznAXHacr2M4atjecgDzbn+nKVODcA5FmD6XMAP4=;
        b=WciZEy8lVwgZgT81ldMSzos6w+/KauLpkuWCbCsr5gtYSxsz71RpGpGD7j9m33q/gA
         Bmn2GbySZPrVBqQaMbC2t9N57lyG3mi/6owjxj7KubI4jgP4kT8T96S/N+tbKOYHQBS2
         ySLANuFHD+rKPY9CYCra46D6BdrDRxBdD7MDX1/tAVXuN3C3c26radxb9d0yOgQzS46a
         9QHtnWHDuhplHEXtUgWRCT1q+W6ZZjcDcgKWEPd2M7uXZFEcyk9iVn+A5IlSCexEWlLj
         b1UZtr3UOgtBz1g5LnJ/FyM0v3op3WSPyaHDvSmBQAk5CgD+roB8dmonDtfH7QYJn3M9
         Gkvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/wTXznAXHacr2M4atjecgDzbn+nKVODcA5FmD6XMAP4=;
        b=Q41WBwDzl2Ez1dV28w2Pywafaf+cTZEg4+wS+6nwcNcmt+VysG1fgeyZVd19PhMHXx
         M3kFcAm8Nwbyu4dhkFJKKhuOIcWGWSbbqkuMkkXq+md7uXCWlyHh8+2xndjOwoiX+x7X
         7z3vf78+xMh11ss5pPLw6IF4KKRxMHxFWCBuWY8K2FZMr8zTwwbaONkO6LsknJkdA3l2
         EsGlR/cc/cBold4s7rddcOivM2A4WY1NxMr8lv1fTlsoSP+PRN1PqvX4Ar0NLtqKF/0/
         2XEtytRMA5/PcYgexUhuAwnHcHdxN2KZRc4w+HedaGAzkLKLbaI3xzEJ/EXFioln5Lnt
         M2MQ==
X-Gm-Message-State: APjAAAW0QqHcmFF1wbjq15QiwhD4roLTlD5oW99GIgKuNx0+yYvmyArI
        lxL/4m/0dPSwBwKAg94SS7XeY4fVdVWYS10UDVY=
X-Google-Smtp-Source: APXvYqw3mO52fkFWWzI3KkCRsehb0j11TNLr1L8ahhW7JM5kXaaMQRxbk9qBDYiYJAmnkj4EvfA14m0VXltgasFgdLE=
X-Received: by 2002:ac8:2d56:: with SMTP id o22mr2245359qta.171.1562856945396;
 Thu, 11 Jul 2019 07:55:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190711091249.59865-1-iii@linux.ibm.com>
In-Reply-To: <20190711091249.59865-1-iii@linux.ibm.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 11 Jul 2019 07:55:34 -0700
Message-ID: <CAEf4Bzb6mY-F-wUNNimS+hMSRbJetTKXNcGDQbsJXhXDywA+tg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf] selftests/bpf: do not ignore clang failures
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <liu.song.a23@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 11, 2019 at 2:14 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>
> When compiling an eBPF prog fails, make still returns 0, because
> failing clang command's output is piped to llc and therefore its
> exit status is ignored.
>
> When clang fails, pipe the string "clang failed" to llc. This will make
> llc fail with an informative error message. This solution was chosen
> over using pipefail, having separate targets or getting rid of llc
> invocation due to its simplicity.
>
> In addition, pull Kbuild.include in order to get .DELETE_ON_ERROR target,

In your original patch you explicitly declared .DELETE_ON_ERROR, but
in this one you just include Kbuild.include.
Is it enough to just include that file to get desired behavior or your
forgot to add .DELETE_ON_ERROR?

> which would cause partial .o files to be removed.
>
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> ---

Thanks!

Acked-by: Andrii Nakryiko <andriin@fb.com>

> v1->v2: use intermediate targets instead of pipefail
> v2->v3: pipe "clang failed" instead of using intermediate targets
>
> tools/testing/selftests/bpf/Makefile | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index e36356e2377e..e375f399b7a6 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -1,4 +1,5 @@
>  # SPDX-License-Identifier: GPL-2.0
> +include ../../../../scripts/Kbuild.include
>
>  LIBDIR := ../../../lib
>  BPFDIR := $(LIBDIR)/bpf
> @@ -185,8 +186,8 @@ $(ALU32_BUILD_DIR)/test_progs_32: prog_tests/*.c
>
>  $(ALU32_BUILD_DIR)/%.o: progs/%.c $(ALU32_BUILD_DIR) \
>                                         $(ALU32_BUILD_DIR)/test_progs_32
> -       $(CLANG) $(CLANG_FLAGS) \
> -                -O2 -target bpf -emit-llvm -c $< -o - |      \
> +       ($(CLANG) $(CLANG_FLAGS) -O2 -target bpf -emit-llvm -c $< -o - || \
> +               echo "clang failed") | \
>         $(LLC) -march=bpf -mattr=+alu32 -mcpu=$(CPU) $(LLC_FLAGS) \
>                 -filetype=obj -o $@
>  ifeq ($(DWARF2BTF),y)
> @@ -197,16 +198,16 @@ endif
>  # Have one program compiled without "-target bpf" to test whether libbpf loads
>  # it successfully
>  $(OUTPUT)/test_xdp.o: progs/test_xdp.c
> -       $(CLANG) $(CLANG_FLAGS) \
> -               -O2 -emit-llvm -c $< -o - | \
> +       ($(CLANG) $(CLANG_FLAGS) -O2 -emit-llvm -c $< -o - || \
> +               echo "clang failed") | \
>         $(LLC) -march=bpf -mcpu=$(CPU) $(LLC_FLAGS) -filetype=obj -o $@
>  ifeq ($(DWARF2BTF),y)
>         $(BTF_PAHOLE) -J $@
>  endif
>
>  $(OUTPUT)/%.o: progs/%.c
> -       $(CLANG) $(CLANG_FLAGS) \
> -                -O2 -target bpf -emit-llvm -c $< -o - |      \
> +       ($(CLANG) $(CLANG_FLAGS) -O2 -target bpf -emit-llvm -c $< -o - || \
> +               echo "clang failed") | \
>         $(LLC) -march=bpf -mcpu=$(CPU) $(LLC_FLAGS) -filetype=obj -o $@
>  ifeq ($(DWARF2BTF),y)
>         $(BTF_PAHOLE) -J $@
> --
> 2.21.0
>
