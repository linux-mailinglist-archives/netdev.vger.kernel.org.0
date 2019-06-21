Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 579A14EF37
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 21:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfFUTFl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 21 Jun 2019 15:05:41 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33758 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbfFUTFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 15:05:41 -0400
Received: by mail-qk1-f194.google.com with SMTP id r6so5255348qkc.0;
        Fri, 21 Jun 2019 12:05:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Bs68w98Lk2x5fHDgGrsEkmRuP6ZkSQPkRKBlrV+oAE4=;
        b=mvWspQpYaMOl/z20Vg4K6KMl5YE1qjLgIZ0MThVNQ3l7uXfj98NbA4u7KzpumRDnVL
         d5rAVhxqEuqDdITIAgTi0GBzBRNP4XZXQCLQWUEOBamWLwfI2XK9sjeuid7oRfR61TWO
         uNJJAHM5wSRN/ciGf9Qxai9PiwFXoLgIEiVC5Mq5RHuX45LlacUA0AqQKYNuTptfpwkq
         MXSQ+s6gOabGwVhL2LLRgRbjWRiVBs0wb9qoUnZjIIo3cV7m+VZBu1R3QZSNEmXt4WFi
         4UyciiwBMTW5bckA2fcmNHm05kU1DozEWNNc+VcE2fOE5IEFUfizk/YNocvmyJYDtHG3
         WPgA==
X-Gm-Message-State: APjAAAUO0b1OwJFD6MnQS63ornHik16iYEbuKI9tRFVllctLaLYmfJSm
        wlmuQ3ne5flGUfd8CDl1U21gGInBBPDdQ3jvQ9/6KgxfmwA=
X-Google-Smtp-Source: APXvYqwUU+VkQWpTMoIjDb5bQvxyzXXtgVkgQyvcfcc7h89W5RgD3UZ89GU3RZg0xa4iRgidvBiDZCiTuH4KdZt9JaA=
X-Received: by 2002:a37:dcc7:: with SMTP id v190mr112639822qki.286.1561143939732;
 Fri, 21 Jun 2019 12:05:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190604101409.2078-1-yamada.masahiro@socionext.com> <20190604101409.2078-16-yamada.masahiro@socionext.com>
In-Reply-To: <20190604101409.2078-16-yamada.masahiro@socionext.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 21 Jun 2019 21:05:22 +0200
Message-ID: <CAK8P3a08f25WYP5r57JHPcZWieS2+07=_qTphLosS4M2w8F0Zw@mail.gmail.com>
Subject: Re: [PATCH 15/15] kbuild: compile test UAPI headers to ensure they
 are self-contained
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        David Howells <dhowells@redhat.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-riscv@lists.infradead.org,
        Michal Marek <michal.lkml@markovi.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Palmer Dabbelt <palmer@sifive.com>, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Albert Ou <aou@eecs.berkeley.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 4, 2019 at 12:16 PM Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:

> --- a/Makefile
> +++ b/Makefile
> @@ -1363,7 +1363,7 @@ CLEAN_DIRS  += $(MODVERDIR) include/ksym
>  CLEAN_FILES += modules.builtin.modinfo
>
>  # Directories & files removed with 'make mrproper'
> -MRPROPER_DIRS  += include/config usr/include include/generated          \
> +MRPROPER_DIRS  += include/config include/generated          \
>                   arch/$(SRCARCH)/include/generated .tmp_objdiff
>  MRPROPER_FILES += .config .config.old .version \
>                   Module.symvers tags TAGS cscope* GPATH GTAGS GRTAGS GSYMS \

This change seems to have caused a minor regression:

$ make clean ; make clean
find: ‘*’: No such file or directory

Any idea?

      Arnd
