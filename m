Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6CC941E091
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 20:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353034AbhI3SF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 14:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353029AbhI3SFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 14:05:55 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9206BC06176C;
        Thu, 30 Sep 2021 11:04:12 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4HL1Mq0ttGzQkBY;
        Thu, 30 Sep 2021 20:04:07 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Subject: Re: [PATCH v2 2/2] mwifiex: Try waking the firmware until we get an
 interrupt
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
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
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Brian Norris <briannorris@chromium.org>, stable@vger.kernel.org
References: <20210914114813.15404-1-verdre@v0yd.nl>
 <20210914114813.15404-3-verdre@v0yd.nl> <YUsRT1rmtITJiJRh@smile.fi.intel.com>
From:   =?UTF-8?Q?Jonas_Dre=c3=9fler?= <verdre@v0yd.nl>
Message-ID: <d9b1c8ea-99e2-7c3e-ec8e-61362e8ccfa7@v0yd.nl>
Date:   Thu, 30 Sep 2021 20:04:00 +0200
MIME-Version: 1.0
In-Reply-To: <YUsRT1rmtITJiJRh@smile.fi.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 839D1188F
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/22/21 1:19 PM, Andy Shevchenko wrote:
> On Tue, Sep 14, 2021 at 01:48:13PM +0200, Jonas Dreßler wrote:
>> It seems that the firmware of the 88W8897 card sometimes ignores or
>> misses when we try to wake it up by writing to the firmware status
>> register. This leads to the firmware wakeup timeout expiring and the
>> driver resetting the card because we assume the firmware has hung up or
>> crashed (unfortunately that's not unlikely with this card).
>>
>> Turns out that most of the time the firmware actually didn't hang up,
>> but simply "missed" our wakeup request and didn't send us an AWAKE
>> event.
>>
>> Trying again to read the firmware status register after a short timeout
>> usually makes the firmware wake up as expected, so add a small retry
>> loop to mwifiex_pm_wakeup_card() that looks at the interrupt status to
>> check whether the card woke up.
>>
>> The number of tries and timeout lengths for this were determined
>> experimentally: The firmware usually takes about 500 us to wake up
>> after we attempt to read the status register. In some cases where the
>> firmware is very busy (for example while doing a bluetooth scan) it
>> might even miss our requests for multiple milliseconds, which is why
>> after 15 tries the waiting time gets increased to 10 ms. The maximum
>> number of tries it took to wake the firmware when testing this was
>> around 20, so a maximum number of 50 tries should give us plenty of
>> safety margin.
>>
>> A good reproducer for this issue is letting the firmware sleep and wake
>> up in very short intervals, for example by pinging a device on the
>> network every 0.1 seconds.
> 
> ...
> 
>> +	do {
>> +		if (mwifiex_write_reg(adapter, reg->fw_status, FIRMWARE_READY_PCIE)) {
>> +			mwifiex_dbg(adapter, ERROR,
>> +				    "Writing fw_status register failed\n");
>> +			return -EIO;
>> +		}
>> +
>> +		n_tries++;
>> +
>> +		if (n_tries <= N_WAKEUP_TRIES_SHORT_INTERVAL)
>> +			usleep_range(400, 700);
>> +		else
>> +			msleep(10);
>> +	} while (n_tries <= N_WAKEUP_TRIES_SHORT_INTERVAL + N_WAKEUP_TRIES_LONG_INTERVAL &&
>> +		 READ_ONCE(adapter->int_status) == 0);
> 
> Can't you use read_poll_timeout() twice instead of this custom approach?
> 

I've tried this now, but read_poll_timeout() is not ideal for our 
use-case. What we'd need would be read->sleep->poll->repeat instead of 
read->poll->sleep->repeat. With read_poll_timeout() we always end up 
doing one more (unnecessary) write.

>> +	mwifiex_dbg(adapter, EVENT,
>> +		    "event: Tried %d times until firmware woke up\n", n_tries);
> 

