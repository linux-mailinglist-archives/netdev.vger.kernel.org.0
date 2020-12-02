Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E26DA2CC10E
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 16:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730523AbgLBPin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 10:38:43 -0500
Received: from mga03.intel.com ([134.134.136.65]:39502 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727699AbgLBPim (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 10:38:42 -0500
IronPort-SDR: awMpY4ry1V1+L8ZkH09QbH3MXispx3mbQlfMLQtb3yoSOZrliD7gj4ho99Cc7T/Dlgi0ih8JsH
 sdeCMwFOu1Ig==
X-IronPort-AV: E=McAfee;i="6000,8403,9823"; a="173132249"
X-IronPort-AV: E=Sophos;i="5.78,387,1599548400"; 
   d="scan'208";a="173132249"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2020 07:38:00 -0800
IronPort-SDR: ug/EuDJ5RuAzG+MVKRDo3eqBUamL0BzqxYq9Qqm+l+QXBJOeXqOgDlDaGzOi+kNFnWnZKrFvpA
 Tx6DOD6g1mcQ==
X-IronPort-AV: E=Sophos;i="5.78,387,1599548400"; 
   d="scan'208";a="550104523"
Received: from chenyu-office.sh.intel.com ([10.239.158.173])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2020 07:37:57 -0800
Date:   Wed, 2 Dec 2020 23:40:46 +0800
From:   Chen Yu <yu.c.chen@intel.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        "David S. Miller" <davem@davemloft.net>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Brandt, Todd E" <todd.e.brandt@intel.com>
Subject: Re: [PATCH 1/2][v3] e1000e: Leverage direct_complete to speed up
 s2ram
Message-ID: <20201202154046.GA17693@chenyu-office.sh.intel.com>
References: <cover.1606757180.git.yu.c.chen@intel.com>
 <b8896b7748e516e9c440ab22e582e30f1389776c.1606757180.git.yu.c.chen@intel.com>
 <DF79FD96-31E6-4D9A-BF0D-40B7FC563C0B@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DF79FD96-31E6-4D9A-BF0D-40B7FC563C0B@canonical.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kai-Heng,
On Wed, Dec 02, 2020 at 09:06:19PM +0800, Kai-Heng Feng wrote:
> > ---
> > v2: Added test data and some commit log revise(Paul Menzel)
> >    Only skip the suspend/resume if the NIC is not a wake up device specified
> >    by the user(Kai-Heng Feng)
> > v3: Leverage direct complete mechanism to skip all hooks(Kai-Heng Feng)
> > ---
> > 
> > -	dev_pm_set_driver_flags(&pdev->dev, DPM_FLAG_NO_DIRECT_COMPLETE);
> > +	dev_pm_set_driver_flags(&pdev->dev, DPM_FLAG_SMART_PREPARE);
> 
> This isn't required for pci_pm_prepare() to use driver's .prepare callback.
>
pci_pm_prepare() is likely to return 1 even if driver's prepare() return 0,
when DPM_FLAG_SMART_PREPARE is not set, which might cause prblems:
if (!error && dev_pm_test_driver_flags(dev, DPM_FLAG_SMART_PREPARE))
	return 0;
> > 
> > 	if (pci_dev_run_wake(pdev) && hw->mac.type < e1000_pch_cnp)
> > 		pm_runtime_put_noidle(&pdev->dev);
> > @@ -7890,6 +7897,7 @@ MODULE_DEVICE_TABLE(pci, e1000_pci_tbl);
> > 
> > static const struct dev_pm_ops e1000_pm_ops = {
> > #ifdef CONFIG_PM_SLEEP
> > +	.prepare	= e1000e_pm_prepare,
> 
> How do we make sure a link change happened in S3 can be detect after resume, without a .complete callback which ask device to runtime resume?
> 
The pm core's device_complete() has already done that pm_runtime_put() in the end.

Just talked to Rafael and he might also give some feedbacks later.

thanks,
Chenyu
> Kai-Heng
> 
> 
