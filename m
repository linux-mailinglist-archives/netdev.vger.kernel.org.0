Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2539122DD3B
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 10:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgGZI3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 04:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgGZI3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 04:29:04 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F263CC0619D2
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 01:29:03 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id b30so7354930lfj.12
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 01:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=habets.se; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=m0whVgZx5OOnO0y46Ck+2+18KwGmvi48a18Wcw+I9v8=;
        b=JCaM0CN5GuiWS2snfbbf6DFx71ZGDjQtlGNpqY7UjUDYNJR2wbWaxD/UvmlF+g6pS5
         hAsinDLEfXmdWcPLDY9jMtyV+PPrV97BQJ1qNWkldLJM66FolAERbs6C/U9kkPe9wB0E
         VobqcsMBz5TLHfuhwVGXQoBt07wDsR/v3O3Cg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=m0whVgZx5OOnO0y46Ck+2+18KwGmvi48a18Wcw+I9v8=;
        b=VhF0SNnpYQXuE2YnfGCPjfYPKa7MNvu+25YMfzbXS4zKllCA5HGs8uJGFBdhbc0Cl6
         LfLaE8EdQ+E0usb5Us/DWUkqw/27QPpLqpaMhvhL8Ki1yxe3ZT1nfecHU9M/Mx9gce5d
         O9+PL38LErh9cM2Su6kMi00YYAC9/Cw6HXFFTrR57OgJdKsxkL5wkYzhI/PZiiWYmZv6
         xwX+XgJ6GA02ArI290gQPMuQ+Vw0TG3oGU2oM5y931HFUO6NpVejhb/Gt62LL/YsdUJ/
         mICEo4Rflbi5I2yxNFYl4n7ZCRUuC7McgD4nI7I93gt3NSkKBRjcsMemZcV4BfRrONJt
         8apQ==
X-Gm-Message-State: AOAM531eZfe8LELC7M/VxK/2NTke5kiiuAm65MIaVLmefkB6We0QD3UE
        UOwI5WKGBVWCAp7QrhJ4+qr0ZViHosiSsM7IzBhEpw==
X-Google-Smtp-Source: ABdhPJyp0QIIu3jUR3Yv0HI9ktvXDZF2QudTjq27LjTqTJj73KUyu8Rx1p0ANY5TUCm0IasUuVyGqLZJj1g+P3qlWZY=
X-Received: by 2002:ac2:5991:: with SMTP id w17mr9123416lfn.153.1595752140637;
 Sun, 26 Jul 2020 01:29:00 -0700 (PDT)
Received: from 195210475306 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 26 Jul 2020 04:28:59 -0400
MIME-Version: 1.0
From:   thomas@habets.se
Date:   Sun, 26 Jul 2020 04:28:59 -0400
Message-ID: <CA+kHd+dHno0QXFCX+BG8CpdaZqkC0k8MtvzsWAQhscoJr7LqKg@mail.gmail.com>
Subject: Re: PATCH ax25: Don't hold skb lock while doing blocking read
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jul 2020 22:31:18 +0100, Eric Dumazet <eric.dumazet@gmail.com> said:
> Or you could use a smaller change and make this look like net/x25/af_x25.c ?

Ah, good point.
Here's a revised version, that like x25 releases the lock and reacquires it.


Author: Thomas Habets <habets@google.com>
Date:   Fri Jun 26 15:23:26 2020 +0100

    ax25: Don't hold sock lock while doing blocking read

    This release/lock follows the pattern of net/x25/af_x25.c.

    I see some other socket types are also locking during
    read. E.g. qrtr_recvmsg. Maybe they need to be fixed too.

    Here's a test program that illustrates the problem:
    https://github.com/ThomasHabets/radiostuff/blob/master/ax25/axftp/examples/client_lockcheck.cc

    Before:
    strace -f -eread,write ./examples/client_lockcheck M0THC-9 M0THC-0 M0THC-2
    strace: Process 3888 attached
    [pid  3888] read(3,  <unfinished ...>
    [pid  3887] write(3, "hello world", 11
    [hang]

    After:
    strace -f -eread,write ./examples/client_lockcheck M0THC-9 M0THC-0 M0THC-2
    strace: Process 2433 attached
    [pid  2433] read(3,  <unfinished ...>
    [pid  2432] write(3, "hello world", 11) = 11
    [pid  2433] <... read resumed> "yo", 1000) = 2
    [pid  2433] write(1, "yo\n", 3yo
    )         = 3
    [successful exit]

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index fd91cd34f25e..75a7c32c7c1a 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1628,8 +1628,10 @@ static int ax25_recvmsg(struct socket *sock,
struct msghdr *msg, size_t size,
        }

        /* Now we can treat all alike */
+       release_sock(sk);
        skb = skb_recv_datagram(sk, flags & ~MSG_DONTWAIT,
                                flags & MSG_DONTWAIT, &err);
+       lock_sock(sk);
        if (skb == NULL)
                goto out;
