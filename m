Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D287E19328D
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 22:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgCYVVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 17:21:19 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35612 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727487AbgCYVVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 17:21:19 -0400
Received: by mail-wm1-f65.google.com with SMTP id m3so4756777wmi.0;
        Wed, 25 Mar 2020 14:21:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mYi81nCjfg0uV4fvH7K+TMxZuRycMx7U2Ry+OEpoges=;
        b=s1RDEaTAGunLg1CwynrjqwJGRt2eY19+i7MWqyT4xiSFnDfik0PMbVB1kAk5BT+xZH
         lMlwIo0/cs9IrQYCAY0SPfR4KF9Q4r5YA0lD1FYIkVOmniOdonmrLo/2UtKXXSaxEQu1
         pcTF88yPatIDg1UsmWxnuSqBLkCBZzzxeBqHnrD3K8gn6NDGsoQmNdRwbus8wVvz6BPv
         p0KWQY8FD1ploAEzdIuB50/0MVTZZ6GI0uTISS2EpHkkn0WwQ1wCTYdRE9aY3YqHyH+p
         wXQyxGQj89MIUV6sdBCHGlgpoPF5CYS+EXC47ud0ynj2Gg2ZRYoYfZq0AW9G9Kesg4vo
         u3tw==
X-Gm-Message-State: ANhLgQ2qRZ5cahXbr7X4jlKVC7TBCz7BwwIexC+TM56/WfGS/LJXvEXx
        HRZHZEJnkTz9trWB2mt+GT3KhWqpa/ZyJ6JoHnw=
X-Google-Smtp-Source: ADFU+vvb/d9wRzSFdGBRbp3lgjOw0dYUgyfArvFwKz55wdSutXeXrQynXLxLfl5e2YYWexQuyjN+WDn4nT8VeSg25GI=
X-Received: by 2002:a7b:c846:: with SMTP id c6mr5617791wml.189.1585171277340;
 Wed, 25 Mar 2020 14:21:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200325055745.10710-1-joe@wand.net.nz> <20200325055745.10710-6-joe@wand.net.nz>
 <82e8d147-b334-3d29-0312-7b087ac908f3@fb.com>
In-Reply-To: <82e8d147-b334-3d29-0312-7b087ac908f3@fb.com>
From:   Joe Stringer <joe@wand.net.nz>
Date:   Wed, 25 Mar 2020 14:20:53 -0700
Message-ID: <CAOftzPiJHOW7BnCmc1MDm-TOwqYYK6V2VHhsiYVd6qZu4jH_+Q@mail.gmail.com>
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

On Wed, Mar 25, 2020 at 11:18 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 3/24/20 10:57 PM, Joe Stringer wrote:
> > From: Lorenz Bauer <lmb@cloudflare.com>
> >
> > Attach a tc direct-action classifier to lo in a fresh network
> > namespace, and rewrite all connection attempts to localhost:4321
> > to localhost:1234 (for port tests) and connections to unreachable
> > IPv4/IPv6 IPs to the local socket (for address tests).
> >
> > Keep in mind that both client to server and server to client traffic
> > passes the classifier.
> >
> > Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> > Co-authored-by: Joe Stringer <joe@wand.net.nz>
> > Signed-off-by: Joe Stringer <joe@wand.net.nz>
> > ---
> > v2: Rebase onto test_progs infrastructure
> > v1: Initial commit
> > ---
> >   tools/testing/selftests/bpf/Makefile          |   2 +-
> >   .../selftests/bpf/prog_tests/sk_assign.c      | 244 ++++++++++++++++++
> >   .../selftests/bpf/progs/test_sk_assign.c      | 127 +++++++++
> >   3 files changed, 372 insertions(+), 1 deletion(-)
> >   create mode 100644 tools/testing/selftests/bpf/prog_tests/sk_assign.c
> >   create mode 100644 tools/testing/selftests/bpf/progs/test_sk_assign.c
> >
> > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > index 7729892e0b04..4f7f83d059ca 100644
> > --- a/tools/testing/selftests/bpf/Makefile
> > +++ b/tools/testing/selftests/bpf/Makefile
> > @@ -76,7 +76,7 @@ TEST_PROGS_EXTENDED := with_addr.sh \
> >   # Compile but not part of 'make run_tests'
> >   TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
> >       flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
> > -     test_lirc_mode2_user xdping test_cpp runqslower
> > +     test_lirc_mode2_user xdping test_cpp runqslower test_sk_assign
>
> No test_sk_assign any more as the test is integrated into test_progs, right?

I'll fix it up.

> > +static __u32 duration;
> > +
> > +static bool configure_stack(int self_net)
>
> self_net parameter is not used.

Hrm, why didn't the compiler tell me this..? Will fix.

> > +{
> > +     /* Move to a new networking namespace */
> > +     if (CHECK_FAIL(unshare(CLONE_NEWNET)))
> > +             return false;
>
> You can use CHECK to encode better error messages. Thhis is what
> most test_progs tests are using.

I was going back and forth on this when I was writing this bit.
CHECK_FAIL() already prints the line that fails, so when debugging
it's pretty clear what call went wrong if you dig into the code.
Combine with perror() and you actually get a readable string of the
error, whereas the common form for CHECK() seems to be just printing
the error code which the developer then has to do symbol lookup to
interpret..

    if (CHECK(efd < 0, "open", "err %d errno %d\n", efd, errno))

Example output with CHECK_FAIL / perror approach:

    # ./test_progs -t assign
    ...
    Timed out while connecting to server
    connect_to_server:FAIL:90
    Cannot connect to server: Interrupted system call
    #46/1 ipv4 port redir:FAIL
    #46 sk_assign:FAIL
    Summary: 0/0 PASSED, 0 SKIPPED, 2 FAILED

Diff to make this happen is just connect to a port that the BPF
program doesn't redirect:

$ git diff
diff --git a/tools/testing/selftests/bpf/prog_tests/sk_assign.c
b/tools/testing/selftests/bpf/prog_tests/sk_assign.c
index 1f0afcc20c48..ba661145518a 100644
--- a/tools/testing/selftests/bpf/prog_tests/sk_assign.c
+++ b/tools/testing/selftests/bpf/prog_tests/sk_assign.c
@@ -192,7 +191,7 @@ static int do_sk_assign(void)
                goto out;

        /* Connect to unbound ports */
-       addr4.sin_port = htons(TEST_DPORT);
+       addr4.sin_port = htons(666);
        addr6.sin6_port = htons(TEST_DPORT);

        test__start_subtest("ipv4 port redir");

(I had to drop the kill() call as well, but that's part of the next
revision of this series..)

> > +static int connect_to_server(const struct sockaddr *addr, socklen_t len)
> > +{
> > +     int fd = -1;
> > +
> > +     fd = socket(addr->sa_family, SOCK_STREAM, 0);
> > +     if (CHECK_FAIL(fd == -1))
> > +             goto out;
> > +     if (CHECK_FAIL(sigaction(SIGALRM, &timeout_action, NULL)))
> > +             goto out;
>
> should this goto close_out?

Will fix.

> > +void test_sk_assign(void)
> > +{
> > +     int self_net;
> > +
> > +     self_net = open(NS_SELF, O_RDONLY);
> > +     if (CHECK_FAIL(self_net < 0)) {
> > +             perror("Unable to open "NS_SELF);
> > +             return;
> > +     }
> > +
> > +     if (!configure_stack(self_net)) {
> > +             perror("configure_stack");
> > +             goto cleanup;
> > +     }
> > +
> > +     do_sk_assign();
> > +
> > +cleanup:
> > +     close(self_net);
>
> Did we exit the newly unshared net namespace and restored the previous
> namespace?

Ah I've mainly just been running this test so it didn't affect me but
I realise now I dropped the hunks that were intended to do this
cleanup. Will fix.

> > +     /* We can't do a single skc_lookup_tcp here, because then the compiler
> > +      * will likely spill tuple_len to the stack. This makes it lose all
> > +      * bounds information in the verifier, which then rejects the call as
> > +      * unsafe.
> > +      */
>
> This is a known issue. For scalars, only constant is restored properly
> in verifier at this moment. I did some hacking before to enable any
> scalars. The fear is this will make pruning performs worse. More
> study is needed here.

Thanks for the background. Do you want me to refer to any specific
release version or date or commit for this comment or it's fine to
leave as-is?
