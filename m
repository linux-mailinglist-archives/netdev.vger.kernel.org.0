Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE6116B4F7
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 00:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbgBXXRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 18:17:54 -0500
Received: from mga07.intel.com ([134.134.136.100]:15611 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbgBXXRy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 18:17:54 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Feb 2020 15:17:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,481,1574150400"; 
   d="scan'208";a="410039160"
Received: from wtczc53028gn.jf.intel.com (HELO skl-build) ([10.54.87.17])
  by orsmga005.jf.intel.com with ESMTP; 24 Feb 2020 15:17:53 -0800
Date:   Mon, 24 Feb 2020 15:17:42 -0800
From:   "Christopher S. Hall" <christopher.s.hall@intel.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        jacob.e.keller@intel.com,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, sean.v.kelley@intel.com
Subject: Re: [Intel PMC TGPIO Driver 5/5] drivers/ptp: Add PMC Time-Aware
 GPIO Driver
Message-ID: <20200224231742.GD1508@skl-build>
References: <20191211214852.26317-1-christopher.s.hall@intel.com>
 <20191211214852.26317-6-christopher.s.hall@intel.com>
 <CACRpkdbi7q5Vr2Lt12eirs3Z8GLL2AuLLrAARCHkYEYgKbYkHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbi7q5Vr2Lt12eirs3Z8GLL2AuLLrAARCHkYEYgKbYkHg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus,

Thanks for the review.

On Fri, Feb 07, 2020 at 06:10:46PM +0100, Linus Walleij wrote:
> Hi Christopher,
> 
> thanks for your patch!
> 
> On Fri, Jan 31, 2020 at 7:41 AM <christopher.s.hall@intel.com> wrote:
> 
> > From: Christopher Hall <christopher.s.hall@intel.com>
> >

> > The driver implements to the expanded PHC interface. Input requires use of
> > the user-polling interface. Also, since the ART clock can't be adjusted,
> > modulating the output frequency uses the edge timestamp interface
> > (EVENT_COUNT_TSTAMP2) and the PEROUT2 ioctl output frequency adjustment
> > interface.
> >
> > Acknowledgment: Portions of the driver code were authored by Felipe
> > Balbi <balbi@kernel.org>
> >
> > Signed-off-by: Christopher Hall <christopher.s.hall@intel.com>

> This driver becomes a big confusion for the GPIO maintainer...

I see your concern. TGPIO is Intel's internal name for the device, but
there's no reason we can't use some other terminology in the context of
the Linux kernel. How about removing the GP? We could refer to the device
as "timed I/O". I think that is still fairly descriptive, but removes the
confusion. Does this help the problem?

> > +config PTP_INTEL_PMC_TGPIO
> > +       tristate "Intel PMC Timed GPIO"
> > +       depends on X86
> > +       depends on ACPI
> > +       depends on PTP_1588_CLOCK
> (...)
> > +#include <linux/gpio.h>
> 
> Don't use this header in new code, use <linux/gpio/driver.h>
> 
> But it looks like you should just drop it because there is no GPIO
> of that generic type going on at all?

Yes. You're correct. Removed.

> > +/* Control Register */
> > +#define TGPIOCTL_EN                    BIT(0)
> > +#define TGPIOCTL_DIR                   BIT(1)
> > +#define TGPIOCTL_EP                    GENMASK(3, 2)
> > +#define TGPIOCTL_EP_RISING_EDGE                (0 << 2)
> > +#define TGPIOCTL_EP_FALLING_EDGE       (1 << 2)
> > +#define TGPIOCTL_EP_TOGGLE_EDGE                (2 << 2)
> > +#define TGPIOCTL_PM                    BIT(4)
> 
> OK this looks like some GPIO registers...
> 
> Then there is a bunch of PTP stuff I don't understand I suppose
> related to the precision time protocol.
> 
> Could you explain to a simple soul like me what is going on?
> Should I bother myself with this or is this "some other GPIO,
> not what you work on" or could it be that it's something I should
> review?

The Timed GPIO device has some GPIO-like features, but is mostly used to
import/export a clock signal. It doesn't implement PWM or some other "GP"
features like reading/setting pin state. I think you can safely ignore
the feature.

> I get the impression that this so-called "general purpose I/O"
> isn't very general purpose at all, it seems to be very PTP-purpose

Yes. It is missing many of general purpose features.

> rather, so this confusion needs to be explained in the commit
> message and possibly in the code as well.
> 
> What is it for really?

For import/export system clock, primarily.

> Yours,
> Linus Walleij

Thanks,
Christopher
