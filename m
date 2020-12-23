Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 494022E2260
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 23:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbgLWWSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 17:18:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgLWWSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 17:18:14 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744C2C061794;
        Wed, 23 Dec 2020 14:17:34 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id n10so411083pgl.10;
        Wed, 23 Dec 2020 14:17:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QmB0Ticp/tS8X0FdCEKnZeU/ip7BBBIBzLSTbjOnxGQ=;
        b=qOvLOqtRbq9OzMxu5LTpISYUGutCXGWR+pvrejukARfRSct6+a8sy9drxZov4AvVpX
         ZP15CxL5O5bk05470gEEdFj+Ngbve52JWjBtyPPeJX//UOJ0WKnUU6gl3GKy2h20G2Di
         heJNUvA/swWkfmW/Ptqr844gXIlovrYUOEKqn4C2y4g16TQ5fSG1rb63qO2nQBSVo2WB
         px9z0uRmuWaIif9eycIEskwDAqniWJh1zbkfCl8ZHY6+0SPAhciR9Ju/xu3j35xEwwqH
         iUZT/KITYc8JzJZmX/oO9vizqs2KAzCGJhCG/pjxYJ40Z0pb2yTfJyFtMV17ixM1KHWb
         L8YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QmB0Ticp/tS8X0FdCEKnZeU/ip7BBBIBzLSTbjOnxGQ=;
        b=epJMBmEYgraA3HtCSO+RVMrqN4moIu7g7nIuQiSsZcbjaFBTU9jSQysYFSqw2rQ87O
         /ZfStnNplc5NISvXGXiGa+I7y4KLHAs9Zae7u5FnE8amb/LGerDdKYuqLV0w6e5JPh62
         bQS6KtL4qf1r76SLX7JaVHYS1CFVoKFMfoa2X+40+YeEu98oxz6ZCmMepaBhffm09eAs
         wZSenBcZEtu7k5cgPIaABs/6HNXffkb0gvX5zLlKU5tZh2dJbcsuhTbHJlAnt5SrGNmd
         qRIBREEkNvdqBuycnX03MUX3a7QrWcmejUwuJLDCPQs4sQNjRJpt83Z+F7ovN3KEztao
         Lvag==
X-Gm-Message-State: AOAM530xqMu+rc4Ppo3TR1+H6G1GIiRy+2oL/xtLss+vk/y033GetTzK
        agm7SlFO3I6b685EhUG38y7Rgd/Bgmc=
X-Google-Smtp-Source: ABdhPJyum+KJDvB6VjV136DIRAMGxPKbKGTARtEIQ+2s7GSaQuMCo1PeheSgynyQsckDB4zhrS71Yw==
X-Received: by 2002:a62:1596:0:b029:19d:a1c6:13f1 with SMTP id 144-20020a6215960000b029019da1c613f1mr25324453pfv.34.1608761853463;
        Wed, 23 Dec 2020 14:17:33 -0800 (PST)
Received: from [10.230.29.27] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 82sm25029747pfv.117.2020.12.23.14.17.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Dec 2020 14:17:32 -0800 (PST)
Subject: Re: [PATCH] net: ethernet: Fix memleak in ethoc_probe
To:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>, kjlu@umn.edu,
        "David S. Miller" <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201223110615.31389-1-dinghao.liu@zju.edu.cn>
 <20201223153304.GD3198262@lunn.ch>
 <20201223123218.1cf7d9cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201223210044.GA3253993@lunn.ch>
 <20201223131149.15fff8d2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <680850a9-8ab0-4672-498e-6dc740720da3@gmail.com>
Date:   Wed, 23 Dec 2020 14:17:29 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201223131149.15fff8d2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/23/2020 1:11 PM, Jakub Kicinski wrote:
> On Wed, 23 Dec 2020 22:00:44 +0100 Andrew Lunn wrote:
>> On Wed, Dec 23, 2020 at 12:32:18PM -0800, Jakub Kicinski wrote:
>>> On Wed, 23 Dec 2020 16:33:04 +0100 Andrew Lunn wrote:  
>>>> On Wed, Dec 23, 2020 at 07:06:12PM +0800, Dinghao Liu wrote:  
>>>>> When mdiobus_register() fails, priv->mdio allocated
>>>>> by mdiobus_alloc() has not been freed, which leads
>>>>> to memleak.
>>>>>
>>>>> Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>    
>>>>
>>>> Fixes: bfa49cfc5262 ("net/ethoc: fix null dereference on error exit path")
>>>>
>>>> Reviewed-by: Andrew Lunn <andrew@lunn.ch>  
>>>
>>> Ooof, I applied without looking at your email and I added:
>>>
>>> Fixes: e7f4dc3536a4 ("mdio: Move allocation of interrupts into core")  
>>
>> [Goes and looks deeper]
>>
>> Yes, commit e7f4dc3536a4 looks like it introduced the original
>> problem. bfa49cfc5262 just moved to code around a bit.
>>
>> Does patchwork not automagically add Fixes: lines from full up emails?
>> That seems like a reasonable automation.
> 
> Looks like it's been a TODO for 3 years now:
> 
> https://github.com/getpatchwork/patchwork/issues/151

It was proposed before, but rejected. You can have your local patchwork
admin take care of that for you though and add custom tags:

https://lists.ozlabs.org/pipermail/patchwork/2017-January/003910.html
-- 
Florian
