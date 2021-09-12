Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E901407FB1
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 21:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236017AbhILT3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 15:29:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234625AbhILT3O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Sep 2021 15:29:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D5FC60F6C;
        Sun, 12 Sep 2021 19:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631474879;
        bh=vmtoFuG0plpPFF+EQhhTtgHGfdTsRfks9YatKXBlEeQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j+Fckx/eoaFlsEVTEDbx5ul9vBoH7/iYrdmWBpOKDmeptkrcvSfHQpJa27yVzWT84
         SNsC9UzDPYBzovTcZ9Oyt/mEltGokJ8RQ2mV1ayDiAiA6wCw95WUSr3cpcbyg+5vDu
         Yjb8mytvs3rNrrQuLTAo7PDBmZaa+uToQ4k4jFFxJwBZc2366cRl5bkaddRGdyROp9
         yeSr9Kjb1escQT8pibROK3y9sPWOqbHX+Kx9z7ugl7Z1EQuNIZKR7zckLz+mPiVOpC
         N325kZBrI2Rx6d9jopqvmogWBSKJlaFsjQdrr4oCNi9WqKVGD8u+1GJ5EiDnOwN7oT
         NWcOIomD5Dyzw==
Date:   Sun, 12 Sep 2021 14:31:40 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Len Baker <len.baker@gmx.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kees Cook <keescook@chromium.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath11k: Replace one-element array with flexible-array
 member
Message-ID: <20210912193140.GC146608@embeddedor>
References: <20210904114937.6644-1-len.baker@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210904114937.6644-1-len.baker@gmx.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


There is already a patch for this:

https://lore.kernel.org/lkml/20210823172159.GA25800@embeddedor/

which I will now add to my -next tree.

Thanks
--
Gustavo

On Sat, Sep 04, 2021 at 01:49:37PM +0200, Len Baker wrote:
> There is a regular need in the kernel to provide a way to declare having
> a dynamically sized set of trailing elements in a structure. Kernel code
> should always use "flexible array members"[1] for these cases. The older
> style of one-element or zero-length arrays should no longer be used[2].
> 
> Also, refactor the code a bit to make use of the struct_size() helper in
> kzalloc().
> 
> [1] https://en.wikipedia.org/wiki/Flexible_array_member
> [2] https://www.kernel.org/doc/html/v5.14/process/deprecated.html#zero-length-and-one-element-arrays
> 
> Signed-off-by: Len Baker <len.baker@gmx.com>
> ---
>  drivers/net/wireless/ath/ath11k/reg.c | 7 ++-----
>  drivers/net/wireless/ath/ath11k/wmi.h | 2 +-
>  2 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/reg.c b/drivers/net/wireless/ath/ath11k/reg.c
> index e1a1df169034..c83d265185f1 100644
> --- a/drivers/net/wireless/ath/ath11k/reg.c
> +++ b/drivers/net/wireless/ath/ath11k/reg.c
> @@ -97,7 +97,6 @@ int ath11k_reg_update_chan_list(struct ath11k *ar)
>  	struct channel_param *ch;
>  	enum nl80211_band band;
>  	int num_channels = 0;
> -	int params_len;
>  	int i, ret;
> 
>  	bands = hw->wiphy->bands;
> @@ -117,10 +116,8 @@ int ath11k_reg_update_chan_list(struct ath11k *ar)
>  	if (WARN_ON(!num_channels))
>  		return -EINVAL;
> 
> -	params_len = sizeof(struct scan_chan_list_params) +
> -			num_channels * sizeof(struct channel_param);
> -	params = kzalloc(params_len, GFP_KERNEL);
> -
> +	params = kzalloc(struct_size(params, ch_param, num_channels),
> +			 GFP_KERNEL);
>  	if (!params)
>  		return -ENOMEM;
> 
> diff --git a/drivers/net/wireless/ath/ath11k/wmi.h b/drivers/net/wireless/ath/ath11k/wmi.h
> index d35c47e0b19d..d9c83726f65d 100644
> --- a/drivers/net/wireless/ath/ath11k/wmi.h
> +++ b/drivers/net/wireless/ath/ath11k/wmi.h
> @@ -3608,7 +3608,7 @@ struct wmi_stop_scan_cmd {
>  struct scan_chan_list_params {
>  	u32 pdev_id;
>  	u16 nallchans;
> -	struct channel_param ch_param[1];
> +	struct channel_param ch_param[];
>  };
> 
>  struct wmi_scan_chan_list_cmd {
> --
> 2.25.1
> 
