Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF72D22B9D7
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 00:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgGWW6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 18:58:09 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:45185 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbgGWW6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 18:58:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1595545086; x=1627081086;
  h=date:from:to:cc:message-id:references:mime-version:
   content-transfer-encoding:in-reply-to:subject;
  bh=y+Ab+qpN+drP51OsAVzLhFNy+EV/cJUJK2AzFsvossY=;
  b=Q7k60bnGU9kk5Tdk9XgUbkFaaO8mXV0lPem+hleZJctIBDXgtGGBNHlR
   4IREheUs4YRzU1a6GeXsCuJ1dHgQQ/RN7ldElzKPBoxYepm3cSwBmT1GL
   V2yMAZW3DwFkIq9WhOlj5H0VJmslDY6KM4t/RZgZA68kAeJhpZ8hpULdV
   A=;
IronPort-SDR: dA+OGJwBfOOYugAkt1GR7i4MLo/b/uzrQfkdodJW7nqunoIzxIwSDzciIPUnI8o7Bc2FoRcL7e
 1mgdgdge/NFQ==
X-IronPort-AV: E=Sophos;i="5.75,388,1589241600"; 
   d="scan'208";a="43610901"
Subject: Re: [PATCH v2 01/11] xen/manage: keep track of the on-going suspend mode
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 23 Jul 2020 22:58:05 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id D35D6A1FB9;
        Thu, 23 Jul 2020 22:57:58 +0000 (UTC)
Received: from EX13D08UEE003.ant.amazon.com (10.43.62.118) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 23 Jul 2020 22:57:45 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D08UEE003.ant.amazon.com (10.43.62.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 23 Jul 2020 22:57:45 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Thu, 23 Jul 2020 22:57:45 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id 5F7384CA2B; Thu, 23 Jul 2020 22:57:45 +0000 (UTC)
Date:   Thu, 23 Jul 2020 22:57:45 +0000
From:   Anchal Agarwal <anchalag@amazon.com>
To:     Stefano Stabellini <sstabellini@kernel.org>
CC:     Boris Ostrovsky <boris.ostrovsky@oracle.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>,
        <x86@kernel.org>, <jgross@suse.com>, <linux-pm@vger.kernel.org>,
        <linux-mm@kvack.org>, <kamatam@amazon.com>,
        <konrad.wilk@oracle.com>, <roger.pau@citrix.com>,
        <axboe@kernel.dk>, <davem@davemloft.net>, <rjw@rjwysocki.net>,
        <len.brown@intel.com>, <pavel@ucw.cz>, <peterz@infradead.org>,
        <eduval@amazon.com>, <sblbir@amazon.com>,
        <xen-devel@lists.xenproject.org>, <vkuznets@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dwmw@amazon.co.uk>, <benh@kernel.crashing.org>
Message-ID: <20200723225745.GB32316@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
References: <50298859-0d0e-6eb0-029b-30df2a4ecd63@oracle.com>
 <20200715204943.GB17938@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <0ca3c501-e69a-d2c9-a24c-f83afd4bdb8c@oracle.com>
 <20200717191009.GA3387@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <5464f384-d4b4-73f0-d39e-60ba9800d804@oracle.com>
 <20200721000348.GA19610@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <408d3ce9-2510-2950-d28d-fdfe8ee41a54@oracle.com>
 <alpine.DEB.2.21.2007211640500.17562@sstabellini-ThinkPad-T480s>
 <20200722180229.GA32316@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <alpine.DEB.2.21.2007221645430.17562@sstabellini-ThinkPad-T480s>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.21.2007221645430.17562@sstabellini-ThinkPad-T480s>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 04:49:16PM -0700, Stefano Stabellini wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> 
> 
> On Wed, 22 Jul 2020, Anchal Agarwal wrote:
> > On Tue, Jul 21, 2020 at 05:18:34PM -0700, Stefano Stabellini wrote:
> > > On Tue, 21 Jul 2020, Boris Ostrovsky wrote:
> > > > >>>>>> +static int xen_setup_pm_notifier(void)
> > > > >>>>>> +{
> > > > >>>>>> +     if (!xen_hvm_domain())
> > > > >>>>>> +             return -ENODEV;
> > > > >>>>>>
> > > > >>>>>> I forgot --- what did we decide about non-x86 (i.e. ARM)?
> > > > >>>>> It would be great to support that however, its  out of
> > > > >>>>> scope for this patch set.
> > > > >>>>> I’ll be happy to discuss it separately.
> > > > >>>>
> > > > >>>> I wasn't implying that this *should* work on ARM but rather whether this
> > > > >>>> will break ARM somehow (because xen_hvm_domain() is true there).
> > > > >>>>
> > > > >>>>
> > > > >>> Ok makes sense. TBH, I haven't tested this part of code on ARM and the series
> > > > >>> was only support x86 guests hibernation.
> > > > >>> Moreover, this notifier is there to distinguish between 2 PM
> > > > >>> events PM SUSPEND and PM hibernation. Now since we only care about PM
> > > > >>> HIBERNATION I may just remove this code and rely on "SHUTDOWN_SUSPEND" state.
> > > > >>> However, I may have to fix other patches in the series where this check may
> > > > >>> appear and cater it only for x86 right?
> > > > >>
> > > > >>
> > > > >> I don't know what would happen if ARM guest tries to handle hibernation
> > > > >> callbacks. The only ones that you are introducing are in block and net
> > > > >> fronts and that's arch-independent.
> > > > >>
> > > > >>
> > > > >> You do add a bunch of x86-specific code though (syscore ops), would
> > > > >> something similar be needed for ARM?
> > > > >>
> > > > >>
> > > > > I don't expect this to work out of the box on ARM. To start with something
> > > > > similar will be needed for ARM too.
> > > > > We may still want to keep the driver code as-is.
> > > > >
> > > > > I understand the concern here wrt ARM, however, currently the support is only
> > > > > proposed for x86 guests here and similar work could be carried out for ARM.
> > > > > Also, if regular hibernation works correctly on arm, then all is needed is to
> > > > > fix Xen side of things.
> > > > >
> > > > > I am not sure what could be done to achieve any assurances on arm side as far as
> > > > > this series is concerned.
> > >
> > > Just to clarify: new features don't need to work on ARM or cause any
> > > addition efforts to you to make them work on ARM. The patch series only
> > > needs not to break existing code paths (on ARM and any other platforms).
> > > It should also not make it overly difficult to implement the ARM side of
> > > things (if there is one) at some point in the future.
> > >
> > > FYI drivers/xen/manage.c is compiled and working on ARM today, however
> > > Xen suspend/resume is not supported. I don't know for sure if
> > > guest-initiated hibernation works because I have not tested it.
> > >
> > >
> > >
> > > > If you are not sure what the effects are (or sure that it won't work) on
> > > > ARM then I'd add IS_ENABLED(CONFIG_X86) check, i.e.
> > > >
> > > >
> > > > if (!IS_ENABLED(CONFIG_X86) || !xen_hvm_domain())
> > > >       return -ENODEV;
> > >
> > > That is a good principle to have and thanks for suggesting it. However,
> > > in this specific case there is nothing in this patch that doesn't work
> > > on ARM. From an ARM perspective I think we should enable it and
> > > &xen_pm_notifier_block should be registered.
> > >
> > This question is for Boris, I think you we decided to get rid of the notifier
> > in V3 as all we need  to check is SHUTDOWN_SUSPEND state which sounds plausible
> > to me. So this check may go away. It may still be needed for sycore_ops
> > callbacks registration.
> > > Given that all guests are HVM guests on ARM, it should work fine as is.
> > >
> > >
> > > I gave a quick look at the rest of the series and everything looks fine
> > > to me from an ARM perspective. I cannot imaging that the new freeze,
> > > thaw, and restore callbacks for net and block are going to cause any
> > > trouble on ARM. The two main x86-specific functions are
> > > xen_syscore_suspend/resume and they look trivial to implement on ARM (in
> > > the sense that they are likely going to look exactly the same.)
> > >
> > Yes but for now since things are not tested I will put this
> > !IS_ENABLED(CONFIG_X86) on syscore_ops calls registration part just to be safe
> > and not break anything.
> > >
> > > One question for Anchal: what's going to happen if you trigger a
> > > hibernation, you have the new callbacks, but you are missing
> > > xen_syscore_suspend/resume?
> > >
> > > Is it any worse than not having the new freeze, thaw and restore
> > > callbacks at all and try to do a hibernation?
> > If callbacks are not there, I don't expect hibernation to work correctly.
> > These callbacks takes care of xen primitives like shared_info_page,
> > grant table, sched clock, runstate time which are important to save the correct
> > state of the guest and bring it back up. Other patches in the series, adds all
> > the logic to these syscore callbacks. Freeze/thaw/restore are just there for at driver
> > level.
> 
> I meant the other way around :-)  Let me rephrase the question.
> 
> Do you think that implementing freeze/thaw/restore at the driver level
> without having xen_syscore_suspend/resume can potentially make things
> worse compared to not having freeze/thaw/restore at the driver level at
> all?
I think in both the cases I don't expect it to work. System may end up in
different state if you register vs not. Hibernation does not work properly
at least for domU instances without these changes on x86 and I am assuming the
same for ARM.

If you do not register freeze/thaw/restore callbacks for arm, then on
invocation of xenbus_dev_suspend, default suspend/resume callbacks
will be called for each driver and since you do not have any code to save domU's
xen primitives state (syscore_ops), hibernation will either fail or will demand a reboot.
I do no have setup to test the current state of ARM's hibernation

If you only register freeze/thaw/restore and no syscore_ops, it will again fail.
Since, I do not have an ARM setup running, I quickly ran a similar test on x86,
may not be an apple to apple comparison but instance failed to resume or I
should say stuck showing huge jump in time and required a reboot.

Now if this doesn't happen currently when you trigger hibernation on arm domU
instances or if system is still alive when you trigger hibernation in xen guest
then not registering the callbacks may be a better idea. In that case  may be 
I need to put arch specific check when registering freeze/thaw/restore handlers.

Hope that answers your question.

Thanks,
Anchal

