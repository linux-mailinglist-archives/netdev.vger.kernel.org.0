Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F37FD52923F
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 23:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348640AbiEPVBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 17:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349185AbiEPVBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 17:01:08 -0400
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD85B1CC;
        Mon, 16 May 2022 13:36:15 -0700 (PDT)
Received: by mail-vs1-xe2e.google.com with SMTP id q2so16785760vsr.5;
        Mon, 16 May 2022 13:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SPVTTEXb7GH/kRukNpd+3rAnRGbjeFyeEDAAtlIB25Q=;
        b=NSekxAUXRVu2pYaw0hTGwWaFqn/QHyOuuGWIa14VTyd85gOV8xGT6+YTJfzp2WkBp3
         UeimhWNjhZ5KL0QlzfydQy+0WXY7c7AIZYYeKKvOuaDOOktdY3EpLLbIAFQP6Fj4u9QR
         v5zVi6prxpCEuv+KArfXza5lhW8bM/Mc6U+n8FXiUizhYlMeZiGNP5vOQyw23rQpLsVh
         O4wrjiZnAcOrcDWVUQnU5oBcmUMIMlJAdqVLjMP7ROLXrp9Ni95AVYRVrJYTecuNqPYz
         saKTifld2dgNmTzpXxcxgLhpNG+9HzYb9G2/V6FVymeX/1yGcDVhC42bns9u+jLm/LbT
         wBXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SPVTTEXb7GH/kRukNpd+3rAnRGbjeFyeEDAAtlIB25Q=;
        b=UFCc2PPk0eQBbM9dhSDQPw4Ld+0aaE+jO7GLX8Ky0RLus4RV7l6eoTiNsm1MZL/ZrA
         isa0U4jKwN/vrI+P9ZMenUvfefWAGMV2x3Fhbcb8qLkwYyy6C0Pd+qTLk6ZB1JIEkHHO
         SDVhaNgozwyfMwOPsKUzLmrQxxgWZsek2QpXPmvc0UVJs2uD3uM+2FQN6ySxV093EyAJ
         26ZjTwMfMKGdkXyFuyBI8/KJylCMn6xJhJosezK/MFAqWhNem9zJ+zLbKt1zcGO/Ny9I
         CytsshxzmztuQnF7L2Lzjm5sR/782Ts3dpcqkzV3QVIW+2B7g/IFN2SzBWapTI2apE9R
         eLNg==
X-Gm-Message-State: AOAM5323rpzhRTWTBQ2N/g+e2cfMkl2gwtl4alCEnkk3dMdKLi+ZDxCM
        G6JZVbkKNgvo4BUV3qetMthQYogjcSOuE03GGkc=
X-Google-Smtp-Source: ABdhPJylvA9O4m7fxtbFb+lkV8pNOJlx1/RRasLF3i25sl6FooKaRcWZritDMSN+ehL0yvKawivRUzI0CFpOVj/+vwo=
X-Received: by 2002:a67:2ec4:0:b0:32c:c442:a309 with SMTP id
 u187-20020a672ec4000000b0032cc442a309mr6741450vsu.32.1652733375162; Mon, 16
 May 2022 13:36:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220514091443.4150162-1-william.xuanziyang@huawei.com>
In-Reply-To: <20220514091443.4150162-1-william.xuanziyang@huawei.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Mon, 16 May 2022 23:36:04 +0300
Message-ID: <CAHNKnsS0D8bRA5GY0xss2ZUCwY2HoLNMgeR0K4ecH-HfmdTefg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: wwan: t7xx: fix GFP_KERNEL usage in
 spin_lock context
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     "Devegowda, Chandrashekar" <chandrashekar.devegowda@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Ziyang,

On Sat, May 14, 2022 at 11:57 AM Ziyang Xuan
<william.xuanziyang@huawei.com> wrote:
> t7xx_cldma_clear_rxq() call t7xx_cldma_alloc_and_map_skb() in spin_lock
> context, But __dev_alloc_skb() in t7xx_cldma_alloc_and_map_skb() uses
> GFP_KERNEL, that will introduce scheduling factor in spin_lock context.
>
> Replace GFP_KERNEL with GFP_ATOMIC to fix it.

Would not it will be more reliable to just rework
t7xx_cldma_clear_rxq() to avoid calling t7xx_cldma_alloc_and_map_skb()
under the spin lock instead of doing each allocation with GFP_ATOMIC?
E.g. t7xx_cldma_gpd_rx_from_q() calls t7xx_cldma_alloc_and_map_skb()
avoiding any lock holding.

-- 
Sergey
