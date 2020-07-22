Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE57F229377
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 10:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730284AbgGVI14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 04:27:56 -0400
Received: from esa3.hc3370-68.iphmx.com ([216.71.145.155]:43850 "EHLO
        esa3.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729946AbgGVI1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 04:27:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1595406476;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=FN40+KHzDRqn99k21tmlYB+H9TCBGBR1w3tvJcN9Tgs=;
  b=cYGQklK5OJcdqGfhVG/S/3cufajSRbOFRUfQQLa3TCpzos4ukgypGEBn
   Eg1L30ggqyBKuSKpzlhqE//n0ii5AgdcqF+pJBVd5SRYPzD7JuxukI+78
   HCQIezx4M+cWLF4AfkwJ2AiwIcsWAOnwqh2ec3qVNTRjI8INjRN/z8JEr
   s=;
Authentication-Results: esa3.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none
IronPort-SDR: mlqzl0cWqd5gabQyWtfyst+GqUDqk2plDTUvwmrYJ8XALOOL3c4pwsZ14wIgTuqSOrWdAsqabU
 U3z4rBnJN46Le58mC9XaMMoAN3S3s0bqLbgiivLfDLVwkpF/RX2WQDULvW4T8zVE5XCVH++AU3
 OUWlO6ngvCzlLeLZixzTsry09fylayuaS5boFcXYZna62kTmuNMGKttp0dIuWif7hkABJgwyxK
 ikPkcGIF9TKekbeq9FWw+LIYJMaFgyhyMnNs+N/qmuLzuxVJUkXnzCjftz5DjOIOBeOWFolL+4
 yw4=
X-SBRS: 2.7
X-MesageID: 22916032
X-Ironport-Server: esa3.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.75,381,1589256000"; 
   d="scan'208";a="22916032"
Date:   Wed, 22 Jul 2020 10:27:46 +0200
From:   Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
To:     Anchal Agarwal <anchalag@amazon.com>
CC:     <marmarek@invisiblethingslab.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>, <x86@kernel.org>, <jgross@suse.com>,
        <linux-pm@vger.kernel.org>, <linux-mm@kvack.org>,
        <kamatam@amazon.com>, <sstabellini@kernel.org>,
        <konrad.wilk@oracle.com>, <axboe@kernel.dk>, <davem@davemloft.net>,
        <rjw@rjwysocki.net>, <len.brown@intel.com>, <pavel@ucw.cz>,
        <peterz@infradead.org>, <eduval@amazon.com>, <sblbir@amazon.com>,
        <xen-devel@lists.xenproject.org>, <vkuznets@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dwmw@amazon.co.uk>, <benh@kernel.crashing.org>
Subject: Re: [PATCH v2 01/11] xen/manage: keep track of the on-going suspend
 mode
Message-ID: <20200722082746.GS7191@Air-de-Roger>
References: <20200702182136.GA3511@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <50298859-0d0e-6eb0-029b-30df2a4ecd63@oracle.com>
 <20200715204943.GB17938@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <0ca3c501-e69a-d2c9-a24c-f83afd4bdb8c@oracle.com>
 <20200717191009.GA3387@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <5464f384-d4b4-73f0-d39e-60ba9800d804@oracle.com>
 <20200720093705.GG7191@Air-de-Roger>
 <20200721001736.GB19610@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <20200721083018.GM7191@Air-de-Roger>
 <20200721195509.GA14682@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200721195509.GA14682@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
X-ClientProxiedBy: AMSPEX02CAS02.citrite.net (10.69.22.113) To
 AMSPEX02CL02.citrite.net (10.69.22.126)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 21, 2020 at 07:55:09PM +0000, Anchal Agarwal wrote:
> On Tue, Jul 21, 2020 at 10:30:18AM +0200, Roger Pau Monné wrote:
> > CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> > 
> > 
> > 
> > Marek: I'm adding you in case you could be able to give this a try and
> > make sure it doesn't break suspend for dom0.
> > 
> > On Tue, Jul 21, 2020 at 12:17:36AM +0000, Anchal Agarwal wrote:
> > > On Mon, Jul 20, 2020 at 11:37:05AM +0200, Roger Pau Monné wrote:
> > > > CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> > > >
> > > >
> > > >
> > > > On Sat, Jul 18, 2020 at 09:47:04PM -0400, Boris Ostrovsky wrote:
> > > > > (Roger, question for you at the very end)
> > > > >
> > > > > On 7/17/20 3:10 PM, Anchal Agarwal wrote:
> > > > > > On Wed, Jul 15, 2020 at 05:18:08PM -0400, Boris Ostrovsky wrote:
> > > > > >> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> > > > > >>
> > > > > >>
> > > > > >>
> > > > > >> On 7/15/20 4:49 PM, Anchal Agarwal wrote:
> > > > > >>> On Mon, Jul 13, 2020 at 11:52:01AM -0400, Boris Ostrovsky wrote:
> > > > > >>>> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> > > > > >>>>
> > > > > >>>>
> > > > > >>>>
> > > > > >>>> On 7/2/20 2:21 PM, Anchal Agarwal wrote:
> > > > > >>>> And PVH dom0.
> > > > > >>> That's another good use case to make it work with however, I still
> > > > > >>> think that should be tested/worked upon separately as the feature itself
> > > > > >>> (PVH Dom0) is very new.
> > > > > >>
> > > > > >> Same question here --- will this break PVH dom0?
> > > > > >>
> > > > > > I haven't tested it as a part of this series. Is that a blocker here?
> > > > >
> > > > >
> > > > > I suspect dom0 will not do well now as far as hibernation goes, in which
> > > > > case you are not breaking anything.
> > > > >
> > > > >
> > > > > Roger?
> > > >
> > > > I sadly don't have any box ATM that supports hibernation where I
> > > > could test it. We have hibernation support for PV dom0, so while I
> > > > haven't done anything specific to support or test hibernation on PVH
> > > > dom0 I would at least aim to not make this any worse, and hence the
> > > > check should at least also fail for a PVH dom0?
> > > >
> > > > if (!xen_hvm_domain() || xen_initial_domain())
> > > >     return -ENODEV;
> > > >
> > > > Ie: none of this should be applied to a PVH dom0, as it doesn't have
> > > > PV devices and hence should follow the bare metal device suspend.
> > > >
> > > So from what I understand you meant for any guest running on pvh dom0 should not
> > > hibernate if hibernation is triggered from within the guest or should they?
> > 
> > Er no to both I think. What I meant is that a PVH dom0 should be able
> > to properly suspend, and we should make sure this work doesn't make
> > this any harder (or breaks it if it's currently working).
> > 
> > Or at least that's how I understood the question raised by Boris.
> > 
> > You are adding code to the generic suspend path that's also used by dom0
> > in order to perform bare metal suspension. This is fine now for a PV
> > dom0 because the code is gated on xen_hvm_domain, but you should also
> > take into account that a PVH dom0 is considered a HVM domain, and
> > hence will get the notifier registered.
> >
> Ok that makes sense now. This is good to be safe, but my patch series is only to
> support domU hibernation, so I am not sure if this will affect pvh dom0.
> However, since I do not have a good way of testing sure I will add the check.
> 
> Moreover, in Patch-0004, I do register suspend/resume syscore_ops specifically for domU
> hibernation only if its xen_hvm_domain.

So if the hooks are only registered for domU, do you still need this
xen_hvm_domain check here?

I have to admit I'm not familiar with Linux PM suspend.

> I don't see any reason that should not
> be registered for domU's running on pvh dom0.

To be clear: it should be registered for all HVM domUs, regardless of
whether they are running on a PV or a PVH dom0. My intention was never
to suggest otherwise. It should be enabled for all HVM domUs, but
shouldn't be enabled for HVM dom0.

> Those suspend/resume callbacks will
> only be invoked in case hibernation and will be skipped if generic suspend path
> is in progress. Do you see any issue with that?

No, I think it's fine.

Roger.
