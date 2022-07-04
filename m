Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4154B564F99
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 10:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbiGDITL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 04:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbiGDITK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 04:19:10 -0400
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34AD610D5;
        Mon,  4 Jul 2022 01:19:10 -0700 (PDT)
Received: by mail-qt1-f170.google.com with SMTP id k14so8952060qtm.3;
        Mon, 04 Jul 2022 01:19:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zi8r/YyJrX221lHUygqNioMHh/LMEMN8PQ9I9UU/NIo=;
        b=HHO6DoRJ9wg5doubghhvyfobzYDsCgNQkAb9y0ZX0FJ3TaT9BADopaihFAe7X6dq+3
         emg0t+PDcS7MAtU1HeM9QvVCe4WjokhS7ChGA0GQLPMXdHKIGCHmwq+xPTs+mjHwvSHX
         0qsS0568DHL+MitxE3GRbAR8rLNRO4AvqIoXzFejvW7TNlyLHUjxQ9+221RukKsOE9/g
         f7cS8J7Q8aEgCBKN3B9VpepQBaHfd9YOgF4UwJPKOvbDVZ1ETFPttiuNg0ggOmW18HDs
         0iMX58ldEq+eUdJxkxyLigoK5Qkwr9pNIbXCXAZ/yZokqY05MlePCLcreMSTZOxXKxdb
         VJjw==
X-Gm-Message-State: AJIora951xLju4Ld4pMTcqq+4gC3kxq/03YeuLO6LXUzsuhlv0l77dRM
        YmsM506Cz02pFBjGoe8HF6tAy4leIn4UqA==
X-Google-Smtp-Source: AGRyM1sSMlyU3jyJAHF7KeQUfqr/pVF0lnW9CKLcY0U+BZvpPoWbTO7oRL2ZZY9B/1Kh1jhYfiN84g==
X-Received: by 2002:a05:6214:3016:b0:470:5291:8e9e with SMTP id ke22-20020a056214301600b0047052918e9emr27715887qvb.19.1656922745783;
        Mon, 04 Jul 2022 01:19:05 -0700 (PDT)
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com. [209.85.219.169])
        by smtp.gmail.com with ESMTPSA id q11-20020a05620a0d8b00b006a32bf19502sm23659463qkl.60.2022.07.04.01.19.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jul 2022 01:19:04 -0700 (PDT)
Received: by mail-yb1-f169.google.com with SMTP id j7so9214425ybj.10;
        Mon, 04 Jul 2022 01:19:03 -0700 (PDT)
X-Received: by 2002:a25:2b48:0:b0:668:3b7d:326c with SMTP id
 r69-20020a252b48000000b006683b7d326cmr29174435ybr.380.1656922742806; Mon, 04
 Jul 2022 01:19:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220704074611.957191-1-yoshihiro.shimoda.uh@renesas.com>
In-Reply-To: <20220704074611.957191-1-yoshihiro.shimoda.uh@renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 4 Jul 2022 10:18:48 +0200
X-Gmail-Original-Message-ID: <CAMuHMdUG-hBSb7GXXnM8P-VvgKr_GVRc8Cejp=pxLw-KFrpAEQ@mail.gmail.com>
Message-ID: <CAMuHMdUG-hBSb7GXXnM8P-VvgKr_GVRc8Cejp=pxLw-KFrpAEQ@mail.gmail.com>
Subject: Re: [PATCH] can: rcar_canfd: Fix data transmission failed on R-Car V3U
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Duy Nguyen <duy.nguyen.rh@renesas.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 4, 2022 at 9:49 AM Yoshihiro Shimoda
<yoshihiro.shimoda.uh@renesas.com> wrote:
> From: Duy Nguyen <duy.nguyen.rh@renesas.com>
>
> On R-Car V3U, this driver should use suitable register offset instead of
> other SoCs' one. Otherwise, data transmission failed on R-Car V3U.
>
> Fixes: 45721c406dcf ("can: rcar_canfd: Add support for r8a779a0 SoC")
> Signed-off-by: Duy Nguyen <duy.nguyen.rh@renesas.com>
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
