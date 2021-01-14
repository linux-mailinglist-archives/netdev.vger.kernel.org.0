Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8862F6F1B
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 00:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731027AbhANXrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 18:47:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:37142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730755AbhANXrM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 18:47:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C7ED23A3B;
        Thu, 14 Jan 2021 23:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610667991;
        bh=2ETqslzrc3BObXDt2oH3b5RNNuC90uSLxcwQ5UA15ig=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PlmcAFPfkM3I61ywTPwaTZRHikH9KuwetZI+eub1Q+GaXENY87fLo9nKvDWtpoPsg
         5dqtlOZXOLqow/GsJXVlhFzvQjpDUCWHDXwtezmyryB0HH3Ui+jQebQSAU2F9vqOux
         793lUVy6IRi7VMR+2JX/+QaLZ0BuHfRkyr/bqpsjYWinIo7SlhL0AhVFD9QEtQur2B
         /E6osjG7isRxA3Mi94Kz+L6LZcCxAD/tGD7l2Lc10V0HvlOt+7RQ/zYaOUt3dVY8UE
         9VWqqjP+x0sGYj3+gc9b8f+fqI1BQdJhiyul4I0qteNCEqql6yJSlT1kthQZW0iVM8
         TD+boAHFdT1sg==
Message-ID: <c8ea9deda401f4c2996129d5089aa10cb0a31e84.camel@kernel.org>
Subject: Re: [PATCH net-next,1/3] octeontx2-af: Mailbox changes for 98xx CPT
 block
From:   Saeed Mahameed <saeed@kernel.org>
To:     Srujana Challa <schalla@marvell.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, sgoutham@marvell.com,
        gakula@marvell.com, sbhatta@marvell.com, schandran@marvell.com,
        pathreya@marvell.com, jerinj@marvell.com,
        Mahipal Challa <mchalla@marvell.com>
Date:   Thu, 14 Jan 2021 15:46:30 -0800
In-Reply-To: <20210113152007.30293-2-schalla@marvell.com>
References: <20210113152007.30293-1-schalla@marvell.com>
         <20210113152007.30293-2-schalla@marvell.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-01-13 at 20:50 +0530, Srujana Challa wrote:
> This patch changes CPT mailbox message format to
> support new block CPT1 in 98xx silicon.
> 
> cpt_rd_wr_reg ->
>     Modify cpt_rd_wr_reg mailbox and its handler to
>     accommodate new block CPT1.
> cpt_lf_alloc ->
>     Modify cpt_lf_alloc mailbox and its handler to
>     configure LFs from a block address out of multiple
>     blocks of same type. If a PF/VF needs to configure
>     LFs from both the blocks then this mbox should be
>     called twice.
> 
> Signed-off-by: Mahipal Challa <mchalla@marvell.com>
> Signed-off-by: Srujana Challa <schalla@marvell.com>
> ---
>  .../net/ethernet/marvell/octeontx2/af/mbox.h  |  2 +
>  .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 41 +++++++++++----
> ----
>  2 files changed, 27 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> index f919283ddc34..cbbab070f22b 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> @@ -1071,6 +1071,7 @@ struct cpt_rd_wr_reg_msg {
>  	u64 *ret_val;
>  	u64 val;
>  	u8 is_write;
> +	int blkaddr;
>  };
>  
>  struct cpt_lf_alloc_req_msg {
> @@ -1078,6 +1079,7 @@ struct cpt_lf_alloc_req_msg {
>  	u16 nix_pf_func;
>  	u16 sso_pf_func;
>  	u16 eng_grpmsk;
> +	int blkaddr;
>  };
>  
>  #endif /* MBOX_H */
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
> b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
> index 35261d52c997..b6de4b95a72a 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
> @@ -65,13 +65,13 @@ int rvu_mbox_handler_cpt_lf_alloc(struct rvu
> *rvu,
>  	int num_lfs, slot;
>  	u64 val;
>  
> +	blkaddr = req->blkaddr ? req->blkaddr : BLKADDR_CPT0;
> +	if (blkaddr != BLKADDR_CPT0 && blkaddr != BLKADDR_CPT1)
> +		return -ENODEV;
> +
>  

Just out of curiosity, why do you need to check against your driver's
internals function calls ? 

who calls this function: I Couldn't find any caller !

$ git grep rvu_mbox_handler_cpt_lf_alloc
drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c:int
rvu_mbox_handler_cpt_lf_alloc(struct rvu *rvu,



