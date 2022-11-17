Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71D8362D994
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 12:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239827AbiKQLi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 06:38:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234802AbiKQLil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 06:38:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564FB1CFEB;
        Thu, 17 Nov 2022 03:38:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEEA36120B;
        Thu, 17 Nov 2022 11:38:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9001DC433D7;
        Thu, 17 Nov 2022 11:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668685118;
        bh=Va0NIa5hMni7va7206brYbPygkfd6ObKdpdlt/pEkTs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UaLU6I+AUMfFoNn/KOoDc8+Vre8ZEj/C6oMmYNmTTJjmgh//HJmCT7nAW0WPICgeH
         9K8Ub2ARA8d6GedfnwzQZjhQKQq0fFF+owRddXlxVPXzcnX8v9POyCQjJ3KuGtsKsD
         s6kjnFBYPu9yhs+NBCUEDAzbwk81H0S1nqJFs7CnM4GKDzhTrT5gktnGAh46/uuEMo
         +2YrFlv92oyYXVxdHPmYMwvyGYXXmy082tOL3E+vHOjzesYYmkRV4pM/fd0UakUiZK
         WRSaW46/G58iAyqbeCY+wZl+bVEVL6vbDnPT5GJ3qJg2rsyH0YCi1i29OLQvREvHi1
         B5y3XTmxPSgVA==
Date:   Thu, 17 Nov 2022 13:38:33 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     GR-Linux-NIC-Dev@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jeff Garzik <jeff@garzik.org>,
        Ron Mercer <ron.mercer@qlogic.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net/qla3xxx: fix potential memleak in ql3xxx_send()
Message-ID: <Y3YdOQYQ5SjdeRpT@unreal>
References: <1668675039-21138-1-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1668675039-21138-1-git-send-email-zhangchangzhong@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 04:50:38PM +0800, Zhang Changzhong wrote:
> The ql3xxx_send() returns NETDEV_TX_OK without freeing skb in error
> handling case, add dev_kfree_skb_any() to fix it.

Can you please remind me why should it release?
There are no paths in ql3xxx_send() that release skb.

Thanks

> 
> Fixes: bd36b0ac5d06 ("qla3xxx: Add support for Qlogic 4032 chip.")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> ---
>  drivers/net/ethernet/qlogic/qla3xxx.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
> index 76072f8..0d57ffc 100644
> --- a/drivers/net/ethernet/qlogic/qla3xxx.c
> +++ b/drivers/net/ethernet/qlogic/qla3xxx.c
> @@ -2471,6 +2471,7 @@ static netdev_tx_t ql3xxx_send(struct sk_buff *skb,
>  					     skb_shinfo(skb)->nr_frags);
>  	if (tx_cb->seg_count == -1) {
>  		netdev_err(ndev, "%s: invalid segment count!\n", __func__);
> +		dev_kfree_skb_any(skb);
>  		return NETDEV_TX_OK;
>  	}
>  
> -- 
> 2.9.5
> 
