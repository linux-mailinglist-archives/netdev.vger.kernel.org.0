Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A43A9405A2F
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 17:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236597AbhIIP2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 11:28:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52012 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbhIIP2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 11:28:38 -0400
Received: from localhost (cpc147930-brnt3-2-0-cust60.4-2.cable.virginm.net [86.15.196.61])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 877AC4F670CF6;
        Thu,  9 Sep 2021 08:27:27 -0700 (PDT)
Date:   Thu, 09 Sep 2021 16:27:21 +0100 (BST)
Message-Id: <20210909.162721.1267526781289116670.davem@davemloft.net>
To:     linux@roeck-us.net
Cc:     ajk@comnets.uni-bremen.de, kuba@kernel.org,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: 6pack: Fix tx timeout and slot time
From:   David Miller <davem@davemloft.net>
In-Reply-To: <751f5079-2da1-187e-573c-d7d2d6743bbf@roeck-us.net>
References: <20210909035743.1247042-1-linux@roeck-us.net>
        <20210909.123442.1648633411296774237.davem@davemloft.net>
        <751f5079-2da1-187e-573c-d7d2d6743bbf@roeck-us.net>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 09 Sep 2021 08:27:28 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>
Date: Thu, 9 Sep 2021 07:53:29 -0700

> On 9/9/21 4:34 AM, David Miller wrote:
>> From: Guenter Roeck <linux@roeck-us.net>
>> Date: Wed,  8 Sep 2021 20:57:43 -0700
>> 
>>> tx timeout and slot time are currently specified in units of HZ.
>>> On Alpha, HZ is defined as 1024. When building alpha:allmodconfig,
>>> this results in the following error message.
>>>
>>> drivers/net/hamradio/6pack.c: In function 'sixpack_open':
>>> drivers/net/hamradio/6pack.c:71:41: error:
>>> 	unsigned conversion from 'int' to 'unsigned char'
>>> 	changes value from '256' to '0'
>>>
>>> In the 6PACK protocol, tx timeout is specified in units of 10 ms
>>> and transmitted over the wire. Defining a value dependent on HZ
>>> doesn't really make sense. Assume that the intent was to set tx
>>> timeout and slot time based on a HZ value of 100 and use constants
>>> instead of values depending on HZ for SIXP_TXDELAY and SIXP_SLOTTIME.
>>>
>>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>>> ---
>>> No idea if this is correct or even makes sense. Compile tested only.
>> These are timer offsets so they have to me HZ based.  Better to make
>> the
>> structure members unsigned long, I think.
>> 
> 
> Hmm, ok. Both tx_delay and slottime are updated in sp_encaps(),
> though,
> from data in the transmit buffer. The KISS protocol description states
> that the values are in units of 10ms; that is where my assumption
> came from.

They are ms and must be converted using to HZ in order to use the values as timer offsets.

The values are perfectly fine, the types used to store them need to be fixed.

> Anyway, I am inclined to just mark the protocol as dependent on
> !ALPHA. Would you accept that ?

No, fix this properly.  Make the unsigfned char members be unsigned long.

Why do you not want to fix it this way?

Thank you.
