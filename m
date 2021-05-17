Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA54386B2F
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 22:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238981AbhEQUTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 16:19:47 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:55016 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238942AbhEQUTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 16:19:46 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1621282707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4CblS4NWUSycccK6+ysE1vs1G6nKpvCAliA4XuNuKT4=;
        b=sZEsINB9gW9rWKIThv/nJUQdVS0LVVxt3mk9SLmr2mnPlVG6wz5VMOrR7yTWtsO+G2D6xU
        BsKI+EgFjlUDMXiDx5ZOIVJHVJDh9digvYou8HnEtX73UoubWvL37hI5Q5gUp7X55T9mjj
        DOvrg+Fa5Cpa5GgGRmPsvz97s/IuHhEDUM7F7dXXjqJwipMa2zywAtAX872nuQ6XOq/nZK
        qFUa/G8sO96R7rbVv6P6biiiDfkCYzjDpIc1iYfmyscNYYql/ptdLI5v31jgwegubZ9sNX
        NJe6nlaunx1HUNB9R5DV7FYvBa2vEyqI/HssiVTqhgtGPdCPjCergsWkw3eF8w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1621282707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4CblS4NWUSycccK6+ysE1vs1G6nKpvCAliA4XuNuKT4=;
        b=nwXJo4JSXCjScrrvNBVQbD7dDyHa0ScZKzi1rD3hgFRAW9j4kIZ6zia4oYhFw9afxGfUeN
        THODgb+5xRdI+9CA==
To:     Robin Murphy <robin.murphy@arm.com>, Nitesh Lal <nilal@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "frederic\@kernel.org" <frederic@kernel.org>,
        "juri.lelli\@redhat.com" <juri.lelli@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, jbrandeb@kernel.org,
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
        Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH tip:irq/core v1] genirq: remove auto-set of the mask when setting the hint
In-Reply-To: <874kf1faac.ffs@nanos.tec.linutronix.de>
References: <20210501021832.743094-1-jesse.brandeburg@intel.com> <16d8ca67-30c6-bb4b-8946-79de8629156e@arm.com> <20210504092340.00006c61@intel.com> <CAFki+LmR-o+Fng21ggy48FUX7RhjjpjO87dn3Ld+L4BK2pSRZg@mail.gmail.com> <bf1d4892-0639-0bbf-443e-ba284a8ed457@arm.com> <87sg2lz0zz.ffs@nanos.tec.linutronix.de> <d1d5e797-49ee-4968-88c6-c07119343492@arm.com> <874kf1faac.ffs@nanos.tec.linutronix.de>
Date:   Mon, 17 May 2021 22:18:27 +0200
Message-ID: <87sg2ldsh8.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 17 2021 at 21:08, Thomas Gleixner wrote:
> On Mon, May 17 2021 at 19:50, Robin Murphy wrote:
>> On 2021-05-17 19:08, Thomas Gleixner wrote:
>>> On Mon, May 17 2021 at 18:26, Robin Murphy wrote:
>>>> On 2021-05-17 17:57, Nitesh Lal wrote:
>>>> I'm not implying that there isn't a bug, or that this code ever made
>>>> sense in the first place, just that fixing it will unfortunately be a
>>>> bit more involved than a simple revert. This patch as-is *will* subtly
>>>> break at least the system PMU drivers currently using
>>> 
>>> s/using/abusing/
>>> 
>>>> irq_set_affinity_hint() - those I know require the IRQ affinity to
>>>> follow whichever CPU the PMU context is bound to, in order to meet perf
>>>> core's assumptions about mutual exclusion.
>>> 
>>> Which driver is that?
>>
>> Right now, any driver which wants to control an IRQ's affinity and also 
>> build as a module, for one thing. I'm familiar with drivers/perf/ where 
>> a basic pattern has been widely copied;
>
> Bah. Why the heck can't people talk and just go and rumage until they
> find something which hopefully does what they want...
>
> The name of that function should have rang all alarm bells...

Aside of that all the warnings around the return value are useless cargo
cult. Why?

The only reason why this function returns an error code is when there is
no irq descriptor assigned to the interrupt number, which is well close
to impossible in that context.

But it does _NOT_ return an error when the actual affinity setting
fails...

Thanks,

        tglx
