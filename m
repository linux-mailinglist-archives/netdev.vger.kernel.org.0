Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2EFF62AF0D
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 00:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbiKOXDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 18:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbiKOXDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 18:03:33 -0500
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0901A218;
        Tue, 15 Nov 2022 15:03:32 -0800 (PST)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 2AFN3A5S879452;
        Wed, 16 Nov 2022 00:03:10 +0100
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 2AFN3A5S879452
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1668553390;
        bh=IlM07V2nk3Vlr1tkiatmuPGZypdU+mfnuL4S/5X5luE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CiWouXgUFhV5lv0v9bDtJhwRnsiJgxdF4ySqrNv6J7ayGCBOezJsDMummzmGK1Wez
         opHkPBg+qH+A6TDe6JbwgxkdnHg8ryFGdl1wjT96y2kbHdXEDlshZxCcguCvpj9q4b
         vnEbqcoC0qLC9WO7y7nn66KAi6IuupFDBlPc0XLc=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 2AFN3Afl879451;
        Wed, 16 Nov 2022 00:03:10 +0100
Date:   Wed, 16 Nov 2022 00:03:10 +0100
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mdf@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 2/3] net: nixge: avoid overwriting buffer
 descriptor
Message-ID: <Y3QarsEAwlJFRXis@electric-eye.fr.zoreil.com>
References: <1668525024-38409-1-git-send-email-zhangchangzhong@huawei.com>
 <1668525024-38409-3-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1668525024-38409-3-git-send-email-zhangchangzhong@huawei.com>
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
> The check on the number of available BDs is incorrect because BDs are
> required not only for frags but also for skb. This may result in
> overwriting BD that is still in use.
> 
> Fixes: 492caffa8a1a ("net: ethernet: nixge: Add support for National Instruments XGE netdev")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> ---
>  drivers/net/ethernet/ni/nixge.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
> index d8cd520..91b7ebc 100644
> --- a/drivers/net/ethernet/ni/nixge.c
> +++ b/drivers/net/ethernet/ni/nixge.c
> @@ -518,7 +518,7 @@ static netdev_tx_t nixge_start_xmit(struct sk_buff *skb,
>  	cur_p = &priv->tx_bd_v[priv->tx_bd_tail];
>  	tx_skb = &priv->tx_skb[priv->tx_bd_tail];
>  
> -	if (nixge_check_tx_bd_space(priv, num_frag)) {
> +	if (nixge_check_tx_bd_space(priv, num_frag + 1)) {
>  		if (!netif_queue_stopped(ndev))
>  			netif_stop_queue(ndev);
>  		return NETDEV_TX_OK;
> -- 

Reviewed-by: Francois Romieu <romieu@fr.zoreil.com>

It's fine as a minimal fix but something may be done in a future patch
to avoid the confusing nixge_check_tx_bd_space(..., num_frag + 1) vs
static int nixge_check_tx_bd_space(struct nixge_priv *priv, int num_frag)
(use "slots" for the latter ?).

Consider waiting for -stable people's opinion before rushing into it
as it may make their life harder.

-- 
Ueimor
