Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B92CE126F1
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 06:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbfECEi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 00:38:59 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38780 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfECEi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 00:38:59 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8FD2961132; Fri,  3 May 2019 04:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556858337;
        bh=tmO9bZ8OSVF3w2WCn5bCHHR5VcAERihrVuWPn4eTVVo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=WbnuGeem6wmks0G9pvkliRJ6bjIvrLEVb6rrx++NvPHTdORn3mOwTDs6+pFTzinpB
         h7Kf6R/cDEEoHkPiwIUZ5WBrAPbCVfcRWKaVQft497o7Q7dKMqfRukBXM/YWKzBKwy
         lCyBYfXos0w7Fk8v81YA1Frrw92+fKX/lOmk24Bc=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0C86761132;
        Fri,  3 May 2019 04:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556858336;
        bh=tmO9bZ8OSVF3w2WCn5bCHHR5VcAERihrVuWPn4eTVVo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=fpIR+sx5CPmg8HXT9vrjKMg1KHUbBWFs1aO5cxUOWDpbKGz2qI2tfGlh57TuLckqx
         gjobOfW5e64o+zFQ489u4LtJX981TYPVJPcfR85Qv6SHq29+HXvxjfEihIZXNqnT9T
         R7L0A2poNp4dT2nbjSvNiW9qvzgHAoetI7ndp0Gk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0C86761132
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH] rsi: Properly initialize data in rsi_sdio_ta_reset
References: <20190502151548.11143-1-natechancellor@gmail.com>
        <CAKwvOd=nvKGGW5jvN+WFUXzOm9xeiNNUD0F9--9YcpuRmnWWhA@mail.gmail.com>
Date:   Fri, 03 May 2019 07:38:52 +0300
In-Reply-To: <CAKwvOd=nvKGGW5jvN+WFUXzOm9xeiNNUD0F9--9YcpuRmnWWhA@mail.gmail.com>
        (Nick Desaulniers's message of "Thu, 2 May 2019 11:18:01 -0700")
Message-ID: <87h8ackv8j.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nick Desaulniers <ndesaulniers@google.com> writes:

> On Thu, May 2, 2019 at 8:16 AM Nathan Chancellor
> <natechancellor@gmail.com> wrote:
>>
>> When building with -Wuninitialized, Clang warns:
>>
>> drivers/net/wireless/rsi/rsi_91x_sdio.c:940:43: warning: variable 'data'
>> is uninitialized when used here [-Wuninitialized]
>>         put_unaligned_le32(TA_HOLD_THREAD_VALUE, data);
>>                                                  ^~~~
>> drivers/net/wireless/rsi/rsi_91x_sdio.c:930:10: note: initialize the
>> variable 'data' to silence this warning
>>         u8 *data;
>>                 ^
>>                  = NULL
>> 1 warning generated.
>>
>> Using Clang's suggestion of initializing data to NULL wouldn't work out
>> because data will be dereferenced by put_unaligned_le32. Use kzalloc to
>> properly initialize data, which matches a couple of other places in this
>> driver.
>>
>> Fixes: e5a1ecc97e5f ("rsi: add firmware loading for 9116 device")
>> Link: https://github.com/ClangBuiltLinux/linux/issues/464
>> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
>> ---
>>  drivers/net/wireless/rsi/rsi_91x_sdio.c | 21 ++++++++++++++-------
>>  1 file changed, 14 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
>> index f9c67ed473d1..b35728564c7b 100644
>> --- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
>> +++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
>> @@ -929,11 +929,15 @@ static int rsi_sdio_ta_reset(struct rsi_hw *adapter)
>>         u32 addr;
>>         u8 *data;
>>
>> +       data = kzalloc(sizeof(u32), GFP_KERNEL);
>
> Something fishy is going on here.  We allocate 4 B but declare data as
> a u8* (pointer to individual bytes)?  In general, dynamically
> allocating that few bytes is a code smell; either you meant to just
> use the stack, or this memory's lifetime extends past the lifetime of
> this stackframe, at which point you probably just meant to stack
> allocate space in a higher parent frame and pass this preallocated
> memory down to the child frame to get filled in.
>
> Reading through this code, I don't think that the memory is meant to
> outlive the stack frame.  Is there a reason why we can't just declare
> data as:
>
> u8 data [4];
>
> then use ARRAY_SIZE(data) or RSI_9116_REG_SIZE in rsi_reset_chip(),
> getting rid of the kzalloc/kfree?

I haven't checked the details but AFAIK stack variables are not supposed
to be used with DMA. So in that case I think it's ok alloc four bytes,
unless the DMA rules have changed of course. But I didn't check if rsi
is using DMA here, just a general comment.

-- 
Kalle Valo
