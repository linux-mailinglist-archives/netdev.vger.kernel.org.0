Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6AD867A1
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 19:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404204AbfHHREj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 13:04:39 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:45702 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404181AbfHHREj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 13:04:39 -0400
Received: by mail-ot1-f66.google.com with SMTP id x21so28167011otq.12
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 10:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ElTMuNeoHI+HHYYsxCZw6Aps3F3VALIwkdZIOhALrxA=;
        b=f7IPdWVvvQMrIFT5y6nMX9j1ZB6ZXkOLJIJ/Aq5Npp3ljgbC8uD1wTUVb1YGYqPbuz
         2Rzw23yxRRYVZsgsnaQGiqh94Fj/NWZBilmwBU+klcpKW3+RuKKJv9ppHnq2b+e6xWbH
         MDzXtNYeTk7otDrS+3VsOYB6WIej4R7njmXKmAYYDXeDdwxfJ0YwuNtBz/CAyqvm9GJN
         FvFHIHEnjvkyILnV7hJTjPFqxljPzGr2S+gE+YqEiUsX2oVcmrByhzE8PblD09YU5CzF
         S9rzKRPbV3v7sewdRDTeVVN78AVthP8aLdWbboRhtFiZsenQ7fbxqTsNDHlIK8CvidEr
         dCEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ElTMuNeoHI+HHYYsxCZw6Aps3F3VALIwkdZIOhALrxA=;
        b=b5N6HcoMy4xRI5tz2EpxhoJcxU0Pke+L3xvcUTKGOS5z6prpA/HHTogvyfA7fFHNCF
         +O5J5dbSuL8AVQHFmddidOmiFfWUsUbsBHJPiGqZDFkA8Kd5OkdZIj1LQ9IZQqBHryvZ
         yRuha8aFNkITbcVtFs0t7oiAeDHfdyk4TlQMRj2khEqrYNmBiAmW2xHOnSfRtymcslNy
         VWvyp3VkWKQhVKvtQDGshlJ1IHMrJ9io+yhAqm+Xok96uKI16dVICaWs5g497380NsVL
         JMk8egP0dulOdiHykYcPBry7qRtG7Y2wH81TKC6fW7x6ezLXigv3YHx459b5OfQoNmGw
         3SaQ==
X-Gm-Message-State: APjAAAVGJnJH/iXGU99+ZcV5OqR+WUYM9j91srHX0t5LsdWnQw0n0MnY
        PKt0yRD2q1tvs2z93aEV2dL0wQb/NYzfzgi4EJLzXQ==
X-Google-Smtp-Source: APXvYqzxBjBYPr3wPY34IaD0DcbIQJtetwQGaIiLDFAooByqTCVN6/j1974v7EFlnwsdK9dVBWgHIWVrxKUZGxtpblE=
X-Received: by 2002:a5e:de0d:: with SMTP id e13mr6746503iok.144.1565283877966;
 Thu, 08 Aug 2019 10:04:37 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000edcb3c058e6143d5@google.com> <00000000000083ffc4058e9dddf0@google.com>
 <CAHk-=why-PdP_HNbskRADMp1bnj+FwUDYpUZSYoNLNHMRPtoVA@mail.gmail.com>
In-Reply-To: <CAHk-=why-PdP_HNbskRADMp1bnj+FwUDYpUZSYoNLNHMRPtoVA@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 8 Aug 2019 19:04:26 +0200
Message-ID: <CACT4Y+bgH9f090N6G0H0zpPBrM-pW7aXXqt9kMxLjFk2jmpAEw@mail.gmail.com>
Subject: Re: memory leak in kobject_set_name_vargs (2)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     syzbot <syzbot+ad8ca40ecd77896d51e2@syzkaller.appspotmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Kalle Valo <kvalo@codeaurora.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, luciano.coelho@intel.com,
        Netdev <netdev@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 27, 2019 at 4:29 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Fri, Jul 26, 2019 at 4:26 PM syzbot
> <syzbot+ad8ca40ecd77896d51e2@syzkaller.appspotmail.com> wrote:
> >
> > syzbot has bisected this bug to:
> >
> > commit 0e034f5c4bc408c943f9c4a06244415d75d7108c
> > Author: Linus Torvalds <torvalds@linux-foundation.org>
> > Date:   Wed May 18 18:51:25 2016 +0000
> >
> >      iwlwifi: fix mis-merge that breaks the driver
>
> While this bisection looks more likely than the other syzbot entry
> that bisected to a version change, I don't think it is correct eitger.
>
> The bisection ended up doing a lot of "git bisect skip" because of the
>
>     undefined reference to `nf_nat_icmp_reply_translation'
>
> issue. Also, the memory leak doesn't seem to be entirely reliable:
> when the bisect does 10 runs to verify that some test kernel is bad,
> there are a couple of cases where only one or two of the ten run
> failed.
>
> Which makes me wonder if one or two of the "everything OK" runs were
> actually buggy, but just happened to have all ten pass...


I agree this is unrelated.

Bisection of memory leaks is now turned off completely after a
week-long experiment (details:
https://groups.google.com/d/msg/syzkaller/sR8aAXaWEF4/k34t365JBgAJ)

FWIW 'git bisect skip' is not a problem in itself. If the bisection
will end up being inconclusive due to this, then syzbot will not
attribute it to any commit (won't send an email at all), it will just
show the commit range in the web UI for the bug.

Low probability wasn't the root cause as well, first runs ended with
10/10 precision:

bisecting cause commit starting from 3bfe1fc46794631366faa3ef075e1b0ff7ba120a
building syzkaller on 1656845f45f284c574eb4f8bfe85dd7916a47a3a
testing commit 3bfe1fc46794631366faa3ef075e1b0ff7ba120a with gcc (GCC) 8.1.0
all runs: crashed: memory leak in kobject_set_name_vargs
testing release v5.2
testing commit 0ecfebd2b52404ae0c54a878c872bb93363ada36 with gcc (GCC) 8.1.0
all runs: crashed: memory leak in kobject_set_name_vargs
testing release v5.1
testing commit e93c9c99a629c61837d5a7fc2120cd2b6c70dbdd with gcc (GCC) 8.1.0
all runs: crashed: memory leak in kobject_set_name_vargs
testing release v5.0
testing commit 1c163f4c7b3f621efff9b28a47abb36f7378d783 with gcc (GCC) 8.1.0
all runs: crashed: memory leak in kobject_set_name_vargs
testing release v4.20
testing commit 8fe28cb58bcb235034b64cbbb7550a8a43fd88be with gcc (GCC) 8.1.0
all runs: crashed: memory leak in kobject_set_name_vargs
testing release v4.19
testing commit 84df9525b0c27f3ebc2ebb1864fa62a97fdedb7d with gcc (GCC) 8.1.0
all runs: crashed: memory leak in kobject_set_name_vargs

But it was distracted by other bugs and other memory leaks (which
reproduce with lower probability) and then the process went random
(which confirms the bisection analysis results).
