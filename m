Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9A3C410C8B
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 19:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbhISRJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 13:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbhISRJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 13:09:40 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18280C061574;
        Sun, 19 Sep 2021 10:08:14 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id i8-20020a056830402800b0051afc3e373aso20323354ots.5;
        Sun, 19 Sep 2021 10:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5SmafzjnNUKdEaDf9TgxfotqCk3DKH3AWvJDlua7sws=;
        b=cQukBkO0RXsYZrlkJvS085EELc5jqFS4KEBVaf5nJX9pRVjgW9Gc8EeyrAYq1j6oNy
         DTFVxTGJSLUcIofPGImHbPPyumt22WIKDOzEB3/RpCY00dUeu5wZZhMY7YgiHGltYrQW
         /u/I23tivYe0LsoAk/9LcxR107ggZ72N6aqtgpxVVRtEOK/JI5M6xmJ/d/uwtBm3QYHe
         RVu/xumg4E1SZ3gB52rnmBVG3gIz3/t8lP6UBQyWaUin3OlRmov7SZnYlPycyq8bOORa
         ht0XPVwvlz3G3aq+swtkmcPxKD+nKCcE8Rzg4yU3xkGvEjCofWK4DacHIivZ4+dvBCAt
         w6oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5SmafzjnNUKdEaDf9TgxfotqCk3DKH3AWvJDlua7sws=;
        b=w16jJ5Wym3DRRgXYgAtOZ1dGlGqhoRHSSs5vPjScj5PnEcqWjFwhKfB/kzq+/Lhiwq
         QWNvTuMa8BN6HRojSTKyGabICVEDYfd8k0vZW1hwPxrA+0esyBqmcNP8g4VC2QaV1neB
         OVGTM5Rueg95ekIljREei5P+heFlQ47EWGCvetVdg+CHN/oQwM532Xcu+JKY4hXYhDDj
         MQlnCyjEAQZ69/YtTZ8Pj0ve9tKpvchVTDxVVs57iSV8eSCZfPgiDrS5yJLejlFdU5TH
         bmgH8KrAOfM09q+wU9NybcIlRyXS7ABm338XePTdkumDwQ37ltV3Pp2Htic+p85Lakk8
         wr4g==
X-Gm-Message-State: AOAM532GbBd/YPm1ylrBgDX6SBmBaVumLZunM2ElKUzj5TlKLrKY2rA5
        c1p8k/QEQVN7RNvM4vbx5eLViANyTtuYkg==
X-Google-Smtp-Source: ABdhPJzqkL7Ei+4NbzXPq0Wbo8JjUaupAa+bBL9YVkui7C58RBgovKOrOYRTKHMY8ByOwVH7O00Gfw==
X-Received: by 2002:a05:6830:793:: with SMTP id w19mr17496412ots.23.1632071292969;
        Sun, 19 Sep 2021 10:08:12 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id g5sm2437786oof.29.2021.09.19.10.08.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Sep 2021 10:08:12 -0700 (PDT)
Subject: Re: [PATCH net] nexthop: Fix division by zero while replacing a
 resilient group
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>,
        stable@vger.kernel.org
References: <20210917130218.560510-1-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d1086930-9a07-1877-9f56-cbee6a106b0f@gmail.com>
Date:   Sun, 19 Sep 2021 11:08:11 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210917130218.560510-1-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/17/21 7:02 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> The resilient nexthop group torture tests in fib_nexthop.sh exposed a
> possible division by zero while replacing a resilient group [1]. The
> division by zero occurs when the data path sees a resilient nexthop
> group with zero buckets.
> 
> The tests replace a resilient nexthop group in a loop while traffic is
> forwarded through it. The tests do not specify the number of buckets
> while performing the replacement, resulting in the kernel allocating a
> stub resilient table (i.e, 'struct nh_res_table') with zero buckets.
> 
> This table should never be visible to the data path, but the old nexthop
> group (i.e., 'oldg') might still be used by the data path when the stub
> table is assigned to it.
> 
> Fix this by only assigning the stub table to the old nexthop group after
> making sure the group is no longer used by the data path.
> 
> Tested with fib_nexthops.sh:
> 
> Tests passed: 222
> Tests failed:   0
> 
> [1]
>  divide error: 0000 [#1] PREEMPT SMP KASAN
>  CPU: 0 PID: 1850 Comm: ping Not tainted 5.14.0-custom-10271-ga86eb53057fe #1107
>  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-4.fc34 04/01/2014
>  RIP: 0010:nexthop_select_path+0x2d2/0x1a80
> [...]
>  Call Trace:
>   fib_select_multipath+0x79b/0x1530
>   fib_select_path+0x8fb/0x1c10
>   ip_route_output_key_hash_rcu+0x1198/0x2da0
>   ip_route_output_key_hash+0x190/0x340
>   ip_route_output_flow+0x21/0x120
>   raw_sendmsg+0x91d/0x2e10
>   inet_sendmsg+0x9e/0xe0
>   __sys_sendto+0x23d/0x360
>   __x64_sys_sendto+0xe1/0x1b0
>   do_syscall_64+0x35/0x80
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Cc: stable@vger.kernel.org
> Fixes: 283a72a5599e ("nexthop: Add implementation of resilient next-hop groups")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Petr Machata <petrm@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 2 ++
>  1 file changed, 2 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

