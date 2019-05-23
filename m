Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5042787E
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 10:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730225AbfEWIwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 04:52:25 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:43912 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbfEWIwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 04:52:25 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0A7FD60E7A; Thu, 23 May 2019 08:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1558601543;
        bh=a4w+WoaBzHQtJcAdG7QaHXhgB3zJUnpS03WiEED1hyM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=VLVnf36ckwKd+IFe3C3tePH9xlwtYWCSeT1NWdLJXfdxz11SotMzBxTEdhWSYvQa5
         PSRS7ZXQMJyAS+npTcgGxzZPRlWn7D28jGd7+ItpiYTesNayJZYsrglUm30qTslSu8
         qXgrmsGllInUL9NZQt+FaJk1UQtbjG9UarXYqkN0=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B2E536118F;
        Thu, 23 May 2019 08:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1558601541;
        bh=a4w+WoaBzHQtJcAdG7QaHXhgB3zJUnpS03WiEED1hyM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=TbaMgyOPWP7nxJq8RTitOmUbpmy5fWZa5Mkljkk68VNl6roXTVP2qUIrkQkDPZ9x9
         fHh5ALXGkD32H9aE/C2gF/YKN5tFIi5RsgbXxISL7dIYCxSikGV7PT0ZdFVTdJoE0g
         JuGW3kr0DTrr36y5gVrpHIKLIgJ3I9lU9dCxq7PI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B2E536118F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH] rsi: Properly initialize data in rsi_sdio_ta_reset
References: <20190502151548.11143-1-natechancellor@gmail.com>
        <CAKwvOd=nvKGGW5jvN+WFUXzOm9xeiNNUD0F9--9YcpuRmnWWhA@mail.gmail.com>
        <20190503031718.GB6969@archlinux-i9>
        <20190523015415.GA17819@archlinux-epyc>
Date:   Thu, 23 May 2019 11:52:17 +0300
In-Reply-To: <20190523015415.GA17819@archlinux-epyc> (Nathan Chancellor's
        message of "Wed, 22 May 2019 18:54:15 -0700")
Message-ID: <87r28po8n2.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nathan Chancellor <natechancellor@gmail.com> writes:

> On Thu, May 02, 2019 at 08:17:18PM -0700, Nathan Chancellor wrote:
>> On Thu, May 02, 2019 at 11:18:01AM -0700, Nick Desaulniers wrote:
>> > On Thu, May 2, 2019 at 8:16 AM Nathan Chancellor
>> > <natechancellor@gmail.com> wrote:
>> > >
>> > > When building with -Wuninitialized, Clang warns:
>> > >
>> > > drivers/net/wireless/rsi/rsi_91x_sdio.c:940:43: warning: variable 'data'
>> > > is uninitialized when used here [-Wuninitialized]
>> > >         put_unaligned_le32(TA_HOLD_THREAD_VALUE, data);
>> > >                                                  ^~~~
>> > > drivers/net/wireless/rsi/rsi_91x_sdio.c:930:10: note: initialize the
>> > > variable 'data' to silence this warning
>> > >         u8 *data;
>> > >                 ^
>> > >                  = NULL
>> > > 1 warning generated.
>> > >
>> > > Using Clang's suggestion of initializing data to NULL wouldn't work out
>> > > because data will be dereferenced by put_unaligned_le32. Use kzalloc to
>> > > properly initialize data, which matches a couple of other places in this
>> > > driver.
>> > >
>> > > Fixes: e5a1ecc97e5f ("rsi: add firmware loading for 9116 device")
>> > > Link: https://github.com/ClangBuiltLinux/linux/issues/464
>> > > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
>> > > ---
>> > >  drivers/net/wireless/rsi/rsi_91x_sdio.c | 21 ++++++++++++++-------
>> > >  1 file changed, 14 insertions(+), 7 deletions(-)
>> > >
>> > > diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
>> > > index f9c67ed473d1..b35728564c7b 100644
>> > > --- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
>> > > +++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
>> > > @@ -929,11 +929,15 @@ static int rsi_sdio_ta_reset(struct rsi_hw *adapter)
>> > >         u32 addr;
>> > >         u8 *data;
>> > >
>> > > +       data = kzalloc(sizeof(u32), GFP_KERNEL);
>> > 
>> > Something fishy is going on here.  We allocate 4 B but declare data as
>> > a u8* (pointer to individual bytes)?  In general, dynamically
>> > allocating that few bytes is a code smell; either you meant to just
>> > use the stack, or this memory's lifetime extends past the lifetime of
>> > this stackframe, at which point you probably just meant to stack
>> > allocate space in a higher parent frame and pass this preallocated
>> > memory down to the child frame to get filled in.
>> > 
>> > Reading through this code, I don't think that the memory is meant to
>> > outlive the stack frame.  Is there a reason why we can't just declare
>> > data as:
>> > 
>> > u8 data [4];
>> 
>> data was __le32 in rsi_reset_chip() before commit f700546682a6 ("rsi:
>> fix nommu_map_sg overflow kernel panic").
>> 
>> I wonder if this would be okay for this function:
>> 
>> -------------------------------------------------
>> 
>> diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
>> index f9c67ed473d1..0330c50ab99c 100644
>> --- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
>> +++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
>> @@ -927,7 +927,7 @@ static int rsi_sdio_ta_reset(struct rsi_hw *adapter)
>>  {
>>         int status;
>>         u32 addr;
>> -       u8 *data;
>> +       u8 data;
>>  
>>         status = rsi_sdio_master_access_msword(adapter, TA_BASE_ADDR);
>>         if (status < 0) {
>> @@ -937,7 +937,7 @@ static int rsi_sdio_ta_reset(struct rsi_hw *adapter)
>>         }
>>  
>>         rsi_dbg(INIT_ZONE, "%s: Bring TA out of reset\n", __func__);
>> -       put_unaligned_le32(TA_HOLD_THREAD_VALUE, data);
>> +       put_unaligned_le32(TA_HOLD_THREAD_VALUE, &data);
>>         addr = TA_HOLD_THREAD_REG | RSI_SD_REQUEST_MASTER;
>>         status = rsi_sdio_write_register_multiple(adapter, addr,
>>                                                   (u8 *)&data,
>> @@ -947,7 +947,7 @@ static int rsi_sdio_ta_reset(struct rsi_hw *adapter)
>>                 return status;
>>         }
>>  
>> -       put_unaligned_le32(TA_SOFT_RST_CLR, data);
>> +       put_unaligned_le32(TA_SOFT_RST_CLR, &data);
>>         addr = TA_SOFT_RESET_REG | RSI_SD_REQUEST_MASTER;
>>         status = rsi_sdio_write_register_multiple(adapter, addr,
>>                                                   (u8 *)&data,
>> @@ -957,7 +957,7 @@ static int rsi_sdio_ta_reset(struct rsi_hw *adapter)
>>                 return status;
>>         }
>>  
>> -       put_unaligned_le32(TA_PC_ZERO, data);
>> +       put_unaligned_le32(TA_PC_ZERO, &data);
>>         addr = TA_TH0_PC_REG | RSI_SD_REQUEST_MASTER;
>>         status = rsi_sdio_write_register_multiple(adapter, addr,
>>                                                   (u8 *)&data,
>> @@ -967,7 +967,7 @@ static int rsi_sdio_ta_reset(struct rsi_hw *adapter)
>>                 return -EINVAL;
>>         }
>>  
>> -       put_unaligned_le32(TA_RELEASE_THREAD_VALUE, data);
>> +       put_unaligned_le32(TA_RELEASE_THREAD_VALUE, &data);
>>         addr = TA_RELEASE_THREAD_REG | RSI_SD_REQUEST_MASTER;
>>         status = rsi_sdio_write_register_multiple(adapter, addr,
>>                                                   (u8 *)&data,
>> 
>> 
>> > 
>> > then use ARRAY_SIZE(data) or RSI_9116_REG_SIZE in rsi_reset_chip(),
>> > getting rid of the kzalloc/kfree?
>> > 
>> > (Sorry, I hate when a simple fixup becomes a "hey let's rewrite all
>> > this code" thus becoming "that guy.")
>> 
>> If we aren't actually improving the code, then why bother? :)
>> 
>> Thank you for the review!
>
> Did any of the maintainers have any comments on what the correct
> solution is here to resolve this warning? It is one of the few left
> before we can turn on -Wuninitialized for the whole kernel.

I don't have any strong opinion, but as the commit log says that
kzalloc() is also used in similar cases in the same driver I would happy
to take this patch as is.

-- 
Kalle Valo
