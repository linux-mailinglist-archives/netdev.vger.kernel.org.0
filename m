Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5360147E6A5
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 18:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349407AbhLWRLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 12:11:04 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49016 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349380AbhLWRLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 12:11:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D256EB80780;
        Thu, 23 Dec 2021 17:11:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A9FC36AE5;
        Thu, 23 Dec 2021 17:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640279461;
        bh=NVrm8QQrQKQ04bfitFX3knY/SkSL31uGMA/v6Uz+VLU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UwnENRbV0tKoLctuPqFpO2NQMV2EVgiNkB45xBdv06zteSWVqcIoboLaJxkRGRp6H
         GATR0kQqnB+fpMuGk27uOg2HfivR5sQ17rfJb6sno2LelfOUfZgQrkwoxbT+m1Gkfq
         wnHC2cvnoLmvzcRzpqXbnjNuoIRb0aEGLj8cT47k/6hPs76cwqmips4j980bBsLO4x
         h2gaSkpKeFRd64llKrvAUpTnW4hmHflSqf01GMTEJk20wxL7QbFlIb7k6z8/slhoSR
         M0LfQkYHYvplzAJgzMHkQFKHIloUWFnw/DDEoSV28pTuIxBltzkV89CVViDofsGjUB
         VotwzEeJ6KZYQ==
Date:   Thu, 23 Dec 2021 09:11:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huangzhaoyang <huangzhaoyang@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Zhaoyang Huang <zhaoyang.huang@unisoc.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: remove judgement based on gfp_flags
Message-ID: <20211223091100.4a86188f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1640224567-3014-1-git-send-email-huangzhaoyang@gmail.com>
References: <1640224567-3014-1-git-send-email-huangzhaoyang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Dec 2021 09:56:07 +0800 Huangzhaoyang wrote:
> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> 
> The parameter allocation here is used for indicating if the memory
> allocation can stall or not. Since we have got the skb buffer, it
> doesn't make sense to check if we can yield on the net's congested
> via gfp_flags. Remove it now.

This is checking if we can sleep AFAICT. What are you trying to fix?

> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> index 4c57532..af5b6af 100644
> --- a/net/netlink/af_netlink.c
> +++ b/net/netlink/af_netlink.c
> @@ -1526,7 +1526,7 @@ int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, u32 portid,
>  	consume_skb(info.skb2);
>  
>  	if (info.delivered) {
> -		if (info.congested && gfpflags_allow_blocking(allocation))
> +		if (info.congested)
>  			yield();
>  		return 0;
>  	}

