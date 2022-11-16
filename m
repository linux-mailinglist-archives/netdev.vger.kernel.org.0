Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20D8562B289
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 06:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiKPFCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 00:02:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiKPFCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 00:02:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EBC532043
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 21:02:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 234E8B81BAE
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 05:02:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C69C433C1;
        Wed, 16 Nov 2022 05:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668574960;
        bh=7QlErTlmcnjLZJWMETVx+kMn89vQ9mnDgMh55H00UYs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XU9xPGM2DxPNr5YRFXCeqKFIE77A6BHh1cHvgKiAWTA2SugOfaGI1MbrahqXBJqqi
         F9FxTSwac19kHswFSzL3TAX1xtJnkSGYCmZoEB2OdVs1+9MWvOKPUyRoPHdVkgjm1G
         BbKxMQcfXOfjDfyjdPDtE0TKA+t+4s4uS9YUcgmckF7vDEiYUU6KybzQA4PSPyM9IZ
         18EFy+LyFsGLp5L3m0rXLpBhC9vKWs5pfD1vau04SqIuUvFRuIto6YuFcO91Mb3Wly
         aTQidXkuUPXrBG54VIUAS61VojXiewLauV73i+7TfXMKnKzkMPCwqGm/vFj198BNQQ
         IH5q1yufa78Yw==
Date:   Tue, 15 Nov 2022 21:02:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        Benjamin Mikailenko <benjamin.mikailenko@intel.com>,
        netdev@vger.kernel.org, Gurucharan G <gurucharanx.g@intel.com>
Subject: Re: [PATCH net-next 5/7] ice: Accumulate ring statistics over reset
Message-ID: <20221115210239.3a1c05ba@kernel.org>
In-Reply-To: <20221114234250.3039889-6-anthony.l.nguyen@intel.com>
References: <20221114234250.3039889-1-anthony.l.nguyen@intel.com>
        <20221114234250.3039889-6-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Nov 2022 15:42:48 -0800 Tony Nguyen wrote:
> +static int ice_vsi_alloc_stat_arrays(struct ice_vsi *vsi)
> +{
> +	struct ice_vsi_stats *vsi_stat;
> +	struct ice_pf *pf = vsi->back;
> +	struct device *dev;
> +
> +	dev = ice_pf_to_dev(pf);
> +
> +	if (vsi->type == ICE_VSI_CHNL)
> +		return 0;
> +	if (!pf->vsi_stats)
> +		return -ENOENT;
> +
> +	vsi_stat = devm_kzalloc(dev, sizeof(*vsi_stat), GFP_KERNEL);

Don't use managed allocations if the structure's lifetime does not
match that of the driver instance. It's not generic garbage collection.

> +	if (!vsi_stat)
> +		return -ENOMEM;
> +
> +	vsi_stat->tx_ring_stats =
> +		devm_kcalloc(dev, vsi->alloc_txq,
> +			     sizeof(*vsi_stat->tx_ring_stats), GFP_KERNEL);
> +
> +	vsi_stat->rx_ring_stats =
> +		devm_kcalloc(dev, vsi->alloc_rxq,
> +			     sizeof(*vsi_stat->rx_ring_stats), GFP_KERNEL);
> +
> +	if (!vsi_stat->tx_ring_stats || !vsi_stat->rx_ring_stats)
> +		goto err_alloc;
> +
> +	pf->vsi_stats[vsi->idx] = vsi_stat;
> +
> +	return 0;
> +
> +err_alloc:

Don't do combined error checking, add appropriate labels for each case.

> +	devm_kfree(dev, vsi_stat->tx_ring_stats);
> +	vsi_stat->tx_ring_stats = NULL;

No need to clear the pointers, vsi_stats is freed few lines down.

> +	devm_kfree(dev, vsi_stat->rx_ring_stats);
> +	vsi_stat->rx_ring_stats = NULL;
> +	devm_kfree(dev, vsi_stat);
> +	pf->vsi_stats[vsi->idx] = NULL;
> +	return -ENOMEM;
> +}
> +
>  /**
>   * ice_vsi_alloc - Allocates the next available struct VSI in the PF
>   * @pf: board private structure
> @@ -560,6 +606,11 @@ ice_vsi_alloc(struct ice_pf *pf, enum ice_vsi_type vsi_type,
>  
>  	if (vsi->type == ICE_VSI_CTRL && vf)
>  		vf->ctrl_vsi_idx = vsi->idx;
> +
> +	/* allocate memory for Tx/Rx ring stat pointers */
> +	if (ice_vsi_alloc_stat_arrays(vsi))
> +		goto err_rings;
> +
>  	goto unlock_pf;
>  
>  err_rings:
> @@ -1535,6 +1586,122 @@ static int ice_vsi_alloc_rings(struct ice_vsi *vsi)
>  	return -ENOMEM;
>  }
>  
> +/**
> + * ice_vsi_free_stats - Free the ring statistics structures
> + * @vsi: VSI pointer
> + */
> +static void ice_vsi_free_stats(struct ice_vsi *vsi)
> +{
> +	struct ice_vsi_stats *vsi_stat;
> +	struct ice_pf *pf = vsi->back;
> +	struct device *dev;
> +	int i;
> +
> +	dev = ice_pf_to_dev(pf);
> +
> +	if (vsi->type == ICE_VSI_CHNL)
> +		return;
> +	if (!pf->vsi_stats)
> +		return;
> +
> +	vsi_stat = pf->vsi_stats[vsi->idx];
> +	if (!vsi_stat)
> +		return;
> +
> +	ice_for_each_alloc_txq(vsi, i) {
> +		if (vsi_stat->tx_ring_stats[i]) {
> +			kfree_rcu(vsi_stat->tx_ring_stats[i], rcu);
> +			WRITE_ONCE(vsi_stat->tx_ring_stats[i], NULL);
> +		}
> +	}
> +
> +	ice_for_each_alloc_rxq(vsi, i) {
> +		if (vsi_stat->rx_ring_stats[i]) {
> +			kfree_rcu(vsi_stat->rx_ring_stats[i], rcu);
> +			WRITE_ONCE(vsi_stat->rx_ring_stats[i], NULL);
> +		}
> +	}
> +
> +	devm_kfree(dev, vsi_stat->tx_ring_stats);
> +	vsi_stat->tx_ring_stats = NULL;
> +	devm_kfree(dev, vsi_stat->rx_ring_stats);
> +	vsi_stat->rx_ring_stats = NULL;
> +	devm_kfree(dev, vsi_stat);
> +	pf->vsi_stats[vsi->idx] = NULL;
> +}
> +
> +/**
> + * ice_vsi_alloc_ring_stats - Allocates Tx and Rx ring stats for the VSI
> + * @vsi: VSI which is having stats allocated
> + */
> +static int ice_vsi_alloc_ring_stats(struct ice_vsi *vsi)
> +{
> +	struct ice_ring_stats **tx_ring_stats;
> +	struct ice_ring_stats **rx_ring_stats;
> +	struct ice_vsi_stats *vsi_stats;
> +	struct ice_pf *pf = vsi->back;
> +	u16 i;
> +
> +	if (!pf->vsi_stats)
> +		return -ENOENT;
> +
> +	vsi_stats = pf->vsi_stats[vsi->idx];
> +	if (!vsi_stats)
> +		return -ENOENT;
> +
> +	tx_ring_stats = vsi_stats->tx_ring_stats;
> +	if (!tx_ring_stats)
> +		return -ENOENT;
> +
> +	rx_ring_stats = vsi_stats->rx_ring_stats;
> +	if (!rx_ring_stats)
> +		return -ENOENT;
> +

Why all this NULL-checking? The init should have failed if any of these
are NULL. Please avoid defensive programming.
