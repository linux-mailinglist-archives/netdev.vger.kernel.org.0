Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF40B16B435
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 23:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbgBXWlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 17:41:11 -0500
Received: from mga14.intel.com ([192.55.52.115]:51792 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbgBXWlL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 17:41:11 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Feb 2020 14:41:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,481,1574150400"; 
   d="scan'208";a="260493792"
Received: from wtczc53028gn.jf.intel.com (HELO skl-build) ([10.54.87.17])
  by fmsmga004.fm.intel.com with ESMTP; 24 Feb 2020 14:41:09 -0800
Date:   Mon, 24 Feb 2020 14:40:59 -0800
From:   "Christopher S. Hall" <christopher.s.hall@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@redhat.com, x86@kernel.org,
        jacob.e.keller@intel.com, richardcochran@gmail.com,
        davem@davemloft.net, sean.v.kelley@intel.com
Subject: Re: [Intel PMC TGPIO Driver 0/5] Add support for Intel PMC Time GPIO
 Driver with PHC interface changes to support additional H/W Features
Message-ID: <20200224224059.GC1508@skl-build>
References: <20191211214852.26317-1-christopher.s.hall@intel.com>
 <87eevf4hnq.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eevf4hnq.fsf@nanos.tec.linutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for reviewing.

On Fri, Jan 31, 2020 at 07:14:49PM +0100, Thomas Gleixner wrote:
> christopher.s.hall@intel.com writes:
> > From: Christopher Hall <christopher.s.hall@intel.com>
> >
> > The TGPIO hardware doesn't implement interrupts. For TGPIO input, the
> > output edge-timestamp API is re-used to implement a user-space polling
> > interface. For periodic input (e.g. PPS) this is fairly efficient,
> > requiring only a marginally faster poll rate than the input event
> > frequency.
> 
> I really have a hard time to understand why this is implemented as part
> of PTP while you talk about PPS at the same time.

We primarily need support for periodic input and output uses cases.
Apologies for omitting the periodic output use case from the cover
letter. While TGPIO isn't associated with a PTP timestamp clock, the PHC
pin/clock interface fits the usage otherwise.

The PHC periodic output API is the closest fit for periodic output without
creating a new API. The PHC interface can also register as a PPS source. I
am, however, concerned in general about implementing PPS input in the
driver because the hardware doesn't implement interrupts - requiring
polling.

> Proper information about why this approach was chosen and what that
> magic device is used for would be really helpful.

The customer requested usages are 1 kHz and 1 Hz for both input and
output. Some higher level use cases are:
- using a GPS PPS signal to sync the system clock
- auditing timesync precision for financial services, especially high
	frequency trading (e.g. MiFID).

Apart from clock import/export applications, timestamping single I/O
events are potentially valuable for industrial control applications
(e.g. motor position sensing vs. time). As time sync precision
requirements for these applications are tightened, standard GPIO
timing precision will not be good enough.

> Thanks,
> 
>         tglx

Thanks,
Christopher
