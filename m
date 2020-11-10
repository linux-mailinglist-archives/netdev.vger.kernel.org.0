Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 622B12AD490
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 12:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgKJLSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 06:18:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24209 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726219AbgKJLSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 06:18:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605007111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vhOxEeSzK0Ivy9Ku3XQdJlj82ClJuPF8szgfw0gISAs=;
        b=XXaGRfTSnJTLmYWCqofeUH3EpYcG9Lj2w/lK6ftO5mUXpUlyA3CGRyajL06aRD/bzUcZeG
        fOqaxKGDrIphnfI/phfVG7LWNs2RS9JzuznGjt3BQ3CBbqFF4ocClJOsPUE1856nJF+bWt
        e/Tl4gQ46gS5JiSTfx62XnMhNYxO2Xs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-AvPKIKGwPmilWybx0GR2yg-1; Tue, 10 Nov 2020 06:18:29 -0500
X-MC-Unique: AvPKIKGwPmilWybx0GR2yg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68B65803F74;
        Tue, 10 Nov 2020 11:18:28 +0000 (UTC)
Received: from carbon (unknown [10.36.110.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 28D6927CB7;
        Tue, 10 Nov 2020 11:18:19 +0000 (UTC)
Date:   Tue, 10 Nov 2020 12:18:18 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ilias.apalodimas@linaro.org, brouer@redhat.com
Subject: Re: [PATCH v4 net-next 1/5] net: xdp: introduce bulking for xdp tx
 return path
Message-ID: <20201110121818.39c9d7fb@carbon>
In-Reply-To: <3764c855c42d719000aa56bb946b3ddfd00971f2.1604686496.git.lorenzo@kernel.org>
References: <cover.1604686496.git.lorenzo@kernel.org>
        <3764c855c42d719000aa56bb946b3ddfd00971f2.1604686496.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 Nov 2020 19:19:07 +0100
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

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
> +
> +	rcu_read_lock();

This rcu_read_lock() shows up on my performance benchmarking, and is
unnecessary for the fast-path usage, as in most drivers DMA-TX
completion already holds the rcu_read_lock.

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



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

