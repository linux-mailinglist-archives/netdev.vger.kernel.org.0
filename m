Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED2C530129D
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 04:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbhAWD1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 22:27:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:46754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726609AbhAWD07 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 22:26:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D91723A3A;
        Sat, 23 Jan 2021 03:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611372378;
        bh=jgBcTjJfzZRhrN70p96TpP3po8wq0ajvAAznGOV+x8c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uLQCS571K4dTGZJ/dB26PMOb+KN5mXAokEbnAGyLwW5LN+zvNLN3Etjiodnwq50vl
         moQkGnw54F69QmMBqEXEmi9Icc3EPjiYG0Vc+nNJju6VoI88m8+j47f6oZu+7nu7NV
         /6PkrPc+D0sjeT04ja21GsPIlA3t9e/bfu02UWNkfmxAUwaicFbl+Wda0q9Ag9l8LI
         jL4SHbLLJgWX1FE4fXxSO/DZeu4aRHWSscgr8Q8U/j/zUoyIRQqRYOXJMhrsF+E1SE
         +2YVI6AHVCcBK+XwY8HqOJpkwfUyJHD5nXiZ8kFzhoaWNOA8g/VTe3AyCUEM1UvoVm
         ECcoopR4CVcYA==
Date:   Fri, 22 Jan 2021 19:26:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Simplify the calculation of variables
Message-ID: <20210122192617.2f7994e0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1611305867-88692-1-git-send-email-abaci-bugfix@linux.alibaba.com>
References: <1611305867-88692-1-git-send-email-abaci-bugfix@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Jan 2021 16:57:47 +0800 Jiapeng Zhong wrote:
> Fix the following coccicheck warnings:
> 
>  ./net/ipv4/esp4_offload.c:288:32-34: WARNING !A || A && B is
> equivalent to !A || B.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
> ---
>  net/ipv4/esp4_offload.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
> index 5bda5ae..9ba8cc5 100644
> --- a/net/ipv4/esp4_offload.c
> +++ b/net/ipv4/esp4_offload.c
> @@ -285,7 +285,7 @@ static int esp_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features_
>  	esp.esph = ip_esp_hdr(skb);
>  
>  
> -	if (!hw_offload || (hw_offload && !skb_is_gso(skb))) {
> +	if (!hw_offload || (!skb_is_gso(skb))) {

You can drop the parenthesis around !skb_is_gso(skb) now.

>  		esp.nfrags = esp_output_head(x, skb, &esp);
>  		if (esp.nfrags < 0)
>  			return esp.nfrags;

