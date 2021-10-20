Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 622564347C6
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 11:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbhJTJVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 05:21:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229809AbhJTJVX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 05:21:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5CD160F9E;
        Wed, 20 Oct 2021 09:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634721537;
        bh=SZkUpO9qIzjwLT/liQ99qcq9w70D9d2LQUSdkfGd2hc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FXHRhtW/B1oof8UF1yc1OaigQiX5End8FkOjLmBTRq0Aha/RPZEyTgSgbfIv4Bz4b
         4aJqReCwosaf2eKO01xcErvBljgCuFe2T7gBX/QBX5SUzXT4eDI7Ct8VYTSAJsCQ03
         dfR8QdJZ1WGoBunS6UM75FYMl7fHKIW1hBJS6u/kdtsd5SvL1kbjTxa3axlvHfSlxQ
         V5h84eMWDENMmWAzqxwI0lR28FaQibrIXZShW0p3yNCvbemsSHVtsYXjWJQZWzWdvP
         MnG26NAyIoY2ZcixlmnplBWw2xg3nOamdf65do8NNjKgfVupTa61qHNUsXL2BQJzLj
         f+BZHFzp1bTlw==
Date:   Wed, 20 Oct 2021 11:18:53 +0200
From:   Simon Horman <horms@kernel.org>
To:     luo penghao <cgel.zte@gmail.com>
Cc:     Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, penghao luo <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] octeontx2-af: Remove redundant assignment
 operations
Message-ID: <20211020091853.GD3935@kernel.org>
References: <20211018091612.858462-1-luo.penghao@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018091612.858462-1-luo.penghao@zte.com.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 09:16:12AM +0000, luo penghao wrote:
> From: penghao luo <luo.penghao@zte.com.cn>

I think the correct patch-prefix for this would be:

[PATCH net-next] sky2:

> 
> the variable err will be reassigned on subsequent branches, and this
> assignment does not perform related value operations.
> 
> clang_analyzer complains as follows:
> 
> drivers/net/ethernet/marvell/sky2.c:4988: warning:
> 
> Although the value stored to 'err' is used in the enclosing expression,
> the value is never actually read from 'err'.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: penghao luo <luo.penghao@zte.com.cn>
> ---
>  drivers/net/ethernet/marvell/sky2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
> index 3cb9c12..6428ae5 100644
> --- a/drivers/net/ethernet/marvell/sky2.c
> +++ b/drivers/net/ethernet/marvell/sky2.c
> @@ -4907,7 +4907,7 @@ static int sky2_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	pci_set_master(pdev);
>  
>  	if (sizeof(dma_addr_t) > sizeof(u32) &&
> -	    !(err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(64)))) {
> +	    !(dma_set_mask(&pdev->dev, DMA_BIT_MASK(64)))) {

I think you can drop the parentheses around the call to dma_set_mask()

>  		using_dac = 1;
>  		err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64));
>  		if (err < 0) {
> -- 
> 2.15.2
> 
> 
