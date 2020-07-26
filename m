Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A01722DAB5
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 02:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgGZAHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 20:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727789AbgGZAHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 20:07:53 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22127C08C5C0;
        Sat, 25 Jul 2020 17:07:53 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id t4so11315085oij.9;
        Sat, 25 Jul 2020 17:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7yG4ryB8jfwldPWWWRczVJAvSj8jKZekCuaFpys05pk=;
        b=vKaOARyBh6QtfllqR4xwoLl5T6MfehkMfz52QhK/6O+0+ekZ9PLK+aqFrVe5Di9wOS
         vsIs3Dio4Hlsg4Y7pxSx23Mr6bJVUcJ5Qbpai/Tmw51dZoVb/iNvqrTFkk0TI7dRdVXt
         GsFt8Y9itKEXqaLLEQRAA3M8lvFHaWT0xV8iw4kCc8R2DE5doHUy3SVfgXwazJCDKnI9
         /gMrWB5DAhnPTbc4S70WNz+pJK1CnEzT3OPtU+10uYKuqAnrnD2Nqnl2VR6apF4vgVPK
         5fKTECiKtTBl/sg42CysSi+B3ubCOymWzjYJn5TW9MQjNE2RdbEddHnAdvkB46IeaS1q
         L+aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7yG4ryB8jfwldPWWWRczVJAvSj8jKZekCuaFpys05pk=;
        b=st1DtqzG4GE3wp38PLXDurYVsMjCU8qjBu01GRxIvnlVfQmKu5s60gdHYrFf0o2xvo
         x91309bGnmS9zODAaoyM8o3o875UFSLN3BU39WnDcry2TyV3imNCTx+ImRCBt917/ETf
         XrdIzIZvIIO2Q+TGMNcfGW69j7jzs79uvRkM5yEQhMrupJqDoBEvZiB1SgfWuomU+YZh
         BkF8YjUV+W+pLuqyJCs7T2aUytabzcV25mdmCkwWVCwMsfLX3V3eIVtpCeKBeFJePdm1
         wpMAh22o/hwT6kvdJuXjh7mePtjVDuGtMpvPXxSun7ZA/KwTNRw1uL7l0bRXQZjedAMb
         U/WQ==
X-Gm-Message-State: AOAM530mKGt/yWzktRnr8k9e3SUWOQx1ZXRRuN6WqL8kyYZqPEpv1PC4
        VMnrCECsIuMZNnGoAGCVN4A=
X-Google-Smtp-Source: ABdhPJyaczFvIbpWNXLQN60Sy6Xgq9CNGT22YxPNwE+fVgxi/5S+Nq/7M0M9hfi0YgZi0dkmMIIMOg==
X-Received: by 2002:a05:6808:34e:: with SMTP id j14mr13692622oie.166.1595722071537;
        Sat, 25 Jul 2020 17:07:51 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:6c04:5f77:5096:1c38])
        by smtp.googlemail.com with ESMTPSA id n7sm2157057ooo.38.2020.07.25.17.07.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jul 2020 17:07:50 -0700 (PDT)
Subject: Re: [PATCH] ipv6: Fix nexthop refcnt leak when creating ipv6 route
 info
To:     Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Xin Tan <tanxin.ctf@gmail.com>
References: <1595664139-40703-1-git-send-email-xiyuyang19@fudan.edu.cn>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <330e3acc-dff5-a59e-e138-97ffbb6e7892@gmail.com>
Date:   Sat, 25 Jul 2020 18:07:49 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1595664139-40703-1-git-send-email-xiyuyang19@fudan.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/25/20 2:02 AM, Xiyu Yang wrote:
> ip6_route_info_create() invokes nexthop_get(), which increases the
> refcount of the "nh".
> 
> When ip6_route_info_create() returns, local variable "nh" becomes
> invalid, so the refcount should be decreased to keep refcount balanced.

I forgot to write the test case for this very code path in
tools/testing/selftests/net/fib_nexthops.sh. If you have the time, it
goes in ipv6_fcnal_runtime() - see the last 'TO-DO' item.

> 
> The reference counting issue happens in one exception handling path of
> ip6_route_info_create(). When nexthops can not be used with source
> routing, the function forgets to decrease the refcnt increased by
> nexthop_get(), causing a refcnt leak.
> 
> Fix this issue by pulling up the error source routing handling when
> nexthops can not be used with source routing.
> 

Fixes: f88d8ea67fbd ("ipv6: Plumb support for nexthop object in a
fib6_info")

> Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
> Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
> ---
>  net/ipv6/route.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 


Reviewed-by: David Ahern <dsahern@kernel.org>
