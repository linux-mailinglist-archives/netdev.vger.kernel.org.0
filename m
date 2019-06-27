Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAE2157F69
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 11:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbfF0Jh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 05:37:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54770 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbfF0JhX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 05:37:23 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 65C3199DDE;
        Thu, 27 Jun 2019 09:37:18 +0000 (UTC)
Received: from carbon (ovpn-200-45.brq.redhat.com [10.40.200.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 102A51001B02;
        Thu, 27 Jun 2019 09:37:09 +0000 (UTC)
Date:   Thu, 27 Jun 2019 11:37:08 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, jaswinder.singh@linaro.org,
        ard.biesheuvel@linaro.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, daniel@iogearbox.net, ast@kernel.org,
        makita.toshiaki@lab.ntt.co.jp, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, davem@davemloft.net, brouer@redhat.com
Subject: Re: [RFC, PATCH 1/2, net-next] net: netsec: Use page_pool API
Message-ID: <20190627113708.67a8575a@carbon>
In-Reply-To: <1561475179-7686-2-git-send-email-ilias.apalodimas@linaro.org>
References: <1561475179-7686-1-git-send-email-ilias.apalodimas@linaro.org>
        <1561475179-7686-2-git-send-email-ilias.apalodimas@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 27 Jun 2019 09:37:23 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jun 2019 18:06:18 +0300
Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:

> @@ -1059,7 +1059,23 @@ static void netsec_setup_tx_dring(struct netsec_priv *priv)
>  static int netsec_setup_rx_dring(struct netsec_priv *priv)
>  {
>  	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_RX];
> -	int i;
> +	struct page_pool_params pp_params = { 0 };
> +	int i, err;
> +
> +	pp_params.order = 0;
> +	/* internal DMA mapping in page_pool */
> +	pp_params.flags = PP_FLAG_DMA_MAP;
> +	pp_params.pool_size = DESC_NUM;
> +	pp_params.nid = cpu_to_node(0);
> +	pp_params.dev = priv->dev;
> +	pp_params.dma_dir = DMA_FROM_DEVICE;

I was going to complain about this DMA_FROM_DEVICE, until I noticed
that in next patch you have:

 pp_params.dma_dir = xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;

Making a note here to help other reviewers.

> +	dring->page_pool = page_pool_create(&pp_params);
> +	if (IS_ERR(dring->page_pool)) {
> +		err = PTR_ERR(dring->page_pool);
> +		dring->page_pool = NULL;
> +		goto err_out;
> +	}
>  


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
