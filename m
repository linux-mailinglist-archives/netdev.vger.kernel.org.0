Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6A4278566
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 12:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbgIYKw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 06:52:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59800 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727044AbgIYKw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 06:52:28 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601031147;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dieT+Ca9pKnYdBmJINGnKiDMU0fSqIZ9el8V16JMejw=;
        b=f65xly0ttacJ0juv1NKLHgatyeIdf7tOi9Vj5Munz8ekw1zR637KZizOzueOIfP1QfFUYk
        3RpInK/LpsNgZSO8O+w40g2+y0y56KGNkz9AyrCZlRMCtfdUXOQxn4a4XbffoMp+7uGlRU
        DP1qUGwj754mv9x2AwAKLzppW2AQwpw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-NjCLE60VNZOq3kgRrJ9bLg-1; Fri, 25 Sep 2020 06:52:23 -0400
X-MC-Unique: NjCLE60VNZOq3kgRrJ9bLg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 61460106B81D;
        Fri, 25 Sep 2020 10:52:22 +0000 (UTC)
Received: from carbon (unknown [10.36.110.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 587DC1002382;
        Fri, 25 Sep 2020 10:52:14 +0000 (UTC)
Date:   Fri, 25 Sep 2020 12:52:13 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com,
        thomas.petazzoni@bootlin.com, brouer@redhat.com
Subject: Re: [PATCH net-next] net: mvneta: try to use in-irq pp cache in
 mvneta_txq_bufs_free
Message-ID: <20200925125213.4981cff8@carbon>
In-Reply-To: <4f6602e98fdaef1610e948acec19a5de51fb136e.1601027617.git.lorenzo@kernel.org>
References: <4f6602e98fdaef1610e948acec19a5de51fb136e.1601027617.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Sep 2020 12:01:32 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Try to recycle the xdp tx buffer into the in-irq page_pool cache if
> mvneta_txq_bufs_free is executed in the NAPI context.

NACK - I don't think this is safe.  That is also why I named the
function postfix rx_napi.  The page pool->alloc.cache is associated
with the drivers RX-queue.  The xdp_frame's that gets freed could be
coming from a remote driver that use page_pool. This remote drivers
RX-queue processing can run concurrently on a different CPU, than this
drivers TXQ-cleanup.

If you want to speedup this, I instead suggest that you add a
xdp_return_frame_bulk API.


> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/marvell/mvneta.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index 14df3aec285d..646fbf4ed638 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -1831,7 +1831,7 @@ static struct mvneta_tx_queue *mvneta_tx_done_policy(struct mvneta_port *pp,
>  /* Free tx queue skbuffs */
>  static void mvneta_txq_bufs_free(struct mvneta_port *pp,
>  				 struct mvneta_tx_queue *txq, int num,
> -				 struct netdev_queue *nq)
> +				 struct netdev_queue *nq, bool napi)
>  {
>  	unsigned int bytes_compl = 0, pkts_compl = 0;
>  	int i;
> @@ -1854,7 +1854,10 @@ static void mvneta_txq_bufs_free(struct mvneta_port *pp,
>  			dev_kfree_skb_any(buf->skb);
>  		} else if (buf->type == MVNETA_TYPE_XDP_TX ||
>  			   buf->type == MVNETA_TYPE_XDP_NDO) {
> -			xdp_return_frame(buf->xdpf);
> +			if (napi)
> +				xdp_return_frame_rx_napi(buf->xdpf);
> +			else
> +				xdp_return_frame(buf->xdpf);
>  		}
>  	}
>  
> @@ -1872,7 +1875,7 @@ static void mvneta_txq_done(struct mvneta_port *pp,
>  	if (!tx_done)
>  		return;
>  
> -	mvneta_txq_bufs_free(pp, txq, tx_done, nq);
> +	mvneta_txq_bufs_free(pp, txq, tx_done, nq, true);
>  
>  	txq->count -= tx_done;
>  
> @@ -2859,7 +2862,7 @@ static void mvneta_txq_done_force(struct mvneta_port *pp,
>  	struct netdev_queue *nq = netdev_get_tx_queue(pp->dev, txq->id);
>  	int tx_done = txq->count;
>  
> -	mvneta_txq_bufs_free(pp, txq, tx_done, nq);
> +	mvneta_txq_bufs_free(pp, txq, tx_done, nq, false);
>  
>  	/* reset txq */
>  	txq->count = 0;



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

