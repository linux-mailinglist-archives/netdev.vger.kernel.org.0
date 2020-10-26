Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037C029924E
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 17:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1785799AbgJZQYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 12:24:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1785790AbgJZQYE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 12:24:04 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25C2522284;
        Mon, 26 Oct 2020 16:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603729444;
        bh=sWOMT7WbWdFXhjs8Zf0K00oVZnP0NtKQ0lk3D8kl7WA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IIOyV2+t7CPsr4YWE2sSaYX5mmMHMgvCjOI3AwYfyNkaIUv2YEhaP7yBmAvv61y9x
         91NxVJR/BielzJwEVHWbWzU6l5Sj0+QUPC+JJw4YuVNzB415aCYJxhMZGVqZ/7twIZ
         7H9Mm1y69YvYN6JcSCenuvwIbQ2qxqLYSZNHcU4Y=
Date:   Mon, 26 Oct 2020 09:24:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yi Li <yili@winhong.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net/core/dev.c : Use skb_is_gso
Message-ID: <20201026092403.5e0634f3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201026013435.1910386-1-yili@winhong.com>
References: <20201023135709.0f89fd59@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20201026013435.1910386-1-yili@winhong.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Oct 2020 09:34:35 +0800 Yi Li wrote:
> Trivial fix to use func skb_is_gso in place of
> test for skb_shinfo(skb)->gso_size.
> 
> Signed-off-by: Yi Li <yili@winhong.com>

So you gave up on all the drivers now?

Please replace the word "fix" in the commit message with "refactoring",
the resulting code is identical.

The subject should be something like

net: core: Use skb_is_gso() in skb_checksum_help()

> diff --git a/net/core/dev.c b/net/core/dev.c
> index 9499a414d67e..55f66e108059 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -3205,7 +3205,7 @@ int skb_checksum_help(struct sk_buff *skb)
>  	if (skb->ip_summed == CHECKSUM_COMPLETE)
>  		goto out_set_summed;
>  
> -	if (unlikely(skb_shinfo(skb)->gso_size)) {
> +	if (unlikely(skb_is_gso(skb))) {
>  		skb_warn_bad_offload(skb);
>  		return -EINVAL;
>  	}

