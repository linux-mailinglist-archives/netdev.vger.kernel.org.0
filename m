Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B46B181F55
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 18:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730471AbgCKRZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 13:25:11 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:40005 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730193AbgCKRZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 13:25:11 -0400
Received: by mail-ot1-f65.google.com with SMTP id h17so2856472otn.7
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 10:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A72FMDEMFI/PWSo7NEjukyYc/xIp+ZKKEp1Vw5reguA=;
        b=f4NPjv9Kh5RQg8A2ZphMM8k4y/Wqzy++zz4Smc4ns7kb4mTZY5b0MquVoo0oaexG8m
         KrG4IP7LWnuJLt4DT5ftocqv4S8NUxnJs1n6VKk/nJFqtEd9LZkJ3dRhryovuziWOfjC
         J1fsmPTGQdVTY4YnZS9hRrCrVnSql9Ru/Y1sw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A72FMDEMFI/PWSo7NEjukyYc/xIp+ZKKEp1Vw5reguA=;
        b=YHFMy+bHG9PnxY0LPqInP3EkWgDModkOkrDb9rsQK+b90nSbPdC8CuAThxfdPBhOuD
         7cy48JGwvOW13fO5iTwqX8CisBBtV/3th/s6VJDC3yWyAEyivVftjHf70xpoZzk/5aJp
         8oc7NWiLi7RlGEyzcQIAdwl2jODKLDaywD96nhf41CgkjgPJYXdIG7B9DpEsh5FyVW4i
         cuqYo/rDvaxzLfEONHVqsIqkOy+U4bRV7c4ztid6TO5FSdejq7Gb8lbD0b/eZ8zgZjmt
         A5R06OlNMb3KszHQu3yipA2Gqm93G5z80PpK/ePzgOAJN3ft0Z2XXoECZ2ZfWxGppCN6
         wFZA==
X-Gm-Message-State: ANhLgQ3tgAIdmCqO2ohTKeqNzGbeJytVuo7cHRvMe9WlEGiFE6LmR4n+
        4E+22xHYIVUgfpQwqqz3Gm+H+95qNMrR7DB9S25G1A==
X-Google-Smtp-Source: ADFU+vtnHEnOBiDu3qXi9GBfF3N93KhAg6bGngtzbVZAuuxAr+3h2KDdAnDf5Jg5otnqUiCg3Co0ZRiZ+uCff88sbto=
X-Received: by 2002:a05:6820:128:: with SMTP id i8mr1024041ood.45.1583947510588;
 Wed, 11 Mar 2020 10:25:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200310174711.7490-1-lmb@cloudflare.com> <20200310174711.7490-6-lmb@cloudflare.com>
 <87wo7rxal4.fsf@cloudflare.com>
In-Reply-To: <87wo7rxal4.fsf@cloudflare.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Wed, 11 Mar 2020 17:24:59 +0000
Message-ID: <CACAyw9_DC5ewgLX=Qrvmbs3i3YvtuLBFbe1Hr6SJtbE+L1P2eQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] bpf: sockmap, sockhash: test looking up fds
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@cloudflare.com>,
        linux-kselftest@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Mar 2020 at 13:52, Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Tue, Mar 10, 2020 at 06:47 PM CET, Lorenz Bauer wrote:
> > Make sure that looking up an element from the map succeeds,
> > and that the fd is valid by using it an fcntl call.
> >
> > Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> > ---
> >  .../selftests/bpf/prog_tests/sockmap_listen.c | 26 ++++++++++++++-----
> >  1 file changed, 20 insertions(+), 6 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
> > index 52aa468bdccd..929e1e77ecc6 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
> > @@ -453,7 +453,7 @@ static void test_lookup_after_delete(int family, int sotype, int mapfd)
> >       xclose(s);
> >  }
> >
> > -static void test_lookup_32_bit_value(int family, int sotype, int mapfd)
> > +static void test_lookup_fd(int family, int sotype, int mapfd)
> >  {
> >       u32 key, value32;
> >       int err, s;
> > @@ -466,7 +466,7 @@ static void test_lookup_32_bit_value(int family, int sotype, int mapfd)
> >                              sizeof(value32), 1, 0);
> >       if (mapfd < 0) {
> >               FAIL_ERRNO("map_create");
> > -             goto close;
> > +             goto close_sock;
> >       }
> >
> >       key = 0;
> > @@ -475,11 +475,25 @@ static void test_lookup_32_bit_value(int family, int sotype, int mapfd)
> >
> >       errno = 0;
> >       err = bpf_map_lookup_elem(mapfd, &key, &value32);
> > -     if (!err || errno != ENOSPC)
> > -             FAIL_ERRNO("map_lookup: expected ENOSPC");
> > +     if (err) {
> > +             FAIL_ERRNO("map_lookup");
> > +             goto close_map;
> > +     }
> >
> > +     if ((int)value32 == s) {
> > +             FAIL("return value is identical");
> > +             goto close;
> > +     }
> > +
> > +     err = fcntl(value32, F_GETFD);
> > +     if (err == -1)
> > +             FAIL_ERRNO("fcntl");
>
> I would call getsockopt()/getsockname() to assert that the FD lookup
> succeeded.  We want to know not only that it's an FD (-EBADFD case), but
> also that it's associated with a socket (-ENOTSOCK).
>
> We can go even further, and compare socket cookies to ensure we got an
> FD for the expected socket.

Good idea, thanks!

> Also, I'm wondering if we could keep the -ENOSPC case test-covered by
> temporarily dropping NET_ADMIN capability.

You mean EPERM? ENOSPC isn't reachable, since the map can only be created
with a map_value of 4 or 8.

>
> > +
> > +close:
> > +     xclose(value32);
> > +close_map:
> >       xclose(mapfd);
> > -close:
> > +close_sock:
> >       xclose(s);
> >  }
> >
> > @@ -1456,7 +1470,7 @@ static void test_ops(struct test_sockmap_listen *skel, struct bpf_map *map,
> >               /* lookup */
> >               TEST(test_lookup_after_insert),
> >               TEST(test_lookup_after_delete),
> > -             TEST(test_lookup_32_bit_value),
> > +             TEST(test_lookup_fd),
> >               /* update */
> >               TEST(test_update_existing),
> >               /* races with insert/delete */



-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
