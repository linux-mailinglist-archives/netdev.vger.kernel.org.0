Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2619462AB0
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 03:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbhK3Cvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 21:51:31 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58286 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230034AbhK3Cva (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 21:51:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=KbhHigOXFWHvCOs1n7KzFI71MHRCrsAnkDvFFCZBeIE=; b=TOCJWGCdlgJVLuz2pz0kYux4Of
        Kjxzn6OBOZsVfLeo0x9rqHNn2ozETL9Mba/5ldrB73MZrfrIrI/1C9bFhhx+1DQy4gvQE+wEmegw+
        rT2CxqQ6hwvY0BSM15je5jQI+Mzi+JMMy7OtRG0XCcTgPNFa3STCvuJ/qlVJKK3/fDl8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mrtBi-00EzVL-5J; Tue, 30 Nov 2021 03:48:10 +0100
Date:   Tue, 30 Nov 2021 03:48:10 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sudarsana Reddy Kalluru <skalluru@marvell.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, irusskikh@marvell.com,
        dbezrukov@marvell.com
Subject: Re: [PATCH net 1/7] atlantic: Increase delay for fw transactions
Message-ID: <YaWQ6gib3t5zu8pE@lunn.ch>
References: <20211129132829.16038-1-skalluru@marvell.com>
 <20211129132829.16038-2-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129132829.16038-2-skalluru@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 29, 2021 at 05:28:23AM -0800, Sudarsana Reddy Kalluru wrote:
> From: Dmitry Bogdanov <dbezrukov@marvell.com>
> 
> The max waiting period (of 1 ms) while reading the data from FW shared
> buffer is too small for certain types of data (e.g., stats). There's a
> chance that FW could be updating buffer at the same time and driver
> would be unsuccessful in reading data. Firmware manual recommends to
> have 1 sec timeout to fix this issue.
> 
> Fixes: 5cfd54d7dc186 ("net: atlantic: minimal A2 fw_ops")
> Signed-off-by: Dmitry Bogdanov <dbezrukov@marvell.com>
> Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
> ---
>  .../ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c  | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
> index dd259c8f2f4f..b0e4119b9883 100644
> --- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
> +++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
> @@ -84,7 +84,7 @@ static int hw_atl2_shared_buffer_read_block(struct aq_hw_s *self,
>  			if (cnt > AQ_A2_FW_READ_TRY_MAX)
>  				return -ETIME;
>  			if (tid1.transaction_cnt_a != tid1.transaction_cnt_b)
> -				udelay(1);
> +				mdelay(1);
>  		} while (tid1.transaction_cnt_a != tid1.transaction_cnt_b);

This change is the 1 second timeout.

>  
>  		hw_atl2_mif_shared_buf_read(self, offset, (u32 *)data, dwords);
> @@ -339,8 +339,11 @@ static int aq_a2_fw_update_stats(struct aq_hw_s *self)
>  {
>  	struct hw_atl2_priv *priv = (struct hw_atl2_priv *)self->priv;
>  	struct statistics_s stats;
> +	int err;
>  
> -	hw_atl2_shared_buffer_read_safe(self, stats, &stats);
> +	err = hw_atl2_shared_buffer_read_safe(self, stats, &stats);
> +	if (err)
> +		return err;

This change however does not seem to be explained in the commit
message. Not discarding an error is a good change, but it needs
commenting on.

Also, looking at hw_atl2_shared_buffer_read_block() i notice it
returns -ETIME. It should be -ETIMEDOUT.

	Andrew
