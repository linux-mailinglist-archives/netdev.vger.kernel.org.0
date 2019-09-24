Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE69BCBE7
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 17:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437989AbfIXPw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 11:52:59 -0400
Received: from foss.arm.com ([217.140.110.172]:33110 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437833AbfIXPw7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 11:52:59 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CB71C142F;
        Tue, 24 Sep 2019 08:52:58 -0700 (PDT)
Received: from [10.1.197.50] (e120937-lin.cambridge.arm.com [10.1.197.50])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AB7783F59C;
        Tue, 24 Sep 2019 08:52:57 -0700 (PDT)
Subject: Re: Linux 5.4 - bpf test build fails
To:     Shuah Khan <skhan@linuxfoundation.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <742ecabe-45ce-cf6e-2540-25d6dc23c45f@linuxfoundation.org>
From:   Cristian Marussi <cristian.marussi@arm.com>
Message-ID: <1d1bbc01-5cf4-72e6-76b3-754d23366c8f@arm.com>
Date:   Tue, 24 Sep 2019 16:52:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <742ecabe-45ce-cf6e-2540-25d6dc23c45f@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Shuah

On 24/09/2019 16:26, Shuah Khan wrote:
> Hi Alexei and Daniel,
> 
> bpf test doesn't build on Linux 5.4 mainline. Do you know what's
> happening here.
> 
> 
> make -C tools/testing/selftests/bpf/

side question, since I'm writing arm64/ tests.

my "build-testcases" following the KSFT docs are:

make kselftest
make TARGETS=arm64 kselftest
make -C tools/testing/selftests/ 
make -C tools/testing/selftests/ INSTALL_PATH=<install-path> install
make TARGETS=arm64 -C tools/testing/selftests/ 
make TARGETS=arm64 -C tools/testing/selftests/ INSTALL_PATH=<install-path> install
./kselftest_install.sh <install-path>

(and related clean targets...)

but definitely NOT

make -C tools/testing/selftests/arm64

(for simplicity....due to the subdirs structure under tools/testing/selftests/arm64/)

am I wrong ?

Thanks

Cristian

> 
> -c progs/test_core_reloc_ptr_as_arr.c -o - || echo "clang failed") | \
> llc -march=bpf -mcpu=generic  -filetype=obj -o 
> /mnt/data/lkml/linux_5.4/tools/testing/selftests/bpf/test_core_reloc_ptr_as_arr.o
> progs/test_core_reloc_ptr_as_arr.c:25:6: error: use of unknown builtin
>        '__builtin_preserve_access_index' [-Wimplicit-function-declaration]
>          if (BPF_CORE_READ(&out->a, &in[2].a))
>              ^
> ./bpf_helpers.h:533:10: note: expanded from macro 'BPF_CORE_READ'
>                         __builtin_preserve_access_index(src))
>                         ^
> progs/test_core_reloc_ptr_as_arr.c:25:6: warning: incompatible integer to
>        pointer conversion passing 'int' to parameter of type 'const void *'
>        [-Wint-conversion]
>          if (BPF_CORE_READ(&out->a, &in[2].a))
>              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ./bpf_helpers.h:533:10: note: expanded from macro 'BPF_CORE_READ'
>                         __builtin_preserve_access_index(src))
>                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 1 warning and 1 error generated.
> llc: error: llc: <stdin>:1:1: error: expected top-level entity
> clang failed
> 
> Also
> 
> make TARGETS=bpf kselftest fails as well. Dependency between
> tools/lib/bpf and the test. How can we avoid this type of
> dependency or resolve it in a way it doesn't result in build
> failures?
> 
> thanks,
> -- Shuah
> 

