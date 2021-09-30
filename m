Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F7A41E305
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 23:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348726AbhI3VJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 17:09:02 -0400
Received: from mout-p-101.mailbox.org ([80.241.56.151]:57772 "EHLO
        mout-p-101.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348668AbhI3VJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 17:09:01 -0400
X-Greylist: delayed 10990 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Sep 2021 17:09:00 EDT
Received: from smtp102.mailbox.org (smtp102.mailbox.org [80.241.60.233])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4HL5R820jFzQk38;
        Thu, 30 Sep 2021 23:07:16 +0200 (CEST)
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
 <d9b1c8ea-99e2-7c3e-ec8e-61362e8ccfa7@v0yd.nl>
 <YVYk/1+ftFUOoitF@smile.fi.intel.com>
From:   =?UTF-8?Q?Jonas_Dre=c3=9fler?= <verdre@v0yd.nl>
Message-ID: <98c1b772-ae6b-e435-030e-399f613061ba@v0yd.nl>
Date:   Thu, 30 Sep 2021 23:07:09 +0200
MIME-Version: 1.0
In-Reply-To: <YVYk/1+ftFUOoitF@smile.fi.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D745326E
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/30/21 10:58 PM, Andy Shevchenko wrote:
> On Thu, Sep 30, 2021 at 08:04:00PM +0200, Jonas Dreßler wrote:
>> On 9/22/21 1:19 PM, Andy Shevchenko wrote:
>>> On Tue, Sep 14, 2021 at 01:48:13PM +0200, Jonas Dreßler wrote:
> 
> ...
> 
>>>> +	do {
>>>> +		if (mwifiex_write_reg(adapter, reg->fw_status, FIRMWARE_READY_PCIE)) {
>>>> +			mwifiex_dbg(adapter, ERROR,
>>>> +				    "Writing fw_status register failed\n");
>>>> +			return -EIO;
>>>> +		}
>>>> +
>>>> +		n_tries++;
>>>> +
>>>> +		if (n_tries <= N_WAKEUP_TRIES_SHORT_INTERVAL)
>>>> +			usleep_range(400, 700);
>>>> +		else
>>>> +			msleep(10);
>>>> +	} while (n_tries <= N_WAKEUP_TRIES_SHORT_INTERVAL + N_WAKEUP_TRIES_LONG_INTERVAL &&
>>>> +		 READ_ONCE(adapter->int_status) == 0);
>>>
>>> Can't you use read_poll_timeout() twice instead of this custom approach?
>>
>> I've tried this now, but read_poll_timeout() is not ideal for our use-case.
>> What we'd need would be read->sleep->poll->repeat instead of
>> read->poll->sleep->repeat. With read_poll_timeout() we always end up doing
>> one more (unnecessary) write.
> 
> First of all, there is a parameter to get sleep beforehand.

Sleeping beforehand will sleep before doing the first write, so that's 
just wasted time.

> Second, what is the problem with having one write more or less?
> Your current code doesn't guarantee this either. It only decreases
> probability of such scenario. Am I wrong?
> 
> 

Indeed my approach just decreases the probability and we sometimes end 
up writing twice to wakeup the card, but it would kinda bug me if we'd 
always do one write too much.

Anyway, if you still prefer the read_poll_timeout() solution I'd be 
alright with that of course.
