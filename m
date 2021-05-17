Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D575B383DBF
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 21:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235292AbhEQTsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 15:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235119AbhEQTsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 15:48:32 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52D2C061573;
        Mon, 17 May 2021 12:47:15 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1621280833;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PpozXE9Eg8reNXM2Sd0imFqDURR7dGqzmLBtJPdjcXE=;
        b=WT4bXOeoC+ZgH20z5dJSPmzeEJizXclBOtClrdp4waF8XiJ9eYKKO5ZVSjO8HKNDaJbHjJ
        /GamRxcZTVMMTAms7SqJ+UGZ47Dy8vjlNjJaiycBChJ4rUZBTSYim17/iPesXu5KwJVj4E
        G/e7XtdXD0HRyELDnIdr0iy/Ncen4MzYCCgHLcJeGusokoXbQnni2QFIz6UwCVcBh9dpCE
        3sraYiKeMQERVsEnhLvAEVsQpsw3l9H2O1YT2po81RmZzrFPBVEEGvYaQBrOpONU5S3qB4
        ybNFo1I235w7fAAh0/sXOlMH5G6zncY6opF8A5dUrRdayHcgVd0+GmZzbdhyYw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1621280833;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PpozXE9Eg8reNXM2Sd0imFqDURR7dGqzmLBtJPdjcXE=;
        b=4GxHSpNZswHYqUYSoeQLyu68tGD1lxN1swfD+vqX8hilV/B9yRXxT8SOH0B7kuSEayiXCI
        AQwV0hZYJX2NtIDg==
To:     Nitesh Lal <nilal@redhat.com>, Robin Murphy <robin.murphy@arm.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "frederic\@kernel.org" <frederic@kernel.org>,
        "juri.lelli\@redhat.com" <juri.lelli@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
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
In-Reply-To: <CAFki+L=LDizBJmFUieMDg9J=U6mn6XxTPPkAaWiyppTouTzaqw@mail.gmail.com>
References: <20210501021832.743094-1-jesse.brandeburg@intel.com> <16d8ca67-30c6-bb4b-8946-79de8629156e@arm.com> <20210504092340.00006c61@intel.com> <CAFki+LmR-o+Fng21ggy48FUX7RhjjpjO87dn3Ld+L4BK2pSRZg@mail.gmail.com> <bf1d4892-0639-0bbf-443e-ba284a8ed457@arm.com> <CAFki+L=LDizBJmFUieMDg9J=U6mn6XxTPPkAaWiyppTouTzaqw@mail.gmail.com>
Date:   Mon, 17 May 2021 21:47:12 +0200
Message-ID: <87y2cddtxb.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nitesh,

On Mon, May 17 2021 at 14:21, Nitesh Lal wrote:
> On Mon, May 17, 2021 at 1:26 PM Robin Murphy <robin.murphy@arm.com> wrote:
>
> We can use irq_set_affinity() to set the hint mask as well, however, maybe
> there is a specific reason behind separating those two in the
> first place (maybe not?).

Yes, because kernel side settings might overwrite the hint.

> But even in this case, we have to either modify the PMU drivers' IRQs
> affinity from the userspace or we will have to make changes in the existing
> request_irq code path.

Adjusting them from user space does not work for various reasons,
especially CPU hotplug.

> I am not sure about the latter because we already have the required controls
> to adjust the device IRQ mask (by using default_smp_affinity or by modifying
> them manually).

default_smp_affinity does not help at all and there is nothing a module
can modify manually.

I'll send out a patch series which cleans that up soon.

Thanks,

        tglx


