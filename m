Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2284031AA70
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 09:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbhBMIFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 03:05:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbhBMIFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 03:05:48 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5414AC061574
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 00:05:08 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id b10so1896911ybn.3
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 00:05:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q5eh0LKvqpuDnxQ4up+ewY7OXRt4kEg9WvDIZGDMrYc=;
        b=muJo5VqdqN7xzqC58IT4Ts9Srwe4Q++aAhqpfPJOKkO5FRKCTG0DB0CArEfkBXEyGF
         yziNzzGA0hhTC/0eWoqrpcqoH3Ax9JUKvTNpjPKvscWPmjtN/GrkiaYSpjhmbFYa+CU6
         iMjIKTRIZiHagz2+bNs572zgrVSsXCjDj1/h0d1Vbtc6UWrysy4ZCPc0KWdE16B6Y3Rs
         ljhaphuu0P+kzesPGb1r3I4Eb8ojkMB3QiWO9nQ7szCjgCgo7wP7VuyUEpKmhkTBBPdO
         0rmYRxqpNshuSzrdA1NeaCkpnD5aXlhbZN/tJvolWXlQSkVpT8WyBnOc6QA7nPI0dvEN
         UWrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q5eh0LKvqpuDnxQ4up+ewY7OXRt4kEg9WvDIZGDMrYc=;
        b=FfPH7NPMc0S2jF57dkiDo3y0gIywxBDZxvHRzVjgNWpozet74Cfa2N8Y4jVX15qtTG
         1ZMyKvhcyqOdsOEyge4RJ9Zq3hOKFu5GztrYC946xjG5k+H0+nHsuKJN/t4Cken2pBOr
         q+J4c9K21v2nPcDQ9ZaS8/TflV3UeCWY7zE9+IGOp7sNUSWNIHGn29d48HoQDithnZ88
         cU6gSAJTbIcVenJoB+Q08+zx8wZ/+YYtacANwVNM6gf1rTM129PfH0W67qGZ5BSA3nwQ
         DjYRXzrU2MN1FnUJQUq1Bi3UxP/6PVRwEHUM/M6hpwees5scaS5rI/Pd3aLGloxvjfeE
         VJGQ==
X-Gm-Message-State: AOAM533VO26+ZfWrgHfQSeaOcefX1Kzt2m722JP3t2XPUqLntw/cmt5d
        ARkEl+y/i8ZzibJbPd63oUBHpCoXMI0mhZ2Nu7nNZA==
X-Google-Smtp-Source: ABdhPJzXQhrIuJy7TlXXd/zdusFR2DsLIFWX0jgNluvIK5xuJxdbCalrq/07m8c7JwC+i+Fs3CRyUzcDmkUodxCq+yw=
X-Received: by 2002:a25:fc3:: with SMTP id 186mr9127658ybp.452.1613203506921;
 Sat, 13 Feb 2021 00:05:06 -0800 (PST)
MIME-Version: 1.0
References: <20210212232214.2869897-1-eric.dumazet@gmail.com>
 <20210212232214.2869897-3-eric.dumazet@gmail.com> <CAEA6p_A0g-7WMfyQbw55wdAKkFkEbW2A-XwTNziP9XyD3MjmCA@mail.gmail.com>
 <CANn89iJ-Y9avDrs3Jbx93J8zwMFfrY8Pq1LAL6tYWDvtcfdWKg@mail.gmail.com>
In-Reply-To: <CANn89iJ-Y9avDrs3Jbx93J8zwMFfrY8Pq1LAL6tYWDvtcfdWKg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 13 Feb 2021 09:04:55 +0100
Message-ID: <CANn89iK7U69XKZVFS2PXUSZhck5xaRE-hkxVe7Q1pbaE8m1cZw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] tcp: factorize logic into tcp_epollin_ready()
To:     Wei Wang <weiwan@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Arjun Roy <arjunroy@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 13, 2021 at 8:50 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Sat, Feb 13, 2021 at 1:30 AM Wei Wang <weiwan@google.com> wrote:
> >
>
> > >  void tcp_data_ready(struct sock *sk)
> > >  {
> > > -       const struct tcp_sock *tp = tcp_sk(sk);
> > > -       int avail = tp->rcv_nxt - tp->copied_seq;
> > > -
> > > -       if (avail < sk->sk_rcvlowat && !tcp_rmem_pressure(sk) &&
> > > -           !sock_flag(sk, SOCK_DONE) &&
> >
> > Seems "!sock_flag(sk, SOCK_DONE)" is not checked in
> > tcp_epollin_read(). Does it matter?
> >
>
>
> Yes, probably, good catch.
>
> Not sure where tcp_poll() gets this, I have to double check.

It gets the info from sk->sk_hutdown & RCV_SHUTDOWN

tcp_find() sets both sk->sk_shutdown |= RCV_SHUTDOWN and
sock_set_flag(sk, SOCK_DONE);

This seems to suggest tcp_fin() could call sk->sk_data_ready() so that
we do not have to test for this unlikely condition in tcp_data_ready()
