Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 855C659C6B
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 15:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbfF1NDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 09:03:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41108 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726558AbfF1NDd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 09:03:33 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8CABB7FDCD;
        Fri, 28 Jun 2019 13:03:29 +0000 (UTC)
Received: from carbon (ovpn-200-45.brq.redhat.com [10.40.200.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3ACA960A97;
        Fri, 28 Jun 2019 13:03:19 +0000 (UTC)
Date:   Fri, 28 Jun 2019 15:03:17 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, jaswinder.singh@linaro.org,
        ard.biesheuvel@linaro.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, daniel@iogearbox.net, ast@kernel.org,
        makita.toshiaki@lab.ntt.co.jp, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, davem@davemloft.net,
        maciejromanfijalkowski@gmail.com, brouer@redhat.com
Subject: Re: [PATCH 1/3, net-next] net: netsec: Use page_pool API
Message-ID: <20190628150317.0b05e7ab@carbon>
In-Reply-To: <1561718355-13919-2-git-send-email-ilias.apalodimas@linaro.org>
References: <1561718355-13919-1-git-send-email-ilias.apalodimas@linaro.org>
        <1561718355-13919-2-git-send-email-ilias.apalodimas@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Fri, 28 Jun 2019 13:03:33 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jun 2019 13:39:13 +0300
Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:

> @@ -1079,11 +1095,22 @@ static int netsec_setup_rx_dring(struct netsec_priv *priv)
>  	}
>  
>  	netsec_rx_fill(priv, 0, DESC_NUM);
> +	err = xdp_rxq_info_reg(&dring->xdp_rxq, priv->ndev, 0);
> +	if (err)
> +		goto err_out;
> +
> +	err = xdp_rxq_info_reg_mem_model(&dring->xdp_rxq, MEM_TYPE_PAGE_POOL,
> +					 dring->page_pool);
> +	if (err) {
> +		page_pool_free(dring->page_pool);
> +		goto err_out;
> +	}
>  
>  	return 0;
>  
>  err_out:
> -	return -ENOMEM;
> +	netsec_uninit_pkt_dring(priv, NETSEC_RING_RX);
> +	return err;
>  }

I think you need to move page_pool_free(dring->page_pool) until after
netsec_uninit_pkt_dring() as it use dring->page_pool.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
