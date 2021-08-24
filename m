Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3203F6C46
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 01:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234477AbhHXXfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 19:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbhHXXfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 19:35:46 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FBDCC061757;
        Tue, 24 Aug 2021 16:35:02 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id j2so8807829pll.1;
        Tue, 24 Aug 2021 16:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rNShSQwThr6gncf6KciCpz1nmilWRZIh2pd8pXlgU2w=;
        b=qRrg8f3X14HU1hkXdQP2hJUuaFNZYL39Ld42quI9OZKOctN7lNB8oYiHtcPq8o85rx
         t2LFCX4VxkZx2JodOA7t466wfzDaVrsVEehzkHmXn5oUpa/CTb98rTfUTQAgPfWxlke1
         Zg7A+78CwG+D5Ai4Yi5a7ZAuReNfUQmP5QrskBruh+QnFy3JBpZhRlSACUjFqFcOcgul
         yg8QDQj2fv66GheIAi44mofDz6n3AknY1FvLR4shJnVc6r/7LbTNmsv23LydETjW8+kX
         F7OL7chebPpqAtWv2QThWl4+NLoIscun6D1ZckwTlB0iJhzznRXXog3/zvpazvSGPKsc
         ZHzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rNShSQwThr6gncf6KciCpz1nmilWRZIh2pd8pXlgU2w=;
        b=QNkbxae/b5Jfu+BkLx90tRmdrfSSXj5hTgs/syXdFvvHtJsp393K5tACXixztcIivD
         Q/FE2A4qqGLnRxNEjbL0qepJADN4Xdy/oyx0i/deHvNasTfLxupNP1FyEiL8DspUtGt+
         fPxb77SAgFfIjNh22TQru3zzaS34a77qcx785DzDKhDbU3D2x9q9/VV89wesDuOBLpLD
         bFUPebhVRMGLfXmW5AL0UM9XI8Aflmjgtg/tBcCtvNPBGRGG0H4+t92ESlJwUVMwMRFs
         FdBiJFIENf0AgBeCfxJygrgNe6sNW9UsvNzvbRZGTrNnrhUXp879NDIdpzNqwLp/e4I3
         MLjw==
X-Gm-Message-State: AOAM532C8Q6GquVY5OatQphDhmM7vw4F8M4EwocMmleWH+CMbjPRvSKu
        5DV2haP7OxfNE9XBiZeHtwX6J4IgkCs=
X-Google-Smtp-Source: ABdhPJzzrItpXBMO6oheDOs/i5nL+4Zw+9CEXaOb5PjyZvwYOOWDy6JTXaNBCCsADY68dt2RtNyvWQ==
X-Received: by 2002:a17:902:8f97:b0:12f:fff9:bad4 with SMTP id z23-20020a1709028f9700b0012ffff9bad4mr25335111plo.65.1629848101603;
        Tue, 24 Aug 2021 16:35:01 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id ev12sm3308395pjb.57.2021.08.24.16.34.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Aug 2021 16:35:01 -0700 (PDT)
Subject: Re: [RFCv3 05/15] tcp: authopt: Add crypto initialization
To:     Leonard Crestez <cdleonard@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1629840814.git.cdleonard@gmail.com>
 <abb720b34b9eef1cc52ef68017334e27a2af83c6.1629840814.git.cdleonard@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <30f73293-ea03-d18f-d923-0cf499d4b208@gmail.com>
Date:   Tue, 24 Aug 2021 16:34:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <abb720b34b9eef1cc52ef68017334e27a2af83c6.1629840814.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/24/21 2:34 PM, Leonard Crestez wrote:
> The crypto_shash API is used in order to compute packet signatures. The
> API comes with several unfortunate limitations:
> 
> 1) Allocating a crypto_shash can sleep and must be done in user context.
> 2) Packet signatures must be computed in softirq context
> 3) Packet signatures use dynamic "traffic keys" which require exclusive
> access to crypto_shash for crypto_setkey.
> 
> The solution is to allocate one crypto_shash for each possible cpu for
> each algorithm at setsockopt time. The per-cpu tfm is then borrowed from
> softirq context, signatures are computed and the tfm is returned.
> 

I could not see the per-cpu stuff that you mention in the changelog.


