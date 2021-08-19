Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477BB3F2375
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 00:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236572AbhHSW7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 18:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236542AbhHSW7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 18:59:11 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5FBC061757
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 15:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=4eDJ/0iHNTkvfDOmWYw2uM6PZUV+Ja5nvO1EWh0jB7s=; b=adXxGidZyNHhdhbZqkL62u7SeM
        MwlBizxjuZV0+5JNTylkrEokuDqWgPv4/Y04VoCNk+qWmf+KMImNXMrNUG45Alf04S5kIlRUi9Hn/
        +TpC+1ilTpgzQozfcenFbEoXgkGAo/WztiZkS0L+LtqDaaRtW/MBFOyD8FS+KiudZfd/H1Rpdt5tr
        v9wOUn7ufji41oC661VuZKaTvwPYMpBpfkhHAf6LpvGWVkWXpXCSZHM+eL9w1vLoOpnB69tSsKeQx
        WB6sLFEcfceeFwFChatG6WaNILKcSkGn8mKeRcX9k+vRIt/9NgzgKkVzD2NmsVE3SGa0B0pwpNsIN
        FFgULv5A==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mGqzZ-009gbI-GQ; Thu, 19 Aug 2021 22:58:33 +0000
Subject: Re: [PATCH] ptp: ocp: don't allow on S390
To:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc:     netdev@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>
References: <20210813203026.27687-1-rdunlap@infradead.org>
 <20210816210914.qkyd4em4rw3thbyg@bsd-mbp.dhcp.thefacebook.com>
 <16acf1ad-d626-b3a3-1cad-3fa6c61c8a22@infradead.org>
 <20210816214103.w54pfwcuge4nqevw@bsd-mbp.dhcp.thefacebook.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <0e6bd492-a3f5-845c-9d93-50f1cc182a62@infradead.org>
Date:   Thu, 19 Aug 2021 15:58:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210816214103.w54pfwcuge4nqevw@bsd-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/16/21 2:41 PM, Jonathan Lemon wrote:
> On Mon, Aug 16, 2021 at 02:15:51PM -0700, Randy Dunlap wrote:
>> On 8/16/21 2:09 PM, Jonathan Lemon wrote:
>>> On Fri, Aug 13, 2021 at 01:30:26PM -0700, Randy Dunlap wrote:
>>>> There is no 8250 serial on S390. See commit 1598e38c0770.
>>>
>>> There's a 8250 serial device on the PCI card.   Its been
>>> ages since I've worked on the architecture, but does S390
>>> even support PCI?
>>
>> Yes, it does.
>>
>>>> Is this driver useful even without 8250 serial?
>>>
>>> The FB timecard has an FPGA that will internally parse the
>>> GNSS strings and correct the clock, so the PTP clock will
>>> work even without the serial devices.
>>>
>>> However, there are userspace tools which want to read the
>>> GNSS signal (for holdolver and leap second indication),
>>> which is why they are exposed.
>>
>> So what do you recommend here?
> 
> Looking at 1598e38c0770, it appears the 8250 console is the
> problem.  Couldn't S390 be fenced by SERIAL_8250_CONSOLE, instead
> of SERIAL_8250, which would make the 8250 driver available?

OK, that sounds somewhat reasonable.

> For now, just disabling the driver on S390 sounds reasonable.
> 

S390 people, how does this look to you?

This still avoids having serial 8250 console conflicting
with S390's sclp console.
(reference commit 1598e38c0770)


---
  drivers/tty/serial/8250/Kconfig |    2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20210819.orig/drivers/tty/serial/8250/Kconfig
+++ linux-next-20210819/drivers/tty/serial/8250/Kconfig
@@ -6,7 +6,6 @@
  
  config SERIAL_8250
  	tristate "8250/16550 and compatible serial support"
-	depends on !S390
  	select SERIAL_CORE
  	select SERIAL_MCTRL_GPIO if GPIOLIB
  	help
@@ -85,6 +84,7 @@ config SERIAL_8250_FINTEK
  config SERIAL_8250_CONSOLE
  	bool "Console on 8250/16550 and compatible serial port"
  	depends on SERIAL_8250=y
+	depends on !S390
  	select SERIAL_CORE_CONSOLE
  	select SERIAL_EARLYCON
  	help


-- 
~Randy

