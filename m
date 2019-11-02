Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85BECED070
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 20:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbfKBToC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 15:44:02 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37865 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726523AbfKBToC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Nov 2019 15:44:02 -0400
Received: by mail-wr1-f65.google.com with SMTP id t1so6948952wrv.4
        for <netdev@vger.kernel.org>; Sat, 02 Nov 2019 12:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Q64tKioGmpkjSreRumgw4MSoiU3wjKcQNA0vySWNXwQ=;
        b=KDG+q0LEI77ysrarY2JEy3B+BuPN7srgGheiF2udQjsYPcW5U0C5Cb/Wfls+u3c0/q
         gQE5lgNnOueyou2FTe1em7yKeJBLg2X86w0ciTGphY4xmf2vFD5qImjKlsb3NxiRR81s
         nSsWR8e1eBFHldoqTtYVnkmJUzoJAV94mhtgc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Q64tKioGmpkjSreRumgw4MSoiU3wjKcQNA0vySWNXwQ=;
        b=bdqxRSKtDVkHLW8EeLDSe0OSJ7TDawFbGj1Xh57XUz1mR0rC31DIJ7kgqbF1G49z7U
         wrZxwDCXen+qk7P5D3l6KddvK0uOL3QB6/4NgaNnOXF+RA2KahbI1uV6XBVxiSaN12yk
         wCmzRuY8YuVp7+feuzc0qTAEwcq4+5Enjd+ZE0MBTw1K4of2K6RuNORXBchiaJ17ho3S
         uT71om5ICLpi9u13cCGLXVJEX6rEwEEQsbwqUehXOkmXz1YE0AOMuFbvINyhQ+TwGmDc
         YP2vrcEJefks5fcNWqsFjSgfIT9aVjC9AMkLkQgQqvAFcZ0eSJPYjrtcSjc32JTanJfB
         DSlg==
X-Gm-Message-State: APjAAAUSGD08JXNdtMkpW+G5ulFlZqVxN3hmDJjle+ORzj+BFZLAlCdu
        OXXlcyR7lcM4TOpu+HJcXGcuZQ==
X-Google-Smtp-Source: APXvYqz5EW77O7b0uNJfIts2HXXU5adk63GWkN8uiEbz/dFrVppROEYu7TFtMPoCqq5Jpz0yEzP39w==
X-Received: by 2002:adf:ea07:: with SMTP id q7mr16643148wrm.78.1572723840083;
        Sat, 02 Nov 2019 12:44:00 -0700 (PDT)
Received: from [10.230.29.119] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h205sm12263876wmf.35.2019.11.02.12.43.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Nov 2019 12:43:59 -0700 (PDT)
Subject: Re: [PATCH RFC V2 1/6] net: bcmgenet: Fix error handling on IRQ
 retrieval
To:     Stefan Wahren <wahrenst@gmx.net>,
        Matthias Brugger <matthias.bgg@kernel.org>,
        Matthias Brugger <mbrugger@suse.com>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Eric Anholt <eric@anholt.net>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Doug Berger <opendmb@gmail.com>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org
References: <1572702093-18261-1-git-send-email-wahrenst@gmx.net>
 <1572702093-18261-2-git-send-email-wahrenst@gmx.net>
From:   Florian Fainelli <florian.fainelli@broadcom.com>
Autocrypt: addr=florian.fainelli@broadcom.com; keydata=
 mQENBFPAG8ABCAC3EO02urEwipgbUNJ1r6oI2Vr/+uE389lSEShN2PmL3MVnzhViSAtrYxeT
 M0Txqn1tOWoIc4QUl6Ggqf5KP6FoRkCrgMMTnUAINsINYXK+3OLe7HjP10h2jDRX4Ajs4Ghs
 JrZOBru6rH0YrgAhr6O5gG7NE1jhly+EsOa2MpwOiXO4DE/YKZGuVe6Bh87WqmILs9KvnNrQ
 PcycQnYKTVpqE95d4M824M5cuRB6D1GrYovCsjA9uxo22kPdOoQRAu5gBBn3AdtALFyQj9DQ
 KQuc39/i/Kt6XLZ/RsBc6qLs+p+JnEuPJngTSfWvzGjpx0nkwCMi4yBb+xk7Hki4kEslABEB
 AAG0MEZsb3JpYW4gRmFpbmVsbGkgPGZsb3JpYW4uZmFpbmVsbGlAYnJvYWRjb20uY29tPokB
 xAQQAQIArgUCW382iBcKAAG/SMv+fS3xUQWa0NryPuoRGjsA3SAUAAAAAAAWAAFrZXktdXNh
 Z2UtbWFza0BwZ3AuY29tjjAUgAAAAAAgAAdwcmVmZXJyZWQtZW1haWwtZW5jb2RpbmdAcGdw
 LmNvbXBncG1pbWUICwkIBwMCAQoFF4AAAAAZGGxkYXA6Ly9rZXlzLmJyb2FkY29tLmNvbQUb
 AwAAAAMWAgEFHgEAAAAEFQgJCgAKCRCBMbXEKbxmoFYGB/9qN5VL6f/88+qtDaDhUKvwBgF8
 koryGCH/gw6FBW5h5hwW0m6946WnsBnqKnZ8OYr8qsCgeJewCh0BEN9rIg8SC5oU7WdcmNg5
 KTv4/V1CmBo6dQaSHA8yQoeHsrw0gQ9HK4EYjhAU60RYXxX7/LFAy0rJMLf0qGKdWW2f5EkN
 dS5GwWOrTp477WL2g+R0khhP57qpejxlMN+Mtvin52UjbAcr1PAx8Zt2rXpFIZsXVWADpZDd
 qIb6PZPdcP/lD1v5it4sTN7D27FgjvbvAgj/D3NmyOjIUsbN9ZDJDfgv431RsJ9LOd6ySaNr
 yuje7L0dbiYrcOi3CN6S+zE1UJsLuQENBFPAG8EBCACsa+9aKnvtPjGAnO1mn1hHKUBxVML2
 C3HQaDp5iT8Q8A0ab1OS4akj75P8iXYfZOMVA0Lt65taiFtiPT7pOZ/yc/5WbKhsPE9dwysr
 vHjHL2gP4q5vZV/RJduwzx8v9KrMZsVZlKbvcvUvgZmjG9gjPSLssTFhJfa7lhUtowFof0fA
 q3Zy+vsy5OtEe1xs5kiahdPb2DZSegXW7DFg15GFlj+VG9WSRjSUOKk+4PCDdKl8cy0LJs+r
 W4CzBB2ARsfNGwRfAJHU4Xeki4a3gje1ISEf+TVxqqLQGWqNsZQ6SS7jjELaB/VlTbrsUEGR
 1XfIn/sqeskSeQwJiFLeQgj3ABEBAAGJAkEEGAECASsFAlPAG8IFGwwAAADAXSAEGQEIAAYF
 AlPAG8EACgkQk2AGqJgvD1UNFQgAlpN5/qGxQARKeUYOkL7KYvZFl3MAnH2VeNTiGFoVzKHO
 e7LIwmp3eZ6GYvGyoNG8cOKrIPvXDYGdzzfwxVnDSnAE92dv+H05yanSUv/2HBIZa/LhrPmV
 hXKgD27XhQjOHRg0a7qOvSKx38skBsderAnBZazfLw9OukSnrxXqW/5pe3mBHTeUkQC8hHUD
 Cngkn95nnLXaBAhKnRfzFqX1iGENYRH3Zgtis7ZvodzZLfWUC6nN8LDyWZmw/U9HPUaYX8qY
 MP0n039vwh6GFZCqsFCMyOfYrZeS83vkecAwcoVh8dlHdke0rnZk/VytXtMe1u2uc9dUOr68
 7hA+Z0L5IQAKCRCBMbXEKbxmoLoHCACXeRGHuijOmOkbyOk7x6fkIG1OXcb46kokr2ptDLN0
 Ky4nQrWp7XBk9ls/9j5W2apKCcTEHONK2312uMUEryWI9BlqWnawyVL1LtyxLLpwwsXVq5m5
 sBkSqma2ldqBu2BHXZg6jntF5vzcXkqG3DCJZ2hOldFPH+czRwe2OOsiY42E/w7NUyaN6b8H
 rw1j77+q3QXldOw/bON361EusWHdbhcRwu3WWFiY2ZslH+Xr69VtYAoMC1xtDxIvZ96ps9ZX
 pUPJUqHJr8QSrTG1/zioQH7j/4iMJ07MMPeQNkmj4kGQOdTcsFfDhYLDdCE5dj5WeE6fYRxE
 Q3up0ArDSP1L
Message-ID: <2201753d-69ce-de12-e0c5-45ac6504caa5@broadcom.com>
Date:   Sat, 2 Nov 2019 12:43:55 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <1572702093-18261-2-git-send-email-wahrenst@gmx.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/2/2019 6:41 AM, Stefan Wahren wrote:
> This fixes the error handling for the mandatory IRQs. There is no need
> for the error message anymore, this is now handled by platform_get_irq.
> 
> Fixes: 1c1008c793fa ("net: bcmgenet: add main driver file")
> Signed-off-by: Stefan Wahren <wahrenst@gmx.net>

Not sure if the Fixes tag is necessary here, this is kind of an
exceptional case anyway since you should be specifying valid interrupt
resources to begin with.
-- 
Florian
