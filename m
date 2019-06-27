Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1A657997
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 04:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbfF0ClI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 22:41:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53614 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726663AbfF0ClI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 22:41:08 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 651A030811C7;
        Thu, 27 Jun 2019 02:41:03 +0000 (UTC)
Received: from [10.72.12.196] (ovpn-12-196.pek2.redhat.com [10.72.12.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5AA1960856;
        Thu, 27 Jun 2019 02:40:56 +0000 (UTC)
Subject: Re: [PATCH bpf-next] virtio_net: add XDP meta data support in
 receive_small()
To:     Yuya Kusakabe <yuya.kusakabe@gmail.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, "Michael S. Tsirkin" <mst@redhat.com>
References: <20190627023332.8557-1-yuya.kusakabe@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <74dc4919-cf27-b058-5996-5af4d9acbd77@redhat.com>
Date:   Thu, 27 Jun 2019 10:40:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190627023332.8557-1-yuya.kusakabe@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Thu, 27 Jun 2019 02:41:08 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/6/27 上午10:33, Yuya Kusakabe wrote:
> This adds XDP meta data support to the code path receive_small().
>
> mrg_rxbuf=off is required on qemu, because receive_mergeable() still
> doesn't support XDP meta data.


What's the reason for this?


>
> Fixes: de8f3a83b0a0 ("bpf: add meta pointer for direct access")
> Signed-off-by: Yuya Kusakabe <yuya.kusakabe@gmail.com>


Could you please cc virtio maintainer through get_maintainer.pl?

Thanks


> ---
>   drivers/net/virtio_net.c | 10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 4f3de0ac8b0b..14165c5edb7d 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -644,6 +644,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
>   	unsigned int delta = 0;
>   	struct page *xdp_page;
>   	int err;
> +	unsigned int metasize = 0;
>   
>   	len -= vi->hdr_len;
>   	stats->bytes += len;
> @@ -683,8 +684,8 @@ static struct sk_buff *receive_small(struct net_device *dev,
>   
>   		xdp.data_hard_start = buf + VIRTNET_RX_PAD + vi->hdr_len;
>   		xdp.data = xdp.data_hard_start + xdp_headroom;
> -		xdp_set_data_meta_invalid(&xdp);
>   		xdp.data_end = xdp.data + len;
> +		xdp.data_meta = xdp.data;
>   		xdp.rxq = &rq->xdp_rxq;
>   		orig_data = xdp.data;
>   		act = bpf_prog_run_xdp(xdp_prog, &xdp);
> @@ -695,9 +696,11 @@ static struct sk_buff *receive_small(struct net_device *dev,
>   			/* Recalculate length in case bpf program changed it */
>   			delta = orig_data - xdp.data;
>   			len = xdp.data_end - xdp.data;
> +			metasize = xdp.data - xdp.data_meta;
>   			break;
>   		case XDP_TX:
>   			stats->xdp_tx++;
> +			xdp.data_meta = xdp.data;
>   			xdpf = convert_to_xdp_frame(&xdp);
>   			if (unlikely(!xdpf))
>   				goto err_xdp;
> @@ -735,11 +738,14 @@ static struct sk_buff *receive_small(struct net_device *dev,
>   	}
>   	skb_reserve(skb, headroom - delta);
>   	skb_put(skb, len);
> -	if (!delta) {
> +	if (!delta && !metasize) {
>   		buf += header_offset;
>   		memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);
>   	} /* keep zeroed vnet hdr since packet was changed by bpf */
>   
> +	if (metasize)
> +		skb_metadata_set(skb, metasize);
> +
>   err:
>   	return skb;
>   
