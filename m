Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CABF039A409
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 17:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbhFCPNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 11:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231558AbhFCPNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 11:13:55 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F22C06174A
        for <netdev@vger.kernel.org>; Thu,  3 Jun 2021 08:12:10 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id m137so2707538oig.6
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 08:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bJic+6tz18vYn4XY34kgSZ1q4wb1zHF82Ip5JNMuAwg=;
        b=LChAnGh7xp/VHexa84QvDxgT5/+FGUXS1V9sBswWi0GlTZ97RY5x1Rz8FQN8pcKiSB
         MN6M0ImJ2k+tK0vaAzM7OA7qd6X1Pl444VSTViMhaAcLGEsxhypo9CmGTxt4zG9yEtzI
         Gd+qTIjN4tCQ0PJcvpNu7L/r2VTbisSpCrblwxTJ1sITH3aTWzLyLjdu2eUXW9F9by2R
         YSfoCgWjwiNiijHuzrXTAFw0ddk5hrFikBHz4p+lR4yr4egnVQpnupZLA9qiMiIQ5DyB
         lNeqbtJ8xmKEFIjzRiXXpNrx09As9OjkCvkdHzIGxy+V6/W4LDX1IdHxd4Rod6xMDWrv
         bqlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bJic+6tz18vYn4XY34kgSZ1q4wb1zHF82Ip5JNMuAwg=;
        b=lu3e1dFuF9rWq3tCNI/U8OjDobr0rnL4B4aJUmMaQdqa0BSf/H4rjWyLdWA7ThZ04O
         UbJkOt+mjWZ1t8dIlTuzPbXkTp8WXUZHJtQQTufFahbdkTXQanz6LJ1Zd4FReQOEjOg0
         38156SQ+f75ABS98nWK4acLNpA+lXyvwJMAVBWTEWTj0uOFpdHZB63OO+ERMrtNPmQBD
         O0LxdS+pVLLnyBGGXj6bbUuV0Pn9FOhz2FuHv/VL7rgYuMfxspzEhiDvUDpjk8B5g8XL
         IHtLhmsyxs/WY5Wt+ZhgOTzoUnBZbxZrxdgbpR0CBKvoXILVSUHy9sw35HoZWlFn4WBB
         xSMQ==
X-Gm-Message-State: AOAM532OMRZthGCwzQSf4BgBjjLMoAH28aKqCzulaqh73IBp6lTXp6Jz
        Wfbu9R3pVRe+idf3a5tGhEI=
X-Google-Smtp-Source: ABdhPJzesQ8JUanx/8T8s9cO9ZmIlZVIoX6vM88HB5lTyHCmXOfgnEgxISmJ31L25LbuGd2OOnJHrw==
X-Received: by 2002:a54:400a:: with SMTP id x10mr7973210oie.158.1622733130148;
        Thu, 03 Jun 2021 08:12:10 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id d20sm756712otq.62.2021.06.03.08.12.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jun 2021 08:12:09 -0700 (PDT)
Subject: Re: [PATCH net] ipv6: Fix KASAN: slab-out-of-bounds Read in
 fib6_nh_flush_exceptions
To:     Coco Li <lixiaoyan@google.com>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
References: <20210603073258.1186722-1-lixiaoyan@google.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1fb6e6f5-a89b-19b8-74df-5e8377605d6a@gmail.com>
Date:   Thu, 3 Jun 2021 09:12:08 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210603073258.1186722-1-lixiaoyan@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/3/21 1:32 AM, Coco Li wrote:
> Reported by syzbot:
> HEAD commit:    90c911ad Merge tag 'fixes' of git://git.kernel.org/pub/scm..
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> dashboard link: https://syzkaller.appspot.com/bug?extid=123aa35098fd3c000eb7
> compiler:       Debian clang version 11.0.1-2
> 
...

> 
> In the ip6_route_info_create function, in the case that the nh pointer
> is not NULL, the fib6_nh in fib6_info has not been allocated.
> Therefore, when trying to free fib6_info in this error case using
> fib6_info_release, the function will call fib6_info_destroy_rcu,
> which it will access fib6_nh_release(f6i->fib6_nh);
> However, f6i->fib6_nh doesn't have any refcount yet given the lack of allocation
> causing the reported memory issue above.
> Therefore, releasing the empty pointer directly instead would be the solution.
> 
> Fixes: f88d8ea67fbdb ("ipv6: Plumb support for nexthop object in a fib6_info")
> Fixes: 706ec91916462 ("ipv6: Fix nexthop refcnt leak when creating ipv6 route info")
> Signed-off-by: Coco Li <lixiaoyan@google.com>
> Cc: David Ahern <dsahern@kernel.org>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> ---
>  net/ipv6/route.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>
