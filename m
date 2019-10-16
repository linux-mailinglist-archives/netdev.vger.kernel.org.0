Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42267D8683
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 05:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391013AbfJPDbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 23:31:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55449 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730211AbfJPDbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 23:31:20 -0400
Received: from [213.220.153.21] (helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iKa1t-0008BG-Fb; Wed, 16 Oct 2019 03:31:17 +0000
Date:   Wed, 16 Oct 2019 05:31:16 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH v2 0/3] bpf: switch to new usercopy helpers
Message-ID: <20191016033115.ljwiae2cfltbdoyo@wittgenstein>
References: <20191009160907.10981-1-christian.brauner@ubuntu.com>
 <20191016004138.24845-1-christian.brauner@ubuntu.com>
 <CAADnVQ+JmXK4EGtt-6pm+KENPooewfikaRE5dZqi1pMBc_jdxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAADnVQ+JmXK4EGtt-6pm+KENPooewfikaRE5dZqi1pMBc_jdxw@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 15, 2019 at 07:14:42PM -0700, Alexei Starovoitov wrote:
> On Tue, Oct 15, 2019 at 5:41 PM Christian Brauner
> <christian.brauner@ubuntu.com> wrote:
> >
> > Hey everyone,
> >
> > In v5.4-rc2 we added two new helpers check_zeroed_user() and
> > copy_struct_from_user() including selftests (cf. [1]). It is a generic
> > interface designed to copy a struct from userspace. The helpers will be
> > especially useful for structs versioned by size of which we have quite a
> > few.
> 
> Was it tested?
> Either your conversion is incorrect or that generic helper is broken.
> ./test_progs -n 2
> and
> ./test_btf
> are catching the bug:
> BTF prog info raw test[8] (line_info (No subprog. zero tailing
> line_info): do_test_info_raw:6205:FAIL prog_fd:-1
> expected_prog_load_failure:0 errno:7
> nonzero tailing record in line_infoprocessed 0 insns (limit 1000000)
> max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0

Ugh, I misrememberd what the helper I helped design returns. The fix is:

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 5db9887a8f4c..0920593eacd0 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -78,11 +78,8 @@ int bpf_check_uarg_tail_zero(void __user *uaddr,
                return 0;

        err = check_zeroed_user(uaddr + expected_size, rest);
-       if (err < 0)
-               return err;
-
-       if (err)
-               return -E2BIG;
+       if (err <= 0)
+               return err ?: -E2BIG;

        return 0;
 }

aka check_zeroed_user() returns 0 if non-zero bytes are present, 1 if no
non-zero bytes were present, and -errno on error.

I'll send a fixed version. The tests pass for me with this.

Christian
