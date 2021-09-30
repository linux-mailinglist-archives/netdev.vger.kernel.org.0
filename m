Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4117541E2ED
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 22:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348551AbhI3VAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 17:00:32 -0400
Received: from mga05.intel.com ([192.55.52.43]:22707 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229957AbhI3VAb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 17:00:31 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10123"; a="310832977"
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="310832977"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2021 13:58:47 -0700
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="618437339"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2021 13:58:43 -0700
Received: from andy by smile with local (Exim 4.95-RC2)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1mW38Z-007Fx0-P6;
        Thu, 30 Sep 2021 23:58:39 +0300
Date:   Thu, 30 Sep 2021 23:58:39 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jonas =?iso-8859-1?Q?Dre=DFler?= <verdre@v0yd.nl>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Brian Norris <briannorris@chromium.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mwifiex: Try waking the firmware until we get an
 interrupt
Message-ID: <YVYk/1+ftFUOoitF@smile.fi.intel.com>
References: <20210914114813.15404-1-verdre@v0yd.nl>
 <20210914114813.15404-3-verdre@v0yd.nl>
 <YUsRT1rmtITJiJRh@smile.fi.intel.com>
 <d9b1c8ea-99e2-7c3e-ec8e-61362e8ccfa7@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d9b1c8ea-99e2-7c3e-ec8e-61362e8ccfa7@v0yd.nl>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 08:04:00PM +0200, Jonas Dreßler wrote:
> On 9/22/21 1:19 PM, Andy Shevchenko wrote:
> > On Tue, Sep 14, 2021 at 01:48:13PM +0200, Jonas Dreßler wrote:

...

> > > +	do {
> > > +		if (mwifiex_write_reg(adapter, reg->fw_status, FIRMWARE_READY_PCIE)) {
> > > +			mwifiex_dbg(adapter, ERROR,
> > > +				    "Writing fw_status register failed\n");
> > > +			return -EIO;
> > > +		}
> > > +
> > > +		n_tries++;
> > > +
> > > +		if (n_tries <= N_WAKEUP_TRIES_SHORT_INTERVAL)
> > > +			usleep_range(400, 700);
> > > +		else
> > > +			msleep(10);
> > > +	} while (n_tries <= N_WAKEUP_TRIES_SHORT_INTERVAL + N_WAKEUP_TRIES_LONG_INTERVAL &&
> > > +		 READ_ONCE(adapter->int_status) == 0);
> > 
> > Can't you use read_poll_timeout() twice instead of this custom approach?
> 
> I've tried this now, but read_poll_timeout() is not ideal for our use-case.
> What we'd need would be read->sleep->poll->repeat instead of
> read->poll->sleep->repeat. With read_poll_timeout() we always end up doing
> one more (unnecessary) write.

First of all, there is a parameter to get sleep beforehand.
Second, what is the problem with having one write more or less?
Your current code doesn't guarantee this either. It only decreases
probability of such scenario. Am I wrong?


-- 
With Best Regards,
Andy Shevchenko


