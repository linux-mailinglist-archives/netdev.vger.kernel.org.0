Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20E89166E78
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 05:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729656AbgBUEX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 23:23:57 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:27843 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729547AbgBUEX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 23:23:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582259035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9uOXUdcAkm4uECVzyjBcZ9Jj9pBC2hIUjFUbk2PSZpc=;
        b=A9BhZrLno2l0icEoErsgfsfQY64MMlHgSZGeWpxGXkPrQBkq6jS3sUvJ+DyPdNPl7lsPEv
        DLHiZLVf94Acum543A6pjHYz+nNJhOnzJuOF8pa8xxcUlYqKJgkNt8hR+76KLGwBT7V2TI
        4CpF277nT0Ok4zKb9mmiEcjS/ZnGlbw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-iZ-dekTJOpmppp2BwkCNNA-1; Thu, 20 Feb 2020 23:23:47 -0500
X-MC-Unique: iZ-dekTJOpmppp2BwkCNNA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE0BF189F766;
        Fri, 21 Feb 2020 04:23:44 +0000 (UTC)
Received: from [10.72.13.208] (ovpn-13-208.pek2.redhat.com [10.72.13.208])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A82835DA76;
        Fri, 21 Feb 2020 04:23:33 +0000 (UTC)
Subject: Re: [PATCH bpf-next v5] virtio_net: add XDP meta data support
To:     Yuya Kusakabe <yuya.kusakabe@gmail.com>
Cc:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com,
        netdev@vger.kernel.org, songliubraving@fb.com, yhs@fb.com
References: <0c5eaba2-dd5a-fc3f-0e8f-154f7ad52881@redhat.com>
 <20200220085549.269795-1-yuya.kusakabe@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <5bf11065-6b85-8253-8548-683c01c98ac1@redhat.com>
Date:   Fri, 21 Feb 2020 12:23:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200220085549.269795-1-yuya.kusakabe@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/20 =E4=B8=8B=E5=8D=884:55, Yuya Kusakabe wrote:
> Implement support for transferring XDP meta data into skb for
> virtio_net driver; before calling into the program, xdp.data_meta point=
s
> to xdp.data, where on program return with pass verdict, we call
> into skb_metadata_set().
>
> Tested with the script at
> https://github.com/higebu/virtio_net-xdp-metadata-test.
>
> Fixes: de8f3a83b0a0 ("bpf: add meta pointer for direct access")


I'm not sure this is correct since virtio-net claims to not support=20
metadata by calling xdp_set_data_meta_invalid()?


> Signed-off-by: Yuya Kusakabe <yuya.kusakabe@gmail.com>
> ---
> v5:
>   - page_to_skb(): copy vnet header if hdr_valid without checking metas=
ize.
>   - receive_small(): do not copy vnet header if xdp_prog is availavle.
>   - __virtnet_xdp_xmit_one(): remove the xdp_set_data_meta_invalid().
>   - improve comments.
> v4:
>   - improve commit message
> v3:
>   - fix preserve the vnet header in receive_small().
> v2:
>   - keep copy untouched in page_to_skb().
>   - preserve the vnet header in receive_small().
>   - fix indentation.
> ---
>   drivers/net/virtio_net.c | 54 ++++++++++++++++++++++++---------------=
-
>   1 file changed, 33 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 2fe7a3188282..4ea0ae60c000 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -371,7 +371,7 @@ static struct sk_buff *page_to_skb(struct virtnet_i=
nfo *vi,
>   				   struct receive_queue *rq,
>   				   struct page *page, unsigned int offset,
>   				   unsigned int len, unsigned int truesize,
> -				   bool hdr_valid)
> +				   bool hdr_valid, unsigned int metasize)
>   {
>   	struct sk_buff *skb;
>   	struct virtio_net_hdr_mrg_rxbuf *hdr;
> @@ -393,6 +393,7 @@ static struct sk_buff *page_to_skb(struct virtnet_i=
nfo *vi,
>   	else
>   		hdr_padded_len =3D sizeof(struct padded_vnet_hdr);
>  =20
> +	/* hdr_valid means no XDP, so we can copy the vnet header */
>   	if (hdr_valid)
>   		memcpy(hdr, p, hdr_len);
>  =20
> @@ -405,6 +406,11 @@ static struct sk_buff *page_to_skb(struct virtnet_=
info *vi,
>   		copy =3D skb_tailroom(skb);
>   	skb_put_data(skb, p, copy);
>  =20
> +	if (metasize) {
> +		__skb_pull(skb, metasize);
> +		skb_metadata_set(skb, metasize);
> +	}
> +
>   	len -=3D copy;
>   	offset +=3D copy;
>  =20
> @@ -450,10 +456,6 @@ static int __virtnet_xdp_xmit_one(struct virtnet_i=
nfo *vi,
>   	struct virtio_net_hdr_mrg_rxbuf *hdr;
>   	int err;
>  =20
> -	/* virtqueue want to use data area in-front of packet */
> -	if (unlikely(xdpf->metasize > 0))
> -		return -EOPNOTSUPP;
> -
>   	if (unlikely(xdpf->headroom < vi->hdr_len))
>   		return -EOVERFLOW;
>  =20
> @@ -644,6 +646,7 @@ static struct sk_buff *receive_small(struct net_dev=
ice *dev,
>   	unsigned int delta =3D 0;
>   	struct page *xdp_page;
>   	int err;
> +	unsigned int metasize =3D 0;
>  =20
>   	len -=3D vi->hdr_len;
>   	stats->bytes +=3D len;
> @@ -683,8 +686,8 @@ static struct sk_buff *receive_small(struct net_dev=
ice *dev,
>  =20
>   		xdp.data_hard_start =3D buf + VIRTNET_RX_PAD + vi->hdr_len;
>   		xdp.data =3D xdp.data_hard_start + xdp_headroom;
> -		xdp_set_data_meta_invalid(&xdp);
>   		xdp.data_end =3D xdp.data + len;
> +		xdp.data_meta =3D xdp.data;
>   		xdp.rxq =3D &rq->xdp_rxq;
>   		orig_data =3D xdp.data;
>   		act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
> @@ -695,6 +698,7 @@ static struct sk_buff *receive_small(struct net_dev=
ice *dev,
>   			/* Recalculate length in case bpf program changed it */
>   			delta =3D orig_data - xdp.data;
>   			len =3D xdp.data_end - xdp.data;
> +			metasize =3D xdp.data - xdp.data_meta;
>   			break;
>   		case XDP_TX:
>   			stats->xdp_tx++;
> @@ -735,11 +739,14 @@ static struct sk_buff *receive_small(struct net_d=
evice *dev,
>   	}
>   	skb_reserve(skb, headroom - delta);
>   	skb_put(skb, len);
> -	if (!delta) {
> +	if (!xdp_prog) {
>   		buf +=3D header_offset;
>   		memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);
>   	} /* keep zeroed vnet hdr since packet was changed by bpf */


I prefer to make this an independent patch and cc stable.

Other looks good.

Thanks


>  =20
> +	if (metasize)
> +		skb_metadata_set(skb, metasize);
> +
>   err:
>   	return skb;
>  =20
> @@ -760,8 +767,8 @@ static struct sk_buff *receive_big(struct net_devic=
e *dev,
>   				   struct virtnet_rq_stats *stats)
>   {
>   	struct page *page =3D buf;
> -	struct sk_buff *skb =3D page_to_skb(vi, rq, page, 0, len,
> -					  PAGE_SIZE, true);
> +	struct sk_buff *skb =3D
> +		page_to_skb(vi, rq, page, 0, len, PAGE_SIZE, true, 0);
>  =20
>   	stats->bytes +=3D len - vi->hdr_len;
>   	if (unlikely(!skb))
> @@ -793,6 +800,7 @@ static struct sk_buff *receive_mergeable(struct net=
_device *dev,
>   	unsigned int truesize;
>   	unsigned int headroom =3D mergeable_ctx_to_headroom(ctx);
>   	int err;
> +	unsigned int metasize =3D 0;
>  =20
>   	head_skb =3D NULL;
>   	stats->bytes +=3D len - vi->hdr_len;
> @@ -839,8 +847,8 @@ static struct sk_buff *receive_mergeable(struct net=
_device *dev,
>   		data =3D page_address(xdp_page) + offset;
>   		xdp.data_hard_start =3D data - VIRTIO_XDP_HEADROOM + vi->hdr_len;
>   		xdp.data =3D data + vi->hdr_len;
> -		xdp_set_data_meta_invalid(&xdp);
>   		xdp.data_end =3D xdp.data + (len - vi->hdr_len);
> +		xdp.data_meta =3D xdp.data;
>   		xdp.rxq =3D &rq->xdp_rxq;
>  =20
>   		act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
> @@ -848,24 +856,27 @@ static struct sk_buff *receive_mergeable(struct n=
et_device *dev,
>  =20
>   		switch (act) {
>   		case XDP_PASS:
> +			metasize =3D xdp.data - xdp.data_meta;
> +
>   			/* recalculate offset to account for any header
> -			 * adjustments. Note other cases do not build an
> -			 * skb and avoid using offset
> +			 * adjustments and minus the metasize to copy the
> +			 * metadata in page_to_skb(). Note other cases do not
> +			 * build an skb and avoid using offset
>   			 */
> -			offset =3D xdp.data -
> -					page_address(xdp_page) - vi->hdr_len;
> +			offset =3D xdp.data - page_address(xdp_page) -
> +				 vi->hdr_len - metasize;
>  =20
> -			/* recalculate len if xdp.data or xdp.data_end were
> -			 * adjusted
> +			/* recalculate len if xdp.data, xdp.data_end or
> +			 * xdp.data_meta were adjusted
>   			 */
> -			len =3D xdp.data_end - xdp.data + vi->hdr_len;
> +			len =3D xdp.data_end - xdp.data + vi->hdr_len + metasize;
>   			/* We can only create skb based on xdp_page. */
>   			if (unlikely(xdp_page !=3D page)) {
>   				rcu_read_unlock();
>   				put_page(page);
> -				head_skb =3D page_to_skb(vi, rq, xdp_page,
> -						       offset, len,
> -						       PAGE_SIZE, false);
> +				head_skb =3D page_to_skb(vi, rq, xdp_page, offset,
> +						       len, PAGE_SIZE, false,
> +						       metasize);
>   				return head_skb;
>   			}
>   			break;
> @@ -921,7 +932,8 @@ static struct sk_buff *receive_mergeable(struct net=
_device *dev,
>   		goto err_skb;
>   	}
>  =20
> -	head_skb =3D page_to_skb(vi, rq, page, offset, len, truesize, !xdp_pr=
og);
> +	head_skb =3D page_to_skb(vi, rq, page, offset, len, truesize, !xdp_pr=
og,
> +			       metasize);
>   	curr_skb =3D head_skb;
>  =20
>   	if (unlikely(!curr_skb))

