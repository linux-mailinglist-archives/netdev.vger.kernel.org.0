Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15A912F19D7
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 16:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730764AbhAKPgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 10:36:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727917AbhAKPgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 10:36:21 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B522EC061795
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 07:35:40 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=[IPv6:::1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1kyzED-0000NB-Uf; Mon, 11 Jan 2021 16:35:34 +0100
Subject: Re: [net-next 15/19] can: tcan4x5x: rework SPI access
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        kernel@pengutronix.de, Sean Nyekjaer <sean@geanix.com>,
        davem@davemloft.net
References: <20210107094900.173046-1-mkl@pengutronix.de>
 <20210107094900.173046-16-mkl@pengutronix.de>
 <20210107110035.42a6bb46@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210107110656.7e49772b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <c98003bf-e62a-ab6a-a526-1f3ed0bb1ab7@pengutronix.de>
 <20210107143851.51675f8d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <8185f3e1-d0b1-0ea4-ac45-f2ea0b63ced9@pengutronix.de>
 <20210108083229.6f42479b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
Message-ID: <7a0e400a-7522-f3f0-55e1-887127636c09@pengutronix.de>
Date:   Mon, 11 Jan 2021 16:35:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20210108083229.6f42479b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub,

On 08.01.21 17:32, Jakub Kicinski wrote:
> On Fri, 8 Jan 2021 11:07:26 +0100 Ahmad Fatoum wrote:
>>>>> +struct __packed tcan4x5x_map_buf { 
>>>>> +	struct tcan4x5x_buf_cmd cmd; 
>>>>> +	u8 data[256 * sizeof(u32)]; 
>>>>> +} ____cacheline_aligned;     
>>>>
>>>> Due to the packing of the struct tcan4x5x_buf_cmd it should have a length of 4
>>>> bytes. Without __packed, will the "u8 data" come directly after the cmd?  
>>>
>>> Yup, u8 with no alignment attribute will follow the previous
>>> field with no holes.  
>>
>> __packed has a documentation benefit though. It documents that the author
>> considers the current layout to be the only correct one. (and thus extra
>> care should be taken when modifying it).
> 
> ____cacheline_aligned adds a big architecture dependent padding at the
> end of this struct, so the size of this structure is architecture
> dependent. Besides using packed forced the compiler to use byte by byte
> loads on architectures without unaligned access, so __packed is not
> free.

https://godbolt.org/z/j68x8n

seems to indicate that explicit alignment "overrules" packed's implicit
alignment of 1 as
 there isn't any byte-by-byte access generated for a struct
that is both packed and cacheline aligned. packed only structs are accessed
byte-by-byte however.

Did I get something wrong in my testcase?

I compiled with ARM gcc 8.2  -mno-unaligned-access -fno-strict-aliasing -O2

Cheers,
Ahmad
 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
