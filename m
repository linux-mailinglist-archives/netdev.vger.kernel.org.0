Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2059D34CCD
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 18:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728214AbfFDQFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 12:05:15 -0400
Received: from mail-lf1-f51.google.com ([209.85.167.51]:40327 "EHLO
        mail-lf1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728160AbfFDQFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 12:05:14 -0400
Received: by mail-lf1-f51.google.com with SMTP id a9so15454940lff.7
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 09:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yHKf0dBjWiln0w4ZthMmJnFg12c3Gmyiday/W+Ueeog=;
        b=P+lo3dX3Y853XVVu/NErjTHy0y3uTOH5/1fFj4/+SdG8xmL9Vhgu3H+7epySB5/DoQ
         dE44yz0S2d21n4MIUQWM/Dq2DDY7x8hX/s3oEWxiond0RMSTcyQ7l8X3Q+Qh7jsMktff
         GFarG1OFqhP44+4kIN0kRqLqWQzDquNP2iWEM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yHKf0dBjWiln0w4ZthMmJnFg12c3Gmyiday/W+Ueeog=;
        b=KKeLbLdpNn1s0b6p5ycDpOI5n8d0hY8iZX9WIjxRDPu4SCxdnBGpuQGgPWZWboMln1
         TA1PZ+qgtLDcg/TyBQZSm2D8F6xZbTECb0U6jXaU6r21JRD8V9xLJ2RvjEYzrW6WwoIR
         oA6znsbia8Y5l3NSgRCf2D5C8McHi8anaS9ni/opCY3W5WBW4WV3+L+FEVW5+66q4Mvu
         eO5THJQijB2BUVZdOPOwqFxoQ3a6cWLjZoV0mJsor6gtdgXnD9+v5214aTGgBwSnLini
         X4uBvIyqdkGKTKsdDJDXbC6ZztYAbSetRxICKJajJCohUCwUmdC64xFrI5HuKd1TUEOI
         w+gw==
X-Gm-Message-State: APjAAAWGMvYUpFdnd4O11paQBSit4xXYLqwSTc7xWxfFXEynHrj9Csvs
        X2NqXgDVyon9mVilieE39DroxTS7YzM=
X-Google-Smtp-Source: APXvYqzdJQPNbIhjxiApaBe6LubdsUWGXysPLiXCOlAqU5L63BjYL5Zp3k3z/Szt7vDQKF3uri5LwQ==
X-Received: by 2002:ac2:4d1c:: with SMTP id r28mr2715027lfi.159.1559664312651;
        Tue, 04 Jun 2019 09:05:12 -0700 (PDT)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com. [209.85.208.171])
        by smtp.gmail.com with ESMTPSA id i14sm3846127ljj.57.2019.06.04.09.05.12
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 09:05:12 -0700 (PDT)
Received: by mail-lj1-f171.google.com with SMTP id o13so20232111lji.5
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 09:05:12 -0700 (PDT)
X-Received: by 2002:a2e:9654:: with SMTP id z20mr4923630ljh.52.1559664311655;
 Tue, 04 Jun 2019 09:05:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190603200301.GM28207@linux.ibm.com> <Pine.LNX.4.44L0.1906041026570.1731-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1906041026570.1731-100000@iolanthe.rowland.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 4 Jun 2019 09:04:55 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgGnCw==uY8radrB+Tg_CEmzOtwzyjfMkuh7JmqFh+jzQ@mail.gmail.com>
Message-ID: <CAHk-=wgGnCw==uY8radrB+Tg_CEmzOtwzyjfMkuh7JmqFh+jzQ@mail.gmail.com>
Subject: Re: rcu_read_lock lost its compiler barrier
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        Luc Maranget <luc.maranget@inria.fr>,
        Jade Alglave <j.alglave@ucl.ac.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 4, 2019 at 7:44 AM Alan Stern <stern@rowland.harvard.edu> wrote:
>
> Even if you don't think the compiler will ever do this, the C standard
> gives compilers the right to invent read accesses if a plain (i.e.,
> non-atomic and non-volatile) write is present.

Note that for the kernel, it's not like we go strictly by what the
standard says anyway.

The reason for the "read for write" thing is that obviously you
sometimes have broken architectures (*cough*alpha*cough*) that need to
do some common writes are read-maskmodify-write accesses, and for
bitfields you obviously *always* have that issue.

In general, a sane compiler (as opposed to "we just read the
standard") had better not add random reads, because people might have
some mappings be write-only when the hardware supports it.

And we do generally expect sanity from our compilers, and will add
compiler flags to disable bad behavior if required - even if said
behavior would be "technically allowed by the standard".

> (Incidentally, regardless of whether the compiler will ever do this, I
> have seen examples in the kernel where people did exactly this
> manually, in order to avoid dirtying a cache line unnecessarily.)

I really hope and expect that this is not something that the compiler ever does.

If a compiler turns "x = y" into if (x != y) x = y" (like we do
manually at times, as you say), that compiler is garbage that we
cannot use for the kernel. It would break things like "smp_wmb()"
ordering guarantees, I'm pretty sure.

And as always, if we're doing actively stupid things, and the compiler
then turns our stupid code into something we don't expect, the
corollary is that then it's on _us_. IOW, if we do

    if (x != 1) {
         ...
    }
    x = 1;

and the compiler goes "oh, we already checked that 'x == 1'" and moves
that "unconditional" 'x = 1' into the conditional section like

    if (x != 1) {
        ..
        x = 1;
    }

then that's not something we can then complain about.

So our expectation is that the compiler is _sane_, not that it's some
"C as assembler".  Adding spurious reads is not ok. But if we already
had reads in the code and the compiler combines them with other ops,
that's on us.

End result: in general, we do expect that the compiler turns a regular
assignment into a single plain write when that's what the code does,
and does not add extra logic over and beyond that.

In fact, the alpha port was always subtly buggy exactly because of the
"byte write turns into a read-and-masked-write", even if I don't think
anybody ever noticed (we did fix cases where people _did_ notice,
though, and we might still have some cases where we use 'int' for
booleans because of alpha issues.).

So I don't technically disagree with anything you say, I just wanted
to point out that as far as the kernel is concerned, we do have higher
quality expectations from the compiler than just "technically valid
according to the C standard".

                   Linus
