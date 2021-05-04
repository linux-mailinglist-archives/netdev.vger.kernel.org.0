Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7EB372DFC
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 18:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbhEDQYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 12:24:53 -0400
Received: from mga06.intel.com ([134.134.136.31]:14634 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231523AbhEDQYu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 May 2021 12:24:50 -0400
IronPort-SDR: S7GzuyjM0h0T2FEtGKyuYvVsvIbUQ+8Pv5cQAbtI9qBh4iort3XhBBEz46S8AHuw/t9L2f79VP
 0jbVIZPzNNNA==
X-IronPort-AV: E=McAfee;i="6200,9189,9974"; a="259304421"
X-IronPort-AV: E=Sophos;i="5.82,272,1613462400"; 
   d="scan'208";a="259304421"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2021 09:23:43 -0700
IronPort-SDR: vLlO0j58OwQgXggWIakS23Ay15238a3Ro6s4OpOioQ5Q/+qno9o+z6NbFaXenSUN7rRTcZ6f0T
 A7wKxJPEXxVg==
X-IronPort-AV: E=Sophos;i="5.82,272,1613462400"; 
   d="scan'208";a="429121950"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.209.83.22])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2021 09:23:41 -0700
Date:   Tue, 4 May 2021 09:23:40 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, <linux-kernel@vger.kernel.org>,
        <intel-wired-lan@lists.osuosl.org>, <jbrandeb@kernel.org>,
        "frederic@kernel.org" <frederic@kernel.org>,
        "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, <abelits@marvell.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "rppt@linux.vnet.ibm.com" <rppt@linux.vnet.ibm.com>,
        "jinyuqi@huawei.com" <jinyuqi@huawei.com>,
        "zhangshaokun@hisilicon.com" <zhangshaokun@hisilicon.com>,
        <netdev@vger.kernel.org>, <chris.friesen@windriver.com>,
        Nitesh Lal <nilal@redhat.com>, Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH tip:irq/core v1] genirq: remove auto-set of the mask
 when setting the hint
Message-ID: <20210504092340.00006c61@intel.com>
In-Reply-To: <16d8ca67-30c6-bb4b-8946-79de8629156e@arm.com>
References: <20210501021832.743094-1-jesse.brandeburg@intel.com>
        <16d8ca67-30c6-bb4b-8946-79de8629156e@arm.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Robin Murphy wrote:

> On 2021-05-01 03:18, Jesse Brandeburg wrote:
> > It was pointed out by Nitesh that the original work I did in 2014
> > to automatically set the interrupt affinity when requesting a
> > mask is no longer necessary. The kernel has moved on and no
> > longer has the original problem, BUT the original patch
> > introduced a subtle bug when booting a system with reserved or
> > excluded CPUs. Drivers calling this function with a mask value
> > that included a CPU that was currently or in the future
> > unavailable would generally not update the hint.
> > 
> > I'm sure there are a million ways to solve this, but the simplest
> > one is to just remove a little code that tries to force the
> > affinity, as Nitesh has shown it fixes the bug and doesn't seem
> > to introduce immediate side effects.
> 
> Unfortunately, I think there are quite a few other drivers now relying 
> on this behaviour, since they are really using irq_set_affinity_hint() 
> as a proxy for irq_set_affinity(). Partly since the latter isn't 
> exported to modules, but also I have a vague memory of it being said 
> that it's nice to update the user-visible hint to match when the 
> affinity does have to be forced to something specific.
> 
> Robin.

Thanks for your feedback Robin, but there is definitely a bug here that
is being exposed by this code. The fact that people are using this
function means they're all exposed to this bug.

Not sure if you saw, but this analysis from Nitesh explains what
happened chronologically to the kernel w.r.t this code, it's a useful
analysis! [1]

I'd add in addition that irqbalance daemon *stopped* paying attention
to hints quite a while ago, so I'm not quite sure what purpose they
serve.

[1]
https://lore.kernel.org/lkml/CAFki+Lm0W_brLu31epqD3gAV+WNKOJfVDfX2M8ZM__aj3nv9uA@mail.gmail.com/

