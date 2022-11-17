Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B03B62D97B
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 12:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234857AbiKQLgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 06:36:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234058AbiKQLga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 06:36:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07FAB4AF20;
        Thu, 17 Nov 2022 03:36:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92945B81FF8;
        Thu, 17 Nov 2022 11:36:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C200AC433D6;
        Thu, 17 Nov 2022 11:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668684986;
        bh=8QJ/6B95ZJj7J382ruXzDOJXOocq7WDhBh8qy5ltB7o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hsodTpErLDF6onHNbVw3rL/p73xlHYXRmka28Bmn7nvhfGZ766CEtphqsjvqq1GwX
         LbjnEABucBKRWAwqc52a9spoBGJRhNWlqd+yOTVcZipwY4c/i7rHSWmouxrIlHzAW3
         FslQsSGK0ywn9eJ2hqIoAYmHsAP+csXyXANjUX0F4D7kjOtZewjRWdTpQ/UnEmfFx7
         cNl05a6OudegR79SKxU/yXhXqX+rl8PEPuWs74O6v+tK7cV8LTs43kZXVnPZpkF8qI
         D6jAaHFbe2cxhNOBdgPCeZTa0bXvPpNmY8eYi4/9/B7+9lOlI25TVwBARotbjL30Jw
         fAgEkarRm6s+w==
Date:   Thu, 17 Nov 2022 13:36:21 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] sfc: fix potential memleak in
 __ef100_hard_start_xmit()
Message-ID: <Y3YctdnKDDvikQcl@unreal>
References: <1668671409-10909-1-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1668671409-10909-1-git-send-email-zhangchangzhong@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 03:50:09PM +0800, Zhang Changzhong wrote:
> The __ef100_hard_start_xmit() returns NETDEV_TX_OK without freeing skb
> in error handling case, add dev_kfree_skb_any() to fix it.
> 
> Fixes: 51b35a454efd ("sfc: skeleton EF100 PF driver")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> ---
>  drivers/net/ethernet/sfc/ef100_netdev.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
> index 88fa295..ddcc325 100644
> --- a/drivers/net/ethernet/sfc/ef100_netdev.c
> +++ b/drivers/net/ethernet/sfc/ef100_netdev.c
> @@ -218,6 +218,7 @@ netdev_tx_t __ef100_hard_start_xmit(struct sk_buff *skb,
>  		   skb->len, skb->data_len, channel->channel);
>  	if (!efx->n_channels || !efx->n_tx_channels || !channel) {
>  		netif_stop_queue(net_dev);
> +		dev_kfree_skb_any(skb);
>  		goto err;
>  	}

ef100 doesn't release in __ef100_enqueue_skb() either. SKB shouldn't be
NULL or ERR at this stage.

diff --git a/drivers/net/ethernet/sfc/ef100_tx.c b/drivers/net/ethernet/sfc/ef100_tx.c
index 29ffaf35559d..426706b91d02 100644
--- a/drivers/net/ethernet/sfc/ef100_tx.c
+++ b/drivers/net/ethernet/sfc/ef100_tx.c
@@ -497,7 +497,7 @@ int __ef100_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb,

 err:
        efx_enqueue_unwind(tx_queue, old_insert_count);
-       if (!IS_ERR_OR_NULL(skb))
+       if (rc)
                dev_kfree_skb_any(skb);

        /* If we're not expecting another transmit and we had something to push


>  
> -- 
> 2.9.5
> 
