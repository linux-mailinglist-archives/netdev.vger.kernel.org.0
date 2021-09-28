Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C316441AD9A
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 13:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240200AbhI1LKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 07:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239068AbhI1LKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 07:10:48 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B96C061575;
        Tue, 28 Sep 2021 04:09:09 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id e15so91137263lfr.10;
        Tue, 28 Sep 2021 04:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=x0TF30fHxd3gegxcCEondgQDh02mpuK7Cfxm1pxNpfI=;
        b=MuseAtczwhFGOVWkDGFVGrYjjwJAYVJM8tkQm6DO8DnESfEEGCpCF9aLV7+nCUX6c9
         aA19RILBgcCnxWQonMx38mrrEwhIFDIfi74YelSGzv87n6lB0HiyhNRg+U3fjBwvtJIx
         tKSmTwGAZiTwDKRWEgRw/9xupa02F+Vb8F8/LUrVi0gp9atVQ9/8e0BfoTRqyU/+FPQP
         Mgd7X6w4zpGDIZQ4X35oHNIg0go8cK0M/IU+r1oNpnLUWi6CxUUF3sum3XxMai34hfBw
         l3tknnjPgZp69FgZwOsi3LVo3Xd4TOXsiCCqxl0hGoH82p3d9oRDTXWyQ2A8yvDJsEiI
         NRhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=x0TF30fHxd3gegxcCEondgQDh02mpuK7Cfxm1pxNpfI=;
        b=kUJcSf52Q+w72j4cnSg45tm8bXITCYtde25drKFXKZBeesusJk45z4jeQyzORLdMzw
         Dounc2u3Ghr3clAwPHkuGQCQJCN5ekfEGfBVGyiIWX1MpB2jQN10a05AKB/MtfjvsT57
         weuqtL5DcaceNsr0JoWU+f2VTkCdopbzBwedeTHAjIurhqVykrEjKC5bKDvknQfiOTwT
         IDbUECi3g02mpej7Jc1xNFsrHqvlopCTm1HjerB9BQ+aXojDl/Xcm54scCRhqxzy0gR9
         bDHJKODrLXEE1gVryY+frwMO1RV63gMmooO98dbXOUVdC6B+CCDZQ2emUjznX3GqBhBp
         b3pA==
X-Gm-Message-State: AOAM530ckvWctEN6K7NKknQ7PD0R6dUp2fElw0ZKNwyo3FQkII+D6eGp
        znNqiCZlCC/JfW/5N+OWJoI=
X-Google-Smtp-Source: ABdhPJwkwH/6z2zBMqGvim8Hu0uutGJmC5Y8vE9+kVQ7PnjlsiFXL6r6+IoZm1McbF2W/ryUC/wQ7w==
X-Received: by 2002:a05:651c:1509:: with SMTP id e9mr5430925ljf.280.1632827347541;
        Tue, 28 Sep 2021 04:09:07 -0700 (PDT)
Received: from [172.28.2.233] ([46.61.204.60])
        by smtp.gmail.com with ESMTPSA id r13sm1303965ljk.130.2021.09.28.04.09.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Sep 2021 04:09:07 -0700 (PDT)
Message-ID: <f587da4b-09dd-4c32-4ee4-5ec8b9ad792f@gmail.com>
Date:   Tue, 28 Sep 2021 14:09:06 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] net: mdiobus: Fix memory leak in __mdiobus_register
Content-Language: en-US
From:   Pavel Skripkin <paskripkin@gmail.com>
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
In-Reply-To: <283d01f0-d5eb-914e-1bd2-baae0420073c@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/28/21 14:06, Pavel Skripkin wrote:
>> It's not actually the same.  The state has to be set before the
>> device_register() or there is still a leak.
>> 
> Ah, I see... I forgot to handle possible device_register() error. Will
> send v2 soon, thank you
> 
> 
> 
Wait... Yanfei's patch is already applied to net tree and if I 
understand correctly, calling put_device() 2 times will cause UAF or 
smth else.




With regards,
Pavel Skripkin
