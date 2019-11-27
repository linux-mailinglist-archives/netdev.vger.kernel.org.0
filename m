Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE0AB10B2F9
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 17:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbfK0QJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 11:09:58 -0500
Received: from mail-vs1-f65.google.com ([209.85.217.65]:45080 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfK0QJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 11:09:58 -0500
Received: by mail-vs1-f65.google.com with SMTP id n9so15490667vsa.12
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 08:09:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jdd3GeiYktZKjSBlhokiKmUt1NBtO9atXLjizQILczs=;
        b=AdAkcufOxPLmmoNS3FqUKUrEE/86QWp/cDyb78rMLLRnmL7OJC/cpCtuRNT5ZVhxIE
         fyEQR1NtdFdH5nLguNSxtLWL14KBWRf17u6tFsJDEUA9AAlsuhdsUzcCFVjY+qO22gxD
         0Mu0aMLmI32UG5hqHLO7rglE4ddMZZTNSDJSBa3XmmBr/c6IJtxYfQwJSPjGvyHmVwkz
         SyXjUrCsR7icSNyBXEEEl4Y8ATMyEDGeejPX2xGYrbV2j7lELE6/1xlYAcMpxCvXgo3M
         11Sg+ybYnvhAePGeIXzwO+zISKGos5Xqi//q76dw+1wRRoUJMov1VScJNj+fmx/yCvN2
         B2lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jdd3GeiYktZKjSBlhokiKmUt1NBtO9atXLjizQILczs=;
        b=Tb2Mza5wnYMujt96OwAreWZliGF+LMoiphGhvHnDLYvx7S+WXRvZjm02J4kQIUpa7/
         7flE5ZngEl7Aba4TQkGvNXM5qKtVhX3h7IdqQKWfMuJnBuYhzwIen5/y0X93jstfhpuk
         BrWhbAhPh8tOJLLRJjdVTS5GphIfzoXZzO6K+lYNu6KVGqmdbZZRYuhExMEEUQaVffZu
         9g1T1C89flkbK06eo8H1BJC5b+aBEgCW39MFU7U89jukgWZfbd7CIs92aQnX5DTyiTPP
         DUn5AmxyiugzVkLqTiWByzDCnJLhpthuJBcGw2n30yU2AmyLJeSP2nUAPU2cG6LHxgMe
         rerQ==
X-Gm-Message-State: APjAAAW8Q6SpcWyy1OLuHZ8QVfngvT8j53da6QWNFSJZcphdzArPB6y0
        lSCUcU0rKfsnYvHcTe3l5rjE2XPLjqHVvN23TqRlUw==
X-Google-Smtp-Source: APXvYqw/snJjGohie9oeCh2cZj1D2XljJyh0xijOo/tpMm8NYn50tNYyrDpgyjhEub29M2oYRrsqRayHGPseU0IMVw8=
X-Received: by 2002:a67:ec82:: with SMTP id h2mr2355717vsp.96.1574870995658;
 Wed, 27 Nov 2019 08:09:55 -0800 (PST)
MIME-Version: 1.0
References: <CAJPywTJzpZAXGdgZLJ+y7G2JoQMyd_JG+G8kgG+xruVVmZD-OA@mail.gmail.com>
In-Reply-To: <CAJPywTJzpZAXGdgZLJ+y7G2JoQMyd_JG+G8kgG+xruVVmZD-OA@mail.gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Wed, 27 Nov 2019 08:09:44 -0800
Message-ID: <CANP3RGfAT199GyqWC7Wbr2983jO1vaJ1YJBSSXtFJmGJaY+wiQ@mail.gmail.com>
Subject: Re: Delayed source port allocation for connected UDP sockets
To:     Marek Majkowski <marek@cloudflare.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        network dev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 27, 2019 at 6:08 AM Marek Majkowski <marek@cloudflare.com> wrote:
>
> Morning,
>
> In my applications I need something like a connectx()[1] syscall. On
> Linux I can get quite far with using bind-before-connect and
> IP_BIND_ADDRESS_NO_PORT. One corner case is missing though.
>
> For various UDP applications I'm establishing connected sockets from
> specific 2-tuple. This is working fine with bind-before-connect, but
> in UDP it creates a slight race condition. It's possible the socket
> will receive packet from arbitrary source after bind():
>
> s = socket(SOCK_DGRAM)
> s.bind((192.0.2.1, 1703))
> # here be dragons
> s.connect((198.18.0.1, 58910))
>
> For the short amount of time after bind() and before connect(), the
> socket may receive packets from any peer. For situations when I don't
> need to specify source port, IP_BIND_ADDRESS_NO_PORT flag solves the
> issue. This code is fine:
>
> s = socket(SOCK_DGRAM)
> s.setsockopt(IP_BIND_ADDRESS_NO_PORT)
> s.bind((192.0.2.1, 0))
> s.connect((198.18.0.1, 58910))
>
> But the IP_BIND_ADDRESS_NO_PORT doesn't work when the source port is
> selected. It seems natural to expand the scope of
> IP_BIND_ADDRESS_NO_PORT flag. Perhaps this could be made to work:
>
> s = socket(SOCK_DGRAM)
> s.setsockopt(IP_BIND_ADDRESS_NO_PORT)
> s.bind((192.0.2.1, 1703))
> s.connect((198.18.0.1, 58910))
>
> I would like such code to delay the binding to port 1703 up until the
> connect(). IP_BIND_ADDRESS_NO_PORT only makes sense for connected
> sockets anyway. This raises a couple of questions though:
>
>  - IP_BIND_ADDRESS_NO_PORT name is confusing - we specify the port
> number in the bind!
>
>  - Where to store the source port in __inet_bind. Neither
> inet->inet_sport nor inet->inet_num seem like correct places to store
> the user-passed source port hint. The alternative is to introduce
> yet-another field onto inet_sock struct, but that is wasteful.
>
> Suggestions?
>
> Marek
>
> [1] https://www.unix.com/man-page/mojave/2/connectx/

attack BPF socket filter drop all, then bind, then connect, then replace it.
