Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2B826D00FD
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 12:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbjC3KT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 06:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbjC3KTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 06:19:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E796D86A8
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 03:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680171501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5G4KlQgalZLZCJDa8edjfg+cOTUz1wNZ1RGVK9EOjxg=;
        b=GQpYV71nkcsOOCZQ/91FMHhhnuDQk8cpiSfdMyaKXI0c2e7TG6b0+VLC618d7LhwH3P2NH
        6Sb17nMXYyQfnYzRD90OnM0eEZPynMegiJFkguckvnnkPJ00NC954nRj4NaAleL2bYm8h1
        sBjrclE8sejZn0uLB4nyQn9hOBFZRFU=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-541-kFcPItbiMDuwww6aihaPGw-1; Thu, 30 Mar 2023 06:18:20 -0400
X-MC-Unique: kFcPItbiMDuwww6aihaPGw-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-57c67ea348eso12362126d6.1
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 03:18:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680171499;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5G4KlQgalZLZCJDa8edjfg+cOTUz1wNZ1RGVK9EOjxg=;
        b=HmeVkW+KweEIjhV03qCDtdfrb/NRptSy2Nw2WFbOVfQyGN6U2XvgwBiSM3toabKCQM
         9hHJn9o9al4Z5A/ql2XydV255RE3WsZqj2/ZKzasam8CR77mWpnwfNWNhJRWZkJ9N4Yl
         ygjVF/1DXWSUeheazqHAfBbYJiQyD0a09uZtJyFSO+ATpmpv5kvBtS0XrbDa3aKcwrOF
         3sdLNfvJjQipNmKYef3riQWzoAWbemGju1eB58zrzsCCGZeKW7+8+ZTw9enj1DfP9X8f
         qRk3TJIoa1//xdxVoPowgEaw6D5x7wNbR4+UXUCXH2btgee67ERmHdNvDiMRGSiK66/F
         1zyg==
X-Gm-Message-State: AAQBX9fU+rmlHKf7DNtgMyZJXT/Df1deLO0mh5tgj63w79sLr2+/NsoN
        qtcg6Zu1PvqTkSAOGIBt82G8+wGMgvk+Wa6iXpAUySTzzTSoCmVujcky8pDO2vkw4fLitMvtDS1
        sKzCJMGdTY4NxCuo179H1uQ6/
X-Received: by 2002:a05:6214:5089:b0:57d:747b:1f7 with SMTP id kk9-20020a056214508900b0057d747b01f7mr1974009qvb.1.1680171499607;
        Thu, 30 Mar 2023 03:18:19 -0700 (PDT)
X-Google-Smtp-Source: AKy350bvx8K/owgkDcL8x2YcXmXFmidn7E2vZNaiTvyyPaK6M4yc/CbTywaTxcrJm2j30ZXWyITBOQ==
X-Received: by 2002:a05:6214:5089:b0:57d:747b:1f7 with SMTP id kk9-20020a056214508900b0057d747b01f7mr1973988qvb.1.1680171499214;
        Thu, 30 Mar 2023 03:18:19 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-228-125.dyn.eolo.it. [146.241.228.125])
        by smtp.gmail.com with ESMTPSA id f17-20020ac84711000000b003e635f0fdb4sm169635qtp.53.2023.03.30.03.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 03:18:18 -0700 (PDT)
Message-ID: <3155cdb517e0db77d8664e5623c9d39e437fd796.camel@redhat.com>
Subject: Re: [PATCH net-next 7/8] virtio_net: introduce
 receive_mergeable_xdp()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Date:   Thu, 30 Mar 2023 12:18:15 +0200
In-Reply-To: <20230328120412.110114-8-xuanzhuo@linux.alibaba.com>
References: <20230328120412.110114-1-xuanzhuo@linux.alibaba.com>
         <20230328120412.110114-8-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, 2023-03-28 at 20:04 +0800, Xuan Zhuo wrote:
> The purpose of this patch is to simplify the receive_mergeable().
> Separate all the logic of XDP into a function.
>=20
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/net/virtio_net.c | 128 +++++++++++++++++++++++----------------
>  1 file changed, 76 insertions(+), 52 deletions(-)
>=20
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 136131a7868a..c8978d8d8adb 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1316,6 +1316,63 @@ static void *mergeable_xdp_prepare(struct virtnet_=
info *vi,
>  	return page_address(xdp_page) + VIRTIO_XDP_HEADROOM;
>  }
> =20
> +static struct sk_buff *receive_mergeable_xdp(struct net_device *dev,
> +					     struct virtnet_info *vi,
> +					     struct receive_queue *rq,
> +					     struct bpf_prog *xdp_prog,
> +					     void *buf,
> +					     void *ctx,
> +					     unsigned int len,
> +					     unsigned int *xdp_xmit,
> +					     struct virtnet_rq_stats *stats)
> +{
> +	struct virtio_net_hdr_mrg_rxbuf *hdr =3D buf;
> +	int num_buf =3D virtio16_to_cpu(vi->vdev, hdr->num_buffers);
> +	struct page *page =3D virt_to_head_page(buf);
> +	int offset =3D buf - page_address(page);
> +	unsigned int xdp_frags_truesz =3D 0;
> +	struct sk_buff *head_skb;
> +	unsigned int frame_sz;
> +	struct xdp_buff xdp;
> +	void *data;
> +	u32 act;
> +	int err;
> +
> +	data =3D mergeable_xdp_prepare(vi, rq, xdp_prog, ctx, &frame_sz, &num_b=
uf, &page,
> +				     offset, &len, hdr);
> +	if (!data)
> +		goto err_xdp;
> +
> +	err =3D virtnet_build_xdp_buff_mrg(dev, vi, rq, &xdp, data, len, frame_=
sz,
> +					 &num_buf, &xdp_frags_truesz, stats);
> +	if (unlikely(err))
> +		goto err_xdp;
> +
> +	act =3D virtnet_xdp_handler(xdp_prog, &xdp, dev, xdp_xmit, stats);
> +
> +	switch (act) {
> +	case VIRTNET_XDP_RES_PASS:
> +		head_skb =3D build_skb_from_xdp_buff(dev, vi, &xdp, xdp_frags_truesz);
> +		if (unlikely(!head_skb))
> +			goto err_xdp;
> +		return head_skb;
> +
> +	case VIRTNET_XDP_RES_CONSUMED:
> +		return NULL;
> +
> +	case VIRTNET_XDP_RES_DROP:
> +		break;
> +	}
> +
> +err_xdp:
> +	put_page(page);
> +	mergeable_buf_free(rq, num_buf, dev, stats);
> +
> +	stats->xdp_drops++;
> +	stats->drops++;
> +	return NULL;
> +}
> +
>  static struct sk_buff *receive_mergeable(struct net_device *dev,
>  					 struct virtnet_info *vi,
>  					 struct receive_queue *rq,
> @@ -1325,21 +1382,22 @@ static struct sk_buff *receive_mergeable(struct n=
et_device *dev,
>  					 unsigned int *xdp_xmit,
>  					 struct virtnet_rq_stats *stats)
>  {
> -	struct virtio_net_hdr_mrg_rxbuf *hdr =3D buf;
> -	int num_buf =3D virtio16_to_cpu(vi->vdev, hdr->num_buffers);
> -	struct page *page =3D virt_to_head_page(buf);
> -	int offset =3D buf - page_address(page);
> -	struct sk_buff *head_skb, *curr_skb;
> -	struct bpf_prog *xdp_prog;
>  	unsigned int truesize =3D mergeable_ctx_to_truesize(ctx);
>  	unsigned int headroom =3D mergeable_ctx_to_headroom(ctx);
>  	unsigned int tailroom =3D headroom ? sizeof(struct skb_shared_info) : 0=
;
>  	unsigned int room =3D SKB_DATA_ALIGN(headroom + tailroom);
> -	unsigned int frame_sz;
> -	int err;
> +	struct virtio_net_hdr_mrg_rxbuf *hdr;
> +	struct sk_buff *head_skb, *curr_skb;
> +	struct bpf_prog *xdp_prog;
> +	struct page *page;
> +	int num_buf;
> +	int offset;
> =20
>  	head_skb =3D NULL;
>  	stats->bytes +=3D len - vi->hdr_len;
> +	hdr =3D buf;
> +	num_buf =3D virtio16_to_cpu(vi->vdev, hdr->num_buffers);
> +	page =3D virt_to_head_page(buf);
> =20
>  	if (unlikely(len > truesize - room)) {
>  		pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
> @@ -1348,51 +1406,21 @@ static struct sk_buff *receive_mergeable(struct n=
et_device *dev,
>  		goto err_skb;
>  	}
> =20
> -	if (likely(!vi->xdp_enabled)) {
> -		xdp_prog =3D NULL;
> -		goto skip_xdp;
> -	}
> -
> -	rcu_read_lock();
> -	xdp_prog =3D rcu_dereference(rq->xdp_prog);
> -	if (xdp_prog) {
> -		unsigned int xdp_frags_truesz =3D 0;
> -		struct xdp_buff xdp;
> -		void *data;
> -		u32 act;
> -
> -		data =3D mergeable_xdp_prepare(vi, rq, xdp_prog, ctx, &frame_sz, &num_=
buf, &page,
> -					     offset, &len, hdr);
> -		if (!data)
> -			goto err_xdp;
> -
> -		err =3D virtnet_build_xdp_buff_mrg(dev, vi, rq, &xdp, data, len, frame=
_sz,
> -						 &num_buf, &xdp_frags_truesz, stats);
> -		if (unlikely(err))
> -			goto err_xdp;
> -
> -		act =3D virtnet_xdp_handler(xdp_prog, &xdp, dev, xdp_xmit, stats);
> -
> -		switch (act) {
> -		case VIRTNET_XDP_RES_PASS:
> -			head_skb =3D build_skb_from_xdp_buff(dev, vi, &xdp, xdp_frags_truesz)=
;
> -			if (unlikely(!head_skb))
> -				goto err_xdp;
> -
> +	if (likely(vi->xdp_enabled)) {

This changes the branch prediction hint compared to the existing code;
as we currently have:
	if (likely(!vi->xdp_enabled)) {


and I think it would be better avoid such change.

Thanks,

Paolo

