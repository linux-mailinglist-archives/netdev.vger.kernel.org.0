Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9720E2E02F7
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 00:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgLUXmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 18:42:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgLUXmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 18:42:23 -0500
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7992C0613D3;
        Mon, 21 Dec 2020 15:41:42 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4D0GFQ12YqzQlRQ;
        Tue, 22 Dec 2020 00:41:14 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1608594072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+SpruTXWYI7kkzwg63Wix/B+XVjogO4KHpq9u4eVk54=;
        b=Ybn4OFRR+VInPVGyZV73PMKEPvPapPVC1CzoUAMxyGHCd+9WGv1gzGf+lVS9QrtrhDgWSy
        nn/ceE4Rfw5TungqySaBY8qZ+OrHKwon8aza7v7pWj1a7BnhGLCht3KJyknv+T66ySY3Ax
        P0Z1kmQr6tpn5R3w2oGdxbVQZkPcyO6Gfcma2EJPp3BlTSgi2cgNVufffBCGN6HuPwuSXB
        y+o+Vcj/b8T4SyTwGVdrdrn/pSf4aiImISYyhP7fsTF3/rXpnMRsc0WD4O2dOHZSCy/TV4
        UTKrQmtFbNPlD2S1BDqdPkDriBYNXITssU9aNkasLxMxE6h35EcKSXwG5ISO4A==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter04.heinlein-hosting.de (spamfilter04.heinlein-hosting.de [80.241.56.122]) (amavisd-new, port 10030)
        with ESMTP id qLzPmxt2L1dn; Tue, 22 Dec 2020 00:41:09 +0100 (CET)
Subject: Re: [PATCH] net: lantiq_etop: check the result of request_irq()
To:     Andrew Lunn <andrew@lunn.ch>,
        Masahiro Yamada <masahiroy@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miguel Ojeda <ojeda@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20201221054323.247483-1-masahiroy@kernel.org>
 <20201221152645.GH3026679@lunn.ch>
 <CAK7LNAQ9vhB6iYHeGV3xcyo8_iLqmGJeJUYOvbdHqN9Wn0mEJg@mail.gmail.com>
 <20201221180433.GE3107610@lunn.ch>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Message-ID: <3197556a-8df8-3959-895b-e4b82de904aa@hauke-m.de>
Date:   Tue, 22 Dec 2020 00:41:07 +0100
MIME-Version: 1.0
In-Reply-To: <20201221180433.GE3107610@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -6.06 / 15.00 / 15.00
X-Rspamd-Queue-Id: E311F1718
X-Rspamd-UID: a3b417
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/21/20 7:04 PM, Andrew Lunn wrote:
> On Tue, Dec 22, 2020 at 12:59:08AM +0900, Masahiro Yamada wrote:
>> On Tue, Dec 22, 2020 at 12:26 AM Andrew Lunn <andrew@lunn.ch> wrote:
>>>
>>> On Mon, Dec 21, 2020 at 02:43:23PM +0900, Masahiro Yamada wrote:
>>>> The declaration of request_irq() in <linux/interrupt.h> is marked as
>>>> __must_check.
>>>>
>>>> Without the return value check, I see the following warnings:
>>>>
>>>> drivers/net/ethernet/lantiq_etop.c: In function 'ltq_etop_hw_init':
>>>> drivers/net/ethernet/lantiq_etop.c:273:4: warning: ignoring return value of 'request_irq', declared with attribute warn_unused_result [-Wunused-result]
>>>>    273 |    request_irq(irq, ltq_etop_dma_irq, 0, "etop_tx", priv);
>>>>        |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>>> drivers/net/ethernet/lantiq_etop.c:281:4: warning: ignoring return value of 'request_irq', declared with attribute warn_unused_result [-Wunused-result]
>>>>    281 |    request_irq(irq, ltq_etop_dma_irq, 0, "etop_rx", priv);
>>>>        |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>>>
>>>> Reported-by: Miguel Ojeda <ojeda@kernel.org>
>>>> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
>>>> ---
>>>>
>>>>   drivers/net/ethernet/lantiq_etop.c | 13 +++++++++++--
>>>>   1 file changed, 11 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
>>>> index 2d0c52f7106b..960494f9752b 100644
>>>> --- a/drivers/net/ethernet/lantiq_etop.c
>>>> +++ b/drivers/net/ethernet/lantiq_etop.c
>>>> @@ -264,13 +264,18 @@ ltq_etop_hw_init(struct net_device *dev)
>>>>        for (i = 0; i < MAX_DMA_CHAN; i++) {
>>>>                int irq = LTQ_DMA_CH0_INT + i;
>>>>                struct ltq_etop_chan *ch = &priv->ch[i];
>>>> +             int ret;
>>>>
>>>>                ch->idx = ch->dma.nr = i;
>>>>                ch->dma.dev = &priv->pdev->dev;
>>>>
>>>>                if (IS_TX(i)) {
>>>>                        ltq_dma_alloc_tx(&ch->dma);
>>>> -                     request_irq(irq, ltq_etop_dma_irq, 0, "etop_tx", priv);
>>>> +                     ret = request_irq(irq, ltq_etop_dma_irq, 0, "etop_tx", priv);
>>>> +                     if (ret) {
>>>> +                             netdev_err(dev, "failed to request irq\n");
>>>> +                             return ret;
>>>
>>> You need to cleanup what ltq_dma_alloc_tx() did.
>>
>>
>> Any failure from this function will roll back
>> in the following paths:
>>
>>    ltq_etop_hw_exit()
>>       -> ltq_etop_free_channel()
>>            -> ltq_dma_free()
>>
>>
>> So, dma is freed anyway.
>>
>> One problem I see is,
>> ltq_etop_hw_exit() frees all DMA channels,
>> some of which may not have been allocated yet.
>>
>> If it is a bug, it is an existing bug.
>>
>>
>>>
>>>> +                     }
>>>>                } else if (IS_RX(i)) {
>>>>                        ltq_dma_alloc_rx(&ch->dma);
>>>>                        for (ch->dma.desc = 0; ch->dma.desc < LTQ_DESC_NUM;
>>>> @@ -278,7 +283,11 @@ ltq_etop_hw_init(struct net_device *dev)
>>>>                                if (ltq_etop_alloc_skb(ch))
>>>>                                        return -ENOMEM;
>>
>>
>> This -ENOMEM does not roll back anything here.
>>
>> As stated above, dma_free_coherent() is called.
>> The problem is, ltq_etop_hw_exit() rolls back too much.
>>
>> If your requirement is "this driver is completely wrong. Please rewrite it",
>> sorry, I cannot (unless I am paid to do so).
>>
>> I am just following this driver's roll-back model.
>>
>> Please do not expect more to a person who
>> volunteers to eliminate build warnings.
>>
>> Of course, if somebody volunteers to rewrite this driver correctly,
>> that is appreciated.
> 
> Hi Hauke
> 
> Do you still have this hardware? Do you have time to take a look at
> the cleanup code?
> 
> Thanks
> 	Andrew
> 

Hi Andrew,

I have this hardware somewhere at home, but I never made it work.
If I find some time I can have a loom at this problem in the next few weeks.

Hauke
