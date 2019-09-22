Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23D5FBABC4
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 23:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392380AbfIVVEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 17:04:07 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44436 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388636AbfIVVEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Sep 2019 17:04:06 -0400
Received: by mail-qt1-f194.google.com with SMTP id u40so14862901qth.11;
        Sun, 22 Sep 2019 14:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oFRwkLtn2Iq4ic5glemRgq9T0csDPXP20ndx8eWwKH0=;
        b=gF5tS84sfuj26rxAmSD8tXZJzlv6RZCDEVucrdGf8m0OWJKWJ92C2q2hEULVxN//0j
         pnB0lKgouLiw87AbMdE52dcwgu9lpR2FzQ6/23ADtr0vB2tysPU2UIBGfQKjU4QNEg4h
         V6x6H8KFXrz1EAtsOpDRtCXOgnWzZ9UOwgGvD5xYU45Cwfa0y22e/LS4VX3/73VJkagA
         JVXGVCOW/lDhPDi81cnyoDbJlYvDDcL6ot4f8R5V7mS1AzCBmY1ricrZNbN+nNZ9bAcj
         TzvhQ8qSeOWv+dhuZm0prpbGjUvOwrFi5wNf5i2Jcy1cy6+9IpW1e5uyMSEWThEjKyhK
         RITA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oFRwkLtn2Iq4ic5glemRgq9T0csDPXP20ndx8eWwKH0=;
        b=G1WitvnRrdxT1ybbwim3aGzfH4qpNqwTNWjBR11RKtfB4FqJ9XIYluePwcQG+0FlcY
         Jc9GJ0BPIv39U+OjExt4MoYAY6xLTdqijcQSfqlldurB0/czDPrl9UEzFOtYwej5t2ZE
         F3lw5suwPrO26Qb2gkmHb1iBcdh+KXVvRzHnsB70H4UnUAIQeomTyeN49Yky1HmQbR9a
         TVLn6SsnJFS9sNJVEQmrbTr86ZhxeFKHvGRuwOvx4LYbXnYsltC2g4iz4snBXSGPbAq3
         SZKx84Io9Wsl5fruqca+e6lbI33EJymleaMwxeWVtFJ0g2lvXVNnEeiecjz8zfLbzOPc
         ol5w==
X-Gm-Message-State: APjAAAUhFKkJVM0BoTvvzl70wNjBfeMrTkN6TMZC63L7sauDnDzHeDuk
        /uMnxhTs2BTHSKsOtmPOM1SYbVENaLDdN4Ktofs=
X-Google-Smtp-Source: APXvYqyOpM+WkAYatt7DzG/e4cFwk8OrxFjR+ycVMRb4cWpvcmoLJd0M3UQroa0ZOGu4FyW2oIRT3GdU+X0W5vULxJU=
X-Received: by 2002:ac8:5147:: with SMTP id h7mr14139172qtn.117.1569186245693;
 Sun, 22 Sep 2019 14:04:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190920233019.187498-1-sdf@google.com>
In-Reply-To: <20190920233019.187498-1-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 22 Sep 2019 14:03:54 -0700
Message-ID: <CAEf4BzYFQhPKoDG7kq=_B5caL-0Af2duL_Uz5v3oVw=BKQ430w@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests/bpf: test_progs: fix client/server race in tcp_rtt
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 22, 2019 at 12:10 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> This is the same problem I found earlier in test_sockopt_inherit:
> there is a race between server thread doing accept() and client
> thread doing connect(). Let's explicitly synchronize them via
> pthread conditional variable.
>
> Fixes: b55873984dab ("selftests/bpf: test BPF_SOCK_OPS_RTT_CB")
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  tools/testing/selftests/bpf/prog_tests/tcp_rtt.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c b/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
> index fdc0b3614a9e..e64058906bcd 100644
> --- a/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
> +++ b/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
> @@ -203,6 +203,9 @@ static int start_server(void)
>         return fd;
>  }
>
> +static pthread_mutex_t server_started_mtx = PTHREAD_MUTEX_INITIALIZER;
> +static pthread_cond_t server_started = PTHREAD_COND_INITIALIZER;
> +
>  static void *server_thread(void *arg)
>  {
>         struct sockaddr_storage addr;
> @@ -215,6 +218,10 @@ static void *server_thread(void *arg)
>                 return NULL;
>         }
>
> +       pthread_mutex_lock(&server_started_mtx);
> +       pthread_cond_signal(&server_started);
> +       pthread_mutex_unlock(&server_started_mtx);
> +
>         client_fd = accept(fd, (struct sockaddr *)&addr, &len);
>         if (CHECK_FAIL(client_fd < 0)) {
>                 perror("Failed to accept client");
> @@ -248,7 +255,14 @@ void test_tcp_rtt(void)
>         if (CHECK_FAIL(server_fd < 0))
>                 goto close_cgroup_fd;
>
> -       pthread_create(&tid, NULL, server_thread, (void *)&server_fd);
> +       if (CHECK_FAIL(pthread_create(&tid, NULL, server_thread,
> +                                     (void *)&server_fd)))
> +               goto close_cgroup_fd;
> +
> +       pthread_mutex_lock(&server_started_mtx);
> +       pthread_cond_wait(&server_started, &server_started_mtx);
> +       pthread_mutex_unlock(&server_started_mtx);


If the server fails to listen, then we'll never get a signal, right?
Let's use timedwait instead to avoid test getting stuck forever in
such cases?


> +
>         CHECK_FAIL(run_test(cgroup_fd, server_fd));
>         close(server_fd);
>  close_cgroup_fd:
> --
> 2.23.0.351.gc4317032e6-goog
>
