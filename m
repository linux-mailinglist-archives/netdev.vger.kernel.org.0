Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E8335BAE5
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 09:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236855AbhDLHiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 03:38:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230356AbhDLHiJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 03:38:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E950A6120B;
        Mon, 12 Apr 2021 07:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618213071;
        bh=W1SBAxid1H3eBmNfVo5aELF90NKiRpX8bemdlPiFQ6Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YaP9ZQ/lvhMegoFspa2NikHKJx5jTHerAvihqMgTpLa7E6wZZMEYlA7BxTC7RIBQa
         lCGuX+W3D8uSLunnN6w2usrz3ONrr04gG7JmFokGlsPm1hyP1/0zybVmCwQTXAzGiI
         SQQumv0O8kGW8efmKI2HPjGHQrXzzXXss4oaHtKtUiw4cvkhIE34/YANxUoycn0Rd7
         Fow0CzyOyCss4sqnawjlfbPnHuN18pXE3pourL51cGRI9412Q4ntYiHCntVIUpACTb
         yfWBhaR6bepiSelApeMFTtE8TZpirIr0s9doyVdnD0jdvlLzcr7du9RevBvn5QjoAw
         PgonVF+CIScNw==
Date:   Mon, 12 Apr 2021 10:37:10 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        gospo@broadcom.com
Subject: Re: [PATCH net-next 4/5] bnxt_en: Refactor __bnxt_vf_reps_destroy().
Message-ID: <YHP4piIPfdXca+uB@unreal>
References: <1618186695-18823-1-git-send-email-michael.chan@broadcom.com>
 <1618186695-18823-5-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1618186695-18823-5-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 11, 2021 at 08:18:14PM -0400, Michael Chan wrote:
> Add a new helper function __bnxt_free_one_vf_rep() to free one VF rep.
> We also reintialize the VF rep fields to proper initial values so that
> the function can be used without freeing the VF rep data structure.  This
> will be used in subsequent patches to free and recreate VF reps after
> error recovery.
> 
> Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
> Reviewed-by: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c | 21 ++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
> index b5d6cd63bea7..a4ac11f5b0e5 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
> @@ -288,6 +288,21 @@ void bnxt_vf_reps_open(struct bnxt *bp)
>  		bnxt_vf_rep_open(bp->vf_reps[i]->dev);
>  }
>  
> +static void __bnxt_free_one_vf_rep(struct bnxt *bp, struct bnxt_vf_rep *vf_rep)
> +{
> +	if (!vf_rep)
> +		return;

How can it be NULL if you check that vf_rep != NULL when called to
__bnxt_free_one_vf_rep() ?

Thanks

> +
> +	if (vf_rep->dst) {
> +		dst_release((struct dst_entry *)vf_rep->dst);
> +		vf_rep->dst = NULL;
> +	}
> +	if (vf_rep->tx_cfa_action != CFA_HANDLE_INVALID) {
> +		hwrm_cfa_vfr_free(bp, vf_rep->vf_idx);
> +		vf_rep->tx_cfa_action = CFA_HANDLE_INVALID;
> +	}
> +}
> +
>  static void __bnxt_vf_reps_destroy(struct bnxt *bp)
>  {
>  	u16 num_vfs = pci_num_vf(bp->pdev);
> @@ -297,11 +312,7 @@ static void __bnxt_vf_reps_destroy(struct bnxt *bp)
>  	for (i = 0; i < num_vfs; i++) {
>  		vf_rep = bp->vf_reps[i];
>  		if (vf_rep) {
> -			dst_release((struct dst_entry *)vf_rep->dst);
> -
> -			if (vf_rep->tx_cfa_action != CFA_HANDLE_INVALID)
> -				hwrm_cfa_vfr_free(bp, vf_rep->vf_idx);
> -
> +			__bnxt_free_one_vf_rep(bp, vf_rep);
>  			if (vf_rep->dev) {
>  				/* if register_netdev failed, then netdev_ops
>  				 * would have been set to NULL
> -- 
> 2.18.1
> 
