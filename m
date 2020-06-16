Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB7F1FA956
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 09:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgFPG75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 02:59:57 -0400
Received: from mga04.intel.com ([192.55.52.120]:42770 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726384AbgFPG74 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jun 2020 02:59:56 -0400
IronPort-SDR: 1Y547nM1lSz1tWLB67GevE2KXgoE4XKpfycuysg8ps7ptraaEYKqhlrSERYxpjWF12AahjqXgt
 sve9cc5N5/SA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2020 23:59:56 -0700
IronPort-SDR: 8BLa8egR+d0BceuadNnqir5piIf7i4xRMu4AhfKEI5XBxLk8UY/y1Jgn9pwTnW/jKhpBlfHZgO
 wI1AEoIK+2dA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,518,1583222400"; 
   d="scan'208";a="420663416"
Received: from chenyu-office.sh.intel.com ([10.239.158.173])
  by orsmga004.jf.intel.com with ESMTP; 15 Jun 2020 23:59:52 -0700
Date:   Tue, 16 Jun 2020 15:01:01 +0800
From:   Chen Yu <yu.c.chen@intel.com>
To:     "Brown, Aaron F" <aaron.f.brown@intel.com>
Cc:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
        Jeff Garzik <jeff@garzik.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Shevchenko, Andriy" <andriy.shevchenko@intel.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
        "Stable@vger.kernel.org" <Stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] e1000e: Do not wake up the system via WOL if device
 wakeup is disabled
Message-ID: <20200616070101.GA24567@chenyu-office.sh.intel.com>
References: <cover.1590081982.git.yu.c.chen@intel.com>
 <9f7ede2e2e8152704258fc11ba3755ae93f50741.1590081982.git.yu.c.chen@intel.com>
 <SN6PR11MB2896298A90B37CEA0DC5A750BC9C0@SN6PR11MB2896.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN6PR11MB2896298A90B37CEA0DC5A750BC9C0@SN6PR11MB2896.namprd11.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 02:51:27AM +0800, Brown, Aaron F wrote:
> > From: Chen Yu <yu.c.chen@intel.com>
> > Sent: Thursday, May 21, 2020 10:59 AM
> > To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; David S. Miller
> > <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Kok, Auke-jan H
> > <auke-jan.h.kok@intel.com>; Jeff Garzik <jeff@garzik.org>
> > Cc: intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org; linux-
> > kernel@vger.kernel.org; Brown, Len <len.brown@intel.com>; Rafael J. Wysocki
> > <rjw@rjwysocki.net>; Shevchenko, Andriy <andriy.shevchenko@intel.com>;
> > Neftin, Sasha <sasha.neftin@intel.com>; Lifshits, Vitaly
> > <vitaly.lifshits@intel.com>; Chen, Yu C <yu.c.chen@intel.com>;
> > Stable@vger.kernel.org
> > Subject: [PATCH 1/2] e1000e: Do not wake up the system via WOL if device
> > wakeup is disabled
> >
> > Currently the system will be woken up via WOL(Wake On Lan) even if the
> > device wakeup ability has been disabled via sysfs:
> >  cat /sys/devices/pci0000:00/0000:00:1f.6/power/wakeup
> >  disabled
> >
> > The system should not be woken up if the user has explicitly
> > disabled the wake up ability for this device.
> >
> > This patch clears the WOL ability of this network device if the
> > user has disabled the wake up ability in sysfs.
> >
> > Fixes: bc7f75fa9788 ("[E1000E]: New pci-express e1000 driver")
> > Reported-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Cc: <Stable@vger.kernel.org>
> > Signed-off-by: Chen Yu <yu.c.chen@intel.com>
> > ---
> >  drivers/net/ethernet/intel/e1000e/netdev.c | 14 ++++++++++----
> >  1 file changed, 10 insertions(+), 4 deletions(-)
> >
> Tested-by: Aaron Brown <aaron.f.brown@intel.com>
> 
Thanks for testing, Aaron.

Best,
Chenyu
