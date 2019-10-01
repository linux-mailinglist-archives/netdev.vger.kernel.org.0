Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDDDC3FB4
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 20:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732034AbfJASSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 14:18:55 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41346 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbfJASSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 14:18:54 -0400
Received: by mail-pg1-f194.google.com with SMTP id s1so10233781pgv.8
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 11:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=a4e8vEmJ55W4AxATOqmd1PYnjLiZCoOPp99j06eISto=;
        b=bdrIHpJYS+H8GrAf3T9ymZwgEtfZyvIi5ij5g67Y7cM/jNkTf+Ur0tBavGx6CXTxQi
         pZToxA6q3a99Vr1QlRC5fIuF69QGy1a3bxhftTp79raLJaawyMmvXMl2QnwksCAi+rw6
         cty+qhy2q8sJUzzxC9V3vZc1Lc5actSqQl4gHRrUbt6h1CD0I/Ex47dq+EH0/LAIQWRB
         d7X9gyhU6mVbhO9KuP1wXE5C6cEd5z/TdQOwK5n236GIZAvnl/76Pa3xCr0RYAi0rEfe
         RJo7VFjpU2eqiwwal+D7SZIbvUUhZvDi1rwJfbsCYelPB/CpUXT3cLm//S5CCiHIDfoZ
         pJew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a4e8vEmJ55W4AxATOqmd1PYnjLiZCoOPp99j06eISto=;
        b=qFOEN/cgMKCl97OWf+01kbh71mNdRoyMe+rvVxiiry0Y3SxLXLKgj0v0AvimaxveZY
         7xWVh5hzi6yc2xLaR2CKyCGOHvGyndGbfX5qPrpz6L1/zceObga9zF4mJD5iVHY7PxBb
         RIM50YwXeQmeXqHqFnJLtPKyreKqa1UUkkYK1Np8GVYRNPCsaSYnOmLOxhMJkF04VB4O
         bs3PLEgWRcUJ85ft+mCRnx89S+406bNGEEfNjPB3MtqjBAkH4Q+CfI1iIJuXm1Xv6diW
         1+w+QFKWqUXHU+XnbWJ6VEZe9jmVzjB535UrwmwCOJLwHNHrlHoBjUjLLxUFPHtxH1OI
         FaFg==
X-Gm-Message-State: APjAAAUYPPkT+Iq0cCqhYTuOf1Vzmm5veY98APD8eUAPgQ/9twAG009Z
        VWefdXV4k8whPaMFgSi/97I=
X-Google-Smtp-Source: APXvYqz3fviYkxSQy3uopnNTmmdjntU1Gb0DLvFMWRRAqVrvKDua4vx2BUgE447x8LEOS4Wsht+lww==
X-Received: by 2002:a62:64ca:: with SMTP id y193mr29318730pfb.164.1569953932795;
        Tue, 01 Oct 2019 11:18:52 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id w11sm18202297pfd.116.2019.10.01.11.18.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Oct 2019 11:18:51 -0700 (PDT)
Subject: Re: [PATCH net v2] ipv6: Handle race in addrconf_dad_work
To:     David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, rajendra.dendukuri@broadcom.com,
        David Ahern <dsahern@gmail.com>
References: <20191001032834.5330-1-dsahern@kernel.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <1ab3e0d0-fb37-d367-fd5f-c6b3262b6583@gmail.com>
Date:   Tue, 1 Oct 2019 11:18:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191001032834.5330-1-dsahern@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/30/19 8:28 PM, David Ahern wrote:
> From: David Ahern <dsahern@gmail.com>
> 
> Rajendra reported a kernel panic when a link was taken down:
> 
> [ 6870.263084] BUG: unable to handle kernel NULL pointer dereference at 00000000000000a8
> [ 6870.271856] IP: [<ffffffff8efc5764>] __ipv6_ifa_notify+0x154/0x290
> 
> <snip>
> 

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks !

