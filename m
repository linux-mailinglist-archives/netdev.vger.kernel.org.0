Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4E411368C
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 21:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbfLDUhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 15:37:20 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36328 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727911AbfLDUhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 15:37:19 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EF65414D78C45;
        Wed,  4 Dec 2019 12:37:18 -0800 (PST)
Date:   Wed, 04 Dec 2019 12:37:18 -0800 (PST)
Message-Id: <20191204.123718.1152659362924451799.davem@davemloft.net>
To:     grygorii.strashko@ti.com
Cc:     netdev@vger.kernel.org, ivan.khoronzhuk@linaro.org, nsekhar@ti.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: ethernet: ti: davinci_cpdma: fix warning
 "device driver frees DMA memory with different size"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191204165029.9264-1-grygorii.strashko@ti.com>
References: <20191204165029.9264-1-grygorii.strashko@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 04 Dec 2019 12:37:19 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>
Date: Wed, 4 Dec 2019 18:50:29 +0200

> @@ -1018,7 +1018,7 @@ static int cpdma_chan_submit_si(struct submit_info *si)
>  	struct cpdma_chan		*chan = si->chan;
>  	struct cpdma_ctlr		*ctlr = chan->ctlr;
>  	int				len = si->len;
> -	int				swlen = len;
> +	int				swlen;
>  	struct cpdma_desc __iomem	*desc;
>  	dma_addr_t			buffer;
>  	u32				mode;
> @@ -1040,6 +1040,7 @@ static int cpdma_chan_submit_si(struct submit_info *si)
>  		chan->stats.runt_transmit_buff++;
>  	}
>  
> +	swlen = len;
>  	mode = CPDMA_DESC_OWNER | CPDMA_DESC_SOP | CPDMA_DESC_EOP;
>  	cpdma_desc_to_port(chan, mode, si->directed);
>  
> -- 
> 2.17.1
> 

Now there is no reason to keep a separate swlen variable.

The integral value is always consumed as the length before the descriptor bits
are added to it.

Therefore you can just use 'len' everywhere in this function now.
