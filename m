Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D73613A7C4
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 11:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728969AbgANK7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 05:59:16 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:46438 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725842AbgANK7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 05:59:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578999554;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cx6M/ay2VP3TtsvfKvOKKwJTow29zDs/AI/wXoULhOA=;
        b=ZUNY46oZKjh5l0mFqnN/tTjA4wivU8r36/0AIvAHga5ZWN32c0wAyfwG5EkT4OwMqA9VFw
        /u7LGKNa2HzrbROJL8Yq3RACpn++7cXbWaBr/LACC+Shsy3SFO0j6EnhcVwQ5t4NkEA1+Y
        Vmi0OAwVB5Xd5wHqs318WTn2HWvmCaU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-jmKbBgMkPRmZuF6NQyABFw-1; Tue, 14 Jan 2020 05:59:12 -0500
X-MC-Unique: jmKbBgMkPRmZuF6NQyABFw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C598107ACC9;
        Tue, 14 Jan 2020 10:59:11 +0000 (UTC)
Received: from carbon (ovpn-200-25.brq.redhat.com [10.40.200.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1EEC9675AF;
        Tue, 14 Jan 2020 10:59:03 +0000 (UTC)
Date:   Tue, 14 Jan 2020 11:59:02 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, ilias.apalodimas@linaro.org, kuba@kernel.org,
        brouer@redhat.com
Subject: Re: [PATCH v3 net-next] net: socionext: get rid of huge dma sync in
 netsec_alloc_rx_data
Message-ID: <20200114115902.29062fbb@carbon>
In-Reply-To: <1fce975f9f77780b92b86dbaf1ca89ffe37255bb.1578993365.git.lorenzo@kernel.org>
References: <1fce975f9f77780b92b86dbaf1ca89ffe37255bb.1578993365.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jan 2020 10:24:19 +0100
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Socionext driver can run on dma coherent and non-coherent devices.
> Get rid of huge dma_sync_single_for_device in netsec_alloc_rx_data since
> now the driver can let page_pool API to managed needed DMA sync
> 
> Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
> Changes since v2:
> - fix checkpatch warnings
> 
> Changes since v1:
> - rely on original frame size for dma sync
> ---
>  drivers/net/ethernet/socionext/netsec.c | 43 +++++++++++++++----------
>  1 file changed, 26 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
> index b5a9e947a4a8..6870a6ce76a6 100644
> --- a/drivers/net/ethernet/socionext/netsec.c
> +++ b/drivers/net/ethernet/socionext/netsec.c
[...]

> @@ -883,6 +881,8 @@ static u32 netsec_xdp_xmit_back(struct netsec_priv *priv, struct xdp_buff *xdp)
>  static u32 netsec_run_xdp(struct netsec_priv *priv, struct bpf_prog *prog,
>  			  struct xdp_buff *xdp)
>  {
> +	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_RX];
> +	unsigned int len = xdp->data_end - xdp->data;

This is correct because you calc len before BPF-prog can change these,
and because we can currently only shrink tail (data_end).

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

