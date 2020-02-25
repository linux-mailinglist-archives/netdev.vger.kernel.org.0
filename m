Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A782216F38A
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 00:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729331AbgBYXhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 18:37:19 -0500
Received: from mga03.intel.com ([134.134.136.65]:17968 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726827AbgBYXhT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 18:37:19 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Feb 2020 15:37:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,485,1574150400"; 
   d="scan'208";a="226519788"
Received: from wtczc53028gn.jf.intel.com (HELO skl-build) ([10.54.87.17])
  by orsmga007.jf.intel.com with ESMTP; 25 Feb 2020 15:37:17 -0800
Date:   Tue, 25 Feb 2020 15:37:07 -0800
From:   "Christopher S. Hall" <christopher.s.hall@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@zytor.com, mingo@redhat.com,
        x86@kernel.org, jacob.e.keller@intel.com, davem@davemloft.net,
        sean.v.kelley@intel.com
Subject: Re: [Intel PMC TGPIO Driver 0/5] Add support for Intel PMC Time GPIO
 Driver with PHC interface changes to support additional H/W Features
Message-ID: <20200225233707.GA32079@skl-build>
References: <20191211214852.26317-1-christopher.s.hall@intel.com>
 <20200203040838.GA5851@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203040838.GA5851@localhost>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard,

Thanks for reviewing.

On Sun, Feb 02, 2020 at 08:08:38PM -0800, Richard Cochran wrote:
> On Wed, Dec 11, 2019 at 01:48:47PM -0800, christopher.s.hall@intel.com wrote:
> > The ART frequency is not adjustable. In order, to implement output
> > adjustments an additional edge-timestamp API is added, as well, as
> > a periodic output frequency adjustment API. Togther, these implement
> > equivalent functionality to the existing SYS_OFFSET_* and frequency
> > adjustment APIs.
> 
> I don't see a reason for a custom, new API just for this device.
> 
> The TGPIO input clock, the ART, is a free running counter, but you
> want to support frequency adjustments.  Use a timecounter cyclecounter
> pair.

I'm concerned about the complexity that the timecounter adds to
the driver. Specifically, the complexity of dealing with any rate mismatches
between the timecounter and the periodic output signal. The phase
error between the output and timecounter needs to be zero.

My counter-proposal would be to use the real-time clock as the basis of the
device clock. This is fairly simple because the relation between ART and the
realtime clock is known. When output is enabled any phase error between
the realtime clock and the periodic output signal is accumulated in the
SYS_OFFSET result.

This leaves the PHC API behavior as it is currently and uses the frequency
adjust API to adjust the output rate.

> Let the user dial a periodic output signal in the normal way.
> 
> Let the user change the frequency in the normal way, and during this
> call, adjust the counter values accordingly.

Yes to both of the above.

> Thanks,
> Richard

Thanks,
Christopher
