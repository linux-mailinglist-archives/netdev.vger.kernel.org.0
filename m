Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B229D5FB0E
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 17:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbfGDPiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 11:38:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60066 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726822AbfGDPiH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 11:38:07 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2CC44300DA2B;
        Thu,  4 Jul 2019 15:38:07 +0000 (UTC)
Received: from carbon (ovpn-200-17.brq.redhat.com [10.40.200.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 59BBC968DD;
        Thu,  4 Jul 2019 15:38:00 +0000 (UTC)
Date:   Thu, 4 Jul 2019 17:37:58 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, brouer@redhat.com
Subject: Re: [PATCH net-next v2 3/3] net: stmmac: Introducing support for
 Page Pool
Message-ID: <20190704173758.6d985aa3@carbon>
In-Reply-To: <fd2b12e6fc99f6064b0c04e1baae24328d16289f.1562252534.git.joabreu@synopsys.com>
References: <cover.1562252534.git.joabreu@synopsys.com>
        <fd2b12e6fc99f6064b0c04e1baae24328d16289f.1562252534.git.joabreu@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Thu, 04 Jul 2019 15:38:07 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  4 Jul 2019 17:04:14 +0200
Jose Abreu <Jose.Abreu@synopsys.com> wrote:

> @@ -1498,8 +1480,9 @@ static void free_dma_rx_desc_resources(struct stmmac_priv *priv)
>  					  sizeof(struct dma_extended_desc),
>  					  rx_q->dma_erx, rx_q->dma_rx_phy);
>  
> -		kfree(rx_q->rx_skbuff_dma);
> -		kfree(rx_q->rx_skbuff);
> +		kfree(rx_q->buf_pool);
> +		if (rx_q->page_pool && page_pool_request_shutdown(rx_q->page_pool))
> +			page_pool_free(rx_q->page_pool);
>  	}
>  }

This code is okay, but I would likely write it as:

  if (rx_q->page_pool) {
	page_pool_request_shutdown(rx_q->page_pool));
	page_pool_free(rx_q->page_pool);
  }

Because (as you noticed) page_pool_free() have some API misuse checks,
that will get triggered, and thus provide a warning of you forget to
update this when driver evolves.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
