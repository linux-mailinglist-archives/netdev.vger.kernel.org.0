Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCCB2A6302
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 12:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729399AbgKDLMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 06:12:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51290 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728741AbgKDLMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 06:12:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604488333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cPyO+MueesNQTpWeBHBm3FGq5qnHU+yFUkP8PGijvH8=;
        b=PGUc1UlDg6PeKbG4AaoGqLGsdoEsahlQLrFxjYsiRhglZxK+TvbbpwytmTSgit6DIjCwfA
        ALAD3OFUuyvsdUKIscWJDEayBFknSuM4bNfkFO4c2s9JDthB35l3jlVeUU5VSkDjQUqmFU
        H/IWmg0FmXaKrLkYS/I9Ybgrqjy8aMU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-ebjSSPuJNkqp3IwlpRw-Ew-1; Wed, 04 Nov 2020 06:12:11 -0500
X-MC-Unique: ebjSSPuJNkqp3IwlpRw-Ew-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AFF2F186840A;
        Wed,  4 Nov 2020 11:12:09 +0000 (UTC)
Received: from carbon (unknown [10.36.110.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 27DFF6CE4F;
        Wed,  4 Nov 2020 11:11:59 +0000 (UTC)
Date:   Wed, 4 Nov 2020 12:11:58 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ilias.apalodimas@linaro.org, brouer@redhat.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>
Subject: Re: [PATCH v3 net-next 1/5] net: xdp: introduce bulking for xdp tx
 return path
Message-ID: <20201104121158.597fa64d@carbon>
In-Reply-To: <5ef0c2886518d8ae1577c8b60ea6ef55d031673e.1604484917.git.lorenzo@kernel.org>
References: <cover.1604484917.git.lorenzo@kernel.org>
        <5ef0c2886518d8ae1577c8b60ea6ef55d031673e.1604484917.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  4 Nov 2020 11:22:54 +0100
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> XDP bulk APIs introduce a defer/flush mechanism to return
> pages belonging to the same xdp_mem_allocator object
> (identified via the mem.id field) in bulk to optimize
> I-cache and D-cache since xdp_return_frame is usually run
> inside the driver NAPI tx completion loop.
> The bulk queue size is set to 16 to be aligned to how
> XDP_REDIRECT bulking works. The bulk is flushed when
> it is full or when mem.id changes.
> xdp_frame_bulk is usually stored/allocated on the function
> call-stack to avoid locking penalties.
> Current implementation considers only page_pool memory model.
> 
> Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  include/net/xdp.h |  9 +++++++
>  net/core/xdp.c    | 61 +++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 70 insertions(+)
> 
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 3814fb631d52..a1f48a73e6df 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -104,6 +104,12 @@ struct xdp_frame {
>  	struct net_device *dev_rx; /* used by cpumap */
>  };
>  
> +#define XDP_BULK_QUEUE_SIZE	16
> +struct xdp_frame_bulk {
> +	int count;
> +	void *xa;
> +	void *q[XDP_BULK_QUEUE_SIZE];
> +};
>  
>  static inline struct skb_shared_info *
>  xdp_get_shared_info_from_frame(struct xdp_frame *frame)
> @@ -194,6 +200,9 @@ struct xdp_frame *xdp_convert_buff_to_frame(struct xdp_buff *xdp)
>  void xdp_return_frame(struct xdp_frame *xdpf);
>  void xdp_return_frame_rx_napi(struct xdp_frame *xdpf);
>  void xdp_return_buff(struct xdp_buff *xdp);
> +void xdp_flush_frame_bulk(struct xdp_frame_bulk *bq);
> +void xdp_return_frame_bulk(struct xdp_frame *xdpf,
> +			   struct xdp_frame_bulk *bq);
>  
>  /* When sending xdp_frame into the network stack, then there is no
>   * return point callback, which is needed to release e.g. DMA-mapping
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 48aba933a5a8..66ac275a0360 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -380,6 +380,67 @@ void xdp_return_frame_rx_napi(struct xdp_frame *xdpf)
>  }
>  EXPORT_SYMBOL_GPL(xdp_return_frame_rx_napi);
>  
> +/* XDP bulk APIs introduce a defer/flush mechanism to return
> + * pages belonging to the same xdp_mem_allocator object
> + * (identified via the mem.id field) in bulk to optimize
> + * I-cache and D-cache.
> + * The bulk queue size is set to 16 to be aligned to how
> + * XDP_REDIRECT bulking works. The bulk is flushed when

If this is connected, then why have you not redefined DEV_MAP_BULK_SIZE?

Cc. DPAA2 maintainers as they use this define in their drivers.
You want to make sure this driver is flexible enough for future changes.

Like:

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 3814fb631d52..44440a36f96f 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -245,6 +245,6 @@ bool xdp_attachment_flags_ok(struct xdp_attachment_info *info,
 void xdp_attachment_setup(struct xdp_attachment_info *info,
                          struct netdev_bpf *bpf);
 
-#define DEV_MAP_BULK_SIZE 16
+#define DEV_MAP_BULK_SIZE XDP_BULK_QUEUE_SIZE
 
 #endif /* __LINUX_NET_XDP_H__ */


> + * it is full or when mem.id changes.
> + * xdp_frame_bulk is usually stored/allocated on the function
> + * call-stack to avoid locking penalties.
> + */
> +void xdp_flush_frame_bulk(struct xdp_frame_bulk *bq)
> +{
> +	struct xdp_mem_allocator *xa = bq->xa;
> +	int i;
> +
> +	if (unlikely(!xa))
> +		return;
> +
> +	for (i = 0; i < bq->count; i++) {
> +		struct page *page = virt_to_head_page(bq->q[i]);
> +
> +		page_pool_put_full_page(xa->page_pool, page, false);
> +	}
> +	bq->count = 0;
> +}
> +EXPORT_SYMBOL_GPL(xdp_flush_frame_bulk);
> +
> +void xdp_return_frame_bulk(struct xdp_frame *xdpf,
> +			   struct xdp_frame_bulk *bq)
> +{
> +	struct xdp_mem_info *mem = &xdpf->mem;
> +	struct xdp_mem_allocator *xa;
> +
> +	if (mem->type != MEM_TYPE_PAGE_POOL) {
> +		__xdp_return(xdpf->data, &xdpf->mem, false);
> +		return;
> +	}
>

I cannot make up my mind: It would be a micro-optimization to move
this if-statement to include/net/xdp.h, but it will make code harder to
read/follow, and the call you replace xdp_return_frame() is also in
xdp.c with same call to _xdp_return().  Let keep it as-is. (we can
followup with micro-optimizations)


> +	rcu_read_lock();
> +
> +	xa = bq->xa;
> +	if (unlikely(!xa)) {
> +		xa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
> +		bq->count = 0;
> +		bq->xa = xa;
> +	}
> +
> +	if (bq->count == XDP_BULK_QUEUE_SIZE)
> +		xdp_flush_frame_bulk(bq);
> +
> +	if (mem->id != xa->mem.id) {
> +		xdp_flush_frame_bulk(bq);
> +		bq->xa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
> +	}
> +
> +	bq->q[bq->count++] = xdpf->data;
> +
> +	rcu_read_unlock();
> +}
> +EXPORT_SYMBOL_GPL(xdp_return_frame_bulk);
> +
>  void xdp_return_buff(struct xdp_buff *xdp)
>  {
>  	__xdp_return(xdp->data, &xdp->rxq->mem, true);



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

