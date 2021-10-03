Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F7B42010C
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 11:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbhJCJUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 05:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhJCJUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Oct 2021 05:20:15 -0400
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 595BFC0613EC;
        Sun,  3 Oct 2021 02:18:28 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4HMdYs6NzvzQk90;
        Sun,  3 Oct 2021 11:18:25 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Message-ID: <5f0b52be-8b9c-b015-6c5a-f2f470e37058@v0yd.nl>
Date:   Sun, 3 Oct 2021 11:18:15 +0200
MIME-Version: 1.0
From:   =?UTF-8?Q?Jonas_Dre=c3=9fler?= <verdre@v0yd.nl>
Subject: Re: [PATCH v2 2/2] mwifiex: Try waking the firmware until we get an
 interrupt
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Tsuchiya Yuto <kitakar@gmail.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Brian Norris <briannorris@chromium.org>, stable@vger.kernel.org
References: <20210914114813.15404-1-verdre@v0yd.nl>
 <20210914114813.15404-3-verdre@v0yd.nl>
Content-Language: en-US
In-Reply-To: <20210914114813.15404-3-verdre@v0yd.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3CFE718B4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/14/21 13:48, Jonas Dreßler wrote:
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
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
> ---
>   drivers/net/wireless/marvell/mwifiex/pcie.c | 33 +++++++++++++++++----
>   1 file changed, 27 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
> index 0eff717ac5fa..7fea319e013c 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> @@ -661,11 +661,15 @@ static void mwifiex_delay_for_sleep_cookie(struct mwifiex_adapter *adapter,
>   			    "max count reached while accessing sleep cookie\n");
>   }
>   
> +#define N_WAKEUP_TRIES_SHORT_INTERVAL 15
> +#define N_WAKEUP_TRIES_LONG_INTERVAL 35
> +
>   /* This function wakes up the card by reading fw_status register. */
>   static int mwifiex_pm_wakeup_card(struct mwifiex_adapter *adapter)
>   {
>   	struct pcie_service_card *card = adapter->card;
>   	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
> +	int n_tries = 0;
>   
>   	mwifiex_dbg(adapter, EVENT,
>   		    "event: Wakeup device...\n");
> @@ -673,12 +677,29 @@ static int mwifiex_pm_wakeup_card(struct mwifiex_adapter *adapter)
>   	if (reg->sleep_cookie)
>   		mwifiex_pcie_dev_wakeup_delay(adapter);
>   
> -	/* Accessing fw_status register will wakeup device */
> -	if (mwifiex_write_reg(adapter, reg->fw_status, FIRMWARE_READY_PCIE)) {
> -		mwifiex_dbg(adapter, ERROR,
> -			    "Writing fw_status register failed\n");
> -		return -1;
> -	}
> +	/* Access the fw_status register to wake up the device.
> +	 * Since the 88W8897 firmware sometimes appears to ignore or miss
> +	 * that wakeup request, we continue trying until we receive an
> +	 * interrupt from the card.
> +	 */
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
> +
> +	mwifiex_dbg(adapter, EVENT,
> +		    "event: Tried %d times until firmware woke up\n", n_tries);
>   
>   	if (reg->sleep_cookie) {
>   		mwifiex_pcie_dev_wakeup_delay(adapter);
> 

So I think I have another solution that might be a lot more elegant, how
about this:

try_again:
	n_tries++;

	mwifiex_write_reg(adapter, reg->fw_status, FIRMWARE_READY_PCIE);

	if (wait_event_interruptible_timeout(adapter->card_wakeup_wait_q,
					     READ_ONCE(adapter->int_status) != 0,
					     WAKEUP_TRY_AGAIN_TIMEOUT) == 0 &&
	    n_tries < MAX_N_WAKEUP_TRIES) {
		goto try_again;
	}


and then call wake_up_interruptible() in the mwifiex_interrupt_status()
interrupt handler.

This solution should make sure we always keep wakeup latency to a minimum
and can still retry the register write if things didn't work.
