Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 101A2194AC2
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 22:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbgCZViz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 17:38:55 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36990 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgCZViz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 17:38:55 -0400
Received: by mail-wm1-f65.google.com with SMTP id d1so9619854wmb.2;
        Thu, 26 Mar 2020 14:38:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MQXIljtTYz4YRIvZS+bbldWf5+76f3XM0yhEkMHjVo8=;
        b=AQgS4mjogYwfJFDNWai5ULDp91Tww513TOOrBDl68l8Q9aV3VzCUEsQVVgOuO6aGAD
         dOtLwl95JSY6E/zFy50J3r/OUztZ7m/w8z0M7/bEslsUbvHnGbrlpzeH4cOC2lj72B1A
         s+4AZ1hH7NAtsxXNrPTWdm3ZcKJHJkiWRAtefTUBD3lpQagqtFWUPNd6PvH2zT35VIlc
         kcKWmESwy1ZhKppu6QAG6stRVnAlyVGrODerEzWwG6BzmFG67GBsXvAJyHwpYB3b8WMQ
         OkqsFOZFe68/K+xss55mVuPFE5IfZiGsbd1Br3jxCK9HuTDru+FgLmEj69jJq/L3ApiP
         qTyQ==
X-Gm-Message-State: ANhLgQ0zoQ4dqVR+XTBjL/pepDySsjmcNRO1tt4Hu6JizLuTti4UGUaL
        zRdZdvy89GqjI0lxLKqOEjNUOqCdUt2qJDXbUEQ=
X-Google-Smtp-Source: ADFU+vt3593z0T4qn8d3Rrd8bFHUBCFi4EgWqwO3MrkxDrofQ7Wnslb/s5rDOmq4VZ5Cw4u5ZFLQnlHD4Hz02cwMUkg=
X-Received: by 2002:a1c:2842:: with SMTP id o63mr2014193wmo.73.1585258732927;
 Thu, 26 Mar 2020 14:38:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200325055745.10710-1-joe@wand.net.nz> <20200325055745.10710-6-joe@wand.net.nz>
 <CAEf4BzYXedX7Bsv8jzfawYoRkN8Wu4z3+kGfQ9CWcO4dOJe+bg@mail.gmail.com>
 <CAOftzPhkoZkooOk9SkwLQnZFxM9KGO4M1XpMbzni9TrEKcepjg@mail.gmail.com> <CAEf4Bza=fiCdXacf3pmdXGiiLx0U1qBKHbbjN-=AEvTZ+S8q0A@mail.gmail.com>
In-Reply-To: <CAEf4Bza=fiCdXacf3pmdXGiiLx0U1qBKHbbjN-=AEvTZ+S8q0A@mail.gmail.com>
From:   Joe Stringer <joe@wand.net.nz>
Date:   Thu, 26 Mar 2020 14:38:41 -0700
Message-ID: <CAOftzPjcvZ8Xyy3seLfXCEiasjAE-Sy8cwuOSou35X9fVr9jXg@mail.gmail.com>
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

On Thu, Mar 26, 2020 at 12:37 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Mar 25, 2020 at 10:28 PM Joe Stringer <joe@wand.net.nz> wrote:
> >
> > On Wed, Mar 25, 2020 at 7:16 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Tue, Mar 24, 2020 at 10:58 PM Joe Stringer <joe@wand.net.nz> wrote:
> > > >
> > > > From: Lorenz Bauer <lmb@cloudflare.com>
> > > >
> > > > Attach a tc direct-action classifier to lo in a fresh network
> > > > namespace, and rewrite all connection attempts to localhost:4321
> > > > to localhost:1234 (for port tests) and connections to unreachable
> > > > IPv4/IPv6 IPs to the local socket (for address tests).
> > > >
> > > > Keep in mind that both client to server and server to client traffic
> > > > passes the classifier.
> > > >
> > > > Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> > > > Co-authored-by: Joe Stringer <joe@wand.net.nz>
> > > > Signed-off-by: Joe Stringer <joe@wand.net.nz>
> > > > ---
> >
> > <snip>
> >
> > > > +static void handle_timeout(int signum)
> > > > +{
> > > > +       if (signum == SIGALRM)
> > > > +               fprintf(stderr, "Timed out while connecting to server\n");
> > > > +       kill(0, SIGKILL);
> > > > +}
> > > > +
> > > > +static struct sigaction timeout_action = {
> > > > +       .sa_handler = handle_timeout,
> > > > +};
> > > > +
> > > > +static int connect_to_server(const struct sockaddr *addr, socklen_t len)
> > > > +{
> > > > +       int fd = -1;
> > > > +
> > > > +       fd = socket(addr->sa_family, SOCK_STREAM, 0);
> > > > +       if (CHECK_FAIL(fd == -1))
> > > > +               goto out;
> > > > +       if (CHECK_FAIL(sigaction(SIGALRM, &timeout_action, NULL)))
> > > > +               goto out;
> > >
> > > no-no-no, we are not doing this. It's part of prog_tests and shouldn't
> > > install its own signal handlers and sending asynchronous signals to
> > > itself. Please find another way to have a timeout.
> >
> > I realise it didn't clean up after itself. How about signal(SIGALRM,
> > SIG_DFL); just like other existing tests do?
>
> You have alarm(3), which will deliver SIGALARM later, when other test
> is running. Once you clean up this custom signal handler it will cause
> test_progs to coredump. So still no, please find another way to do
> timeouts.

FWIW I hit this issue and alarm(0) afterwards fixed it up.

That said the SO_SNDTIMEO / SO_RCVTIMEO alternative should work fine
for this use case instead so I'll switch to that, it's marginally
cleaner.
