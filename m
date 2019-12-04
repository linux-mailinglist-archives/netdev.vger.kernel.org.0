Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD36113046
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 17:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728896AbfLDQxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 11:53:12 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42339 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbfLDQxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 11:53:11 -0500
Received: by mail-pf1-f195.google.com with SMTP id 4so118354pfz.9
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 08:53:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Nxoz6BVeNAQHOf9JdrWQqBTT4e/HsPz+1BwMxNNEGCc=;
        b=f4JP/0y042I07u83Lk0o6+YVPEjqfPyrpm0LNAw3nT3a4MN2YqezN/Gk/Q+gbqANzT
         dPjhASajQ9TmraiASkeQ56OGocLlUhUW+ozH0pTYxAW3pV8EDzpcv7G+Vfp8aMHPuvA7
         FbpOe7b3EpUeilQuQh3JhI+A7AtAptvO/I8XL9UKd9BFcha1hyBw/wrE63A+PYP3kZbe
         6omJW1sucKpaMn8kXHyM5wYtA06zP8/6M1nNK+t+EvzgAmYVNUofxkZlwjCzoLqnLqbu
         G28MV+jbAiKKhOUjY25hCzsn36slsuryuDfOnHety8cEnMg8pA0T0SZa+86WspKWXNl6
         eN+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Nxoz6BVeNAQHOf9JdrWQqBTT4e/HsPz+1BwMxNNEGCc=;
        b=kdwNr6z86aFcsNQcf/xxfSrG5qcPipZm4JHBPRSBg2uCU9pBCUghWBa6cSWxnpU0aJ
         tCT8PNnxwH8yTxodheZwumT8RUV31Lc0IsaQhcdgYX3uJAVB6Rt52Z4npdCUqbo4NUYU
         UkQjqoY6LXzk85HNDKOPw0g22CuCNuctSScMfOoo1MkSM7lF/uvWePUEsIaw8H1886Cu
         TB9YFTFuUnoYUrirDEfuoP52qTvtAgmCLJoxecwBzHCnMQUzaaeYJKXd585pzPzJm/7D
         XO+HV4mdYx7DmfLcKdPI/M5zEbOuT6xUxoo3Cdh53Ypoj/7K2Bg+SW7NDVlUAgGq2oet
         h/WA==
X-Gm-Message-State: APjAAAWiBDDHwS4E4IlDjVS3Oy8LWJg8as0Fo+w9bhzmAoJruJHlCh6u
        Fp/suDdX4GRq6UsXHJDAVwM=
X-Google-Smtp-Source: APXvYqyUdNmlVW0suFscg0c8AtHmBGzwwh++l0EqXWAgEo5htNobtrmAGdwf8Vtr1DG4iEtaGLKeog==
X-Received: by 2002:a65:530d:: with SMTP id m13mr4466338pgq.172.1575478391147;
        Wed, 04 Dec 2019 08:53:11 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id x11sm8505399pfn.53.2019.12.04.08.53.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2019 08:53:10 -0800 (PST)
Subject: Re: [PATCH net] tcp: Avoid time_after32() underflow when handling
 syncookies
To:     Guillaume Nault <gnault@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev <netdev@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
References: <2601e43617d707a28f60f2fe6927b1aaaa0a37f8.1574976866.git.gnault@redhat.com>
 <CANn89i+G0jCU=JtSit3X9w+SaExgbbo-d1x4UEkTEJRdypN3gQ@mail.gmail.com>
 <20191202215143.GA13231@linux.home>
 <CANn89i+k3+NN8=5fD9RN4BnPT5dei=iKJaps_0vmcMNQwC58mw@mail.gmail.com>
 <20191204004654.GA22999@linux.home>
 <d6b6e3c4-cae6-6127-7bda-235a00d351ef@gmail.com>
 <20191204143414.GA2358@linux.home>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <192e1cb1-2cf1-22e8-999b-c74c74492113@gmail.com>
Date:   Wed, 4 Dec 2019 08:53:08 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191204143414.GA2358@linux.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/4/19 6:34 AM, Guillaume Nault wrote:
> On Tue, Dec 03, 2019 at 06:20:24PM -0800, Eric Dumazet wrote:
>>
>> Sorry I am completely lost with this amount of text.
>>
> No problem. I'll write a v2 and remork the problem description to make
> it clearer.
> 
>> Whatever solution you come up with, make sure it covers all the points
>> that have been raised.
>>
> Will do.
> Thanks.
> 

Le me apologize for my last email.

I should have slept first after my long day.

Thanks a lot for working on this !
