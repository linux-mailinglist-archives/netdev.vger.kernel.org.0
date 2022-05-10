Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50414521B4E
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 16:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245521AbiEJOKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 10:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343872AbiEJOHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 10:07:17 -0400
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C0E31157F7;
        Tue, 10 May 2022 06:41:19 -0700 (PDT)
Received: by mail-wr1-f48.google.com with SMTP id b19so23867014wrh.11;
        Tue, 10 May 2022 06:41:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ETH0SXQwXqTw7S/Rt3mpUjs/svhKnIJybMWlENZs/nk=;
        b=W/aTyxriX/AFi1WA1W/ReMB7iksCkA8NLGBwdaBf+72UciSNQvK1W2XOesDUt7lQcF
         pALoanvrfBLaDgBMNs+um+z9TQzUgIuUNodOvsToU45SRyiWtcglZMiCuqySECo+Ztif
         glZzYVTxzZDTz95HlFhnGSwR18jVRL79PeNp9HV1Oh3j3QYv9nk1MCxpI//RsNdgtTCN
         r9K3i5mXjq/TIuGDOjappSM610R3RoIKaFIh6S51xF1Xf3ejcEmzgIC5BJ2EIAO2AtbP
         6a/Us2gUkIaUQSdgP9tWiUS+uWZnHnh5YIjRwQvjkB90WWibhir2pULHDEGOGblygnGB
         nyqg==
X-Gm-Message-State: AOAM531Mqa8/Sm6N2IiIFuq0jrvlJQahJyVC/kg81JML5E9csfIXc79O
        8fPEtM0Z0BQd5vEZe7gCXm5e4Ws4tN9JFhMtf3M=
X-Google-Smtp-Source: ABdhPJzra9WRGXGAomB0wHN9mnXi2nAqWwwlTmykLLgn0+W9K0qUWbej5QepKdDxwpiRha8RA3ftHLjtNChLpUbS7As=
X-Received: by 2002:adf:d213:0:b0:20a:d703:154f with SMTP id
 j19-20020adfd213000000b0020ad703154fmr19112799wrh.604.1652190078045; Tue, 10
 May 2022 06:41:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220509121513.30549-1-harini.katakam@xilinx.com> <21ee77073341cd2b5e0109be5da61d8e981ea50d.camel@redhat.com>
In-Reply-To: <21ee77073341cd2b5e0109be5da61d8e981ea50d.camel@redhat.com>
From:   Harini Katakam <harinik@xilinx.com>
Date:   Tue, 10 May 2022 19:11:06 +0530
Message-ID: <CAFcVECKRpfuaJiBU8bXveHh3ukzgkSh6Q2s0WhRA0RoT+jSg4Q@mail.gmail.com>
Subject: Re: [PATCH] net: macb: Disable macb pad and fcs for fragmented packets
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Harini Katakam <harini.katakam@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        David Miller <davem@davemloft.net>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>, dumazet@google.com,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paolo,

On Tue, May 10, 2022 at 6:48 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Mon, 2022-05-09 at 17:45 +0530, Harini Katakam wrote:
> > data_len in skbuff represents bytes resident in fragment lists or
> > unmapped page buffers. For such packets, when data_len is non-zero,
> > skb_put cannot be used - this will throw a kernel bug. Hence do not
> > use macb_pad_and_fcs for such fragments.
> >
> > Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
> > Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> > Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
>
> This looks like a fix suitable for the net tree. Please add a relevant
> 'Fixes' tag.
>
> > ---
> >  drivers/net/ethernet/cadence/macb_main.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> > index 6434e74c04f1..0b03305ad6a0 100644
> > --- a/drivers/net/ethernet/cadence/macb_main.c
> > +++ b/drivers/net/ethernet/cadence/macb_main.c
> > @@ -1995,7 +1995,8 @@ static unsigned int macb_tx_map(struct macb *bp,
> >                       ctrl |= MACB_BF(TX_LSO, lso_ctrl);
> >                       ctrl |= MACB_BF(TX_TCP_SEQ_SRC, seq_ctrl);
> >                       if ((bp->dev->features & NETIF_F_HW_CSUM) &&
> > -                         skb->ip_summed != CHECKSUM_PARTIAL && !lso_ctrl)
> > +                         skb->ip_summed != CHECKSUM_PARTIAL && !lso_ctrl &&
> > +                         (skb->data_len == 0))
> >                               ctrl |= MACB_BIT(TX_NOCRC);
> >               } else
> >                       /* Only set MSS/MFS on payload descriptors
>
> This chunk looks unrelated to the commit message ?!? only the next one
> looks relevant.

Thanks for the review. This code is related to the commit message.
macb_pad_and_fcs is performed on the same packets on which
TX_NOCRC is set (instruct HW not to perform CRC and perform
CRC in SW). This is the patch which added both:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/drivers/net/ethernet/cadence?id=653e92a9175ea7ed67efe209c725222051a3713d
I'll mention the same in Fixes tag and also add Claudiu's review tag.

Regards,
Harini
