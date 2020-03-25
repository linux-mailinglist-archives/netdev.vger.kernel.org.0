Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41516193434
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 00:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbgCYXH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 19:07:59 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38619 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727358AbgCYXH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 19:07:59 -0400
Received: by mail-wm1-f68.google.com with SMTP id l20so5086027wmi.3;
        Wed, 25 Mar 2020 16:07:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4CjDjA3dLNgAm9S9PFScwrjp6WE+UcnMLSRjmlnIKeg=;
        b=AveFVfa/UdDwIG3zArf5u2HfhRK7MJKZuHPsynV3aXvXieTCjkinatTj3oyE61sYSg
         vHTechlxA8DrMUhamKQ8fgt9qveyPeVqckQ9wHowDhKB8XfVcd3PArSyYbLg0IiUzebJ
         8jbL1NLDhcPRm7244r10dXxUaBWK+Mxc7d+AkpZqF5Ue8S9YOLcgjBIrb8QRTbjoH4eR
         cgF6zUYw/3Kc+B13D8ychHPnWwtWBn6b1TojvOuZ5WEomTgMxUrIFDOZKs9MR+duGs4U
         Qbq7KGpXuH/i5YiNt1/LQo53ATqe06DCSv3zZbQn3C2hdl1lD0ngtHBnMp5bPOEU/afg
         lM1Q==
X-Gm-Message-State: ANhLgQ0jwFgZC14+g6ENzXLuqmNomMl20Hfla8GFWdtr9QqctTu4y2Bl
        /Rmr0Aioj3+yQp+j29u2HSYNETd/FlzYJULqDew=
X-Google-Smtp-Source: ADFU+vsKr6b0ywav0QLPhY1gWY20lDfz+56IhCrTvvozCE8tOEZOhn1En8snuGu6OqDloSm2NoJhtJKuRFgr2S6cEeg=
X-Received: by 2002:a7b:c846:: with SMTP id c6mr5998961wml.189.1585177676302;
 Wed, 25 Mar 2020 16:07:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200325055745.10710-1-joe@wand.net.nz> <20200325055745.10710-6-joe@wand.net.nz>
 <82e8d147-b334-3d29-0312-7b087ac908f3@fb.com> <CAOftzPiJHOW7BnCmc1MDm-TOwqYYK6V2VHhsiYVd6qZu4jH_+Q@mail.gmail.com>
 <6d92317a-5274-5718-c78e-fb7b309cdee7@fb.com>
In-Reply-To: <6d92317a-5274-5718-c78e-fb7b309cdee7@fb.com>
From:   Joe Stringer <joe@wand.net.nz>
Date:   Wed, 25 Mar 2020 16:07:32 -0700
Message-ID: <CAOftzPjnXNM387OP4jN+EzKG05u_5Es2OH7PDc9cbTodBrMjgg@mail.gmail.com>
Subject: Re: [PATCHv2 bpf-next 5/5] selftests: bpf: add test for sk_assign
To:     Yonghong Song <yhs@fb.com>
Cc:     Joe Stringer <joe@wand.net.nz>, bpf <bpf@vger.kernel.org>,
        Lorenz Bauer <lmb@cloudflare.com>,
        netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 3:01 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 3/25/20 2:20 PM, Joe Stringer wrote:
> > On Wed, Mar 25, 2020 at 11:18 AM Yonghong Song <yhs@fb.com> wrote:
> >>
> >>
> >>
> >> On 3/24/20 10:57 PM, Joe Stringer wrote:
> >>> From: Lorenz Bauer <lmb@cloudflare.com>
> >>>
> >>> Attach a tc direct-action classifier to lo in a fresh network
> >>> namespace, and rewrite all connection attempts to localhost:4321
> >>> to localhost:1234 (for port tests) and connections to unreachable
> >>> IPv4/IPv6 IPs to the local socket (for address tests).
> >>>
> >>> Keep in mind that both client to server and server to client traffic
> >>> passes the classifier.
> >>>
> >>> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> >>> Co-authored-by: Joe Stringer <joe@wand.net.nz>
> >>> Signed-off-by: Joe Stringer <joe@wand.net.nz>
> >>> ---
> >>> v2: Rebase onto test_progs infrastructure
> >>> v1: Initial commit
> >>> ---
> >>>    tools/testing/selftests/bpf/Makefile          |   2 +-
> >>>    .../selftests/bpf/prog_tests/sk_assign.c      | 244 ++++++++++++++++++
> >>>    .../selftests/bpf/progs/test_sk_assign.c      | 127 +++++++++
> >>>    3 files changed, 372 insertions(+), 1 deletion(-)
> >>>    create mode 100644 tools/testing/selftests/bpf/prog_tests/sk_assign.c
> >>>    create mode 100644 tools/testing/selftests/bpf/progs/test_sk_assign.c
> >>>
> >>> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> >>> index 7729892e0b04..4f7f83d059ca 100644
> >>> --- a/tools/testing/selftests/bpf/Makefile
> >>> +++ b/tools/testing/selftests/bpf/Makefile
> >>> @@ -76,7 +76,7 @@ TEST_PROGS_EXTENDED := with_addr.sh \
> >>>    # Compile but not part of 'make run_tests'
> >>>    TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
> >>>        flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
> >>> -     test_lirc_mode2_user xdping test_cpp runqslower
> >>> +     test_lirc_mode2_user xdping test_cpp runqslower test_sk_assign
> >>
> >> No test_sk_assign any more as the test is integrated into test_progs, right?
> >
> > I'll fix it up.
> >
> >>> +static __u32 duration;
> >>> +
> >>> +static bool configure_stack(int self_net)
> >>
> >> self_net parameter is not used.
> >
> > Hrm, why didn't the compiler tell me this..? Will fix.
> >
> >>> +{
> >>> +     /* Move to a new networking namespace */
> >>> +     if (CHECK_FAIL(unshare(CLONE_NEWNET)))
> >>> +             return false;
> >>
> >> You can use CHECK to encode better error messages. Thhis is what
> >> most test_progs tests are using.
> >
> > I was going back and forth on this when I was writing this bit.
> > CHECK_FAIL() already prints the line that fails, so when debugging
> > it's pretty clear what call went wrong if you dig into the code.
> > Combine with perror() and you actually get a readable string of the
> > error, whereas the common form for CHECK() seems to be just printing
> > the error code which the developer then has to do symbol lookup to
> > interpret..
> >
> >      if (CHECK(efd < 0, "open", "err %d errno %d\n", efd, errno))
> >
> > Example output with CHECK_FAIL / perror approach:
> >
> >      # ./test_progs -t assign
> >      ...
> >      Timed out while connecting to server
> >      connect_to_server:FAIL:90
> >      Cannot connect to server: Interrupted system call
> >      #46/1 ipv4 port redir:FAIL
> >      #46 sk_assign:FAIL
> >      Summary: 0/0 PASSED, 0 SKIPPED, 2 FAILED
>
> I won't insist since CHECK_FAIL should roughly provide enough
> information for failure. CHECK might be more useful if you want
> to provide more context, esp. if the same routine is called
> in multiple places and you can have a marker to differentiate
> which call site caused the problem.

Good point, maybe for extra context the subtests can use CHECK() in
addition to the CHECK_FAIL.

> But again, just a suggestion. CHECK_FAIL is okay to me.

<snip>

> >>> +     /* We can't do a single skc_lookup_tcp here, because then the compiler
> >>> +      * will likely spill tuple_len to the stack. This makes it lose all
> >>> +      * bounds information in the verifier, which then rejects the call as
> >>> +      * unsafe.
> >>> +      */
> >>
> >> This is a known issue. For scalars, only constant is restored properly
> >> in verifier at this moment. I did some hacking before to enable any
> >> scalars. The fear is this will make pruning performs worse. More
> >> study is needed here.
> >
> > Thanks for the background. Do you want me to refer to any specific
> > release version or date or commit for this comment or it's fine to
> > leave as-is?
>
> Maybe add a "workaround:" marker in the comments so later we can search
> and find these examples if we have compiler/verifier improvements.
>
> -bash-4.4$ egrep -ri workaround
> test_get_stack_rawtp.c: * This is an acceptable workaround since there
> is one entry here.
> test_seg6_loop.c:       // workaround: define induction variable "i" as
> "long" instead
> test_sysctl_loop1.c:    /* a workaround to prevent compiler from generating
> -bash-4.4$

SGTM, Will roll that in thanks.
