Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE52BB9CD
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 18:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389984AbfIWQlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 12:41:17 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:46805 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387922AbfIWQlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 12:41:17 -0400
Received: by mail-qk1-f195.google.com with SMTP id 201so16045771qkd.13;
        Mon, 23 Sep 2019 09:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SBKCJ9/KWpxGbP4djDzhK53U35CqZgAtuBDicONwJzU=;
        b=hw+P+kJwxdN8zr5dAFV2JiGR2bKoVLOLu1W12dXamssIwg3T1dIgW5UuVfFyiW8lfC
         JjoxmRYPVT4SLJuabge4VsCjiFSzKcUmtsu4uF7AZgxTngm6sZVaEuSfI8WCdbmkEYco
         Hfp1/6tmhrVzto8VuaXJ5bhrfo1NhpRKxWrSGHhN4yNAImJNmVB52F4o+Xev+BR4Mx7m
         k7b83n2IA/ZPkOrTxRbW1xOO/Ge9mh2f6UfMDJg/+onjblgxw89dOYur06KTbJN63nN3
         snmuLqXFk2VahcDN+qxiQmEgIzmbre9iL8jnlF0UC1QBL+plTqy/gWf00EJuJTtMG90I
         +4UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SBKCJ9/KWpxGbP4djDzhK53U35CqZgAtuBDicONwJzU=;
        b=kMzkaLp5bZSN/9EanOTNY3oSc6rlRi3kqoY6hs8DfBUwiPJ9DtSQ0AsIawu9wyWCYu
         Wjz6OtvOHlYyiqEopdQIAIjErK6wPPqb11IwouENTqjdJ/UppuiGOmIS0qd9zYTxIkA3
         s0rDbxGFZcRqUAqgKkEUjCS0H+3TT52CmTBi01lAHgL8ekPoLnUVpRZDYrMBd+ToOYQj
         Gfhc0uJHAQtQv8fRnT+UkExwfKc9WTivo45hA7zamWa/Onx6WSsr6a1RYhb3pQkISjG5
         LftVDACLGMJbMjguzTyr5quA58FRifTxr+vqJAlwdVqvE5nKexxDcE4OIeW27+qxREoU
         G0tw==
X-Gm-Message-State: APjAAAUAeIGj61OqUZlCX10Lcx0RTsIFr/O3TeDZS0ZajVzTI9lhjA38
        ZgGBzWxy28LRgR4HQfhYIzT08ZnjvtvURO80TTHBLFtj
X-Google-Smtp-Source: APXvYqxlSdRfwAA0/m/q8wfAxiI1EB1Jtiosq0KEktrOmbfzzBfNbCO+9G0an3IvW7q9rXgHCZ8EJUkB6+2U+XDVkRs=
X-Received: by 2002:ae9:dc87:: with SMTP id q129mr797545qkf.92.1569256876316;
 Mon, 23 Sep 2019 09:41:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190920233019.187498-1-sdf@google.com> <CAEf4BzYFQhPKoDG7kq=_B5caL-0Af2duL_Uz5v3oVw=BKQ430w@mail.gmail.com>
 <20190923153819.GA21441@mini-arch>
In-Reply-To: <20190923153819.GA21441@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 23 Sep 2019 09:41:05 -0700
Message-ID: <CAEf4BzYGLraDwTurDakNq4PuHr0VpqCBOrJ33guPChFk4amBnw@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests/bpf: test_progs: fix client/server race in tcp_rtt
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 23, 2019 at 8:38 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 09/22, Andrii Nakryiko wrote:
> > On Sun, Sep 22, 2019 at 12:10 PM Stanislav Fomichev <sdf@google.com> wrote:
> > >
> > > This is the same problem I found earlier in test_sockopt_inherit:
> > > there is a race between server thread doing accept() and client
> > > thread doing connect(). Let's explicitly synchronize them via
> > > pthread conditional variable.
> > >
> > > Fixes: b55873984dab ("selftests/bpf: test BPF_SOCK_OPS_RTT_CB")
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> > >  tools/testing/selftests/bpf/prog_tests/tcp_rtt.c | 16 +++++++++++++++-
> > >  1 file changed, 15 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c b/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
> > > index fdc0b3614a9e..e64058906bcd 100644
> > > --- a/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
> > > +++ b/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
> > > @@ -203,6 +203,9 @@ static int start_server(void)
> > >         return fd;
> > >  }
> > >
> > > +static pthread_mutex_t server_started_mtx = PTHREAD_MUTEX_INITIALIZER;
> > > +static pthread_cond_t server_started = PTHREAD_COND_INITIALIZER;
> > > +
> > >  static void *server_thread(void *arg)
> > >  {
> > >         struct sockaddr_storage addr;
> > > @@ -215,6 +218,10 @@ static void *server_thread(void *arg)
> > >                 return NULL;
> > >         }
> > >
> > > +       pthread_mutex_lock(&server_started_mtx);
> > > +       pthread_cond_signal(&server_started);
> > > +       pthread_mutex_unlock(&server_started_mtx);
> > > +
> > >         client_fd = accept(fd, (struct sockaddr *)&addr, &len);
> > >         if (CHECK_FAIL(client_fd < 0)) {
> > >                 perror("Failed to accept client");
> > > @@ -248,7 +255,14 @@ void test_tcp_rtt(void)
> > >         if (CHECK_FAIL(server_fd < 0))
> > >                 goto close_cgroup_fd;
> > >
> > > -       pthread_create(&tid, NULL, server_thread, (void *)&server_fd);
> > > +       if (CHECK_FAIL(pthread_create(&tid, NULL, server_thread,
> > > +                                     (void *)&server_fd)))
> > > +               goto close_cgroup_fd;
> > > +
> > > +       pthread_mutex_lock(&server_started_mtx);
> > > +       pthread_cond_wait(&server_started, &server_started_mtx);
> > > +       pthread_mutex_unlock(&server_started_mtx);
> >
> >
> > If the server fails to listen, then we'll never get a signal, right?
> > Let's use timedwait instead to avoid test getting stuck forever in
> > such cases?
> Good point. How about I do the same thing I do in sockopt_inherit tests:
> https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c#n73
>
>         err = listen()
>         pthread_cond_signal()
>         if (CHECK_FAIL(err)) {
>                 return;
>         }
>
> Should fix the problem of getting stuck forever without any timeouts.
> I'll send a v2 later today.

Sounds good.


>
> > > +
> > >         CHECK_FAIL(run_test(cgroup_fd, server_fd));
> > >         close(server_fd);
> > >  close_cgroup_fd:
> > > --
> > > 2.23.0.351.gc4317032e6-goog
> > >
