Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4075159CD
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 04:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382063AbiD3CdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 22:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240220AbiD3CdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 22:33:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8892AD373C;
        Fri, 29 Apr 2022 19:29:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25BFBB83792;
        Sat, 30 Apr 2022 02:29:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90FE7C385A4;
        Sat, 30 Apr 2022 02:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651285791;
        bh=WxGjH9GKenJrHMdsgC8yGrUfMI9wd/YwLo7QxqxqxPY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e0F0h9apwdB52hZ8fLCXYvdhk8V5VYVpoj38Wn+/DI7J5/Jnrv8WrOidpGYNKvxAI
         IuZcwFfEV+pD4MZT7ROJQk3d4+0dNnoRqw6pgb6mj49PoCqK/26A0cJ5KYxns/2Wqt
         H/5leMQEmoIeLVgtGTd2oixsrkEkCbeYKbctuHa7uoYH+zjhzaQ+rZeab3jIrIvf7D
         bE15ybc5oMipOne9nU0pGRav8/Jo6nNODUtraAppT21Mhf89WhxdIbGIfxFhRZUF4U
         fA/IAqsKgLoDx2GuVxLhdvU8jDXJyj/Der9pIvZeZ13qGRHAjDyroj4h8FANg7znKs
         Q4YbcgnG02WIQ==
Date:   Fri, 29 Apr 2022 19:29:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <ioana.ciornei@nxp.com>, <davem@davemloft.net>,
        <robert-ionut.alexa@nxp.com>
Subject: Re: [PATCH] net: dpaa2-mac: add missing of_node_put() in
 dpaa2_mac_get_node()
Message-ID: <20220429192950.5a1d23cc@kernel.org>
In-Reply-To: <20220428100127.542399-1-yangyingliang@huawei.com>
References: <20220428100127.542399-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Apr 2022 18:01:27 +0800 Yang Yingliang wrote:
> Add missing of_node_put() in error path in dpaa2_mac_get_node().
> 
> Fixes: 5b1e38c0792c ("dpaa2-mac: bail if the dpmacs fwnode is not found")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> index c48811d3bcd5..a91446685526 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> @@ -108,8 +108,11 @@ static struct fwnode_handle *dpaa2_mac_get_node(struct device *dev,
>  		return ERR_PTR(-EPROBE_DEFER);
>  	}
>  
> -	if (!parent)
> +	if (!parent) {
> +		if (dpmacs)
> +			of_node_put(dpmacs);

of_node_put() accepts NULL. I know this because unlike you I did 
at least the bare minimum looking at the surrounding code and saw 
other places not checking if it's NULL.
