Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59C26152804
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 10:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgBEJGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 04:06:44 -0500
Received: from mga07.intel.com ([134.134.136.100]:63399 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727068AbgBEJGn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Feb 2020 04:06:43 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Feb 2020 01:06:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,405,1574150400"; 
   d="scan'208";a="404085684"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga005.jf.intel.com with ESMTP; 05 Feb 2020 01:06:37 -0800
Received: from andy by smile with local (Exim 4.93)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1izGdq-0008JD-Ad; Wed, 05 Feb 2020 11:06:38 +0200
Date:   Wed, 5 Feb 2020 11:06:38 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     davem@davemloft.ne, mkubecek@suse.cz, jeffrey.t.kirsher@intel.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Jouni Hogander <jouni.hogander@unikie.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        Wang Hai <wanghai26@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Li RongQing <lirongqing@baidu.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] net-sysfs: Ensure begin/complete are called in
 speed_show() and duplex_show()
Message-ID: <20200205090638.GS10400@smile.fi.intel.com>
References: <20200205081616.18378-1-kai.heng.feng@canonical.com>
 <20200205081616.18378-2-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200205081616.18378-2-kai.heng.feng@canonical.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 05, 2020 at 04:16:16PM +0800, Kai-Heng Feng wrote:
> Device like igb gets runtime suspended when there's no link partner. We
> can't get correct speed under that state:
> $ cat /sys/class/net/enp3s0/speed
> 1000
> 
> In addition to that, an error can also be spotted in dmesg:
> [  385.991957] igb 0000:03:00.0 enp3s0: PCIe link lost
> 
> It's because the igb device doesn't get runtime resumed before calling
> get_link_ksettings().
> 
> So let's use a new helper to call begin() and complete() like what
> dev_ethtool() does, to runtime resume/suspend or power up/down the
> device properly.
> 
> Once this fix is in place, igb can show the speed correctly without link
> partner:
> $ cat /sys/class/net/enp3s0/speed
> -1

What is the meaning of -1? Does it tells us "Hey, something is bad in hardware
I can't tell you the speed" or does it imply anything else?

Wouldn't be better to report 0?

Where is the documentation part of this ABI change?

-- 
With Best Regards,
Andy Shevchenko


