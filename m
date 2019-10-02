Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96889C4968
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 10:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbfJBIX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 04:23:28 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54448 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbfJBIX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 04:23:27 -0400
Received: by mail-wm1-f68.google.com with SMTP id p7so6138140wmp.4;
        Wed, 02 Oct 2019 01:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fjdNl+PoTY9jdW12WzpwvTBCSOavhiTQp0zXpkH751c=;
        b=T/mqmM587yOS6XkKYkloyc4yPJFeu0xgXyu6xm+JQO60F6y+5o+DFfIiy0Th0kDP+m
         bYSUfIaUQY0FLq6Pig7JlEXOMcznpOv08Dy5LvhtFQYSckW068NG5NjDakQ0qE5HRj+u
         OTpBrFcuxMGsZhQ8zjU+ziJlVRqVzQ+HepSePHTwUtBrddyKQDTNVfx+SiC7Tww5tGm/
         XeUZ4GpUGldZwz9nC2MDbq8RQN6dd+5XPZJ/YSoWKc+6i6kgf13KLg6N8IyMUFLa3DdN
         B796kUBeRpVyXdk21yoKL/nh6dseiqgnlsurPOCRs7/SGi1V8WAWw/HyiwzckQbEH7Pd
         +FyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fjdNl+PoTY9jdW12WzpwvTBCSOavhiTQp0zXpkH751c=;
        b=t1TaZScoD5uuOvRnhjo6F/W8UW897T5OGnHCHM1146X28HOB6uB7LQdDIVtUg7K7gX
         BlzSikucAoTY5PdufFrUcDHvZO9EN6GzUhqNNsXMRxmogO0sg9k1F1vdPro8HIfmxk56
         Fe16iZriU7LaTYLKZB/WoqP27gl35P+M5WOwE49d5ZCHy98ocnkoFY0iYNSjT0vXSiy8
         j2HAI1rR8hLN1rPXq68A8Jyp+IldPESZuJ7yZvyy72LF6fX/Y9hWknSI4ogjnZXXwGQp
         2KrHi1R1Vx0r1mzkAQQlyKhocTeDY+5qYhMo7qKgqHIAqaARWlIItarJFdDsK8efXjwg
         fZtQ==
X-Gm-Message-State: APjAAAWVvqybXYxRy8SJzRrczFgmlo8Fw35VApPdvL4NlAz3Wwu0FNIQ
        /fLudMxb2B2audwLZk9HOSONLX6J0yZtFHiAbzPuyEw+
X-Google-Smtp-Source: APXvYqzlRf65qhU4kTSHqIBi40tevjd+qK5g3NR32ui50naslg4CkhfAeOuBw3nDmmOtAYHmmwPA1e/2KKItWyrGQWk=
X-Received: by 2002:a1c:a74f:: with SMTP id q76mr1887806wme.16.1570004603664;
 Wed, 02 Oct 2019 01:23:23 -0700 (PDT)
MIME-Version: 1.0
References: <acd60f4797143dc6e9817b3dce38e1408caf65e5.1569849018.git.lucien.xin@gmail.com>
 <20191002010356.GG3499@localhost.localdomain>
In-Reply-To: <20191002010356.GG3499@localhost.localdomain>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 2 Oct 2019 16:23:52 +0800
Message-ID: <CADvbK_ctLG+vnhmWwN=cWmZV7FgZreVRmoU+23PExdk=goF8cQ@mail.gmail.com>
Subject: Re: [PATCH net] sctp: set newsk sk_socket before processing listening
 sk backlog
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem <davem@davemloft.net>, Neil Horman <nhorman@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 2, 2019 at 9:04 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Mon, Sep 30, 2019 at 09:10:18PM +0800, Xin Long wrote:
> > This patch is to fix a NULL-ptr deref crash in selinux_sctp_bind_connect:
> >
> >   [...] kasan: GPF could be caused by NULL-ptr deref or user memory access
> >   [...] RIP: 0010:selinux_sctp_bind_connect+0x16a/0x230
> >   [...] Call Trace:
> >   [...]  security_sctp_bind_connect+0x58/0x90
> >   [...]  sctp_process_asconf+0xa52/0xfd0 [sctp]
> >   [...]  sctp_sf_do_asconf+0x782/0x980 [sctp]
> >   [...]  sctp_do_sm+0x139/0x520 [sctp]
> >   [...]  sctp_assoc_bh_rcv+0x284/0x5c0 [sctp]
> >   [...]  sctp_backlog_rcv+0x45f/0x880 [sctp]
> >   [...]  __release_sock+0x120/0x370
> >   [...]  release_sock+0x4f/0x180
> >   [...]  sctp_accept+0x3f9/0x5a0 [sctp]
> >   [...]  inet_accept+0xe7/0x6f0
> >
> > It was caused by that the 'newsk' sk_socket was not set before going to
> > security sctp hook when doing accept() on a tcp-type socket:
> >
> >   inet_accept()->
> >     sctp_accept():
> >       lock_sock():
> >           lock listening 'sk'
> >                                           do_softirq():
> >                                             sctp_rcv():  <-- [1]
> >                                                 asconf chunk arrived and
> >                                                 enqueued in 'sk' backlog
> >       sctp_sock_migrate():
> >           set asoc's sk to 'newsk'
> >       release_sock():
> >           sctp_backlog_rcv():
> >             lock 'newsk'
> >             sctp_process_asconf()  <-- [2]
> >             unlock 'newsk'
> >     sock_graft():
> >         set sk_socket  <-- [3]
> >
> > As it shows, at [1] the asconf chunk would be put into the listening 'sk'
> > backlog, as accept() was holding its sock lock. Then at [2] asconf would
> > get processed with 'newsk' as asoc's sk had been set to 'newsk'. However,
> > 'newsk' sk_socket is not set until [3], while selinux_sctp_bind_connect()
> > would deref it, then kernel crashed.
>
> Note that sctp will migrate such incoming chunks from sk to newsk in
> sctp_rcv() if they arrived after the mass-migration performed at
> sctp_sock_migrate().
>
> That said, did you explore changing inet_accept() so that
> sk1->sk_prot->accept() would return sk2 still/already locked?
> That would be enough to block [2] from happening as then it would be
> queued on newsk backlog this time and avoid nearly duplicating
> inet_accept(). (too bad for this chunk, hit 2 backlogs..)
We don't have to bother inet_accept() for it. I had this one below,
and I was just thinking the locks order doesn't look nice. Do you
think this is more acceptable?

@@ -4963,15 +4963,19 @@ static struct sock *sctp_accept(struct sock
*sk, int flags, int *err, bool kern)
         * asoc to the newsk.
         */
        error = sctp_sock_migrate(sk, newsk, asoc, SCTP_SOCKET_TCP);
-       if (error) {
-               sk_common_release(newsk);
-               newsk = NULL;
+       if (!error) {
+               lock_sock_nested(newsk, SINGLE_DEPTH_NESTING);
+               release_sock(sk);
+               release_sock(newsk);
+               *err = error;
+
+               return newsk;
        }

 out:
        release_sock(sk);
        *err = error;
-       return newsk;
+       return NULL;
 }

>
> AFAICT TCP code would be fine with such change. Didn't check other
> protocols.
>
