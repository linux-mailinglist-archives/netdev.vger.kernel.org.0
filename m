Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B842305216
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 06:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbhA0FSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 00:18:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234503AbhA0Ehx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 23:37:53 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80873C0613D6
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 20:36:14 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id w8so895290oie.2
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 20:36:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BriFJKpxtyDY96JBBgv7U+0HEIgEkOOsat2y8i6t3yU=;
        b=b8HC4wYSU0yiMSEtsxwJJ7pPkJ3oMABKurhJC7j05bBiXj4SK7g5/Pi0zG8Wc7A9Yg
         /+O0H1soBo28ZOQVQzTIERNFXt5yBabvPJ1Hz22VTMv8a2QYwMSbWbtwXsddR3kjkeLL
         mxs7a5DrBT4riBVK0zv7t5pfzkCF16dXFRfRSBz4ANvFHImbAakDhNmzgCbKFVDRj1pJ
         HniOhy/B6O5j3X+WDvK5cM1h01Uu5eADGGW3cQTWYPgIGLm+XV0vE9/i/EpiGgLmwCPm
         omj4jmtBN99v9Iz5cYAgMxqr72x4C9bJdZM97qWf9CRMwnFIKILxs+LT0Ae04g21Q2w5
         CSrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BriFJKpxtyDY96JBBgv7U+0HEIgEkOOsat2y8i6t3yU=;
        b=hNwW4g79LF3L/G7f168+NY9w6+SQU0gI6k088HUgUvRd1fG29Nh2NlJ16nz98J6iKb
         xznHIfUJnbJVFYdb+Psg3gh6+FdTIGaPNw7Z1yTMLxJ3kt+z7ATrUuL2qbZ5WDsio16y
         kbhkKOife/A7bQ8tpMGolezn4O6dTFukiWWY8Xx4s9B0dY9SfcalqepJFgtetD+6MVHu
         1sE6fGTcbSsY7tUNkHz8gqMgQAxYMy//mcvWLtRTI3RKi9INJAdL4nvB2qw4VmRPhpy5
         cYC8fWqyiLQRCuMzCHm7YMKs6dypnqgiFD4Niaggjs+Qrp5sevonYm6IjPOT1WF2hEah
         dLmg==
X-Gm-Message-State: AOAM533CRS7eYfT0+22tZiZCq8oWJDW6Zhf70EYTyjlWTy7IhuKRAHCK
        saMoqz7n9aAIf5CsKqAxbzAM7u9IXVA=
X-Google-Smtp-Source: ABdhPJzW/4R128yVDeULK5XV5+ho/LZvgDVxUOV6s7UKEMeK4GGmH1trUKWbvCkNpPOdeaE1InIPHQ==
X-Received: by 2002:aca:f486:: with SMTP id s128mr1935773oih.113.1611722173962;
        Tue, 26 Jan 2021 20:36:13 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:284:8203:54f0:a08d:e5cd:cfb5:2f9])
        by smtp.googlemail.com with ESMTPSA id w5sm179124ote.29.2021.01.26.20.36.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 20:36:13 -0800 (PST)
Subject: Re: [PATCH net-next 02/10] netdevsim: fib: Perform the route
 programming in a non-atomic context
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        roopa@nvidia.com, sharpd@nvidia.com, bpoirier@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20210126132311.3061388-1-idosch@idosch.org>
 <20210126132311.3061388-3-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <505125ef-522b-4beb-270f-25b6614f88ed@gmail.com>
Date:   Tue, 26 Jan 2021 21:36:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210126132311.3061388-3-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/26/21 6:23 AM, Ido Schimmel wrote:
> From: Amit Cohen <amcohen@nvidia.com>
> 
> Currently, netdevsim implements dummy FIB offload and marks notified
> routes with RTM_F_TRAP flag. netdevsim does not defer route notifications
> to a work queue because it does not need to program any hardware.
> 
> Given that netdevsim's purpose is to both give an example implementation
> and allow developers to test their code, align netdevsim to a "real"
> hardware device driver like mlxsw and have it also perform the route
> "programming" in a non-atomic context.
> 
> It will be used to test route flags notifications which will be added in
> the next patches.
> 
> The following changes are needed when route handling is performed in WQ:
> - Handle the accounting in the main context, to be able to return an
>   error for adding route when all the routes are used.
>   For FIB_EVENT_ENTRY_REPLACE increase the counter before scheduling
>   the delayed work, and in case that this event replaces an existing route,
>   decrease the counter as part of the delayed work.
> 
> - For IPv6, cannot use fen6_info->rt->fib6_siblings list because it
>   might be changed during handling the delayed work.
>   Save an array with the nexthops as part of fib6_event struct, and take
>   a reference for each nexthop to prevent them from being freed while
>   event is queued.
> 
> - Change GFP_ATOMIC allocations to GFP_KERNEL.
> 
> - Use single work item that is handling a list of ordered routes.
>   Handling routes must be processed in the order they were submitted to
>   avoid logical errors that could lead to unexpected failures.
> 
> Signed-off-by: Amit Cohen <amcohen@nvidia.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  drivers/net/netdevsim/fib.c | 467 +++++++++++++++++++++++++-----------
>  1 file changed, 327 insertions(+), 140 deletions(-)
> 

Acked-by: David Ahern <dsahern@kernel.org>

