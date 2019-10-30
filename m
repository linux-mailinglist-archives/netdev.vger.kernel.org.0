Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9866E9428
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 01:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfJ3AlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 20:41:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33650 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfJ3AlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 20:41:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 78BC413EF0D09;
        Tue, 29 Oct 2019 17:41:11 -0700 (PDT)
Date:   Tue, 29 Oct 2019 17:41:11 -0700 (PDT)
Message-Id: <20191029.174111.1326267225443351642.davem@davemloft.net>
To:     yangchun@google.com
Cc:     netdev@vger.kernel.org, csully@google.com
Subject: Re: [PATCH net] gve: Fixes DMA synchronization.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191028182309.73313-1-yangchun@google.com>
References: <20191028182309.73313-1-yangchun@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Oct 2019 17:41:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yangchun Fu <yangchun@google.com>
Date: Mon, 28 Oct 2019 11:23:09 -0700

> diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
> index 778b87b5a06c..d8342b7b9764 100644
> --- a/drivers/net/ethernet/google/gve/gve_tx.c
> +++ b/drivers/net/ethernet/google/gve/gve_tx.c
> @@ -390,7 +390,23 @@ static void gve_tx_fill_seg_desc(union gve_tx_desc *seg_desc,
>  	seg_desc->seg.seg_addr = cpu_to_be64(addr);
>  }
>  
> -static int gve_tx_add_skb(struct gve_tx_ring *tx, struct sk_buff *skb)
> +static inline void gve_dma_sync_for_device(struct gve_priv *priv,
> +					   dma_addr_t *page_buses,
> +					   u64 iov_offset, u64 iov_len)

Never use the inline keyword in foo.c files, let the compiler device.
