Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE5A2243E3
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 21:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728573AbgGQTKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 15:10:35 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:58472 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728182AbgGQTKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 15:10:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1595013033; x=1626549033;
  h=date:from:to:cc:message-id:references:mime-version:
   content-transfer-encoding:in-reply-to:subject;
  bh=JXEp3fu4ueKSPTL/aTTxogwWbfIdE4zKSLg5x2ylncA=;
  b=qFWB9M0p4V9EPFUX9w3CtmL975Re8xUfeScpOkbW6oj2DTGFjPIHiIMR
   GADrCHxJI1cPfotygfYbnRJ/COloPrZfb1ZMYfW/sFDnXT5cFzuud0rta
   2eyL3KD/Cvwb7/O/h0iya5YppUjJHaaNB/F4sTcRYTLJgxf514RxfGnFB
   8=;
IronPort-SDR: B7g8C+O+44k2rWyS1+qLZ7Ril88L7euUS5PHylv/wSxXaBC1vnDAauj2J020dgzo+5pOznIGT3
 9bsyqNana+Aw==
X-IronPort-AV: E=Sophos;i="5.75,364,1589241600"; 
   d="scan'208";a="42640067"
Subject: Re: [PATCH v2 01/11] xen/manage: keep track of the on-going suspend mode
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 17 Jul 2020 19:10:32 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com (Postfix) with ESMTPS id D73BFA20E1;
        Fri, 17 Jul 2020 19:10:24 +0000 (UTC)
Received: from EX13D08UEE003.ant.amazon.com (10.43.62.118) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 17 Jul 2020 19:10:09 +0000
Received: from EX13MTAUEA002.ant.amazon.com (10.43.61.77) by
 EX13D08UEE003.ant.amazon.com (10.43.62.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 17 Jul 2020 19:10:09 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.61.169) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Fri, 17 Jul 2020 19:10:09 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id 3826A56980; Fri, 17 Jul 2020 19:10:09 +0000 (UTC)
Date:   Fri, 17 Jul 2020 19:10:09 +0000
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
        <dwmw@amazon.co.uk>, <benh@kernel.crashing.org>
Message-ID: <20200717191009.GA3387@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
References: <cover.1593665947.git.anchalag@amazon.com>
 <20200702182136.GA3511@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <50298859-0d0e-6eb0-029b-30df2a4ecd63@oracle.com>
 <20200715204943.GB17938@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <0ca3c501-e69a-d2c9-a24c-f83afd4bdb8c@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0ca3c501-e69a-d2c9-a24c-f83afd4bdb8c@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 05:18:08PM -0400, Boris Ostrovsky wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> 
> 
> On 7/15/20 4:49 PM, Anchal Agarwal wrote:
> > On Mon, Jul 13, 2020 at 11:52:01AM -0400, Boris Ostrovsky wrote:
> >> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> >>
> >>
> >>
> >> On 7/2/20 2:21 PM, Anchal Agarwal wrote:
> >>> +
> >>> +bool xen_is_xen_suspend(void)
> >>
> >> Weren't you going to call this pv suspend? (And also --- is this suspend
> >> or hibernation? Your commit messages and cover letter talk about fixing
> >> hibernation).
> >>
> >>
> > This is for hibernation is for pvhvm/hvm/pv-on-hvm guests as you may call it.
> > The method is just there to check if "xen suspend" is in progress.
> > I do not see "xen_suspend" differentiating between pv or hvm
> > domain until later in the code hence, I abstracted it to xen_is_xen_suspend.
> 
> 
> I meant "pv suspend" in the sense that this is paravirtual suspend, not
> suspend for paravirtual guests. Just like pv drivers are for both pv and
> hvm guests.
> 
> 
> And then --- should it be pv suspend or pv hibernation?
> 
>
Ok so I think I am lot confused by this question. Here is what this
function for, function xen_is_xen_suspend() just tells us whether 
the guest is in "SHUTDOWN_SUSPEND" state or not. This check is needed
for correct invocation of syscore_ops callbacks registered for guest's
hibernation and for xenbus to invoke respective callbacks[suspend/resume
vs freeze/thaw/restore].
Since "shutting_down" state is defined static and is not directly available
to other parts of the code, the function solves the purpose.

I am having hard time understanding why this should be called pv
suspend/hibernation unless you are suggesting something else?
Am I missing your point here? 
> 
> >>> +{
> >>> +     return suspend_mode == XEN_SUSPEND;
> >>> +}
> >>> +
> >>
> >> +static int xen_setup_pm_notifier(void)
> >> +{
> >> +     if (!xen_hvm_domain())
> >> +             return -ENODEV;
> >>
> >> I forgot --- what did we decide about non-x86 (i.e. ARM)?
> > It would be great to support that however, its  out of
> > scope for this patch set.
> > I’ll be happy to discuss it separately.
> 
> 
> I wasn't implying that this *should* work on ARM but rather whether this
> will break ARM somehow (because xen_hvm_domain() is true there).
> 
> 
Ok makes sense. TBH, I haven't tested this part of code on ARM and the series
was only support x86 guests hibernation.
Moreover, this notifier is there to distinguish between 2 PM
events PM SUSPEND and PM hibernation. Now since we only care about PM
HIBERNATION I may just remove this code and rely on "SHUTDOWN_SUSPEND" state.
However, I may have to fix other patches in the series where this check may
appear and cater it only for x86 right?
> 
> >>
> >> And PVH dom0.
> > That's another good use case to make it work with however, I still
> > think that should be tested/worked upon separately as the feature itself
> > (PVH Dom0) is very new.
> 
> 
> Same question here --- will this break PVH dom0?
> 
I haven't tested it as a part of this series. Is that a blocker here?
> 
Thanks,
Anchal
> -boris
> 
> 
