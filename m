Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF8A827896
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 10:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730081AbfEWI4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 04:56:49 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48618 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfEWI4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 04:56:49 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CA8F56087A; Thu, 23 May 2019 08:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1558601807;
        bh=QoKQwUVsXxnHAUsIMkOKP7NNW7ia3bSoaSYhBVtRhcg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=dTPlFvRNEmYC83Nd6i6hbIH4UX1Uvko11xoqQIe2Emx/T5ij2pFlIG4XBsfIrmict
         kz+gxTVU6DJtTGfeIscXEaMRi79gj4dP+W3jsL/6M/th0PWx5kYilbYGF+/jPx5S5F
         Qf83Ci2iDtX/9G2JRXFufW5Gyihk6VjDurT/xQfo=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B2948600C1;
        Thu, 23 May 2019 08:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1558601806;
        bh=QoKQwUVsXxnHAUsIMkOKP7NNW7ia3bSoaSYhBVtRhcg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=MH+aR2BiPZAWTJ6vhDfYNLht5Ff4iza9NCDSQvT4M8jR5ul3KhM90rlU58og0wscl
         Ttp9jZcgT1WsQ/4dXS/Kz+u7GR5J29d/fcMKlsdGuM4hvkDU8508besFkk7DJlwQU4
         t/G4kqfy89muTbGYh/UduvUPO3K7sz6Wdm/NEUE8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B2948600C1
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH] rsi: Properly initialize data in rsi_sdio_ta_reset
References: <20190502151548.11143-1-natechancellor@gmail.com>
        <CAKwvOd=nvKGGW5jvN+WFUXzOm9xeiNNUD0F9--9YcpuRmnWWhA@mail.gmail.com>
        <20190503031718.GB6969@archlinux-i9>
        <20190523015415.GA17819@archlinux-epyc>
        <CAK8P3a001V5qQo4vGfpugtmrnFfUNeP_q4KY-YS7rP_L91HY1A@mail.gmail.com>
Date:   Thu, 23 May 2019 11:56:42 +0300
In-Reply-To: <CAK8P3a001V5qQo4vGfpugtmrnFfUNeP_q4KY-YS7rP_L91HY1A@mail.gmail.com>
        (Arnd Bergmann's message of "Thu, 23 May 2019 10:51:01 +0200")
Message-ID: <87mujdo8fp.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

>> > @@ -937,7 +937,7 @@ static int rsi_sdio_ta_reset(struct rsi_hw *adapter)
>> >         }
>> >
>> >         rsi_dbg(INIT_ZONE, "%s: Bring TA out of reset\n", __func__);
>> > -       put_unaligned_le32(TA_HOLD_THREAD_VALUE, data);
>> > +       put_unaligned_le32(TA_HOLD_THREAD_VALUE, &data);
>> >         addr = TA_HOLD_THREAD_REG | RSI_SD_REQUEST_MASTER;
>> >         status = rsi_sdio_write_register_multiple(adapter, addr,
>> >                                                   (u8 *)&data,
>
> This is clearly not ok, as put_unaligned_le32() stores four bytes, and
> the local variable is only one byte!
>
> Also, sdio does use DMA for transfers, so the variable has to be
> dynamically allocated. I think your original patch was correct.
> The only change I'd possibly make would be to use
> RSI_9116_REG_SIZE instead of sizeof(u32).

Good point. Nathan please fix this and submit v2.

>> Did any of the maintainers have any comments on what the correct
>> solution is here to resolve this warning? It is one of the few left
>> before we can turn on -Wuninitialized for the whole kernel.
>
> I would argue that this should not stop us from turning it on, as the
> warning is for a clear bug in the code that absolutely needs to be
> fixed, rather than a false-positive.

I can queue v2 for v5.2, just remind me by adding "[PATCH v2 5.2]" to
the subject.

-- 
Kalle Valo
