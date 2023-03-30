Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE5EA6CFAFE
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 07:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbjC3Fzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 01:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbjC3Fzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 01:55:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD691BE1;
        Wed, 29 Mar 2023 22:55:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03D6B61ED4;
        Thu, 30 Mar 2023 05:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0947C433D2;
        Thu, 30 Mar 2023 05:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680155736;
        bh=jePcfN0x3909Hzntn86C67kAOB+wuqEjPSGL6lUh7Zc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RnEwa2LVs76papoofedcMKqAycv5hXhBhVCjFU8YU+SjshRamZXvT3tpfGPjiacPD
         xWylfk9c94ox2VywaLKRVB4hJFXQO6oWuwOR9zZ7kzrpwaTzt5eCvtAbOYW2FSIdVm
         2WmggUnl3VEIc0s5ZlTWF9BxDbFyj/tS2jwKs9CYhjDKOMPg3LvDb85g4eyTf/qtmp
         F7qqh7FCubnT3OkKJ4gxP0J3BvTKdfmOvO2BpNRpIKvBONeHMf7Lv57q3LwGxLc8hG
         74qlDf8010lvWpM3gKE29NF6nPqgiqNYQoYSxtev3a196k/8nvAgPLyuXtqYOrKW0d
         E/VjZooPXKAtQ==
Date:   Thu, 30 Mar 2023 08:55:32 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Sai Krishna <saikrishnag@marvell.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgoutham@marvell.com,
        richardcochran@gmail.com, Geetha sowjanya <gakula@marvell.com>
Subject: Re: [net PATCH 1/7] octeontx2-af: Secure APR table update with the
 lock
Message-ID: <20230330055532.GK831478@unreal>
References: <20230329170619.183064-1-saikrishnag@marvell.com>
 <20230329170619.183064-2-saikrishnag@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329170619.183064-2-saikrishnag@marvell.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 10:36:13PM +0530, Sai Krishna wrote:
> From: Geetha sowjanya <gakula@marvell.com>
> 
> APR table contains the lmtst base address of PF/VFs.
> These entries are updated by the PF/VF during the
> device probe. Due to race condition while updating the
> entries are getting corrupted. Hence secure the APR
> table update with the lock.

However, I don't see rsrc_lock in probe path.
otx2_probe()
 -> cn10k_lmtst_init()
  -> lmt_base/lmstst is updated with and without mbox.lock.

Where did you take rsrc_lock in probe flow?

Thanks

> 
> Fixes: 893ae97214c3 ("octeontx2-af: cn10k: Support configurable LMTST regions")
> Signed-off-by: Geetha sowjanya <gakula@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
> index 4ad9ff025c96..8530250f6fba 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
> @@ -142,16 +142,17 @@ int rvu_mbox_handler_lmtst_tbl_setup(struct rvu *rvu,
>  	 * region, if so, convert that IOVA to physical address and
>  	 * populate LMT table with that address
>  	 */
> +	mutex_lock(&rvu->rsrc_lock);
>  	if (req->use_local_lmt_region) {
>  		err = rvu_get_lmtaddr(rvu, req->hdr.pcifunc,
>  				      req->lmt_iova, &lmt_addr);
>  		if (err < 0)
> -			return err;
> +			goto error;
>  
>  		/* Update the lmt addr for this PFFUNC in the LMT table */
>  		err = rvu_update_lmtaddr(rvu, req->hdr.pcifunc, lmt_addr);
>  		if (err)
> -			return err;
> +			goto error;
>  	}
>  
>  	/* Reconfiguring lmtst map table in lmt region shared mode i.e. make
> @@ -181,7 +182,7 @@ int rvu_mbox_handler_lmtst_tbl_setup(struct rvu *rvu,
>  		 */
>  		err = rvu_update_lmtaddr(rvu, req->hdr.pcifunc, val);
>  		if (err)
> -			return err;
> +			goto error;
>  	}
>  
>  	/* This mailbox can also be used to update word1 of APR_LMT_MAP_ENTRY_S
> @@ -230,6 +231,7 @@ int rvu_mbox_handler_lmtst_tbl_setup(struct rvu *rvu,
>  	}
>  
>  error:
> +	mutex_unlock(&rvu->rsrc_lock);
>  	return err;
>  }
>  
> -- 
> 2.25.1
> 
