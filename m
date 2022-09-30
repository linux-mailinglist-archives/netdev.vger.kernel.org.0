Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD5F85F1030
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 18:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbiI3Qnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 12:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232235AbiI3Qnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 12:43:41 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15DB6198686
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 09:43:40 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-324ec5a9e97so49687997b3.7
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 09:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=2oQDtouYC9WEKv48uT0kLmtjhnea4jelKk0fBgM03W0=;
        b=QbZ3WiNX62sPsNx6sLqR7iv/BxknvdUPmjvNURilIRgF5fKp0PNRo6FqEkXtEi1MoR
         MVMx4659tJhrcUg6jT8OmZmo8BGrPg6yxpEMlnyN+gCr1TllvEGiTzUUdAxr1R0XDn4L
         ZQUqtI6YD9BpAHLsaF30j1Jtddiyen6vxzRtnMV+Ro6ZOLD3GbmQXdHXa1RvoD80Me7L
         Xhu3R962CDbubg5m8aIegFEY6E5k/DTXr3mO2ESNfTEzdpKXYCEqrOQpFQzP6OvUh41c
         1c6hAuHZeCRSnAiZchDyNibIjaGseE2XYFojQlIHz5v7kkIvanYpqj9qQRzWPwitcoIF
         mWrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=2oQDtouYC9WEKv48uT0kLmtjhnea4jelKk0fBgM03W0=;
        b=PzvWIw+v4WAW3A6UgR0dg4pzBrc9yqD2zmIBtcQfk4ZJAV7wr9ZyuHwD+rfdgsGkoe
         TzV6b/G0dHePfgM2gTa1dnR0RgxKDC/NUD4/e3TNLpiJfuKhVrUCgxunRhC4HRDD1THo
         XKXRrbymtQzv6yGuAG8HF0FXVXwys6IFlsTf3srBYRtpKHr7Ky0AHy3J94GQhEvoT8q2
         qaP3HwJPQL6PrEnBVJf2xCYhlsA1vZnEU1t6Wi8eT3l4kq5Jn1fNcUGBYvHHu2WCt4OW
         W34T3gAAiRADHMfZkcgV2zt+fgMLpbzuzMrbvcIYHvPqnAYFSfXQAhZb0K0um+AgRTp9
         ReLA==
X-Gm-Message-State: ACrzQf2tNVW5cPYDK0iYbKNdfWysvTUM/tZu+gIVfCN4624tFlKQqIcb
        LQIlm0XLM833Kzcn+Yfcdidaw1lTWfeM/2OArbx3pReVjUvrQg==
X-Google-Smtp-Source: AMsMyM7WE99BcmGnWmGHiNDMv8TFIwgrNj8I5YdhDnaSeS8ylNOnyFY65qgpI1q9yoA579jrXORTEHs6O4bXvGuMJ6g=
X-Received: by 2002:a0d:ea85:0:b0:355:58b2:5a48 with SMTP id
 t127-20020a0dea85000000b0035558b25a48mr7369286ywe.332.1664556219077; Fri, 30
 Sep 2022 09:43:39 -0700 (PDT)
MIME-Version: 1.0
References: <6b6f65957c59f86a353fc09a5127e83a32ab5999.1664350652.git.pabeni@redhat.com>
 <166450446690.30186.16482162810476880962.git-patchwork-notify@kernel.org>
In-Reply-To: <166450446690.30186.16482162810476880962.git-patchwork-notify@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 30 Sep 2022 09:43:26 -0700
Message-ID: <CANn89iJ=_e9-P4dvRcMzJYqpTBQ5kevEvaYFH1JVvSdv4sguhA@mail.gmail.com>
Subject: Re: [PATCH net-next v4] net: skb: introduce and use a single page
 frag cache
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>
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

On Thu, Sep 29, 2022 at 7:21 PM <patchwork-bot+netdevbpf@kernel.org> wrote:
>
> Hello:
>
> This patch was applied to netdev/net-next.git (master)
> by Jakub Kicinski <kuba@kernel.org>:
>
> On Wed, 28 Sep 2022 10:43:09 +0200 you wrote:
> > After commit 3226b158e67c ("net: avoid 32 x truesize under-estimation
> > for tiny skbs") we are observing 10-20% regressions in performance
> > tests with small packets. The perf trace points to high pressure on
> > the slab allocator.
> >
> > This change tries to improve the allocation schema for small packets
> > using an idea originally suggested by Eric: a new per CPU page frag is
> > introduced and used in __napi_alloc_skb to cope with small allocation
> > requests.
> >
> > [...]
>
> Here is the summary with links:
>   - [net-next,v4] net: skb: introduce and use a single page frag cache
>     https://git.kernel.org/netdev/net-next/c/dbae2b062824
>

Paolo, this patch adds a regression for TCP RPC workloads (aka TCP_RR)

Before the patch, cpus servicing NIC interrupts were allocating
SLAB/SLUB objects for incoming packets,
but they were also freeing skbs from TCP rtx queues when ACK packets
were processed. SLAB/SLUB caches
were efficient (hit ratio close to 100%)

After the patch, these CPU only free skbs from TCP rtx queues and
constantly have to drain their alien caches,
thus competing with the mm spinlocks. RX skbs allocations being done
by page frag allocation only left kfree(~1KB) calls.

One way to avoid the asymmetric behavior would be to switch TCP to
also use page frags for TX skbs,
allocated from tcp_stream_alloc_skb()
