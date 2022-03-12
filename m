Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69DE54D6BC4
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 02:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbiCLB6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 20:58:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiCLB6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 20:58:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755CC1C3D26;
        Fri, 11 Mar 2022 17:57:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07A48616C8;
        Sat, 12 Mar 2022 01:57:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2C6C340E9;
        Sat, 12 Mar 2022 01:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647050231;
        bh=PFSibOWGdDwOfUSOtu7ctlKnbZRLcRFKGOjRfHqpfp4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NXqsyCw+XMDmEblziBhd04ifsm2RDmqfR/YjYHyPBZb0Qo0VOs8oIm44uIgq0DG2b
         c6a02hYTz3juewFAY/EswWyIPi7ixE34zPwmEpA/K9ZlNv0gtE/rnjYpBYoU1lPkjP
         MLZ52epgOHBe65xuAvN5DYulx/46BNn8D62o05HdC2FkaUgtT/VtBo2T12wZx+NIx3
         T2lyJSF0XZwYUkmhtrMVbYlXh6Nx40dbkPyV9QiEujXNB3L710eypo8Fl6PgLcJgcZ
         9U6y3/+lreLGNAW77iXUJS2zzDc0OHOYi5oSen+SAAGBe5mz6wA/hoh245bSpkRBw4
         O1CWUNS/O8D3g==
Date:   Sat, 12 Mar 2022 10:57:05 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v10 12/12] fprobe: Add a selftest for fprobe
Message-Id: <20220312105705.f1d2c30c4e2023f5e7a7842c@kernel.org>
In-Reply-To: <CAEf4BzZXS5eg-409S5XGB-gC8CkC9YAYk7EsugKgOpCr+zAsUg@mail.gmail.com>
References: <164673771096.1984170.8155877393151850116.stgit@devnote2>
        <164673784786.1984170.244480726272055433.stgit@devnote2>
        <20220310091745.73580bd6314803cfbf21312d@kernel.org>
        <CAEf4BzavZUn2Y40MjyGg_gkZqYQet_L0sWAJGOSgt_QVrtf21Q@mail.gmail.com>
        <20220311001103.6d3f30c80175b0d169e3f4f6@kernel.org>
        <CAEf4BzZXS5eg-409S5XGB-gC8CkC9YAYk7EsugKgOpCr+zAsUg@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Mar 2022 10:35:30 -0800
Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:

> On Thu, Mar 10, 2022 at 7:11 AM Masami Hiramatsu <mhiramat@kernel.org> wrote:
> >
> > On Wed, 9 Mar 2022 16:40:00 -0800
> > Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > > On Wed, Mar 9, 2022 at 4:17 PM Masami Hiramatsu <mhiramat@kernel.org> wrote:
> > > >
> > > > Hi,
> > > >
> > > > On Tue,  8 Mar 2022 20:10:48 +0900
> > > > Masami Hiramatsu <mhiramat@kernel.org> wrote:
> > > >
> > > > > Add a KUnit based selftest for fprobe interface.
> > > > >
> > > > > Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> > > > > ---
> > > > >  Changes in v9:
> > > > >   - Rename fprobe_target* to fprobe_selftest_target*.
> > > > >   - Find the correct expected ip by ftrace_location_range().
> > > > >   - Since the ftrace_location_range() is not exposed to module, make
> > > > >     this test only for embedded.
> > > > >   - Add entry only test.
> > > > >   - Reset the fprobe structure before reuse it.
> > > > > ---
> > > > >  lib/Kconfig.debug |   12 ++++
> > > > >  lib/Makefile      |    2 +
> > > > >  lib/test_fprobe.c |  174 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> > > > >  3 files changed, 188 insertions(+)
> > > > >  create mode 100644 lib/test_fprobe.c
> > > > >
> > > > > diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> > > > > index 14b89aa37c5c..ffc469a12afc 100644
> > > > > --- a/lib/Kconfig.debug
> > > > > +++ b/lib/Kconfig.debug
> > > > > @@ -2100,6 +2100,18 @@ config KPROBES_SANITY_TEST
> > > > >
> > > > >         Say N if you are unsure.
> > > > >
> > > > > +config FPROBE_SANITY_TEST
> > > > > +     bool "Self test for fprobe"
> > > > > +     depends on DEBUG_KERNEL
> > > > > +     depends on FPROBE
> > > > > +     depends on KUNIT
> > > >
> > > > Hmm, this caused a build error with allmodconfig because KUNIT=m but FPROBE_SANITY_TEST=y.
> > > > Let me fix this issue.
> > >
> > > Please base on top of bpf-next and add [PATCH v11 bpf-next] to subject.
> >
> > OK, let me rebase on it.
> > There are master and for-next branch, which one is better to use?
> >
> 
> Sorry, missed your reply earlier. Always rebase against master.
> 
> You forgot to add "bpf-next" into [PATCH] prefix, so I had to manually
> mark it in patchworks as delegated to bpf queue (this is necessary for
> our CI to properly pick it up). For future submissions to bpf-next,
> please don't forget to add "bpf-next" marker.
> 

Oops, sorry, I forgot that. Should I resend with that tag?

Thank you,


> > Thank you,
> >
> > >
> > > >
> > > > Thank you,
> > > >
> > > > > +     help
> > > > > +       This option will enable testing the fprobe when the system boot.
> > > > > +       A series of tests are made to verify that the fprobe is functioning
> > > > > +       properly.
> > > > > +
> > > > > +       Say N if you are unsure.
> > > > > +
> > > > >  config BACKTRACE_SELF_TEST
> > > > >       tristate "Self test for the backtrace code"
> > > > >       depends on DEBUG_KERNEL
> > > > > diff --git a/lib/Makefile b/lib/Makefile
> > > > > index 300f569c626b..154008764b16 100644
> > > > > --- a/lib/Makefile
> > > > > +++ b/lib/Makefile
> > > > > @@ -103,6 +103,8 @@ obj-$(CONFIG_TEST_HMM) += test_hmm.o
> > > > >  obj-$(CONFIG_TEST_FREE_PAGES) += test_free_pages.o
> > > > >  obj-$(CONFIG_KPROBES_SANITY_TEST) += test_kprobes.o
> > > > >  obj-$(CONFIG_TEST_REF_TRACKER) += test_ref_tracker.o
> > > > > +CFLAGS_test_fprobe.o += $(CC_FLAGS_FTRACE)
> > > > > +obj-$(CONFIG_FPROBE_SANITY_TEST) += test_fprobe.o
> > > > >  #
> > > > >  # CFLAGS for compiling floating point code inside the kernel. x86/Makefile turns
> > > > >  # off the generation of FPU/SSE* instructions for kernel proper but FPU_FLAGS
> > > > > diff --git a/lib/test_fprobe.c b/lib/test_fprobe.c
> > > > > new file mode 100644
> > > > > index 000000000000..ed70637a2ffa
> > > > > --- /dev/null
> > > > > +++ b/lib/test_fprobe.c
> > > > > @@ -0,0 +1,174 @@
> > > > > +// SPDX-License-Identifier: GPL-2.0-or-later
> > > > > +/*
> > > > > + * test_fprobe.c - simple sanity test for fprobe
> > > > > + */
> > > > > +
> > > > > +#include <linux/kernel.h>
> > > > > +#include <linux/fprobe.h>
> > > > > +#include <linux/random.h>
> > > > > +#include <kunit/test.h>
> > > > > +
> > > > > +#define div_factor 3
> > > > > +
> > > > > +static struct kunit *current_test;
> > > > > +
> > > > > +static u32 rand1, entry_val, exit_val;
> > > > > +
> > > > > +/* Use indirect calls to avoid inlining the target functions */
> > > > > +static u32 (*target)(u32 value);
> > > > > +static u32 (*target2)(u32 value);
> > > > > +static unsigned long target_ip;
> > > > > +static unsigned long target2_ip;
> > > > > +
> > > > > +static noinline u32 fprobe_selftest_target(u32 value)
> > > > > +{
> > > > > +     return (value / div_factor);
> > > > > +}
> > > > > +
> > > > > +static noinline u32 fprobe_selftest_target2(u32 value)
> > > > > +{
> > > > > +     return (value / div_factor) + 1;
> > > > > +}
> > > > > +
> > > > > +static notrace void fp_entry_handler(struct fprobe *fp, unsigned long ip, struct pt_regs *regs)
> > > > > +{
> > > > > +     KUNIT_EXPECT_FALSE(current_test, preemptible());
> > > > > +     /* This can be called on the fprobe_selftest_target and the fprobe_selftest_target2 */
> > > > > +     if (ip != target_ip)
> > > > > +             KUNIT_EXPECT_EQ(current_test, ip, target2_ip);
> > > > > +     entry_val = (rand1 / div_factor);
> > > > > +}
> > > > > +
> > > > > +static notrace void fp_exit_handler(struct fprobe *fp, unsigned long ip, struct pt_regs *regs)
> > > > > +{
> > > > > +     unsigned long ret = regs_return_value(regs);
> > > > > +
> > > > > +     KUNIT_EXPECT_FALSE(current_test, preemptible());
> > > > > +     if (ip != target_ip) {
> > > > > +             KUNIT_EXPECT_EQ(current_test, ip, target2_ip);
> > > > > +             KUNIT_EXPECT_EQ(current_test, ret, (rand1 / div_factor) + 1);
> > > > > +     } else
> > > > > +             KUNIT_EXPECT_EQ(current_test, ret, (rand1 / div_factor));
> > > > > +     KUNIT_EXPECT_EQ(current_test, entry_val, (rand1 / div_factor));
> > > > > +     exit_val = entry_val + div_factor;
> > > > > +}
> > > > > +
> > > > > +/* Test entry only (no rethook) */
> > > > > +static void test_fprobe_entry(struct kunit *test)
> > > > > +{
> > > > > +     struct fprobe fp_entry = {
> > > > > +             .entry_handler = fp_entry_handler,
> > > > > +     };
> > > > > +
> > > > > +     current_test = test;
> > > > > +
> > > > > +     /* Before register, unregister should be failed. */
> > > > > +     KUNIT_EXPECT_NE(test, 0, unregister_fprobe(&fp_entry));
> > > > > +     KUNIT_EXPECT_EQ(test, 0, register_fprobe(&fp_entry, "fprobe_selftest_target*", NULL));
> > > > > +
> > > > > +     entry_val = 0;
> > > > > +     exit_val = 0;
> > > > > +     target(rand1);
> > > > > +     KUNIT_EXPECT_NE(test, 0, entry_val);
> > > > > +     KUNIT_EXPECT_EQ(test, 0, exit_val);
> > > > > +
> > > > > +     entry_val = 0;
> > > > > +     exit_val = 0;
> > > > > +     target2(rand1);
> > > > > +     KUNIT_EXPECT_NE(test, 0, entry_val);
> > > > > +     KUNIT_EXPECT_EQ(test, 0, exit_val);
> > > > > +
> > > > > +     KUNIT_EXPECT_EQ(test, 0, unregister_fprobe(&fp_entry));
> > > > > +}
> > > > > +
> > > > > +static void test_fprobe(struct kunit *test)
> > > > > +{
> > > > > +     struct fprobe fp = {
> > > > > +             .entry_handler = fp_entry_handler,
> > > > > +             .exit_handler = fp_exit_handler,
> > > > > +     };
> > > > > +
> > > > > +     current_test = test;
> > > > > +     KUNIT_EXPECT_EQ(test, 0, register_fprobe(&fp, "fprobe_selftest_target*", NULL));
> > > > > +
> > > > > +     entry_val = 0;
> > > > > +     exit_val = 0;
> > > > > +     target(rand1);
> > > > > +     KUNIT_EXPECT_NE(test, 0, entry_val);
> > > > > +     KUNIT_EXPECT_EQ(test, entry_val + div_factor, exit_val);
> > > > > +
> > > > > +     entry_val = 0;
> > > > > +     exit_val = 0;
> > > > > +     target2(rand1);
> > > > > +     KUNIT_EXPECT_NE(test, 0, entry_val);
> > > > > +     KUNIT_EXPECT_EQ(test, entry_val + div_factor, exit_val);
> > > > > +
> > > > > +     KUNIT_EXPECT_EQ(test, 0, unregister_fprobe(&fp));
> > > > > +}
> > > > > +
> > > > > +static void test_fprobe_syms(struct kunit *test)
> > > > > +{
> > > > > +     static const char *syms[] = {"fprobe_selftest_target", "fprobe_selftest_target2"};
> > > > > +     struct fprobe fp = {
> > > > > +             .entry_handler = fp_entry_handler,
> > > > > +             .exit_handler = fp_exit_handler,
> > > > > +     };
> > > > > +
> > > > > +     current_test = test;
> > > > > +     KUNIT_EXPECT_EQ(test, 0, register_fprobe_syms(&fp, syms, 2));
> > > > > +
> > > > > +     entry_val = 0;
> > > > > +     exit_val = 0;
> > > > > +     target(rand1);
> > > > > +     KUNIT_EXPECT_NE(test, 0, entry_val);
> > > > > +     KUNIT_EXPECT_EQ(test, entry_val + div_factor, exit_val);
> > > > > +
> > > > > +     entry_val = 0;
> > > > > +     exit_val = 0;
> > > > > +     target2(rand1);
> > > > > +     KUNIT_EXPECT_NE(test, 0, entry_val);
> > > > > +     KUNIT_EXPECT_EQ(test, entry_val + div_factor, exit_val);
> > > > > +
> > > > > +     KUNIT_EXPECT_EQ(test, 0, unregister_fprobe(&fp));
> > > > > +}
> > > > > +
> > > > > +static unsigned long get_ftrace_location(void *func)
> > > > > +{
> > > > > +     unsigned long size, addr = (unsigned long)func;
> > > > > +
> > > > > +     if (!kallsyms_lookup_size_offset(addr, &size, NULL) || !size)
> > > > > +             return 0;
> > > > > +
> > > > > +     return ftrace_location_range(addr, addr + size - 1);
> > > > > +}
> > > > > +
> > > > > +static int fprobe_test_init(struct kunit *test)
> > > > > +{
> > > > > +     do {
> > > > > +             rand1 = prandom_u32();
> > > > > +     } while (rand1 <= div_factor);
> > > > > +
> > > > > +     target = fprobe_selftest_target;
> > > > > +     target2 = fprobe_selftest_target2;
> > > > > +     target_ip = get_ftrace_location(target);
> > > > > +     target2_ip = get_ftrace_location(target2);
> > > > > +
> > > > > +     return 0;
> > > > > +}
> > > > > +
> > > > > +static struct kunit_case fprobe_testcases[] = {
> > > > > +     KUNIT_CASE(test_fprobe_entry),
> > > > > +     KUNIT_CASE(test_fprobe),
> > > > > +     KUNIT_CASE(test_fprobe_syms),
> > > > > +     {}
> > > > > +};
> > > > > +
> > > > > +static struct kunit_suite fprobe_test_suite = {
> > > > > +     .name = "fprobe_test",
> > > > > +     .init = fprobe_test_init,
> > > > > +     .test_cases = fprobe_testcases,
> > > > > +};
> > > > > +
> > > > > +kunit_test_suites(&fprobe_test_suite);
> > > > > +
> > > > > +MODULE_LICENSE("GPL");
> > > > >
> > > >
> > > >
> > > > --
> > > > Masami Hiramatsu <mhiramat@kernel.org>
> >
> >
> > --
> > Masami Hiramatsu <mhiramat@kernel.org>


-- 
Masami Hiramatsu <mhiramat@kernel.org>
