Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E22341AE0F
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 13:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240408AbhI1LrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 07:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240342AbhI1LrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 07:47:22 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E363C061575;
        Tue, 28 Sep 2021 04:45:43 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id z24so92308044lfu.13;
        Tue, 28 Sep 2021 04:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZFnfwEeJAq8qyzlUHZnHojA4Gqoqc8GcjCT1PQRuPlA=;
        b=idCz1J7YZryuSGAEx0P8dtwU0pPDXZSyD85JKy8/tAEDtrtNW8CsbL9FR1EhFETBx6
         ld+TQKPSWhcOHZ9tYz4UASudaTMxa9E2NPziVZMWXtc9w6UHcnaR2Gk9uaBF4S2cNTiZ
         8xoeewE7Op8Z+MUcTC6HQ4nWOux71j3Lrqz9r6tVq3oIOakElzsgWU6JPzXYYeK1GTYK
         Xec8xkx6CqAJ7o/HnURkNbZb+NQJvFoZHUvZ2FlPuFXVF4cpvdLatMuh6f09d2oqVYNV
         2jVQh56T0/xEJ2jUItZAaa/tEzTARwAd0F35gkmvWBgHCGaAW5J4UHywJUgE3DCsp9Tz
         8Z9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZFnfwEeJAq8qyzlUHZnHojA4Gqoqc8GcjCT1PQRuPlA=;
        b=BXPBcSiSg28xp1/9g5ACT9NLPDKMhZssS1U4EFoW/EAB5dH+HL5Y9R6scBNltUxIe+
         WBMfULyXc1X3oi0rRSAUW5sqseB/LyoAt8mvrEaPIbgmH0wXykjuCqG2SPIwpPkzIFE2
         4GStXxBaQxJa9KcbLP6aqgAJZdfadLVcXXxsFxKBgeVeCS7lt8Rw57I0P9Jkh5EexQOs
         v1hIFYJKDrRa7+N3yRSpc/khbojGh6ljOlKIiv8BkN5UtCHS8GlS62oVZtvy346ifxQz
         hKN23hj0d6T/dXyIsQhNyZdgeZAso0WE3sNdQ9t4FmDyVYiFBkKhliASJ+70XIe5wW+l
         nf4A==
X-Gm-Message-State: AOAM530fZx1BIKvyBs8wHQiukmp3r4dbmOAxCR+ri9/38OoaEZBCnIJm
        28JweUgNOwb0oik5A7JDfh0=
X-Google-Smtp-Source: ABdhPJy6sGn1qi4kGTA9CrQHvb7Jw0OywQqebNn0vrF9RBO9rMSoEkeYLXg1VcSAz8Ty+k8jOWQOTQ==
X-Received: by 2002:a05:6512:39c4:: with SMTP id k4mr5253195lfu.14.1632829541741;
        Tue, 28 Sep 2021 04:45:41 -0700 (PDT)
Received: from [172.28.2.233] ([46.61.204.60])
        by smtp.gmail.com with ESMTPSA id y1sm1892679lfe.292.2021.09.28.04.45.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Sep 2021 04:45:41 -0700 (PDT)
Message-ID: <c86fecd6-6412-fec8-1dce-81e99c059e38@gmail.com>
Date:   Tue, 28 Sep 2021 14:45:39 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] net: mdiobus: Fix memory leak in __mdiobus_register
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Yanfei Xu <yanfei.xu@windriver.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, p.zabel@pengutronix.de,
        syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dongliang Mu <mudongliangabcd@gmail.com>
References: <20210926045313.2267655-1-yanfei.xu@windriver.com>
 <20210928085549.GA6559@kili> <20210928092657.GI2048@kadam>
 <6f90fa0f-6d3b-0ca7-e894-eb971b3b69fa@gmail.com>
 <20210928103908.GJ2048@kadam>
 <63b18426-c39e-d898-08fb-8bfd05b7be9e@gmail.com>
 <20210928105943.GL2083@kadam>
 <283d01f0-d5eb-914e-1bd2-baae0420073c@gmail.com>
 <f587da4b-09dd-4c32-4ee4-5ec8b9ad792f@gmail.com>
 <20210928113055.GN2083@kadam>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <20210928113055.GN2083@kadam>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/28/21 14:30, Dan Carpenter wrote:
> On Tue, Sep 28, 2021 at 02:09:06PM +0300, Pavel Skripkin wrote:
>> On 9/28/21 14:06, Pavel Skripkin wrote:
>> > > It's not actually the same.  The state has to be set before the
>> > > device_register() or there is still a leak.
>> > > 
>> > Ah, I see... I forgot to handle possible device_register() error. Will
>> > send v2 soon, thank you
>> > 
>> > 
>> > 
>> Wait... Yanfei's patch is already applied to net tree and if I understand
>> correctly, calling put_device() 2 times will cause UAF or smth else.
>> 
> 
> Yes.  It causes a UAF.
> 
> Huh...  You're right that the log should say "failed to register".  But
> I don't think that's the correct syzbot link for your patch either
> because I don't think anyone calls mdiobus_free() if
> __devm_mdiobus_register() fails.  I have looked at these callers.  It
> would be a bug as well.
> 

mdiobus_free() is called in case of ->probe() failure, because devres 
clean up function for bus is devm_mdiobus_free(). It simply calls 
mdiobus_free().


So, i imagine following calltrace:

ax88772_bind
   ax88772_init_mdio
     devm_mdiobus_alloc() <- bus registered as devres
     devm_mdiobus_register() <- fail (->probe failure)

...

devres_release_all
   mdiobus_free()


Also, syzbot has tested my patch :)

> Anyway, your patch is required and the __devm_mdiobus_register()
> function has leaks as well.  And perhaps there are more bugs we have not
> discovered.
> 
> regards,
> dan carpenter
> 



With regards,
Pavel Skripkin
