Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF5D032FFD9
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 10:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbhCGJSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 04:18:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:39550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230070AbhCGJSH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Mar 2021 04:18:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31EDB65135;
        Sun,  7 Mar 2021 09:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615108686;
        bh=hmbvo4CsBfdIYvP8uNbcauFppXo+TwHppHp6RrtgvqY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dMMrjfx5hV1WA1fNztS+ezPiQfSOxtEWJ0fdAo4twFhkWET8svomz9cbgO9bwiH6I
         Bzp336EEY5Ma1a1DJU0ojjGpYZvfclmwTD2izNEQfjDVRVzTJiZASBkB48UIt3gA8t
         eWDonlL5sCoShpOHP21ng8Hpokhk+g8DfATaTFJak+EnZ/WhRxEzbKvkWqoEZqJxT2
         zdyBGGIp5XAsB/rDHIlHgnM8dXxb2A/TdwYE/Sm0yX3SkFOIaD1wLMKnRypLMiKIkt
         eO43SS0qASn6+q62Pp+AMYe3WzQ196sHi5zjqZ/uqvWvB4i47mWGpxQ/8ByTd74kVU
         fHKIKR+rblzCg==
Date:   Sun, 7 Mar 2021 11:18:03 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath: ath6kl: fix error return code of
 ath6kl_htc_rx_bundle()
Message-ID: <YESaSwoGRxGvrggv@unreal>
References: <20210307090757.22617-1-baijiaju1990@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210307090757.22617-1-baijiaju1990@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 07, 2021 at 01:07:57AM -0800, Jia-Ju Bai wrote:
> When hif_scatter_req_get() returns NULL to scat_req, no error return
> code of ath6kl_htc_rx_bundle() is assigned.
> To fix this bug, status is assigned with -EINVAL in this case.
>
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
>  drivers/net/wireless/ath/ath6kl/htc_mbox.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath6kl/htc_mbox.c b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
> index 998947ef63b6..3f8857d19a0c 100644
> --- a/drivers/net/wireless/ath/ath6kl/htc_mbox.c
> +++ b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
> @@ -1944,8 +1944,10 @@ static int ath6kl_htc_rx_bundle(struct htc_target *target,
>
>  	scat_req = hif_scatter_req_get(target->dev->ar);
>
> -	if (scat_req == NULL)
> +	if (scat_req == NULL) {
> +		status = -EINVAL;

I'm not sure about it.

David. Jakub,
Please be warned that patches from this guy are not so great.
I looked on 4 patches and 3 of them were wrong (2 in RDMA and 1 for mlx5)
plus this patch most likely is incorrect too.

Thanks

>  		goto fail_rx_pkt;
> +	}
>
>  	for (i = 0; i < n_scat_pkt; i++) {
>  		int pad_len;
> --
> 2.17.1
>
