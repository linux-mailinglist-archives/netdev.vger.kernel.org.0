Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3DEBD215
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 20:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392177AbfIXStx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 14:49:53 -0400
Received: from www62.your-server.de ([213.133.104.62]:48528 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbfIXStx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 14:49:53 -0400
Received: from [178.197.248.15] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iCpsg-0000x9-SG; Tue, 24 Sep 2019 20:49:46 +0200
Date:   Tue, 24 Sep 2019 20:49:46 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: Linux 5.4 - bpf test build fails
Message-ID: <20190924184946.GB5889@pc-63.home>
References: <742ecabe-45ce-cf6e-2540-25d6dc23c45f@linuxfoundation.org>
 <0a5bf608-bb15-c116-8e58-7224b6c3b62f@fb.com>
 <05b7830c-1fa8-b613-0535-1f5f5a40a25a@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <05b7830c-1fa8-b613-0535-1f5f5a40a25a@linuxfoundation.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25582/Tue Sep 24 10:20:37 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 24, 2019 at 09:48:35AM -0600, Shuah Khan wrote:
> On 9/24/19 9:43 AM, Yonghong Song wrote:
> > On 9/24/19 8:26 AM, Shuah Khan wrote:
> > > Hi Alexei and Daniel,
> > > 
> > > bpf test doesn't build on Linux 5.4 mainline. Do you know what's
> > > happening here.
> > > 
> > > make -C tools/testing/selftests/bpf/
> > > 
> > > -c progs/test_core_reloc_ptr_as_arr.c -o - || echo "clang failed") | \
> > > llc -march=bpf -mcpu=generic  -filetype=obj -o
> > > /mnt/data/lkml/linux_5.4/tools/testing/selftests/bpf/test_core_reloc_ptr_as_arr.o
> > > 
> > > progs/test_core_reloc_ptr_as_arr.c:25:6: error: use of unknown builtin
> > >         '__builtin_preserve_access_index' [-Wimplicit-function-declaration]
> > >           if (BPF_CORE_READ(&out->a, &in[2].a))
> > >               ^
> > > ./bpf_helpers.h:533:10: note: expanded from macro 'BPF_CORE_READ'
> > >                          __builtin_preserve_access_index(src))
> > >                          ^
> > > progs/test_core_reloc_ptr_as_arr.c:25:6: warning: incompatible integer to
> > >         pointer conversion passing 'int' to parameter of type 'const void *'
> > >         [-Wint-conversion]
> > >           if (BPF_CORE_READ(&out->a, &in[2].a))
> > >               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > ./bpf_helpers.h:533:10: note: expanded from macro 'BPF_CORE_READ'
> > >                          __builtin_preserve_access_index(src))
> > >                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > 1 warning and 1 error generated.
> > > llc: error: llc: <stdin>:1:1: error: expected top-level entity
> > > clang failed
> > > 
> > > Also
> > > 
> > > make TARGETS=bpf kselftest fails as well. Dependency between
> > > tools/lib/bpf and the test. How can we avoid this type of
> > > dependency or resolve it in a way it doesn't result in build
> > > failures?
> > 
> > Thanks, Shuah.
> > 
> > The clang __builtin_preserve_access_index() intrinsic is
> > introduced in LLVM9 (which just released last week) and
> > the builtin and other CO-RE features are only supported
> > in LLVM10 (current development branch) with more bug fixes
> > and added features.
> > 
> > I think we should do a feature test for llvm version and only
> > enable these tests when llvm version >= 10.
> 
> Yes. If new tests depend on a particular llvm revision, the failing
> the build is a regression. I would like to see older tests that don't
> have dependency build and run.

So far we haven't made it a requirement as majority of BPF contributors
that would run/add tests in here are also on bleeding edge LLVM anyway
and other CIs like 0-day bot have simply upgraded their LLVM version
from git whenever there was a failure similar to the one here so its
ensured that really /all/ test cases are running and nothing would be
skipped. There is worry to some degree that CIs just keep sticking to
an old compiler since tests "just" pass and regressions wouldn't be
caught on new releases for those that are skipped.

That said, for the C based tests, it should actually be straight forward
to categorize them based on built-in macros like ...

$ echo | clang -dM -E -
[...]
#define __clang_major__ 10
#define __clang_minor__ 0
[...]

... given there is now also bpf-gcc, the test matrix gets bigger anyway,
so it might be worth rethinking to run the suite multiple times with
different major llvm{,gcc} versions at some point to make sure their
generated BPF bytecode keeps passing the verifier, and yell loudly if
newer features had to be skipped due to lack of recent compiler version.
This would be a super set of /just/ skipping tests and improve coverage
at the same time.

Thanks,
Daniel
