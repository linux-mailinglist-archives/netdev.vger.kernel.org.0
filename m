Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CECF138C613
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 13:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233754AbhEUL5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 07:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233431AbhEUL5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 07:57:35 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B40EC061574;
        Fri, 21 May 2021 04:56:12 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1621598170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mkWCZPQm4Sq8eRx/19smgC/LUP5WutmsllFmC78x3iM=;
        b=jrrijcDW62qctMPrxCPXE+I3Q90yWYLVqGQ/yxRh12V/HvAA4nCM4b766r4kA8aSn4+W6E
        SnRcFBlQvE0mrX89gDciuHuQz771KRrNl1rzuPHyZ7IOQOKeKFvJjJI/wOkLb6sDJpvn9q
        TgadlGc0X/rM2/PgucKpLTCyxxYD915Z+IIh5R86eu4bzWFOfnGAlLAdiRl+7RS8wzUa4O
        zUy3nLU2rk9dFpcvjfjfPfe15jnqoj9aLPNzfzFFf4JT5BYRKOaHYUjUsIyJwEPstKdLu1
        8o9h1bEaNR5IEyG46taJYm8nVwLh9LGpPGvwj9eMvzQn3aSouG7k+mhy6HNnPQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1621598170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mkWCZPQm4Sq8eRx/19smgC/LUP5WutmsllFmC78x3iM=;
        b=pzOgjIPEze+IzdbjPO3qovTvTCQJdEkxS1LKiSfgOooS/j3Pkf4u1ZVW+rw51h6LKK/SxF
        /aR/hPOxq6scYiBg==
To:     Nitesh Lal <nilal@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
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
Subject: Re: [PATCH tip:irq/core v1] genirq: remove auto-set of the mask when setting the hint
In-Reply-To: <CAFki+LkB1sk3mOv4dd1D-SoPWHOs28ZwN-PqL_6xBk=Qkm40Lw@mail.gmail.com>
References: <20210504092340.00006c61@intel.com> <87pmxpdr32.ffs@nanos.tec.linutronix.de> <CAFki+Lkjn2VCBcLSAfQZ2PEkx-TR0Ts_jPnK9b-5ne3PUX37TQ@mail.gmail.com> <87im3gewlu.ffs@nanos.tec.linutronix.de> <CAFki+L=gp10W1ygv7zdsee=BUGpx9yPAckKr7pyo=tkFJPciEg@mail.gmail.com> <CAFki+L=eQoMq+mWhw_jVT-biyuDXpxbXY5nO+F6HvCtpbG9V2w@mail.gmail.com> <CAFki+LkB1sk3mOv4dd1D-SoPWHOs28ZwN-PqL_6xBk=Qkm40Lw@mail.gmail.com>
Date:   Fri, 21 May 2021 13:56:10 +0200
Message-ID: <87zgwo9u79.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nitesh,

On Thu, May 20 2021 at 20:03, Nitesh Lal wrote:
> On Thu, May 20, 2021 at 5:57 PM Nitesh Lal <nilal@redhat.com> wrote:
>> I think here to ensure that we are not breaking any of the drivers we have
>> to first analyze all the existing drivers and understand how they are using
>> this API.
>> AFAIK there are three possible scenarios:
>>
>> - A driver use this API to spread the IRQs
>>   + For this case we should be safe considering the spreading is naturally
>>     done from the IRQ subsystem itself.
>
> Forgot to mention another thing in the above case is to determine whether
> it is true for all architectures or not as Thomas mentioned.

Yes.

>>
>> - A driver use this API to actually set the hint
>>   + These drivers should have no functional impact because of this revert

Correct.


>> - Driver use this API to force a certain affinity mask
>>   + In this case we have to replace the API with the irq_force_affinity()

irq_set_affinity() or irq_set_affinity_and_hint()

>> I can start looking into the individual drivers, however, testing them will
>> be a challenge.

The only way to do that is to have the core infrastructure added and
then send patches changing it in the way you think. The relevant
maintainers/developers should be able to tell you when your analysis
went south. :)

Been there, done that. It's just lots of work :)

Thanks,

        tglx
