Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECAEE15FDE6
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 10:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbgBOJ4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 04:56:52 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33490 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbgBOJ4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 04:56:52 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 541C015D54AD5;
        Sat, 15 Feb 2020 01:56:51 -0800 (PST)
Date:   Sat, 15 Feb 2020 01:56:47 -0800 (PST)
Message-Id: <20200215.015647.1085864163503366086.davem@davemloft.net>
To:     marex@denx.de
Cc:     netdev@vger.kernel.org, lukas@wunner.de, ynezz@true.cz,
        yuehaibing@huawei.com
Subject: Re: [PATCH 2/3] net: ks8851-ml: Fix 16-bit data access
From:   David Miller <davem@davemloft.net>
In-Reply-To: <925845a7-c79b-a434-ca1c-bc9b660aa3ba@denx.de>
References: <20200210184139.342716-2-marex@denx.de>
        <20200215.012458.724817187941650024.davem@davemloft.net>
        <925845a7-c79b-a434-ca1c-bc9b660aa3ba@denx.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 15 Feb 2020 01:56:51 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>
Date: Sat, 15 Feb 2020 10:47:56 +0100

> On 2/15/20 10:24 AM, David Miller wrote:
>> From: Marek Vasut <marex@denx.de>
>> Date: Mon, 10 Feb 2020 19:41:38 +0100
>> 
>>> @@ -197,7 +197,7 @@ static inline void ks_inblk(struct ks_net *ks, u16 *wptr, u32 len)
>>>  {
>>>  	len >>= 1;
>>>  	while (len--)
>>> -		*wptr++ = (u16)ioread16(ks->hw_addr);
>>> +		*wptr++ = swab16(ioread16(ks->hw_addr));
>> 
>> I agree with the other feedback, the endianness looks wrong here.
>> 
>> The ioread16() translates whatever is behind ks->hw_addr into cpu
>> endianness.
>> 
>> This is either always little endian (for example), which means that
>> unconditionally swapping this doesn't seem to make sense.
> 
> So what is the suggestion to fix this properly ?

once you know the endianness coming out of ioread16() you can then
use le16_to_cpu() or be16_to_cpu() as appropriate.
