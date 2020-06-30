Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4255420EA9B
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 03:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbgF3BDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 21:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727011AbgF3BDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 21:03:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F863C061755;
        Mon, 29 Jun 2020 18:03:08 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2AFA3127D3F69;
        Mon, 29 Jun 2020 18:03:06 -0700 (PDT)
Date:   Mon, 29 Jun 2020 18:03:05 -0700 (PDT)
Message-Id: <20200629.180305.1550276438848153234.davem@davemloft.net>
To:     elder@linaro.org
Cc:     kuba@kernel.org, evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/5] net: ipa: head-of-line block registers
 are RX only
From:   David Miller <davem@davemloft.net>
In-Reply-To: <7c438ee3-8ff0-0ee1-2a0a-fa458d982e11@linaro.org>
References: <20200629214919.1196017-2-elder@linaro.org>
        <20200629173517.40716282@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <7c438ee3-8ff0-0ee1-2a0a-fa458d982e11@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jun 2020 18:03:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder <elder@linaro.org>
Date: Mon, 29 Jun 2020 20:01:20 -0500

> On 6/29/20 7:35 PM, Jakub Kicinski wrote:
>> On Mon, 29 Jun 2020 16:49:15 -0500 Alex Elder wrote:
>>> The INIT_HOL_BLOCK_EN and INIT_HOL_BLOCK_TIMER endpoint registers
>>> are only valid for RX endpoints.
>>>
>>> Have ipa_endpoint_modem_hol_block_clear_all() skip writing these
>>> registers for TX endpoints.
>>>
>>> Signed-off-by: Alex Elder <elder@linaro.org>
>>> ---
>>>  drivers/net/ipa/ipa_endpoint.c | 6 +++++-
>>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
>>> index 9f50d0d11704..3f5a41fc1997 100644
>>> --- a/drivers/net/ipa/ipa_endpoint.c
>>> +++ b/drivers/net/ipa/ipa_endpoint.c
>>> @@ -642,6 +642,8 @@ static int ipa_endpoint_init_hol_block_timer(struct ipa_endpoint *endpoint,
>>>  	u32 offset;
>>>  	u32 val;
>>>  
>>> +	/* assert(!endpoint->toward_ipa); */
>>> +
>>>  	/* XXX We'll fix this when the register definition is clear */
>>>  	if (microseconds) {
>>>  		struct device *dev = &ipa->pdev->dev;
>>> @@ -671,6 +673,8 @@ ipa_endpoint_init_hol_block_enable(struct ipa_endpoint *endpoint, bool enable)
>>>  	u32 offset;
>>>  	u32 val;
>>>  
>>> +	/* assert(!endpoint->toward_ipa); */
>> 
>> What are these assert comments for? :S
> 
> They are place holders for when I can put in a proper assert
> function.  For now I'm trying to avoid BUG_ON() calls, but
> at some point soon I'll replace these comments with calls
> to a macro that does BUG_ON() conditioned on a config option
> (or something else if there's a better suggestion).
> 
> Even though it's commented, the assert() call does what
> I want, which is to communicate to the reader a condition
> assumed by the code, succinctly.

Never BUG_ON() unless you absolutely cannot continue executing kernel
without corrupting memory or similar.

If you can error out in some way at all, do not BUG().
