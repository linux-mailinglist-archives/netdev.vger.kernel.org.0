Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59F5C614AD5
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 13:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbiKAMhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 08:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbiKAMhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 08:37:23 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E356618E2C
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 05:37:21 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-36cbcda2157so134558817b3.11
        for <netdev@vger.kernel.org>; Tue, 01 Nov 2022 05:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=F/FPQon1lKuEcgIBUSF5KOqSskD51ob9OwnxpY6zbaI=;
        b=GmC558rWwtuEoqdu6si69MXirnb5j/9l6OJbBCYVASq9xGha/MF1VIPYTQd0v/cZjv
         nnc1LRPeBzgrtHp9p2KJQ0KCCHcHYFQJCcsdayIwk8hqVNAz5nzwk/Wg6enHceI0k6LY
         fri3xdkjDUoTu5bn/vDkCeHi5+1vrhwFSA8tO5uROcOaUHNQNe4yE7W1ovoSjObpgi0E
         bc21VqU0OOe3lQudIFpjliwfA+ahW7UEVs1euUab/Fh85HFIeR4E/0GFvxyUOMefCaW8
         YTwr1/FSkIstd/6qtUmbYwLEJg9Dha+xh8u8hUHjrQvQo2AzFrsblg6x30TZPE20XhAD
         HT7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F/FPQon1lKuEcgIBUSF5KOqSskD51ob9OwnxpY6zbaI=;
        b=KqR3OB/D8BVekqGBX2VO6AzjOD1MrUDL5I0Z8DQR3EtSchLsFUdYPzZeAn2sKPMTE/
         dWCwvoRxwW9hM/CEybxTqpnFIDTI+LKFq9vYWyD939o0exGeNUQaIgBPWN9s5Rekv6q/
         18vap0id14clLDkyDqU0KwEIwh7yrq5YP5FK3wL4iZ+srenCmfIA87Hlf6YUXz8MefeC
         l57SvRCR0+GG2+A52D3dJMkRPFFZlma1+fPvkq0hUx54AuDfaATKBnrcGbZfhwK7Bbt+
         ITKmMygq0EOhEzHaVVV6309w25trcOH4nKKpZFROwmJY11XLIHjsoziwXhP9Fba1o2Gb
         CeWQ==
X-Gm-Message-State: ACrzQf2SLk7sy60d3J6TRtMI/avL0yFs13KLcxWP8Vl2wmE4hKnSooJ/
        bb1hzkx5q25/IldWytKlDJn0ib8tgilEQYhey9UNUw==
X-Google-Smtp-Source: AMsMyM7ul/e0fRGFfXIk2+oY/aAzl97477v2/nTAApjXIMy02cZaFiF4tXcmE/kvnb9/YqLacoEH02rlpeeqg7cS4WQ=
X-Received: by 2002:a81:5a86:0:b0:36f:cece:6efd with SMTP id
 o128-20020a815a86000000b0036fcece6efdmr17186330ywb.489.1667306240709; Tue, 01
 Nov 2022 05:37:20 -0700 (PDT)
MIME-Version: 1.0
References: <20221101121552.21890-1-chenzhongjin@huawei.com>
In-Reply-To: <20221101121552.21890-1-chenzhongjin@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 1 Nov 2022 05:37:09 -0700
Message-ID: <CANn89iLU4_YpS9abdsyckJ4ZWu+jtvHH=fHnxLe0ByPJ7gh8ng@mail.gmail.com>
Subject: Re: [PATCH net] net, neigh: Fix null-ptr-deref in neigh_table_clear()
To:     Chen Zhongjin <chenzhongjin@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        dsahern@kernel.org, daniel@iogearbox.net, yangyingliang@huawei.com,
        stephen@networkplumber.org, wangyuweihx@gmail.com,
        alexander.mikhalitsyn@virtuozzo.com, den@openvz.org,
        xu.xin16@zte.com.cn
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

On Tue, Nov 1, 2022 at 5:19 AM Chen Zhongjin <chenzhongjin@huawei.com> wrote:
>
> When IPv6 module gets initialized but hits an error in the middle,
> kenel panic with:
>
> KASAN: null-ptr-deref in range [0x0000000000000598-0x000000000000059f]
> CPU: 1 PID: 361 Comm: insmod
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
> RIP: 0010:__neigh_ifdown.isra.0+0x24b/0x370
> RSP: 0018:ffff888012677908 EFLAGS: 00000202
> ...
> Call Trace:
>  <TASK>
>  neigh_table_clear+0x94/0x2d0
>  ndisc_cleanup+0x27/0x40 [ipv6]
>  inet6_init+0x21c/0x2cb [ipv6]
>  do_one_initcall+0xd3/0x4d0
>  do_init_module+0x1ae/0x670
> ...
> Kernel panic - not syncing: Fatal exception
>
> When ipv6 initialization fails, it will try to cleanup and calls:
>
> neigh_table_clear()
>   neigh_ifdown(tbl, NULL)
>     pneigh_queue_purge(&tbl->proxy_queue, dev_net(dev == NULL))
>     # dev_net(NULL) triggers null-ptr-deref.
>
> Fix it by passing NULL to pneigh_queue_purge() in neigh_ifdown() if dev
> is NULL, to make kernel not panic immediately.
>
> Fixes: 66ba215cb513 ("neigh: fix possible DoS due to net iface start/stop loop")
> Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
> ---

SGTM, thanks !

Reviewed-by: Eric Dumazet <edumazet@google.com>
