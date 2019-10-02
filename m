Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAF6C936F
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 23:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbfJBVXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 17:23:08 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41013 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728220AbfJBVXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 17:23:08 -0400
Received: by mail-pg1-f196.google.com with SMTP id s1so351710pgv.8
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 14:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jiB0ayywNyocteaGY2MEqUumoxsbrwHNJSLQ/RKCHP0=;
        b=kypwazYGSiuB119480smu4Jl/KhDWh6Qjhy8/It9hzJNe8+tuNIqpyAy8wjHOStdR6
         3mm6gpbLfG0RYVuBpjFuf0pRtFXK/76p7V+7ia1FRWJkloJGlq3pQaQ/pU2rkfYniL9x
         a2UqidKilXQP0Tzf2baWwDdhfyairMlGtEa2tY+xIUHo/d/9FzmF+XBoaU0BxxQ2Azr0
         hMKw4a6ZG6veHiqc0ArMiUlbpDJuqFFFyxeeTWw1NhI66c6l710Q/dRjxCt+kmntYfnp
         0sbGbwU6/sCDMVLrtWMvnPpXjQ+FYO036eVvlT7EwSP38de7uWEMXGrkj53H/cWaOOHV
         0XvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jiB0ayywNyocteaGY2MEqUumoxsbrwHNJSLQ/RKCHP0=;
        b=nxxIN0U8CkLlKAVZS4ATMog0SPpXmG1lqvCuCNkQ7IYfVljYM+7nHcribruzKtqcpJ
         9BwHuCsYo83DalVzchGzeGQEhqfsjfwep/eIfNMDGwKpMWtltAJ7KFSYeVG9FHNzakeU
         mte7uGC8DosMnigf+ADp3P32gwBIqdt7eTt4LVoZLvLKNeYEs5jdxhMf2fnMUEzLpgSA
         6LZkG9csDWimYfqc6xIQr7oec7f0z886K6lgYxeY8kbVQ3sLuzTkoSgA/enwgCmetAZN
         DqxIAMqO5m56VVZBQg/2RUdJPRE6cFVHfxErJv2+s9+H80zEWoj3mrkliREwgOx81SCz
         nknA==
X-Gm-Message-State: APjAAAWtlUDE/WOjzzUq9Zglv16cY6uync5ZN0to5+Td72+MuG06nR9q
        dMvIwsi5+CMKthuNInTOSk4=
X-Google-Smtp-Source: APXvYqyrhZj6iLRpg6xknKiv14HMTITgmQlZnOeREAlzfS8m4SGjFs3LgFodSBbg2D0nLqVxPJ070Q==
X-Received: by 2002:a63:3709:: with SMTP id e9mr5870264pga.53.1570051386255;
        Wed, 02 Oct 2019 14:23:06 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id v1sm173632pjd.22.2019.10.02.14.23.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Oct 2019 14:23:05 -0700 (PDT)
Subject: Re: [PATCH net v2] ipv6: Handle race in addrconf_dad_work
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, rajendra.dendukuri@broadcom.com,
        David Ahern <dsahern@gmail.com>
References: <20191001032834.5330-1-dsahern@kernel.org>
 <1ab3e0d0-fb37-d367-fd5f-c6b3262b6583@gmail.com>
 <18c18892-3f1c-6eb8-abbb-00fd6c9c64d3@gmail.com>
Message-ID: <146a2f8a-8ee9-65f3-1013-ef60a96aa27b@gmail.com>
Date:   Wed, 2 Oct 2019 14:23:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <18c18892-3f1c-6eb8-abbb-00fd6c9c64d3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/2/19 2:08 PM, Eric Dumazet wrote:
> 
> 
> On 10/1/19 11:18 AM, Eric Dumazet wrote:
>>
>>
>> On 9/30/19 8:28 PM, David Ahern wrote:
>>> From: David Ahern <dsahern@gmail.com>
>>>
>>> Rajendra reported a kernel panic when a link was taken down:
>>>
>>> [ 6870.263084] BUG: unable to handle kernel NULL pointer dereference at 00000000000000a8
>>> [ 6870.271856] IP: [<ffffffff8efc5764>] __ipv6_ifa_notify+0x154/0x290
>>>
>>> <snip>
>>>
>>
>> Reviewed-by: Eric Dumazet <edumazet@google.com>
>>
>> Thanks !
>>
> 
> Apparently this patch causes problems. I yet have to make an analysis.
> 

It seems we need to allow the code to do some changes if IF_READY is not set.

WDYT ?

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index dd3be06d5a066e494617d4917c757eae19340d4d..e8181a3700213b9574ea25130689c9218236245d 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4035,7 +4035,7 @@ static void addrconf_dad_work(struct work_struct *w)
        /* check if device was taken down before this delayed work
         * function could be canceled
         */
-       if (idev->dead || !(idev->if_flags & IF_READY))
+       if (idev->dead)
                goto out;
 
        spin_lock_bh(&ifp->lock);
@@ -4083,6 +4083,11 @@ static void addrconf_dad_work(struct work_struct *w)
                goto out;
 
        write_lock_bh(&idev->lock);
+       if (!(idev->if_flags & IF_READY)) {
+               write_unlock_bh(&idev->lock);
+               goto out;
+       }
+
        spin_lock(&ifp->lock);
        if (ifp->state == INET6_IFADDR_STATE_DEAD) {
                spin_unlock(&ifp->lock);
