Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB44641D20
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 13:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbiLDMz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 07:55:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiLDMz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 07:55:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9DE1648E;
        Sun,  4 Dec 2022 04:55:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17D04B80918;
        Sun,  4 Dec 2022 12:55:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2D2C433C1;
        Sun,  4 Dec 2022 12:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670158554;
        bh=8yRgtw2sqbmn0sbuN2uygsx/CmEH3xWVwet848rkPeM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oe73S5CnLcYVnjryVw5zKzNeITWOUd6MAR9WezfDI7EZNvRnTwQsM1muhe7F4yp11
         sUE/OoTwBZ+id9Y9+bInvHLCGeGytmEZ3AvtbtddbK44gAO9XG5bdWNLsLckg9bCtu
         Dgtg9NAKqB+5ldcvzbnJmcYhSyy5tJWxqM2UbQR822fFEqkLAlIYfQ8lLcFDUYT1Yj
         LAHx5MXsrzDpbMLhSQ57R8wCf2vlLcjqKTPcrCniEGimkc1W4SD/qaI5o+2F5XTdZe
         9py2XIebbQHY4sgwm9R6PYfbJ3QL2CO7CKvO88/2GWNOnkNr3V1f0D9HSMvhY7hIS6
         lT9O4Yxkz38UA==
Date:   Sun, 4 Dec 2022 14:55:42 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] octeontx2-pf: Fix potential memory leak in
 otx2_init_tc()
Message-ID: <Y4yYzlzPKix6VloH@unreal>
References: <20221202110430.1472991-1-william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202110430.1472991-1-william.xuanziyang@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 07:04:30PM +0800, Ziyang Xuan wrote:
> In otx2_init_tc(), if rhashtable_init() failed, it does not free
> tc->tc_entries_bitmap which is allocated in otx2_tc_alloc_ent_bitmap().
> 
> Fixes: 2e2a8126ffac ("octeontx2-pf: Unify flow management variables")
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> ---
> v2:
>   - Remove patch 2 which is not a problem, see the following link:
>     https://www.spinics.net/lists/netdev/msg864159.html
> ---
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
> index e64318c110fd..6a01ab1a6e6f 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
> @@ -1134,7 +1134,12 @@ int otx2_init_tc(struct otx2_nic *nic)
>  		return err;
>  
>  	tc->flow_ht_params = tc_flow_ht_params;
> -	return rhashtable_init(&tc->flow_table, &tc->flow_ht_params);
> +	err = rhashtable_init(&tc->flow_table, &tc->flow_ht_params);
> +	if (err) {
> +		kfree(tc->tc_entries_bitmap);
> +		tc->tc_entries_bitmap = NULL;

Why do you set NULL here? All callers of otx2_init_tc() unwind error
properly.

> +	}
> +	return err;
>  }
>  EXPORT_SYMBOL(otx2_init_tc);
>  
> -- 
> 2.25.1
> 
