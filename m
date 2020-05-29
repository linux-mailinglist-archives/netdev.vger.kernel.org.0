Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 965871E850C
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 19:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbgE2RgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 13:36:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:57442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbgE2RgM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 13:36:12 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.37.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04E3E2065F;
        Fri, 29 May 2020 17:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590773771;
        bh=MFRDDH/zJpKQ7kKqtBS6pous5gRQL392N96uHe//azM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f/lNGzOwe5vkkH1zrTuPACfT5vfGh/HLXHAS3s43LBMNw7KpU5CMXdDeG/cZbqQN7
         9V2ZWGI5fPsWK5gKXPOgM1W2SoquqTFRYh1WO62CEy/HhQijww9s1+IC1iCNZ/mnW6
         yL4kPPy27fozs48jPczze6KbpN5mVEwW4p9KB4ak=
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id C4D7940AFD; Fri, 29 May 2020 14:36:08 -0300 (-03)
Date:   Fri, 29 May 2020 14:36:08 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ian Rogers <irogers@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Igor Lubashev <ilubashe@akamai.com>,
        Alexey Budankov <alexey.budankov@linux.intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Jiwei Sun <jiwei.sun@windriver.com>,
        yuzhoujian <yuzhoujian@didichuxing.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Leo Yan <leo.yan@linaro.org>,
        John Garry <john.garry@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-perf-users <linux-perf-users@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v14 1/1] perf tools: add support for libpfm4
Message-ID: <20200529173608.GA31795@kernel.org>
References: <20200505182943.218248-1-irogers@google.com>
 <20200505182943.218248-2-irogers@google.com>
 <CAP-5=fWn1=DtZyfGtYEFd=-zDY1O+9A1fcG_3bDKsuoQDZ4i=Q@mail.gmail.com>
 <20200529172310.GE537@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529172310.GE537@kernel.org>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, May 29, 2020 at 02:23:10PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Fri, May 29, 2020 at 10:03:51AM -0700, Ian Rogers escreveu:
> > On Tue, May 5, 2020 at 11:29 AM Ian Rogers <irogers@google.com> wrote:
> > >
> > > From: Stephane Eranian <eranian@google.com>
> > >
> > > This patch links perf with the libpfm4 library if it is available
> > > and LIBPFM4 is passed to the build. The libpfm4 library
> > > contains hardware event tables for all processors supported by
> > > perf_events. It is a helper library that helps convert from a
> > > symbolic event name to the event encoding required by the
> > > underlying kernel interface. This library is open-source and
> > > available from: http://perfmon2.sf.net.
> > >
> > > With this patch, it is possible to specify full hardware events
> > > by name. Hardware filters are also supported. Events must be
> > > specified via the --pfm-events and not -e option. Both options
> > > are active at the same time and it is possible to mix and match:
> > >
> > > $ perf stat --pfm-events inst_retired:any_p:c=1:i -e cycles ....
> > >
> > > Signed-off-by: Stephane Eranian <eranian@google.com>
> > > Reviewed-by: Ian Rogers <irogers@google.com>
> > 
> > Ping.
> 
> Check my tmp.perf/core branch, I had to make some adjustments, mostly in
> the 'perf test' entries as I merged a java demangle test that touched
> the same files,
> 
> I'm now doing the build tests.

Talking about build  tests, you forgot to add it there, like I did
below, I'll eventually do it, as it is opt-in, no biggie at this point.

I'll install libpfm-devel that is in fedora and do further tests, later
today.

- Arnaldo

commit a01c205e3c4cd6d134317413f2dc3129c4ab7a5a
Author: Arnaldo Carvalho de Melo <acme@redhat.com>
Date:   Fri May 29 11:31:23 2020 -0300

    perf build: Add NO_SYSCALL_TABLE=1 to the build tests
    
    So that we make sure that even on x86-64 and other architectures where
    that is the default method we test build the fallback to libaudit that
    other architectures use.
    
    I.e. now this line got added to:
    
      $ make -C tools/perf build-test
      <SNIP>
           make_no_syscall_tbl_O: cd . && make NO_SYSCALL_TABLE=1 FEATURES_DUMP=/home/acme/git/perf/tools/perf/BUILD_TEST_FEATURE_DUMP -j12 O=/tmp/tmp.W0HtKR1mfr DESTDIR=/tmp/tmp.lNezgCVPzW
      <SNIP>
      $
    
    Cc: Adrian Hunter <adrian.hunter@intel.com>
    Cc: Ingo Molnar <mingo@kernel.org>
    Cc: Jiri Olsa <jolsa@kernel.org>
    Cc: Namhyung Kim <namhyung@kernel.org>
    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/tools/perf/tests/make b/tools/perf/tests/make
index 29ce0da7fca6..a4ffa3c7fcb6 100644
--- a/tools/perf/tests/make
+++ b/tools/perf/tests/make
@@ -88,6 +88,7 @@ make_no_libbpf_DEBUG := NO_LIBBPF=1 DEBUG=1
 make_no_libcrypto   := NO_LIBCRYPTO=1
 make_with_babeltrace:= LIBBABELTRACE=1
 make_no_sdt	    := NO_SDT=1
+make_no_syscall_tbl := NO_SYSCALL_TABLE=1
 make_with_clangllvm := LIBCLANGLLVM=1
 make_tags           := tags
 make_cscope         := cscope
@@ -113,7 +114,7 @@ make_minimal        += NO_DEMANGLE=1 NO_LIBELF=1 NO_LIBUNWIND=1 NO_BACKTRACE=1
 make_minimal        += NO_LIBNUMA=1 NO_LIBAUDIT=1 NO_LIBBIONIC=1
 make_minimal        += NO_LIBDW_DWARF_UNWIND=1 NO_AUXTRACE=1 NO_LIBBPF=1
 make_minimal        += NO_LIBCRYPTO=1 NO_SDT=1 NO_JVMTI=1 NO_LIBZSTD=1
-make_minimal        += NO_LIBCAP=1
+make_minimal        += NO_LIBCAP=1 NO_SYSCALL_TABLE=1
 
 # $(run) contains all available tests
 run := make_pure
@@ -146,6 +147,7 @@ run += make_no_libbionic
 run += make_no_auxtrace
 run += make_no_libbpf
 run += make_no_libbpf_DEBUG
+run += make_no_syscall_tbl
 run += make_with_babeltrace
 run += make_with_clangllvm
 run += make_help
