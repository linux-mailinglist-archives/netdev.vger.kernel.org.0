Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 407041823A4
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 22:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729232AbgCKVBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 17:01:51 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:34719 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbgCKVBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 17:01:50 -0400
Received: by mail-qk1-f196.google.com with SMTP id f3so3597308qkh.1;
        Wed, 11 Mar 2020 14:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lnRB7SIfRHvZE+4Ks0PAluwnDpGBF1Z7OiZTfn5ojcQ=;
        b=ElMXR6l+g+4NQFfUygU3d/SecgrAXGECxyMSfN4axVwgoVXcVCuvxHQkI2R/2CoT5P
         HKNHSXF4JSDENpc3YebPHPBGnMI0at+78Cbkijf7ElE/4hro4AFECqq4YYkPBFkc3VVy
         U+0pmmaCMAkoRC6VVJJmV0wGMEvxXriag54h+ggnMzfeKD5WemsqkyaB68ByjOtQ2A0K
         /Ive9pLQyN/8BCOBCRYzkDZKpFT7gASfoOSaRer3ogKWJj+b98Rn19iXLuR2/HLwmOuP
         MISaTJMIcyBPkrSxLawWq6WX40k0lHDKSoP08yxxhJ9QdUivkEKtU3DynLfU16xifGFY
         hicw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lnRB7SIfRHvZE+4Ks0PAluwnDpGBF1Z7OiZTfn5ojcQ=;
        b=Gcp+nN2K15DIBE2iRDRx31EIBzNQT1ELwAeNpjoBBdaPgID4nK6gNub6051MDpJjM9
         ooVox7lOftHIVo593KpHxqWxSbZXdWyBn7mwi2lBxjoSDgN8FgnB3ufbryrGymegdKGZ
         FJ5VzlgDgYJT8a5zg4cWUpZxSFLmoLGEGYaujoIiLQim71lIlW7QSyldDCKdqtF3ohju
         2Wy8zOOCVyiB+M+9oRFm5P/m8YHhs3CSC8TmIKz12iL+tpXFX8hpNi3bVI+uvJem7Jl+
         V1gv81/iHPzvufDkps1pLrNUgfh61lxgixOlmRD5ywEeK6G1WzWdTvEKjLlIobqjSmWV
         pMGA==
X-Gm-Message-State: ANhLgQ1+OYIJLE8lMt9GcjGrGZZ80jiTzX+cWxbYE9/HI9xa4eCVWh1G
        nIxxmsAFJW+RDclvwilDe4mKU/duc7twweR3w20NOJHd
X-Google-Smtp-Source: ADFU+vu/ThZrgH2H21ey1eveM15qmrff8AUBaMGynMK0V3qv5hm3rKfLrpYcbQF5koz5/y42hAf/2bzBwj9ETG53UDM=
X-Received: by 2002:a37:e40d:: with SMTP id y13mr4653608qkf.39.1583960509614;
 Wed, 11 Mar 2020 14:01:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200311191513.3954203-1-andriin@fb.com> <20200311204106.GA2125642@mini-arch.hsd1.ca.comcast.net>
In-Reply-To: <20200311204106.GA2125642@mini-arch.hsd1.ca.comcast.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 11 Mar 2020 14:01:38 -0700
Message-ID: <CAEf4BzZpL83aAhDWTyNoXtJp5W8S4Q_=+2_0UNeY=eb14hS8aQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: make tcp_rtt test more robust to failures
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 1:41 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 03/11, Andrii Nakryiko wrote:
> > Switch to non-blocking accept and wait for server thread to exit before
> > proceeding. I noticed that sometimes tcp_rtt server thread failure would
> > "spill over" into other tests (that would run after tcp_rtt), probably just
> > because server thread exits much later and tcp_rtt doesn't wait for it.
> >
> > Fixes: 8a03222f508b ("selftests/bpf: test_progs: fix client/server race in tcp_rtt")
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  .../selftests/bpf/prog_tests/tcp_rtt.c        | 30 +++++++++++--------
> >  1 file changed, 18 insertions(+), 12 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c b/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
> > index f4cd60d6fba2..d235eea0de27 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
> > @@ -188,7 +188,7 @@ static int start_server(void)
> >       };
> >       int fd;
> >
> > -     fd = socket(AF_INET, SOCK_STREAM, 0);
> > +     fd = socket(AF_INET, SOCK_STREAM | SOCK_NONBLOCK, 0);
> >       if (fd < 0) {
> >               log_err("Failed to create server socket");
> >               return -1;
> > @@ -205,6 +205,7 @@ static int start_server(void)
> >
> >  static pthread_mutex_t server_started_mtx = PTHREAD_MUTEX_INITIALIZER;
> >  static pthread_cond_t server_started = PTHREAD_COND_INITIALIZER;
> > +static volatile bool server_done = false;
> >
> >  static void *server_thread(void *arg)
> >  {
> > @@ -222,23 +223,22 @@ static void *server_thread(void *arg)
> >
> >       if (CHECK_FAIL(err < 0)) {
> >               perror("Failed to listed on socket");
> > -             return NULL;
> > +             return ERR_PTR(err);
> >       }
> >
> > -     client_fd = accept(fd, (struct sockaddr *)&addr, &len);
> > +     while (!server_done) {
> > +             client_fd = accept(fd, (struct sockaddr *)&addr, &len);
> > +             if (client_fd == -1 && errno == EAGAIN)
> > +                     continue;
> > +             break;
> > +     }
> >       if (CHECK_FAIL(client_fd < 0)) {
> >               perror("Failed to accept client");
> > -             return NULL;
> > +             return ERR_PTR(err);
> >       }
> >
> > -     /* Wait for the next connection (that never arrives)
> > -      * to keep this thread alive to prevent calling
> > -      * close() on client_fd.
> > -      */
> > -     if (CHECK_FAIL(accept(fd, (struct sockaddr *)&addr, &len) >= 0)) {
> > -             perror("Unexpected success in second accept");
> > -             return NULL;
> > -     }
> > +     while (!server_done)
> > +             usleep(50);
> >
> >       close(client_fd);
> >
> > @@ -249,6 +249,7 @@ void test_tcp_rtt(void)
> >  {
> >       int server_fd, cgroup_fd;
> >       pthread_t tid;
> > +     void *server_res;
> >
> >       cgroup_fd = test__join_cgroup("/tcp_rtt");
> >       if (CHECK_FAIL(cgroup_fd < 0))
> > @@ -267,6 +268,11 @@ void test_tcp_rtt(void)
> >       pthread_mutex_unlock(&server_started_mtx);
> >
> >       CHECK_FAIL(run_test(cgroup_fd, server_fd));
> > +
> > +     server_done = true;
>
> [..]
> > +     pthread_join(tid, &server_res);
> > +     CHECK_FAIL(IS_ERR(server_res));
>
> I wonder if we add (move) close(server_fd) before pthread_join(), can we
> fix this issue without using non-blocking socket? The accept() should
> return as soon as server_fd is closed so it's essentially your
> 'server_done'.

That was my first attempt. Amazingly, closing listening socket FD
doesn't unblock accept()...

>
> > +
> >  close_server_fd:
> >       close(server_fd);
> >  close_cgroup_fd:
> > --
> > 2.17.1
> >
