Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2697923CC2A
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 18:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbgHEQ1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 12:27:44 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:55745 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726974AbgHEQZe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Aug 2020 12:25:34 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 565f5627;
        Wed, 5 Aug 2020 16:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=wQFKIPFU1F/Wy4pWSc/VF213f2A=; b=bSL763
        Pe22/Yrf1UnS1/o3vmN/dvQ3cqpXsG0YhJmq0myiBvUbP8C+B7nyfMRHtoZco3jQ
        XgxK6oNyirnRJSytWcRd2+Um5KW679E5JJg9CyB4kfMl8lvfuTPQUvbS/mxwIgjq
        1fFbTGBHjTGguQ97k1uplFs1y6iaIRgNO1ruETUoNzR6dEdi4yl9zfRuukuX/EkX
        5blpRTY5EMgE7MuC2/ihlzH1/aaTOpY+/X1NDGr3k6Kyy1ZO9QQsJkhAWoKVBqS0
        6s54a96eJcOclCdCYlFswS1uyKuJiG6bWjQDAa51xtYoHqapM5whiB/mAlK8EcN/
        tsYeY7beOGEzcBYg==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id da8a7e5c (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 5 Aug 2020 16:00:35 +0000 (UTC)
Received: by mail-il1-f178.google.com with SMTP id t18so37903088ilh.2;
        Wed, 05 Aug 2020 09:25:06 -0700 (PDT)
X-Gm-Message-State: AOAM531G5mNd4FAaKv8Li6Qmq62kFeWxKbBhZ+iWtNoPOlfb/z0DGNoo
        IDrmtapn41WePLjMqPAnX/CD1R+K25UvytOrXZc=
X-Google-Smtp-Source: ABdhPJypmSLlzD3Asg+78LEL2bY8dQDr5phM3gWy+pMD+r8LcO15NQML6LeKqYo5Y6nNLW5pyMx0r7EbORxmhhDylXs=
X-Received: by 2002:a92:ce12:: with SMTP id b18mr4821887ilo.207.1596644704701;
 Wed, 05 Aug 2020 09:25:04 -0700 (PDT)
MIME-Version: 1.0
References: <9f74230f-ba4d-2e19-5751-79dc2ab59877@gmail.com>
 <20200805024941.GA17301@1wt.eu> <20200805153432.GE497249@mit.edu>
In-Reply-To: <20200805153432.GE497249@mit.edu>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 5 Aug 2020 18:24:53 +0200
X-Gmail-Original-Message-ID: <CAHmME9qu-gUvZ1HJB8x4aWOsayRY_nKUu0S49Wx6UU-O4SQn=Q@mail.gmail.com>
Message-ID: <CAHmME9qu-gUvZ1HJB8x4aWOsayRY_nKUu0S49Wx6UU-O4SQn=Q@mail.gmail.com>
Subject: Re: Flaw in "random32: update the net random state on interrupt and activity"
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     Willy Tarreau <w@1wt.eu>, Marc Plumb <lkml.mplumb@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        Amit Klein <aksecurity@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 5, 2020 at 6:07 PM <tytso@mit.edu> wrote:
> That being said, it certainly is a certificational / theoretical
> weakness

random.c is filled with super suspicious things that are probably only
correct by accident, or only correct in practice, but in theory it's
just such a mess. Stupid example if I'm remembering correctly: you
fill the sha1 IV with input from rdrand; if rdrand is borked or
backdoored or whatever, then the security of sha1 there reduces to
shacal1, which isn't totally broken, far from it actually, so we're
fine there, but you can't help but look at that and say "ugh." I'll
rewrite that eventually. Anyway, having another "certificational
weakness", as you put it, that isn't a practical one would be par for
the course with random.c

> , and if the bright boys and girls at Fort Meade did figure
> out a way to exploit this, they are very much unlikely to share it at
> an open Crypto conference.  So replacing LFSR-based PRnG with
> something stronger which didn't release any bits from the fast_pool
> would certainly be desireable, and I look forward to seeing what Willy
> has in mind.

This disaster is partially my fault. I was going to make
get_random_u{32,64} fast enough that we could get rid of the fake rng
stuff, and then Covid things got weird and I haven't gotten refocused
on that yet. Andy started that, and I was supposed to pick up his work
and complete it, but I dropped the ball. I kept meaning to get back to
that, but I'd get discouraged every time I saw Willy sending more
messages about improving the fake rng stuff with more fake rng stuff.
But, seems like it's time for me to step on the pedal a bit and get
that working. So hopefully we'll be able to get rid of the code in
question here, and use a good rng everywhere. I'll send an update on
that if I get it working.


Jason
