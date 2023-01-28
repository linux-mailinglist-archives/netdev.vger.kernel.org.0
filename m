Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04DD667F80A
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 14:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234320AbjA1NaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 08:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbjA1NaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 08:30:20 -0500
X-Greylist: delayed 138 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 28 Jan 2023 05:30:20 PST
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D75D20057;
        Sat, 28 Jan 2023 05:30:19 -0800 (PST)
Received: from [192.168.2.51] (p4fe71212.dip0.t-ipconnect.de [79.231.18.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 2F8D6C0B7D;
        Sat, 28 Jan 2023 14:30:18 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1674912618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4mdqGqv2BgX/GxZf2yMkOIhITBqaR1xv+UfObZcYJAs=;
        b=twtC5u5k+Pj4DFgTKWHmW9bdmhMXmQ8fk/rOLBSpwcvKYidnvVgJQWW//Yjbz45CWrPH5A
        8qxvoYAj4qPN3jxWhvJz191zgQ3fMWIyLBgDCMabO37zCFezW/zhA0icA1TxQ8hWX1oPqV
        lDJBdVpnyCuvozVxlJJVaaBDFsAeelpNdBbJknpkxLuEwLozDOqLtdVidYGzSUoDFthjNM
        Cq+jgmbbTcUuIfMjutRfZi3n95jK5XHbyYEEN6hiAqen5uqb5K5yXB07tGjHYKtRMUfnSi
        +pXMVkt/EqFtQRYUnAyXN/ul1v9h196q0pUk2b4AlLGhshr1NMvxYInmEBdLDA==
Message-ID: <9a09a41b-1eb9-edc9-28ad-acb920e04ae4@datenfreihafen.org>
Date:   Sat, 28 Jan 2023 14:30:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] ca8210: move to gpio descriptors
Content-Language: en-US
To:     Arnd Bergmann <arnd@arndb.de>, Arnd Bergmann <arnd@kernel.org>,
        Alexander Aring <alex.aring@gmail.com>
Cc:     "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hauke Mehrtens <hauke@hauke-m.de>, linux-wpan@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
References: <20230126161737.2985704-1-arnd@kernel.org>
 <57e74219-d439-4d10-9bb5-53fe7b30b46f@app.fastmail.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <57e74219-d439-4d10-9bb5-53fe7b30b46f@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Arnd.

On 26.01.23 17:25, Arnd Bergmann wrote:
> On Thu, Jan 26, 2023, at 17:17, Arnd Bergmann wrote:
> 
>>   	if (ret) {
>> -		dev_crit(&spi->dev, "request_irq %d failed\n", pdata->irq_id);
>> -		gpiod_unexport(gpio_to_desc(pdata->gpio_irq));
>> -		gpio_free(pdata->gpio_irq);
>> +		dev_crit(&spi->dev, "request_irq %d failed\n", priv->irq_id);
>> +		gpiod_put(priv->gpio_irq);
>>   	}
> 
> I just realized that this bit depends on the "gpiolib: remove
> legacy gpio_export" patch I sent to the gpio mailing list earlier.
> 
> We can probably just defer this change until that is merged,
> or alternatively I can rebase this patch to avoid the
> dependency.

Deferring the change until i picked it up from Linus or net-next in my 
tree is fine. This driver is not heavily worked on (its actually marked 
as orphaned) so the patch should still apply in a few days.

I will keep it in my patchwork queue of patches to be applied. No extra 
work needed from your side.

regards
Stefan Schmidt
