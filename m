Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCC946351B0
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 08:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236033AbiKWH6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 02:58:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236642AbiKWH5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 02:57:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB7CB1D5;
        Tue, 22 Nov 2022 23:57:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF89D61AE3;
        Wed, 23 Nov 2022 07:57:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE21FC433C1;
        Wed, 23 Nov 2022 07:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669190264;
        bh=D6LOp+qWaRcug48HhYQmVa5piKJzo25FJRWHcK5aDec=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JZeqwYEZS6n2kkdoyxVDmo+BHiSR2gfFfXDKnyoQQOckEHe3z7Bzpe07Exea4aM2O
         UcWGAUUvSh4MIp3tbR2GMuv1qzei68CSoZfMMVvLrHiCbpBoKge7I7MFsyvCOTE3Gz
         h9u6LiJwVW5EvWjY37j2rFzMIkwbntJCQUteljs+qHsoD476HgEqakkzaxCbfss1+B
         a8dDsPLg0takTJZrzmA8PVKiBQwW/WC6w8gTa10VHjwDll2IN4/+cgA7Uwd4b12a17
         RY/6GAT1tUDRcs7v7BVXo/Giu/K7zQSa9wnHVTooFIm+capdzFtcLKytp7e6XCbtMs
         B9+MnYqkoWX7A==
Date:   Wed, 23 Nov 2022 09:57:37 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Suman Ghosh <sumang@marvell.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, sgoutham@marvell.com, sbhatta@marvell.com,
        jerinj@marvell.com, gakula@marvell.com, hkelam@marvell.com,
        lcherian@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net PATCH] octeontx2-pf: Fix pfc_alloc_status array overflow
Message-ID: <Y33ScUx5t7f921uh@unreal>
References: <20221123051010.2725917-1-sumang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123051010.2725917-1-sumang@marvell.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 10:40:10AM +0530, Suman Ghosh wrote:
> This patch addresses pfc_alloc_status array overflow occurring for
> send queue index value greater than PFC priority. This is causing
> mbox errors as otx2_get_smq_idx returing invalid smq value.

Maybe this change is correct one, but commit message is missing an
explanation why internal function can receive "illegal" index and
why it is safe to continue.

> 
> Fixes: 99c969a83d82 ("octeontx2-pf: Add egress PFC support")
> 

No blank line here.

> Signed-off-by: Suman Ghosh <sumang@marvell.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> index 282db6fe3b08..67aa02bb2b85 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> @@ -884,7 +884,7 @@ static inline void otx2_dma_unmap_page(struct otx2_nic *pfvf,
>  static inline u16 otx2_get_smq_idx(struct otx2_nic *pfvf, u16 qidx)
>  {
>  #ifdef CONFIG_DCB
> -	if (pfvf->pfc_alloc_status[qidx])
> +	if (qidx < NIX_PF_PFC_PRIO_MAX && pfvf->pfc_alloc_status[qidx])
>  		return pfvf->pfc_schq_list[NIX_TXSCH_LVL_SMQ][qidx];
>  #endif
>  
> -- 
> 2.25.1
> 
