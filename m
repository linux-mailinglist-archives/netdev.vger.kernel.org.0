Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0A514147B4
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 13:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235581AbhIVLV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 07:21:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:14308 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230171AbhIVLV0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 07:21:26 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="246009773"
X-IronPort-AV: E=Sophos;i="5.85,313,1624345200"; 
   d="scan'208";a="246009773"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2021 04:19:51 -0700
X-IronPort-AV: E=Sophos;i="5.85,313,1624345200"; 
   d="scan'208";a="653237297"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2021 04:19:46 -0700
Received: from andy by smile with local (Exim 4.95-RC2)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1mT0Hv-004AOf-HS;
        Wed, 22 Sep 2021 14:19:43 +0300
Date:   Wed, 22 Sep 2021 14:19:43 +0300
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
Message-ID: <YUsRT1rmtITJiJRh@smile.fi.intel.com>
References: <20210914114813.15404-1-verdre@v0yd.nl>
 <20210914114813.15404-3-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210914114813.15404-3-verdre@v0yd.nl>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 14, 2021 at 01:48:13PM +0200, Jonas Dreßler wrote:
> It seems that the firmware of the 88W8897 card sometimes ignores or
> misses when we try to wake it up by writing to the firmware status
> register. This leads to the firmware wakeup timeout expiring and the
> driver resetting the card because we assume the firmware has hung up or
> crashed (unfortunately that's not unlikely with this card).
> 
> Turns out that most of the time the firmware actually didn't hang up,
> but simply "missed" our wakeup request and didn't send us an AWAKE
> event.
> 
> Trying again to read the firmware status register after a short timeout
> usually makes the firmware wake up as expected, so add a small retry
> loop to mwifiex_pm_wakeup_card() that looks at the interrupt status to
> check whether the card woke up.
> 
> The number of tries and timeout lengths for this were determined
> experimentally: The firmware usually takes about 500 us to wake up
> after we attempt to read the status register. In some cases where the
> firmware is very busy (for example while doing a bluetooth scan) it
> might even miss our requests for multiple milliseconds, which is why
> after 15 tries the waiting time gets increased to 10 ms. The maximum
> number of tries it took to wake the firmware when testing this was
> around 20, so a maximum number of 50 tries should give us plenty of
> safety margin.
> 
> A good reproducer for this issue is letting the firmware sleep and wake
> up in very short intervals, for example by pinging a device on the
> network every 0.1 seconds.

...

> +	do {
> +		if (mwifiex_write_reg(adapter, reg->fw_status, FIRMWARE_READY_PCIE)) {
> +			mwifiex_dbg(adapter, ERROR,
> +				    "Writing fw_status register failed\n");
> +			return -EIO;
> +		}
> +
> +		n_tries++;
> +
> +		if (n_tries <= N_WAKEUP_TRIES_SHORT_INTERVAL)
> +			usleep_range(400, 700);
> +		else
> +			msleep(10);
> +	} while (n_tries <= N_WAKEUP_TRIES_SHORT_INTERVAL + N_WAKEUP_TRIES_LONG_INTERVAL &&
> +		 READ_ONCE(adapter->int_status) == 0);

Can't you use read_poll_timeout() twice instead of this custom approach?

> +	mwifiex_dbg(adapter, EVENT,
> +		    "event: Tried %d times until firmware woke up\n", n_tries);

-- 
With Best Regards,
Andy Shevchenko


