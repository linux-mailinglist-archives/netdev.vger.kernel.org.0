Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03291696167
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 11:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232771AbjBNKsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 05:48:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232791AbjBNKr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 05:47:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 608921EBD8
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 02:46:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676371591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L7Ftds8TVQxX16ljD8lOH5jLCrVm4Pe+/Nd+AJPmtZM=;
        b=jFGPKYvsqJsRKlbu8OilOk5j9A5vEp60N+mkTcXCZA2ysfdCZJHnZ/5fxuuKcuy6TQ+DTm
        fmVuvRIsYkPbwaJTXMgdQvl9T5asI3qrP9zcDMM3cF6IL+4IWwxAR3XyoS+qmI7j6wTjEd
        exWXjZBUhwk2kw9f0ikrH9OQT7UJSLU=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-373-TUYoItkNOK-NNw_aAd1suA-1; Tue, 14 Feb 2023 05:46:30 -0500
X-MC-Unique: TUYoItkNOK-NNw_aAd1suA-1
Received: by mail-ej1-f71.google.com with SMTP id fy3-20020a1709069f0300b008a69400909fso9594250ejc.7
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 02:46:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L7Ftds8TVQxX16ljD8lOH5jLCrVm4Pe+/Nd+AJPmtZM=;
        b=WiEmap5QrTit1WpEJLwxnl7lCXpqOcXdrqG5PK0RJYM3opDBqtAkyqKIbsGkhpsrSQ
         3y2vXaUXsDq18cx5pbCqwxLX0qq6/ke21NL08h9fmTk2KPVTCrtY4F63rfCoBwszkwKc
         gHT5YMCZ/onjoHpf+kOk/tFKfoHDDf3BwC/bvdmlMR1+XqX6V73djvNhhMnVvpX/+drU
         fsbQMQCXPiAEjiNo4G+vJYpFe95kMJZ+nCdj6qpDVmRkHUrKlpNvYfGOIiSnNzNzHL7P
         FXqcfdubnFfwoN/oHyy9X262IC01dURAeau+6n+gGZ0QuG2oZUWoGn5pTFbZCsU6CF5I
         1qZg==
X-Gm-Message-State: AO0yUKXmZrPUCpIEZYu09epxqBZB4UwVVdHbbss1cMJbiQXERCbdUoml
        xg9UjvOoAejyaZoyGYFmUoKgpJCEZFlDvJEkJDwEb6vYihfPqApcpJ2Oj+xyjzzqTOmm5zpmqd0
        8L8fZXv64bIfMz6n1
X-Received: by 2002:a17:906:1014:b0:878:4bda:2011 with SMTP id 20-20020a170906101400b008784bda2011mr2138438ejm.4.1676371588984;
        Tue, 14 Feb 2023 02:46:28 -0800 (PST)
X-Google-Smtp-Source: AK7set/8ArVavvBGMnprLx7mN3RVTWZUHqcCRig4Ivl713HOatwOzZRUHph6agkhkFq5cX0LEDU0Lw==
X-Received: by 2002:a17:906:1014:b0:878:4bda:2011 with SMTP id 20-20020a170906101400b008784bda2011mr2138429ejm.4.1676371588768;
        Tue, 14 Feb 2023 02:46:28 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id g25-20020a170906349900b0088519b92074sm8080698ejb.128.2023.02.14.02.46.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 02:46:28 -0800 (PST)
Message-ID: <d18b70fc097d475ca6e4a5b9349b971eda1f853d.camel@redhat.com>
Subject: Re: [PATCH net v5 1/2] net/ps3_gelic_net: Fix RX sk_buff length
From:   Paolo Abeni <pabeni@redhat.com>
To:     Geoff Levand <geoff@infradead.org>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 14 Feb 2023 11:46:26 +0100
In-Reply-To: <de8eacb3bb238f40ce69882e425bd83c6180d671.1676221818.git.geoff@infradead.org>
References: <cover.1676221818.git.geoff@infradead.org>
         <de8eacb3bb238f40ce69882e425bd83c6180d671.1676221818.git.geoff@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Alex
On Sun, 2023-02-12 at 18:00 +0000, Geoff Levand wrote:
> The Gelic Ethernet device needs to have the RX sk_buffs aligned to
> GELIC_NET_RXBUF_ALIGN and the length of the RX sk_buffs must be a
> multiple of GELIC_NET_RXBUF_ALIGN.
>=20
> The current Gelic Ethernet driver was not allocating sk_buffs large
> enough to allow for this alignment.
>=20
> Fixes various randomly occurring runtime network errors.
>=20
> Fixes: 02c1889166b4 (ps3: gigabit ethernet driver for PS3, take3)

Please use the correct format for the Fixes tag: <hash> ("<msg>"). Note
the missing quotes.

> Signed-off-by: Geoff Levand <geoff@infradead.org>
> ---
>  drivers/net/ethernet/toshiba/ps3_gelic_net.c | 55 ++++++++++++--------
>  1 file changed, 33 insertions(+), 22 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/e=
thernet/toshiba/ps3_gelic_net.c
> index cf8de8a7a8a1..2bb68e60d0d5 100644
> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> @@ -365,51 +365,62 @@ static int gelic_card_init_chain(struct gelic_card =
*card,
>   *
>   * allocates a new rx skb, iommu-maps it and attaches it to the descript=
or.
>   * Activate the descriptor state-wise
> + *
> + * Gelic RX sk_buffs must be aligned to GELIC_NET_RXBUF_ALIGN and the le=
ngth
> + * must be a multiple of GELIC_NET_RXBUF_ALIGN.
>   */
>  static int gelic_descr_prepare_rx(struct gelic_card *card,
>  				  struct gelic_descr *descr)
>  {
> -	int offset;
> -	unsigned int bufsize;
> +	struct device *dev =3D ctodev(card);
> +	struct {
> +		const unsigned int buffer_bytes;
> +		const unsigned int total_bytes;
> +		unsigned int offset;
> +	} aligned_buf =3D {
> +		.buffer_bytes =3D ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN),
> +		.total_bytes =3D (GELIC_NET_RXBUF_ALIGN - 1) +
> +			ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN),
> +	};
> =20
>  	if (gelic_descr_get_status(descr) !=3D  GELIC_DESCR_DMA_NOT_IN_USE)
>  		dev_info(ctodev(card), "%s: ERROR status\n", __func__);
> -	/* we need to round up the buffer size to a multiple of 128 */
> -	bufsize =3D ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN);
> =20
> -	/* and we need to have it 128 byte aligned, therefore we allocate a
> -	 * bit more */
> -	descr->skb =3D dev_alloc_skb(bufsize + GELIC_NET_RXBUF_ALIGN - 1);
> +	descr->skb =3D dev_alloc_skb(aligned_buf.total_bytes);
> +
>  	if (!descr->skb) {
> -		descr->buf_addr =3D 0; /* tell DMAC don't touch memory */
> +		descr->buf_addr =3D 0;
>  		return -ENOMEM;
>  	}
> -	descr->buf_size =3D cpu_to_be32(bufsize);
> +
> +	aligned_buf.offset =3D
> +		PTR_ALIGN(descr->skb->data, GELIC_NET_RXBUF_ALIGN) -
> +			descr->skb->data;
> +
> +	descr->buf_size =3D aligned_buf.buffer_bytes;
>  	descr->dmac_cmd_status =3D 0;
>  	descr->result_size =3D 0;
>  	descr->valid_size =3D 0;
>  	descr->data_error =3D 0;
> =20
> -	offset =3D ((unsigned long)descr->skb->data) &
> -		(GELIC_NET_RXBUF_ALIGN - 1);
> -	if (offset)
> -		skb_reserve(descr->skb, GELIC_NET_RXBUF_ALIGN - offset);
> -	/* io-mmu-map the skb */
> -	descr->buf_addr =3D cpu_to_be32(dma_map_single(ctodev(card),
> -						     descr->skb->data,
> -						     GELIC_NET_MAX_MTU,
> -						     DMA_FROM_DEVICE));
> +	skb_reserve(descr->skb, aligned_buf.offset);
> +
> +	descr->buf_addr =3D dma_map_single(dev, descr->skb->data, descr->buf_si=
ze,
> +		DMA_FROM_DEVICE);

As already noted by Alex, you should preserve the cpu_to_be32(). If the
running arch is be32, it has 0 performance and/or code size overhead,
and it helps readability and maintainability.

Please be sure to check the indentation of new code with checkpatch.

When reposting, please be sure to CC people that gave feedback on
previous iterations.

Cheers,

Paolo

