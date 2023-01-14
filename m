Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C82666A993
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 07:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjANGKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 01:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjANGKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 01:10:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C4C30DB;
        Fri, 13 Jan 2023 22:10:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2E0360B50;
        Sat, 14 Jan 2023 06:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98ABCC433D2;
        Sat, 14 Jan 2023 06:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673676644;
        bh=LDlKC7jMT4LJfIORAw5P71w/p4Kkb+Uq8n7pEU6mECI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fC96JrbbfYv8nAkOwZsw+JZmrP6EI1rD2z/janUSnK0Q0Bfnysxm57j5mLXDCcbjD
         oOAbrUGILNL5qJDYoF5oM2Q+48Du3iGKMPDZy+NhEdoT/fTuYwPGNbl/hBT0aqJY3G
         LU/nmaOapAoal0C5ZgwWBW1PuVqbkWAFyQ1mUIhhjKoJ88u9u2eLdj2IFIU8Ed4iyu
         qlAVaPUHtyXA5uiT/+ZfuDyW0EA8lN+wRAferYX7XXp6sRhVEwEiQZPakOFM2S26Ms
         uz2Wg9EKQNFXE0ozc1lJY5cIeZEb0DfMfE5pCUgDsm07bES4mwuV3F7T5Yr014CgU7
         kfiwR9/eNBntg==
Date:   Fri, 13 Jan 2023 22:10:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ajit Khaparde <ajit.khaparde@broadcom.com>
Cc:     andrew.gospodarek@broadcom.com, davem@davemloft.net,
        edumazet@google.com, jgg@ziepe.ca, leon@kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        michael.chan@broadcom.com, netdev@vger.kernel.org,
        pabeni@redhat.com, selvin.xavier@broadcom.com,
        Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH net-next v7 1/8] bnxt_en: Add auxiliary driver support
Message-ID: <20230113221042.5d24bdde@kernel.org>
In-Reply-To: <20230112202939.19562-2-ajit.khaparde@broadcom.com>
References: <20230112202939.19562-1-ajit.khaparde@broadcom.com>
        <20230112202939.19562-2-ajit.khaparde@broadcom.com>
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

On Thu, 12 Jan 2023 12:29:32 -0800 Ajit Khaparde wrote:
> Add auxiliary driver support.
> An auxiliary device will be created if the hardware indicates
> support for RDMA.
> The bnxt_ulp_probe() function has been removed and a new
> bnxt_rdma_aux_device_add() function has been added.
> The bnxt_free_msix_vecs() and bnxt_req_msix_vecs() will now hold
> the RTNL lock when they call the bnxt_close_nic()and bnxt_open_nic()
> since the device close and open need to be protected under RTNL lock.
> The operations between the bnxt_en and bnxt_re will be protected
> using the en_ops_lock.
> This will be used by the bnxt_re driver in a follow-on patch
> to create ROCE interfaces.

> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> @@ -13178,6 +13178,9 @@ static void bnxt_remove_one(struct pci_dev *pdev)
>  	struct net_device *dev = pci_get_drvdata(pdev);
>  	struct bnxt *bp = netdev_priv(dev);
>  
> +	bnxt_rdma_aux_device_uninit(bp);
> +	bnxt_aux_dev_free(bp);

You still free bp->aux_dev synchronously..

> +void bnxt_aux_dev_free(struct bnxt *bp)
> +{
> +	kfree(bp->aux_dev);

.. here. Which is called on .remove of the PCI device.

> +	bp->aux_dev = NULL;
> +}
> +
> +static struct bnxt_aux_dev *bnxt_aux_dev_alloc(struct bnxt *bp)
> +{
> +	return kzalloc(sizeof(struct bnxt_aux_dev), GFP_KERNEL);
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
> +	auxiliary_device_uninit(adev);
> +	if (bnxt_adev->id >= 0)
> +		ida_free(&bnxt_aux_dev_ids, bnxt_adev->id);
> +}
> +
> +static void bnxt_aux_dev_release(struct device *dev)
> +{
> +	struct bnxt_aux_dev *bnxt_adev =
> +		container_of(dev, struct bnxt_aux_dev, aux_dev.dev);
> +	struct bnxt *bp = netdev_priv(bnxt_adev->edev->net);
> +
> +	bnxt_adev->edev->en_ops = NULL;
> +	kfree(bnxt_adev->edev);

And yet the reference counted "release" function accesses the bp->adev
like it must exist.

This seems odd to me - why do we need refcounting on devices at all 
if we can free them synchronously? To be clear - I'm not sure this is
wrong, just seems odd.

> +	bnxt_adev->edev = NULL;
> +	bp->edev = NULL;
> +}
