Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B93F154C43
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 20:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbgBFT3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 14:29:18 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:43122 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727698AbgBFT3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 14:29:18 -0500
Received: by mail-oi1-f193.google.com with SMTP id p125so5774487oif.10
        for <netdev@vger.kernel.org>; Thu, 06 Feb 2020 11:29:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tcB2zArJfdWlSRiKMp1mRpBElv371E5kpDFKOpb7uOc=;
        b=QUs2WGWIBcgWpxLJxUTlfgR+XHfKQU7AzLgtV7p3BcQjryYCPdEhYUEoEAcqUhoDtH
         BZ8imRgJEqcRxyr/JjmTfQMIX7k+0dT2IUnZA4T0Dchi2Otqw/LSoHOYzlv7Mqk/4Ewv
         n57rU51HPLpRWqMU82HBkqj7A5gFroJxoHDFJoqJSYMKltE7FGiJIbzU42EJNcOxfGA5
         Zl87hCDzBSrYKIejSgeYtAKtBHJs2sfw4hdJ5Kpzi2+UIUBjSF51Tw7xd6NasmEDv0Co
         oM6V/L5d85c4PaywIzx1o9W3zHfZB7PtDdJZSXx4es8NLbNtviw+xATSezr2VjmaITso
         FsAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tcB2zArJfdWlSRiKMp1mRpBElv371E5kpDFKOpb7uOc=;
        b=gVYKEQXq82AHuge3TA2jnquHjKB5nUCJKa4Pu8pfuvZUBujbKntr/nV4a8HTVCLI9S
         CeoJpDBAVGLzBT9/Fue82xgHpBDz7mHY4vAzXY4uia5ZSIaNdq0FcjPdkpJ/Tmous3wY
         jRMab+K8Ca6z2a7/fAsqM2TFg+DMQTSCtHcBWqzvgOwVV321+rszwB69ahSz+NyuMR2G
         +03PGSSKaATdssvBNpmKDcU4w2uNYpdr0tQEF+AnquKHwVKi2lIjftJNQnIJiotS1QY3
         FYZa2IvQZ/dVvM4jUSg90lM4CunekQ0TJfLlb719VFCA91pEf4l/WHAcEtQIQNU/Sm3u
         oIUg==
X-Gm-Message-State: APjAAAWRA6KeLY0IMI/utge/X2L7IMAeoVtCYQF7T8ELzbRhvlXIB4zG
        +c3EaKaUYjFtS3n56oKGsQUdTbaQubrwtW/LUyajsw==
X-Google-Smtp-Source: APXvYqzxY3H9VHQKLy6SJmotxutYI23y4WupdYn0HSY2/MEQpO0LDJtyyatl8tdeEgj/cxrHEmgx/t4ORU/ia4trtmY=
X-Received: by 2002:aca:c7ca:: with SMTP id x193mr8059395oif.70.1581017357296;
 Thu, 06 Feb 2020 11:29:17 -0800 (PST)
MIME-Version: 1.0
References: <1580841629-7102-1-git-send-email-cai@lca.pw> <20200206163844.GA432041@zx2c4.com>
 <453212cf-8987-9f05-ceae-42a4fc3b0876@gmail.com> <CAHmME9pGhQoY8MjR8uvEZpF66Y_DvReAjKBx8L4SRiqbL_9itw@mail.gmail.com>
 <495f79f5-ae27-478a-2a1d-6d3fba2d4334@gmail.com> <20200206184340.GA494766@zx2c4.com>
In-Reply-To: <20200206184340.GA494766@zx2c4.com>
From:   Marco Elver <elver@google.com>
Date:   Thu, 6 Feb 2020 20:29:06 +0100
Message-ID: <CANpmjNN9xsxuPo4oc4CwDDbQS3bWBn0c_m++pLo61EOap=UOow@mail.gmail.com>
Subject: Re: [PATCH v3] skbuff: fix a data race in skb_queue_len()
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, Qian Cai <cai@lca.pw>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Feb 2020 at 19:43, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Thu, Feb 06, 2020 at 10:22:02AM -0800, Eric Dumazet wrote:
> > On 2/6/20 10:12 AM, Jason A. Donenfeld wrote:
> > > On Thu, Feb 6, 2020 at 6:10 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > >> Unfortunately we do not have ADD_ONCE() or something like that.
> > >
> > > I guess normally this is called "atomic_add", unless you're thinking
> > > instead about something like this, which generates the same
> > > inefficient code as WRITE_ONCE:
> > >
> > > #define ADD_ONCE(d, s) *(volatile typeof(d) *)&(d) += (s)
> > >
> >
> > Dmitry Vyukov had a nice suggestion few months back how to implement this.
> >
> > https://lkml.org/lkml/2019/10/5/6
>
> That trick appears to work well in clang but not gcc:
>
> #define ADD_ONCE(d, i) ({ \
>        typeof(d) *__p = &(d); \
>        __atomic_store_n(__p, (i) + __atomic_load_n(__p, __ATOMIC_RELAXED), __ATOMIC_RELAXED); \
> })
>
> gcc 9.2 gives:
>
>   0:   8b 47 10                mov    0x10(%rdi),%eax
>   3:   83 e8 01                sub    $0x1,%eax
>   6:   89 47 10                mov    %eax,0x10(%rdi)
>
> clang 9.0.1 gives:
>
>    0:   81 47 10 ff ff ff ff    addl   $0xffffffff,0x10(%rdi)
>
> But actually, clang does equally as well with:
>
> #define ADD_ONCE(d, i) *(volatile typeof(d) *)&(d) += (i)

I feel that ADD_ONCE conveys that it adds actually once (atomically),
that is, if there are concurrent ADD_ONCE, all of them will succeed.
This is not the case with the above variants and the 'ONCE' can turn
into a 'MAYBE', and since we probably want to avoid making this more
expensive on e.g. x86 that would need a LOCK-prefix.

In the case here, what we actually want is something that safely
increments/decrements if there are only concurrent readers (concurrent
writers disallowed). So 'add_exclusive(var, val)' (all-caps or not)
might be more appropriate. [As an aside, recent changes to KCSAN would
also allow us to assert for something like 'add_exclusive()' that
there are in fact no other writers but only concurrent readers, even
if all accesses are marked.]

If the single-writer constraint isn't wanted, but should still not be
atomic, maybe 'add_lossy()'?

Thanks,
-- Marco


> And testing further back, it generates the same code with your original
> WRITE_ONCE.
>
> If clang's optimization here is technically correct, maybe we should go
> talk to the gcc people about catching this case?
