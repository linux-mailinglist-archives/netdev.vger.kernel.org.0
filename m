Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2030BDA258
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 01:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729219AbfJPXfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 19:35:15 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:38663 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfJPXfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 19:35:15 -0400
Received: by mail-yw1-f68.google.com with SMTP id s6so217186ywe.5
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 16:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9b/ul4mbGS02kxiuVy/n7L8yiMFa/DUQYAEdbStYXZk=;
        b=pjftXlAfQqwIDfYSP7pQTuLFXzgr6pBUaaoiFSRyYcUcKtBKHY5T5PkgvbzM4HgC75
         EwBsVRrsfLY/Uu7YHKylx+E9I5Alx7akQD9DWo43J0gwh5cau8Vt/k+J3W0G/eZMr4f1
         8HvFA422sgBPQTJIS8TK84oKosQu9XG3+8DG79lRM2I+LGr4oW8Q6l/P1zhhJhyOdEuc
         Wg00wGN7RnT4slv+dpf0nj0EU/hkBV3q2w1dqWPutp+K70NWZq6HPA5RCYyLApkh0bv6
         J2uNF9nNYig7FE07np3r4mCCbWfVxfR/604g1EKsDtWgP3J9adcNZGG/qRraooB6cyid
         0DmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9b/ul4mbGS02kxiuVy/n7L8yiMFa/DUQYAEdbStYXZk=;
        b=Ge9jiENzIK9DAyToLBq3wQmIxi3El/pQdC+n1MGQBD/B2gmlvyHmtLYWV9eZDasFKv
         SHCOiNmxg4/5OEZmtlfxd/zt1leb6u8Fi0fOGrtEL71Svwis2109qHUVtIzpYVgmQW6f
         Mym87MM6loM0+ODrPaMV9KsJcf7ZfEBfWO3YXU1A/sTZ5fe4C3HtoYPWPK0GD51SCn4N
         kmh9dnnBHZiBvDZ2Sz1oiEVQhqmPP+YwzRz4KNY6oycOFh2tWtDJe+r2AQxm5K0OdefG
         LWqpTIdGXvdfCgK/pd1Z/G+ywODAOu6HrT0gsYUg9ZyGzBSnximUz2UEgcszz9O7AZ27
         oOOQ==
X-Gm-Message-State: APjAAAWApAvDcMej3Z1pC1LeXSAACsakiMsvmhZ41hM0ANo0Op0JUNeq
        JBCrrxEF43/aGpqxLewnrujL6aRma2Ulfi95t2WTmA==
X-Google-Smtp-Source: APXvYqwRe36J4EEAYNc6zevxBKOlyb/+DaLehRShj+Mu/VMPhx5KjQ3NX39TqSunH8o3mP2Ej4jbn6Ch32JSMymHV3Q=
X-Received: by 2002:a81:8981:: with SMTP id z123mr649796ywf.92.1571268913833;
 Wed, 16 Oct 2019 16:35:13 -0700 (PDT)
MIME-Version: 1.0
References: <20191014130438.163688-1-edumazet@google.com> <8142.1571268276@warthog.procyon.org.uk>
In-Reply-To: <8142.1571268276@warthog.procyon.org.uk>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 16 Oct 2019 16:35:01 -0700
Message-ID: <CANn89iL9t78ta1JMecG7b8A+mNytfBy4_wXXYRD2Rosz8iFpVg@mail.gmail.com>
Subject: Re: [PATCH net] rxrpc: use rcu protection while reading sk->sk_user_data
To:     David Howells <dhowells@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 4:24 PM David Howells <dhowells@redhat.com> wrote:
>
> Eric Dumazet <edumazet@google.com> wrote:
>
> > We need to extend the rcu_read_lock() section in rxrpc_error_report()
> > and use rcu_dereference_sk_user_data() instead of plain access
> > to sk->sk_user_data to make sure all rules are respected.
>
> Should I take it that the caller won't be guaranteed to be holding the RCU
> read lock?
>
> Looking at __udp4_lib_err(), that calls __udp4_lib_err_encap(), which calls
> __udp4_lib_err_encap_no_sk(), which should throw a warning if the RCU read
> lock is not held.
>
> Similarly, icmp_socket_deliver() and icmpv6_notify() should also throw a
> warning before calling ->err_handler().
>
> Does that mean something further up the CPU stack is going to be holding the
> RCU read lock?

Note  that before my patch, the code had a rcu_read_lock()/rcu_read_unlock(),
so I only extended it.

I am not sure that all callers already have rcu_read_lock()  held, I
prefer leaving this matter for net-next

>
> David
