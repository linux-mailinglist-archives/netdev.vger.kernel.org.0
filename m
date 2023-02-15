Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAE5697EC0
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 15:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbjBOOwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 09:52:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjBOOwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 09:52:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803DE38B7A
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 06:51:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676472682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gn3VT1h9aMWQHBQWyqAOD5jr8pSEmeBcYR1j6rqdOyA=;
        b=aio/HeihHtCCKINOMC68j6kjdHVvGpaVGJB2o069D0EUlnM9nyzGWFxuEoNuon36CtjrS+
        Y1zKxNE8DG4Zrr+6hqr+przMs1gtPkQQssz5j+rhpaiQT+yx3u/qtMJvOIkzt38Pe5l1Ux
        oNSUNV8Mw5t4EOigTYA4iyOzR8iOzbY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-185-ILu1DcIzMQGSUARibYfcPg-1; Wed, 15 Feb 2023 09:51:20 -0500
X-MC-Unique: ILu1DcIzMQGSUARibYfcPg-1
Received: by mail-wm1-f72.google.com with SMTP id p14-20020a05600c468e00b003e0107732f4so9347766wmo.1
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 06:51:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gn3VT1h9aMWQHBQWyqAOD5jr8pSEmeBcYR1j6rqdOyA=;
        b=D2MMjGSf+UMwYjwSl09i/m+Y3iE+N1Cyocw1mNtAanFOXIeKr+I15nhv59Lz698DZW
         t2Joq/Bz3bu53LybiqMQQmYTNMR9hfDNiL/diLTG8/WHPpAS16ACIEBl+XXzMjktVtAr
         OuCXZ/8lwpfQ+JA5GfdeQ4PvG7QTw+h6FhOmjXfBvwzI5DWr17H9zMIvT5cyMpkxTRcP
         W+/Wms1jiBHLXXbto8xJ0vrlD5IlJySntMvZ2SHZEtg+981e44NFuyBgdcP8LWF1cy/c
         JUFRcmR5y62W4BQWv5h6nvh69pvs/3YeR3ooqSPOE3zkOOceXtCKHK0PRBWP9oo+s/SZ
         GuNQ==
X-Gm-Message-State: AO0yUKV0SbUK+bN7mY9lZ7NJRRvy2ri0+1qTizb1wTjMN1cb30EopzPp
        TH/BOhnIgWwl0w346BLjLrN4a/B6v4P3Zaghl72+XhWy5S3+EkcDdmv82f9V0Nth8izEc5q6RLk
        phw2QUhbw7WryIYRq
X-Received: by 2002:a5d:4486:0:b0:2c3:da8a:192 with SMTP id j6-20020a5d4486000000b002c3da8a0192mr1929859wrq.15.1676472679471;
        Wed, 15 Feb 2023 06:51:19 -0800 (PST)
X-Google-Smtp-Source: AK7set/6skf1FPAcrd+pwasF3Q2WbsD97ptdd0VYp85azKjX+/WJsku80CtRHTR1mvJnFy6IpjdbzA==
X-Received: by 2002:a5d:4486:0:b0:2c3:da8a:192 with SMTP id j6-20020a5d4486000000b002c3da8a0192mr1929834wrq.15.1676472679113;
        Wed, 15 Feb 2023 06:51:19 -0800 (PST)
Received: from localhost (net-188-216-77-84.cust.vodafonedsl.it. [188.216.77.84])
        by smtp.gmail.com with ESMTPSA id c3-20020a7bc843000000b003d9aa76dc6asm2267806wml.0.2023.02.15.06.51.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 06:51:17 -0800 (PST)
Date:   Wed, 15 Feb 2023 15:51:15 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Tirthendu Sarkar <tirthendu.sarkar@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com
Subject: Re: [PATCH intel-next v4 8/8] i40e: add support for XDP multi-buffer
 Rx
Message-ID: <Y+zxY07GZ8aI7LrV@lore-desk>
References: <20230215124305.76075-1-tirthendu.sarkar@intel.com>
 <20230215124305.76075-9-tirthendu.sarkar@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3gZ1XSp8YJPxMz7x"
Content-Disposition: inline
In-Reply-To: <20230215124305.76075-9-tirthendu.sarkar@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--3gZ1XSp8YJPxMz7x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> This patch adds multi-buffer support for the i40e_driver.
>=20

[...]

> =20
>  	netdev->features &=3D ~NETIF_F_HW_TC;
>  	netdev->xdp_features =3D NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT=
 |
> -			       NETDEV_XDP_ACT_XSK_ZEROCOPY;
> +			       NETDEV_XDP_ACT_XSK_ZEROCOPY |
> +			       NETDEV_XDP_ACT_RX_SG;

Hi Tirthendu,

I guess we should set it just for I40E_VSI_MAIN, I posted a patch yesterday
to fix it:
https://patchwork.kernel.org/project/netdevbpf/patch/f2b537f86b34fc176fbc6b=
3d249b46a20a87a2f3.1676405131.git.lorenzo@kernel.org/

can you please rebase on top of it?

Regards,
Lorenzo

> =20
>  	if (vsi->type =3D=3D I40E_VSI_MAIN) {
>  		SET_NETDEV_DEV(netdev, &pf->pdev->dev);
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/et=
hernet/intel/i40e/i40e_txrx.c
> index dc2c9aae0ffe..7ace7b7ec256 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> @@ -1477,9 +1477,6 @@ void i40e_clean_rx_ring(struct i40e_ring *rx_ring)
>  	if (!rx_ring->rx_bi)
>  		return;
> =20
> -	dev_kfree_skb(rx_ring->skb);
> -	rx_ring->skb =3D NULL;
> -
>  	if (rx_ring->xsk_pool) {
>  		i40e_xsk_clean_rx_ring(rx_ring);
>  		goto skip_free;
> @@ -2033,36 +2030,6 @@ static void i40e_rx_buffer_flip(struct i40e_rx_buf=
fer *rx_buffer,
>  #endif
>  }
> =20
> -/**
> - * i40e_add_rx_frag - Add contents of Rx buffer to sk_buff
> - * @rx_ring: rx descriptor ring to transact packets on
> - * @rx_buffer: buffer containing page to add
> - * @skb: sk_buff to place the data into
> - * @size: packet length from rx_desc
> - *
> - * This function will add the data contained in rx_buffer->page to the s=
kb.
> - * It will just attach the page as a frag to the skb.
> - *
> - * The function will then update the page offset.
> - **/
> -static void i40e_add_rx_frag(struct i40e_ring *rx_ring,
> -			     struct i40e_rx_buffer *rx_buffer,
> -			     struct sk_buff *skb,
> -			     unsigned int size)
> -{
> -#if (PAGE_SIZE < 8192)
> -	unsigned int truesize =3D i40e_rx_pg_size(rx_ring) / 2;
> -#else
> -	unsigned int truesize =3D SKB_DATA_ALIGN(size + rx_ring->rx_offset);
> -#endif
> -
> -	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, rx_buffer->page,
> -			rx_buffer->page_offset, size, truesize);
> -
> -	/* page is being used so we must update the page offset */
> -	i40e_rx_buffer_flip(rx_buffer, truesize);
> -}
> -
>  /**
>   * i40e_get_rx_buffer - Fetch Rx buffer and synchronize data for use
>   * @rx_ring: rx descriptor ring to transact packets on
> @@ -2099,20 +2066,82 @@ static struct i40e_rx_buffer *i40e_get_rx_buffer(=
struct i40e_ring *rx_ring,
>  }
> =20
>  /**
> - * i40e_construct_skb - Allocate skb and populate it
> + * i40e_put_rx_buffer - Clean up used buffer and either recycle or free
>   * @rx_ring: rx descriptor ring to transact packets on
>   * @rx_buffer: rx buffer to pull data from
> + *
> + * This function will clean up the contents of the rx_buffer.  It will
> + * either recycle the buffer or unmap it and free the associated resourc=
es.
> + */
> +static void i40e_put_rx_buffer(struct i40e_ring *rx_ring,
> +			       struct i40e_rx_buffer *rx_buffer)
> +{
> +	if (i40e_can_reuse_rx_page(rx_buffer, &rx_ring->rx_stats)) {
> +		/* hand second half of page back to the ring */
> +		i40e_reuse_rx_page(rx_ring, rx_buffer);
> +	} else {
> +		/* we are not reusing the buffer so unmap it */
> +		dma_unmap_page_attrs(rx_ring->dev, rx_buffer->dma,
> +				     i40e_rx_pg_size(rx_ring),
> +				     DMA_FROM_DEVICE, I40E_RX_DMA_ATTR);
> +		__page_frag_cache_drain(rx_buffer->page,
> +					rx_buffer->pagecnt_bias);
> +		/* clear contents of buffer_info */
> +		rx_buffer->page =3D NULL;
> +	}
> +}
> +
> +/**
> + * i40e_process_rx_buffs- Processing of buffers post XDP prog or on error
> + * @rx_ring: Rx descriptor ring to transact packets on
> + * @xdp_res: Result of the XDP program
> + * @xdp: xdp_buff pointing to the data
> + **/
> +static void i40e_process_rx_buffs(struct i40e_ring *rx_ring, int xdp_res,
> +				  struct xdp_buff *xdp)
> +{
> +	u16 next =3D rx_ring->next_to_clean;
> +	struct i40e_rx_buffer *rx_buffer;
> +
> +	xdp->flags =3D 0;
> +
> +	while (1) {
> +		rx_buffer =3D i40e_rx_bi(rx_ring, next);
> +		if (++next =3D=3D rx_ring->count)
> +			next =3D 0;
> +
> +		if (!rx_buffer->page)
> +			continue;
> +
> +		if (xdp_res =3D=3D I40E_XDP_CONSUMED)
> +			rx_buffer->pagecnt_bias++;
> +		else
> +			i40e_rx_buffer_flip(rx_buffer, xdp->frame_sz);
> +
> +		/* EOP buffer will be put in i40e_clean_rx_irq() */
> +		if (next =3D=3D rx_ring->next_to_process)
> +			return;
> +
> +		i40e_put_rx_buffer(rx_ring, rx_buffer);
> +	}
> +}
> +
> +/**
> + * i40e_construct_skb - Allocate skb and populate it
> + * @rx_ring: rx descriptor ring to transact packets on
>   * @xdp: xdp_buff pointing to the data
> + * @nr_frags: number of buffers for the packet
>   *
>   * This function allocates an skb.  It then populates it with the page
>   * data from the current receive descriptor, taking care to set up the
>   * skb correctly.
>   */
>  static struct sk_buff *i40e_construct_skb(struct i40e_ring *rx_ring,
> -					  struct i40e_rx_buffer *rx_buffer,
> -					  struct xdp_buff *xdp)
> +					  struct xdp_buff *xdp,
> +					  u32 nr_frags)
>  {
>  	unsigned int size =3D xdp->data_end - xdp->data;
> +	struct i40e_rx_buffer *rx_buffer;
>  	unsigned int headlen;
>  	struct sk_buff *skb;
> =20
> @@ -2152,13 +2181,17 @@ static struct sk_buff *i40e_construct_skb(struct =
i40e_ring *rx_ring,
>  	memcpy(__skb_put(skb, headlen), xdp->data,
>  	       ALIGN(headlen, sizeof(long)));
> =20
> +	rx_buffer =3D i40e_rx_bi(rx_ring, rx_ring->next_to_clean);
>  	/* update all of the pointers */
>  	size -=3D headlen;
>  	if (size) {
> +		if (unlikely(nr_frags >=3D MAX_SKB_FRAGS)) {
> +			dev_kfree_skb(skb);
> +			return NULL;
> +		}
>  		skb_add_rx_frag(skb, 0, rx_buffer->page,
>  				rx_buffer->page_offset + headlen,
>  				size, xdp->frame_sz);
> -
>  		/* buffer is used by skb, update page_offset */
>  		i40e_rx_buffer_flip(rx_buffer, xdp->frame_sz);
>  	} else {
> @@ -2166,21 +2199,40 @@ static struct sk_buff *i40e_construct_skb(struct =
i40e_ring *rx_ring,
>  		rx_buffer->pagecnt_bias++;
>  	}
> =20
> +	if (unlikely(xdp_buff_has_frags(xdp))) {
> +		struct skb_shared_info *sinfo, *skinfo =3D skb_shinfo(skb);
> +
> +		sinfo =3D xdp_get_shared_info_from_buff(xdp);
> +		memcpy(&skinfo->frags[skinfo->nr_frags], &sinfo->frags[0],
> +		       sizeof(skb_frag_t) * nr_frags);
> +
> +		xdp_update_skb_shared_info(skb, skinfo->nr_frags + nr_frags,
> +					   sinfo->xdp_frags_size,
> +					   nr_frags * xdp->frame_sz,
> +					   xdp_buff_is_frag_pfmemalloc(xdp));
> +
> +		/* First buffer has already been processed, so bump ntc */
> +		if (++rx_ring->next_to_clean =3D=3D rx_ring->count)
> +			rx_ring->next_to_clean =3D 0;
> +
> +		i40e_process_rx_buffs(rx_ring, I40E_XDP_PASS, xdp);
> +	}
> +
>  	return skb;
>  }
> =20
>  /**
>   * i40e_build_skb - Build skb around an existing buffer
>   * @rx_ring: Rx descriptor ring to transact packets on
> - * @rx_buffer: Rx buffer to pull data from
>   * @xdp: xdp_buff pointing to the data
> + * @nr_frags: number of buffers for the packet
>   *
>   * This function builds an skb around an existing Rx buffer, taking care
>   * to set up the skb correctly and avoid any memcpy overhead.
>   */
>  static struct sk_buff *i40e_build_skb(struct i40e_ring *rx_ring,
> -				      struct i40e_rx_buffer *rx_buffer,
> -				      struct xdp_buff *xdp)
> +				      struct xdp_buff *xdp,
> +				      u32 nr_frags)
>  {
>  	unsigned int metasize =3D xdp->data - xdp->data_meta;
>  	struct sk_buff *skb;
> @@ -2203,36 +2255,25 @@ static struct sk_buff *i40e_build_skb(struct i40e=
_ring *rx_ring,
>  	if (metasize)
>  		skb_metadata_set(skb, metasize);
> =20
> -	/* buffer is used by skb, update page_offset */
> -	i40e_rx_buffer_flip(rx_buffer, xdp->frame_sz);
> +	if (unlikely(xdp_buff_has_frags(xdp))) {
> +		struct skb_shared_info *sinfo;
> =20
> -	return skb;
> -}
> +		sinfo =3D xdp_get_shared_info_from_buff(xdp);
> +		xdp_update_skb_shared_info(skb, nr_frags,
> +					   sinfo->xdp_frags_size,
> +					   nr_frags * xdp->frame_sz,
> +					   xdp_buff_is_frag_pfmemalloc(xdp));
> =20
> -/**
> - * i40e_put_rx_buffer - Clean up used buffer and either recycle or free
> - * @rx_ring: rx descriptor ring to transact packets on
> - * @rx_buffer: rx buffer to pull data from
> - *
> - * This function will clean up the contents of the rx_buffer.  It will
> - * either recycle the buffer or unmap it and free the associated resourc=
es.
> - */
> -static void i40e_put_rx_buffer(struct i40e_ring *rx_ring,
> -			       struct i40e_rx_buffer *rx_buffer)
> -{
> -	if (i40e_can_reuse_rx_page(rx_buffer, &rx_ring->rx_stats)) {
> -		/* hand second half of page back to the ring */
> -		i40e_reuse_rx_page(rx_ring, rx_buffer);
> +		i40e_process_rx_buffs(rx_ring, I40E_XDP_PASS, xdp);
>  	} else {
> -		/* we are not reusing the buffer so unmap it */
> -		dma_unmap_page_attrs(rx_ring->dev, rx_buffer->dma,
> -				     i40e_rx_pg_size(rx_ring),
> -				     DMA_FROM_DEVICE, I40E_RX_DMA_ATTR);
> -		__page_frag_cache_drain(rx_buffer->page,
> -					rx_buffer->pagecnt_bias);
> -		/* clear contents of buffer_info */
> -		rx_buffer->page =3D NULL;
> +		struct i40e_rx_buffer *rx_buffer;
> +
> +		rx_buffer =3D i40e_rx_bi(rx_ring, rx_ring->next_to_clean);
> +		/* buffer is used by skb, update page_offset */
> +		i40e_rx_buffer_flip(rx_buffer, xdp->frame_sz);
>  	}
> +
> +	return skb;
>  }
> =20
>  /**
> @@ -2387,6 +2428,55 @@ static void i40e_inc_ntp(struct i40e_ring *rx_ring)
>  	prefetch(I40E_RX_DESC(rx_ring, ntp));
>  }
> =20
> +/**
> + * i40e_add_xdp_frag: Add a frag to xdp_buff
> + * @xdp: xdp_buff pointing to the data
> + * @nr_frags: return number of buffers for the packet
> + * @rx_buffer: rx_buffer holding data of the current frag
> + * @size: size of data of current frag
> + */
> +static int i40e_add_xdp_frag(struct xdp_buff *xdp, u32 *nr_frags,
> +			     struct i40e_rx_buffer *rx_buffer, u32 size)
> +{
> +	struct skb_shared_info *sinfo =3D xdp_get_shared_info_from_buff(xdp);
> +
> +	if (!xdp_buff_has_frags(xdp)) {
> +		sinfo->nr_frags =3D 0;
> +		sinfo->xdp_frags_size =3D 0;
> +		xdp_buff_set_frags_flag(xdp);
> +	} else if (unlikely(sinfo->nr_frags >=3D MAX_SKB_FRAGS)) {
> +		/* Overflowing packet: All frags need to be dropped */
> +		return -ENOMEM;
> +	}
> +
> +	__skb_fill_page_desc_noacc(sinfo, sinfo->nr_frags++, rx_buffer->page,
> +				   rx_buffer->page_offset, size);
> +
> +	sinfo->xdp_frags_size +=3D size;
> +
> +	if (page_is_pfmemalloc(rx_buffer->page))
> +		xdp_buff_set_frag_pfmemalloc(xdp);
> +	*nr_frags =3D sinfo->nr_frags;
> +
> +	return 0;
> +}
> +
> +/**
> + * i40e_consume_xdp_buff - Consume all the buffers of the packet and upd=
ate ntc
> + * @rx_ring: rx descriptor ring to transact packets on
> + * @xdp: xdp_buff pointing to the data
> + * @rx_buffer: rx_buffer of eop desc
> + */
> +static void i40e_consume_xdp_buff(struct i40e_ring *rx_ring,
> +				  struct xdp_buff *xdp,
> +				  struct i40e_rx_buffer *rx_buffer)
> +{
> +	i40e_process_rx_buffs(rx_ring, I40E_XDP_CONSUMED, xdp);
> +	i40e_put_rx_buffer(rx_ring, rx_buffer);
> +	rx_ring->next_to_clean =3D rx_ring->next_to_process;
> +	xdp->data =3D NULL;
> +}
> +
>  /**
>   * i40e_clean_rx_irq - Clean completed descriptors from Rx ring - bounce=
 buf
>   * @rx_ring: rx descriptor ring to transact packets on
> @@ -2405,9 +2495,9 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_r=
ing, int budget,
>  {
>  	unsigned int total_rx_bytes =3D 0, total_rx_packets =3D 0;
>  	u16 cleaned_count =3D I40E_DESC_UNUSED(rx_ring);
> +	u16 clean_threshold =3D rx_ring->count / 2;
>  	unsigned int offset =3D rx_ring->rx_offset;
>  	struct xdp_buff *xdp =3D &rx_ring->xdp;
> -	struct sk_buff *skb =3D rx_ring->skb;
>  	unsigned int xdp_xmit =3D 0;
>  	struct bpf_prog *xdp_prog;
>  	bool failure =3D false;
> @@ -2419,11 +2509,14 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx=
_ring, int budget,
>  		u16 ntp =3D rx_ring->next_to_process;
>  		struct i40e_rx_buffer *rx_buffer;
>  		union i40e_rx_desc *rx_desc;
> +		struct sk_buff *skb;
>  		unsigned int size;
> +		u32 nfrags =3D 0;
> +		bool neop;
>  		u64 qword;
> =20
>  		/* return some buffers to hardware, one at a time is too slow */
> -		if (cleaned_count >=3D I40E_RX_BUFFER_WRITE) {
> +		if (cleaned_count >=3D clean_threshold) {
>  			failure =3D failure ||
>  				  i40e_alloc_rx_buffers(rx_ring, cleaned_count);
>  			cleaned_count =3D 0;
> @@ -2461,76 +2554,83 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx=
_ring, int budget,
>  			break;
> =20
>  		i40e_trace(clean_rx_irq, rx_ring, rx_desc, xdp);
> +		/* retrieve a buffer from the ring */
>  		rx_buffer =3D i40e_get_rx_buffer(rx_ring, size);
> =20
> -		/* retrieve a buffer from the ring */
> -		if (!skb) {
> +		neop =3D i40e_is_non_eop(rx_ring, rx_desc);
> +		i40e_inc_ntp(rx_ring);
> +
> +		if (!xdp->data) {
>  			unsigned char *hard_start;
> =20
>  			hard_start =3D page_address(rx_buffer->page) +
>  				     rx_buffer->page_offset - offset;
>  			xdp_prepare_buff(xdp, hard_start, offset, size, true);
> -			xdp_buff_clear_frags_flag(xdp);
>  #if (PAGE_SIZE > 4096)
>  			/* At larger PAGE_SIZE, frame_sz depend on len size */
>  			xdp->frame_sz =3D i40e_rx_frame_truesize(rx_ring, size);
>  #endif
> -			xdp_res =3D i40e_run_xdp(rx_ring, xdp, xdp_prog);
> +		} else if (i40e_add_xdp_frag(xdp, &nfrags, rx_buffer, size) &&
> +			   !neop) {
> +			/* Overflowing packet: Drop all frags on EOP */
> +			i40e_consume_xdp_buff(rx_ring, xdp, rx_buffer);
> +			break;
>  		}
> =20
> +		if (neop)
> +			continue;
> +
> +		xdp_res =3D i40e_run_xdp(rx_ring, xdp, xdp_prog);
> +
>  		if (xdp_res) {
> -			if (xdp_res & (I40E_XDP_TX | I40E_XDP_REDIR)) {
> -				xdp_xmit |=3D xdp_res;
> +			xdp_xmit |=3D xdp_res & (I40E_XDP_TX | I40E_XDP_REDIR);
> +
> +			if (unlikely(xdp_buff_has_frags(xdp))) {
> +				i40e_process_rx_buffs(rx_ring, xdp_res, xdp);
> +				size =3D xdp_get_buff_len(xdp);
> +			} else if (xdp_res & (I40E_XDP_TX | I40E_XDP_REDIR)) {
>  				i40e_rx_buffer_flip(rx_buffer, xdp->frame_sz);
>  			} else {
>  				rx_buffer->pagecnt_bias++;
>  			}
>  			total_rx_bytes +=3D size;
> -			total_rx_packets++;
> -		} else if (skb) {
> -			i40e_add_rx_frag(rx_ring, rx_buffer, skb, size);
> -		} else if (ring_uses_build_skb(rx_ring)) {
> -			skb =3D i40e_build_skb(rx_ring, rx_buffer, xdp);
>  		} else {
> -			skb =3D i40e_construct_skb(rx_ring, rx_buffer, xdp);
> -		}
> +			if (ring_uses_build_skb(rx_ring))
> +				skb =3D i40e_build_skb(rx_ring, xdp, nfrags);
> +			else
> +				skb =3D i40e_construct_skb(rx_ring, xdp, nfrags);
> +
> +			/* drop if we failed to retrieve a buffer */
> +			if (!skb) {
> +				rx_ring->rx_stats.alloc_buff_failed++;
> +				i40e_consume_xdp_buff(rx_ring, xdp, rx_buffer);
> +				break;
> +			}
> =20
> -		/* exit if we failed to retrieve a buffer */
> -		if (!xdp_res && !skb) {
> -			rx_ring->rx_stats.alloc_buff_failed++;
> -			rx_buffer->pagecnt_bias++;
> -			break;
> -		}
> +			if (i40e_cleanup_headers(rx_ring, skb, rx_desc))
> +				goto process_next;
> =20
> -		i40e_put_rx_buffer(rx_ring, rx_buffer);
> -		cleaned_count++;
> +			/* probably a little skewed due to removing CRC */
> +			total_rx_bytes +=3D skb->len;
> =20
> -		i40e_inc_ntp(rx_ring);
> -		rx_ring->next_to_clean =3D rx_ring->next_to_process;
> -		if (i40e_is_non_eop(rx_ring, rx_desc))
> -			continue;
> +			/* populate checksum, VLAN, and protocol */
> +			i40e_process_skb_fields(rx_ring, rx_desc, skb);
> =20
> -		if (xdp_res || i40e_cleanup_headers(rx_ring, skb, rx_desc)) {
> -			skb =3D NULL;
> -			continue;
> +			i40e_trace(clean_rx_irq_rx, rx_ring, rx_desc, xdp);
> +			napi_gro_receive(&rx_ring->q_vector->napi, skb);
>  		}
> =20
> -		/* probably a little skewed due to removing CRC */
> -		total_rx_bytes +=3D skb->len;
> -
> -		/* populate checksum, VLAN, and protocol */
> -		i40e_process_skb_fields(rx_ring, rx_desc, skb);
> -
> -		i40e_trace(clean_rx_irq_rx, rx_ring, rx_desc, xdp);
> -		napi_gro_receive(&rx_ring->q_vector->napi, skb);
> -		skb =3D NULL;
> -
>  		/* update budget accounting */
>  		total_rx_packets++;
> +process_next:
> +		cleaned_count +=3D nfrags + 1;
> +		i40e_put_rx_buffer(rx_ring, rx_buffer);
> +		rx_ring->next_to_clean =3D rx_ring->next_to_process;
> +
> +		xdp->data =3D NULL;
>  	}
> =20
>  	i40e_finalize_xdp_rx(rx_ring, xdp_xmit);
> -	rx_ring->skb =3D skb;
> =20
>  	i40e_update_rx_stats(rx_ring, total_rx_bytes, total_rx_packets);
> =20
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/et=
hernet/intel/i40e/i40e_txrx.h
> index e86abc25bb5e..14ad074639ab 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
> +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
> @@ -393,14 +393,6 @@ struct i40e_ring {
> =20
>  	struct rcu_head rcu;		/* to avoid race on free */
>  	u16 next_to_alloc;
> -	struct sk_buff *skb;		/* When i40e_clean_rx_ring_irq() must
> -					 * return before it sees the EOP for
> -					 * the current packet, we save that skb
> -					 * here and resume receiving this
> -					 * packet the next time
> -					 * i40e_clean_rx_ring_irq() is called
> -					 * for this ring.
> -					 */
> =20
>  	struct i40e_channel *ch;
>  	u16 rx_offset;
> --=20
> 2.34.1
>=20

--3gZ1XSp8YJPxMz7x
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY+zxYwAKCRA6cBh0uS2t
rMg7AP9lvmOeFEgK6Dk2u9vPi7nl2xpOqmuwSo60VfViGiR7WwD/UWdlTP0+g6eD
UohiHiMOnNgcDmvKE65Hg/dBcMtLgAk=
=jQx6
-----END PGP SIGNATURE-----

--3gZ1XSp8YJPxMz7x--

