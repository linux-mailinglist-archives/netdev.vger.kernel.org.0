Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC5C354D22
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 08:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233453AbhDFG4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 02:56:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59047 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233190AbhDFG4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 02:56:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617692153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dX5orlTGdb4bJ6Az1N9tjYF5g2lu2ijEDoMKzlNTE8g=;
        b=Yg6M1zWsZZrKMVTMCdOvhqCx/GDaVhE+915kUxnGX5DT/w9HGy8kelYBUFn1E7oC21XiEA
        6DEUgHCfF7YYjAEALJl2vySjHOKNe0giXrl5hetqnTKiz6NlEaaaDUwS6VhEQEvPuwVWfc
        Ns4EaXdlg27pMsAGNp0HW2PYTUe+yas=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-CdEy8GphMMC26czYaIQ2nQ-1; Tue, 06 Apr 2021 02:55:49 -0400
X-MC-Unique: CdEy8GphMMC26czYaIQ2nQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7824F1922020;
        Tue,  6 Apr 2021 06:55:47 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-95.pek2.redhat.com [10.72.13.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 09BD65D9DC;
        Tue,  6 Apr 2021 06:55:37 +0000 (UTC)
Subject: Re: [PATCH net-next v3 5/8] virtio-net: xsk zero copy xmit support
 xsk unaligned mode
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        Dust Li <dust.li@linux.alibaba.com>
References: <20210331071139.15473-1-xuanzhuo@linux.alibaba.com>
 <20210331071139.15473-6-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <44b460db-d852-7151-9833-21fed25ecdc7@redhat.com>
Date:   Tue, 6 Apr 2021 14:55:36 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210331071139.15473-6-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/3/31 ÏÂÎç3:11, Xuan Zhuo Ð´µÀ:
> In xsk unaligned mode, the frame pointed to by desc may span two
> consecutive pages, but not more than two pages.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Reviewed-by: Dust Li <dust.li@linux.alibaba.com>


I'd squash this patch into patch 4.


> ---
>   drivers/net/virtio_net.c | 30 ++++++++++++++++++++++++------
>   1 file changed, 24 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index c8a317a93ef7..259fafcf6028 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -2562,24 +2562,42 @@ static void virtnet_xsk_check_space(struct send_queue *sq)
>   static int virtnet_xsk_xmit(struct send_queue *sq, struct xsk_buff_pool *pool,
>   			    struct xdp_desc *desc)
>   {
> +	u32 offset, n, i, copy, copied;


Let's use a better name since we don't actually copy anything here.


>   	struct virtnet_info *vi;
>   	struct page *page;
>   	void *data;
> -	u32 offset;
> +	int err, m;
>   	u64 addr;
> -	int err;
>   
>   	vi = sq->vq->vdev->priv;
>   	addr = desc->addr;
> +
>   	data = xsk_buff_raw_get_data(pool, addr);
> +
>   	offset = offset_in_page(data);
> +	m = desc->len - (PAGE_SIZE - offset);
> +	/* xsk unaligned mode, desc will use two page */
> +	if (m > 0)
> +		n = 3;
> +	else
> +		n = 2;
>   
> -	sg_init_table(sq->sg, 2);
> +	sg_init_table(sq->sg, n);
>   	sg_set_buf(sq->sg, &xsk_hdr, vi->hdr_len);
> -	page = xsk_buff_xdp_get_page(pool, addr);
> -	sg_set_page(sq->sg + 1, page, desc->len, offset);
>   
> -	err = virtqueue_add_outbuf(sq->vq, sq->sg, 2, NULL, GFP_ATOMIC);
> +	copied = 0;
> +	for (i = 1; i < n; ++i) {
> +		copy = min_t(int, desc->len - copied, PAGE_SIZE - offset);
> +
> +		page = xsk_buff_xdp_get_page(pool, addr + copied);
> +
> +		sg_set_page(sq->sg + i, page, copy, offset);
> +		copied += copy;
> +		if (offset)
> +			offset = 0;
> +	}


Can we simplify the codes by using while here? Then I think we don't 
need to determine the value of n.

Thanks


> +
> +	err = virtqueue_add_outbuf(sq->vq, sq->sg, n, NULL, GFP_ATOMIC);
>   	if (unlikely(err))
>   		sq->xsk.last_desc = *desc;
>   

