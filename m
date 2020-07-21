Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546032273A7
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 02:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbgGUASC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 20:18:02 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:7466 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbgGUASB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 20:18:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1595290681; x=1626826681;
  h=date:from:to:cc:message-id:references:mime-version:
   content-transfer-encoding:in-reply-to:subject;
  bh=q1CNBzpRhN4Mc4ypaHePuk74XZdBFhC4bG3j6hSGqx4=;
  b=HUVmIBL6J/Qk+c/dC5DKNb/lZHrGeTB/nN457NNpGsTKSUilN2I0DBAb
   4X4MeiPl6WvUK+oDiizQVCF69cs7Px+UTRjmDPmzFIIUaQIjzWu5GQ3I8
   uN9gPO7Ztjfc7NTf1CgSS9Eu4NjoTmjrQ2RaTVc6ogOL0bpaSyrFQCjDK
   4=;
IronPort-SDR: G2GXoAb+f4TN0NyhO0C8Og8NIHK2YxFNqEXDyAHtEtY+mbXOxHH+4fC2M/p5JlcPh2j5NAouPF
 /BfqN6WyTTjw==
X-IronPort-AV: E=Sophos;i="5.75,375,1589241600"; 
   d="scan'208";a="42970481"
Subject: Re: [PATCH v2 01/11] xen/manage: keep track of the on-going suspend mode
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 21 Jul 2020 00:18:00 +0000
Received: from EX13MTAUEB002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com (Postfix) with ESMTPS id 7324CA1F8C;
        Tue, 21 Jul 2020 00:17:53 +0000 (UTC)
Received: from EX13D08UEB004.ant.amazon.com (10.43.60.142) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Jul 2020 00:17:36 +0000
Received: from EX13MTAUEA002.ant.amazon.com (10.43.61.77) by
 EX13D08UEB004.ant.amazon.com (10.43.60.142) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Jul 2020 00:17:36 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.61.169) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Tue, 21 Jul 2020 00:17:36 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id 192FC40712; Tue, 21 Jul 2020 00:17:36 +0000 (UTC)
Date:   Tue, 21 Jul 2020 00:17:36 +0000
From:   Anchal Agarwal <anchalag@amazon.com>
To:     Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
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
Message-ID: <20200721001736.GB19610@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
References: <cover.1593665947.git.anchalag@amazon.com>
 <20200702182136.GA3511@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <50298859-0d0e-6eb0-029b-30df2a4ecd63@oracle.com>
 <20200715204943.GB17938@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <0ca3c501-e69a-d2c9-a24c-f83afd4bdb8c@oracle.com>
 <20200717191009.GA3387@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <5464f384-d4b4-73f0-d39e-60ba9800d804@oracle.com>
 <20200720093705.GG7191@Air-de-Roger>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200720093705.GG7191@Air-de-Roger>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 11:37:05AM +0200, Roger Pau Monné wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> 
> 
> On Sat, Jul 18, 2020 at 09:47:04PM -0400, Boris Ostrovsky wrote:
> > (Roger, question for you at the very end)
> >
> > On 7/17/20 3:10 PM, Anchal Agarwal wrote:
> > > On Wed, Jul 15, 2020 at 05:18:08PM -0400, Boris Ostrovsky wrote:
> > >> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> > >>
> > >>
> > >>
> > >> On 7/15/20 4:49 PM, Anchal Agarwal wrote:
> > >>> On Mon, Jul 13, 2020 at 11:52:01AM -0400, Boris Ostrovsky wrote:
> > >>>> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> > >>>>
> > >>>>
> > >>>>
> > >>>> On 7/2/20 2:21 PM, Anchal Agarwal wrote:
> > >>>> And PVH dom0.
> > >>> That's another good use case to make it work with however, I still
> > >>> think that should be tested/worked upon separately as the feature itself
> > >>> (PVH Dom0) is very new.
> > >>
> > >> Same question here --- will this break PVH dom0?
> > >>
> > > I haven't tested it as a part of this series. Is that a blocker here?
> >
> >
> > I suspect dom0 will not do well now as far as hibernation goes, in which
> > case you are not breaking anything.
> >
> >
> > Roger?
> 
> I sadly don't have any box ATM that supports hibernation where I
> could test it. We have hibernation support for PV dom0, so while I
> haven't done anything specific to support or test hibernation on PVH
> dom0 I would at least aim to not make this any worse, and hence the
> check should at least also fail for a PVH dom0?
> 
> if (!xen_hvm_domain() || xen_initial_domain())
>     return -ENODEV;
> 
> Ie: none of this should be applied to a PVH dom0, as it doesn't have
> PV devices and hence should follow the bare metal device suspend.
>
So from what I understand you meant for any guest running on pvh dom0 should not 
hibernate if hibernation is triggered from within the guest or should they?

> Also I would contact the QubesOS guys, they rely heavily on the
> suspend feature for dom0, and that's something not currently tested by
> osstest so any breakages there go unnoticed.
> 
Was this for me or Boris? If its the former then I have no idea how to?
> Thanks, Roger.

Thanks,
Anchal
