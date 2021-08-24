Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 514C03F6C05
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 01:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233155AbhHXXDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 19:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbhHXXDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 19:03:20 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D75BC061757;
        Tue, 24 Aug 2021 16:02:36 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso2851963pjh.5;
        Tue, 24 Aug 2021 16:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oRutMmfmW+MGy1iLNBbS8khgGdiC/2DVGIuLCvRzIxc=;
        b=D12KbHKDX2FItHHdsbeVU0omV3ybH8+TUrbldLtROeNhVf75RjAD6kgMQS6JJ0N78/
         rIDDzdPWPMwD0f7rdL321JW1R3vLftlZTC9ULJYImUqc3fQrXizDoFchG7b07MJcSfWm
         0Pkp5qCreURDK6hoRzhzZV1RZ+fzYi0ivF+UCNqfIPlXNJmNTsK7y+3fHoe+zYooRXv7
         sPi/20yLCoYYe1LxbJokFyQHV2SffHx4Qj2AMp/XJ3pUV3gpQy1txUoq0JUBWzmk6ZJZ
         8TOUshr8LqRb00pL3UUsEfwTRinlHg95pZD3bEM7xIyn6n72r4Ll10Tl7umXvukF9hsh
         chJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oRutMmfmW+MGy1iLNBbS8khgGdiC/2DVGIuLCvRzIxc=;
        b=G4oQTnY4JpX3aFED1RmzWNNr4b5ixr1P6Mj86SRuIYTwuGvysdN3I/cQ5r3tVUtB+P
         K9zvYoNcZNGh51PCY2F/gOE7PnnSBE2iXoZp+8k9JgUJEqqqszJJHuEJ65nPqJAgmhvw
         IPH5WaZncGa0f+NtQJ5ZR456BnEF5coybJhySG/FG6Ch8udsUSftfUznxpoHRCiwuYEB
         ntfhAVPI1RcJXl0BpHJDuk5L9vWjL+Y4rkBgPhNKcLOMMk3B1YsUU1cdoTr4gRBja7a+
         7WCQdewZ+EyeMDvkXaDw4C7siay/EAQzW2SrkIiQK9TwTa0OwJ4XRJ7FQKkl3Z5kBBdY
         jMKA==
X-Gm-Message-State: AOAM530xYZeWH/Q/ptMejpO2MaldYtvjkgp3+4dY4VEQxjCXjVRRGoY8
        rS1A/FQG+lLZOFuif+A8R5VSM9AKsLk=
X-Google-Smtp-Source: ABdhPJw7FH241pGhrdQO3cXCJ57NSAVZlaQhi7eAd2A9b883WxGmbq1kbkyJ3jXMVz/EeX/5PYccuw==
X-Received: by 2002:a17:90b:4b0b:: with SMTP id lx11mr7085430pjb.70.1629846155436;
        Tue, 24 Aug 2021 16:02:35 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id y3sm24128749pgc.67.2021.08.24.16.02.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Aug 2021 16:02:35 -0700 (PDT)
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
Message-ID: <72d126d8-1d44-de0c-fa1d-4362774ea3db@gmail.com>
Date:   Tue, 24 Aug 2021 16:02:32 -0700
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
> The pool for each algorithm is reference counted, initialized at
> setsockopt time and released in tcp_authopt_key_info's rcu callback
> 
>

I don't know, why should we really care and try so hard to release
the tfm per cpu ?

I would simply allocate them at boot time.
This would avoid the expensive refcounting (potential false sharing)

