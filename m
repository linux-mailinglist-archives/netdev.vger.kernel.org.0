Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38FB8602309
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 06:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbiJRECn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 00:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiJRECl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 00:02:41 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9182186EE
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 21:02:38 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id 81so15583951ybf.7
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 21:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HalKK5SyX7FJhYB5Tf86gqfUkX66otPt4pr9pNs2XmA=;
        b=Xm71qlnvRqyuKfZiXZ6kysTR2sRjb9zTfNa42alQ+cKjHsZx2xgw+rdFQsQAy9JchL
         DI30gqjH4RqKPJdg/Mdk4S0PODBtMnTwuOF+cpc3Tu2z43Qsjtml3JTAaePN9pR+QvBE
         RCgvZtHchl+2diBPREa5X+GG6VtFrd80fXVmGQ7sLi6uUMuVDDSZ87a2rGHvGRxeFAqk
         uF82P6zMl0jdvCEGjBKbonMCkM6NXs3tyd/VH7nKBbK+xOVxaQrUB1k5MXtmfIs/ubI0
         lijPS189ySTUDCj68W1GLbzP9dCX+Akj7VZ044VrGwXyGTYZ1oMKjBGzgOtyhZCr7NVd
         0/uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HalKK5SyX7FJhYB5Tf86gqfUkX66otPt4pr9pNs2XmA=;
        b=NFn4kuV9Sqlxp4RwKndmBoL4K39m1r0obEQi8wOfEbcGFe5BRAwSSDPb8XWgH+OA3p
         tCrG0HxgD0bOFnl2kAaOj4wui3OacVTz8p17qgU4anJkx2G7VgDrJ2LyObLFQiiuyQ0k
         eLprp4rcC5SSav5GMLaiW5DR8vkaKZDA4jO8Ob8dxZD78WOfSLIs2BS4nHPnT+Oq25C+
         damcL3w4rLs/NO3QFwD2Eg5Ca1t0VWEwAC3Yalrd9qZYSeDddBqrebv2iy1YTK7UjqIJ
         XLAB0haoX7wA7a8N+u2Ft2e8MMyP9vfo0lBCFNlpbJfmKjhuPEOfeKdn8Us+b78XodhO
         +s6w==
X-Gm-Message-State: ACrzQf2ayLBF5ztoFC/xb8F2IBQppMp3HdmduQwKrGhv6DMgNw/huurb
        3VItTm83PATw2bcoYtE3x03o/IMzrpHbGsucv6vlhw==
X-Google-Smtp-Source: AMsMyM5a72J+oURrN1Xn65POqIcaJbOb/V5ADXI1msRfSesaXYIp7KdxQCFidqm8CWl7fZdfIE8dj2k7QBC+tgvGSi0=
X-Received: by 2002:a25:328c:0:b0:6be:2d4a:e77 with SMTP id
 y134-20020a25328c000000b006be2d4a0e77mr762263yby.407.1666065757722; Mon, 17
 Oct 2022 21:02:37 -0700 (PDT)
MIME-Version: 1.0
References: <20221018034718.82389-1-shaozhengchao@huawei.com> <20221018034718.82389-3-shaozhengchao@huawei.com>
In-Reply-To: <20221018034718.82389-3-shaozhengchao@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 17 Oct 2022 21:02:26 -0700
Message-ID: <CANn89iJubvtbdpgKXhP8CMcWEn8Ws80sLeu=F4RMTAEKWePoyg@mail.gmail.com>
Subject: Re: [PATCH net 2/3] net: sched: fq_codel: fix null pointer access
 issue when fq_codel_init() fails
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     cake@lists.bufferbloat.net, netdev@vger.kernel.org, toke@toke.dk,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        dave.taht@gmail.com, weiyongjun1@huawei.com, yuehaibing@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 17, 2022 at 8:39 PM Zhengchao Shao <shaozhengchao@huawei.com> wrote:
>
> When the default qdisc is fq_codel, if the qdisc of dev_queue fails to be
> inited during mqprio_init(), fq_codel_reset() is invoked to clear
> resources. In this case, the flow is NULL, and it will cause gpf issue.
>
> The process is as follows:
> qdisc_create_dflt()
>         fq_codel_init()
>                 ...
>                 q->flows_cnt = 1024;
>                 ...
>                 q->flows = kvcalloc(...)      --->failed, q->flows is NULL
>                 ...
>         ...
>         qdisc_put()
>                 ...
>                 fq_codel_reset()
>                         ...
>                         flow = q->flows + i   --->q->flows is NULL
>
> The following is the Call Trace information:
> general protection fault, probably for non-canonical address
> 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
> RIP: 0010:fq_codel_reset+0x14d/0x350
> Call Trace:
> <TASK>
> qdisc_reset+0xed/0x6f0
> qdisc_destroy+0x82/0x4c0
> qdisc_put+0x9e/0xb0
> qdisc_create_dflt+0x2c3/0x4a0
> mqprio_init+0xa71/0x1760
> qdisc_create+0x3eb/0x1000
> tc_modify_qdisc+0x408/0x1720
> rtnetlink_rcv_msg+0x38e/0xac0
> netlink_rcv_skb+0x12d/0x3a0
> netlink_unicast+0x4a2/0x740
> netlink_sendmsg+0x826/0xcc0
> sock_sendmsg+0xc5/0x100
> ____sys_sendmsg+0x583/0x690
> ___sys_sendmsg+0xe8/0x160
> __sys_sendmsg+0xbf/0x160
> do_syscall_64+0x35/0x80
> entry_SYSCALL_64_after_hwframe+0x46/0xb0
> RIP: 0033:0x7fd272b22d04
> </TASK>
>
> Fixes: 494f5063b86c ("net: sched: fq_codel: remove redundant resource cleanup in fq_codel_init()")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---

I vote for a revert, previous code was much cleaner.
