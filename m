Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91EC860587
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 13:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728720AbfGELqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 07:46:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56846 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728316AbfGELqN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 07:46:13 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CC9E63082DD3;
        Fri,  5 Jul 2019 11:46:12 +0000 (UTC)
Received: from carbon (ovpn-200-17.brq.redhat.com [10.40.200.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D7F052C5;
        Fri,  5 Jul 2019 11:46:07 +0000 (UTC)
Date:   Fri, 5 Jul 2019 13:46:06 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, jaswinder.singh@linaro.org,
        ard.biesheuvel@linaro.org, arnd@arndb.de, brouer@redhat.com
Subject: Re: [net-next, PATCH, v3] net: netsec: Sync dma for device on
 buffer allocation
Message-ID: <20190705134606.6a4ffde8@carbon>
In-Reply-To: <1562323667-6945-1-git-send-email-ilias.apalodimas@linaro.org>
References: <1562323667-6945-1-git-send-email-ilias.apalodimas@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Fri, 05 Jul 2019 11:46:12 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  5 Jul 2019 13:47:47 +0300
Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:

> Quoting Arnd,
> We have to do a sync_single_for_device /somewhere/ before the
> buffer is given to the device. On a non-cache-coherent machine with
> a write-back cache, there may be dirty cache lines that get written back
> after the device DMA's data into it (e.g. from a previous memset
> from before the buffer got freed), so you absolutely need to flush any
> dirty cache lines on it first.
> 
> Since the coherency is configurable in this device make sure we cover
> all configurations by explicitly syncing the allocated buffer for the
> device before refilling it's descriptors
> 
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> ---
> Changes since v2:
> - Only sync for the portion of the packet owned by the NIC as suggested by 
>   Jesper

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

Some general comments below.

>  drivers/net/ethernet/socionext/netsec.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
> index 5544a722543f..6b954ad88842 100644
> --- a/drivers/net/ethernet/socionext/netsec.c
> +++ b/drivers/net/ethernet/socionext/netsec.c
> @@ -727,6 +727,7 @@ static void *netsec_alloc_rx_data(struct netsec_priv *priv,
>  {
>  
>  	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_RX];
> +	enum dma_data_direction dma_dir;
>  	struct page *page;
>  
>  	page = page_pool_dev_alloc_pages(dring->page_pool);
> @@ -742,6 +743,8 @@ static void *netsec_alloc_rx_data(struct netsec_priv *priv,
>  	 * cases and reserve enough space for headroom + skb_shared_info
>  	 */
>  	*desc_len = PAGE_SIZE - NETSEC_RX_BUF_NON_DATA;
> +	dma_dir = page_pool_get_dma_dir(dring->page_pool);
> +	dma_sync_single_for_device(priv->dev, *dma_handle, *desc_len, dma_dir);

Following the API this seems to turn into a noop if dev_is_dma_coherent().

Thus, I don't think it is worth optimizing further, as I suggested
earlier, with only sync of previous packet length.   This sync of the
"full" possible payload-data area (without headroom) is likely the best
and simplest option.  I don't think we should extend and complicate
the API for optimizing for non-coherent DMA hardware.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
