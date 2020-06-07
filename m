Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2D31F0A80
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 10:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgFGIUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 04:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbgFGIUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jun 2020 04:20:36 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7987AC08C5C2
        for <netdev@vger.kernel.org>; Sun,  7 Jun 2020 01:20:36 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id l10so14104134wrr.10
        for <netdev@vger.kernel.org>; Sun, 07 Jun 2020 01:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=d6y0/beVX2prGG9BaE8oNlZtYuIjUlHNGhxvleEO0bg=;
        b=IJ5qErtG21ULmz69a5xEiMSHuCWvqzTbWhUhp1hh4fbxsqJP6xZ2Prgzz+wFtA0ZhO
         5llr2H/GttTs9TLm6c8dlzvbbjDs2LKrFy6lno4XdfRvUDY3xj7SoMeeEcvXf8dg5+Vr
         Wl44IfE9RxaitCau+KqAiKKI96hf7MRwA6DPg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d6y0/beVX2prGG9BaE8oNlZtYuIjUlHNGhxvleEO0bg=;
        b=aR0b6TDi47h4d6LZaEGOrN1ksagxjkPvP2wU+T9IiRiqiQskERwKliQ3Y2ZaEnYaiG
         fcv7pvvhmF6n4NN6deDY6PDLRvHQddS/LfhZ3qYzSUVDb1AogleRH5Wo8o2vJA0LC9Ec
         a8UthNouT4rO1GkeeL8HiDaep8ozhT8X+K+huWrdVCtjvwGUmyIvNp2fbPFsOFQtzETt
         2cTteLXDmMulem7reRE/D9vLy063rK8dzGN2vytly4OnEdSWzSHzTH0AzKoFIu/GB/R0
         bjEXF7aqHFw8he3tCuvHbMjhsBjC3rqWm5Rkmwi/6RjSXBOHzkbiCCrlCSwCN/YwBZG2
         3S4g==
X-Gm-Message-State: AOAM532S01528Jhxu+Nhg+8sAYhCTyGTYdHdb65iw4Chz5fa+TGz972P
        RVYVA2bnAR3wCSp/pmLXR30zo9l/ck4=
X-Google-Smtp-Source: ABdhPJyrLG5zH3hR7xWaSH2JPAz+F2TCGNki4XEF8+f2WSz6+lF2sVGbgdCLcSVEy4IPAlpSagcgVQ==
X-Received: by 2002:a5d:6289:: with SMTP id k9mr18715571wru.358.1591518035028;
        Sun, 07 Jun 2020 01:20:35 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id g3sm21445618wrb.46.2020.06.07.01.20.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jun 2020 01:20:34 -0700 (PDT)
Subject: Re: [PATCH] ipv4: nexthop: Fix deadcode issue by performing a proper
 NULL check
To:     David Miller <davem@davemloft.net>
Cc:     patrickeigensatz@gmail.com, dsahern@kernel.org,
        scan-admin@coverity.com, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200601111201.64124-1-patrick.eigensatz@gmail.com>
 <20200601.110654.1178868171436999333.davem@davemloft.net>
 <4e6ba1a8-be3b-fd22-e0b8-485d33bb51eb@cumulusnetworks.com>
 <20200602.140108.2199333313862275860.davem@davemloft.net>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <438a628d-e742-0bc6-a67b-41a2d0a62bab@cumulusnetworks.com>
Date:   Sun, 7 Jun 2020 11:20:33 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200602.140108.2199333313862275860.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/06/2020 00:01, David Miller wrote:
> From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> Date: Tue, 2 Jun 2020 10:23:09 +0300
> 
>> On 01/06/2020 21:06, David Miller wrote:
>>> From: patrickeigensatz@gmail.com
>>> Date: Mon,  1 Jun 2020 13:12:01 +0200
>>>
>>>> From: Patrick Eigensatz <patrickeigensatz@gmail.com>
>>>>
>>>> After allocating the spare nexthop group it should be tested for kzalloc()
>>>> returning NULL, instead the already used nexthop group (which cannot be
>>>> NULL at this point) had been tested so far.
>>>>
>>>> Additionally, if kzalloc() fails, return ERR_PTR(-ENOMEM) instead of NULL.
>>>>
>>>> Coverity-id: 1463885
>>>> Reported-by: Coverity <scan-admin@coverity.com>
>>>> Signed-off-by: Patrick Eigensatz <patrickeigensatz@gmail.com>
>>>
>>> Applied, thank you.
>>>
>>
>> Hi Dave,
>> I see this patch in -net-next but it should've been in -net as I wrote in my
>> review[1]. This patch should go along with the recent nexthop set that fixes
>> a few bugs, since it could result in a null ptr deref if the spare group cannot
>> be allocated.
>> How would you like to proceed? Should it be submitted for -net as well?
> 
> When I'm leading up to the merge window I just toss everything into net-next
> and still queue things to -stable as needed.
> 

Got it, in that case could you please queue the patch for -stable?

I checked https://patchwork.ozlabs.org/bundle/davem/stable/?state=* and
https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
but didn't find it.

Thanks,
 Nik


