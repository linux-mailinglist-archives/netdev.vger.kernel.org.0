Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27979522EC9
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 10:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234570AbiEKIza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 04:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235786AbiEKIz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 04:55:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9E2A0232773
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 01:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652259326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H/Zc0yDwWMRNJfjVhrcU4xRq0fjTNgvVjsiQzPz7FOE=;
        b=Jhuno4dcDsF3MLLN6PtkjuO0e8PlWRm2Vr52y3dPK3Jx88CwhP1zBNkSUJgxeQ8OAdorQf
        +IvylXnnZeYu7YEeU+4Uc9p47E+FnYdytcX+bjVbfRT25vynzX694ozhEX6uVpnulYhqCZ
        gdvyyI20p7dESiqtdyJR2eawv9tdovs=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-rJ-bxYHtPxCBNV2ZCyR3Xw-1; Wed, 11 May 2022 04:55:25 -0400
X-MC-Unique: rJ-bxYHtPxCBNV2ZCyR3Xw-1
Received: by mail-io1-f72.google.com with SMTP id x13-20020a0566022c4d00b0065491fa5614so795869iov.9
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 01:55:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=H/Zc0yDwWMRNJfjVhrcU4xRq0fjTNgvVjsiQzPz7FOE=;
        b=O6E/vxFI7N9A68S6vMYDmNzFUGU7Vuu1Wa0JZ90bMsgxoRHor2tJeAVTOsVSnbrndQ
         BhMebBoCtCrArXb3X2UdYN0etulufMUXwun/F7lP/g4dPMAWoifYxWtr7tdNhPcdWY70
         9zIbkVaGiSs/+4IHFjggfcF+NaRnVUoTURzvZwSyjn4aIfBG7KKeR1yRQqUr30x5MT3r
         PMZZr7GXg/3Bw4pg2vd+7mSVE13aVBkeiw1BmWEr1U/x9a/NcI7jC2cOjEKmLrhHbvr3
         L6E16V7yXUbiTwNg7gHH1fuUY3spDDAs985In7zpT+gvxpPG2J8C4Hm0HlgRg9FMEpaO
         mW5g==
X-Gm-Message-State: AOAM532aQko+TJm723eZYl5Qq/ZU7iY2VXLV3Qq7CtEyOtNrtMf6GlGp
        SXVrK7jxySK6e1jtfLxaydKmgE/s3lVcdZqgf10xiNg445/racwwt8u+hAIrKcbeTQGouV8mNPi
        FqUWF6JXZjx1F4AyzLqBwCqN5CLUdqYMk
X-Received: by 2002:a05:6638:138d:b0:32b:9049:503e with SMTP id w13-20020a056638138d00b0032b9049503emr11559496jad.263.1652259324710;
        Wed, 11 May 2022 01:55:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyWLuYUyp3j1ipO/Zka4pOCvIB6rro/RNZZzSa/SUed+TDWv2FuLCMxCT8BiR6MVq70Ef0Lhx6K86PTPJhMLfg=
X-Received: by 2002:a05:6638:138d:b0:32b:9049:503e with SMTP id
 w13-20020a056638138d00b0032b9049503emr11559489jad.263.1652259324463; Wed, 11
 May 2022 01:55:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220510084443.14473-1-ihuguet@redhat.com> <20220510084443.14473-3-ihuguet@redhat.com>
 <20220511075220.3eut4vp33o4w4qtt@gmail.com>
In-Reply-To: <20220511075220.3eut4vp33o4w4qtt@gmail.com>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Wed, 11 May 2022 10:55:13 +0200
Message-ID: <CACT4oudgy-89mKY0LJ3CfbrZBkJSS-ayvHQSjNLWLDU4=yhz=A@mail.gmail.com>
Subject: Re: [PATCH net-next 2/5] sfc: separate channel->tx_queue and
 efx->xdp_tx_queue mappings
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        Edward Cree <ecree.xilinx@gmail.com>, ap420073@gmail.com,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 11, 2022 at 9:52 AM Martin Habets <habetsm.xilinx@gmail.com> wr=
ote:
>
> On Tue, May 10, 2022 at 10:44:40AM +0200, =C3=8D=C3=B1igo Huguet wrote:
> > Channels that contains tx queues need to determine the mapping of this
> > queue structures to hw queue numbers. This applies both to all tx
> > queues, no matter if they are normal tx queues, xdp_tx queues or both a=
t
> > the same time.
>
> In my thinking XDP-only channels are a different channel type, so it
> would be cleaner to define a separate struct efx_channel_type for those.

That would be changes far deeper than this patch series intended to
do. However, I totally agree with you, but maybe it's something better
to be included in the channels rework you're working on? I'm happy to
help on that, if possible.

>
> >
> > Also, a lookup table to map each cpu to a xdp_tx queue is created,
> > containing pointers to the xdp_tx queues, that should already be
> > allocated in one or more channels. This lookup table is global to all
> > efx_nic structure.
>
> I'm not keen on a direct CPU to queue mapping, but rather map the
> specific XDP-only channels to CPUs. Also for such a mapping there is
> XPS already. Ideally that configuration will be used.

But that mapping is not introduced by me, it already existed, and it's
used in efx_xdp_tx_buffers to have a dedicated TX queue for each CPU,
avoiding locking contention (at least when there are enough channels).

XPS is not an option here, at least not one I can think of, for 2 reasons:
1. When doing XDP_TX action, there doesn't even exist an skb, so there
is no information to be used by XPS
2. XPS create mappings to the normal TX queues, for normal traffic,
not for the XDP ones

In fact, when I sent the patches to allow using normal TX queues for
XDP if there are no free channels for XDP, I already tried to use XPS
to do the CPU mapping, and I didn't find the way to do it, because of
point 1.

I think this is because XDP is still very limited in some things,
hopefully it will improve in the future. AFAIK, all drivers are doing
the same or similar approach of one CPU mapped to one dedicated XDP_TX
queue.

>
> > Mappings to hw queues and xdp lookup table creation were done at the
> > same time in efx_set_channels, but it had a bit messy and not very clea=
r
> > code. Then, commit 059a47f1da93 ("net: sfc: add missing xdp queue
> > reinitialization") moved part of that initialization to a separate
> > function to fix a bug produced because the xdp_tx queues lookup table
> > was not reinitialized after channels reallocation, leaving it pointing
> > to deallocated queues. Not all of that initialization needs to be
> > redone, but only the xdp_tx queues lookup table, and not the mappings t=
o
> > hw queues. So this resulted in even less clear code.
> >
> > This patch moves back the part of that code that doesn't need to be
> > reinitialized. That is, the mapping of tx queues with hw queues numbers=
.
> > As a result, xdp queues lookup table creation and this are done in
> > different places, conforming to single responsibility principle and
> > resulting in more clear code.
> >
> > Signed-off-by: =C3=8D=C3=B1igo Huguet <ihuguet@redhat.com>
> > ---
> >  drivers/net/ethernet/sfc/efx_channels.c | 69 +++++++++++++------------
> >  1 file changed, 37 insertions(+), 32 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethe=
rnet/sfc/efx_channels.c
> > index 3f28f9861dfa..8feba80f0a34 100644
> > --- a/drivers/net/ethernet/sfc/efx_channels.c
> > +++ b/drivers/net/ethernet/sfc/efx_channels.c
> > @@ -767,6 +767,19 @@ void efx_remove_channels(struct efx_nic *efx)
> >       kfree(efx->xdp_tx_queues);
> >  }
> >
> > +static inline int efx_alloc_xdp_tx_queues(struct efx_nic *efx)
> > +{
> > +     if (efx->xdp_tx_queue_count) {
> > +             EFX_WARN_ON_PARANOID(efx->xdp_tx_queues);
> > +             efx->xdp_tx_queues =3D kcalloc(efx->xdp_tx_queue_count,
> > +                                          sizeof(*efx->xdp_tx_queues),
> > +                                          GFP_KERNEL);
>
> efx_set_channels() can be called multiple times. In that case
> the previous memory allocated is not freed and thus it is leaked.

This was an already existing bug, that I didn't see, but you're right
we should fix it now. I will submit it to `net`.

>
> Martin
>
> > +             if (!efx->xdp_tx_queues)
> > +                     return -ENOMEM;
> > +     }
> > +     return 0;
> > +}
> > +
> >  static int efx_set_xdp_tx_queue(struct efx_nic *efx, int xdp_queue_num=
ber,
> >                               struct efx_tx_queue *tx_queue)
> >  {
> > @@ -789,44 +802,29 @@ static void efx_set_xdp_channels(struct efx_nic *=
efx)
> >       int xdp_queue_number =3D 0;
> >       int rc;
> >
> > -     /* We need to mark which channels really have RX and TX
> > -      * queues, and adjust the TX queue numbers if we have separate
> > -      * RX-only and TX-only channels.
> > -      */
> >       efx_for_each_channel(channel, efx) {
> >               if (channel->channel < efx->tx_channel_offset)
> >                       continue;
> >
> >               if (efx_channel_is_xdp_tx(channel)) {
> >                       efx_for_each_channel_tx_queue(tx_queue, channel) =
{
> > -                             tx_queue->queue =3D next_queue++;
> >                               rc =3D efx_set_xdp_tx_queue(efx, xdp_queu=
e_number,
> >                                                         tx_queue);
> >                               if (rc =3D=3D 0)
> >                                       xdp_queue_number++;
> >                       }
> > -             } else {
> > -                     efx_for_each_channel_tx_queue(tx_queue, channel) =
{
> > -                             tx_queue->queue =3D next_queue++;
> > -                             netif_dbg(efx, drv, efx->net_dev,
> > -                                       "Channel %u TXQ %u is HW %u\n",
> > -                                       channel->channel, tx_queue->lab=
el,
> > -                                       tx_queue->queue);
> > -                     }
> > +             } else if (efx->xdp_txq_queues_mode =3D=3D EFX_XDP_TX_QUE=
UES_BORROWED) {
> >
> >                       /* If XDP is borrowing queues from net stack, it =
must
> >                        * use the queue with no csum offload, which is t=
he
> >                        * first one of the channel
> >                        * (note: tx_queue_by_type is not initialized yet=
)
> >                        */
> > -                     if (efx->xdp_txq_queues_mode =3D=3D
> > -                         EFX_XDP_TX_QUEUES_BORROWED) {
> > -                             tx_queue =3D &channel->tx_queue[0];
> > -                             rc =3D efx_set_xdp_tx_queue(efx, xdp_queu=
e_number,
> > -                                                       tx_queue);
> > -                             if (rc =3D=3D 0)
> > -                                     xdp_queue_number++;
> > -                     }
> > +                     tx_queue =3D &channel->tx_queue[0];
> > +                     rc =3D efx_set_xdp_tx_queue(efx, xdp_queue_number=
,
> > +                                               tx_queue);
> > +                     if (rc =3D=3D 0)
> > +                             xdp_queue_number++;
> >               }
> >       }
> >       WARN_ON(efx->xdp_txq_queues_mode =3D=3D EFX_XDP_TX_QUEUES_DEDICAT=
ED &&
> > @@ -952,31 +950,38 @@ int efx_realloc_channels(struct efx_nic *efx, u32=
 rxq_entries, u32 txq_entries)
> >
> >  int efx_set_channels(struct efx_nic *efx)
> >  {
> > +     struct efx_tx_queue *tx_queue;
> >       struct efx_channel *channel;
> > +     unsigned int queue_num =3D 0;
> >       int rc;
> >
> >       efx->tx_channel_offset =3D
> >               efx_separate_tx_channels ?
> >               efx->n_channels - efx->n_tx_channels : 0;
> >
> > -     if (efx->xdp_tx_queue_count) {
> > -             EFX_WARN_ON_PARANOID(efx->xdp_tx_queues);
> > -
> > -             /* Allocate array for XDP TX queue lookup. */
> > -             efx->xdp_tx_queues =3D kcalloc(efx->xdp_tx_queue_count,
> > -                                          sizeof(*efx->xdp_tx_queues),
> > -                                          GFP_KERNEL);
> > -             if (!efx->xdp_tx_queues)
> > -                     return -ENOMEM;
> > -     }
> > -
> > +     /* We need to mark which channels really have RX and TX queues, a=
nd
> > +      * adjust the TX queue numbers if we have separate RX/TX only cha=
nnels.
> > +      */
> >       efx_for_each_channel(channel, efx) {
> >               if (channel->channel < efx->n_rx_channels)
> >                       channel->rx_queue.core_index =3D channel->channel=
;
> >               else
> >                       channel->rx_queue.core_index =3D -1;
> > +
> > +             if (channel->channel >=3D efx->tx_channel_offset) {
> > +                     efx_for_each_channel_tx_queue(tx_queue, channel) =
{
> > +                             tx_queue->queue =3D queue_num++;
> > +                             netif_dbg(efx, drv, efx->net_dev,
> > +                                       "Channel %u TXQ %u is HW %u\n",
> > +                                       channel->channel, tx_queue->lab=
el,
> > +                                       tx_queue->queue);
> > +                     }
> > +             }
> >       }
> >
> > +     rc =3D efx_alloc_xdp_tx_queues(efx);
> > +     if (rc)
> > +             return rc;
> >       efx_set_xdp_channels(efx);
> >
> >       rc =3D netif_set_real_num_tx_queues(efx->net_dev, efx->n_tx_chann=
els);
> > --
> > 2.34.1
>


--=20
=C3=8D=C3=B1igo Huguet

