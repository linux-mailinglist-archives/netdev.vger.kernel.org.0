Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75AAE354AB8
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 04:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241997AbhDFCE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 22:04:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48310 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238649AbhDFCE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 22:04:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617674690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sH97MFKF8uXZip+Q4jKHFeUMjs56HEFxm9EQqtnNF/I=;
        b=IU04DAHd5aF1CQufLB/TG3USTOMJWuocfR7phsqkvL4X2VGbn3huqqV3p/eyE+cxWmlECO
        7kTI7Ugb4JKCOwYn18Gfv+RhO3M9CEI3qkEENcJMC0/RZMEjxppSzayoNCDA3vqmb8W+p3
        k5DfNmEp3fTFGaST0QeCYYhikem2vXU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-B1KNjSJYNs2ioCoHWhKYKg-1; Mon, 05 Apr 2021 22:04:48 -0400
X-MC-Unique: B1KNjSJYNs2ioCoHWhKYKg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DCB0D18C43C2;
        Tue,  6 Apr 2021 02:04:46 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-96.pek2.redhat.com [10.72.13.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2424A19C78;
        Tue,  6 Apr 2021 02:04:39 +0000 (UTC)
Subject: Re: [PATCH net] net: avoid 32 x truesize under-estimation for tiny
 skbs
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Thelen <gthelen@google.com>,
        "David S.Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, su-lifan@linux.alibaba.com,
        "dust.li" <dust.li@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eric Dumazet <edumazet@google.com>
References: <1617361253.1788838-2-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <56eaaf7c-a9f1-c631-737a-8ec0b09d7f65@redhat.com>
Date:   Tue, 6 Apr 2021 10:04:37 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <1617361253.1788838-2-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/4/2 ÏÂÎç7:00, Xuan Zhuo Ð´µÀ:
> On Fri, 2 Apr 2021 10:52:12 +0800, Jason Wang <jasowang@redhat.com> wrote:
>> So I wonder something like the following like this help. We know the
>> frag size, that means, if we know there's sufficient tailroom we can use
>> build_skb() without reserving dedicated room for skb_shared_info.
>>
>> Thanks
>>
>>
> Do you mean so?
>
> I have also considered this scenario, although build_skb is not always used, but
> it is also very good for the right situation.


Something like this. Would you mind to post a formal patch to net-next 
with some perf numbers?

Thanks


>
> Thanks.
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index bb4ea9dbc16b..3db207c67422 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -383,17 +383,12 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>   {
>   	struct sk_buff *skb;
>   	struct virtio_net_hdr_mrg_rxbuf *hdr;
> -	unsigned int copy, hdr_len, hdr_padded_len;
> -	char *p;
> +	unsigned int copy, hdr_len, hdr_padded_len, shinfo_size;
> +	char *p, *hdr_p;
>
>   	p = page_address(page) + offset;
> +	hdr_p = p;
>
> -	/* copy small packet so we can reuse these pages for small data */
> -	skb = napi_alloc_skb(&rq->napi, GOOD_COPY_LEN);
> -	if (unlikely(!skb))
> -		return NULL;
> -
> -	hdr = skb_vnet_hdr(skb);
>
>   	hdr_len = vi->hdr_len;
>   	if (vi->mergeable_rx_bufs)
> @@ -401,27 +396,57 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>   	else
>   		hdr_padded_len = sizeof(struct padded_vnet_hdr);
>
> -	/* hdr_valid means no XDP, so we can copy the vnet header */
> -	if (hdr_valid)
> -		memcpy(hdr, p, hdr_len);
> -
>   	len -= hdr_len;
>   	offset += hdr_padded_len;
>   	p += hdr_padded_len;
>
> -	copy = len;
> -	if (copy > skb_tailroom(skb))
> -		copy = skb_tailroom(skb);
> -	skb_put_data(skb, p, copy);
> +	shinfo_size = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> +
> +	if (truesize - len - hdr_len >= shinfo_size && len > GOOD_COPY_LEN) {
> +		skb = build_skb(p, truesize);
> +		if (unlikely(!skb))
> +			return NULL;
> +
> +		skb_put(skb, len);
> +
> +		/* hdr_valid means no XDP, so we can copy the vnet header */
> +		if (hdr_valid) {
> +			hdr = skb_vnet_hdr(skb);
> +			memcpy(hdr, hdr_p, hdr_len);
> +		}
> +
> +		if (metasize) {
> +			__skb_pull(skb, metasize);
> +			skb_metadata_set(skb, metasize);
> +		}
> +
> +		return skb;
> +	} else {
> +		/* copy small packet so we can reuse these pages for small data */
> +		skb = napi_alloc_skb(&rq->napi, GOOD_COPY_LEN);
> +		if (unlikely(!skb))
> +			return NULL;
> +
> +		copy = len;
> +		if (copy > skb_tailroom(skb))
> +			copy = skb_tailroom(skb);
> +		skb_put_data(skb, p, copy);
> +
> +		len -= copy;
> +		offset += copy;
> +	}
> +
> +	hdr = skb_vnet_hdr(skb);
> +
> +	/* hdr_valid means no XDP, so we can copy the vnet header */
> +	if (hdr_valid)
> +		memcpy(hdr, hdr_p, hdr_len);
>
>   	if (metasize) {
>   		__skb_pull(skb, metasize);
>   		skb_metadata_set(skb, metasize);
>   	}
>
> -	len -= copy;
> -	offset += copy;
> -
>   	if (vi->mergeable_rx_bufs) {
>   		if (len)
>   			skb_add_rx_frag(skb, 0, page, offset, len, truesize);
>

