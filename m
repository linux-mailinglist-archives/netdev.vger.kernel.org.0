Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 844B1462615
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 23:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbhK2Wq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 17:46:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234398AbhK2WoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 17:44:25 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB8D2C0C0876
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 09:44:51 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id s13so38660316wrb.3
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 09:44:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hzOx1eG/eR2CEdkQAHdZsD7yeCZJIch9Df75X0dhFac=;
        b=Y0untIZS8EpGk+szKxNKpY7wxQbRa9XJTEz0sC4T9wXurF9g+mFsu0YLLFKh7XN4SQ
         THr/PUjXONxqRvNXgZ14+Xbwz/EpphmuWf/bDNUqY9oCUu/660OFJSMXWTRMGHy/A01B
         Fpzn+1Lm5UzAfepDxY0zAY/nSCRZYxVcKH52sVs2vvEoi8ug+eMyjxeoaoRt7YRSznC3
         6Y+Wy7NpssYCuqP1a56pMeKC2Pb32t+PzaNghMM7oD/BISXUvPmgDA3LTizNRrHjJyEv
         BBuGfB2CMv3W2PZ9dYZCyIJRW2t3tTPbGNuxEF+JA6GpUJcGLtP41+sxM1GPfMSrtHUt
         Owow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hzOx1eG/eR2CEdkQAHdZsD7yeCZJIch9Df75X0dhFac=;
        b=k+zGKsjnKEDdQmLedHjHEaYfGH6BIbwVOsCY9HXbqYJWmhqHC02UCw0NDPhHlGwtHr
         o1CsVejn0jvDg3ZHbPNP7pK7MOh2AeQ/0kIMIRv+H09XiwHq4NuBhanp73WEL/IwK0uP
         KFSKWh8Z20IUO7J9MZAfJl3VlGEnn4vmCKHHAxQ9h7sCENdiUSwbfi8YfTz1deRSPFVe
         ic82Gt6posVQfoeZ5ln/96FGnKiEt7E8sgilnEbir73Bg4CcMQI3nGaEDm8gI/TMWgxf
         cvB7mJieNx4OdoqpMW3vOfUMVyiwMQpu51h0kMxjJNSdBJeu+NV/yIJavZRalybCFTJF
         2YIA==
X-Gm-Message-State: AOAM533MyhQfye78M3qHlJwdMv8IdDpYtDtgHXvXJM4UMmkf09NoqGmn
        X42W7jB/n8qS5DkNVYLWAlzx9q+V+0up91L40WvT4g==
X-Google-Smtp-Source: ABdhPJw/anl8SIvJAx2fOTcG8isi4uRA64oQ3G08WeANzyDxgQAkhWKm5capv2zIIi9w1215FVjL9AX5UFBkn4bzAbs=
X-Received: by 2002:adf:fb86:: with SMTP id a6mr35706630wrr.35.1638207889987;
 Mon, 29 Nov 2021 09:44:49 -0800 (PST)
MIME-Version: 1.0
References: <20211129045503.20217-1-xiangxia.m.yue@gmail.com> <20211129045503.20217-2-xiangxia.m.yue@gmail.com>
In-Reply-To: <20211129045503.20217-2-xiangxia.m.yue@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 29 Nov 2021 09:44:38 -0800
Message-ID: <CANn89i+Pk61q+7gxzhDEDgQBkcOhOLpx80QoiuDM2ceunFkqvg@mail.gmail.com>
Subject: Re: [net v3 2/3] net: sched: add check tc_skip_classify in sch egress
To:     xiangxia.m.yue@gmail.com
Cc:     netdev@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Wei Wang <weiwan@google.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 28, 2021 at 8:55 PM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> Try to resolve the issues as below:
> * We look up and then check tc_skip_classify flag in net
>   sched layer, even though skb don't want to be classified.
>   That case may consume a lot of cpu cycles.
>
>   Install the rules as below:
>   $ for id in $(seq 1 100); do
>   $       tc filter add ... egress prio $id ... action mirred egress redirect dev ifb0
>   $ done
>
>   netperf:
>   $ taskset -c 1 netperf -t TCP_RR -H ip -- -r 32,32
>   $ taskset -c 1 netperf -t TCP_STREAM -H ip -- -m 32
>
>   Before: 10662.33 tps, 108.95 Mbit/s
>   After:  12434.48 tps, 145.89 Mbit/s
>   For TCP_RR, there are 16.6% improvement, TCP_STREAM 33.9%.

These numbers mean nothing, really.

I think you should put 10,000 filters instead of 100 so that the
numbers look even better ?

As a matter of fact, you add yet another check in fast  path.

For some reason I have not received the cover letter and patch 1/3.
