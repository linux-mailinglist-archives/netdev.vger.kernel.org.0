Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDBFC4AF1D5
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 13:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbiBIMgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 07:36:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiBIMgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 07:36:40 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB47C0613CA
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 04:36:44 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id c5-20020a17090a1d0500b001b904a7046dso3410588pjd.1
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 04:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=KoaY7QVHhycjxFpCDXXDoU+1tLjtiipmxvi7trvu6gg=;
        b=D1BN68jaAcvHInI6xINXs8apMQX2ecblqVR0R7Nx/OUJByOiMGb39Rmo02F01kYoF8
         ZpE0DJicfsMrR/qkBE+ceZSGZls2WdCzDKX3kFSRl17EfA0vvJwudiI7CWP8gw8Xcx1y
         6nXY/UP2A8jhe4ay26mxoXIqed0P+zjFL+nUPR+I8DD7VOeodfGp/IA/Ok725POSF+HM
         yOY7T4gY6glBBO1j53L426Y/K+ONp8UcNf/4uZv5teXZQJV/M1tCrQfKS8AYqkmAEmlI
         /osoFp3Ioy7Cmtyc1bquL6NUXXA6JNOpvTO/5GZvRu5MEQtSpwn9eSOFj95RjqMfQ2j2
         syvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KoaY7QVHhycjxFpCDXXDoU+1tLjtiipmxvi7trvu6gg=;
        b=5aCuqfHODmXy52VC6JyVCgoKogngY3flMTfeqi591ftn9p+lbgWT3MJsgn6SKqSTqA
         2i6BW+UJ48VHAfFLJ0sP4vluOnQW2dSGML4dJvv0yWNlWCuzIVi0Qzoe6OOnKInjK4vX
         ffxdF+erxmgF7tytg0Z0yn4/qDBMxK5g4vd+1O84FZTmGSCXgkCia+7YVboXUKIy4z/m
         CIboGklEH87NC1putfdpbO171Z2ctC99Zm6FV/Yfz+ktiz6x2D6Eo3swXmGH2AUGu6c3
         /CIPqH+XhtcXE7pNCxR73LOZaSV+RwI9uWU5QN60s9gCcX0zAJgLtLudDaOG8BrKlUOY
         1c1A==
X-Gm-Message-State: AOAM5302s2LmIdwQLNWTW0S9ocuRTwit7OYCUKnfSgMSMGOwbvSkmyAf
        QQ+Squ8J9p9CkYF5OePr8e4=
X-Google-Smtp-Source: ABdhPJxoSwCyDkFL+fLpryYwjd0Oam5hZnC/SXP/8e+HW46IjZRo1n2yVooRK9w1/E18gywyQnV4Qg==
X-Received: by 2002:a17:902:c40b:: with SMTP id k11mr2048650plk.50.1644410203676;
        Wed, 09 Feb 2022 04:36:43 -0800 (PST)
Received: from [192.168.99.7] (i220-99-138-239.s42.a013.ap.plala.or.jp. [220.99.138.239])
        by smtp.googlemail.com with ESMTPSA id u18sm19843607pfk.14.2022.02.09.04.36.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 04:36:43 -0800 (PST)
Message-ID: <18d9bd16-a5f9-b4b3-d92c-4057240ad89f@gmail.com>
Date:   Wed, 9 Feb 2022 21:36:37 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH net] veth: fix races around rq->rx_notify_masked
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        syzbot <syzkaller@googlegroups.com>
References: <20220208232822.3432213-1-eric.dumazet@gmail.com>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
In-Reply-To: <20220208232822.3432213-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/02/09 8:28, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>

Thank you for handling this case.

> veth being NETIF_F_LLTX enabled, we need to be more careful
> whenever we read/write rq->rx_notify_masked.
> 
> BUG: KCSAN: data-race in veth_xmit / veth_xmit
> 
> write to 0xffff888133d9a9f8 of 1 bytes by task 23552 on cpu 0:
>   __veth_xdp_flush drivers/net/veth.c:269 [inline]
>   veth_xmit+0x307/0x470 drivers/net/veth.c:350
>   __netdev_start_xmit include/linux/netdevice.h:4683 [inline]
>   netdev_start_xmit include/linux/netdevice.h:4697 [inline]
>   xmit_one+0x105/0x2f0 net/core/dev.c:3473
>   dev_hard_start_xmit net/core/dev.c:3489 [inline]
>   __dev_queue_xmit+0x86d/0xf90 net/core/dev.c:4116
>   dev_queue_xmit+0x13/0x20 net/core/dev.c:4149
>   br_dev_queue_push_xmit+0x3ce/0x430 net/bridge/br_forward.c:53
>   NF_HOOK include/linux/netfilter.h:307 [inline]
>   br_forward_finish net/bridge/br_forward.c:66 [inline]
>   NF_HOOK include/linux/netfilter.h:307 [inline]
>   __br_forward+0x2e4/0x400 net/bridge/br_forward.c:115
>   br_flood+0x521/0x5c0 net/bridge/br_forward.c:242
>   br_dev_xmit+0x8b6/0x960
>   __netdev_start_xmit include/linux/netdevice.h:4683 [inline]
>   netdev_start_xmit include/linux/netdevice.h:4697 [inline]
>   xmit_one+0x105/0x2f0 net/core/dev.c:3473
>   dev_hard_start_xmit net/core/dev.c:3489 [inline]
>   __dev_queue_xmit+0x86d/0xf90 net/core/dev.c:4116
>   dev_queue_xmit+0x13/0x20 net/core/dev.c:4149
>   neigh_hh_output include/net/neighbour.h:525 [inline]
>   neigh_output include/net/neighbour.h:539 [inline]
>   ip_finish_output2+0x6f8/0xb70 net/ipv4/ip_output.c:228
>   ip_finish_output+0xfb/0x240 net/ipv4/ip_output.c:316
>   NF_HOOK_COND include/linux/netfilter.h:296 [inline]
>   ip_output+0xf3/0x1a0 net/ipv4/ip_output.c:430
>   dst_output include/net/dst.h:451 [inline]
>   ip_local_out net/ipv4/ip_output.c:126 [inline]
>   ip_send_skb+0x6e/0xe0 net/ipv4/ip_output.c:1570
>   udp_send_skb+0x641/0x880 net/ipv4/udp.c:967
>   udp_sendmsg+0x12ea/0x14c0 net/ipv4/udp.c:1254
>   inet_sendmsg+0x5f/0x80 net/ipv4/af_inet.c:819
>   sock_sendmsg_nosec net/socket.c:705 [inline]
>   sock_sendmsg net/socket.c:725 [inline]
>   ____sys_sendmsg+0x39a/0x510 net/socket.c:2413
>   ___sys_sendmsg net/socket.c:2467 [inline]
>   __sys_sendmmsg+0x267/0x4c0 net/socket.c:2553
>   __do_sys_sendmmsg net/socket.c:2582 [inline]
>   __se_sys_sendmmsg net/socket.c:2579 [inline]
>   __x64_sys_sendmmsg+0x53/0x60 net/socket.c:2579
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> read to 0xffff888133d9a9f8 of 1 bytes by task 23563 on cpu 1:
>   __veth_xdp_flush drivers/net/veth.c:268 [inline]
>   veth_xmit+0x2d6/0x470 drivers/net/veth.c:350
>   __netdev_start_xmit include/linux/netdevice.h:4683 [inline]
>   netdev_start_xmit include/linux/netdevice.h:4697 [inline]
>   xmit_one+0x105/0x2f0 net/core/dev.c:3473
>   dev_hard_start_xmit net/core/dev.c:3489 [inline]
>   __dev_queue_xmit+0x86d/0xf90 net/core/dev.c:4116
>   dev_queue_xmit+0x13/0x20 net/core/dev.c:4149
>   br_dev_queue_push_xmit+0x3ce/0x430 net/bridge/br_forward.c:53
>   NF_HOOK include/linux/netfilter.h:307 [inline]
>   br_forward_finish net/bridge/br_forward.c:66 [inline]
>   NF_HOOK include/linux/netfilter.h:307 [inline]
>   __br_forward+0x2e4/0x400 net/bridge/br_forward.c:115
>   br_flood+0x521/0x5c0 net/bridge/br_forward.c:242
>   br_dev_xmit+0x8b6/0x960
>   __netdev_start_xmit include/linux/netdevice.h:4683 [inline]
>   netdev_start_xmit include/linux/netdevice.h:4697 [inline]
>   xmit_one+0x105/0x2f0 net/core/dev.c:3473
>   dev_hard_start_xmit net/core/dev.c:3489 [inline]
>   __dev_queue_xmit+0x86d/0xf90 net/core/dev.c:4116
>   dev_queue_xmit+0x13/0x20 net/core/dev.c:4149
>   neigh_hh_output include/net/neighbour.h:525 [inline]
>   neigh_output include/net/neighbour.h:539 [inline]
>   ip_finish_output2+0x6f8/0xb70 net/ipv4/ip_output.c:228
>   ip_finish_output+0xfb/0x240 net/ipv4/ip_output.c:316
>   NF_HOOK_COND include/linux/netfilter.h:296 [inline]
>   ip_output+0xf3/0x1a0 net/ipv4/ip_output.c:430
>   dst_output include/net/dst.h:451 [inline]
>   ip_local_out net/ipv4/ip_output.c:126 [inline]
>   ip_send_skb+0x6e/0xe0 net/ipv4/ip_output.c:1570
>   udp_send_skb+0x641/0x880 net/ipv4/udp.c:967
>   udp_sendmsg+0x12ea/0x14c0 net/ipv4/udp.c:1254
>   inet_sendmsg+0x5f/0x80 net/ipv4/af_inet.c:819
>   sock_sendmsg_nosec net/socket.c:705 [inline]
>   sock_sendmsg net/socket.c:725 [inline]
>   ____sys_sendmsg+0x39a/0x510 net/socket.c:2413
>   ___sys_sendmsg net/socket.c:2467 [inline]
>   __sys_sendmmsg+0x267/0x4c0 net/socket.c:2553
>   __do_sys_sendmmsg net/socket.c:2582 [inline]
>   __se_sys_sendmmsg net/socket.c:2579 [inline]
>   __x64_sys_sendmmsg+0x53/0x60 net/socket.c:2579
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> value changed: 0x00 -> 0x01

I'm not familiar with KCSAN.
Does this mean rx_notify_masked value is changed while another CPU is reading it?

If so, I'm not sure there is a problem with that.
At least we could call napi_schedule() twice, but that just causes one extra napi 
poll due to NAPIF_STATE_MISSED, and it happens very rarely?

Toshiaki Makita
