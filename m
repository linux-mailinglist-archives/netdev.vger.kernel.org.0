Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A154138D009
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 23:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbhEUVqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 17:46:40 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:56566 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhEUVqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 17:46:39 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1621633514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XaPyYtGVTJJud1M86TNOLs+rsQI2Kj9lnXY3H+cu/B0=;
        b=GWPNOh34mwS1P2HssdlKXWYC2cb0/7ReSUe88lhO6VM4W67K+8jaNdN8J1QWRZKOCLZLek
        obNhTVmcA5eECX4vLfE+2ewnqfM/obokPSvUsKqeHpp2FNJlJFkezOS+ankHC3USbbYBhO
        JxOmEOXlZgcrwxQx2MO2bpdr3TzCJ4gwjrOtRz4xqLIgIXC9EW4tufADmasY68QKks/eBk
        oHkXV0k9J2uwivI0KgsTFxkCMCQfVmuu6GRr9USMiKFNX0/uB2UqPIF+ycpUjf8Dw/DxRH
        vBzB05qF5vJ/LYbp39ehcGCxW3E1AgdJw9h8vZTc6eP8x5PGBx+YOCtWarNtVg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1621633514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XaPyYtGVTJJud1M86TNOLs+rsQI2Kj9lnXY3H+cu/B0=;
        b=ys1EeWOdNdNZ7QDxXGBp6GDvs0ZkBupG3nrlJ/lE35qgxunHJzjnNadxRQswz2zQMVaPrI
        8Tsdrf+ncPocWqCA==
To:     Lijun Pan <lijunp213@gmail.com>
Cc:     Nitesh Lal <nilal@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, jbrandeb@kernel.org,
        "frederic\@kernel.org" <frederic@kernel.org>,
        "juri.lelli\@redhat.com" <juri.lelli@redhat.com>,
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
        Neil Horman <nhorman@tuxdriver.com>, pjwaskiewicz@gmail.com
Subject: Re: [PATCH] genirq: Provide new interfaces for affinity hints
In-Reply-To: <CAOhMmr6p2a=Dgz3Q=cbEoXJjbBjBdJm1Vwt60Si+JDCdbOEVaw@mail.gmail.com>
References: <20210504092340.00006c61@intel.com> <87pmxpdr32.ffs@nanos.tec.linutronix.de> <CAFki+Lkjn2VCBcLSAfQZ2PEkx-TR0Ts_jPnK9b-5ne3PUX37TQ@mail.gmail.com> <87im3gewlu.ffs@nanos.tec.linutronix.de> <CAFki+L=gp10W1ygv7zdsee=BUGpx9yPAckKr7pyo=tkFJPciEg@mail.gmail.com> <CAFki+L=eQoMq+mWhw_jVT-biyuDXpxbXY5nO+F6HvCtpbG9V2w@mail.gmail.com> <CAFki+LkB1sk3mOv4dd1D-SoPWHOs28ZwN-PqL_6xBk=Qkm40Lw@mail.gmail.com> <87zgwo9u79.ffs@nanos.tec.linutronix.de> <87wnrs9tvp.ffs@nanos.tec.linutronix.de> <CAOhMmr6p2a=Dgz3Q=cbEoXJjbBjBdJm1Vwt60Si+JDCdbOEVaw@mail.gmail.com>
Date:   Fri, 21 May 2021 23:45:14 +0200
Message-ID: <87eedzahhx.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 21 2021 at 10:45, Lijun Pan wrote:
> On Fri, May 21, 2021 at 7:48 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>> +/**
>> + * irq_update_affinity_hint - Update the affinity hint
>> + * @irq:       Interrupt to update
>> + * @cpumask:   cpumask pointer (NULL to clear the hint)
>> + *
>> + * Updates the affinity hint, but does not change the affinity of the interrupt.
>> + */
>> +static inline int
>> +irq_update_affinity_hint(unsigned int irq, const struct cpumask *m)
>> +{
>> +       return __irq_apply_affinity_hint(irq, m, true);
>> +}
>
> Should it be:
> return __irq_apply_affinity_hint(irq, m, false);
> here?

Of course. Copy & Pasta should be forbidden.

Thanks for spotting it!

       tglx
