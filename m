Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA2BD41AD88
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 13:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240340AbhI1LGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 07:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239306AbhI1LGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 07:06:30 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28ADCC061575;
        Tue, 28 Sep 2021 04:04:51 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id g41so90697697lfv.1;
        Tue, 28 Sep 2021 04:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=JvSal7U5gOYvPnr4z3PV/NIO3eAB35FFYmEZfawUULA=;
        b=QM1lWM+fRxiur5qYe0uqGFGjz0gS/B4gvq8BvzNOWRf8Pmi8I0i5XPqTnjnZpX/9MW
         AJmEXBlw4jGPynkAAAbDabHIFAkBmWlHhuetp9rAgcbW+5fTAFm/Ybu0UohPk1/SUGHk
         hV2L1HBpgqlR4e+f/OEHvb1uh6eTb+qbxDnKp4s/AAbF1otDOu6bXAO2k5JdeRl07T22
         E3ly/Iz4DQV/5kbRCt+DqRyDjBpSdZcwMHlFpqmw0Wllulmio41IMoVmE+4lROEOZZpJ
         pa7QcW8qHeK+zPNiLVs0RZHgGaFUHqRShwkfLFzvb3g3+WpGKbL70M8lK7bwluCD0FwX
         ScYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JvSal7U5gOYvPnr4z3PV/NIO3eAB35FFYmEZfawUULA=;
        b=Dd/lcsrU/33Qb5UbSfJX2ECvbPOibfDwkkW1kMRb60m3slfBXWYEAmaxEHWC0tH/hQ
         O1fwt1aRW7NZd5u4er6o7AwcAFv0BlTwph9sTIR8Lfnta9mTo34ICXG0209qdMz/JTXd
         EyiN0OGMfqMOoY+ogCo7gB3WCQYE324G/VwsYq4Ro9zYF3uqeHXm9IClwF4UaqsYXBR0
         n28ADO2s+UOkZW4jLOTMmcJd7JhIa2okdB665qZFn9+E+L+YvlVDdkJiXmTpR3Y3zbW3
         C+KoHzP2/n5vbPgWKZd9Hkmo3Mel5glnr/UbQF+i62QevRffQvTr+ZvfDtdBQmQbS3Nx
         fnBA==
X-Gm-Message-State: AOAM532Rh93HOLSwW2x59F1kGgdbZipYUPZO8DVToswwmnx8Uy24Pp5U
        ycf767zH7KeSbvD7/YIT7gA=
X-Google-Smtp-Source: ABdhPJx0Xh2zA5rTXcw0s2i753PdeLRJ71JKPkqZMCQ33SG1yD6QYllvWVJ+lLyylZJo+BKUN59b/g==
X-Received: by 2002:a2e:50d:: with SMTP id 13mr5084107ljf.467.1632827089455;
        Tue, 28 Sep 2021 04:04:49 -0700 (PDT)
Received: from [172.28.2.233] ([46.61.204.60])
        by smtp.gmail.com with ESMTPSA id y24sm1532232lje.35.2021.09.28.04.04.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Sep 2021 04:04:49 -0700 (PDT)
Message-ID: <0ff35e57-978a-ed79-d401-cbe3f86835af@gmail.com>
Date:   Tue, 28 Sep 2021 14:04:48 +0300
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
 <20210928105522.GK2083@kadam>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <20210928105522.GK2083@kadam>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/28/21 13:55, Dan Carpenter wrote:
> On Tue, Sep 28, 2021 at 01:46:56PM +0300, Pavel Skripkin wrote:
>> On 9/28/21 13:39, Dan Carpenter wrote:
>> > No, the syzbot link was correct.
>> > 
>> 
>> Link is correct, but Yanfei's patch does not fix this bug. Syzbot reported
>> leak, that you described below, not the Yanfei one.
>> 
> 
> I promise you that Yanfei's link was correct.  That bug was in
> __devm_mdiobus_register().  It's a totally separate issue.
> 

I must be missing something, or we are talking about different links :)

Let me explain why I think, that Yanfei's patch cannot fix leak reported 
by syzkaller [1] (I hope, we are talking about this link)


Yanfei has changed this code part:

	err = device_register(&bus->dev);
	if (err) {
(*)		pr_err("mii_bus %s failed to register\n", bus->id);
		return -EINVAL;
	}

So, if executing gets into this branch we should see error message (*), 
right? There is no such message into log file on bug report page [1], so 
how is it possible?




[1] 
https://syzkaller.appspot.com/bug?id=fa99459691911a0369622248e0f4e3285fcedd97
	

With regards,
Pavel Skripkin
