Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C07AE381A7B
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 20:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234434AbhEOSZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 14:25:23 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:50907 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234414AbhEOSZT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 May 2021 14:25:19 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1621103045; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=ch3A0RldTQj2BJift1c1BerWB0aD14nIhxK4TmHg/Ss=; b=VyGlR7M25106qM9D4vwFhOalFA08ztlG3d6d6/mjoWU6FsAHnHT5VaPUvSVbPXtC2ZkEO3Ah
 IXUmJAqKeCRISpGO5mNlZ9lF5s6wK409xcPUM+X/5VcnClFs/yX/OqOhgorABGrmdsAiu0K/
 WcGL8GauyWYRJy4H9fIZXZW2cBQ=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 60a011bd7b5af81b5c419f60 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 15 May 2021 18:23:57
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C0EF0C4323A; Sat, 15 May 2021 18:23:57 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 86F7AC433D3;
        Sat, 15 May 2021 18:23:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 86F7AC433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     linux-arch <linux-arch@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Devidas Puranik <devidas@marvell.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devidas.puranik@nxp.com
Subject: Re: [PATCH v2 10/13] mwifiex: re-fix for unaligned accesses
References: <20210514100106.3404011-1-arnd@kernel.org>
        <20210514100106.3404011-11-arnd@kernel.org>
        <87lf8gikhp.fsf@codeaurora.org>
        <CAK8P3a0zc7GGEjPzYsAi=EPxs+3PL0PuhiRF2DfAfR1OHAn+gg@mail.gmail.com>
Date:   Sat, 15 May 2021 21:23:51 +0300
In-Reply-To: <CAK8P3a0zc7GGEjPzYsAi=EPxs+3PL0PuhiRF2DfAfR1OHAn+gg@mail.gmail.com>
        (Arnd Bergmann's message of "Sat, 15 May 2021 11:01:02 +0200")
Message-ID: <878s4fj1oo.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> writes:

> On Sat, May 15, 2021 at 8:22 AM Kalle Valo <kvalo@codeaurora.org> wrote:
>> Arnd Bergmann <arnd@kernel.org> writes:
>> > From: Arnd Bergmann <arnd@arndb.de>
>> >
>> > A patch from 2017 changed some accesses to DMA memory to use
>> > get_unaligned_le32() and similar interfaces, to avoid problems
>> > with doing unaligned accesson uncached memory.
>> >
>> > However, the change in the mwifiex_pcie_alloc_sleep_cookie_buf()
>> > function ended up changing the size of the access instead,
>> > as it operates on a pointer to u8.
>> >
>> > Change this function back to actually access the entire 32 bits.
>> > Note that the pointer is aligned by definition because it came
>> > from dma_alloc_coherent().
>> >
>> > Fixes: 92c70a958b0b ("mwifiex: fix for unaligned reads")
>> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>>
>> Via which tree should this go? I assume it will go via some other tree
>> so:
>>
>> Acked-by: Kalle Valo <kvalo@codeaurora.org>
>
> I have queued the series in the asm-generic tree for 5.14, as the patches
> that depend on this one are a little too invasive for 5.13 at this point.
>
> If you think this fix should be in 5.13, please take it through your tree.

I think v5.14 is more approriate, so please take this via your tree.
Thanks.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
