Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F37C618381A
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 18:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgCLR5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 13:57:20 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44080 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbgCLR5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 13:57:20 -0400
Received: by mail-qt1-f194.google.com with SMTP id h16so5086126qtr.11;
        Thu, 12 Mar 2020 10:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fcUmBSKOubwSK+evbJa9bjckIkDyihaMKqZDg6CoVTE=;
        b=k4NgwUUw/iihO90GSWCzkEhlKUn3ABVR8QzowdGpvnUsKMm6s9hXRjeVYn/AwVe1+z
         Ndg+GIbHkh3z63kqwahUbaM7T50Ube0JCvxwTi4hm64y4TV3pWWmfqjEUOpSQXWsQuVP
         BftLI7UX+WSHfR8U57Wnpo/Q7GLxHd1f+tCQm2/USF8WNkqX/0XwLROdKCf5tnpq3HBQ
         HSPivucrMlGJfYUfDLOBpjrB9rIoRc5jQBdz9VrIoru5lAkv5ta8GF8GszGqFxP3brmb
         iNtWA4Umo8mr87RLCwEOFW+dCZX3MAAqzGTr/PJba6TVoztYPxQPuTyE2sgBhJRz7A98
         sisA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fcUmBSKOubwSK+evbJa9bjckIkDyihaMKqZDg6CoVTE=;
        b=eUehd6FkPZD05Q0acG5RdrQ0xc+yRHwwFkqwJBth+SDle86B7KHm+I7kbZIdcpOExE
         kvf6zKj1DIRrWKGhs4qOYUZ4e/JcsFG+VObJVL4RlVAuk+u0p5Sv0Hvkt/9+eLCBAl1L
         uZR8qkOXK0HYZx0AWJL6Xj0DNGvtnh/2LDBpgaGezvcf7q8ps9ViEd+FdJcAkYJZALXV
         RHkkjr0RBjwbPET/kN9ac26GgMUYcYMs2fhlbipdOOuGa6jBNpy8D1gadptga8f/VlgB
         s9VTfahTvQ/2DLi9AktJbERQeYxq6dbwywXIGpmCsf2uG2PtAmNGC4VBmjgO75p8NyeN
         ddUw==
X-Gm-Message-State: ANhLgQ0mLd4mzeVHuO7r2edlCoVRzKS7s4TmXbyGxe0rJPWmGoSQyx+9
        xv8mQ38V47PclgVs6szPmrINs9xIjZF3nHJ1Ayw=
X-Google-Smtp-Source: ADFU+vvutppFPmZjzNWWltZFB1bcVR1eapxIeCdLOVswu98BxHvfSpkBCdIV9oQImZ8VILNXjvPLrR0N9bxiKLrK1/o=
X-Received: by 2002:ac8:140c:: with SMTP id k12mr8458255qtj.117.1584035839118;
 Thu, 12 Mar 2020 10:57:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200312171105.533690-1-jakub@cloudflare.com>
In-Reply-To: <20200312171105.533690-1-jakub@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 12 Mar 2020 10:57:08 -0700
Message-ID: <CAEf4BzbsDMbmury9Z-+j=egsfJf4uKxsu0Fsdr4YpP1FgvBiiQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix spurious failures in accept
 due to EAGAIN
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 12, 2020 at 10:11 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Andrii Nakryiko reports that sockmap_listen test suite is frequently
> failing due to accept() calls erroring out with EAGAIN:
>
>   ./test_progs:connect_accept_thread:733: accept: Resource temporarily unavailable
>   connect_accept_thread:FAIL:733
>
> This is because we are needlessly putting the listening TCP sockets in
> non-blocking mode.
>
> Fix it by using the default blocking mode in all tests in this suite.
>
> Fixes: 44d28be2b8d4 ("selftests/bpf: Tests for sockmap/sockhash holding listening sockets")
> Reported-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

Thanks for looking into this. Can you please verify that test
successfully fails (not hangs) when, say, network is down (do `ip link
set lo down` before running test?). The reason I'm asking is that I
just fixed a problem in tcp_rtt selftest, in which accept() would
block forever, even if listening socket was closed.


>  tools/testing/selftests/bpf/prog_tests/sockmap_listen.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
> index 52aa468bdccd..90271ec90388 100644
> --- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
> +++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
> @@ -754,7 +754,7 @@ static void test_syn_recv_insert_delete(int family, int sotype, int mapfd)
>         int err, s;
>         u64 value;
>
> -       s = socket_loopback(family, sotype | SOCK_NONBLOCK);
> +       s = socket_loopback(family, sotype);
>         if (s < 0)
>                 return;
>
> @@ -896,7 +896,7 @@ static void redir_to_connected(int family, int sotype, int sock_mapfd,
>
>         zero_verdict_count(verd_mapfd);
>
> -       s = socket_loopback(family, sotype | SOCK_NONBLOCK);
> +       s = socket_loopback(family, sotype);
>         if (s < 0)
>                 return;
>
> @@ -1028,7 +1028,7 @@ static void redir_to_listening(int family, int sotype, int sock_mapfd,
>
>         zero_verdict_count(verd_mapfd);
>
> -       s = socket_loopback(family, sotype | SOCK_NONBLOCK);
> +       s = socket_loopback(family, sotype);
>         if (s < 0)
>                 return;
>
> --
> 2.24.1
>
