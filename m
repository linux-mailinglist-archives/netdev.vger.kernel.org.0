Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC62D145CB5
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 20:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbgAVTvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 14:51:50 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52884 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726442AbgAVTvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 14:51:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579722709;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FPcSthSbcM7Vuq6oiRu0G4FuI4CgyKFmAIFuX7y1w4I=;
        b=EFEv++onxd68uYf7thn1Z4c9KXjsAdtxYe5e22DUs4n/Sg6Bv8/WY/CaXQuYXtS0B4PNeW
        uVhZvLsUFeQNA1zYOSJ7VhDYlmUdmprb9ERMmQHUuMpqPPvgWMLp4vzZ/XedgCBKjVqH2Q
        03Maec12Yh0ibvZu4rRMK+OCoO2bmsg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-F0leqwevPne0Cf6QkgNcbA-1; Wed, 22 Jan 2020 14:51:46 -0500
X-MC-Unique: F0leqwevPne0Cf6QkgNcbA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4981E800D41;
        Wed, 22 Jan 2020 19:51:44 +0000 (UTC)
Received: from carbon (ovpn-200-26.brq.redhat.com [10.40.200.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 87F061001925;
        Wed, 22 Jan 2020 19:51:34 +0000 (UTC)
Date:   Wed, 22 Jan 2020 20:51:33 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     brouer@redhat.com, sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: Re: [PATCH V3,net-next, 1/2] hv_netvsc: Add XDP support
Message-ID: <20200122205133.00688f7c@carbon>
In-Reply-To: <1579713814-36061-2-git-send-email-haiyangz@microsoft.com>
References: <1579713814-36061-1-git-send-email-haiyangz@microsoft.com>
        <1579713814-36061-2-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Jan 2020 09:23:33 -0800
Haiyang Zhang <haiyangz@microsoft.com> wrote:

> +u32 netvsc_run_xdp(struct net_device *ndev, struct netvsc_channel *nvchan,
> +		   struct xdp_buff *xdp)
> +{
> +	void *data = nvchan->rsc.data[0];
> +	u32 len = nvchan->rsc.len[0];
> +	struct page *page = NULL;
> +	struct bpf_prog *prog;
> +	u32 act = XDP_PASS;
> +
> +	xdp->data_hard_start = NULL;
> +
> +	rcu_read_lock();
> +	prog = rcu_dereference(nvchan->bpf_prog);
> +
> +	if (!prog)
> +		goto out;
> +
> +	/* allocate page buffer for data */
> +	page = alloc_page(GFP_ATOMIC);

The alloc_page() + __free_page() alone[1] cost 231 cycles(tsc) 64.395 ns.
Thus, the XDP_DROP case will already be limited to just around 10Gbit/s
14.88 Mpps (67.2ns).

XDP is suppose to be done for performance reasons. This looks like a
slowdown.

Measurement tool:
[1] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/mm/bench/page_bench01.c

> +	if (!page) {
> +		act = XDP_DROP;
> +		goto out;
> +	}
> +
> +	xdp->data_hard_start = page_address(page);
> +	xdp->data = xdp->data_hard_start + NETVSC_XDP_HDRM;
> +	xdp_set_data_meta_invalid(xdp);
> +	xdp->data_end = xdp->data + len;
> +	xdp->rxq = &nvchan->xdp_rxq;
> +	xdp->handle = 0;
> +
> +	memcpy(xdp->data, data, len);

And a memcpy.

> +
> +	act = bpf_prog_run_xdp(prog, xdp);
> +
> +	switch (act) {
> +	case XDP_PASS:
> +	case XDP_TX:
> +	case XDP_DROP:
> +		break;
> +
> +	case XDP_ABORTED:
> +		trace_xdp_exception(ndev, prog, act);
> +		break;
> +
> +	default:
> +		bpf_warn_invalid_xdp_action(act);
> +	}
> +
> +out:
> +	rcu_read_unlock();
> +
> +	if (page && act != XDP_PASS && act != XDP_TX) {
> +		__free_page(page);

Given this runs under NAPI you could optimize this easily for XDP_DROP
(and XDP_ABORTED) by recycling the page in a driver local cache. (The
page_pool also have a driver local cache build in, but it might be
overkill to use page_pool in this simple case).

You could do this in a followup patch.

> +		xdp->data_hard_start = NULL;
> +	}
> +
> +	return act;
> +}



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

