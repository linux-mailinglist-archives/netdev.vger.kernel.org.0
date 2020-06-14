Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F22B1F87A3
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 10:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbgFNIYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 04:24:12 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:53570 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725265AbgFNIYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jun 2020 04:24:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592123050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bAA8tAwvCqEnEOZtu0sfJMj8YHNywNJG8Pv3ts+oZ/8=;
        b=L+waR3OaQmuo7c2/dYvXQzblEteHt1xmNnSntxapwNaOCfggxWgP87WtN74jmMmHs1FYqi
        E2C8JCghzi1MPRRHjNDGfVbO61R+21KB9wiaGX818kHZdygTsvl4LBp6tOPtN1PrYPf7aR
        oqbNLQKX5fpZFRdI+8STIIB10ouZfmE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-MuaEctJNPGW8ezW78XZSAQ-1; Sun, 14 Jun 2020 04:23:51 -0400
X-MC-Unique: MuaEctJNPGW8ezW78XZSAQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F719BFC0;
        Sun, 14 Jun 2020 08:23:49 +0000 (UTC)
Received: from carbon (unknown [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0DAB52B4D8;
        Sun, 14 Jun 2020 08:23:44 +0000 (UTC)
Date:   Sun, 14 Jun 2020 10:23:43 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Sven Auhagen <sven.auhagen@voleatech.de>
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        lorenzo@kernel.org, brouer@redhat.com
Subject: Re: [PATCH 1/1] mvneta: fix prefetch location
Message-ID: <20200614102343.47837452@carbon>
In-Reply-To: <20200614071128.4ezfcyhjesot4vvr@SvensMacBookAir.sven.lan>
References: <20200614071128.4ezfcyhjesot4vvr@SvensMacBookAir.sven.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 14 Jun 2020 09:11:28 +0200
Sven Auhagen <sven.auhagen@voleatech.de> wrote:

> The packet header prefetch is at an offset
> now. Correct the prefetch address.
> 
> Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> ---
>  drivers/net/ethernet/marvell/mvneta.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index 51889770958d..344fc5f649b4 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -2229,7 +2229,7 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
>  				len, dma_dir);
>  
>  	/* Prefetch header */
> -	prefetch(data);
> +	prefetch(data + pp->rx_offset_correction + MVNETA_MH_SIZE);

The comment does say "header", so I guess your change is correct if we
are talking about the packet header.

Currently this prefetch will help XDP-redirect, as it store xdp_frame
in this area.

>  	xdp->data_hard_start = data;
>  	xdp->data = data + pp->rx_offset_correction + MVNETA_MH_SIZE;

If you really need to prefetch the packet headers, it would be the same
as calling prefetch(xdp->data), right?

Have you benchmarked that this prefetch is a benefit?

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

