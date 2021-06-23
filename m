Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5D53B1271
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 05:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbhFWDuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 23:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbhFWDuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 23:50:06 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C9FC061574
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 20:47:48 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id s23so1804857oiw.9
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 20:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6iOtJY8+CanP+GQBJVX14WGuM7C/OsANuY/l+Tk7nh4=;
        b=q5x3KpDC6jnfb8KVmHuHKIXnTz918OznnXyUNuBMm1DUvfGNTx2Qp52axtYF2GUuYE
         bEw/ptQZ+rKDzCnZXdy5SQnz1x7nyZA1qU1+RWrFcWW0xjksPC5BGbTPfkFIvXslH4NH
         fapjUYTuBs907K2fe/hdApQIzVyxXA8rOlhW9wRuIIw40ut2aAhIglUe7ztQMbi4huLn
         wrhlwuIfExuRlC3LTj4uJbFUYGCm/GPkZMSxGDHvksk71QRn8JaBHNJEpbw7gA8xMXiA
         UqG3frdNETi1sLKRLjDj2hidgdeTjYvqT7TAhS+d/Li9Mua6Jm52denuhzX/apT6LIBt
         +X4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6iOtJY8+CanP+GQBJVX14WGuM7C/OsANuY/l+Tk7nh4=;
        b=dRMvTFnwoTaiijCtsqmg3l0Xpw8ACAaLzCkYg5vqOfz4LW6CEibfrJ/C/cAbk1mnSw
         pJnhgV3KM+LCAJg9sSvriUH1XMN7MG05sI70NTPzAqqofLXQTkR7QURHwBkh1es6EyNy
         dPV8jlhwnY8T1FvqIHS8Ntcypvg6Xlgz9dTp6KsOol9Ce8e/sJEb9pcjVPsdUWXangSw
         682cn+h7sXxbX5MKMVQu0pXK2vzDiBEKD4MTxVFqQd5PwUS5r5G/kqdQX69NYPnIzal3
         UN9hwMzB4ZYJeKIrP3nQPzDfTwvICkpCfXXYtln4qzyhorCMFHq61f5VhwxjD7M3VWgY
         44iA==
X-Gm-Message-State: AOAM530v9B0+i8dQDwo5qeo0xcWO3hTuuwuxea8sh7yXypkCt7v7hoV0
        sxoQAT1TtK2kZsBHpoeF3kppvbDil+4=
X-Google-Smtp-Source: ABdhPJwVeHuyg9Mp22zALeEznoymVuMLKYqHRgY6uB+36ZdBnvLbZupTOKvFozxc1XD4WPGKiYNHXQ==
X-Received: by 2002:aca:d54f:: with SMTP id m76mr1582709oig.47.1624420067268;
        Tue, 22 Jun 2021 20:47:47 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id x31sm312607ota.24.2021.06.22.20.47.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 20:47:46 -0700 (PDT)
Subject: Re: [PATCH net] ip6_tunnel: fix GRE6 segmentation
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, vfedorenko@novek.ru
References: <20210622015254.1967716-1-kuba@kernel.org>
 <33902f8c-e14a-7dc6-9bde-4f8f168505b5@gmail.com>
 <20210622152451.7847bc24@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <592a8a33-dfb8-c67f-c9e6-0e1bab37b00d@gmail.com>
Date:   Tue, 22 Jun 2021 21:47:45 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210622152451.7847bc24@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/22/21 4:24 PM, Jakub Kicinski wrote:
>>>   
>>
>> would be good to capture the GRE use case that found the bug and the
>> MPLS version as test cases under tools/testing/selftests/net. Both
>> should be doable using namespaces.
> 
> I believe Vadim is working on MPLS side, how does this look for GRE?
> 

I like the template you followed. :-)

The test case looks good to me, thanks for doing it.

