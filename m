Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD06D2DBCC4
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 09:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbgLPIhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 03:37:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58040 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725819AbgLPIhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 03:37:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608107758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=saH67GkyhVIKCCcRqSzTIOd1hMIkUjAXCx4g+f8BafU=;
        b=Kq/E/W6eI45P/KYUcD2swcQwI1legIu1Hbk6XhA6B30de3bi5ZQemcZT7RGQV6K5QWTQrI
        bXe+V/o9x8LWNTTfQndLdfCCDC8Egmy6NsbUZrAC1dx69ukW3Z7UCl1jfcfe1NYSs6oM9q
        Vtf5fsb2LCNhpzTxrDkt8Euu8xVY0HA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-n-YLhPFIOYacNy8Z3WBdzg-1; Wed, 16 Dec 2020 03:35:56 -0500
X-MC-Unique: n-YLhPFIOYacNy8Z3WBdzg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C36D800D55;
        Wed, 16 Dec 2020 08:35:54 +0000 (UTC)
Received: from carbon (unknown [10.36.110.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 211FC5D9D7;
        Wed, 16 Dec 2020 08:35:44 +0000 (UTC)
Date:   Wed, 16 Dec 2020 09:35:43 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, alexander.duyck@gmail.com,
        maciej.fijalkowski@intel.com, saeed@kernel.org, brouer@redhat.com
Subject: Re: [PATCH v3 bpf-next 1/2] net: xdp: introduce xdp_init_buff
 utility routine
Message-ID: <20201216093543.73836860@carbon>
In-Reply-To: <1125364c807a24e03cfdc1901913181fe1457d42.1607794552.git.lorenzo@kernel.org>
References: <cover.1607794551.git.lorenzo@kernel.org>
        <1125364c807a24e03cfdc1901913181fe1457d42.1607794552.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 12 Dec 2020 18:41:48 +0100
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
> index fcc262064766..b7942c3440c0 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
> @@ -133,12 +133,11 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
>  	dma_sync_single_for_cpu(&pdev->dev, mapping + offset, *len, bp->rx_dir);
>  
>  	txr = rxr->bnapi->tx_ring;
> +	xdp_init_buff(&xdp, PAGE_SIZE, &rxr->xdp_rxq);
>  	xdp.data_hard_start = *data_ptr - offset;
>  	xdp.data = *data_ptr;
>  	xdp_set_data_meta_invalid(&xdp);
>  	xdp.data_end = *data_ptr + *len;
> -	xdp.rxq = &rxr->xdp_rxq;
> -	xdp.frame_sz = PAGE_SIZE; /* BNXT_RX_PAGE_MODE(bp) when XDP enabled */
>  	orig_data = xdp.data;

I don't like loosing the comment here.  Other developers reading this
code might assume that size is always PAGE_SIZE, which is only the case
when XDP is enabled.  Lets save them from making this mistake.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

