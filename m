Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18FECB77A3
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 12:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388215AbfISKmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 06:42:54 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:43728 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387520AbfISKmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 06:42:54 -0400
Received: from mua.local.altlinux.org (mua.local.altlinux.org [192.168.1.14])
        by vmicros1.altlinux.org (Postfix) with ESMTP id DA8F072CCAE;
        Thu, 19 Sep 2019 13:42:51 +0300 (MSK)
Received: by mua.local.altlinux.org (Postfix, from userid 508)
        id CC39F7CCB47; Thu, 19 Sep 2019 13:42:51 +0300 (MSK)
Date:   Thu, 19 Sep 2019 13:42:51 +0300
From:   "Dmitry V. Levin" <ldv@altlinux.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Tyler Hicks <tyhicks@canonical.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        luto@amacapital.net, jannh@google.com, wad@chromium.org,
        shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Tycho Andersen <tycho@tycho.ws>, stable@vger.kernel.org
Subject: Re: [PATCH 2/4] seccomp: add two missing ptrace ifdefines
Message-ID: <20190919104251.GA16834@altlinux.org>
References: <20190918084833.9369-1-christian.brauner@ubuntu.com>
 <20190918084833.9369-3-christian.brauner@ubuntu.com>
 <20190918091512.GA5088@elm>
 <201909181031.1EE73B4@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201909181031.1EE73B4@keescook>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 18, 2019 at 10:33:09AM -0700, Kees Cook wrote:
> On Wed, Sep 18, 2019 at 11:15:12AM +0200, Tyler Hicks wrote:
> > On 2019-09-18 10:48:31, Christian Brauner wrote:
> > > Add tw missing ptrace ifdefines to avoid compilation errors on systems
> > > that do not provide PTRACE_EVENTMSG_SYSCALL_ENTRY or
> > > PTRACE_EVENTMSG_SYSCALL_EXIT or:
> > > 
> > > gcc -Wl,-no-as-needed -Wall  seccomp_bpf.c -lpthread -o seccomp_bpf
> > > In file included from seccomp_bpf.c:52:0:
> > > seccomp_bpf.c: In function ‘tracer_ptrace’:
> > > seccomp_bpf.c:1792:20: error: ‘PTRACE_EVENTMSG_SYSCALL_ENTRY’ undeclared (first use in this function); did you mean ‘PTRACE_EVENT_CLONE’?
> > >   EXPECT_EQ(entry ? PTRACE_EVENTMSG_SYSCALL_ENTRY
> > >                     ^
> > > ../kselftest_harness.h:608:13: note: in definition of macro ‘__EXPECT’
> > >   __typeof__(_expected) __exp = (_expected); \
> > >              ^~~~~~~~~
> > > seccomp_bpf.c:1792:2: note: in expansion of macro ‘EXPECT_EQ’
> > >   EXPECT_EQ(entry ? PTRACE_EVENTMSG_SYSCALL_ENTRY
> > >   ^~~~~~~~~
> > > seccomp_bpf.c:1792:20: note: each undeclared identifier is reported only once for each function it appears in
> > >   EXPECT_EQ(entry ? PTRACE_EVENTMSG_SYSCALL_ENTRY
> > >                     ^
> > > ../kselftest_harness.h:608:13: note: in definition of macro ‘__EXPECT’
> > >   __typeof__(_expected) __exp = (_expected); \
> > >              ^~~~~~~~~
> > > seccomp_bpf.c:1792:2: note: in expansion of macro ‘EXPECT_EQ’
> > >   EXPECT_EQ(entry ? PTRACE_EVENTMSG_SYSCALL_ENTRY
> > >   ^~~~~~~~~
> > > seccomp_bpf.c:1793:6: error: ‘PTRACE_EVENTMSG_SYSCALL_EXIT’ undeclared (first use in this function); did you mean ‘PTRACE_EVENTMSG_SYSCALL_ENTRY’?
> > >     : PTRACE_EVENTMSG_SYSCALL_EXIT, msg);
> > >       ^
> > > ../kselftest_harness.h:608:13: note: in definition of macro ‘__EXPECT’
> > >   __typeof__(_expected) __exp = (_expected); \
> > >              ^~~~~~~~~
> > > seccomp_bpf.c:1792:2: note: in expansion of macro ‘EXPECT_EQ’
> > >   EXPECT_EQ(entry ? PTRACE_EVENTMSG_SYSCALL_ENTRY
> > >   ^~~~~~~~~
> > > 
> > > Fixes: 6a21cc50f0c7 ("seccomp: add a return code to trap to userspace")
> > 
> > I think this Fixes line is incorrect and should be changed to:
> > 
> > Fixes: 201766a20e30 ("ptrace: add PTRACE_GET_SYSCALL_INFO request")
> > 
> > With that changed,
> > 
> > Reviewed-by: Tyler Hicks <tyhicks@canonical.com>
> 
> This is actually fixed in -next already (and, yes, with the Fixes line
> Tyler has mentioned):
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest.git/commit/?h=next&id=69b2d3c5924273a0ae968d3818210fc57a1b9d07

Excuse me, does it mean that you expect each selftest to be self-hosted?
I was (and still is) under impression that selftests should be built
with headers installed from the tree. Is it the case, or is it not?


-- 
ldv
