Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8305826B
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 14:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfF0MXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 08:23:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45372 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726308AbfF0MXZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 08:23:25 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 08664307D90F;
        Thu, 27 Jun 2019 12:23:15 +0000 (UTC)
Received: from carbon (ovpn-200-45.brq.redhat.com [10.40.200.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C2A1260BE0;
        Thu, 27 Jun 2019 12:23:06 +0000 (UTC)
Date:   Thu, 27 Jun 2019 14:23:05 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, jaswinder.singh@linaro.org,
        ard.biesheuvel@linaro.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, daniel@iogearbox.net, ast@kernel.org,
        makita.toshiaki@lab.ntt.co.jp, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, davem@davemloft.net, brouer@redhat.com
Subject: Re: [RFC, PATCH 2/2, net-next] net: netsec: add XDP support
Message-ID: <20190627142305.16b8f331@carbon>
In-Reply-To: <1561475179-7686-3-git-send-email-ilias.apalodimas@linaro.org>
References: <1561475179-7686-1-git-send-email-ilias.apalodimas@linaro.org>
        <1561475179-7686-3-git-send-email-ilias.apalodimas@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 27 Jun 2019 12:23:25 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jun 2019 18:06:19 +0300
Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:

> @@ -609,6 +639,9 @@ static bool netsec_clean_tx_dring(struct netsec_priv *priv)
>  	int tail = dring->tail;
>  	int cnt = 0;
>  
> +	if (dring->is_xdp)
> +		spin_lock(&dring->lock);
> +
>  	pkts = 0;
>  	bytes = 0;
>  	entry = dring->vaddr + DESC_SZ * tail;
> @@ -622,16 +655,24 @@ static bool netsec_clean_tx_dring(struct netsec_priv *priv)
>  		eop = (entry->attr >> NETSEC_TX_LAST) & 1;
>  		dma_rmb();
>  
> -		dma_unmap_single(priv->dev, desc->dma_addr, desc->len,
> -				 DMA_TO_DEVICE);
> -		if (eop) {
> -			pkts++;
> +		if (!eop)
> +			goto next;
> +
> +		if (desc->buf_type == TYPE_NETSEC_SKB) {
> +			dma_unmap_single(priv->dev, desc->dma_addr, desc->len,
> +					 DMA_TO_DEVICE);

I don't think this is correct.  If I read the code correctly, you will
miss the DMA unmap for !eop packets.

>  			bytes += desc->skb->len;
>  			dev_kfree_skb(desc->skb);
> +		} else {
> +			if (desc->buf_type == TYPE_NETSEC_XDP_NDO)
> +				dma_unmap_single(priv->dev, desc->dma_addr,
> +						 desc->len, DMA_TO_DEVICE);
> +			xdp_return_frame(desc->xdpf);
>  		}
>  		/* clean up so netsec_uninit_pkt_dring() won't free the skb
>  		 * again
>  		 */
> +next:
>  		*desc = (struct netsec_desc){};
>  
>  		/* entry->attr is not going to be accessed by the NIC until
> @@ -645,6 +686,8 @@ static bool netsec_clean_tx_dring(struct netsec_priv *priv)
>  		entry = dring->vaddr + DESC_SZ * tail;
>  		cnt++;
>  	}
> +	if (dring->is_xdp)
> +		spin_unlock(&dring->lock);
>  
>  	if (!cnt)
>  		return false;



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
