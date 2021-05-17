Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C679383BEB
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 20:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236922AbhEQSKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 14:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbhEQSKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 14:10:07 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B482EC061573;
        Mon, 17 May 2021 11:08:50 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1621274929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CvTjUMP0IFpl0qRUVo9p7Gf+50VNC5rcsZbQA53CimU=;
        b=Ey7OfTMIuqEtByYZx90mXd53djFEoEu8K6IQPlvipZNXg5ghONNRHkNCn3ng4fZHJ14yVJ
        GJFvsrF4jaDT1+cvSLA20ljvzp6GSJku4d78C4Cl9fB+KBVB6k3f9aAEbnFAygXcIBDtoa
        dZQSyUeukUjJ+r7QVVaTL2WMe2VWaCxzYKzcGwcQEKSHyNyhpuw482nShODXmgnLX53zj0
        FNDDJY5gMC1aK6TVCRecA6Mj0F9fHIdZGSDYxUF0THBl2/Qu2LsiPsOHutrwBUp5iHhR+W
        ShmIS0ZMS9bRH5pEk0GZOCGZBu3XBYTzL065HM+NcjX/kLs6ukQ09rczJrw+Ig==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1621274929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CvTjUMP0IFpl0qRUVo9p7Gf+50VNC5rcsZbQA53CimU=;
        b=nwk42rkPCNh3s3mfln/GYYElC6A2IeHtvkPV0s3OY/6QuCU3sny3CL8c02/ZY3eO7ySjyt
        gJbDII33Hb8QQmAg==
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
In-Reply-To: <bf1d4892-0639-0bbf-443e-ba284a8ed457@arm.com>
References: <20210501021832.743094-1-jesse.brandeburg@intel.com> <16d8ca67-30c6-bb4b-8946-79de8629156e@arm.com> <20210504092340.00006c61@intel.com> <CAFki+LmR-o+Fng21ggy48FUX7RhjjpjO87dn3Ld+L4BK2pSRZg@mail.gmail.com> <bf1d4892-0639-0bbf-443e-ba284a8ed457@arm.com>
Date:   Mon, 17 May 2021 20:08:48 +0200
Message-ID: <87sg2lz0zz.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 17 2021 at 18:26, Robin Murphy wrote:
> On 2021-05-17 17:57, Nitesh Lal wrote:
> I'm not implying that there isn't a bug, or that this code ever made 
> sense in the first place, just that fixing it will unfortunately be a 
> bit more involved than a simple revert. This patch as-is *will* subtly 
> break at least the system PMU drivers currently using

s/using/abusing/

> irq_set_affinity_hint() - those I know require the IRQ affinity to 
> follow whichever CPU the PMU context is bound to, in order to meet perf 
> core's assumptions about mutual exclusion.

Which driver is that?

Thanks,

        tglx
