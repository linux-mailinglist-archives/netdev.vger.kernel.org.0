Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6EF96B6181
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 23:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbjCKWhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 17:37:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbjCKWhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 17:37:05 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C97186C6B1
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 14:37:03 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id u5so9210481plq.7
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 14:37:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678574223;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SYLtAvS71e9DHRZ1YQA8wj6OoQkLOOK2heLI6XLCAs8=;
        b=n8l1vjJQj9erKBjQnBYSL+MjW7sIKwLjFT9LFk0jjJWMsXHtra0Zc38Tao1weW9pNy
         ObMbL06DC99jiQ1qnPdhLf1+5FtWDnKCiWFdWe4UruUiXG84v5+0vNaq67coIz3xA3Nu
         NFUxOVVWCq65idLNRhyOSWOrwcN/RWqeUMYVj+eSs35ndyGWL0amVGRAnu78PjAqZ9We
         M37OVGI1JkPOTy3poZBZYOoxblVOFW12grnUZxxKdL1+tiVxW6qOonPDql78/clPwg33
         PDYXjwGUAcScWtrwODoTKwRJ5VTFo4rkuu+mCVAsjOs+N7f0J4UegPeFhN+i0OJSiVQY
         HdCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678574223;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SYLtAvS71e9DHRZ1YQA8wj6OoQkLOOK2heLI6XLCAs8=;
        b=BDc9ze8vbWT60U4F9LeF8+2uzSz4nOePQUunYZtX/bFVO7u5Ve9z7N+sviCo4mcrEt
         kHw1rOj3kwvdvAUubyj4S9l7v0ypt6djeoQSl0lE5h6Ggo5yLXXUpUzlb/5BmsqSyyuF
         9SsHNhXYlfqank1avJWMyQ/fmMC6f4guCTllpXLz5ajvgjGLOzZFFbiAwTEW75Yjky0w
         lOjqYGlOx3MXnaZfcStEfn3iUtxf9EtlXBqUVWVUkH4Ey/1fOkdHVigCDSM2eTGSclPd
         KL3919WKGnFLSuoWuUip1jObran8gnnRc6ukErSyw1b9OjZSPfL/FVwcVSt5bVlfUBqU
         sXRA==
X-Gm-Message-State: AO0yUKWSFzZEAB55XZPhoxrSQTYOq9moCgTZ8zMz8GNepy0i/mww5aOO
        3QkVbto+DwZCga3v3TYZyXA=
X-Google-Smtp-Source: AK7set+jbRPLp0rdAonZPkzgrGK5KNzWWr/6P009Cv8XwA4dj8IroNDNZjFGcMHFqK775OR+3J7mPg==
X-Received: by 2002:a17:902:b203:b0:19a:ae30:3a42 with SMTP id t3-20020a170902b20300b0019aae303a42mr4918309plr.21.1678574222815;
        Sat, 11 Mar 2023 14:37:02 -0800 (PST)
Received: from [192.168.0.128] ([98.97.116.32])
        by smtp.googlemail.com with ESMTPSA id li14-20020a170903294e00b0019a84b88f7csm2003564plb.27.2023.03.11.14.37.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 14:37:01 -0800 (PST)
Message-ID: <64932ccc97c3bd2ab7fac6216e465550107b7fa4.camel@gmail.com>
Subject: Re: [PATCH net v8 1/2] net/ps3_gelic_net: Fix RX sk_buff length
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Geoff Levand <geoff@infradead.org>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Paolo Abeni <pabeni@redhat.com>
Date:   Sat, 11 Mar 2023 14:37:00 -0800
In-Reply-To: <4581be2478ecc3292a3864e24fe9a42dac533b89.1678570942.git.geoff@infradead.org>
References: <cover.1678570942.git.geoff@infradead.org>
         <4581be2478ecc3292a3864e24fe9a42dac533b89.1678570942.git.geoff@infradead.org>
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

On Sat, 2023-03-11 at 21:46 +0000, Geoff Levand wrote:
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
>  drivers/net/ethernet/toshiba/ps3_gelic_net.c | 21 +++++++++++---------
>  drivers/net/ethernet/toshiba/ps3_gelic_net.h |  5 +++--
>  2 files changed, 15 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/e=
thernet/toshiba/ps3_gelic_net.c
> index cf8de8a7a8a1..56557fc8d18a 100644
> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> @@ -44,6 +44,14 @@ MODULE_AUTHOR("SCE Inc.");
>  MODULE_DESCRIPTION("Gelic Network driver");
>  MODULE_LICENSE("GPL");
> =20
> +/**
> + * Gelic RX sk_buffs must be aligned to GELIC_NET_RXBUF_ALIGN and the le=
ngth
> + * must be a multiple of GELIC_NET_RXBUF_ALIGN.
> + */
> +
> +static const unsigned int gelic_rx_skb_size =3D
> +	ALIGN(GELIC_NET_MAX_FRAME, GELIC_NET_RXBUF_ALIGN) +
> +	GELIC_NET_RXBUF_ALIGN - 1;
>=20

After a bit more digging I now understand the need for the
"GELIC_NET_RXBUF_ALIGN - 1". It shouldn't be added here. The device
will not be able to DMA into it. It is being used to align the buffer
itself to 128B. I am assuming it must be 128B aligned in BOTH size and
offset.

>  /* set irq_mask */
>  int gelic_card_set_irq_mask(struct gelic_card *card, u64 mask)
> @@ -370,21 +378,16 @@ static int gelic_descr_prepare_rx(struct gelic_card=
 *card,
>  				  struct gelic_descr *descr)
>  {
>  	int offset;
> -	unsigned int bufsize;
> =20
>  	if (gelic_descr_get_status(descr) !=3D  GELIC_DESCR_DMA_NOT_IN_USE)
>  		dev_info(ctodev(card), "%s: ERROR status\n", __func__);
> -	/* we need to round up the buffer size to a multiple of 128 */
> -	bufsize =3D ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN);
> =20
> -	/* and we need to have it 128 byte aligned, therefore we allocate a
> -	 * bit more */
> -	descr->skb =3D dev_alloc_skb(bufsize + GELIC_NET_RXBUF_ALIGN - 1);
> +	descr->skb =3D netdev_alloc_skb(*card->netdev, gelic_rx_skb_size);

I would leave the "+  GELIC_NET_RXBUF_ALIGN - 1" here. so it should be
	descr->skb =3D netdev_alloc_skb(*card->netdev, 	=09
				      gelic_rx_skb_size +
				      GELIC_NET_RXBUF_ALIGN - 1);

Also I would leav the comment as it makes it a bit clearer what is
going on here.

>  	if (!descr->skb) {
>  		descr->buf_addr =3D 0; /* tell DMAC don't touch memory */
>  		return -ENOMEM;
>  	}
> -	descr->buf_size =3D cpu_to_be32(bufsize);
> +	descr->buf_size =3D cpu_to_be32(gelic_rx_skb_size);
>  	descr->dmac_cmd_status =3D 0;
>  	descr->result_size =3D 0;
>  	descr->valid_size =3D 0;

The part I missed was the lines of code that didn't make it into the
patch that like between the two code blocks here above and below. They
are doing an AND with your align mask and then adding the difference to
the skb reserve to pad it to be 128B aligned.

> @@ -397,7 +400,7 @@ static int gelic_descr_prepare_rx(struct gelic_card *=
card,
>  	/* io-mmu-map the skb */
>  	descr->buf_addr =3D cpu_to_be32(dma_map_single(ctodev(card),
>  						     descr->skb->data,
> -						     GELIC_NET_MAX_MTU,
> +						     gelic_rx_skb_size,
>  						     DMA_FROM_DEVICE));
>  	if (!descr->buf_addr) {
>  		dev_kfree_skb_any(descr->skb);
> @@ -915,7 +918,7 @@ static void gelic_net_pass_skb_up(struct gelic_descr =
*descr,
>  	data_error =3D be32_to_cpu(descr->data_error);
>  	/* unmap skb buffer */
>  	dma_unmap_single(ctodev(card), be32_to_cpu(descr->buf_addr),
> -			 GELIC_NET_MAX_MTU,
> +			 gelic_rx_skb_size,
>  			 DMA_FROM_DEVICE);
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

