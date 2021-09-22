Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8DD4147A8
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 13:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235484AbhIVLTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 07:19:33 -0400
Received: from mga18.intel.com ([134.134.136.126]:65341 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230171AbhIVLTc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 07:19:32 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="210649436"
X-IronPort-AV: E=Sophos;i="5.85,313,1624345200"; 
   d="scan'208";a="210649436"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2021 04:18:00 -0700
X-IronPort-AV: E=Sophos;i="5.85,313,1624345200"; 
   d="scan'208";a="474522094"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2021 04:17:53 -0700
Received: from andy by smile with local (Exim 4.95-RC2)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1mT0G6-004ANk-OB;
        Wed, 22 Sep 2021 14:17:50 +0300
Date:   Wed, 22 Sep 2021 14:17:50 +0300
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
Subject: Re: [PATCH v2 1/2] mwifiex: Use non-posted PCI write when setting TX
 ring write pointer
Message-ID: <YUsQ3jU1RuThUYn8@smile.fi.intel.com>
References: <20210914114813.15404-1-verdre@v0yd.nl>
 <20210914114813.15404-2-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210914114813.15404-2-verdre@v0yd.nl>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 14, 2021 at 01:48:12PM +0200, Jonas Dreﬂler wrote:
> On the 88W8897 card it's very important the TX ring write pointer is
> updated correctly to its new value before setting the TX ready
> interrupt, otherwise the firmware appears to crash (probably because
> it's trying to DMA-read from the wrong place). The issue is present in
> the latest firmware version 15.68.19.p21 of the pcie+usb card.

Please, be consistent in the commit message(s) and the code (esp. if the term
comes from a specification).

Here, PCIe (same in the code, at least that I have noticed, but should be done
everywhere).

> Since PCI uses "posted writes" when writing to a register, it's not
> guaranteed that a write will happen immediately. That means the pointer
> might be outdated when setting the TX ready interrupt, leading to
> firmware crashes especially when ASPM L1 and L1 substates are enabled
> (because of the higher link latency, the write will probably take
> longer).
> 
> So fix those firmware crashes by always using a non-posted write for
> this specific register write. We do that by simply reading back the
> register after writing it, just as a few other PCI drivers do.
> 
> This fixes a bug where during rx/tx traffic and with ASPM L1 substates

Ditto. TX/RX.

> enabled (the enabled substates are platform dependent), the firmware
> crashes and eventually a command timeout appears in the logs.

Should it have a Fixes tag?

> Cc: stable@vger.kernel.org
> Signed-off-by: Jonas Dreﬂler <verdre@v0yd.nl>

...

> -		/* Write the TX ring write pointer in to reg->tx_wrptr */
> -		if (mwifiex_write_reg(adapter, reg->tx_wrptr,
> -				      card->txbd_wrptr | rx_val)) {
> +		/* Write the TX ring write pointer in to reg->tx_wrptr.
> +		 * The firmware (latest version 15.68.19.p21) of the 88W8897
> +		 * pcie+usb card seems to crash when getting the TX ready
> +		 * interrupt but the TX ring write pointer points to an outdated
> +		 * address, so it's important we do a non-posted write here to
> +		 * force the completion of the write.
> +		 */
> +		if (mwifiex_write_reg_np(adapter, reg->tx_wrptr,
> +				        card->txbd_wrptr | rx_val)) {

>  			mwifiex_dbg(adapter, ERROR,
>  				    "SEND DATA: failed to write reg->tx_wrptr\n");
>  			ret = -1;

I'm not sure how this is not a dead code.

On top of that, I would rather to call old function and explicitly put the
dummy read after it.

		/* Write the TX ring write pointer in to reg->tx_wrptr */
		if (mwifiex_write_reg(adapter, reg->tx_wrptr,
				      card->txbd_wrptr | rx_val)) {
			...eliminate dead code in the following patch(es)...
		}

+		/* The firmware (latest version 15.68.19.p21) of the 88W8897
+		 * pcie+usb card seems to crash when getting the TX ready
+		 * interrupt but the TX ring write pointer points to an outdated
+		 * address, so it's important we do a non-posted write here to
+		 * force the completion of the write.
+		 */
		mwifiex_read_reg(...);

Now, since I found the dummy read function to be present, perhaps you need to
dive more into the code and understand why it exists.

-- 
With Best Regards,
Andy Shevchenko


