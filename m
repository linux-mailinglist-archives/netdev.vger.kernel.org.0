Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD78A149C9B
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 20:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgAZTzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 14:55:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59646 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbgAZTzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 14:55:03 -0500
Received: from localhost (unknown [62.209.224.147])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EFB82155526E3;
        Sun, 26 Jan 2020 11:54:59 -0800 (PST)
Date:   Sun, 26 Jan 2020 20:54:55 +0100 (CET)
Message-Id: <20200126.205455.1082696737843782760.davem@davemloft.net>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, kubakici@wp.pl, mkubecek@suse.cz,
        maciej.fijalkowski@intel.com, sgoutham@marvell.com,
        gakula@marvell.com
Subject: Re: [PATCH v5 04/17] octeontx2-pf: Initialize and config queues
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CA+sq2CcQk47hZ9tue1-yjGmUFF7RONfG47c2T77SRU5t8ovpVg@mail.gmail.com>
References: <1579887955-22172-5-git-send-email-sunil.kovvuri@gmail.com>
        <20200126.120059.1968749784775179465.davem@davemloft.net>
        <CA+sq2CcQk47hZ9tue1-yjGmUFF7RONfG47c2T77SRU5t8ovpVg@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 26 Jan 2020 11:55:02 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date: Sun, 26 Jan 2020 23:30:04 +0530

> On Sun, Jan 26, 2020 at 4:31 PM David Miller <davem@davemloft.net> wrote:
>>
>> From: sunil.kovvuri@gmail.com
>> Date: Fri, 24 Jan 2020 23:15:42 +0530
>>
>> > @@ -184,6 +192,72 @@ static inline void otx2_mbox_unlock(struct mbox *mbox)
>> >       mutex_unlock(&mbox->lock);
>> >  }
>> >
>> > +/* With the absence of API for 128-bit IO memory access for arm64,
>> > + * implement required operations at place.
>> > + */
>> > +#if defined(CONFIG_ARM64)
>> > +static inline void otx2_write128(u64 lo, u64 hi, void __iomem *addr)
>> > +{
>> > +     __asm__ volatile("stp %x[x0], %x[x1], [%x[p1],#0]!"
>> > +                      ::[x0]"r"(lo), [x1]"r"(hi), [p1]"r"(addr));
>> > +}
>> > +
>> > +static inline u64 otx2_atomic64_add(u64 incr, u64 *ptr)
>> > +{
>> > +     u64 result;
>> > +
>> > +     __asm__ volatile(".cpu   generic+lse\n"
>> > +                      "ldadd %x[i], %x[r], [%[b]]"
>> > +                      : [r]"=r"(result), "+m"(*ptr)
>> > +                      : [i]"r"(incr), [b]"r"(ptr)
>> > +                      : "memory");
>> > +     return result;
>> > +}
>> > +
>> > +#else
>> > +#define otx2_write128(lo, hi, addr)
>> > +#define otx2_atomic64_add(incr, ptr)         ({ *ptr = incr; })
>> > +#endif
>>
>> So what exactly is going on here?  Are these true 128-bit writes
>> and atomic operations?  Why is it named atomic64 then?  Why can't
>> the normal atomic64 kernel interfaces be used?
> 
> otx2_write128() is used to free receive buffer pointers into buffer pool.
> It's a register write, which works like,
> "A 128-bit write (STP) to NPA_LF_AURA_OP_FREE0 and
> NPA_LF_AURA_OP_FREE1 frees a pointer into a given pool. All other
> accesses to these registers (e.g. reads and 64-bit writes) are RAZ/WI."
> 
> Wrt otx2_atomic64_add(), registers for reading IRQ status, queue stats etc
> works only with 64-bit atomic load-and-add instructions. The nornal
> atomic64 kernel
> interface for ARM64 which supports 'ldadd' instruction needs
> CONFIG_ARM64_LSE_ATOMICS
> to be enabled. LSE (Large system extensions) is a CPU feature which is supported
> by silicons which implement ARMv8.1 and later version of instruction set.
> 
> To support kernel with and without LSE_ATOMICS config enabled, here we are
> passing "cpu   generic+lse" to the compiler. This is also done to avoid making
> ARM64 and ARM64_LSE_ATOMICS hard dependency for driver compilation.
> 
>>
>> Finally why is the #else case doing an assignment to *ptr rather
>> than an increment like "*ptr += incr;"?
> 
> This device is a on-chip network controller which is a ARM64 based.
> Previously when i submitted driver with ARM64 dependency i was advised
> to allow this driver to be built for other architectures as well for
> static analysis
> reports etc.
> https://www.spinics.net/lists/linux-soc/msg05847.html
> 
> Hence added a dummy 'otx2_atomic64_add' just for compilation purposes.
> Please ignore the definition.

But it doesn't add, it assigns.  That's the point of my question.

If you are going to provide a fallback, at least make it semantically
correct.
