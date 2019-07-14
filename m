Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5783A68041
	for <lists+netdev@lfdr.de>; Sun, 14 Jul 2019 18:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728307AbfGNQgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jul 2019 12:36:47 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37523 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728164AbfGNQgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jul 2019 12:36:47 -0400
Received: by mail-lj1-f193.google.com with SMTP id z28so13839423ljn.4
        for <netdev@vger.kernel.org>; Sun, 14 Jul 2019 09:36:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ViiJKLh2r6Mb+xeyGQz8eGKAVX101QXoiobk7whksJY=;
        b=Q9XzTjgq7KrETV+LkMUUJa9raV6nnwWfs6fLcr9vulFCuzOgWj1aest+7YaQA1l4yA
         QQpFDqm9YlKiSRVsHwwHCOTpkC2W2rqKVp7XV1gxEAMx5CH6FPVqv4kzns5ToJE21EAO
         oB/Oey0PTNcbHzlKyLeXqV0Qufb0ycIcJ5Go5BUz2dLO80YR9ELGuLUBtVe0p3G4qNu9
         F5m3iTfBJ9nAbc0MttFiXDOlLTczQXVQmJDotiuj28Dy97AxWaPUNYVpAcVzSKOkOPH7
         W1WCn7kxPajMq6Ggj74jDWSfeqHgPag904fRXWzTJj0w3cu5GICFbJSMt8ocFKYfj9eg
         ++XQ==
X-Gm-Message-State: APjAAAVCVQEh1kHZgDiAfbdUt41P+apyGInqszEL/zURK+3xnTlWTl+d
        9tda7L7PDoedsI7fcNjR7tEJrfuvBuoqS5YWJ/g0SA==
X-Google-Smtp-Source: APXvYqyBiqq/mo0BImk1+QzjzMNzDVt3J8AEUgqJozlro9cH5X5Livw47Awty5hZAT6TjC0oDfKpTM4JQb+8MTqBBBY=
X-Received: by 2002:a2e:2b01:: with SMTP id q1mr11231026lje.27.1563122205557;
 Sun, 14 Jul 2019 09:36:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190611180513.30772-1-mcroce@redhat.com> <20190611122800.56d72eba@hermes.lan>
In-Reply-To: <20190611122800.56d72eba@hermes.lan>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Sun, 14 Jul 2019 18:36:08 +0200
Message-ID: <CAGnkfhy9-GrxtBw4bGtxVv3erbd8dRi_BRP=k2etQRj_RwuLfA@mail.gmail.com>
Subject: Re: [PATCH iproute2-next] Makefile: pass -pipe to the compiler
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 9:28 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Tue, 11 Jun 2019 20:05:13 +0200
> Matteo Croce <mcroce@redhat.com> wrote:
>
> > Pass the -pipe option to GCC, to use pipes instead of temp files.
> > On a slow AMD G-T40E CPU we get a non negligible 6% improvement
> > in build time.
> >
> > real    1m15,111s
> > user    1m2,521s
> > sys     0m12,465s
> >
> > real    1m10,861s
> > user    1m2,520s
> > sys     0m12,901s
> >
> > Signed-off-by: Matteo Croce <mcroce@redhat.com>
>
> Why bother, on my machine (make -j12).
>
> Before
> real    0m6.320s
> user    0m30.674s
> sys     0m3.649s
>
>
> After (with -pipe)
> real    0m6.158s
> user    0m31.197s
> sys     0m3.532s
>
>
> So it is slower. Get a faster disk :-)
>

I did it :)

root@apu:~# hdparm -t /dev/sda

/dev/sda:
 Timing buffered disk reads: 1086 MB in  3.00 seconds = 361.58 MB/sec

No change at all thought. It's really a CPU bound job, and this
machine is not a number cruncher:

root@apu:~# dd if=/dev/zero bs=1G count=1 status=none |time -p sha1sum
2a492f15396a6768bcbca016993f4b4c8b0b5307  -
real 16.00
user 12.38
sys 2.05

I think that the slight increase is due to the fact that the processes
starts in parallel, instead of being serialized.

> Maybe allow "EXTRA_CFLAGS" to be passed to Makefile for those that
> have a burning need for this.

Just out of curiosity, I checked the linux history repo to discover
when it was introduced in the kernel, it tooks me a while to really
find it:

Linux-0.99.13k (September 19, 1993)

-- 
Matteo Croce
per aspera ad upstream
