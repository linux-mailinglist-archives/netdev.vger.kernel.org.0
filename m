Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E872FDF45
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 03:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404431AbhATXyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 18:54:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49246 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390742AbhATWye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 17:54:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611183187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LP0iiQuizg9LomNFlz79SVokUpxYY8lm5HUjpUc5rfc=;
        b=MG8tT2WdJ4OTMTVBc3knZE91TSWT984EozJjN9wCjK77V+IVZtf+dxF4uZat1fYkMicOHZ
        fQzwtt5ml90JtmwdzMBMDqE+6Nw+5XIRuFz4YEqZpB+4pkEfgNRJLVEEXalOrYtZ1YPshQ
        Jfke08VmFZWgh/Ij+TyvWX1GWouSe0E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-Ox147a_8MbCpG6Q2Jqcg1w-1; Wed, 20 Jan 2021 17:36:04 -0500
X-MC-Unique: Ox147a_8MbCpG6Q2Jqcg1w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A9C51AFAA1;
        Wed, 20 Jan 2021 22:35:58 +0000 (UTC)
Received: from krava (unknown [10.40.194.35])
        by smtp.corp.redhat.com (Postfix) with SMTP id 351176A8E6;
        Wed, 20 Jan 2021 22:35:47 +0000 (UTC)
Date:   Wed, 20 Jan 2021 23:35:46 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Tobias Klauser <tklauser@distanz.ch>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Yulia Kartseva <hex@fb.com>, Andrey Ignatov <rdna@fb.com>,
        Thomas Hebb <tommyhebb@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Davide Caratti <dcaratti@redhat.com>,
        Briana Oursler <briana.oursler@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH RFC] tools: Factor Clang, LLC and LLVM utils definitions
Message-ID: <20210120223546.GF1798087@krava>
References: <20210116095413.72820-1-sedat.dilek@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210116095413.72820-1-sedat.dilek@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 16, 2021 at 10:54:04AM +0100, Sedat Dilek wrote:
> When dealing with BPF/BTF/pahole and DWARF v5 I wanted to build bpftool.
> 
> While looking into the source code I found duplicate assignments
> in misc tools for the LLVM eco system, e.g. clang and llvm-objcopy.
> 
> Move the Clang, LLC and/or LLVM utils definitions to
> tools/scripts/Makefile.include file and add missing
> includes where needed.
> Honestly, I was inspired by commit c8a950d0d3b9
> ("tools: Factor HOSTCC, HOSTLD, HOSTAR definitions").
> 
> I tested with bpftool and perf on Debian/testing AMD64 and
> LLVM/Clang v11.1.0-rc1.
> 
> Build instructions:
> 
> [ make and make-options ]
> MAKE="make V=1"
> MAKE_OPTS="HOSTCC=clang HOSTCXX=clang++ HOSTLD=ld.lld CC=clang LD=ld.lld LLVM=1 LLVM_IAS=1"
> MAKE_OPTS="$MAKE_OPTS PAHOLE=/opt/pahole/bin/pahole"
> 
> [ clean-up ]
> $MAKE $MAKE_OPTS -C tools/ clean
> 
> [ bpftool ]
> $MAKE $MAKE_OPTS -C tools/bpf/bpftool/
> 
> [ perf ]
> PYTHON=python3 $MAKE $MAKE_OPTS -C tools/perf/
> 
> I was careful with respecting the user's wish to override custom compiler,
> linker, GNU/binutils and/or LLVM utils settings.
> 
> Some personal notes:
> 1. I have NOT tested with cross-toolchain for other archs (cross compiler/linker etc.).
> 2. This patch is on top of Linux v5.11-rc3.
> 
> I hope to get some feedback from especially Linux-bpf folks.
> 
> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
> ---
>  tools/bpf/bpftool/Makefile                  | 2 --
>  tools/bpf/runqslower/Makefile               | 3 ---
>  tools/build/feature/Makefile                | 4 ++--
>  tools/perf/Makefile.perf                    | 1 -

for tools/build and tools/perf

Acked-by: Jiri Olsa <jolsa@redhat.com>

jirka

>  tools/scripts/Makefile.include              | 7 +++++++
>  tools/testing/selftests/bpf/Makefile        | 3 +--
>  tools/testing/selftests/tc-testing/Makefile | 3 +--
>  7 files changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> index f897cb5fb12d..71c14efa6e91 100644
> --- a/tools/bpf/bpftool/Makefile
> +++ b/tools/bpf/bpftool/Makefile

SNIP

