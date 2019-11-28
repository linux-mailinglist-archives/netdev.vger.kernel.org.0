Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6133B10CFA9
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 23:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbfK1WEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 17:04:35 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:42345 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbfK1WEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 17:04:35 -0500
Received: by mail-yb1-f195.google.com with SMTP id a11so10897566ybc.9
        for <netdev@vger.kernel.org>; Thu, 28 Nov 2019 14:04:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iXGDzfpX5eiGhGb96fDv8/kvkIXQpW5Kn/9+wc41hjk=;
        b=tzW7L96cIDmDD3+3yK3+j9a4rU85Xd9whFbeou95yYtyrWe20lHiWPe+j7B6Kqt0MR
         NOmq3iqwZP1SX5Ac5tXBUzh7Wl3jH68oKE26XCH8nyAIxtZc5rwEetbG5GABeJUz6vv1
         LX+U3v2uZr2gozNCv2HHLmyg+pH1JlVf3INKrx4DWThUP8XCQVcb+Hs7vr/fUQx/SInP
         s9/V4Kr9Q0zgprVzOskaPlUElVRU3tosKepZCRdesUmrab/M8pSKh5HBUit+xDJloXQg
         DTY8dijPZxrHNE7j14ZKQIm8mrEwqqp1EuCIv5AFPz6gtGittsjo8Nub3IKB5bFV5/4E
         Cisg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iXGDzfpX5eiGhGb96fDv8/kvkIXQpW5Kn/9+wc41hjk=;
        b=EzP7+/dxVzAIrBlzLAGmfXM0wnYpJ5l0YvEMdRsZgT/7mCwlggCgSkNVjBq/zarRXa
         HWgSXit3TJXej3CfnS/BPXr+dmtVdtgGfX7jhoRUMioipm9P8ZAulFOZv5C9lVpn4Xkb
         KHo3csa2KcSgh/Jo3ligVqqttiByBDTJq/0OEL0QioiaYJvPDHajEMtghk/IVykbW85z
         rhp6qZAKyT1mMvfST4tkA7kVEAj32WVM3rVcG12xZb96wheH8d4xhXeEoOLRVnSBciZM
         8HTuyH40Zhk3VsszRXyEgHTsUKPiJwkmco2J9GXiM0l07SSfKPxqmv6P88UoFG1rmc2l
         Yvaw==
X-Gm-Message-State: APjAAAUPyDaxHw6qeRP7UX6qzP7A89T8Yu7hhAL3AtVgB0GvleDJT5+7
        rDwr0+pbhj7vZ2pIuVRQElxrWb+5+bnGWXjs3myoMg==
X-Google-Smtp-Source: APXvYqz+ygUF+QX5xI3Otcw6/vxILp8vkPqfmUUAMGIl2vMwV9oPnXrBum9+5VxOWg/kJ/XOMuLzIWO2BQ2sUPNauAA=
X-Received: by 2002:a25:aaa4:: with SMTP id t33mr39288400ybi.274.1574978671474;
 Thu, 28 Nov 2019 14:04:31 -0800 (PST)
MIME-Version: 1.0
References: <2601e43617d707a28f60f2fe6927b1aaaa0a37f8.1574976866.git.gnault@redhat.com>
In-Reply-To: <2601e43617d707a28f60f2fe6927b1aaaa0a37f8.1574976866.git.gnault@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 28 Nov 2019 14:04:19 -0800
Message-ID: <CANn89i+G0jCU=JtSit3X9w+SaExgbbo-d1x4UEkTEJRdypN3gQ@mail.gmail.com>
Subject: Re: [PATCH net] tcp: Avoid time_after32() underflow when handling syncookies
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev <netdev@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 28, 2019 at 1:36 PM Guillaume Nault <gnault@redhat.com> wrote:
>
> In tcp_synq_overflow() and tcp_synq_no_recent_overflow(), the
> time_after32() call might underflow and return the opposite of the
> expected result.
>
> This happens after socket initialisation, when ->synq_overflow_ts and
> ->rx_opt.ts_recent_stamp are still set to zero. In this case, they
> can't be compared reliably to the current value of jiffies using
> time_after32(), because jiffies may be too far apart (especially soon
> after system startup, when it's close to 2^32).
>
> In such a situation, the erroneous time_after32() result prevents
> tcp_synq_overflow() from updating ->synq_overflow_ts and
> ->rx_opt.ts_recent_stamp, so the problem remains until jiffies wraps
> and exceeds HZ.
>
> Practical consequences should be quite limited though, because the
> time_after32() call of tcp_synq_no_recent_overflow() would also
> underflow (unless jiffies wrapped since the first time_after32() call),
> thus detecting a socket overflow and triggering the syncookie
> verification anyway.
>
> Also, since commit 399040847084 ("bpf: add helper to check for a valid
> SYN cookie") and commit 70d66244317e ("bpf: add bpf_tcp_gen_syncookie
> helper"), tcp_synq_overflow() and tcp_synq_no_recent_overflow() can be
> triggered from BPF programs. Even though such programs would normally
> pair these two operations, so both underflows would compensate each
> other as described above, we'd better avoid exposing the problem
> outside of the kernel networking stack.
>
> Let's fix it by initialising ->rx_opt.ts_recent_stamp and
> ->synq_overflow_ts to a value that can be safely compared to jiffies
> using time_after32(). Use "jiffies - TCP_SYNCOOKIE_VALID - 1", to
> indicate that we're not in a socket overflow phase.
>
> Fixes: cca9bab1b72c ("tcp: use monotonic timestamps for PAWS")
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  net/core/sock_reuseport.c | 10 ++++++++++
>  net/ipv4/tcp.c            |  8 ++++++++
>  2 files changed, 18 insertions(+)
>
> diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
> index f19f179538b9..87c287433a52 100644
> --- a/net/core/sock_reuseport.c
> +++ b/net/core/sock_reuseport.c
> @@ -11,6 +11,7 @@
>  #include <linux/idr.h>
>  #include <linux/filter.h>
>  #include <linux/rcupdate.h>
> +#include <net/tcp.h>
>
>  #define INIT_SOCKS 128
>
> @@ -85,6 +86,15 @@ int reuseport_alloc(struct sock *sk, bool bind_inany)
>         reuse->socks[0] = sk;
>         reuse->num_socks = 1;
>         reuse->bind_inany = bind_inany;
> +
> +       /* synq_overflow_ts can be used for syncookies. Ensure that it has a
> +        * recent value, so that tcp_synq_overflow() and
> +        * tcp_synq_no_recent_overflow() can safely use time_after32().
> +        * Initialise it 'TCP_SYNCOOKIE_VALID + 1' jiffies in the past, to
> +        * ensure that we start in the 'no recent overflow' case.
> +        */
> +       reuse->synq_overflow_ts = jiffies - TCP_SYNCOOKIE_VALID - 1;
> +
>         rcu_assign_pointer(sk->sk_reuseport_cb, reuse);
>
>  out:
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 9b48aec29aca..e9555db95dff 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -443,6 +443,14 @@ void tcp_init_sock(struct sock *sk)
>         tp->tsoffset = 0;
>         tp->rack.reo_wnd_steps = 1;
>
> +       /* ts_recent_stamp can be used for syncookies. Ensure that it has a
> +        * recent value, so that tcp_synq_overflow() and
> +        * tcp_synq_no_recent_overflow() can safely use time_after32().
> +        * Initialise it 'TCP_SYNCOOKIE_VALID + 1' jiffies in the past, to
> +        * ensure that we start in the 'no recent overflow' case.
> +        */
> +       tp->rx_opt.ts_recent_stamp = jiffies - TCP_SYNCOOKIE_VALID - 1;
> +
>         sk->sk_state = TCP_CLOSE;
>
>         sk->sk_write_space = sk_stream_write_space;
> --
> 2.21.0
>

A listener could be live for one year, and flip its ' I am under
synflood' status every 24 days (assuming HZ=1000)

You only made sure the first 24 days are ok, but the problem is still there.

We need to refresh the values, maybe in tcp_synq_no_recent_overflow()

(Note the issue has been there forever on 32bit arches)
