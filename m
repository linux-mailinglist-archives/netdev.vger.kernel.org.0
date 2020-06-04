Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD8A1EEA54
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 20:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730461AbgFDSeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 14:34:00 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:56834 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730348AbgFDSeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 14:34:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1591295640; x=1622831640;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=HTqcTU628wYZT8oBd+ArbsC8bAoTC8fUsqm9xVXgmro=;
  b=Xp9f4OPOff8jKD9jEy1DjSHAIcs2lzAnVrlmF0AHlIJCv2t4VyR2I90N
   W2uPj+W/Lk5RB/+9ORMMpEcESt24L93jfYkl583RKiRRNFX49bmz4ONaR
   B2P/P6uydCs3Meo0yV8sS5exYbOWuUKhWhAxbnRfUk0jqI/ddyiyO3P8K
   0=;
IronPort-SDR: Bp9sXjz5OL6Qmgdn1t2NjI2Ij78oRPs1ANk1UfVNxYHuSJrPGMGuWQ5o01KOARrU4ThWIT/DpG
 g10L4tLv3oVA==
X-IronPort-AV: E=Sophos;i="5.73,472,1583193600"; 
   d="scan'208";a="41639696"
Subject: Re: [PATCH 09/12] x86/xen: save and restore steal clock
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 04 Jun 2020 18:33:58 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com (Postfix) with ESMTPS id 2AEAAA22B6;
        Thu,  4 Jun 2020 18:33:56 +0000 (UTC)
Received: from EX13D08UEB004.ant.amazon.com (10.43.60.142) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 4 Jun 2020 18:33:36 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB004.ant.amazon.com (10.43.60.142) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 4 Jun 2020 18:33:36 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Thu, 4 Jun 2020 18:33:36 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id 5663D403BB; Thu,  4 Jun 2020 18:33:36 +0000 (UTC)
Date:   Thu, 4 Jun 2020 18:33:36 +0000
From:   Anchal Agarwal <anchalag@amazon.com>
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>
CC:     <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>, <x86@kernel.org>, <jgross@suse.com>,
        <linux-pm@vger.kernel.org>, <linux-mm@kvack.org>,
        <kamatam@amazon.com>, <sstabellini@kernel.org>,
        <konrad.wilk@oracle.com>, <roger.pau@citrix.com>,
        <axboe@kernel.dk>, <davem@davemloft.net>, <rjw@rjwysocki.net>,
        <len.brown@intel.com>, <pavel@ucw.cz>, <peterz@infradead.org>,
        <eduval@amazon.com>, <sblbir@amazon.com>,
        <xen-devel@lists.xenproject.org>, <vkuznets@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dwmw@amazon.co.uk>, <benh@kernel.crashing.org>,
        <anchalag@amazon.com>
Message-ID: <20200604183336.GA25251@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
References: <cover.1589926004.git.anchalag@amazon.com>
 <6f39a1594a25ab5325f34e1e297900d699cd92bf.1589926004.git.anchalag@amazon.com>
 <5edb4147-af12-3a0e-e8f7-5b72650209ac@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5edb4147-af12-3a0e-e8f7-5b72650209ac@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 30, 2020 at 07:44:06PM -0400, Boris Ostrovsky wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> 
> 
> On 5/19/20 7:28 PM, Anchal Agarwal wrote:
> > From: Munehisa Kamata <kamatam@amazon.com>
> >
> > Save steal clock values of all present CPUs in the system core ops
> > suspend callbacks. Also, restore a boot CPU's steal clock in the system
> > core resume callback. For non-boot CPUs, restore after they're brought
> > up, because runstate info for non-boot CPUs are not active until then.
> >
> > Signed-off-by: Munehisa Kamata <kamatam@amazon.com>
> > Signed-off-by: Anchal Agarwal <anchalag@amazon.com>
> > ---
> >  arch/x86/xen/suspend.c | 13 ++++++++++++-
> >  arch/x86/xen/time.c    |  3 +++
> >  2 files changed, 15 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/xen/suspend.c b/arch/x86/xen/suspend.c
> > index 784c4484100b..dae0f74f5390 100644
> > --- a/arch/x86/xen/suspend.c
> > +++ b/arch/x86/xen/suspend.c
> > @@ -91,12 +91,20 @@ void xen_arch_suspend(void)
> >  static int xen_syscore_suspend(void)
> >  {
> >       struct xen_remove_from_physmap xrfp;
> > -     int ret;
> > +     int cpu, ret;
> >
> >       /* Xen suspend does similar stuffs in its own logic */
> >       if (xen_suspend_mode_is_xen_suspend())
> >               return 0;
> >
> > +     for_each_present_cpu(cpu) {
> > +             /*
> > +              * Nonboot CPUs are already offline, but the last copy of
> > +              * runstate info is still accessible.
> > +              */
> > +             xen_save_steal_clock(cpu);
> > +     }
> > +
> >       xrfp.domid = DOMID_SELF;
> >       xrfp.gpfn = __pa(HYPERVISOR_shared_info) >> PAGE_SHIFT;
> >
> > @@ -118,6 +126,9 @@ static void xen_syscore_resume(void)
> >
> >       pvclock_resume();
> 
> 
> Doesn't make any difference but I think since this patch is where you
> are dealing with clock then pvclock_resume() should be added here and
> not in the earlier patch.
> 
> 
> -boris
I think the reason it may be in previous patch because it was a part
of syscore_resume and steal clock fix came in later. 
It could me moved to this patch that deals with all clock stuff.

-Anchal
> 
> 

> >
> > +     /* Nonboot CPUs will be resumed when they're brought up */
> > +     xen_restore_steal_clock(smp_processor_id());
> > +
> >       gnttab_resume();
> >  }
> >
> > diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
> > index c8897aad13cd..33d754564b09 100644
> > --- a/arch/x86/xen/time.c
> > +++ b/arch/x86/xen/time.c
> > @@ -545,6 +545,9 @@ static void xen_hvm_setup_cpu_clockevents(void)
> >  {
> >       int cpu = smp_processor_id();
> >       xen_setup_runstate_info(cpu);
> > +     if (cpu)
> > +             xen_restore_steal_clock(cpu);
> > +
> >       /*
> >        * xen_setup_timer(cpu) - snprintf is bad in atomic context. Hence
> >        * doing it xen_hvm_cpu_notify (which gets called by smp_init during
> 
> 
> 
