Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D496383DB3
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 21:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235119AbhEQTpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 15:45:13 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:54724 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234820AbhEQTpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 15:45:12 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1621280634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TN3eCy4K3v+FJgfvmzzc0Rr5EDmqsacmFrs0RMJDVzU=;
        b=GMYgkfTvzOMMSYG9Z5Kji7SNPPQjvR1SKqkMheQ6jKoITXDpRcEdvARxgbXnKTWYkntFHj
        BUIU7NV37f613bfJ4PeoRd7NpKwCWOBtaLEzt8p7y8nZCm/Ifltx+SkLgVpeVyW2hGOtHW
        PfYX3ELXMcstAsw3RMrFuK8ZrhC1PrkdnJCiscbgMyIQ5UImP6GfQucc89ZNoPa6z8jJui
        FimZKiy4fnQJ/X8Y4hOJsLqOmLCIj3Yb9S/polhLWIj8LTk91yjIDmtqsfq1eplvo/qY4K
        EbjLDncfAPa28ZTl+7yPnazbGGM+iGGsYbJvYsu2ov+ftPq+wCMJfeRaz+D/nA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1621280634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TN3eCy4K3v+FJgfvmzzc0Rr5EDmqsacmFrs0RMJDVzU=;
        b=3ZyX7mXAoc/FzM/YFz4cWDS/4vd5Id0khZi3a2JYcqlfmTT9UfJfYFndAYNdZJb4+iWbnS
        41OIcwEdsCM+biBg==
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
Date:   Mon, 17 May 2021 21:43:54 +0200
Message-ID: <871ra5f8n9.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 17 2021 at 21:08, Thomas Gleixner wrote:
> On Mon, May 17 2021 at 19:50, Robin Murphy wrote:
>> some of the callers in other subsystems appear to *expect* it to set
>> the underlying affinity as well, but whether any of those added within
>> the last 6 years represent a functional dependency rather than just a
>> performance concern I don't know.
>
> Sigh. Let me do yet another tree wide audit...

It's clearly only the perf muck which has a functional dependency.

None of the other usage sites has IRQF_NOBALANCING set which clearly
makes this a hint because user space can freely muck with the affinity.

Thanks,

        tglx



