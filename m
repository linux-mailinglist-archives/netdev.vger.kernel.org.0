Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B96F30A33
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 10:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbfEaIYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 04:24:22 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:33170 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbfEaIYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 04:24:22 -0400
Received: by mail-it1-f193.google.com with SMTP id j17so10331258itk.0
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 01:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YyOvQlBwBfyT4dQcy6Ql02p1RNK4xtCznQNR/OE+OXo=;
        b=YGrjxb+OdJJY2Y3NTtCfg2gWpMLqGbMTB5DSeaFRSBlz2E7Rpz/dZ4hbkEm5+ndGIp
         2YZFySr1E4oLpMXpm+TqkfUCAQR9OdXxFF6BteTchF3BajJuEDqZvC7ikcnNcg59t0Ws
         0XXOzDGXZvTYVCBaNNl70XNZ/R9s1LZJH37YNMLh8/OggGDSjvY696P5xxL9Tvca4jkd
         r37TVzH/sPS+dFma5oBrDWPRbXFvayR3P4/9h7sfmNm7AY0oB25uG1HzFhVOD/gDVlEu
         UM+qo59Zaocs7Z9rlvRDWEZBNNisQ0HRCoZiS62t5e74rdXo2G2f2x8Csljixz6TgTM6
         teGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YyOvQlBwBfyT4dQcy6Ql02p1RNK4xtCznQNR/OE+OXo=;
        b=UEmwqI3VqK6QVwGHKdbi7+C9gDAKIcu04kjVOBUEUCz9tDBPMWZLC0abUHkItYAFmM
         HKPTc0CyZZShvvyFmSwsMKSdMN//f4oBlYhBJpLnjbRyo6l7GHphfZ065pCjlWy8dIVU
         6eKVTj+guWHw+MEwDCw6sPbG5C2STGEVb7JDtK+lVFIiDjz7XS822Tl5oQvbjtXiQ8o3
         wIJkaoArKYK2CeYLCz6VGR2k51mGCqn/7SCbppGK6NNohTS1qZWGqkC2/AM8hSCR8rfM
         iHSpnlSIAOSdDtiZYrGV8e6jP4eWpQKc6irUDTRc8wu4H4PpfcZn8kLhHgRlBTh3uax2
         BUaQ==
X-Gm-Message-State: APjAAAV7ogH+MvYwYbugK/QMOq5gg/XEP40drh406WSIXR+6+4NtF9eG
        V7iDNPVxV8JglqIIDUi45LtwZXE9jTD6K7BcazjZ9A==
X-Google-Smtp-Source: APXvYqwL1lRJB5GvBymOPhjDdoQBldCtq9tIq71bu2iYf0fGDlTYUi1jjLXldLi+CutPqDjvtA3YEzBDSVProCIgkgI=
X-Received: by 2002:a02:1384:: with SMTP id 126mr5303492jaz.72.1559291060657;
 Fri, 31 May 2019 01:24:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190524160340.169521-12-edumazet@google.com> <20190528063403.ukfh37igryq4u2u6@gondor.apana.org.au>
 <CANn89i+NfFLHDthLC-=+vWV6fFSqddVqhnAWE_+mHRD9nQsNyw@mail.gmail.com>
 <20190529054026.fwcyhzt33dshma4h@gondor.apana.org.au> <CACT4Y+Y39u9VL+C27PVpfVZbNP_U8yFG35yLy6_KaxK2+Z9Gyw@mail.gmail.com>
 <20190529054759.qrw7h73g62mnbica@gondor.apana.org.au>
In-Reply-To: <20190529054759.qrw7h73g62mnbica@gondor.apana.org.au>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 31 May 2019 10:24:08 +0200
Message-ID: <CACT4Y+ZuHhAwNZ31+W2Hth90qA9mDk7YmZFq49DmjXCUa_gF1g@mail.gmail.com>
Subject: Re: [PATCH] inet: frags: Remove unnecessary smp_store_release/READ_ONCE
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        Alan Stern <stern@rowland.harvard.edu>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 7:48 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Wed, May 29, 2019 at 07:43:51AM +0200, Dmitry Vyukov wrote:
> >
> > If fqdir->dead read/write are concurrent, then this still needs to be
> > READ_ONCE/WRITE_ONCE. Ordering is orthogonal to atomicity.
>
> No they do not.  READ_ONCE/WRITE_ONCE are basically a more fine-tuned
> version of barrier().  In this case we already have an implicit
> barrier() call due to the memory barrier semantics so this is simply
> unnecessary.
>
> It's the same reason you don't need READ_ONCE/WRITE_ONCE when you do:
>
> CPU1                            CPU2
> ----                            ----
> spin_lock
> shared_var = 1                  spin_lock
> spin_unlock                     if (shared_var == 1)
>                                         ...
>                                 spin_unlock

+Paul, Andrea, Alan

OK, let's call it barrier. But we need more than a barrier here then.

1. The C standard is very clear here -- this new code causes undefined
behavior of kernel. Regardless of what one might think about the C
standard, it's still the current contract between us and compiler
writers and nobody created any better replacement.

2. Then Documentation/memory-barriers.txt (which one can't say is not
relevant here) effectively says the same:

 (*) It _must_not_ be assumed that the compiler will do what you want
     with memory references that are not protected by READ_ONCE() and
     WRITE_ONCE().  Without them, the compiler is within its rights to
     do all sorts of "creative" transformations, which are covered in
     the COMPILER BARRIER section.

3. The code is only correct under the naive execution (all code is
executed literally as written). But we don't want compiler to execute
code in such way, we want them to all employ all possible optimization
tricks to make it faster. As the result compiler can break this code.
It can reload the condition multiple times, including within the same
branch, it can use variables as scratch storage and do other things
that you and me can't think of now. Some of these optimizations are
reasonable, some are not reasonable but still legal and just a result
complex compiler logic giving surprising result on a corner case. Also
if current implementation details of rhashtable_remove_fast change,
surprising things can happen, e.g. executing just refcount_dec but not
rhashtable_remove_fast.
"Proving" impossibility of any of unexpected transformations it's just
not what we should be spending time on again and again. E.g. a hundred
of times people will skim through this code in future chasing some
bug.

4. Then READ_ONCE()/WRITE_ONCE() improve code self-documentation.
There is huge difference between a plain load and inter-thread
synchronization algorithms. This needs to be clearly visible in the
code. Especially when one hunts a racy memory corruption in large base
of code (which happens with kernel all the time).

5. Marking all shared access is required to enable data race detection
tooling. Which is an absolute must for kernel taking into account
amount and complexity of tricky multi-threaded code. We need this.

6. We need marking of all shared memory accesses for the kernel memory
model effort. There is no way the model can be defined without that.

7. This is very different from spin_lock example. spin_lock is a
synchronization primitive that effectively makes code inside of the
critical section single-threaded. But in this case read/write to dead
execute concurrently.

So what are the reasons to give up all these nice things and go into
the rabbit hole of "proving" that we don't see how compiler could
screw up things?
If there are no significant reasons that outweigh all of these points,
please use READ_ONCE()/WRITE_ONCE() for all shared accesses. Many will
say thank you.
