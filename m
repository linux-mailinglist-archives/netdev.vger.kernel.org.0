Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05DE0124530
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 11:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfLRK5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 05:57:55 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:40833 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726595AbfLRK5z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 05:57:55 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 55c136cb;
        Wed, 18 Dec 2019 10:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=55Ej4v0lM3p/I0FACRIUrnfxHIU=; b=vbw6a+
        MHY4MrDHXtOaa/wts2jO4Jb7oi1uKXpI4vrR6Ae91EPhptQMbj+8ZZ8muRDF9j7D
        mYV3IXZCk+jAfe3hvXAWgZQTVQQIZ6zGksZgxMvnCRSX3xEI+jEuNquVKEAEhQiu
        BLFUlgnliYBoMn+WzSZQlKfBoo0HM60WoFHLceIFVTVT/LyFhA7NiN2uOKt4Dts1
        1l6acGOyDDQUdjI8TglIeUAPuvXgevkzuqNpe9fumQmOdrGajoZGb8F/E54BMRHC
        BJqr3bgX9wQd4mLFT5cVANQNVzAuMhze+jVyCSz4EtFd70n80WyvHAq4OcyxH9X6
        rewiFeDTthHEFI2w==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b0294151 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Wed, 18 Dec 2019 10:01:18 +0000 (UTC)
Received: by mail-ot1-f53.google.com with SMTP id x3so1998460oto.11;
        Wed, 18 Dec 2019 02:57:52 -0800 (PST)
X-Gm-Message-State: APjAAAVrn1qy7wtIpeIqtNwi3i7tsYFCPy8YacM8Vxn6xt9ZEyihjJtv
        9VhgAz7NpYvpjTU9k6Z00KGeJXJVI27LZL8e1S4=
X-Google-Smtp-Source: APXvYqxjqV48MW8pEkonJsHCBJB6dAMkCc+h3CShRUdg0tgBsfi81aou/VOZAKMexDuvEJyDMIJCnr2JWKqhoiSCJ4c=
X-Received: by 2002:a9d:674f:: with SMTP id w15mr2002550otm.243.1576666671241;
 Wed, 18 Dec 2019 02:57:51 -0800 (PST)
MIME-Version: 1.0
References: <20191208232734.225161-1-Jason@zx2c4.com> <CACT4Y+bsJVmgbD-WogwU=LfWiPN1JgjBrwx4s8Y14hDd7vqqhQ@mail.gmail.com>
In-Reply-To: <CACT4Y+bsJVmgbD-WogwU=LfWiPN1JgjBrwx4s8Y14hDd7vqqhQ@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 18 Dec 2019 11:57:39 +0100
X-Gmail-Original-Message-ID: <CAHmME9o0AparjaaOSoZD14RAW8_AJTfKfcx3Y2ndDAPFNC-MeQ@mail.gmail.com>
Message-ID: <CAHmME9o0AparjaaOSoZD14RAW8_AJTfKfcx3Y2ndDAPFNC-MeQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: WireGuard secure network tunnel
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dmitry,

On Wed, Dec 18, 2019 at 11:13 AM Dmitry Vyukov <dvyukov@google.com> wrote:
> Does it really do "verbose debug log"? I only see it is used for
> self-tests and debug checks:

Yes, it does, via net_dbg and co. People with the Linux "dynamic
debugging" feature turned also get the log by twiddling with some file
at runtime.

> In different contexts one may enable different sets of these.
> In particular in fuzzing context one absolutely wants additional debug
> checks, but not self tests and definitely no verbose logging. CI and
> various manual scenarios will require different sets as well.
> If this does verbose logging, we won't get debug checks as well during
> fuzzing, which is unfortunate.
> Can make sense splitting CONFIG_WIREGUARD_DEBUG into 2 or 3 separate
> configs (that's what I see frequently). Unfortunately there is no
> standard conventions for anything of this, so CIs will never find your
> boot tests and fuzzing won't find the additional checks...

I agree that it might make sense to split this up at some point, but
for now I think it might be a bit overkill. Both the self-tests and
debug tests are *very* light at the moment. Down the road if these
become heavier, I think it'd probably be a good idea, but for the time
being it'd mostly be more complexity for nothing.

Another more interesting point, though, you wrote
> and definitely no verbose logging.

Actually with WireGuard, I think that's not the case. The WireGuard
logging has been written with DoS in mind. You /should/ be able to
safely run it on a production system exposed to the wild Internet, and
while there will be some additional things in your dmesg, an attacker
isn't supposed to be able to totally flood it without ratelimiting or
inject malicious strings into it (such as ANSI escape sequence). In
other words, I consider the logging to be fair game attack surface. If
your fuzzer manages to craft some nasty sequence of packets that
tricks some rate limiting logic and lets you litter all over dmesg
totally unbounded, I'd consider that a real security bug worth
stressing out about. So from the perspective of letting your fuzzers
loose on WireGuard, I'd actually like to see this option kept on.

Jason
