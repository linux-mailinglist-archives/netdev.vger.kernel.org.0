Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0947E627AA8
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 11:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234043AbiKNKkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 05:40:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbiKNKkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 05:40:47 -0500
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6C01A062
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 02:40:44 -0800 (PST)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 2AEAe5Uf820655;
        Mon, 14 Nov 2022 11:40:05 +0100
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 2AEAe5Uf820655
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1668422406;
        bh=ruWxN85n8k29Oly4aD/onyXwm+G1dWEBNEhULwlWsj8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MNdO/JPQFntF+lJh71QYeQvRSnzPu2iIdkEZFKzTecVnv9ySF5yMUZRnlhLszeD40
         RXnLdCfCGSFXL4iVD79orRyWYf82BhNmZ5ErPLwa2HpA1BLLM6tyQXoFJ+W+e5GcU7
         i2PWMXF3YHSvgxGyuu6IE3ys4rETYBVou2LGGV6M=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 2AEAe4Hp820654;
        Mon, 14 Nov 2022 11:40:04 +0100
Date:   Mon, 14 Nov 2022 11:40:04 +0100
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Moritz Fischer <mdf@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: nixge: fix potential memory leak in
 nixge_start_xmit()
Message-ID: <Y3IbBCioK1Clt/3a@electric-eye.fr.zoreil.com>
References: <1668416136-33530-1-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1668416136-33530-1-git-send-email-zhangchangzhong@huawei.com>
X-Organisation: Land of Sunshine Inc.
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zhang Changzhong <zhangchangzhong@huawei.com> :
> The nixge_start_xmit() returns NETDEV_TX_OK but does not free skb on two
> error handling cases, which can lead to memory leak.
> 
> To fix this, return NETDEV_TX_BUSY in case of nixge_check_tx_bd_space()
> fails and add dev_kfree_skb_any() in case of dma_map_single() fails.

This patch merge two unrelated changes. Please split.

> Fixes: 492caffa8a1a ("net: ethernet: nixge: Add support for National Instruments XGE netdev")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> ---
>  drivers/net/ethernet/ni/nixge.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
> index 19d043b593cc..b9091f9bbc77 100644
> --- a/drivers/net/ethernet/ni/nixge.c
> +++ b/drivers/net/ethernet/ni/nixge.c
> @@ -521,13 +521,15 @@ static netdev_tx_t nixge_start_xmit(struct sk_buff *skb,
>  	if (nixge_check_tx_bd_space(priv, num_frag)) {
>  		if (!netif_queue_stopped(ndev))
>  			netif_stop_queue(ndev);
> -		return NETDEV_TX_OK;
> +		return NETDEV_TX_BUSY;
>  	}

The driver should probably check the available room before returning
from hard_start_xmit and turn the check above unlikely().

Btw there is no lock and the Tx completion is irq driven: the driver
is racy. :o(

-- 
Ueimor
