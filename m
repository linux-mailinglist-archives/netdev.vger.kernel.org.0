Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 205C4152585
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 05:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727949AbgBEELD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 23:11:03 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45627 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727832AbgBEELC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 23:11:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580875859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mZTJknh5sK2MHEpZvb12IRTeffrqu13C1stnHofSxGc=;
        b=i2c9SGzPwJjBraJ0xuFwFHw0Hf5RbezHTExtE72hHC3dGdvowqdokuHTEX/adsHtP+tumn
        QpE4CH4rHOFxJ+ZPkn8R+SqgRNRWq9KQp2XSC35+0g8XgU0YaaEfmVKAjD5e15XOIaSOGQ
        u2jWAet/us/cgJXxR54Y4+7WlUSVjC8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-cUk5z23YN_Se3RSdtgiohw-1; Tue, 04 Feb 2020 23:10:55 -0500
X-MC-Unique: cUk5z23YN_Se3RSdtgiohw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D114D1081FA1;
        Wed,  5 Feb 2020 04:10:52 +0000 (UTC)
Received: from [10.72.13.188] (ovpn-13-188.pek2.redhat.com [10.72.13.188])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F17277792B;
        Wed,  5 Feb 2020 04:10:44 +0000 (UTC)
Subject: Re: [PATCH bpf-next v4] virtio_net: add XDP meta data support
To:     Yuya Kusakabe <yuya.kusakabe@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        mst@redhat.com, songliubraving@fb.com, yhs@fb.com, kuba@kernel.org,
        andriin@fb.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <8da1b560-3128-b885-b453-13de5c7431fb@redhat.com>
 <20200204071655.94474-1-yuya.kusakabe@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <9a0a1469-c8a7-8223-a4d5-dad656a142fc@redhat.com>
Date:   Wed, 5 Feb 2020 12:10:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200204071655.94474-1-yuya.kusakabe@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/4 =E4=B8=8B=E5=8D=883:16, Yuya Kusakabe wrote:
> Implement support for transferring XDP meta data into skb for
> virtio_net driver; before calling into the program, xdp.data_meta point=
s
> to xdp.data and copy vnet header to the front of xdp.data_hard_start
> to avoid overwriting it, where on program return with pass verdict,
> we call into skb_metadata_set().
>
> Fixes: de8f3a83b0a0 ("bpf: add meta pointer for direct access")
> Signed-off-by: Yuya Kusakabe <yuya.kusakabe@gmail.com>
> ---
>   drivers/net/virtio_net.c | 47 ++++++++++++++++++++++++++++-----------=
-
>   1 file changed, 33 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 2fe7a3188282..5fdd6ea0e3f1 100644
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
> @@ -393,7 +393,7 @@ static struct sk_buff *page_to_skb(struct virtnet_i=
nfo *vi,
>   	else
>   		hdr_padded_len =3D sizeof(struct padded_vnet_hdr);
>  =20
> -	if (hdr_valid)
> +	if (hdr_valid && !metasize)


hdr_valid means no XDP, so I think we can remove the check for metasize=20
here and add a comment instead?


>   		memcpy(hdr, p, hdr_len);
>  =20
>   	len -=3D hdr_len;
> @@ -405,6 +405,11 @@ static struct sk_buff *page_to_skb(struct virtnet_=
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
> @@ -644,6 +649,7 @@ static struct sk_buff *receive_small(struct net_dev=
ice *dev,
>   	unsigned int delta =3D 0;
>   	struct page *xdp_page;
>   	int err;
> +	unsigned int metasize =3D 0;
>  =20
>   	len -=3D vi->hdr_len;
>   	stats->bytes +=3D len;
> @@ -683,10 +689,15 @@ static struct sk_buff *receive_small(struct net_d=
evice *dev,
>  =20
>   		xdp.data_hard_start =3D buf + VIRTNET_RX_PAD + vi->hdr_len;
>   		xdp.data =3D xdp.data_hard_start + xdp_headroom;
> -		xdp_set_data_meta_invalid(&xdp);
>   		xdp.data_end =3D xdp.data + len;
> +		xdp.data_meta =3D xdp.data;
>   		xdp.rxq =3D &rq->xdp_rxq;
>   		orig_data =3D xdp.data;
> +		/* Copy the vnet header to the front of data_hard_start to avoid
> +		 * overwriting it by XDP meta data.
> +		 */
> +		memcpy(xdp.data_hard_start - vi->hdr_len,
> +		       xdp.data - vi->hdr_len, vi->hdr_len);


I think we don't need this. And it looks to me there's a bug in the=20
current code.

Commit 436c9453a1ac0 ("virtio-net: keep vnet header zeroed after=20
processing XDP") leave the a corner case for receive_small() which still=20
use:

 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!delta) {
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 buf +=3D header_offset;
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } /* keep zeroed vnet hdr sin=
ce packet was changed by bpf */

Which seems wrong, we need check xdp_prog instead of delta.

With this fixed, there's no need to care about the vnet header here=20
since we don't know whether or not packet is modified by XDP.


>   		act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
>   		stats->xdp_packets++;
>  =20
> @@ -695,9 +706,11 @@ static struct sk_buff *receive_small(struct net_de=
vice *dev,
>   			/* Recalculate length in case bpf program changed it */
>   			delta =3D orig_data - xdp.data;
>   			len =3D xdp.data_end - xdp.data;
> +			metasize =3D xdp.data - xdp.data_meta;
>   			break;
>   		case XDP_TX:
>   			stats->xdp_tx++;
> +			xdp.data_meta =3D xdp.data;


I think we should remove the xdp_set_data_meta_invalid() at least? And=20
move this initialization just after xdp.data is initialized.

Testing receive_small() requires to disable mrg_rxbuf, guest_tso4,=20
guest_tso6 and guest_ufo from qemu command line.


>   			xdpf =3D convert_to_xdp_frame(&xdp);
>   			if (unlikely(!xdpf))
>   				goto err_xdp;
> @@ -736,10 +749,12 @@ static struct sk_buff *receive_small(struct net_d=
evice *dev,
>   	skb_reserve(skb, headroom - delta);
>   	skb_put(skb, len);
>   	if (!delta) {


Need to check xdp_prog (need another patch).


> -		buf +=3D header_offset;
> -		memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);
> +		memcpy(skb_vnet_hdr(skb), buf + VIRTNET_RX_PAD, vi->hdr_len);
>   	} /* keep zeroed vnet hdr since packet was changed by bpf */
>  =20
> +	if (metasize)
> +		skb_metadata_set(skb, metasize);
> +
>   err:
>   	return skb;
>  =20
> @@ -760,8 +775,8 @@ static struct sk_buff *receive_big(struct net_devic=
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
> @@ -793,6 +808,7 @@ static struct sk_buff *receive_mergeable(struct net=
_device *dev,
>   	unsigned int truesize;
>   	unsigned int headroom =3D mergeable_ctx_to_headroom(ctx);
>   	int err;
> +	unsigned int metasize =3D 0;
>  =20
>   	head_skb =3D NULL;
>   	stats->bytes +=3D len - vi->hdr_len;
> @@ -839,8 +855,8 @@ static struct sk_buff *receive_mergeable(struct net=
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
> @@ -852,8 +868,9 @@ static struct sk_buff *receive_mergeable(struct net=
_device *dev,
>   			 * adjustments. Note other cases do not build an
>   			 * skb and avoid using offset
>   			 */
> -			offset =3D xdp.data -
> -					page_address(xdp_page) - vi->hdr_len;
> +			metasize =3D xdp.data - xdp.data_meta;
> +			offset =3D xdp.data - page_address(xdp_page) -
> +				 vi->hdr_len - metasize;
>  =20
>   			/* recalculate len if xdp.data or xdp.data_end were
>   			 * adjusted
> @@ -863,14 +880,15 @@ static struct sk_buff *receive_mergeable(struct n=
et_device *dev,
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
>   		case XDP_TX:
>   			stats->xdp_tx++;
> +			xdp.data_meta =3D xdp.data;


Any reason for doing this?

Thanks


>   			xdpf =3D convert_to_xdp_frame(&xdp);
>   			if (unlikely(!xdpf))
>   				goto err_xdp;
> @@ -921,7 +939,8 @@ static struct sk_buff *receive_mergeable(struct net=
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

