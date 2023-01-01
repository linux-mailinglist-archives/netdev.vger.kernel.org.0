Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 946E665A93E
	for <lists+netdev@lfdr.de>; Sun,  1 Jan 2023 08:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjAAHoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Jan 2023 02:44:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjAAHox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Jan 2023 02:44:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 142FB6241;
        Sat, 31 Dec 2022 23:44:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A40BB60CFB;
        Sun,  1 Jan 2023 07:44:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FFEFC433D2;
        Sun,  1 Jan 2023 07:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672559091;
        bh=59eVHOxrFMgU3R7WYLVhvDVwYrTPlF5buBzKHCX931k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=is7+RLaLyADQ4dKsPNK1KChFOHA9VTV9UI3BiJeAitFOZE5tm1gC2gH96BKujzrJH
         kbPyvzDoO0F3jPcBVykTXOMeDUyHZkBmzje8HI5wd3SJVvsZLxCs/5ijuXtNJnfYfj
         IGsur9tnSLdBN/pjo/LCmp+8jyqBjzLKsCmUFzKgfb7tZAboXyT5qWWag8ldq07yU5
         8l3k3E83rhuXlfQgslr82WtPB5bpuOntF6uV2t7S3263CNKSxPBPkp8byDwekjW7Mx
         NfNJMbKyIYszXDt8vnyiHwUWyRNIYLQyW3OMmKrTKFO84RENpDWF8IRvMUGQc9nZ0/
         8MxfZt+3KLXJw==
Date:   Sun, 1 Jan 2023 09:44:46 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Miaoqian Lin <linmq006@gmail.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: ath11k: Fix memory leak in
 ath11k_peer_rx_frag_setup
Message-ID: <Y7E57sQ9LiJWefoj@unreal>
References: <20221229073849.1388315-1-linmq006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221229073849.1388315-1-linmq006@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 29, 2022 at 11:38:48AM +0400, Miaoqian Lin wrote:
> crypto_alloc_shash() allocates resources, which should be released by
> crypto_free_shash(). When ath11k_peer_find() fails, there has memory
> leak. Move crypto_alloc_shash() after ath11k_peer_find() to fix this.
> 
> Fixes: 243874c64c81 ("ath11k: handle RX fragments")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> ---
>  drivers/net/wireless/ath/ath11k/dp_rx.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
> index c5a4c34d7749..1297caa2b09a 100644
> --- a/drivers/net/wireless/ath/ath11k/dp_rx.c
> +++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
> @@ -3116,10 +3116,6 @@ int ath11k_peer_rx_frag_setup(struct ath11k *ar, const u8 *peer_mac, int vdev_id
>  	struct dp_rx_tid *rx_tid;
>  	int i;
>  
> -	tfm = crypto_alloc_shash("michael_mic", 0, 0);
> -	if (IS_ERR(tfm))
> -		return PTR_ERR(tfm);
> -
>  	spin_lock_bh(&ab->base_lock);
>  
>  	peer = ath11k_peer_find(ab, vdev_id, peer_mac);
> @@ -3129,6 +3125,10 @@ int ath11k_peer_rx_frag_setup(struct ath11k *ar, const u8 *peer_mac, int vdev_id
>  		return -ENOENT;
>  	}
>  
> +	tfm = crypto_alloc_shash("michael_mic", 0, 0);
> +	if (IS_ERR(tfm))
> +		return PTR_ERR(tfm);
> +

You forgot to unlock ab->base_lock.

Thanks

>  	for (i = 0; i <= IEEE80211_NUM_TIDS; i++) {
>  		rx_tid = &peer->rx_tid[i];
>  		rx_tid->ab = ab;
> -- 
> 2.25.1
> 
