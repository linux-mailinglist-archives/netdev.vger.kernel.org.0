Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A68B63BFA0F
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 14:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhGHM30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 08:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbhGHM3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 08:29:25 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFFC1C061574;
        Thu,  8 Jul 2021 05:26:42 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id b14-20020a1c1b0e0000b02901fc3a62af78so6567666wmb.3;
        Thu, 08 Jul 2021 05:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2BNe9rKXhY8MmWQX67o+G5gKAgLO+47b5LDxS9l4Meo=;
        b=olyx2nDd+kC70burfasIdtGB3O5hE3fqw3l3Tg1BcdWGpI9BUvAtoUbHTyhixSBrDa
         AHRa6CVMvdm+ROYzQeDNeLYkhb56HPeQ2tIS++yJ09jLKmJ+flmSbe7mEQnltNhX5MdR
         rlv+/L0RUYPRYX9zJVHvW0Iv/GHXqCqwwFNNyEOnVLjDo+dK2vajysrfs6cTlJy52fhv
         B0aKfjBKwtPtt5O1fMqDB/Z94RciRu7xqrHvMS3YzVtF266lmppQbGNZ9x/ZQHSPE87X
         H7Of6CkYFdKyHoDwxLdCkrHSvt6Dq0Q1XvLmp993Ynb5QBAgnKMpIp5mSf/iyTsSGG9f
         jzQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2BNe9rKXhY8MmWQX67o+G5gKAgLO+47b5LDxS9l4Meo=;
        b=PHOa6KwMK8WcoJZFz8+Ieg5XMl1FSCGg3hIm1sgE0xQwv2+/S0NeO92xfaNtnoz6gU
         MjcZCtlpFaeMbFsaJVN/YBs0RHvkF9wQasyia9UWTIOlN/wv41q/o0CCr3IGd6JbWMR/
         RgiKSkTI3TONBaVKIIMqzh9+nrn7YGXfSu4cOfNOGkjnirPUuRIV/vyLyeL9oeCFdds3
         cFoADrLnmZuC6023dpaL0EBzaTU1/PidfZVlzlyYEqOIIfdw6vJLm5cG4iIJz4tHgisx
         Oq716bZ02TUfULcjTe1SqmUcjyuSoQIAStHKHe2G8YQk2sxZazKIchL253BS1bPkelUi
         VSPg==
X-Gm-Message-State: AOAM530xbdIq5sRQ+hAWCRI9frRP7IGGU9/PCUweLCRPDgYaX/h8ozVW
        YDIMcRnIeJMN8Sl84lu6FjKG18IHsTg=
X-Google-Smtp-Source: ABdhPJwqC/SZxrVdpL1dHpgkIsCDB6Ln1sdmIBorf2K9D6i2ebpS/Hh2T8uSDkVEftaMB12GuV2Yug==
X-Received: by 2002:a05:600c:224a:: with SMTP id a10mr5073252wmm.7.1625747201217;
        Thu, 08 Jul 2021 05:26:41 -0700 (PDT)
Received: from [10.0.0.3] ([37.165.6.154])
        by smtp.gmail.com with ESMTPSA id s1sm9105516wmj.8.2021.07.08.05.26.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 05:26:40 -0700 (PDT)
Subject: Re: [PATCH v2] net: rtnetlink: Fix rtnl_dereference may be return
 NULL
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     Yajun Deng <yajun.deng@linux.dev>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "ryazanov.s.a@gmail.com" <ryazanov.s.a@gmail.com>,
        "avagin@gmail.com" <avagin@gmail.com>,
        "cong.wang@bytedance.com" <cong.wang@bytedance.com>,
        "roopa@cumulusnetworks.com" <roopa@cumulusnetworks.com>,
        "zhudi21@huawei.com" <zhudi21@huawei.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210708092936.20044-1-yajun.deng@linux.dev>
 <3c160d187382677abe40606a6a88ddac0809c328.camel@sipsolutions.net>
 <20210708111118.kti4jprkz7bus62g@skbuf>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <7e11f410-9a97-c7d8-ee6a-fa776a4d1f0e@gmail.com>
Date:   Thu, 8 Jul 2021 14:26:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210708111118.kti4jprkz7bus62g@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/8/21 1:11 PM, Vladimir Oltean wrote:
> On Thu, Jul 08, 2021 at 11:43:20AM +0200, Johannes Berg wrote:
>> On Thu, 2021-07-08 at 17:29 +0800, Yajun Deng wrote:
>>> The value 'link' may be NULL in rtnl_unregister(), this leads to
>>> kfree_rcu(NULL, xxx), so add this case handling.
>>>
>>
>> I don't see how. It would require the caller to unregister something
>> they never registered. That would be a bug there, but I don't see that
>> it's very useful to actually be defensive about bugs there.
> 
> Besides, isn't kfree_rcu(NULL) safe anyway?
> 

Only from linux-5.3 I think.
(commit 12edff045bc6dd3ab1565cc02fa4841803c2a633 was not backported to old kernels)

But yes, this patch is not solving any bug, as I suspected.
