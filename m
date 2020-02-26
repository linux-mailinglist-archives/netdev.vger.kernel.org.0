Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9280170676
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 18:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgBZRrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 12:47:46 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:36272 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgBZRrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 12:47:46 -0500
Received: by mail-yw1-f65.google.com with SMTP id y72so254510ywg.3
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 09:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4nWSD5rX0iUFe+4lysKTB0gKSfxOYTIMo5sQHG78MEk=;
        b=mkFwcEFa69A1ukTfnoCEyUvbQD1ZmZv7kLzPxC+A6lvEYjT/+tXbG5I+8laSDjWQIc
         xlTPN8QIRSbaZ+ALpduSb6L9JhAf3Ha/+blz4sHR3CDLiBbBtoB/ZLuG+EVKJ85ZZuaS
         a6ZToCcNVotM1TPIYAL6G0vct4JTtHv33FF6EOkG3sEy1dE3r5z1uQ96ptjwDZQ7a4XF
         rGtlbFJSiZyS55oho9OhBayed3aJ2vBQmiT5saaw2NqyY7YJCSCc8FMunmNV48LvdwIF
         HCzELBstTtLURKd+2XLOLCKMioJc5hiA6mZS/KDPu61Kw4aqYWI+yMP58RHZq+n6HP//
         Awrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4nWSD5rX0iUFe+4lysKTB0gKSfxOYTIMo5sQHG78MEk=;
        b=Obw4+pc5mV+JMw+LSlsZCpHnqJGZIMchhuqVqsJ5CBfZq+Scgbu4y8qZYw7/uW0iWS
         SHEDvWZxFe6D8Ldoq4x5R/XEXEDFDBDxYeinEWGxKSvSLPKZ+1nHbfauR4MJhaK7G75k
         G4huMqePpvyRr6ZjDuLy356MtNMwSF1c0GRvFnregpttEZVZ0tzr9cbwuLuCY9PsYRdO
         mz5YEk1S4/kzidkopxoHmqpenYxlRHfKE4m8Zfno61sOnEtUXe/08c5q6OuT33/LX0Mz
         8hNEcqxc9ZsIx4kN2LQQN83pKgNiXW4pha4Jc6FuRJYiS+9114GvM/qNTd+enMRoTXKD
         i0hw==
X-Gm-Message-State: APjAAAUaf816oQTBlCaIGbXrE5KzcODSMlaNwHG8zpHnv+1RonAqOd7e
        V+WPOC/c2w3+j027WEalG1RMDq57FFUww8ZzIvkkYw==
X-Google-Smtp-Source: APXvYqzxSfdN+EgnzTKq5ESW7ClF19Nft2Lmfjyb4y8aFrOHCTCRv+urbUMt9KAide2jJIFVDJ+GGv1+DOcpxcn8hh0=
X-Received: by 2002:a81:b38a:: with SMTP id r132mr372848ywh.114.1582739258206;
 Wed, 26 Feb 2020 09:47:38 -0800 (PST)
MIME-Version: 1.0
References: <20200226074631.67688-1-kuniyu@amazon.co.jp> <20200226074631.67688-4-kuniyu@amazon.co.jp>
In-Reply-To: <20200226074631.67688-4-kuniyu@amazon.co.jp>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 26 Feb 2020 09:47:26 -0800
Message-ID: <CANn89i+m9yKkaVLUm9P8+gTSOMtvrJgsvHfKAjXCZ5_9Wf0-9w@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 3/3] tcp: Prevent port hijacking when ports
 are exhausted.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        kuni1840@gmail.com, netdev <netdev@vger.kernel.org>,
        osa-contribution-log@amazon.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 11:46 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
>
> If all of the sockets bound to the same port have SO_REUSEADDR and
> SO_REUSEPORT enabled, any other user can hijack the port by exhausting all
> ephemeral ports, binding sockets to (addr, 0) and calling listen().
>

Yes, an user (application) can steal all ports by opening many
sockets, bind to (addr, 0) and calling listen().

This changelog is rather confusing, and your patch does not solve this
precise problem.
Patch titles are important, you are claiming something, but I fail to
see how the patch solves the problem stated in the title.

Please be more specific, and add tests officially, in tools/testing/selftests/


> If both of SO_REUSEADDR and SO_REUSEPORT are enabled, the restriction of
> SO_REUSEPORT should be taken into account so that can only one socket be in
> TCP_LISTEN.

Sorry, I do not understand this. If I do not understand the sentence,
I do not read the patch
changing one piece of code that has been very often broken in the past.

Please spend time on the changelog to give the exact outcome and goals.

Thanks.

>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> ---
>  net/ipv4/inet_connection_sock.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index cddeab240ea6..d27ed5fe7147 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -131,7 +131,7 @@ static int inet_csk_bind_conflict(const struct sock *sk,
>  {
>         struct sock *sk2;
>         bool reuse = sk->sk_reuse;
> -       bool reuseport = !!sk->sk_reuseport && reuseport_ok;
> +       bool reuseport = !!sk->sk_reuseport;
>         kuid_t uid = sock_i_uid((struct sock *)sk);
>
>         /*
> @@ -148,10 +148,16 @@ static int inet_csk_bind_conflict(const struct sock *sk,
>                      sk->sk_bound_dev_if == sk2->sk_bound_dev_if)) {
>                         if (reuse && sk2->sk_reuse &&
>                             sk2->sk_state != TCP_LISTEN) {
> -                               if (!relax &&
> +                               if ((!relax ||
> +                                    (!reuseport_ok &&
> +                                     reuseport && sk2->sk_reuseport &&
> +                                     !rcu_access_pointer(sk->sk_reuseport_cb) &&
> +                                     (sk2->sk_state == TCP_TIME_WAIT ||
> +                                      uid_eq(uid, sock_i_uid(sk2))))) &&
>                                     inet_rcv_saddr_equal(sk, sk2, true))
>                                         break;
> -                       } else if (!reuseport || !sk2->sk_reuseport ||
> +                       } else if (!reuseport_ok ||
> +                                  !reuseport || !sk2->sk_reuseport ||
>                                    rcu_access_pointer(sk->sk_reuseport_cb) ||
>                                    (sk2->sk_state != TCP_TIME_WAIT &&
>                                     !uid_eq(uid, sock_i_uid(sk2)))) {
> --
> 2.17.2 (Apple Git-113)
>
