Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551AB3F7B92
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 19:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242363AbhHYRaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 13:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242359AbhHYRaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 13:30:39 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 528E7C061757
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 10:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=7y3Q6M07gXg4HMRB4g9ObQ0nQ6TauvKwSdCFCWQ0WDw=; b=L04eDKQi9X5O02xlO9Av5ZZ12E
        JkhFJv4hzRFtNtlXW/q3Nuh5ixFie84jxhZiVdynrboONsdl3x1BjAOT/PZxDyEJRUDBe8ByCRKd+
        +vOuSTT0hDWg5DRaFtc2++SvPUXfsB+6kQTXFxfbmaD0wIRdQBp7WMi+yKCXN0ma1QNxEpJHf+zaT
        Zdj9p3Yw2CwTD4U74qrJFPf9hrVpqxnmx8bkfxokzDL2P5QJTt6/g91xgyVUff0wYL8yhhfhTiArW
        1iK3FtdJkJiKJx9ct9WhnpJVQho9xZMeX2pZ2s1iXj9kqLOTiJAzJ43QU9xGIiVYBEYatp6V5orD8
        DJJAtNcQ==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mIwim-0086HX-Mw; Wed, 25 Aug 2021 17:29:52 +0000
Subject: Re: [PATCH] ptp: ocp: don't allow on S390
To:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Arnd Bergmann <arnd@kernel.org>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Networking <netdev@vger.kernel.org>
References: <20210813203026.27687-1-rdunlap@infradead.org>
 <CAK8P3a3QGF2=WZz6N8wQo2ZQxmVqKToHGmhT4wEtB7tAL+-ruQ@mail.gmail.com>
 <20210820153100.GA9604@hoboy.vegasvil.org>
 <80be0a74-9b0d-7386-323c-c261ca378eef@infradead.org>
 <CAK8P3a11wvEhoEutCNBs5NqiZ2VUA1r-oE1CKBBaYbu_abr4Aw@mail.gmail.com>
 <20210825170813.7muvouqsijy3ysrr@bsd-mbp.dhcp.thefacebook.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <8f0848a6-354d-ff58-7d41-8610dc095773@infradead.org>
Date:   Wed, 25 Aug 2021 10:29:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210825170813.7muvouqsijy3ysrr@bsd-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/25/21 10:08 AM, Jonathan Lemon wrote:
> On Wed, Aug 25, 2021 at 12:55:25PM +0200, Arnd Bergmann wrote:
>> On Tue, Aug 24, 2021 at 11:48 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>>>
>>> On 8/20/21 8:31 AM, Richard Cochran wrote:
>>>> On Fri, Aug 20, 2021 at 12:45:42PM +0200, Arnd Bergmann wrote:
>>>>
>>>>> I would also suggest removing all the 'imply' statements, they
>>>>> usually don't do what the original author intended anyway.
>>>>> If there is a compile-time dependency with those drivers,
>>>>> it should be 'depends on', otherwise they can normally be
>>>>> left out.
>>>>
>>>> +1
>>>
>>> Hi,
>>>
>>> Removing the "imply" statements is simple enough and the driver
>>> still builds cleanly without them, so Yes, they aren't needed here.
>>>
>>> Removing the SPI dependency is also clean.
>>>
>>> The driver does use I2C, MTD, and SERIAL_8250 interfaces, so they
>>> can't be removed without some other driver changes, like using
>>> #ifdef/#endif (or #if IS_ENABLED()) blocks and some function stubs.
>>
>> If the SERIAL_8250 dependency is actually required, then using
>> 'depends on' for this is probably better than an IS_ENABLED() check.
>> The 'select' is definitely misplaced here, that doesn't even work when
>> the dependencies fo 8250 itself are not met, and it does force-enable
>> the entire TTY subsystem.
> 
> So, something like the following (untested) patch?
> I admit to not fully understanding all the nuances around Kconfig.

Hi,

You can also remove the "select NET_DEVLINK". The driver builds fine
without it. And please drop the "default n" while at it.

After that, your patch will match my (tested) patch.  :)

thanks.

-- 
~Randy

