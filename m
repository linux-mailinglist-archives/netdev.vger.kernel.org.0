Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAAFB225BCD
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 11:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbgGTJhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 05:37:14 -0400
Received: from esa4.hc3370-68.iphmx.com ([216.71.155.144]:60760 "EHLO
        esa4.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727062AbgGTJhO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 05:37:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1595237833;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nwPJa3NUFyEUiPP7p8oQoME8KchN1Curaq49nRiJSr0=;
  b=fYMwKP8cenGPoU7mH9agCOVNlbUNuqtl+b/h67ELLn2z49ebvGng8oJ2
   3uqQwOJ0cjk33uoNIULdGigKi6PU3/ilTjaQ9JflnIuX7KWFwKDk4GxCi
   yGoIqY01MIY8rv4EVbQrwxaRWx3U5golWH8mIAx1jCiZ6uZMPx1PmzNdE
   4=;
Authentication-Results: esa4.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none
IronPort-SDR: 4hmgLSfnkocyYHfNLmECegraULYWfvgO+2ir3ZYwO5eOasBTEYVWmVfPwW4mzeVVL17AAtcZVd
 bUVOns9d+KznUSTWedAW/WhA4LDQ6fI22ZVr7E0i6W1qt7UqqwxosEHno3/M1gQyUdpcDOjoqF
 Nj70/QuhTm+JOMOwc9sysRtdWdhiTtL0p7pcoHDnQAPgaCsxfhMhr0r+0WqS9xxrS3GSrFbPO0
 NyjgT8OXTOod2Cdp5jysswqlD0JX8QMphFc9cBJwZ90Kl5ucVrm3e0q6KBg1OKyPj5+tG+RRay
 t54=
X-SBRS: 2.7
X-MesageID: 23586900
X-Ironport-Server: esa4.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.75,374,1589256000"; 
   d="scan'208";a="23586900"
Date:   Mon, 20 Jul 2020 11:37:05 +0200
From:   Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>
CC:     Anchal Agarwal <anchalag@amazon.com>, <tglx@linutronix.de>,
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
Message-ID: <20200720093705.GG7191@Air-de-Roger>
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
In-Reply-To: <5464f384-d4b4-73f0-d39e-60ba9800d804@oracle.com>
X-ClientProxiedBy: AMSPEX02CAS01.citrite.net (10.69.22.112) To
 AMSPEX02CL02.citrite.net (10.69.22.126)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 18, 2020 at 09:47:04PM -0400, Boris Ostrovsky wrote:
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

I sadly don't have any box ATM that supports hibernation where I
could test it. We have hibernation support for PV dom0, so while I
haven't done anything specific to support or test hibernation on PVH
dom0 I would at least aim to not make this any worse, and hence the
check should at least also fail for a PVH dom0?

if (!xen_hvm_domain() || xen_initial_domain())
    return -ENODEV;

Ie: none of this should be applied to a PVH dom0, as it doesn't have
PV devices and hence should follow the bare metal device suspend.

Also I would contact the QubesOS guys, they rely heavily on the
suspend feature for dom0, and that's something not currently tested by
osstest so any breakages there go unnoticed.

Thanks, Roger.
