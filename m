Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA4266C3453
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 15:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbjCUOeO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 Mar 2023 10:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbjCUOeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 10:34:12 -0400
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A026234C37;
        Tue, 21 Mar 2023 07:34:10 -0700 (PDT)
Received: by mail-qt1-f180.google.com with SMTP id c19so18032763qtn.13;
        Tue, 21 Mar 2023 07:34:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679409249;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=82nUopC4peey5GRVSgLUYvMNsOkr6qqSP8KaXHFDorM=;
        b=povKLd2VWRVnfXIwc/JvHyhRXfzbpRCOXWz67h8TEE5Uo0h4oNBXibBzJ6PeVozRr+
         fHcX8sms7zpFFHqgmpDKefq2LWbHhz1CyIdEDROvMdN0qNdLPSWkGNn3XsGpPc5Oi7wr
         f/O5Ygrlvm6qveC1eM2cGjYPk0A51N6OeH18ni8VAg3fOyN+0y7Ftdiu/qlc5Z8rtbsk
         LahV5+8Buc5MSXRWfvyZ/BTi8I7JgsVuMH6cw+pt4OZVaA6UzIKkn/r1kLpJ6iO2a/lW
         BxTKL2AaIlxC3Yt5WmrvXjB2hrkAKdoe85JW0lG8PRmLtjZNmPOmiS6kbFU+/FZFy3Sj
         YuWw==
X-Gm-Message-State: AO0yUKX3h9t3ijewGqWdPFiNuwD9ziWZnv3aChd1yKL4JzXXWoYfeI+5
        EL5hEGpD4DhypPIhtfo/aqKxV0VB9xV2ow==
X-Google-Smtp-Source: AK7set/hopW2XtMSTKOZpioG6ZIh22UttanvDRwjaBRMfHIzwA+U9NwjPFxbIoC6/7OHeNe0wZQmdw==
X-Received: by 2002:ac8:5c93:0:b0:3bf:c5ce:127a with SMTP id r19-20020ac85c93000000b003bfc5ce127amr236294qta.4.1679409248911;
        Tue, 21 Mar 2023 07:34:08 -0700 (PDT)
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com. [209.85.219.179])
        by smtp.gmail.com with ESMTPSA id b14-20020a05620a270e00b0073b7f2a0bcbsm9589445qkp.36.2023.03.21.07.34.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 07:34:08 -0700 (PDT)
Received: by mail-yb1-f179.google.com with SMTP id e194so17365122ybf.1;
        Tue, 21 Mar 2023 07:34:08 -0700 (PDT)
X-Received: by 2002:a05:6902:1023:b0:b6b:841a:aae4 with SMTP id
 x3-20020a056902102300b00b6b841aaae4mr1264687ybt.12.1679409248087; Tue, 21 Mar
 2023 07:34:08 -0700 (PDT)
MIME-Version: 1.0
References: <20230321065826.2044-1-wsa+renesas@sang-engineering.com>
In-Reply-To: <20230321065826.2044-1-wsa+renesas@sang-engineering.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 21 Mar 2023 15:33:56 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWts4ixT87hK=GcOODQVkfgCqjp+dML0cAxPnXkfnsCpg@mail.gmail.com>
Message-ID: <CAMuHMdWts4ixT87hK=GcOODQVkfgCqjp+dML0cAxPnXkfnsCpg@mail.gmail.com>
Subject: Re: [PATCH net-next] sh_eth: remove open coded netif_running()
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 7:58 AM Wolfram Sang
<wsa+renesas@sang-engineering.com> wrote:
> It had a purpose back in the days, but today we have a handy helper.
>
> Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

No regressions seen on R-Car M2-W, RZ/A1H, and RZ/A2M.
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
