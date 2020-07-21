Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD4B227AAA
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 10:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728348AbgGUIaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 04:30:30 -0400
Received: from esa1.hc3370-68.iphmx.com ([216.71.145.142]:57868 "EHLO
        esa1.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbgGUIaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 04:30:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1595320229;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=BzY2QweQF/rQiDbWv7Jn9Mmq9ZfmwWs8Ov87vMZGyUU=;
  b=EgMid7TNjyXMwcvfL5EWSkFvLKZOp3SiwIul+X1NQONWcx8nYYRaDkKT
   Yp3BqBNCq+c58oYIKa6rgy3+oVHpFi3ZKSJqKQfxjW5Bvm3XctTEoY0TN
   vWWzf4Jlovt1F4f7BUfYn07vujKfiWgiL0rWlb2KFLv5kT7+SnwNAzd63
   o=;
Authentication-Results: esa1.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none
IronPort-SDR: x0OiNrk4e0Kv/geF7/GsMS3ajUnY+7gsSFFEXbjmHoWrn0Lxe6gtvxgEn0GR/cqaG+YYQcjcmB
 y9cXZDaFN18y2oIa9h8b9NAh7AkUkC7xN6pUY0g7UBLeXlTrlJ4gdZ2eS3wMmI4P/wL7ISLp8w
 /rH69WDGB4HRSyD8Mi1RPaLwy67UwO/DxY+phNhaDtpaI/XDgb+g5Z7PhX+c3q5qRqoauEaBxR
 Eblv/h6LWWnHOFZ3YXG0BABZ9rg/RT1Z7xPJGXBV02waTGeDtwxItb0TozFEIVA2hEWlnwbpcU
 zt4=
X-SBRS: 2.7
X-MesageID: 23153757
X-Ironport-Server: esa1.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.75,378,1589256000"; 
   d="scan'208";a="23153757"
Date:   Tue, 21 Jul 2020 10:30:18 +0200
From:   Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
To:     Anchal Agarwal <anchalag@amazon.com>,
        <marmarek@invisiblethingslab.com>
CC:     Boris Ostrovsky <boris.ostrovsky@oracle.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>,
        <x86@kernel.org>, <jgross@suse.com>, <linux-pm@vger.kernel.org>,
        <linux-mm@kvack.org>, <kamatam@amazon.com>,
        <sstabellini@kernel.org>, <konrad.wilk@oracle.com>,
        <axboe@kernel.dk>, <davem@davemloft.net>, <rjw@rjwysocki.net>,
        <len.brown@intel.com>, <pavel@ucw.cz>, <peterz@infradead.org>,
        <eduval@amazon.com>, <sblbir@amazon.com>,
        <xen-devel@lists.xenproject.org>, <vkuznets@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dwmw@amazon.co.uk>, <benh@kernel.crashing.org>
Subject: Re: [PATCH v2 01/11] xen/manage: keep track of the on-going suspend
 mode
Message-ID: <20200721083018.GM7191@Air-de-Roger>
References: <cover.1593665947.git.anchalag@amazon.com>
 <20200702182136.GA3511@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <50298859-0d0e-6eb0-029b-30df2a4ecd63@oracle.com>
 <20200715204943.GB17938@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <0ca3c501-e69a-d2c9-a24c-f83afd4bdb8c@oracle.com>
 <20200717191009.GA3387@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <5464f384-d4b4-73f0-d39e-60ba9800d804@oracle.com>
 <20200720093705.GG7191@Air-de-Roger>
 <20200721001736.GB19610@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200721001736.GB19610@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
X-ClientProxiedBy: AMSPEX02CAS02.citrite.net (10.69.22.113) To
 AMSPEX02CL02.citrite.net (10.69.22.126)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marek: I'm adding you in case you could be able to give this a try and
make sure it doesn't break suspend for dom0.

On Tue, Jul 21, 2020 at 12:17:36AM +0000, Anchal Agarwal wrote:
> On Mon, Jul 20, 2020 at 11:37:05AM +0200, Roger Pau Monné wrote:
> > CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> > 
> > 
> > 
> > On Sat, Jul 18, 2020 at 09:47:04PM -0400, Boris Ostrovsky wrote:
> > > (Roger, question for you at the very end)
> > >
> > > On 7/17/20 3:10 PM, Anchal Agarwal wrote:
> > > > On Wed, Jul 15, 2020 at 05:18:08PM -0400, Boris Ostrovsky wrote:
> > > >> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> > > >>
> > > >>
> > > >>
> > > >> On 7/15/20 4:49 PM, Anchal Agarwal wrote:
> > > >>> On Mon, Jul 13, 2020 at 11:52:01AM -0400, Boris Ostrovsky wrote:
> > > >>>> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> > > >>>>
> > > >>>>
> > > >>>>
> > > >>>> On 7/2/20 2:21 PM, Anchal Agarwal wrote:
> > > >>>> And PVH dom0.
> > > >>> That's another good use case to make it work with however, I still
> > > >>> think that should be tested/worked upon separately as the feature itself
> > > >>> (PVH Dom0) is very new.
> > > >>
> > > >> Same question here --- will this break PVH dom0?
> > > >>
> > > > I haven't tested it as a part of this series. Is that a blocker here?
> > >
> > >
> > > I suspect dom0 will not do well now as far as hibernation goes, in which
> > > case you are not breaking anything.
> > >
> > >
> > > Roger?
> > 
> > I sadly don't have any box ATM that supports hibernation where I
> > could test it. We have hibernation support for PV dom0, so while I
> > haven't done anything specific to support or test hibernation on PVH
> > dom0 I would at least aim to not make this any worse, and hence the
> > check should at least also fail for a PVH dom0?
> > 
> > if (!xen_hvm_domain() || xen_initial_domain())
> >     return -ENODEV;
> > 
> > Ie: none of this should be applied to a PVH dom0, as it doesn't have
> > PV devices and hence should follow the bare metal device suspend.
> >
> So from what I understand you meant for any guest running on pvh dom0 should not 
> hibernate if hibernation is triggered from within the guest or should they?

Er no to both I think. What I meant is that a PVH dom0 should be able
to properly suspend, and we should make sure this work doesn't make
this any harder (or breaks it if it's currently working).

Or at least that's how I understood the question raised by Boris.

You are adding code to the generic suspend path that's also used by dom0
in order to perform bare metal suspension. This is fine now for a PV
dom0 because the code is gated on xen_hvm_domain, but you should also
take into account that a PVH dom0 is considered a HVM domain, and
hence will get the notifier registered.

> > Also I would contact the QubesOS guys, they rely heavily on the
> > suspend feature for dom0, and that's something not currently tested by
> > osstest so any breakages there go unnoticed.
> > 
> Was this for me or Boris? If its the former then I have no idea how to?

I've now added Marek.

Roger.
