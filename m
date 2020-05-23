Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9FD11DF62F
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 11:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387695AbgEWJJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 05:09:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:55626 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387498AbgEWJJs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 May 2020 05:09:48 -0400
IronPort-SDR: /r9XUnPmLDPn2oi3ixcluaFbuFL8g4mvImarTFfuAhmX9IKpmA7VfvKskfCm0GgitZ57gpLq10
 6Ihtt2/bmvjA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2020 02:09:46 -0700
IronPort-SDR: aJaaLrQ5tW18n/MyrFwL71eEqJgr683s9sxfyr6RhmFtCrX9vqtgj6KUo/N1dL93LgKmU/2ixg
 Ca/79gnlWSRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,425,1583222400"; 
   d="scan'208";a="467435870"
Received: from chenyu-office.sh.intel.com ([10.239.158.173])
  by fmsmga005.fm.intel.com with ESMTP; 23 May 2020 02:09:43 -0700
Date:   Sat, 23 May 2020 17:09:50 +0800
From:   Chen Yu <yu.c.chen@intel.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Auke Kok <auke-jan.h.kok@intel.com>,
        Jeff Garzik <jeff@garzik.org>,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Shevchenko, Andriy" <andriy.shevchenko@intel.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
        Stable@vger.kernel.org
Subject: Re: [PATCH 2/2] e1000e: Make WOL info in ethtool consistent with
 device wake up ability
Message-ID: <20200523090950.GA20370@chenyu-office.sh.intel.com>
References: <cover.1590081982.git.yu.c.chen@intel.com>
 <725bad2f3ce7f7b7f1667d53b6527dc059f9e419.1590081982.git.yu.c.chen@intel.com>
 <20200521192342.GE8771@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200521192342.GE8771@lion.mk-sys.cz>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal,
Thanks for reviewing,
and sorry for late reply.
On Thu, May 21, 2020 at 09:23:42PM +0200, Michal Kubecek wrote:
> On Fri, May 22, 2020 at 01:59:13AM +0800, Chen Yu wrote:
> > Currently the ethtool shows that WOL(Wake On Lan) is enabled
> > even if the device wakeup ability has been disabled via sysfs:
> >   cat /sys/devices/pci0000:00/0000:00:1f.6/power/wakeup
> >    disabled
> > 
> >   ethtool eno1
> >   ...
> >   Wake-on: g
> > 
> > Fix this in ethtool to check if the user has explicitly disabled the
> > wake up ability for this device.
> 
> Wouldn't this lead to rather unexpected and inconsistent behaviour when
> the wakeup is disabled? As you don't touch the set_wol handler, I assume
> it will still allow setting enabled modes as usual so that you get e.g.
> 
>   ethtool -s eth0 wol g   # no error or warning, returns 0
>   ethtool eth0            # reports no modes enabled
> 
> The first command would set the enabled wol modes but that would be
> hidden from user and even the netlink notification would claim something
> different. Another exampe (with kernel and ethtool >= 5.6):
> 
>   ethtool -s eth0 wol g
>   ethtool -s eth0 wol +m
> 
> resulting in "mg" if device wakeup is enabled but "m" when it's disabled
> (but the latter would be hidden from user and only revealed when you
> enable the device wakeup).
> 
I've tested ethtool v5.6 on top of kernel v5.7-rc6, it looks like
the scenario you described will not happen as it will not allow
the user to enable the wol options with device wakeup disabled,
not sure if I missed something:

/sys/devices/pci0000:00/0000:00:1f.6/power# echo disabled > wakeup

ethtool -s eno1 wol g
netlink error: cannot enable unsupported WoL mode (offset 36)
netlink error: Invalid argument

I've not digged into the code too much, but according to
ethhl_set_wol(), it will first get the current wol options
via dev->ethtool_ops->get_wol(), and both the wolopts and
wol.supported are 0 when device wake up are disabled. Then
ethnl_update_bitset32 might manipulate on wolopts and
make it non-zero each is controdict with the precondition that
no opts should be enabled due to 0 wol.supported.
> This is a general problem discussed recently for EEE and pause
> autonegotiation: if setting A can be effectively used only when B is
> enabled, should we hide actual setting of A from userspace when B is
> disabled or even reset the value of A whenever B gets toggled or rather
> allow setting A and B independently? AFAICS the consensus seemed to be
> that A should be allowed to be set and queried independently of the
> value of B.

But then there would be an inconsistence between A and B. I was thinking
if there's a way to align them in kernel space and  maintain the difference in user space?

Thanks,
Chenyu
> 
> Michal
> 
> > Fixes: 6ff68026f475 ("e1000e: Use device_set_wakeup_enable")
> > Reported-by: Len Brown <len.brown@intel.com>
> > Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Cc: <Stable@vger.kernel.org>
> > Signed-off-by: Chen Yu <yu.c.chen@intel.com>
> > ---
> >  drivers/net/ethernet/intel/e1000e/ethtool.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/intel/e1000e/ethtool.c b/drivers/net/ethernet/intel/e1000e/ethtool.c
> > index 1d47e2503072..0cccd823ff24 100644
> > --- a/drivers/net/ethernet/intel/e1000e/ethtool.c
> > +++ b/drivers/net/ethernet/intel/e1000e/ethtool.c
> > @@ -1891,7 +1891,7 @@ static void e1000_get_wol(struct net_device *netdev,
> >  	wol->wolopts = 0;
> >  
> >  	if (!(adapter->flags & FLAG_HAS_WOL) ||
> > -	    !device_can_wakeup(&adapter->pdev->dev))
> > +	    !device_may_wakeup(&adapter->pdev->dev))
> >  		return;
> >  
> >  	wol->supported = WAKE_UCAST | WAKE_MCAST |
> > -- 
> > 2.17.1
> > 
