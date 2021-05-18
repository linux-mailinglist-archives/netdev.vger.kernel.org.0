Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F279E386E09
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 02:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344749AbhERAFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 20:05:17 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:56162 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231430AbhERAFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 20:05:16 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1621296237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GHW7rXkDeIGk/f09UxCJTS97zy7h+pIJUZoYLG1bdJY=;
        b=azzdYFzdrDBd1cHZb+nfIEb6gPXpuJVbIecZfpj1yx84NpBZx8TdlCkKaP40YGn77M9c9A
        tl7fXGZS8t9aOWPi3BrzQ+stk8LUxYpV4RMvOEU/B7Z1KpeBRaHwi5xAbJQ4ZAzD+0Yr3i
        fVh9qavYuNAAna0Ds5WMaCuChBhsW6qpQ4FOLsUW8+JrvdWjeB07XMATzIf2gAnB7cUt3G
        ZaTNGxYBY91bdtLlaGiQldTD3YGcS7ll5EDzakY1Vi2y4XGcKhfBjL1QmWOVmyl15GKDG6
        fPcFCJkCABqpd7Tf3nM9P8mltnChwshTp/sMYJxCUpHPAD5iNP4JLWbAhalZWg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1621296237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GHW7rXkDeIGk/f09UxCJTS97zy7h+pIJUZoYLG1bdJY=;
        b=aKXRsDXe8OZvqv/EJLQWaYBETlUl0og14+GClrJNmh8MKDKm1XxVvecVbCeN1DyMaI0GdQ
        oI+7KyfNIXqLTACg==
To:     Nitesh Lal <nilal@redhat.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, jbrandeb@kernel.org,
        "frederic\@kernel.org" <frederic@kernel.org>,
        "juri.lelli\@redhat.com" <juri.lelli@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Alex Belits <abelits@marvell.com>,
        "linux-api\@vger.kernel.org" <linux-api@vger.kernel.org>,
        "bhelgaas\@google.com" <bhelgaas@google.com>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "rostedt\@goodmis.org" <rostedt@goodmis.org>,
        "peterz\@infradead.org" <peterz@infradead.org>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,
        "sfr\@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "stephen\@networkplumber.org" <stephen@networkplumber.org>,
        "rppt\@linux.vnet.ibm.com" <rppt@linux.vnet.ibm.com>,
        "jinyuqi\@huawei.com" <jinyuqi@huawei.com>,
        "zhangshaokun\@hisilicon.com" <zhangshaokun@hisilicon.com>,
        netdev@vger.kernel.org, chris.friesen@windriver.com,
        Marc Zyngier <maz@kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH tip:irq/core v1] genirq: remove auto-set of the mask when setting the hint
In-Reply-To: <CAFki+Lkjn2VCBcLSAfQZ2PEkx-TR0Ts_jPnK9b-5ne3PUX37TQ@mail.gmail.com>
References: <20210504092340.00006c61@intel.com> <87pmxpdr32.ffs@nanos.tec.linutronix.de> <CAFki+Lkjn2VCBcLSAfQZ2PEkx-TR0Ts_jPnK9b-5ne3PUX37TQ@mail.gmail.com>
Date:   Tue, 18 May 2021 02:03:57 +0200
Message-ID: <87im3gewlu.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 17 2021 at 18:44, Nitesh Lal wrote:
> On Mon, May 17, 2021 at 4:48 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>> The hint was added so that userspace has a better understanding where it
>> should place the interrupt. So if irqbalanced ignores it anyway, then
>> what's the point of the hint? IOW, why is it still used drivers?
>>
> Took a quick look at the irqbalance repo and saw the following commit:
>
> dcc411e7bf    remove affinity_hint infrastructure
>
> The commit message mentions that "PJ is redesiging how affinity hinting
> works in the kernel, the future model will just tell us to ignore an IRQ,
> and the kernel will handle placement for us.  As such we can remove the
> affinity_hint recognition entirely".

No idea who PJ is. I really love useful commit messages. Maybe Neil can
shed some light on that.

> This does indicate that apparently, irqbalance moved away from the usage of
> affinity_hint. However, the next question is what was this future
> model?

I might have missed something in the last 5 years, but that's the first
time I hear about someone trying to cleanup that thing.

> I don't know but I can surely look into it if that helps or maybe someone
> here already knows about it?

I CC'ed Neil :)

>> Now there is another aspect to that. What happens if irqbalanced does
>> not run at all and a driver relies on the side effect of the hint
>> setting the initial affinity. Bah...
>>
>
> Right, but if they only rely on this API so that the IRQs are spread across
> all the CPUs then that issue is already resolved and these other drivers
> should not regress because of changing this behavior. Isn't it?

Is that true for all architectures?

>> While none of the drivers (except the perf muck) actually prevents
>> userspace from fiddling with the affinity (via IRQF_NOBALANCING) a
>> deeper inspection shows that they actually might rely on the current
>> behaviour if irqbalanced is disabled. Of course every driver has its own
>> convoluted way to do that and all of those functions are well
>> documented. What a mess.
>>
>> If the hint still serves a purpose then we can provide a variant which
>> solely applies the hint and does not fiddle with the actual affinity,
>> but if the hint is useless anyway then we have a way better option to
>> clean that up.
>>
>
> +1

= 1

Thanks,

        tglx
