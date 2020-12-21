Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99E572DFB76
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 12:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbgLULX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 06:23:57 -0500
Received: from mail.zx2c4.com ([192.95.5.64]:52339 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725791AbgLULX5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 06:23:57 -0500
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 217f8c9d
        for <netdev@vger.kernel.org>;
        Mon, 21 Dec 2020 11:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=vLtA2Gd7PORSyFHTFfRhJp635lg=; b=CZ00WV
        vHbJDSOdPiIu78xqWKqcqXZOt5i4zVpa1AGEjoryHgkrWgmqWKN0B7wW57Fcvsnx
        0rbMblN5iBlrloBdrtURbp06NhOXjwpKx2XW/8ihj8w2AcLUBZM5vnUQnO9INGR8
        fG5JANIeZimfsv/ggZYE9KZSQuR4ZmbixgI/B6WxS5zmKdK/QyPf8Dbg3Gz69FL/
        gABLEzGPErC4ATnkzzXPKgNFUU6I1A662T470cs9YqMv6iXeNmqzpWO5HihC8DCY
        edPb44+lpUskAfZuYMAAVxPezyeOy9gpU4QQ1q05oMfd6e7iYgfS3DG+lzCsuixy
        D8SWE27a+WdLMg4g==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 95e1d018 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Mon, 21 Dec 2020 11:15:00 +0000 (UTC)
Received: by mail-yb1-f173.google.com with SMTP id a16so8511004ybh.5
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 03:23:15 -0800 (PST)
X-Gm-Message-State: AOAM533yUdx9iIv4QgFk3wgqX4+N9pXXXlOxig/QSkhOrGNRjYBHkZlD
        vnzEvvJWK9BKL7AYdV3eNkc9dAA56BTkUgk2dvk=
X-Google-Smtp-Source: ABdhPJw7QxDqH0FnueYorz9qIvRY9lNzFtlxIxVU0vKxQp3hSwPVzLIyvFhvZOnHHrQTXfgmk8U8ANWa+viklgn62/U=
X-Received: by 2002:a25:bb81:: with SMTP id y1mr22197534ybg.456.1608549795129;
 Mon, 21 Dec 2020 03:23:15 -0800 (PST)
MIME-Version: 1.0
References: <000000000000e13e2905b6e830bb@google.com> <CAHmME9qwbB7kbD=1sg_81=82vO07XMV7GyqBcCoC=zwM-v47HQ@mail.gmail.com>
 <CACT4Y+ac8oFk1Sink0a6VLUiCENTOXgzqmkuHgQLcS2HhJeq=g@mail.gmail.com>
In-Reply-To: <CACT4Y+ac8oFk1Sink0a6VLUiCENTOXgzqmkuHgQLcS2HhJeq=g@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 21 Dec 2020 12:23:04 +0100
X-Gmail-Original-Message-ID: <CAHmME9q0HMz+nERjoT-TQ8_6bcAFUNVHDEeXQAennUrrifKESw@mail.gmail.com>
Message-ID: <CAHmME9q0HMz+nERjoT-TQ8_6bcAFUNVHDEeXQAennUrrifKESw@mail.gmail.com>
Subject: Re: UBSAN: object-size-mismatch in wg_xmit
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Kees Cook <keescook@google.com>, Netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dmitry,

On Mon, Dec 21, 2020 at 10:14 AM Dmitry Vyukov <dvyukov@google.com> wrote:
> Hi Jason,
>
> Thanks for looking into this.
>
> Reading clang docs for ubsan:
>
> https://clang.llvm.org/docs/UndefinedBehaviorSanitizer.html
> -fsanitize=object-size: An attempt to potentially use bytes which the
> optimizer can determine are not part of the object being accessed.
> This will also detect some types of undefined behavior that may not
> directly access memory, but are provably incorrect given the size of
> the objects involved, such as invalid downcasts and calling methods on
> invalid pointers. These checks are made in terms of
> __builtin_object_size, and consequently may be able to detect more
> problems at higher optimization levels.
>
> From skimming though your description this seems to fall into
> "provably incorrect given the size of the objects involved".
> I guess it's one of these cases which trigger undefined behavior and
> compiler can e.g. remove all of this code assuming it will be never
> called at runtime and any branches leading to it will always branch in
> other directions, or something.

Right that sort of makes sense, and I can imagine that in more general
cases the struct casting could lead to UB. But what has me scratching
my head is that syzbot couldn't reproduce. The cast happens every
time. What about that one time was special? Did the address happen to
fall on the border of a mapping? Is UBSAN non-deterministic as an
optimization? Or is there actually some mysterious UaF happening with
my usage of skbs that I shouldn't overlook?

Jason
