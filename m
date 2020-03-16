Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F92A186AAD
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 13:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731015AbgCPMNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 08:13:07 -0400
Received: from ozlabs.org ([203.11.71.1]:36911 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730931AbgCPMNG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 08:13:06 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48gwDX5qGrz9sPR;
        Mon, 16 Mar 2020 23:13:00 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1584360783;
        bh=snOsoTHH+Aabb2P355c26XBFeN4O7bKpJryxsh2JuUM=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=nQPS5z3PnaQYTsTt7P/efS/59UTCNapp72VHWbUlw6Boi8EHWDevOs0BAo7bzLfe5
         69gBYNoWSNfIfk6v1m3ENsZMn8BcodFjz/lCWpBAmCI1nzcIGUjcwN8Ig8jQ2uPAf3
         UVJvfSCS+iMkpZJUEPPGfZsabq5aPSvSmHJ/CkfIpaegrhvk2ulyj8SpbtDLuJxA8R
         +tWR6HC/UnIB9M/LLb+FakMYq7wRQH0ZziMOBjCSxFW+Ey6K2M/N4MXRz/2+h3F9O7
         +gI+L2/8/7CoQMqZTCHt430UgCq5hHGa73aiV1jubhatUfSNQalXY+JxM1p9HluHvj
         UsFiCFb3egm4w==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Shuah Khan <skhan@linuxfoundation.org>, shuah@kernel.org,
        keescook@chromium.org, luto@amacapital.net, wad@chromium.org,
        daniel@iogearbox.net, kafai@fb.com, yhs@fb.com, andriin@fb.com,
        gregkh@linuxfoundation.org, tglx@linutronix.de
Cc:     Shuah Khan <skhan@linuxfoundation.org>, khilman@baylibre.com,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v3] selftests: Fix seccomp to support relocatable build (O=objdir)
In-Reply-To: <20200313212404.24552-1-skhan@linuxfoundation.org>
References: <20200313212404.24552-1-skhan@linuxfoundation.org>
Date:   Mon, 16 Mar 2020 23:12:57 +1100
Message-ID: <8736a8qz06.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Shuah Khan <skhan@linuxfoundation.org> writes:
> Fix seccomp relocatable builds. This is a simple fix to use the right
> lib.mk variable TEST_GEN_PROGS with dependency on kselftest_harness.h
> header, and defining LDFLAGS for pthread lib.
>
> Removes custom clean rule which is no longer necessary with the use of
> TEST_GEN_PROGS. 
>
> Uses $(OUTPUT) defined in lib.mk to handle build relocation.
>
> The following use-cases work with this change:
>
> In seccomp directory:
> make all and make clean
>
> From top level from main Makefile:
> make kselftest-install O=objdir ARCH=arm64 HOSTCC=gcc \
>  CROSS_COMPILE=aarch64-linux-gnu- TARGETS=seccomp
>
> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> ---
>
> Changes since v2:
> -- Using TEST_GEN_PROGS is sufficient to generate objects.
>    Addresses review comments from Kees Cook.
>
>  tools/testing/selftests/seccomp/Makefile | 18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)
>
> diff --git a/tools/testing/selftests/seccomp/Makefile b/tools/testing/selftests/seccomp/Makefile
> index 1760b3e39730..a0388fd2c3f2 100644
> --- a/tools/testing/selftests/seccomp/Makefile
> +++ b/tools/testing/selftests/seccomp/Makefile
> @@ -1,17 +1,15 @@
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
> +TEST_GEN_PROGS := $(OUTPUT)/seccomp_bpf $(OUTPUT)/seccomp_benchmark
>  
> -seccomp_bpf: seccomp_bpf.c ../kselftest_harness.h
> -	$(CC) $(CFLAGS) $(LDFLAGS) $< -lpthread -o $@
> +$(TEST_GEN_PROGS): ../kselftest_harness.h
>  
> -TEST_PROGS += $(BINARIES)
> -EXTRA_CLEAN := $(BINARIES)
> +all: $(TEST_GEN_PROGS)
>  
> -all: $(BINARIES)


It shouldn't be that complicated. We just need to define TEST_GEN_PROGS
before including lib.mk, and then add the dependency on the harness
after we include lib.mk (so that TEST_GEN_PROGS has been updated to
prefix $(OUTPUT)).

eg:

  # SPDX-License-Identifier: GPL-2.0
  CFLAGS += -Wl,-no-as-needed -Wall
  LDFLAGS += -lpthread
  
  TEST_GEN_PROGS := seccomp_bpf seccomp_benchmark
  
  include ../lib.mk
  
  $(TEST_GEN_PROGS): ../kselftest_harness.h


Normal in-tree build:

  selftests$ make TARGETS=seccomp
  make[1]: Entering directory '/home/michael/linux/tools/testing/selftests/seccomp'
  gcc -Wl,-no-as-needed -Wall  -lpthread  seccomp_bpf.c ../kselftest_harness.h  -o /home/michael/linux/tools/testing/selftests/seccomp/seccomp_bpf
  gcc -Wl,-no-as-needed -Wall  -lpthread  seccomp_benchmark.c ../kselftest_harness.h  -o /home/michael/linux/tools/testing/selftests/seccomp/seccomp_benchmark
  make[1]: Leaving directory '/home/michael/linux/tools/testing/selftests/seccomp'
  
  selftests$ ls -l seccomp/
  total 388
  -rw-rw-r-- 1 michael michael     41 Jan  9 12:00 config
  -rw-rw-r-- 1 michael michael    201 Mar 16 23:04 Makefile
  -rwxrwxr-x 1 michael michael  70824 Mar 16 23:07 seccomp_benchmark*
  -rw-rw-r-- 1 michael michael   2289 Feb 17 21:39 seccomp_benchmark.c
  -rwxrwxr-x 1 michael michael 290520 Mar 16 23:07 seccomp_bpf*
  -rw-rw-r-- 1 michael michael  94778 Mar  5 23:33 seccomp_bpf.c


O= build:

  selftests$ make TARGETS=seccomp O=$PWD/build
  make[1]: Entering directory '/home/michael/linux/tools/testing/selftests/seccomp'
  gcc -Wl,-no-as-needed -Wall  -lpthread  seccomp_bpf.c ../kselftest_harness.h  -o /home/michael/linux/tools/testing/selftests/build/seccomp/seccomp_bpf
  gcc -Wl,-no-as-needed -Wall  -lpthread  seccomp_benchmark.c ../kselftest_harness.h  -o /home/michael/linux/tools/testing/selftests/build/seccomp/seccomp_benchmark
  make[1]: Leaving directory '/home/michael/linux/tools/testing/selftests/seccomp'
  
  selftests$ ls -l build/seccomp/
  total 280
  -rwxrwxr-x 1 michael michael  70824 Mar 16 23:05 seccomp_benchmark*
  -rwxrwxr-x 1 michael michael 290520 Mar 16 23:05 seccomp_bpf*


Build in the directory itself:
  selftests$ cd seccomp
  seccomp$ make
  gcc -Wl,-no-as-needed -Wall  -lpthread  seccomp_bpf.c ../kselftest_harness.h  -o /home/michael/linux/tools/testing/selftests/seccomp/seccomp_bpf
  gcc -Wl,-no-as-needed -Wall  -lpthread  seccomp_benchmark.c ../kselftest_harness.h  -o /home/michael/linux/tools/testing/selftests/seccomp/seccomp_benchmark
  
  seccomp$ ls -l
  total 388
  -rw-rw-r-- 1 michael michael     41 Jan  9 12:00 config
  -rw-rw-r-- 1 michael michael    201 Mar 16 23:04 Makefile
  -rwxrwxr-x 1 michael michael  70824 Mar 16 23:06 seccomp_benchmark*
  -rw-rw-r-- 1 michael michael   2289 Feb 17 21:39 seccomp_benchmark.c
  -rwxrwxr-x 1 michael michael 290520 Mar 16 23:06 seccomp_bpf*
  -rw-rw-r-- 1 michael michael  94778 Mar  5 23:33 seccomp_bpf.c


cheers
