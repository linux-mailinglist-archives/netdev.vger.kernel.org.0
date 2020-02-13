Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 800A715C92E
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 18:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbgBMRJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 12:09:27 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36674 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727690AbgBMRJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 12:09:27 -0500
Received: by mail-wr1-f68.google.com with SMTP id z3so7657709wru.3
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 09:09:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UMbYCpdCH8T8sVuZfzcA/ngmQLlMH6y8DegWbJdKko4=;
        b=s2Y18twm33EPAUcSQxsxInq8a0dds4VggPNveAoz+VMUepMzWVnWWR7YEpDzXQYs1y
         lRhqpN5ffmjp89a+EFWY0St2RG0pE35PGKEFvcWjbCQ1lLRqz3CG0BWlVvZIrf9gjPLn
         GQ93N6ZnSlrB2X6gwDPp5WBGrLCKtld8mpQzlXOd/RnrRSBBfLWspmp/UGAp4wFWbAms
         LY5F7xkRay4VRrzzM3jSUm3OzzrXNLzouaaSi3NTyQ1gKx4stAdquMEt1cfazL5R61oQ
         pbcM4qyWGeUjHq8YzSp1NfJowdpVWy4cYrB1D2+E9dnLF2SxtUCn/WMIuy+Rbhlvh+ju
         okBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UMbYCpdCH8T8sVuZfzcA/ngmQLlMH6y8DegWbJdKko4=;
        b=f1RLKD+vH6wdp3uuqvoWkoIt5n/XsMBCr9V/LlQ5G4DSemxvpBKvOyu4cu2uCCFHNn
         zn0yN/Ry6O14gTFE2io7bZEW5pXSvuEHxYzaM7WbusW9xSvDhB8itOfWQQtWci3HvJEz
         owzKduUlx9uRzoTbDMgzsCvArupYCKnjg65kj5R8Yqj5qDuScKTTuIMPFFHN6MYyMRUq
         MHsY92j0QKOqoYtm4A13mE4pXR18KrmrBG2BA8SydtvsVWQdzyFsv0e77uIrIB+60AGm
         Nyf/fX1t3kc5iZl3UpKrvLMs757uZ6qYfbkQksjbimvHj5ktgLMsteIU/jhXkqkTddoR
         YNMg==
X-Gm-Message-State: APjAAAWCQ1DQ3nrH2RHLWs7u3syDy5UHn3F/+wWGYpdBUnTXqXIs06ZN
        4GH+2CNlIodKlRSEesETNFEimXdofpkTE6cVCMkgwA==
X-Google-Smtp-Source: APXvYqysk4BQRUA7KMjIf3XEDQQsUviietYjVkLfWfBQqDWTKRzgbIjzZ6YU2odsXwNwn76mVKONYWxTwrbLQmqJR5Y=
X-Received: by 2002:a5d:6545:: with SMTP id z5mr22318536wrv.3.1581613764978;
 Thu, 13 Feb 2020 09:09:24 -0800 (PST)
MIME-Version: 1.0
References: <20200128025958.43490-1-arjunroy.kdev@gmail.com>
 <20200128025958.43490-2-arjunroy.kdev@gmail.com> <20200212184101.b8551710bd19c8216d62290d@linux-foundation.org>
In-Reply-To: <20200212184101.b8551710bd19c8216d62290d@linux-foundation.org>
From:   Arjun Roy <arjunroy@google.com>
Date:   Thu, 13 Feb 2020 09:09:13 -0800
Message-ID: <CAOFY-A16-eba-aNO+=062jy67cRs7-YSGoctp4GVApBnhYFPhA@mail.gmail.com>
Subject: Re: [PATCH resend mm,net-next 2/3] mm: Add vm_insert_pages().
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Arjun Roy <arjunroy.kdev@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I think at least to start it probably makes sense to keep regular
vm_insert_page() around - smaller stack used, less branches, if you
know you just need one page - not sure if gcc would err towards
smaller binary or not when compiling.

Regarding the page_count() check - as far as I can tell that's just
checking to make sure that at least *someone* has a reference to the
page before inserting it; in the zerocopy case we most definitely do
but I guess a bad caller could call it with a bad page argument and
this would guard against that.

Actually, I appear to have fat fingered it - I intended for this check
to be in there but seem to have forgotten (per the comment "/* Defer
page refcount checking till we're about to map that page. */" but with
no actual check). So that check should go inside
insert_page_in_batch_locked(), right before the
validate_page_before_insert() check. I'll send an updated fixup diff
shortly.

-Arjun

On Wed, Feb 12, 2020 at 6:41 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Mon, 27 Jan 2020 18:59:57 -0800 Arjun Roy <arjunroy.kdev@gmail.com> wrote:
>
> > Add the ability to insert multiple pages at once to a user VM with
> > lower PTE spinlock operations.
> >
> > The intention of this patch-set is to reduce atomic ops for
> > tcp zerocopy receives, which normally hits the same spinlock multiple
> > times consecutively.
>
> Seems sensible, thanks.  Some other vm_insert_page() callers might want
> to know about this, but I can't immediately spot any which appear to be
> high bandwidth.
>
> Is there much point in keeping the vm_insert_page() implementation
> around?  Replace it with
>
> static inline int
> vm_insert_page(struct vm_area_struct *vma, unsigned long addr,
>                struct page *page)
> {
>         return vm_insert_pages(vma, addr, &page, 1);
> }
>
> ?
>
> Also, vm_insert_page() does
>
>         if (!page_count(page))
>                 return -EINVAL;
>
> and this was not carried over into vm_insert_pages().  How come?
>
> I don't know what that test does - it was added by Linus in the
> original commit a145dd411eb28c83.  It's only been 15 years so I'm sure
> he remembers ;)
