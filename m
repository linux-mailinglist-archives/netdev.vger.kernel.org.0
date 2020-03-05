Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4A06179DC4
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 03:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgCECUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 21:20:49 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:37782 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbgCECUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 21:20:48 -0500
Received: by mail-pj1-f66.google.com with SMTP id o2so1820521pjp.2
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 18:20:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=o7EoAC0uRM8GPyBvo7DIt0uzNdUVYvkGswKAIdWl07g=;
        b=Ymv11zsoqj+1jPfTSuqq1+O5QZKNyI1Zpv3lSfH5TkQPlk9VjfVJ75WHgXD3D9eWaZ
         pALGV+GU0/1woinJclUpH+wq+coH/o67/15kiSpuFGUy0GTYVaE7xSUYZo0M0lGjMlBM
         ysd1WVAvhITtOUGS5hQB3UnogP+VoFec4vz64=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o7EoAC0uRM8GPyBvo7DIt0uzNdUVYvkGswKAIdWl07g=;
        b=fOchFhQCZrMn0sZJrQ/Ejvh4ilibem+uYxoffskx90MepPghSys0jMGGXZY/PThRwA
         B5wATSFRnvjOycEnitr/44IcuoRPpj1+jBPoGIg77zOyyLcXDGD0fGcOj6OkNG4VUY7+
         EGWuaM19rtg4vUlRUQ4n0A8GDaWAhP5DxbpXUawxmFGtWLq5Q959J8L30f5E93awaQ52
         MjyfNCFJGcZPURLTH9HCJ3h624/OtXPleyxe8T+NvNPp1N6u5w9jtqA6Wn4epv5HdYJU
         5Yz3e1XIuhhJlZqLWdsYDJzOipOYa1ICI59tjpRv5ecAKjqu8/QtzCiJCLN4V5k3AKkY
         BJtg==
X-Gm-Message-State: ANhLgQ17pcld2pE6PW54mWQdSvs9ZWB9BCcp8ivdJAj3gTTS35Lv35OD
        VUlfvbBj3910A352BGqyp51fKw==
X-Google-Smtp-Source: ADFU+vsYvHRJ7Or2bcedq/UlSMlYWHcozxCBOy/f+j+Ny96xn3FvobNbqYF1wBvt1WxXN7QWfnNysA==
X-Received: by 2002:a17:90a:8a09:: with SMTP id w9mr6257968pjn.0.1583374847828;
        Wed, 04 Mar 2020 18:20:47 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id a9sm4006971pjk.1.2020.03.04.18.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 18:20:46 -0800 (PST)
Date:   Wed, 4 Mar 2020 18:20:45 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     shuah@kernel.org, luto@amacapital.net, wad@chromium.org,
        daniel@iogearbox.net, kafai@fb.com, yhs@fb.com, andriin@fb.com,
        gregkh@linuxfoundation.org, tglx@linutronix.de,
        khilman@baylibre.com, mpe@ellerman.id.au,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v2 2/4] selftests: Fix seccomp to support relocatable
 build (O=objdir)
Message-ID: <202003041815.B8C73DEC@keescook>
References: <20200305003627.31900-1-skhan@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305003627.31900-1-skhan@linuxfoundation.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 04, 2020 at 05:36:27PM -0700, Shuah Khan wrote:
> Fix seccomp relocatable builds. This is a simple fix to use the
> right lib.mk variable TEST_CUSTOM_PROGS to continue to do custom
> build to preserve dependency on kselftest_harness.h local header.
> This change applies cutom rule to seccomp_bpf seccomp_benchmark
> for a simpler logic. 
> 
> Uses $(OUTPUT) defined in lib.mk to handle build relocation.
> 
> The following use-cases work with this change:
> 
> In seccomp directory:
> make all and make clean

This works.

> 
> From top level from main Makefile:
> make kselftest-install O=objdir ARCH=arm64 HOSTCC=gcc \
>  CROSS_COMPILE=aarch64-linux-gnu- TARGETS=seccomp

This fails for me:

$ make kselftest-install O=objdir ARCH=arm64 HOSTCC=gcc CROSS_COMPILE=aarch64-linux-gnu- TARGETS=seccomp
make[1]: Entering directory '/home/kees/src/linux/objdir'
make --no-builtin-rules INSTALL_HDR_PATH=$BUILD/usr \
        ARCH=arm64 -C ../../.. headers_install
make[4]: ../scripts/Makefile.build: No such file or directory
make[4]: *** No rule to make target '../scripts/Makefile.build'.  Stop.
make[3]: *** [Makefile:501: scripts_basic] Error 2
make[2]: *** [Makefile:151: khdr] Error 2
make[1]: *** [/home/kees/src/linux/Makefile:1221: kselftest-install] Error 2
make[1]: Leaving directory '/home/kees/src/linux/objdir'
make: *** [Makefile:180: sub-make] Error 2

(My "objdir" is empty)

If I remove O=objdir everything is fine. And see below...

> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> ---
>  tools/testing/selftests/seccomp/Makefile | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/testing/selftests/seccomp/Makefile b/tools/testing/selftests/seccomp/Makefile
> index 1760b3e39730..355bcbc0394a 100644
> --- a/tools/testing/selftests/seccomp/Makefile
> +++ b/tools/testing/selftests/seccomp/Makefile
> @@ -1,17 +1,16 @@
>  # SPDX-License-Identifier: GPL-2.0
> -all:
> -
> -include ../lib.mk
> +CFLAGS += -Wl,-no-as-needed -Wall
> +LDFLAGS += -lpthread
>  
>  .PHONY: all clean
>  
> -BINARIES := seccomp_bpf seccomp_benchmark
> -CFLAGS += -Wl,-no-as-needed -Wall
> +include ../lib.mk
> +
> +# OUTPUT set by lib.mk
> +TEST_CUSTOM_PROGS := $(OUTPUT)/seccomp_bpf $(OUTPUT)/seccomp_benchmark
>  
> -seccomp_bpf: seccomp_bpf.c ../kselftest_harness.h
> -	$(CC) $(CFLAGS) $(LDFLAGS) $< -lpthread -o $@
> +$(TEST_CUSTOM_PROGS): ../kselftest_harness.h
>  
> -TEST_PROGS += $(BINARIES)
> -EXTRA_CLEAN := $(BINARIES)
> +all: $(TEST_CUSTOM_PROGS)
>  
> -all: $(BINARIES)
> +EXTRA_CLEAN := $(TEST_CUSTOM_PROGS)
> -- 
> 2.20.1
> 

Instead of the TEST_CUSTOM_PROGS+all dance, you can just add an explicit
dependency, with the final seccomp/Makefile looking like this:


# SPDX-License-Identifier: GPL-2.0
CFLAGS += -Wl,-no-as-needed -Wall
LDFLAGS += -lpthread

TEST_GEN_PROGS := seccomp_bpf seccomp_benchmark

include ../lib.mk

# Additional dependencies
$(OUTPUT)/seccomp_bpf: ../kselftest_harness.h


(Though this fails in the same way as above when run from the top-level
directory.)

-Kees

-- 
Kees Cook
