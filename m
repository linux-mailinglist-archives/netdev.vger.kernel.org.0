Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 933E71707E8
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 19:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbgBZSoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 13:44:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:39466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727064AbgBZSoU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 13:44:20 -0500
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDB1C24672;
        Wed, 26 Feb 2020 18:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582742660;
        bh=+ZEx/SYUVu2ZDVwgEK3NGQTYfgIzerB381AaQx/Qkzk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=SIfWUOyRZWQEPf2QzeE0JXyAMf0b6Mx9HMBh1K8h49+4yMUMEzsoHeUD4kgxxrw1L
         Hn+3kiuqYQOSaNwJX3/cSYmCuesHyP9pSxMz+7cjtWslx1tTQDx4z560b0OOwS6STe
         x659AUCowgYwa2yqs6PMnVuNLcCcVClyiyLYhe3Y=
Received: by mail-lf1-f54.google.com with SMTP id c23so97219lfi.7;
        Wed, 26 Feb 2020 10:44:19 -0800 (PST)
X-Gm-Message-State: ANhLgQ1bRGlCXr0Kh58y1EBN+39OMl5jdWkQEhHNQJGYp73nG5iBezA4
        HKwGbhijkz6qR1DsHD25d6R481lNbU+e/qqPuc0=
X-Google-Smtp-Source: ADFU+vtVO/rAlebwPPt4cAwiiUpRNsvUkm3f2DwFApMRWJ8vfavrHtt7xTlns/ASG7Z3Z78Vx94uKfuUUsGR4+hbBxs=
X-Received: by 2002:ac2:52a2:: with SMTP id r2mr18095lfm.33.1582742657881;
 Wed, 26 Feb 2020 10:44:17 -0800 (PST)
MIME-Version: 1.0
References: <20200226130345.209469-1-jolsa@kernel.org> <20200226130345.209469-2-jolsa@kernel.org>
In-Reply-To: <20200226130345.209469-2-jolsa@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Wed, 26 Feb 2020 10:44:06 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7C49dB1VQrPojO6+CwU1D+LRZWYj-NwkCu_Q0TOwYRgQ@mail.gmail.com>
Message-ID: <CAPhsuW7C49dB1VQrPojO6+CwU1D+LRZWYj-NwkCu_Q0TOwYRgQ@mail.gmail.com>
Subject: Re: [PATCH 01/18] x86/mm: Rename is_kernel_text to __is_kernel_text
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kbuild test robot <lkp@intel.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 5:04 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> The kbuild test robot reported compile issue on x86 in one of
> the following patches that adds <linux/kallsyms.h> include into
> <linux/bpf.h>, which is picked up by init_32.c object.
>
> The problem is that <linux/kallsyms.h> defines global function
> is_kernel_text which colides with the static function of the
> same name defined in init_32.c:
>
>   $ make ARCH=i386
>   ...
>   >> arch/x86/mm/init_32.c:241:19: error: redefinition of 'is_kernel_text'
>     static inline int is_kernel_text(unsigned long addr)
>                       ^~~~~~~~~~~~~~
>    In file included from include/linux/bpf.h:21:0,
>                     from include/linux/bpf-cgroup.h:5,
>                     from include/linux/cgroup-defs.h:22,
>                     from include/linux/cgroup.h:28,
>                     from include/linux/hugetlb.h:9,
>                     from arch/x86/mm/init_32.c:18:
>    include/linux/kallsyms.h:31:19: note: previous definition of 'is_kernel_text' was here
>     static inline int is_kernel_text(unsigned long addr)
>
> Renaming the init_32.c is_kernel_text function to __is_kernel_text.
>
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>
