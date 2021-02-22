Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868F9321199
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 08:50:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhBVHsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 02:48:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbhBVHs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 02:48:29 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF1E0C061574
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 23:47:48 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id p186so12035583ybg.2
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 23:47:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nLmHZHLnRgwDEEObE94Nv0Fsz35Ofv0+MLLREOl9EKo=;
        b=rrBdirC+RJBT90GZlIyIX4UdWjk0XyBHsRx7Snz3fBoAqUYRUbujpSAP8oOT6keGMX
         z2/YVH7ZgQzIGJjyzrAwFrAyqavCMWutoFdMKI6i19CFxwPj1EErgZS4UD42Ufcpv6gx
         ca8y3fbjWLFt/IXTUwMSR/l2SDfcCYf+bDM7tdN3aPTrrkHApsKf9jOfzJcdFkogoVMY
         v0bu13qtxPOd1UDgFSNt9WgUXlxZWhw4cKTlrPkLHsmlg7lIObAA4fqUg7p3OzDOKNAP
         WY/bM40bu6+PrM/b5aboFYF+gHvFobM882PosueNsGVJ/fV7ofTHFMmVY84m0Clzpelz
         qoeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nLmHZHLnRgwDEEObE94Nv0Fsz35Ofv0+MLLREOl9EKo=;
        b=gB102MEchVyVKkFGOEFgmC+RlRvYVOfhGm2qtLAZ6Ko714G3TcBJTWve8tgqRQFqwY
         O7zu8dssSqPdHt6MwoVwBF9/4R6KJf15qcJAe7YNvllZFptax6nmi8L3J0a8hFD5WhJR
         J3pRDW2mStsdHl0ofgCLrNTqoMPoNL9Vc3vz7RzXbMWD4T82tLgvndNhFpYUUDFCHRmD
         geYKk+HoWfPr82o5EEbhl/TpGM8JmpDsg7ihIcwj23YlB+kcTvFvi+ItNiGZro5ioZEP
         AzF247D/qye4tCq44Qv8aqSFPAU0hJB8RqRMKk1zb9+rReseRjL5z9Z1IBskppA654ge
         6kgA==
X-Gm-Message-State: AOAM532jlGip8nHy9RU1xNVyegY89lh7Z4DKwZSFtYVKGtLp47GYSvw1
        lW9p6dOTITh/m7mpcB1v2rWuABS3b9C4tLFB8xKaOX5FoHw=
X-Google-Smtp-Source: ABdhPJzBCUglu9dk+dHnqAzCSN5FK6zpJMPMOWaQmxWodYX1NnJ/oUNlaNqrU5r8gLKb/o9gS7ufrNe4P9F6WrxKc64=
X-Received: by 2002:a25:2307:: with SMTP id j7mr6910028ybj.518.1613980067690;
 Sun, 21 Feb 2021 23:47:47 -0800 (PST)
MIME-Version: 1.0
References: <20210220110356.84399-1-redsky110@gmail.com>
In-Reply-To: <20210220110356.84399-1-redsky110@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 22 Feb 2021 08:47:35 +0100
Message-ID: <CANn89iKw_GCU6QeDHx31zcjFzqhzjaR2KrSNRON=KbohswHhmg@mail.gmail.com>
Subject: Re: [PATCH] tcp: avoid unnecessary loop if even ports are used up
To:     Honglei Wang <redsky110@gmail.com>
Cc:     David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 20, 2021 at 12:04 PM Honglei Wang <redsky110@gmail.com> wrote:
>
> We are getting port for connect() from even ports firstly now. This
> makes bind() users have more available slots at odd part. But there is a
> problem here when the even ports are used up. This happens when there
> is a flood of short life cycle connections. In this scenario, it starts
> getting ports from the odd part, but each requirement has to walk all of
> the even port and the related hash buckets (it probably gets nothing
> before the workload pressure's gone) before go to the odd part. This
> makes the code path __inet_hash_connect()->__inet_check_established()
> and the locks there hot.
>
> This patch tries to improve the strategy so we can go faster when the
> even part is used up. It'll record the last gotten port was odd or even,
> if it's an odd one, it means there is no available even port for us and
> we probably can't get an even port this time, neither. So we just walk
> 1/16 of the whole even ports. If we can get one in this way, it probably
> means there are more available even part, we'll go back to the old
> strategy and walk all of them when next connect() comes. If still can't
> get even port in the 1/16 part, we just go to the odd part directly and
> avoid doing unnecessary loop.


Your patch trades correctness for speed.

Sorry, but adding yet another static (and thus shared) variable
assuming only one process
on the physical host attempts a series of connect() is a non starter for me.

Just scanning 1/8 of even ports to decide if none of them is available
is potentially going to
not see 7/16 of potential free 4-tuple, and an application needing
28,000 4-tuple with SRCIP,DSTIP,DSTPORT being fixed
might not be able to run anymore.

If you do not care about bind() being able to find a free port, I
would suggest you add
a sysctl to simply relax the even/odd strategy that Google has been using
to avoid all these port exhaustion bugs we had in the past.
(Although now we use one netns per job, jobs are now isolated and only
can hurt themselves)



>
>
> Signed-off-by: Honglei Wang <redsky110@gmail.com>
> ---
>  net/ipv4/inet_hashtables.c | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> index 45fb450b4522..c95bf5cf9323 100644
> --- a/net/ipv4/inet_hashtables.c
> +++ b/net/ipv4/inet_hashtables.c
> @@ -721,9 +721,10 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
>         struct net *net = sock_net(sk);
>         struct inet_bind_bucket *tb;
>         u32 remaining, offset;
> -       int ret, i, low, high;
> +       int ret, i, low, high, span;
>         static u32 hint;


This is an old tree, current kernels do not have this 'static u32 hint' anymore.


>
>         int l3mdev;
> +       static bool last_port_is_odd;
>
>         if (port) {
>                 head = &hinfo->bhash[inet_bhashfn(net, port,
> @@ -756,8 +757,19 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
>          */
>         offset &= ~1U;
>  other_parity_scan:
> +       /* If the last available port is odd, it means
> +        * we walked all of the even ports, but got
> +        * nothing last time. It's telling us the even
> +        * part is busy to get available port. In this
> +        * case, we can go a bit faster.
> +        */
> +       if (last_port_is_odd && !(offset & 1) && remaining > 32)
> +               span = 32;
> +       else
> +               span = 2;
> +
>         port = low + offset;
> -       for (i = 0; i < remaining; i += 2, port += 2) {
> +       for (i = 0; i < remaining; i += span, port += span) {
>                 if (unlikely(port >= high))
>                         port -= remaining;
>                 if (inet_is_local_reserved_port(net, port))
> @@ -806,6 +818,11 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
>  ok:
>         hint += i + 2;
>
> +       if (offset & 1)
> +               last_port_is_odd = true;
> +       else
> +               last_port_is_odd = false;
> +
>         /* Head lock still held and bh's disabled */
>         inet_bind_hash(sk, tb, port);
>         if (sk_unhashed(sk)) {
> --
> 2.14.1
>
