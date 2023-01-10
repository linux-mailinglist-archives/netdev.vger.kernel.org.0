Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92C8E664F2A
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 23:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234574AbjAJWyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 17:54:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235433AbjAJWxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 17:53:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A2363F6B;
        Tue, 10 Jan 2023 14:51:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 158CB6191F;
        Tue, 10 Jan 2023 22:51:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10461C433F1;
        Tue, 10 Jan 2023 22:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673391114;
        bh=o9OeEHKSFKlahP4meTr0ckJWyKeB9yjaFvMZ1lhRkqI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nbd32xmaW9WdO1u/PWOjdJdb+26FTqJao9Sn4v2we5M1eMT3ytIkI5Igxv8PCj6yS
         H15ViKsK868VH+nPmcUJSG2Rbo5Z8kdSph/JdIGd4sXha9RSQXF6IzjhVijbuF1+6/
         DOMRusZi9N0mLE0xl7dRLeHHAvc4qGVNw9IjZQ0+2ssQ7L02GFqnXRp+NKk/dASYRt
         3NU8rFp6CgBdGGYMqTDmQcVf1MQb79lC35/ViyDG0Z85vNNMUqcARAr3oJymwV51VN
         sUazuUJZrXJvraztzR9CdoWtiCR8j952ZkAw69LLawbwa9H2523ldrw0z+Sx7ukXQM
         lHMeS5k4au/tg==
Date:   Tue, 10 Jan 2023 14:51:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ajit Khaparde <ajit.khaparde@broadcom.com>
Cc:     andrew.gospodarek@broadcom.com, davem@davemloft.net,
        edumazet@google.com, jgg@ziepe.ca, leon@kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        michael.chan@broadcom.com, netdev@vger.kernel.org,
        pabeni@redhat.com, selvin.xavier@broadcom.com
Subject: Re: [PATCH 1/8] bnxt_en: Add auxiliary driver support
Message-ID: <20230110145152.3029bd2a@kernel.org>
In-Reply-To: <20230108030208.26390-2-ajit.khaparde@broadcom.com>
References: <20230108030208.26390-1-ajit.khaparde@broadcom.com>
        <20230108030208.26390-2-ajit.khaparde@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  7 Jan 2023 19:02:01 -0800 Ajit Khaparde wrote:
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
> index 2e54bf4fc7a7..6c697172f042 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
> @@ -25,32 +25,37 @@
>  #include "bnxt_hwrm.h"
>  #include "bnxt_ulp.h"
>  
> +static DEFINE_IDA(bnxt_aux_dev_ids);
> +
>  static int bnxt_register_dev(struct bnxt_en_dev *edev, unsigned int ulp_id,
>  			     struct bnxt_ulp_ops *ulp_ops, void *handle)
>  {
>  	struct net_device *dev = edev->net;
>  	struct bnxt *bp = netdev_priv(dev);
>  	struct bnxt_ulp *ulp;
> +	int rc = 0;
>  
> -	ASSERT_RTNL();
>  	if (ulp_id >= BNXT_MAX_ULP)
>  		return -EINVAL;
>  
>  	ulp = &edev->ulp_tbl[ulp_id];
>  	if (rcu_access_pointer(ulp->ulp_ops)) {
>  		netdev_err(bp->dev, "ulp id %d already registered\n", ulp_id);
> -		return -EBUSY;
> +		rc = -EBUSY;
> +		goto exit;

The change to jump to the return statement rater than return directly
seems unrelated to the rest of the patch, and wrong.

>  	}
>  	if (ulp_id == BNXT_ROCE_ULP) {
>  		unsigned int max_stat_ctxs;
>  
>  		max_stat_ctxs = bnxt_get_max_func_stat_ctxs(bp);
>  		if (max_stat_ctxs <= BNXT_MIN_ROCE_STAT_CTXS ||
> -		    bp->cp_nr_rings == max_stat_ctxs)
> -			return -ENOMEM;
> +		    bp->cp_nr_rings == max_stat_ctxs) {
> +			rc = -ENOMEM;
> +			goto exit;
> +		}
>  	}
>  
> -	atomic_set(&ulp->ref_count, 0);
> +	atomic_set(&ulp->ref_count, 1);
>  	ulp->handle = handle;
>  	rcu_assign_pointer(ulp->ulp_ops, ulp_ops);
>  
> @@ -59,7 +64,8 @@ static int bnxt_register_dev(struct bnxt_en_dev *edev, unsigned int ulp_id,
>  			bnxt_hwrm_vnic_cfg(bp, 0);
>  	}
>  
> -	return 0;
> +exit:
> +	return rc;
>  }
>  
>  static int bnxt_unregister_dev(struct bnxt_en_dev *edev, unsigned int ulp_id)
> @@ -69,10 +75,11 @@ static int bnxt_unregister_dev(struct bnxt_en_dev *edev, unsigned int ulp_id)
>  	struct bnxt_ulp *ulp;
>  	int i = 0;
>  
> -	ASSERT_RTNL();
>  	if (ulp_id >= BNXT_MAX_ULP)
>  		return -EINVAL;
>  
> +	edev->flags |= BNXT_EN_FLAG_ULP_STOPPED;
> +
>  	ulp = &edev->ulp_tbl[ulp_id];
>  	if (!rcu_access_pointer(ulp->ulp_ops)) {
>  		netdev_err(bp->dev, "ulp id %d not registered\n", ulp_id);
> @@ -126,7 +133,6 @@ static int bnxt_req_msix_vecs(struct bnxt_en_dev *edev, unsigned int ulp_id,
>  	int total_vecs;
>  	int rc = 0;
>  
> -	ASSERT_RTNL();
>  	if (ulp_id != BNXT_ROCE_ULP)
>  		return -EINVAL;
>  
> @@ -149,6 +155,7 @@ static int bnxt_req_msix_vecs(struct bnxt_en_dev *edev, unsigned int ulp_id,
>  		max_idx = min_t(int, bp->total_irqs, max_cp_rings);
>  		idx = max_idx - avail_msix;
>  	}
> +
>  	edev->ulp_tbl[ulp_id].msix_base = idx;
>  	edev->ulp_tbl[ulp_id].msix_requested = avail_msix;
>  	hw_resc = &bp->hw_resc;
> @@ -156,8 +163,10 @@ static int bnxt_req_msix_vecs(struct bnxt_en_dev *edev, unsigned int ulp_id,
>  	if (bp->total_irqs < total_vecs ||
>  	    (BNXT_NEW_RM(bp) && hw_resc->resv_irqs < total_vecs)) {
>  		if (netif_running(dev)) {
> +			rtnl_lock();

What prevents the device from going down after you check running 
but before you take the lock?

>  			bnxt_close_nic(bp, true, false);
>  			rc = bnxt_open_nic(bp, true, false);
> +			rtnl_unlock();
>  		} else {
>  			rc = bnxt_reserve_rings(bp, true);
>  		}

> @@ -475,6 +467,143 @@ static const struct bnxt_en_ops bnxt_en_ops_tbl = {
>  	.bnxt_register_fw_async_events	= bnxt_register_async_events,
>  };
>  
> +void bnxt_aux_dev_free(struct bnxt *bp)
> +{
> +	kfree(bp->aux_dev);
> +	bp->aux_dev = NULL;
> +}
> +
> +static struct bnxt_aux_dev *bnxt_aux_dev_alloc(struct bnxt *bp)
> +{
> +	struct bnxt_aux_dev *bnxt_adev;
> +
> +	bnxt_adev =  kzalloc(sizeof(*bnxt_adev), GFP_KERNEL);

double space

> +	if (!bnxt_adev)
> +		return NULL;
> +
> +	return bnxt_adev;

This entire function is rather pointless.

If you really want it - it can be simply written as:

static struct bnxt_aux_dev *bnxt_aux_dev_alloc(struct bnxt *bp)
{
	return kzalloc(sizeof(struct bnxt_aux_dev), GFP_KERNEL);
}

> +}
> +
> +void bnxt_rdma_aux_device_uninit(struct bnxt *bp)
> +{
> +	struct bnxt_aux_dev *bnxt_adev;
> +	struct auxiliary_device *adev;
> +
> +	/* Skip if no auxiliary device init was done. */
> +	if (!(bp->flags & BNXT_FLAG_ROCE_CAP))
> +		return;
> +
> +	bnxt_adev = bp->aux_dev;
> +	adev = &bnxt_adev->aux_dev;
> +	auxiliary_device_delete(adev);

auxiliary_device_delete() waits for all the references to disappear?
The lifetime rules between adev and "edev" seem a little odd to me,
maybe I'm not familiar enough with auxdev.

> +	auxiliary_device_uninit(adev);
> +	if (bnxt_adev->id >= 0)
> +		ida_free(&bnxt_aux_dev_ids, bnxt_adev->id);
> +}
> +
> +void bnxt_rdma_aux_device_init(struct bnxt *bp)
> +{
> +	int rc;
> +
> +	if (bp->flags & BNXT_FLAG_ROCE_CAP) {

flip the condition and return early, don't indent an entire function.

> +		bp->aux_dev = bnxt_aux_dev_alloc(bp);
> +		if (!bp->aux_dev)
> +			goto skip_ida_init;
> +
> +		bp->aux_dev->id = ida_alloc(&bnxt_aux_dev_ids, GFP_KERNEL);
> +		if (bp->aux_dev->id < 0) {
> +			netdev_warn(bp->dev,
> +				    "ida alloc failed for ROCE auxiliary device\n");
> +			goto skip_aux_init;
> +		}
> +
> +		/* If aux bus init fails, continue with netdev init. */
> +		rc = bnxt_rdma_aux_device_add(bp);
> +		if (rc) {
> +			netdev_warn(bp->dev,
> +				    "Failed to add auxiliary device for ROCE\n");
> +			goto aux_add_failed;
> +		}
> +	}
> +	return;
> +
> +aux_add_failed:
> +	ida_free(&bnxt_aux_dev_ids, bp->aux_dev->id);
> +	bp->aux_dev->id = -1;
> +skip_aux_init:
> +	bnxt_aux_dev_free(bp);
> +skip_ida_init:
> +	bp->flags &= ~BNXT_FLAG_ROCE_CAP;
> +}

> +static inline void bnxt_set_edev_info(struct bnxt_en_dev *edev, struct bnxt *bp)

Please don't use inline for no good reason.

> +{
> +	edev->en_ops = &bnxt_en_ops_tbl;
> +	edev->net = bp->dev;
> +	edev->pdev = bp->pdev;
> +	edev->l2_db_size = bp->db_size;
> +	edev->l2_db_size_nc = bp->db_size;
> +
> +	if (bp->flags & BNXT_FLAG_ROCEV1_CAP)
> +		edev->flags |= BNXT_EN_FLAG_ROCEV1_CAP;
> +	if (bp->flags & BNXT_FLAG_ROCEV2_CAP)
> +		edev->flags |= BNXT_EN_FLAG_ROCEV2_CAP;
> +}
> +
> +int bnxt_rdma_aux_device_add(struct bnxt *bp)
> +{
> +	struct bnxt_aux_dev *bnxt_adev = bp->aux_dev;
> +	struct bnxt_en_dev *edev = bnxt_adev->edev;
> +	struct auxiliary_device *aux_dev;
> +	int ret;
> +
> +	edev = kzalloc(sizeof(*edev), GFP_KERNEL);
> +	if (!edev) {
> +		ret = -ENOMEM;
> +		goto cleanup_edev_failure;
> +	}
> +
> +	aux_dev = &bnxt_adev->aux_dev;
> +	aux_dev->id = bnxt_adev->id;
> +	aux_dev->name = "rdma";
> +	aux_dev->dev.parent = &bp->pdev->dev;
> +	aux_dev->dev.release = bnxt_aux_dev_release;
> +
> +	bnxt_adev->edev = edev;
> +	bp->edev = edev;
> +	bnxt_set_edev_info(edev, bp);
> +
> +	ret = auxiliary_device_init(aux_dev);
> +	if (ret)
> +		goto cleanup_init_failure;
> +
> +	ret = auxiliary_device_add(aux_dev);
> +	if (ret)
> +		goto cleanup_add_failure;
> +
> +	return 0;
> +
> +cleanup_add_failure:

Name your labels after what you clean up, not what failed.

> +	auxiliary_device_uninit(aux_dev);
> +cleanup_init_failure:
> +	kfree(edev);
> +	bp->edev = NULL;
> +cleanup_edev_failure:

Don't jump to the return statement, just return.

> +	return ret;
> +}
> +
>  struct bnxt_en_dev *bnxt_ulp_probe(struct net_device *dev)
>  {
>  	struct bnxt *bp = netdev_priv(dev);
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
> index 42b50abc3e91..647147a68554 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
> @@ -17,6 +17,7 @@
>  #define BNXT_MIN_ROCE_STAT_CTXS	1
>  
>  struct hwrm_async_event_cmpl;
> +struct bnxt_aux_dev;

This forward declaration is not needed, at least in this patch.

>  struct bnxt;
>  
>  struct bnxt_msix_entry {
> @@ -102,10 +103,14 @@ int bnxt_get_ulp_stat_ctxs(struct bnxt *bp);
>  void bnxt_ulp_stop(struct bnxt *bp);
>  void bnxt_ulp_start(struct bnxt *bp, int err);
>  void bnxt_ulp_sriov_cfg(struct bnxt *bp, int num_vfs);
> -void bnxt_ulp_shutdown(struct bnxt *bp);
>  void bnxt_ulp_irq_stop(struct bnxt *bp);
>  void bnxt_ulp_irq_restart(struct bnxt *bp, int err);
>  void bnxt_ulp_async_events(struct bnxt *bp, struct hwrm_async_event_cmpl *cmpl);
> +void bnxt_aux_dev_release(struct device *dev);
> +int bnxt_rdma_aux_device_add(struct bnxt *bp);

This is only used in bnxt_ulp.c, please remove the declaration and make
it static. Please check other functions for the same problem.

> +void bnxt_rdma_aux_device_uninit(struct bnxt *bp);
> +void bnxt_rdma_aux_device_init(struct bnxt *bp);
> +void bnxt_aux_dev_free(struct bnxt *bp);

