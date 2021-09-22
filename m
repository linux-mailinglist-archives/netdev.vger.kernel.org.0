Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C62C41487D
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 14:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235925AbhIVMKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 08:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235860AbhIVMKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 08:10:24 -0400
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75CB6C061574;
        Wed, 22 Sep 2021 05:08:54 -0700 (PDT)
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:105:465:1:4:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4HDxsX11lFzQlZ1;
        Wed, 22 Sep 2021 14:08:48 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Subject: Re: [PATCH v2 1/2] mwifiex: Use non-posted PCI write when setting TX
 ring write pointer
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
 <20210914114813.15404-2-verdre@v0yd.nl> <YUsQ3jU1RuThUYn8@smile.fi.intel.com>
From:   =?UTF-8?Q?Jonas_Dre=c3=9fler?= <verdre@v0yd.nl>
Message-ID: <9293504f-f70d-61ac-b221-dd466f01b5df@v0yd.nl>
Date:   Wed, 22 Sep 2021 14:08:39 +0200
MIME-Version: 1.0
In-Reply-To: <YUsQ3jU1RuThUYn8@smile.fi.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A27113CD
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/22/21 1:17 PM, Andy Shevchenko wrote:
> On Tue, Sep 14, 2021 at 01:48:12PM +0200, Jonas Dreßler wrote:
>> On the 88W8897 card it's very important the TX ring write pointer is
>> updated correctly to its new value before setting the TX ready
>> interrupt, otherwise the firmware appears to crash (probably because
>> it's trying to DMA-read from the wrong place). The issue is present in
>> the latest firmware version 15.68.19.p21 of the pcie+usb card.
> 
> Please, be consistent in the commit message(s) and the code (esp. if the term
> comes from a specification).
> 
> Here, PCIe (same in the code, at least that I have noticed, but should be done
> everywhere).
> 
>> Since PCI uses "posted writes" when writing to a register, it's not
>> guaranteed that a write will happen immediately. That means the pointer
>> might be outdated when setting the TX ready interrupt, leading to
>> firmware crashes especially when ASPM L1 and L1 substates are enabled
>> (because of the higher link latency, the write will probably take
>> longer).
>>
>> So fix those firmware crashes by always using a non-posted write for
>> this specific register write. We do that by simply reading back the
>> register after writing it, just as a few other PCI drivers do.
>>
>> This fixes a bug where during rx/tx traffic and with ASPM L1 substates
> 
> Ditto. TX/RX.
> 
>> enabled (the enabled substates are platform dependent), the firmware
>> crashes and eventually a command timeout appears in the logs.
> 
> Should it have a Fixes tag?
> 

Don't think so, there's the infamous 
(https://bugzilla.kernel.org/show_bug.cgi?id=109681) Bugzilla bug it 
fixes though, I'll mention that in v3.

>> Cc: stable@vger.kernel.org
>> Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
> 
> ...
> 
>> -		/* Write the TX ring write pointer in to reg->tx_wrptr */
>> -		if (mwifiex_write_reg(adapter, reg->tx_wrptr,
>> -				      card->txbd_wrptr | rx_val)) {
>> +		/* Write the TX ring write pointer in to reg->tx_wrptr.
>> +		 * The firmware (latest version 15.68.19.p21) of the 88W8897
>> +		 * pcie+usb card seems to crash when getting the TX ready
>> +		 * interrupt but the TX ring write pointer points to an outdated
>> +		 * address, so it's important we do a non-posted write here to
>> +		 * force the completion of the write.
>> +		 */
>> +		if (mwifiex_write_reg_np(adapter, reg->tx_wrptr,
>> +				        card->txbd_wrptr | rx_val)) {
> 
>>   			mwifiex_dbg(adapter, ERROR,
>>   				    "SEND DATA: failed to write reg->tx_wrptr\n");
>>   			ret = -1;
> 
> I'm not sure how this is not a dead code.
> 
> On top of that, I would rather to call old function and explicitly put the
> dummy read after it
> 
> 		/* Write the TX ring write pointer in to reg->tx_wrptr */
> 		if (mwifiex_write_reg(adapter, reg->tx_wrptr,
> 				      card->txbd_wrptr | rx_val)) {
> 			...eliminate dead code in the following patch(es)...
> 		}
> 
> +		/* The firmware (latest version 15.68.19.p21) of the 88W8897
> +		 * pcie+usb card seems to crash when getting the TX ready
> +		 * interrupt but the TX ring write pointer points to an outdated
> +		 * address, so it's important we do a non-posted write here to
> +		 * force the completion of the write.
> +		 */
> 		mwifiex_read_reg(...);
> 
> Now, since I found the dummy read function to be present, perhaps you need to
> dive more into the code and understand why it exists.
> 

Interesting, I haven't noticed that mwifiex_write_reg() always returns 
0. So are you suggesting to remove that return value and get rid of all 
the "if (mwifiex_write_reg()) {}" checks in a separate commit?

As for why the dummy read/write functions exist, I have no idea. Looking 
at git history it seems they were always there (only change is that 
mwifiex_read_reg() started to handle read errors with commit 
af05148392f50490c662dccee6c502d9fcba33e2). My bet would be that they 
were created to be consistent with sdio.c which is the oldest supported 
bus type in mwifiex.
