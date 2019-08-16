Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB96905FA
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 18:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726941AbfHPQh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 12:37:59 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:42019 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbfHPQh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 12:37:58 -0400
Received: by mail-ot1-f66.google.com with SMTP id j7so10125706ota.9;
        Fri, 16 Aug 2019 09:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jojj179az45tbHD4CUEIdOITmY1yKd9pWEAUy54nDTg=;
        b=mnZAfvbT9nPKTno+KcYGSDBOEPnAx3N6/W+GzB0PNSl8qdcsgoh6hdHCoYay7PUnoA
         klYEK5LJDqOYTiZfxs3Ef5LOZiXh7WrmfC0nFcthb6bXpW4O6v9xKMt+ttDVMpXKPVWk
         sL6f7c6kh/O70x45js7EXDOzM9StT0wz+Nm7ljRbRfVLmqJ0bpLXg8VU2SuDnFr+B+Bb
         6TFGaqDBae12CjCyM4GCK6cGoqJ0Ex7LDJ5QCn7SiRrgZxHd11z9PBwJLp5iu+0oIJEf
         jwyFVeJJEy6s0to2kFcc61hoqvCxppoIjBQxvk16iIu6rOoUA9UDqsXbmPs8SOXJ38ri
         db8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jojj179az45tbHD4CUEIdOITmY1yKd9pWEAUy54nDTg=;
        b=EomMdUoN1c+fwV/hB00aZZ63HJEywgfOuHwBXUrFbvlyAnpU5VrGsD81YdrsxZFigu
         cp3GjguhSKw4ydVrjq7pQQvpbO7Kc3ZrkXBxw2feyG0kjogekVatpl5nv8kkxKYTl9N/
         RNhkGCrDp4cshJR2yQTg1S0UymchicFjcKa572Tsy+DYlhIUNx2Mnx1f++h0IOFYGlXn
         f2SIXxVwclzMW4tigrR/Y/w4B000TJ39wNi7Umk4xFf/Wr4Pr8IrjYbSG7e4fKhxSg9b
         9PsclJe9Ay6/JQkb2EVXIX9xO9FMpg1ZQKdPHJuY6N3YWaYW8MjT8ysbMjqS3WCf4HDz
         v4tw==
X-Gm-Message-State: APjAAAWdqkQSkYWxPT4RmvBv6/VTQW5IjsVCr0XcqsrVXUUNfapUwJYS
        ByVmezGDc2KaLIUAeSElFSyAmBqbNgMpMn5Y0uQ=
X-Google-Smtp-Source: APXvYqx3ajM5Unmh3ZmHZ5WsZyz+aWr06MeHQiPf81QbQyNvupnu4IHpVuCa1oUB0pHwkN8wUdYGYyhyyMJJBHWQNH8=
X-Received: by 2002:a9d:67cd:: with SMTP id c13mr6381658otn.196.1565973477817;
 Fri, 16 Aug 2019 09:37:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190816160339.249832-1-ppenkov.kernel@gmail.com> <20190816161302.GQ2820@mini-arch>
In-Reply-To: <20190816161302.GQ2820@mini-arch>
From:   Petar Penkov <ppenkov.kernel@gmail.com>
Date:   Fri, 16 Aug 2019 09:37:46 -0700
Message-ID: <CAGdtWsR0KtCuc7wb3Uh57DpNrWZTYL2pxXQ2FVFJHtFfoSPmwg@mail.gmail.com>
Subject: Re: [bpf-next] selftests/bpf: fix race in test_tcp_rtt test
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        davem@davemloft.net, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 16, 2019 at 9:13 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 08/16, Petar Penkov wrote:
> > From: Petar Penkov <ppenkov@google.com>
> >
> > There is a race in this test between receiving the ACK for the
> > single-byte packet sent in the test, and reading the values from the
> > map.
> >
> > This patch fixes this by having the client wait until there are no more
> > unacknowledged packets.
> >
> > Before:
> > for i in {1..1000}; do ../net/in_netns.sh ./test_tcp_rtt; \
> > done | grep -c PASSED
> > < trimmed error messages >
> > 993
> >
> > After:
> > for i in {1..10000}; do ../net/in_netns.sh ./test_tcp_rtt; \
> > done | grep -c PASSED
> > 10000
> >
> > Fixes: b55873984dab ("selftests/bpf: test BPF_SOCK_OPS_RTT_CB")
> > Signed-off-by: Petar Penkov <ppenkov@google.com>
> > ---
> >  tools/testing/selftests/bpf/test_tcp_rtt.c | 31 ++++++++++++++++++++++
> >  1 file changed, 31 insertions(+)
> >
> > diff --git a/tools/testing/selftests/bpf/test_tcp_rtt.c b/tools/testing/selftests/bpf/test_tcp_rtt.c
> > index 90c3862f74a8..2b4754473956 100644
> > --- a/tools/testing/selftests/bpf/test_tcp_rtt.c
> > +++ b/tools/testing/selftests/bpf/test_tcp_rtt.c
> > @@ -6,6 +6,7 @@
> >  #include <sys/types.h>
> >  #include <sys/socket.h>
> >  #include <netinet/in.h>
> > +#include <netinet/tcp.h>
> >  #include <pthread.h>
> >
> >  #include <linux/filter.h>
> > @@ -34,6 +35,30 @@ static void send_byte(int fd)
> >               error(1, errno, "Failed to send single byte");
> >  }
> >
> > +static int wait_for_ack(int fd, int retries)
> > +{
> > +     struct tcp_info info;
> > +     socklen_t optlen;
> > +     int i, err;
> > +
> > +     for (i = 0; i < retries; i++) {
> > +             optlen = sizeof(info);
> > +             err = getsockopt(fd, SOL_TCP, TCP_INFO, &info, &optlen);
> > +             if (err < 0) {
> > +                     log_err("Failed to lookup TCP stats");
> > +                     return err;
> > +             }
> > +
> > +             if (info.tcpi_unacked == 0)
> > +                     return 0;
> > +
> > +             sleep(1);
> Isn't it too big of a hammer? Maybe usleep(10) here and do x100 retries
> instead?
>
I guess this is more consistent with the time we expect to wait for an
ACK in the test, will change and send out a v2 shortly. Thank you for
your quick review!
> > +     }
> > +
> > +     log_err("Did not receive ACK");
> > +     return -1;
> > +}
> > +
> >  static int verify_sk(int map_fd, int client_fd, const char *msg, __u32 invoked,
> >                    __u32 dsack_dups, __u32 delivered, __u32 delivered_ce,
> >                    __u32 icsk_retransmits)
> > @@ -149,6 +174,11 @@ static int run_test(int cgroup_fd, int server_fd)
> >                        /*icsk_retransmits=*/0);
> >
> >       send_byte(client_fd);
> > +     if (wait_for_ack(client_fd, 5) < 0) {
> > +             err = -1;
> > +             goto close_client_fd;
> > +     }
> > +
> >
> >       err += verify_sk(map_fd, client_fd, "first payload byte",
> >                        /*invoked=*/2,
> > @@ -157,6 +187,7 @@ static int run_test(int cgroup_fd, int server_fd)
> >                        /*delivered_ce=*/0,
> >                        /*icsk_retransmits=*/0);
> >
> > +close_client_fd:
> >       close(client_fd);
> >
> >  close_bpf_object:
> > --
> > 2.23.0.rc1.153.gdeed80330f-goog
> >
