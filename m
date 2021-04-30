Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7A6370063
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 20:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbhD3SW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 14:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbhD3SWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 14:22:25 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC67C06174A;
        Fri, 30 Apr 2021 11:21:37 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1619806893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=As7DtcWhMuF7h0TJSZIn85h3WNKtXg9d7v6tEvOH+qs=;
        b=Hf0zeuoMznsXlwihwhVMhTEAKd/4k0Ku0M8qkgHH8iMN7iFVDrrBrlgDLNn/uPoy1iKACk
        iV7CRZB9Ietru5dVJrPzai9l+ANGERnoM8JgXjnkJPawpmserZobzznAl4wU8HbP20NjTi
        gRqE9n6dM5ioAwOCZzVGZkF7OsPPc/k3SqU4YMn9gzpCgcbhffPUGSRy5PXGDSRcu5/oUG
        wMHNT2SxUnZSEpx3ujEh29oxbC6yg30BKCWoswhigidBvafirSYlgeZ/dMOPKhz0vEmMTg
        dznmUDpTXBgikHUhP3rSy7pyiXwMs922CziEhTbkikOCwWL8a0FjSqJ788N/7g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1619806893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=As7DtcWhMuF7h0TJSZIn85h3WNKtXg9d7v6tEvOH+qs=;
        b=FfdE0kUFkRqEf4ebx700jPou/iScTJY9te1G3qeOnRcZC57twD9Fxky/GZRsh+TKE1KvJx
        INh75Tmvp3C5AmBA==
To:     Nitesh Lal <nilal@redhat.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "frederic\@kernel.org" <frederic@kernel.org>,
        "juri.lelli\@redhat.com" <juri.lelli@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, abelits@marvell.com,
        Robin Murphy <robin.murphy@arm.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api\@vger.kernel.org" <linux-api@vger.kernel.org>,
        "bhelgaas\@google.com" <bhelgaas@google.com>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "rostedt\@goodmis.org" <rostedt@goodmis.org>,
        "mingo\@kernel.org" <mingo@kernel.org>,
        "peterz\@infradead.org" <peterz@infradead.org>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,
        "sfr\@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "stephen\@networkplumber.org" <stephen@networkplumber.org>,
        "rppt\@linux.vnet.ibm.com" <rppt@linux.vnet.ibm.com>,
        "jinyuqi\@huawei.com" <jinyuqi@huawei.com>,
        "zhangshaokun\@hisilicon.com" <zhangshaokun@hisilicon.com>,
        netdev@vger.kernel.org, chris.friesen@windriver.com
Subject: Re: [Patch v4 1/3] lib: Restrict cpumask_local_spread to houskeeping CPUs
In-Reply-To: <CAFki+LmmRyvOkWoNNLk5JCwtaTnabyaRUKxnS+wyAk_kj8wzyw@mail.gmail.com>
References: <20200625223443.2684-1-nitesh@redhat.com> <3e9ce666-c9cd-391b-52b6-3471fe2be2e6@arm.com> <20210127121939.GA54725@fuller.cnet> <87r1m5can2.fsf@nanos.tec.linutronix.de> <20210128165903.GB38339@fuller.cnet> <87h7n0de5a.fsf@nanos.tec.linutronix.de> <20210204181546.GA30113@fuller.cnet> <cfa138e9-38e3-e566-8903-1d64024c917b@redhat.com> <20210204190647.GA32868@fuller.cnet> <d8884413-84b4-b204-85c5-810342807d21@redhat.com> <87y2g26tnt.fsf@nanos.tec.linutronix.de> <d0aed683-87ae-91a2-d093-de3f5d8a8251@redhat.com> <7780ae60-efbd-2902-caaa-0249a1f277d9@redhat.com> <07c04bc7-27f0-9c07-9f9e-2d1a450714ef@redhat.com> <20210406102207.0000485c@intel.com> <1a044a14-0884-eedb-5d30-28b4bec24b23@redhat.com> <20210414091100.000033cf@intel.com> <54ecc470-b205-ea86-1fc3-849c5b144b3b@redhat.com> <CAFki+Lm0W_brLu31epqD3gAV+WNKOJfVDfX2M8ZM__aj3nv9uA@mail.gmail.com> <87czucfdtf.ffs@nanos.tec.linutronix.de> <CAFki+LmmRyvOkWoNNLk5JCwtaTnabyaRUKxnS+wyAk_kj8wzyw@mail.gmail.com>
Date:   Fri, 30 Apr 2021 20:21:33 +0200
Message-ID: <87sg37eiqa.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nitesh,

On Fri, Apr 30 2021 at 12:14, Nitesh Lal wrote:
> Based on this analysis and the fact that with your re-work the interrupts
> seems to be naturally spread across the CPUs, will it be safe to revert
> Jesse's patch
>
> e2e64a932 genirq: Set initial affinity in irq_set_affinity_hint()
>
> as it overwrites the previously set IRQ affinity mask for some of the
> devices?

That's a good question. My gut feeling says yes.

> IMHO if we think that this patch is still solving some issue other than
> what Jesse has mentioned then perhaps we should reproduce that and fix it
> directly from the request_irq code path.

Makes sense.

Thanks,

        tglx
