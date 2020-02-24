Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A24CC169F41
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 08:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgBXH3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 02:29:18 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:44071 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbgBXH3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 02:29:17 -0500
Received: by mail-yw1-f65.google.com with SMTP id t141so4788680ywc.11
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 23:29:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pu7YZUk9S4E/pNGkKq9v6WlWWKovjGT+ogGtMRUpTlY=;
        b=cT1aVW9aEmNffyJsbSnpD1pePBSTJmnbrzeS1G1xYMa+f/EI6Ix7TCrDA2k7COPesT
         nCNnqeSTzMOzj9Dop4WbLhHHv4N6u/cpIlGFjewYNHHviMvEopaL5JfcJWNiNYOy828a
         5q0KS5TdQWwz9hJAk7r952F3mLit5GROR1edHOg1LGu+yE8oWQ3LB3TLurElJ+N/IUhS
         yJOqnGyl9XxLMZrwR8wmW/j6Hkht8FySi7RJe6fJtKM5dYhMdn9bTuo8r9THb3skjq7K
         /3mYHGC5MFfzeDS085t/m1H8wI9bVvbmxd3lRfq7AH9PkcpWJXQWmBQKz0NmH5Zm2SVy
         CC+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pu7YZUk9S4E/pNGkKq9v6WlWWKovjGT+ogGtMRUpTlY=;
        b=UNxTfDOt/Bmm/ybnoBKeTw2ezihnXJPEXbQ+CDhfDTCKjHkAKKU/YY2FdDbaGtR9o0
         6UfcKTteOmuaSF16O9FKPuscOc0y4qdqFEi9yWpbSvjW0QL2qtZVMHFjYCpJEd+1UjXi
         RRBKolWyLuv8GyEPCoZZp6HfG2RWcXnEd+fYMjXYpHgmjd3riDgzyfBwms+VWImVQVsX
         KyeEEK4kyYWWJd/iOsaPIdmhIgUv3wVU7OiVJa2c/J/75xL0NE5MnsWrg4HNz4iD7P+A
         TEMD2lcYbC1JdDJiuaE8krJaLNKCpRSM2ZIrN2ZRoW4b9tQtzCnnrBp8C0Dn6Y1edpSO
         +Dvw==
X-Gm-Message-State: APjAAAWrP1StOHkf927pYDkb/lJBtjZGUVY49VQtFDyEfEndKGze9H8y
        jZdN7M8R1RLtqqFbyMM4nRElP+dQMvGZxfa6Ed7flg==
X-Google-Smtp-Source: APXvYqxZIwuqqBEDmmlfQUkUBgpzYL2C3CpS2lE4a1qMVtMJH7Paj2i9si0t8xcdBW8R0TX6IMVC8K2dWXRjAM3RHXU=
X-Received: by 2002:a81:3a06:: with SMTP id h6mr39722556ywa.170.1582529356484;
 Sun, 23 Feb 2020 23:29:16 -0800 (PST)
MIME-Version: 1.0
References: <20200222010456.40635-1-shakeelb@google.com>
In-Reply-To: <20200222010456.40635-1-shakeelb@google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sun, 23 Feb 2020 23:29:04 -0800
Message-ID: <CANn89iJ2CWSeLp-+mfBLWKNdS2vw=r1iLFtWhyzav_SYcjFrAg@mail.gmail.com>
Subject: Re: [PATCH] net: memcg: late association of sock to memcg
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        netdev <netdev@vger.kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        linux-mm <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 21, 2020 at 5:05 PM Shakeel Butt <shakeelb@google.com> wrote:
>
> If a TCP socket is allocated in IRQ context or cloned from unassociated
> (i.e. not associated to a memcg) in IRQ context then it will remain
> unassociated for its whole life. Almost half of the TCPs created on the
> system are created in IRQ context, so, memory used by suck sockets will
> not be accounted by the memcg.
>
> This issue is more widespread in cgroup v1 where network memory
> accounting is opt-in but it can happen in cgroup v2 if the source socket
> for the cloning was created in root memcg.
>
> To fix the issue, just do the late association of the unassociated
> sockets at accept() time in the process context and then force charge
> the memory buffer already reserved by the socket.
>
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> ---
>  net/ipv4/inet_connection_sock.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index a4db79b1b643..df9c8ef024a2 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -482,6 +482,13 @@ struct sock *inet_csk_accept(struct sock *sk, int flags, int *err, bool kern)
>                 }
>                 spin_unlock_bh(&queue->fastopenq.lock);
>         }
> +
> +       if (mem_cgroup_sockets_enabled && !newsk->sk_memcg) {
> +               mem_cgroup_sk_alloc(newsk);
> +               if (newsk->sk_memcg)
> +                       mem_cgroup_charge_skmem(newsk->sk_memcg,
> +                                       sk_mem_pages(newsk->sk_forward_alloc));

I am not sure what you  are trying to do here.

sk->sk_forward_alloc is not the total amount of memory used by a TCP socket.
It is only some part that has been reserved, but not yet consumed.

For example, every skb that has been stored in TCP receive queue or
out-of-order queue might have
used memory.

I guess that if we assume that  a not yet accepted socket can not have
any outstanding data in its transmit queue,
you need to use sk->sk_rmem_alloc as well.

To test this patch, make sure to add a delay before accept(), so that
2MB worth of data can be queued before accept() happens.

Thanks.
