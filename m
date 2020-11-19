Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A14A2B9BA8
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 20:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727445AbgKSTpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 14:45:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726644AbgKSTpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 14:45:42 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B935BC0613D4
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 11:45:41 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id l12so6479501ilo.1
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 11:45:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0KGIu9QRLsnQRLw4m01WgKEPBTZoDdSdeLkEBZ2tnKA=;
        b=wFtV9CzTOhb0ygSMdv7pxPCcDzW5ecgnSj9bV0GLsBaHBjOjZH+dQAUZHvfAN5nr9z
         jhy8r/GaWxtSdwlC8C9jvnq8lACIvAvInSLgqr835nKCGRMjyNohDU9HkVvi9tjnrLRm
         zfJVvv39fRmXm8+uGVjYwjZokiwhlRLPzjfbNbMKt6joieaJa+9Z1XMuZASwugDJy2fo
         F7wv8MN0LgZEKCkTcB85WG9euTP1j3OoSpcz+ZaHdQ9ZtwIklMULl3LzLe2PXlSK2v9G
         PVhp0ut2Zm+iu6KHy5k+r6ALFj9ve6zGgRTnkvvEGZxmIbKZSSnHdMCU2xvzf02TMZnn
         VBQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0KGIu9QRLsnQRLw4m01WgKEPBTZoDdSdeLkEBZ2tnKA=;
        b=NBxyV5OSwXviGn1mM4fvbp9VjIxZOEFrwBY466BO37K9HhppmwARccx3dYghD44CSB
         iSimmmtelhDCFbnx8KoREsjgqvpEgNaivNVreTY8fpvoEKuLWU9nKEbH8wc/X6nd2Q21
         DhaWGVLqL3w66nhni5Z45PkbWlz/xFpp+j5Dn2KigLuduYg3bpwCiCFovK4s2es9cDbg
         pg1/jZnO1BZyUMKgQMMNAdhkkMmr6io7DEm+JhDPOFmbotZifOf9CjAK6ylhDgTJDSQE
         xVymnDisj3/rvZ5QjRDoGnf/8BTiOmiw7sjPPHtOEVOxuSfvplO7udeyY5o4ERZcvyG9
         0vQw==
X-Gm-Message-State: AOAM5315MesJquzq/SpSnR5Ax28iL8Y+Vx/mhA+50ZIyTrc3bIMfl8su
        3aTj/j5BJcLN8r0EoIrTM49z12dy0uaSwrYjpPAusQ==
X-Google-Smtp-Source: ABdhPJxlB8Q7lqvk727IIAPd6mMOTst+FmA6fjvZmwfS5aUWIM9610IC4XHnlI9OG3hUQJVhY76qjm1q6yF39QXYBGo=
X-Received: by 2002:a92:358e:: with SMTP id c14mr6919106ilf.69.1605815140718;
 Thu, 19 Nov 2020 11:45:40 -0800 (PST)
MIME-Version: 1.0
References: <20201119192442.GA820741@rdias-suse-pc.lan>
In-Reply-To: <20201119192442.GA820741@rdias-suse-pc.lan>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 19 Nov 2020 20:45:29 +0100
Message-ID: <CANn89i+WL9G0vsr4HYJc==g0R+=cRPP7MkVZb120M5S4Q+NLbA@mail.gmail.com>
Subject: Re: [PATCH v7] tcp: fix race condition when creating child sockets
 from syncookies
To:     Ricardo Dias <rdias@singlestore.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 8:24 PM Ricardo Dias <rdias@singlestore.com> wrote:
>
> When the TCP stack is in SYN flood mode, the server child socket is
> created from the SYN cookie received in a TCP packet with the ACK flag
> set.
>
> The child socket is created when the server receives the first TCP
> packet with a valid SYN cookie from the client. Usually, this packet
> corresponds to the final step of the TCP 3-way handshake, the ACK
> packet. But is also possible to receive a valid SYN cookie from the
> first TCP data packet sent by the client, and thus create a child socket
> from that SYN cookie.
>
> Since a client socket is ready to send data as soon as it receives the
> SYN+ACK packet from the server, the client can send the ACK packet (sent
> by the TCP stack code), and the first data packet (sent by the userspace
> program) almost at the same time, and thus the server will equally
> receive the two TCP packets with valid SYN cookies almost at the same
> instant.
>
> When such event happens, the TCP stack code has a race condition that
> occurs between the momement a lookup is done to the established
> connections hashtable to check for the existence of a connection for the
> same client, and the moment that the child socket is added to the
> established connections hashtable. As a consequence, this race condition
> can lead to a situation where we add two child sockets to the
> established connections hashtable and deliver two sockets to the
> userspace program to the same client.
>
> This patch fixes the race condition by checking if an existing child
> socket exists for the same client when we are adding the second child
> socket to the established connections socket. If an existing child
> socket exists, we return that socket and use it to process the TCP
> packet received, and discard the second child socket to the same client.
>
> Signed-off-by: Ricardo Dias <rdias@singlestore.com>
> ---
> v7 (2020-11-19):
>   * Changed the approach to re-use the first (existing) socket created
>     from thge syncookie. Instead of returning the existing socket in
>     tcp_(v4|v6)_syn_recv_sock and continue the protocol state machine
>     execution, tcp_(v4|v6)_syn_recv_sock signals that already exists a
>     socket, and tells tcp_(v4|v6)_rcv to lookup the socket again in the
>     established connections table.
>     This new approach fixes the errors reported by Eric for the previous
>     version of the patch.
>   * Also fixes the memory leaks by making sure that the newly created
>     socket in syn_recv_sock is destroyed in case an already existing
>     socket exists.

I think this is going too far. Your patch is too complex/risky, and
will be hard to backport to old kernels, because TCP stack has changed
a lot.

Alternative approach would be to detect the race and simply drop the
packet that lost the battle.
