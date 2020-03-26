Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D49E51937BC
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 06:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbgCZF2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 01:28:24 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37677 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbgCZF2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 01:28:24 -0400
Received: by mail-wr1-f68.google.com with SMTP id w10so6244535wrm.4;
        Wed, 25 Mar 2020 22:28:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wXHdJQjHOZJU3K+b0MFItSKiPAOIqY5bhyT6MjjRq/M=;
        b=Vv7DfbitthYmF5lPWT9RA6U8WpBtwMsN5P4F3qMJz7KB9Vp3tcywUBnOrIcgbE3lJH
         UQTDagMv1sZjlX67yVZHsWm6+SJMSs4Dwk0N8sLeFKe7wvYt4CWYb+Hfr5IiN0G7GL/0
         bSOw5IJPNlgpJJH8lLTFu5RytbaaiJKm+zjmHzgLQhnGLhkdH1zfcibUnV2w633HwPPV
         IG7qXv7NlD8/gvePqJizhVqTqBowQNvc0nMl+XXiFTcPwbrX5bmFNQ6IRbzLY480lq79
         wtqPJqVq7cpAtgJo65JaOjvR8+0xmp7Hhj8QNe72LS9OGvk0m+ltSo3sK1z0kVblfeBz
         MIJQ==
X-Gm-Message-State: ANhLgQ1vAacO+sy1qoRvzu0E7cfbr4qsGfoDb/6ejktvjUfbVzgtN7Fx
        UhZd4K2EC1hDBUU7doAY8/Afo3HgSPwXPGRdtfM=
X-Google-Smtp-Source: ADFU+vvFi4O3boTduxBlDe29KEFsRsIR5Iv7MipoLYsHjhlTBCfp9wIVM3wXy/0JhYcPZX1akUuHdtI+KDHZQw4/030=
X-Received: by 2002:adf:fe03:: with SMTP id n3mr7350423wrr.266.1585200502533;
 Wed, 25 Mar 2020 22:28:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200325055745.10710-1-joe@wand.net.nz> <20200325055745.10710-6-joe@wand.net.nz>
 <CAEf4BzYXedX7Bsv8jzfawYoRkN8Wu4z3+kGfQ9CWcO4dOJe+bg@mail.gmail.com>
In-Reply-To: <CAEf4BzYXedX7Bsv8jzfawYoRkN8Wu4z3+kGfQ9CWcO4dOJe+bg@mail.gmail.com>
From:   Joe Stringer <joe@wand.net.nz>
Date:   Wed, 25 Mar 2020 22:28:11 -0700
Message-ID: <CAOftzPhkoZkooOk9SkwLQnZFxM9KGO4M1XpMbzni9TrEKcepjg@mail.gmail.com>
Subject: Re: [PATCHv2 bpf-next 5/5] selftests: bpf: add test for sk_assign
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Joe Stringer <joe@wand.net.nz>, bpf <bpf@vger.kernel.org>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 7:16 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Mar 24, 2020 at 10:58 PM Joe Stringer <joe@wand.net.nz> wrote:
> >
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

<snip>

> > +static void handle_timeout(int signum)
> > +{
> > +       if (signum == SIGALRM)
> > +               fprintf(stderr, "Timed out while connecting to server\n");
> > +       kill(0, SIGKILL);
> > +}
> > +
> > +static struct sigaction timeout_action = {
> > +       .sa_handler = handle_timeout,
> > +};
> > +
> > +static int connect_to_server(const struct sockaddr *addr, socklen_t len)
> > +{
> > +       int fd = -1;
> > +
> > +       fd = socket(addr->sa_family, SOCK_STREAM, 0);
> > +       if (CHECK_FAIL(fd == -1))
> > +               goto out;
> > +       if (CHECK_FAIL(sigaction(SIGALRM, &timeout_action, NULL)))
> > +               goto out;
>
> no-no-no, we are not doing this. It's part of prog_tests and shouldn't
> install its own signal handlers and sending asynchronous signals to
> itself. Please find another way to have a timeout.

I realise it didn't clean up after itself. How about signal(SIGALRM,
SIG_DFL); just like other existing tests do?

> > +       test__start_subtest("ipv4 addr redir");
> > +       if (run_test(server, (const struct sockaddr *)&addr4, sizeof(addr4)))
> > +               goto out;
> > +
> > +       test__start_subtest("ipv6 addr redir");
>
> test__start_subtest() returns false if subtest is supposed to be
> skipped. If you ignore that, then test_progs -t and -n filtering won't
> work properly.

Will fix.

> > +       if (run_test(server_v6, (const struct sockaddr *)&addr6, sizeof(addr6)))
> > +               goto out;
> > +
> > +       err = 0;
> > +out:
> > +       close(server);
> > +       close(server_v6);
> > +       return err;
> > +}
> > +
> > +void test_sk_assign(void)
> > +{
> > +       int self_net;
> > +
> > +       self_net = open(NS_SELF, O_RDONLY);
>
> I'm not familiar with what this does. Can you please explain briefly
> what are the side effects of this? Asking because of shared test_progs
> environment worries, of course.

This one is opening an fd to the current program's netns path on the
filesystem. The intention was to use it to switch back to the current
netns after the unshare() call elsewhere which switches to a new
netns. As per the other feedback the bit where it switches back to
this netns was dropped along the way so I'll fix it up in the next
revision.

> > +SEC("sk_assign_test")
>
> Please use "canonical" section name that libbpf recognizes. This
> woulde be "action/" or "classifier/", right?

Will fix.
