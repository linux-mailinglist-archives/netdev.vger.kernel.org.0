Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 785049B830
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 23:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436907AbfHWVap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 17:30:45 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38124 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389419AbfHWVao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 17:30:44 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EFD181543B28D;
        Fri, 23 Aug 2019 14:30:43 -0700 (PDT)
Date:   Fri, 23 Aug 2019 14:30:43 -0700 (PDT)
Message-Id: <20190823.143043.2108633405675062512.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     dan.carpenter@oracle.com, inaky.perez-gonzalez@intel.com,
        linux-wimax@intel.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wimax/i2400m: fix calculation of index, remove sizeof
From:   David Miller <davem@davemloft.net>
In-Reply-To: <300939a6-33b6-a941-1875-0f7fe610d441@canonical.com>
References: <20190823085230.6225-1-colin.king@canonical.com>
        <20190823112337.GB23408@kadam>
        <300939a6-33b6-a941-1875-0f7fe610d441@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 23 Aug 2019 14:30:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>
Date: Fri, 23 Aug 2019 12:27:00 +0100

> On 23/08/2019 12:23, Dan Carpenter wrote:
>> On Fri, Aug 23, 2019 at 09:52:30AM +0100, Colin King wrote:
>>> From: Colin Ian King <colin.king@canonical.com>
>>>
>>> The subtraction of the two pointers is automatically scaled by the
>>> size of the size of the object the pointers point to, so the division
>>> by sizeof(*i2400m->barker) is incorrect.  Fix this by removing the
>>> division.  Also make index an unsigned int to clean up a checkpatch
>>> warning.
>>>
>>> Addresses-Coverity: ("Extra sizeof expression")
>>> Fixes: aba3792ac2d7 ("wimax/i2400m: rework bootrom initialization to be more flexible")
>>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>>> ---
>>>  drivers/net/wimax/i2400m/fw.c | 3 +--
>>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/wimax/i2400m/fw.c b/drivers/net/wimax/i2400m/fw.c
>>> index 489cba9b284d..599a703af6eb 100644
>>> --- a/drivers/net/wimax/i2400m/fw.c
>>> +++ b/drivers/net/wimax/i2400m/fw.c
>>> @@ -399,8 +399,7 @@ int i2400m_is_boot_barker(struct i2400m *i2400m,
>>>  	 * associated with the device. */
>>>  	if (i2400m->barker
>>>  	    && !memcmp(buf, i2400m->barker, sizeof(i2400m->barker->data))) {
>>> -		unsigned index = (i2400m->barker - i2400m_barker_db)
>>> -			/ sizeof(*i2400m->barker);
>>> +		unsigned int index = i2400m->barker - i2400m_barker_db;
>>>  		d_printf(2, dev, "boot barker cache-confirmed #%u/%08x\n",
>>>  			 index, le32_to_cpu(i2400m->barker->data[0]));
>> 
>> It's only used for this debug output.  You may as well just delete it.
>> 
>>>  		return 0;
> 
> Deleting wrong debug code vs fixing debug code? I'd rather go for the
> latter.

It's been wrong since day one, so it's been useful for absolutely nobody.

This is also an ancient driver for hardware no longer in production.

Dan is right, just remove this stuff, thanks.
