Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0A6221693
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 22:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgGOUuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 16:50:00 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:24689 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbgGOUuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 16:50:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594846198; x=1626382198;
  h=date:from:to:cc:message-id:references:mime-version:
   content-transfer-encoding:in-reply-to:subject;
  bh=Z0Bj5n1UQ2ZkITPj7VMLUCR260N7o5zgaQh0zJTjo9w=;
  b=rHcL5k2EM9ZnAeTwmLHvVfBzhBqtXI1Rl1pkYVHndn+SimCjMfAyYbvm
   LkIed8BdWvtvlWzoVFr0fnFWPLWUh51en8D7+XKd6fvXgNSA4xfxVi77k
   wcMvUuFYp8S4c/5hPcoN7ccBPq0+YxzqUPJGGK7/Td2cKpyti0+KJf3qJ
   s=;
IronPort-SDR: egCxTTQAJwMI43/0aX/z8oXu3NQj1TiM9Enuy46fU6CQHIN1t4Iofu4RMoWeW9abbFwiF0d9Lw
 DMcfZ+o0VE1A==
X-IronPort-AV: E=Sophos;i="5.75,356,1589241600"; 
   d="scan'208";a="42136950"
Subject: Re: [PATCH v2 01/11] xen/manage: keep track of the on-going suspend mode
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-119b4f96.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 15 Jul 2020 20:49:55 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-119b4f96.us-west-2.amazon.com (Postfix) with ESMTPS id 75ECA1A289B;
        Wed, 15 Jul 2020 20:49:53 +0000 (UTC)
Received: from EX13D01UWB004.ant.amazon.com (10.43.161.157) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 15 Jul 2020 20:49:44 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13d01UWB004.ant.amazon.com (10.43.161.157) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 15 Jul 2020 20:49:44 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Wed, 15 Jul 2020 20:49:43 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id A13584E7C6; Wed, 15 Jul 2020 20:49:43 +0000 (UTC)
Date:   Wed, 15 Jul 2020 20:49:43 +0000
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
Message-ID: <20200715204943.GB17938@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
References: <cover.1593665947.git.anchalag@amazon.com>
 <20200702182136.GA3511@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <50298859-0d0e-6eb0-029b-30df2a4ecd63@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50298859-0d0e-6eb0-029b-30df2a4ecd63@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 11:52:01AM -0400, Boris Ostrovsky wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> 
> 
> On 7/2/20 2:21 PM, Anchal Agarwal wrote:
> > From: Munehisa Kamata <kamatam@amazon.com>
> >
> > Guest hibernation is different from xen suspend/resume/live migration.
> > Xen save/restore does not use pm_ops as is needed by guest hibernation.
> > Hibernation in guest follows ACPI path and is guest inititated , the
> > hibernation image is saved within guest as compared to later modes
> > which are xen toolstack assisted and image creation/storage is in
> > control of hypervisor/host machine.
> > To differentiate between Xen suspend and PM hibernation, keep track
> > of the on-going suspend mode by mainly using a new PM notifier.
> > Introduce simple functions which help to know the on-going suspend mode
> > so that other Xen-related code can behave differently according to the
> > current suspend mode.
> > Since Xen suspend doesn't have corresponding PM event, its main logic
> > is modfied to acquire pm_mutex and set the current mode.
> >
> > Though, acquirng pm_mutex is still right thing to do, we may
> > see deadlock if PM hibernation is interrupted by Xen suspend.
> > PM hibernation depends on xenwatch thread to process xenbus state
> > transactions, but the thread will sleep to wait pm_mutex which is
> > already held by PM hibernation context in the scenario. Xen shutdown
> > code may need some changes to avoid the issue.
> >
> > [Anchal Agarwal: Changelog]:
> >  RFC v1->v2: Code refactoring
> >  v1->v2:     Remove unused functions for PM SUSPEND/PM hibernation
> >
> > Signed-off-by: Anchal Agarwal <anchalag@amazon.com>
> > Signed-off-by: Munehisa Kamata <kamatam@amazon.com>
> > ---
> >  drivers/xen/manage.c  | 60 +++++++++++++++++++++++++++++++++++++++++++
> >  include/xen/xen-ops.h |  1 +
> >  2 files changed, 61 insertions(+)
> >
> > diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
> > index cd046684e0d1..69833fd6cfd1 100644
> > --- a/drivers/xen/manage.c
> > +++ b/drivers/xen/manage.c
> > @@ -14,6 +14,7 @@
> >  #include <linux/freezer.h>
> >  #include <linux/syscore_ops.h>
> >  #include <linux/export.h>
> > +#include <linux/suspend.h>
> >
> >  #include <xen/xen.h>
> >  #include <xen/xenbus.h>
> > @@ -40,6 +41,20 @@ enum shutdown_state {
> >  /* Ignore multiple shutdown requests. */
> >  static enum shutdown_state shutting_down = SHUTDOWN_INVALID;
> >
> > +enum suspend_modes {
> > +     NO_SUSPEND = 0,
> > +     XEN_SUSPEND,
> > +     PM_HIBERNATION,
> > +};
> > +
> > +/* Protected by pm_mutex */
> > +static enum suspend_modes suspend_mode = NO_SUSPEND;
> > +
> > +bool xen_is_xen_suspend(void)
> 
> 
> Weren't you going to call this pv suspend? (And also --- is this suspend
> or hibernation? Your commit messages and cover letter talk about fixing
> hibernation).
> 
> 
This is for hibernation is for pvhvm/hvm/pv-on-hvm guests as you may call it.
The method is just there to check if "xen suspend" is in progress.
I do not see "xen_suspend" differentiating between pv or hvm
domain until later in the code hence, I abstracted it to xen_is_xen_suspend.
> > +{
> > +     return suspend_mode == XEN_SUSPEND;
> > +}
> > +
> 
> 
> 
> > +
> > +static int xen_pm_notifier(struct notifier_block *notifier,
> > +                     unsigned long pm_event, void *unused)
> > +{
> > +     switch (pm_event) {
> > +     case PM_SUSPEND_PREPARE:
> > +     case PM_HIBERNATION_PREPARE:
> > +     case PM_RESTORE_PREPARE:
> > +             suspend_mode = PM_HIBERNATION;
> 
> 
> Do you ever use this mode? It seems to me all you care about is whether
> or not we are doing XEN_SUSPEND. And so perhaps suspend_mode could
> become a boolean. And then maybe even drop it altogether because it you
> should be able to key off (shutting_down == SHUTDOWN_SUSPEND).
> 
> 
The mode was left there in case its needed for restore prepare cases. But you
are right the only thing I currently care about whether shutting_down ==
SHUTDOWN_SUSPEND. Infact, the notifier may not be needed in first place.
xen_is_xen_suspend could work right off the bat using 'shutting_down' variable
itself. *I think so* I will test it on my end and send an updated patch.
> > +             break;
> > +     case PM_POST_SUSPEND:
> > +     case PM_POST_RESTORE:
> > +     case PM_POST_HIBERNATION:
> > +             /* Set back to the default */
> > +             suspend_mode = NO_SUSPEND;
> > +             break;
> > +     default:
> > +             pr_warn("Receive unknown PM event 0x%lx\n", pm_event);
> > +             return -EINVAL;
> > +     }
> > +
> > +     return 0;
> > +};
> 
> 
> 
> > +static int xen_setup_pm_notifier(void)
> > +{
> > +     if (!xen_hvm_domain())
> > +             return -ENODEV;
> 
> 
> I forgot --- what did we decide about non-x86 (i.e. ARM)?
It would be great to support that however, its  out of
scope for this patch set.
I’ll be happy to discuss it separately.
> 
> 
> And PVH dom0.
That's another good use case to make it work with however, I still
think that should be tested/worked upon separately as the feature itself
(PVH Dom0) is very new.
> 
> 
Thanks,
Anchal
> -boris
> 
> 
> 
