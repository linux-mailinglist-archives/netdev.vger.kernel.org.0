Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 091B353CE08
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 19:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344451AbiFCRZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 13:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344444AbiFCRZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 13:25:30 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96885527FE
        for <netdev@vger.kernel.org>; Fri,  3 Jun 2022 10:25:28 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id i11so14862913ybq.9
        for <netdev@vger.kernel.org>; Fri, 03 Jun 2022 10:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9d7m1DB2JYorAFcfrJRCyYngv/Ipyhp23NdS37Fbtxg=;
        b=URVQb1JkqaW1ZxUmYQ5sQlIodWx8/3heQ74G3ifWb6OpIziXlv8ER/kur16b8WoQp4
         Lc75UyQ3wEz6iiXKQ8UhcNPavNi5XJQbcreWYMbvM5B1SvdDeRX2QhDybf7QiVx3ovoa
         P9UtVL9f2yrR7ABjofsD/R/Wawv52H4VhdVBY2dYjjOPRr2oet+wr58sqTAgUHoYjoUb
         QpvYsttsm2TqMFvOve3llhXgR+a3j2q2nJMOxhNJOScXi11csrk7F00sVwfpQAJ//JqB
         un16nZdFbn+rv+2qfdYf+R1Xsx8fbDZo0yOXaVS9L05xFbaYKY8IaFxLUs5lR0uGl7zz
         ZZhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9d7m1DB2JYorAFcfrJRCyYngv/Ipyhp23NdS37Fbtxg=;
        b=D9cpWrEeGBVZkSYXy85Vi498VixDapgK2+Zg4HzVn24YV2w03+D+wAHvL5tEwvrAKD
         kxNzgHa3wFj4mElh3P6rzyevMJu1mSt1ZmykaVfte4CqU3gMQzAY92e3BZO5T7JbgafG
         /M5JtREz3qEISL9iKMyOL0t+JkOQTzzgzw8sfCUC53iovExYNCh01n2aGQfM3OAE2RD/
         Yh+9j//OtxO5e1P0b4ijsOyJ0SU3sE2lLbE7Q5UCHekGvJHBtV9OuiPPGCTv/4E3cxxE
         KccnGRFUs57gE4Ntge2wtk7QLDscfeMfjFiWcQa2yTren++Zfw1v4vUO2neQM2BsbVHR
         HRLw==
X-Gm-Message-State: AOAM531kJEh/qTl5R3JrZnR0nzEusHkQBUQ/wOg9XtLMo/z9nk6Mirti
        Aty1fZkS6GlHmm/2T1bJ+NB9Y86PNs6Pmf1VddU4Eg==
X-Google-Smtp-Source: ABdhPJxf9t98itOGujrgic0ySJOm8xg1lh3ELD9RztTvYghZn9PWg0G/2n3G5/cLA3+ZqRARoLBWHk2qXYPDrLAVE04=
X-Received: by 2002:a25:aa32:0:b0:65c:af6a:3502 with SMTP id
 s47-20020a25aa32000000b0065caf6a3502mr12290545ybi.598.1654277127473; Fri, 03
 Jun 2022 10:25:27 -0700 (PDT)
MIME-Version: 1.0
References: <2997c5b0-3611-5e00-466c-b2966f09f067@nbd.name> <1654245968-8067-1-git-send-email-chen45464546@163.com>
In-Reply-To: <1654245968-8067-1-git-send-email-chen45464546@163.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 3 Jun 2022 10:25:16 -0700
Message-ID: <CANn89iKiyh36ULH4PCXF4c8sBdh9WLksMoMcmQwipZYWCzBkMA@mail.gmail.com>
Subject: Re: [PATCH v2] net: ethernet: mtk_eth_soc: fix misuse of mem alloc
 interface netdev[napi]_alloc_frag
To:     Chen Lin <chen45464546@163.com>
Cc:     Felix Fietkau <nbd@nbd.name>, Jakub Kicinski <kuba@kernel.org>,
        john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-mediatek@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 3, 2022 at 1:46 AM Chen Lin <chen45464546@163.com> wrote:
>
> When rx_flag == MTK_RX_FLAGS_HWLRO,
> rx_data_len = MTK_MAX_LRO_RX_LENGTH(4096 * 3) > PAGE_SIZE.
> netdev_alloc_frag is for alloction of page fragment only.
> Reference to other drivers and Documentation/vm/page_frags.rst
>
> Branch to use alloc_pages when ring->frag_size > PAGE_SIZE.
>
> Signed-off-by: Chen Lin <chen45464546@163.com>

...

>                         goto release_desc;
> @@ -1914,7 +1923,16 @@ static int mtk_rx_alloc(struct mtk_eth *eth, int ring_no, int rx_flag)
>                 return -ENOMEM;
>
>         for (i = 0; i < rx_dma_size; i++) {
> -               ring->data[i] = netdev_alloc_frag(ring->frag_size);

Note aside, calling netdev_alloc_frag() in a loop like that is adding
GFP_ATOMIC pressure.

mtk_rx_alloc() being in process context, using GFP_KERNEL allocations
would be less aggressive and
have more chances to succeed.

We probably should offer a generic helper. This could be used from
driver/net/tun.c and others.
