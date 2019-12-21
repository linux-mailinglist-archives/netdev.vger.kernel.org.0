Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7B30128794
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 06:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbfLUFfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 00:35:34 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56960 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfLUFfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 00:35:34 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 45B4B1539F27F;
        Fri, 20 Dec 2019 21:35:33 -0800 (PST)
Date:   Fri, 20 Dec 2019 21:35:32 -0800 (PST)
Message-Id: <20191220.213532.2095474595045639925.davem@davemloft.net>
To:     madalin.bucur@nxp.com, madalin.bucur@oss.nxp.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] dpaa_eth: fix DMA mapping leak
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1576764528-10742-1-git-send-email-madalin.bucur@oss.nxp.com>
References: <1576764528-10742-1-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 20 Dec 2019 21:35:33 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madalin Bucur <madalin.bucur@oss.nxp.com>
Date: Thu, 19 Dec 2019 16:08:48 +0200

> @@ -1744,6 +1744,9 @@ static struct sk_buff *sg_fd_to_skb(const struct dpaa_priv *priv,
>  		count_ptr = this_cpu_ptr(dpaa_bp->percpu_count);
>  		dma_unmap_page(priv->rx_dma_dev, sg_addr,
>  			       DPAA_BP_RAW_SIZE, DMA_FROM_DEVICE);
> +
> +		j++; /* fragments up to j were DMA unmapped */
> +

You can move this code:

		/* We may use multiple Rx pools */
		dpaa_bp = dpaa_bpid2pool(sgt[i].bpid);
		if (!dpaa_bp)
			goto free_buffers;

		count_ptr = this_cpu_ptr(dpaa_bp->percpu_count);

after the dma_unmap_page() call and that is such a much simpler
way to fix this bug.
