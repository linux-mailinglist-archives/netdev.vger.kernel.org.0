Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A858A245867
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 17:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728551AbgHPPgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 11:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726407AbgHPPgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 11:36:13 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8ACBC061786
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 08:36:12 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id b14so12887954qkn.4
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 08:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b56DIDSCCqSDUz/uzUz7lQYGowdXao8cMoz74W2Vp+A=;
        b=cytAt91qfvsIIqALSY3Sq5YGJQwUDZMHl9xJVy+aR1chYbKLhVlEW5gMww8Fsj7Pe9
         dT+CA74v1O8uVX6jNfYxokzIGWMIlW5OwmI8BtTxc4XioKRsimjC1Rb3wluruytRpAUV
         nNSK4NTEEqRAsH+CQL+q9qSaBTdRHlCtel9EoxD+mifQp6iXO6JhebQlKwKdWsbnUGQK
         cptb0E44J9/vqQsRG5NtUDtCl7gYfAt0PJyV+hNv5QIimFALo/sbsuteTOKCkt7iJgEq
         LJre5aMgClBqTOifHMpD9Z3NUhhFzTT/3vqjXHBI8Qec7vx8eBfQ5yruuS8Aa/5Dy535
         s6wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b56DIDSCCqSDUz/uzUz7lQYGowdXao8cMoz74W2Vp+A=;
        b=BhD7ZTJyUaRPxs15njIgC7Yde/E3pTTtSUHF4jgZuux/nCIkB4hXKMd6KaRxk3VkGJ
         4cvar6q4q5E/U+dlOsLPJFpvMLwVrNQwdhQEBIWxTOBMMjFk1vikchTsGtXeOg3URNjS
         yslHlIn4ds5Y5LOBTP/EZUbSTiaVjHTFT1xRDy485/CblK6c90hGIDdYA71RgxNyzTrE
         sfq/9yzIJpkIcP+R3MvJoux3LM3Iw6xQ/60miHcvUzsMC/80AeoM2oBojB9BnSkSo8tD
         /jXleWm8v2LxrTQeeyyzW6I8RXSB3m/9U28U7XYDnAcuFatsOU1Sz1jQBelXqw81UJEu
         rOXw==
X-Gm-Message-State: AOAM532KNCHRdW0QP38NEMrrYtzuBOIecUxz/2wg5OlG+bBSRkTgCpXC
        Kn3RhgrXGrH9HfU7KCCO1hYZVsGT3rsZYlGv32CHrQ==
X-Google-Smtp-Source: ABdhPJzTk2OH/pkDHhLZH40+pQBa5PfUAJJf6R0K8mEMsjxwcxzX/ayZtBEiRsA/49DNSAy2Pf87K3S0lRVyVixwW7U=
X-Received: by 2002:a05:620a:c07:: with SMTP id l7mr9799747qki.250.1597592171145;
 Sun, 16 Aug 2020 08:36:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200814101000.2463612-1-fazilyildiran@gmail.com> <20200814.135526.430805159179452727.davem@davemloft.net>
In-Reply-To: <20200814.135526.430805159179452727.davem@davemloft.net>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Sun, 16 Aug 2020 17:36:00 +0200
Message-ID: <CACT4Y+aTaB5YVYjMXSnonLmocO1FWs06DaOwHCiuweGD93M0kA@mail.gmail.com>
Subject: Re: [PATCH] net: qrtr: fix usage of idr in port assignment to socket
To:     David Miller <davem@davemloft.net>
Cc:     =?UTF-8?B?TmVjaXAgRi4gWcSxbGTEsXJhbg==?= <fazilyildiran@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        courtney.cavin@sonymobile.com,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Marco Elver <elver@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Alexander Potapenko <glider@google.com>,
        Necip Fazil Yildiran <necip@google.com>,
        syzbot+f31428628ef672716ea8@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 14, 2020 at 10:55 PM David Miller <davem@davemloft.net> wrote:
>
> From: Necip Fazil Yildiran <fazilyildiran@gmail.com>
> Date: Fri, 14 Aug 2020 10:10:00 +0000
>
> > diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
> > index b4c0db0b7d31..52d0707df776 100644
> > --- a/net/qrtr/qrtr.c
> > +++ b/net/qrtr/qrtr.c
> > @@ -693,22 +693,24 @@ static void qrtr_port_remove(struct qrtr_sock *ipc)
> >  static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
> >  {
> >       int rc;
> > +     u32 min_port;
>
> Please use reverse christmas tree ordering for local variables.

If Dave's comment is fixed:

Reviewed-by: Dmitry Vyukov <dvyukov@google.com>

(add this tag to the v2 of this patch).

Just in case: "reverse christmas tree" is when variable declarations
are sorted by line length (longest first).
