Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A8D22736C
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 02:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgGUAEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 20:04:13 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:53722 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbgGUAEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 20:04:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1595289851; x=1626825851;
  h=date:from:to:cc:message-id:references:mime-version:
   content-transfer-encoding:in-reply-to:subject;
  bh=UsYCfB4vUXuGXUfz5NputLMtDzKXoyLRAcqjcS/oV1U=;
  b=EPr5X1FakCSP6fTwJXDPetnCGx/ufkrJ1vh3jhtR4X9D30jTM0JUjcTn
   C7qk/dcrnQBOoB+o0dsOj83R5D4UFv4dv8NcG345Yti99/gMqT+xJr3zV
   dYR/aBZwjF8ci9z2lJ0/aX2TLwmcWhTeXGJhLYhS01xwl6eHxrioX4yJr
   M=;
IronPort-SDR: tZK50MAqoODz1iBYxa4vWL5exodTTwRmcIhymTRjjXO2FMSE1DvQe+l0hCyjOlwb8BWlXHn/1m
 DLjLzCD/UXHg==
X-IronPort-AV: E=Sophos;i="5.75,375,1589241600"; 
   d="scan'208";a="53134259"
Subject: Re: [PATCH v2 01/11] xen/manage: keep track of the on-going suspend mode
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 21 Jul 2020 00:04:07 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id EECCBA1D1D;
        Tue, 21 Jul 2020 00:04:00 +0000 (UTC)
Received: from EX13D08UEE004.ant.amazon.com (10.43.62.182) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Jul 2020 00:03:48 +0000
Received: from EX13MTAUEA002.ant.amazon.com (10.43.61.77) by
 EX13D08UEE004.ant.amazon.com (10.43.62.182) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Jul 2020 00:03:48 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.61.169) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Tue, 21 Jul 2020 00:03:48 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id 16C9240844; Tue, 21 Jul 2020 00:03:48 +0000 (UTC)
Date:   Tue, 21 Jul 2020 00:03:48 +0000
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
Message-ID: <20200721000348.GA19610@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
References: <cover.1593665947.git.anchalag@amazon.com>
 <20200702182136.GA3511@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <50298859-0d0e-6eb0-029b-30df2a4ecd63@oracle.com>
 <20200715204943.GB17938@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <0ca3c501-e69a-d2c9-a24c-f83afd4bdb8c@oracle.com>
 <20200717191009.GA3387@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <5464f384-d4b4-73f0-d39e-60ba9800d804@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5464f384-d4b4-73f0-d39e-60ba9800d804@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 18, 2020 at 09:47:04PM -0400, Boris Ostrovsky wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> 
> 
> (Roger, question for you at the very end)
> 
> On 7/17/20 3:10 PM, Anchal Agarwal wrote:
> > On Wed, Jul 15, 2020 at 05:18:08PM -0400, Boris Ostrovsky wrote:
> >> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> >>
> >>
> >>
> >> On 7/15/20 4:49 PM, Anchal Agarwal wrote:
> >>> On Mon, Jul 13, 2020 at 11:52:01AM -0400, Boris Ostrovsky wrote:
> >>>> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> >>>>
> >>>>
> >>>>
> >>>> On 7/2/20 2:21 PM, Anchal Agarwal wrote:
> >>>>> +
> >>>>> +bool xen_is_xen_suspend(void)
> >>>> Weren't you going to call this pv suspend? (And also --- is this suspend
> >>>> or hibernation? Your commit messages and cover letter talk about fixing
> >>>> hibernation).
> >>>>
> >>>>
> >>> This is for hibernation is for pvhvm/hvm/pv-on-hvm guests as you may call it.
> >>> The method is just there to check if "xen suspend" is in progress.
> >>> I do not see "xen_suspend" differentiating between pv or hvm
> >>> domain until later in the code hence, I abstracted it to xen_is_xen_suspend.
> >>
> >> I meant "pv suspend" in the sense that this is paravirtual suspend, not
> >> suspend for paravirtual guests. Just like pv drivers are for both pv and
> >> hvm guests.
> >>
> >>
> >> And then --- should it be pv suspend or pv hibernation?
> >>
> >>
> > Ok so I think I am lot confused by this question. Here is what this
> > function for, function xen_is_xen_suspend() just tells us whether
> > the guest is in "SHUTDOWN_SUSPEND" state or not. This check is needed
> > for correct invocation of syscore_ops callbacks registered for guest's
> > hibernation and for xenbus to invoke respective callbacks[suspend/resume
> > vs freeze/thaw/restore].
> > Since "shutting_down" state is defined static and is not directly available
> > to other parts of the code, the function solves the purpose.
> >
> > I am having hard time understanding why this should be called pv
> > suspend/hibernation unless you are suggesting something else?
> > Am I missing your point here?
> 
> 
> 
> I think I understand now what you are trying to say --- it's whether we
> are going to use xen_suspend() routine, right? If that's the case then
> sure, you can use "xen_suspend" term. (I'd probably still change
> xen_is_xen_suspend() to is_xen_suspend())
>
I think so too. Will change it.
> 
> >>>>> +{
> >>>>> +     return suspend_mode == XEN_SUSPEND;
> >>>>> +}
> >>>>> +
> >>>> +static int xen_setup_pm_notifier(void)
> >>>> +{
> >>>> +     if (!xen_hvm_domain())
> >>>> +             return -ENODEV;
> >>>>
> >>>> I forgot --- what did we decide about non-x86 (i.e. ARM)?
> >>> It would be great to support that however, its  out of
> >>> scope for this patch set.
> >>> I’ll be happy to discuss it separately.
> >>
> >> I wasn't implying that this *should* work on ARM but rather whether this
> >> will break ARM somehow (because xen_hvm_domain() is true there).
> >>
> >>
> > Ok makes sense. TBH, I haven't tested this part of code on ARM and the series
> > was only support x86 guests hibernation.
> > Moreover, this notifier is there to distinguish between 2 PM
> > events PM SUSPEND and PM hibernation. Now since we only care about PM
> > HIBERNATION I may just remove this code and rely on "SHUTDOWN_SUSPEND" state.
> > However, I may have to fix other patches in the series where this check may
> > appear and cater it only for x86 right?
> 
> 
> I don't know what would happen if ARM guest tries to handle hibernation
> callbacks. The only ones that you are introducing are in block and net
> fronts and that's arch-independent.
> 
> 
> You do add a bunch of x86-specific code though (syscore ops), would
> something similar be needed for ARM?
> 
> 
I don't expect this to work out of the box on ARM. To start with something
similar will be needed for ARM too.
We may still want to keep the driver code as-is.

I understand the concern here wrt ARM, however, currently the support is only
proposed for x86 guests here and similar work could be carried out for ARM.
Also, if regular hibernation works correctly on arm, then all is needed is to
fix Xen side of things.

I am not sure what could be done to achieve any assurances on arm side as far as
this series is concerned.
> >>>> And PVH dom0.
> >>> That's another good use case to make it work with however, I still
> >>> think that should be tested/worked upon separately as the feature itself
> >>> (PVH Dom0) is very new.
> >>
> >> Same question here --- will this break PVH dom0?
> >>
> > I haven't tested it as a part of this series. Is that a blocker here?
> 
> 
> I suspect dom0 will not do well now as far as hibernation goes, in which
> case you are not breaking anything.
> 
> 
> Roger?
> 
> 
> -boris

Thanks,
Anchal
> 
> 
> 
