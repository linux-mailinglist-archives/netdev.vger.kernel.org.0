Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7706424E5
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 09:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232169AbiLEInm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 03:43:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232167AbiLEIng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 03:43:36 -0500
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 532CF6305;
        Mon,  5 Dec 2022 00:43:35 -0800 (PST)
Received: by mail-qt1-f180.google.com with SMTP id r19so10927621qtx.6;
        Mon, 05 Dec 2022 00:43:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TBMfq/T9pVt74NINWFPN13PsYwGHM/ql2acng2MzNpk=;
        b=XLPwdPgWvFFoFQN+IzToIE+Rp+PBxH/j3QeCEWWNPdY1UmiHjMuAPOk1cCBIOUo/92
         KEZ0nyYJijwYDRCkFphkit/6vh7Ed5uApsdp6x8XNq0TnJc8QH4JYiHoTQ5f4E68nso2
         wurDT/2KgY0NhLOFCfN3una6P+FYxLUdxoPXGPXY1xFbfNiVMZHZ/4/5CdkyBCO/ouSo
         dLvz9c7NIAIHCp577lDKyfrxYVGEY7WA5pP2UU38lLotA4m3ItbzIRh6e3w8VJgdWhJc
         28n30M/sQlXTQDtyVm61pIsyiYlNwMdwlRZ1zx6IPxs3OTVyecHCo2nw38AH0VNiK59F
         TInA==
X-Gm-Message-State: ANoB5pn2tAvVakXuEDo+3ajWep8eO9HLlhUrofqCuGY6dIyZgrT05xZB
        so3eEiYazjlfVekFTUs6nObcTCQXqYA0AA==
X-Google-Smtp-Source: AA0mqf7LljSCKLMpTtLeL1eI9+y7kuEj12tHYQC/QBTSLfMrgoTGoYRyUB+qr1CPxH4lrMtXVsPKvA==
X-Received: by 2002:ac8:1183:0:b0:3a5:8517:c3f3 with SMTP id d3-20020ac81183000000b003a58517c3f3mr74725249qtj.618.1670229813895;
        Mon, 05 Dec 2022 00:43:33 -0800 (PST)
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com. [209.85.128.173])
        by smtp.gmail.com with ESMTPSA id bs17-20020a05620a471100b006bbc3724affsm12123722qkb.45.2022.12.05.00.43.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 00:43:33 -0800 (PST)
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-3b5d9050e48so110914357b3.2;
        Mon, 05 Dec 2022 00:43:33 -0800 (PST)
X-Received: by 2002:a81:148c:0:b0:3e5:f2ca:7be8 with SMTP id
 134-20020a81148c000000b003e5f2ca7be8mr7694852ywu.358.1670229812835; Mon, 05
 Dec 2022 00:43:32 -0800 (PST)
MIME-Version: 1.0
References: <20221203092941.10880-1-yuehaibing@huawei.com> <OS0PR01MB592214C639E060C5AD3A67BF86169@OS0PR01MB5922.jpnprd01.prod.outlook.com>
In-Reply-To: <OS0PR01MB592214C639E060C5AD3A67BF86169@OS0PR01MB5922.jpnprd01.prod.outlook.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 5 Dec 2022 09:43:20 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXs1jNgOD4u2ncW81rfxC7xb1+hc3N2VH_Gom8f9zB+vw@mail.gmail.com>
Message-ID: <CAMuHMdXs1jNgOD4u2ncW81rfxC7xb1+hc3N2VH_Gom8f9zB+vw@mail.gmail.com>
Subject: Re: [PATCH net] ravb: Fix potential use-after-free in ravb_rx_gbeth()
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     YueHaibing <yuehaibing@huawei.com>,
        "s.shtylyov@omp.ru" <s.shtylyov@omp.ru>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "phil.edworthy@renesas.com" <phil.edworthy@renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Biju,

On Sat, Dec 3, 2022 at 11:29 AM Biju Das <biju.das.jz@bp.renesas.com> wrote:
> > Subject: [PATCH net] ravb: Fix potential use-after-free in
> > ravb_rx_gbeth()
> >
> > The skb is delivered to napi_gro_receive() which may free it, after
> > calling this, dereferencing skb may trigger use-after-free.
>
> Can you please reconfirm the changes you have done is actually fixing any issue?
> If yes, please provide the details.
>
> Current code,
>
> napi_gro_receive(&priv->napi[q], priv->rx_1st_skb);

IIUIC, after this, priv->rx_1st_skb may have been freed...

>
> - stats->rx_bytes += priv->rx_1st_skb->len;

... so accessing priv->rx_1st_skb->len here may be a UAF.

> + stats->rx_bytes += pkt_len;

So this change looks correct to me, as pkt_len was stored to
priv->rx_1st_skb->len using skb_put() before.

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

>
> Note: I haven't tested your patch yet to see it cause any regression.
>
> Cheers,
> Biju
>
> >
> > Fixes: 1c59eb678cbd ("ravb: Fillup ravb_rx_gbeth() stub")
> > Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> > ---
> >  drivers/net/ethernet/renesas/ravb_main.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/renesas/ravb_main.c
> > b/drivers/net/ethernet/renesas/ravb_main.c
> > index 6bc923326268..33f723a9f471 100644
> > --- a/drivers/net/ethernet/renesas/ravb_main.c
> > +++ b/drivers/net/ethernet/renesas/ravb_main.c
> > @@ -841,7 +841,7 @@ static bool ravb_rx_gbeth(struct net_device *ndev,
> > int *quota, int q)
> >                               napi_gro_receive(&priv->napi[q],
> >                                                priv->rx_1st_skb);
> >                               stats->rx_packets++;
> > -                             stats->rx_bytes += priv->rx_1st_skb->len;
> > +                             stats->rx_bytes += pkt_len;
> >                               break;
> >                       }
> >               }

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
