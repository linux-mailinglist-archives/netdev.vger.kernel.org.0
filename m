Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E915626AC14
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 20:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbgIOSer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 14:34:47 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:61422 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727958AbgIOSMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 14:12:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1600193525; x=1631729525;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=lGH087KRAdN2IAz1zJ/C61BaTYeYAAq4piRhMy/XWkM=;
  b=oZpp8s4IOoj/KhC4s8tl2zDcLr+7qKBK7NGvxOegFqIKh5tSGijHrLoY
   cpkEYBwJODN6GYM86bMxPGRdDw9qqbU6v+/jEohDD2zEVRs4zLFrhRS0h
   EQO0MkWbNIL2r5DKJiJJaiRXLe11ucthm1n7SmPNQ29uqP+5vqhW9sBSv
   s=;
X-IronPort-AV: E=Sophos;i="5.76,430,1592870400"; 
   d="scan'208";a="68218795"
Subject: Re: [PATCH v3 01/11] xen/manage: keep track of the on-going suspend mode
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-87a10be6.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 15 Sep 2020 18:01:41 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-87a10be6.us-west-2.amazon.com (Postfix) with ESMTPS id 82565A069E;
        Tue, 15 Sep 2020 18:01:38 +0000 (UTC)
Received: from EX13D05UWC002.ant.amazon.com (10.43.162.92) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 15 Sep 2020 18:00:56 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D05UWC002.ant.amazon.com (10.43.162.92) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 15 Sep 2020 18:00:55 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Tue, 15 Sep 2020 18:00:55 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id A746640269; Tue, 15 Sep 2020 18:00:55 +0000 (UTC)
Date:   Tue, 15 Sep 2020 18:00:55 +0000
From:   Anchal Agarwal <anchalag@amazon.com>
To:     <boris.ostrovsky@oracle.com>
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
Message-ID: <20200915180055.GB19975@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
References: <cover.1598042152.git.anchalag@amazon.com>
 <9b970e12491107afda0c1d4a6f154b52d90346ac.1598042152.git.anchalag@amazon.com>
 <4b2bbc8b-7817-271a-4ff0-5ee5df956049@oracle.com>
 <20200914214754.GA19975@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <e9b94104-d20a-b6b2-cbe0-f79b1ed09c98@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e9b94104-d20a-b6b2-cbe0-f79b1ed09c98@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 08:24:22PM -0400, boris.ostrovsky@oracle.com wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> 
> 
> On 9/14/20 5:47 PM, Anchal Agarwal wrote:
> > On Sun, Sep 13, 2020 at 11:43:30AM -0400, boris.ostrovsky@oracle.com wrote:
> >> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> >>
> >>
> >>
> >> On 8/21/20 6:25 PM, Anchal Agarwal wrote:
> >>> Though, accquirng pm_mutex is still right thing to do, we may
> >>> see deadlock if PM hibernation is interrupted by Xen suspend.
> >>> PM hibernation depends on xenwatch thread to process xenbus state
> >>> transactions, but the thread will sleep to wait pm_mutex which is
> >>> already held by PM hibernation context in the scenario. Xen shutdown
> >>> code may need some changes to avoid the issue.
> >>
> >>
> >> Is it Xen's shutdown or suspend code that needs to address this? (Or I
> >> may not understand what the problem is that you are describing)
> >>
> > Its Xen suspend code I think. If we do not take the system_transition_mutex
> > in do_suspend then if hibernation is triggered in parallel to xen suspend there
> > could be issues.
> 
> 
> But you *are* taking this mutex to avoid this exact race, aren't you?
yes, in that case this race should not occur and either one of it should fail
gracefully.
> 
> 
> > Now this is still theoretical in my case and I havent been able
> > to reproduce such a race. So the approach the original author took was to take
> > this lock which to me seems right.
> > And its Xen suspend and not Xen Shutdown. So basically if this scenario
> > happens I am of the view one of other will fail to occur then how do we recover
> > or avoid this at all.
> >
> > Does that answer your question?
> >
> 
> 
> >>> +
> >>> +static int xen_setup_pm_notifier(void)
> >>> +{
> >>> +     if (!xen_hvm_domain() || xen_initial_domain())
> >>> +             return -ENODEV;
> >>
> >> I don't think this works anymore.
> > What do you mean?
> > The first check is for xen domain types and other is for architecture support.
> > The reason I put this check here is because I wanted to segregate the two.
> > I do not want to register this notifier at all for !hmv guest and also if its
> > an initial control domain.
> > The arm check only lands in notifier because once hibernate() api is called ->
> > calls pm_notifier_call_chain for PM_HIBERNATION_PREPARE this will fail for
> > aarch64.
> > Once we have support for aarch64 this notifier can go away altogether.
> >
> > Is there any other reason I may be missing why we should move this check to
> > notifier?
> 
> 
> Not registering this notifier is equivalent to having it return NOTIFY_OK.
>
How is that different from current behavior?
> 
> In your earlier versions just returning NOTIFY_OK was not sufficient for
> hibernation to proceed since the notifier would also need to set
> suspend_mode appropriately. But now your notifier essentially filters
> out unsupported configurations. And so if it is not called your
> configuration (e.g. PV domain) will be considered supported.
> 
I am sorry if I am having a bit of hard time understanding this. 
How will it be considered supported when its not even registered? My
understanding is if its not registered, it will not land in notifier call chain
which is invoked in pm_notifier_call_chain().

As Roger, mentioned in last series none of this should be a part of PVH dom0 
hibernation as its not tested but this series should also not break anything.
If I register this notifier for PVH dom0 and return error later that will alter
the current behavior right?

If a pm_notifier for pvh dom0 is not registered then it will not land in the
notifier call chain and system will work as before this series.
If I look for unsupported configurations, then !hvm domain is also one but we
filter that out at the beginning and don't even bother about it.

Unless you mean guest running VMs itself? [Trying to read between the lines may
not be the case though]
> 
> >> In the past your notifier would set suspend_mode (or something) but now
> >> it really doesn't do anything except reports an error in some (ARM) cases.
> >>
> >> So I think you should move this check into the notifier.
> >> (And BTW I still think PM_SUSPEND_PREPARE should return an error too.
> >> The fact that we are using "suspend" in xen routine names is irrelevant)
> >>
> > I may have send "not-updated" version of the notifier's function change.
> >
> > +    switch (pm_event) {
> > +       case PM_HIBERNATION_PREPARE:
> > +        /* Guest hibernation is not supported for aarch64 currently*/
> > +        if (IS_ENABLED(CONFIG_ARM64)) {
> > +             ret = NOTIFY_BAD;
> > +             break;
> > +     }
> > +       case PM_RESTORE_PREPARE:
> > +       case PM_POST_RESTORE:
> > +       case PM_POST_HIBERNATION:
> > +       default:
> > +           ret = NOTIFY_OK;
> > +    }
> 
> 
> There is no difference on x86 between this code and what you sent
> earlier. In both instances PM_SUSPEND_PREPARE will return NOTIFY_OK.
> 
> 
> On ARM this code will allow suspend to proceed (which is not what we want).
> 
Ok, I think I may have overlooked arm code. I will fix that.
> 
> -boris
> 
Thanks,
Anchal
> 
> >
> > With the above path PM_SUSPEND_PREPARE will go all together. Does that
> > resolves this issue? I wanted to get rid of all SUSPEND_* as they are not needed
> > here clearly.
> > The only reason I kept it there is if someone tries to trigger hibernation on
> > ARM instances they should get an error. As I am not sure about the current
> > behavior. There may be a better way to not invoke hibernation on ARM DomU's and
> > get rid of this block all together.
> >
> > Again, sorry for sending in the half baked fix. My workspace switch may have
> > caused the error.
> >>
> >>
> >> -boris
> >>
> > Anchal
> >>
> >>> +     return register_pm_notifier(&xen_pm_notifier_block);
> >>> +}
> >>> +
