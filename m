Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2BF46AC5F8
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 16:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbjCFPy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 10:54:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbjCFPyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 10:54:52 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9950823669
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 07:54:51 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id i3so10858103plg.6
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 07:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678118091;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fwi1418DCU1aNlQXYZlvl6WuH58XKZr+tHXuV1t3v/M=;
        b=J/DVmtfqlx2xg3c1f3HyAUH6IVHwspoCUzN5Q+40H1OjWiad0eRFcH6UA+6t0WaG1t
         cELL5Rx+P8fMr0C2YzpNQFmFp6yHI7+09krRHQRcE8+Ahzmrvr2SB6hdgWhE0/UA/bBK
         N/Mhtr+trb4dQNJzQiZEPzgd5n3XDMu3wqoy6BjOHW0RXXBgyhS9EmLCSa6gQkFM+jvE
         3e8unVQTwNIty7ndJYTDwux+T7QOjVJfPiP8FB8q68SiWEmp0jlzB69uHZezGxnwer+p
         opJAoLP9GOgAPtXEyE6jpqiolvw3AIC8X3Axp7b44AbAf24PWgR5XsTdvZo89nPOhkhJ
         sW7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678118091;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fwi1418DCU1aNlQXYZlvl6WuH58XKZr+tHXuV1t3v/M=;
        b=PNuWSoHpWAc0yLb3E7ArCE28QGCSCqUShykcfyyF1I7Pli5oX8OeuVNQpOetZkqAa5
         x07JbG4RHdP0xuH9pUOlDnmhf5Lp6+Dus6EsZoKjoBr7FmIo11hE69ljRRdCYvw7d9v3
         NCaNJszrIeZiqeInb2J23KDzD9ZiuQCjPbBLmJp2OfZj86lmGsMsKBXXM+zMQViLW2rd
         ov24+ILKXS1CXpe3002ifP7u/1jQPwyo7sgSSTWnIAGGqRxHdfGimV2J8e7EA1MYb+eH
         OY5OUzI2o0RO9RyoO4eDdF03pkF7slhVyrZfxiV2p2ZAnoxBxDo5xwKxYJ8mzHIDWP46
         W/mg==
X-Gm-Message-State: AO0yUKUVHBTR0Js4XZg54NrCaqmfuupe3A4RMSJBhpgjbldKdDjLhR+H
        wRfm2v+Hve5f0BunPUSZfSac8H0Fi14=
X-Google-Smtp-Source: AK7set82kw7rSI3WEGiHKn17gt+67eGeNEfXJtibFa4nAAk5074RaJB8DQmfoeVZe9stGTUal5X60g==
X-Received: by 2002:a17:902:d2d0:b0:19a:a520:b203 with SMTP id n16-20020a170902d2d000b0019aa520b203mr15317399plc.25.1678118090881;
        Mon, 06 Mar 2023 07:54:50 -0800 (PST)
Received: from [192.168.0.128] ([98.97.39.127])
        by smtp.googlemail.com with ESMTPSA id p16-20020a170902ebd000b001994e74c094sm6899540plg.275.2023.03.06.07.54.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 07:54:50 -0800 (PST)
Message-ID: <4dfe231890d9b29f90d90f98d0898dcd7910f25a.camel@gmail.com>
Subject: Re: [PATCH net v7 1/2] net/ps3_gelic_net: Fix RX sk_buff length
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Geoff Levand <geoff@infradead.org>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Paolo Abeni <pabeni@redhat.com>
Date:   Mon, 06 Mar 2023 07:54:48 -0800
In-Reply-To: <22d742b4e7d11ff48e8c40e39db3c776e495abe2.1677981671.git.geoff@infradead.org>
References: <cover.1677981671.git.geoff@infradead.org>
         <22d742b4e7d11ff48e8c40e39db3c776e495abe2.1677981671.git.geoff@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2023-03-05 at 02:08 +0000, Geoff Levand wrote:
> The Gelic Ethernet device needs to have the RX sk_buffs aligned to
> GELIC_NET_RXBUF_ALIGN, and also the length of the RX sk_buffs must
> be a multiple of GELIC_NET_RXBUF_ALIGN.
>=20
> The current Gelic Ethernet driver was not allocating sk_buffs large
> enough to allow for this alignment.
>=20
> Also, correct the maximum and minimum MTU sizes, and add a new
> preprocessor macro for the maximum frame size, GELIC_NET_MAX_FRAME.
>=20
> Fixes various randomly occurring runtime network errors.
>=20
> Fixes: 02c1889166b4 ("ps3: gigabit ethernet driver for PS3, take3")
> Signed-off-by: Geoff Levand <geoff@infradead.org>
> ---
>  drivers/net/ethernet/toshiba/ps3_gelic_net.c | 10 ++++++----
>  drivers/net/ethernet/toshiba/ps3_gelic_net.h |  5 +++--
>  2 files changed, 9 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/e=
thernet/toshiba/ps3_gelic_net.c
> index cf8de8a7a8a1..b0ebe0e603b4 100644
> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> @@ -375,11 +375,13 @@ static int gelic_descr_prepare_rx(struct gelic_card=
 *card,
>  	if (gelic_descr_get_status(descr) !=3D  GELIC_DESCR_DMA_NOT_IN_USE)
>  		dev_info(ctodev(card), "%s: ERROR status\n", __func__);
>  	/* we need to round up the buffer size to a multiple of 128 */
> -	bufsize =3D ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN);
> +	bufsize =3D (GELIC_NET_MAX_FRAME + GELIC_NET_RXBUF_ALIGN - 1) &
> +		(~(GELIC_NET_RXBUF_ALIGN - 1));

Why did you stop using ALIGN? What you coded looks exactly like what
the code for ALIGN does. From what I can tell you just need to replace
GELIC_NET_MAX_MTU with GELIC_NET_MAX_FRAME.

> =20
>  	/* and we need to have it 128 byte aligned, therefore we allocate a
>  	 * bit more */
> -	descr->skb =3D dev_alloc_skb(bufsize + GELIC_NET_RXBUF_ALIGN - 1);
> +	descr->skb =3D netdev_alloc_skb(*card->netdev, bufsize +
> +		GELIC_NET_RXBUF_ALIGN - 1);

This wrapping doesn't look right to me. Also why add the align value
again here? I would think that it being added above should have taken
care of what you needed. Are you adding any data beyond the end of what
is DMAed into the frame?

>  	if (!descr->skb) {
>  		descr->buf_addr =3D 0; /* tell DMAC don't touch memory */
>  		return -ENOMEM;
> @@ -397,7 +399,7 @@ static int gelic_descr_prepare_rx(struct gelic_card *=
card,
>  	/* io-mmu-map the skb */
>  	descr->buf_addr =3D cpu_to_be32(dma_map_single(ctodev(card),
>  						     descr->skb->data,
> -						     GELIC_NET_MAX_MTU,
> +						     GELIC_NET_MAX_FRAME,
>  						     DMA_FROM_DEVICE));

Rather than using the define GELIC_NET_MAX_FRAME, why not just use
bufsize since that is what you actually have allocated for receive?

>  	if (!descr->buf_addr) {
>  		dev_kfree_skb_any(descr->skb);
> @@ -915,7 +917,7 @@ static void gelic_net_pass_skb_up(struct gelic_descr =
*descr,
>  	data_error =3D be32_to_cpu(descr->data_error);
>  	/* unmap skb buffer */
>  	dma_unmap_single(ctodev(card), be32_to_cpu(descr->buf_addr),
> -			 GELIC_NET_MAX_MTU,
> +			 GELIC_NET_MAX_FRAME,
>  			 DMA_FROM_DEVICE);

I suppose my suggestion above would cause a problem here since you
would need to also define buffer size here. However since it looks like
you are adding a define below anyway maybe you should just look at
adding a new RX_BUFSZ define and just drop bufsize completely.

> =20
>  	skb_put(skb, be32_to_cpu(descr->valid_size)?
> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.h b/drivers/net/e=
thernet/toshiba/ps3_gelic_net.h
> index 68f324ed4eaf..0d98defb011e 100644
> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.h
> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.h
> @@ -19,8 +19,9 @@
>  #define GELIC_NET_RX_DESCRIPTORS        128 /* num of descriptors */
>  #define GELIC_NET_TX_DESCRIPTORS        128 /* num of descriptors */
> =20
> -#define GELIC_NET_MAX_MTU               VLAN_ETH_FRAME_LEN
> -#define GELIC_NET_MIN_MTU               VLAN_ETH_ZLEN
> +#define GELIC_NET_MAX_FRAME             2312
> +#define GELIC_NET_MAX_MTU               2294
> +#define GELIC_NET_MIN_MTU               64
>  #define GELIC_NET_RXBUF_ALIGN           128
>  #define GELIC_CARD_RX_CSUM_DEFAULT      1 /* hw chksum */
>  #define GELIC_NET_WATCHDOG_TIMEOUT      5*HZ

Since you are adding defines why not just add:
#define GELIC_NET_RX_BUFSZ \
	ALIGN(GELIC_NET_MAX_FRAME, GELIC_NET_RXBUF_ALIGN)
