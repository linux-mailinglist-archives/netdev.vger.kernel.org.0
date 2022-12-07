Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6FE64562F
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 10:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbiLGJNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 04:13:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbiLGJMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 04:12:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D7211B;
        Wed,  7 Dec 2022 01:12:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C39EB80189;
        Wed,  7 Dec 2022 09:12:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 582E7C433D6;
        Wed,  7 Dec 2022 09:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670404349;
        bh=fQa6B7E0Sk8yD7Z1ApAog2OUJ3gEMBIbSKp3KTXR5Co=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LdCl54ESA51k3chtydSBzfMUZGWmc+kMfLRk4eI7dpVYPq+4r36oiHVvfzqPTnmmv
         4ftXtc98gIzTgMHHIF4Y4jtQG/ca7pciF1J39Gon2IrB2bYHwAWRm4PcjGRLW/j2xt
         H2mfj4QWT+tBge/2vsM2Hi77ptoGhfcUwx+jhsKaZosI58yehEJavBPMcsJq82pYnG
         Tl5102MRgBdTAGkcuBdCw68qE+lRDrcpCR6XhNdFAVsQ8tLMzIDCcXJxz69j0KfYpc
         9D0uBrGCxHHSDXffT4+yTnqwIDtr6Wetw/1L2VWDB+NkSZkzL9bE6N54C5BaqCQ1++
         NU4crXp14djwg==
Date:   Wed, 7 Dec 2022 11:12:25 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: stmmac: selftests: fix potential memleak in
 stmmac_test_arpoffload()
Message-ID: <Y5BY+ZpW20XpkVZw@unreal>
References: <1670401920-7574-1-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1670401920-7574-1-git-send-email-zhangchangzhong@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 04:31:59PM +0800, Zhang Changzhong wrote:
> The skb allocated by stmmac_test_get_arp_skb() hasn't been released in
> some error handling case, which will lead to a memory leak. Fix this up
> by adding kfree_skb() to release skb.
> 
> Compile tested only.
> 
> Fixes: 5e3fb0a6e2b3 ("net: stmmac: selftests: Implement the ARP Offload test")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
> index 49af7e7..687f43c 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
> @@ -1654,12 +1654,16 @@ static int stmmac_test_arpoffload(struct stmmac_priv *priv)
>  	}
>  
>  	ret = stmmac_set_arp_offload(priv, priv->hw, true, ip_addr);
> -	if (ret)
> +	if (ret) {
> +		kfree_skb(skb);
>  		goto cleanup;
> +	}
>  
>  	ret = dev_set_promiscuity(priv->dev, 1);
> -	if (ret)
> +	if (ret) {
> +		kfree_skb(skb);
>  		goto cleanup;
> +	}
>  
>  	ret = dev_direct_xmit(skb, 0);
>  	if (ret)

You should release skb here too. So the better patch will be to write
something like that:

cleanup:
  stmmac_set_arp_offload(priv, priv->hw, false, 0x0);
  if (ret)
  	kfree_skb(skb);

Thanks

> -- 
> 2.9.5
> 
