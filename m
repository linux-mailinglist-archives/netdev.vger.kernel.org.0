Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54EFD2BB9EA
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 00:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729404AbgKTXRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 18:17:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:45512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726255AbgKTXRQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 18:17:16 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97CE52240B;
        Fri, 20 Nov 2020 23:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605914236;
        bh=KvO84Nal/tJn9KZ59r6ifWaSbl38e4OTyNa1SPsm4hk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YjH/R92g11wYtasnpI/valctwreQ9Di/QydAA7gZcTZVno+oaZJwdrWX81itAm5DE
         7z+fa7yM0T9nSHeDOy97yjdCaXnVkuKn11IUmWZcm/S6E4GeJrGEGB+6YaZb7KXCQ/
         sRuJE7DwgNZy6Kfnelc3+n6iRLARGrKwG83X3pNM=
Date:   Fri, 20 Nov 2020 15:17:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     xiakaixu1987@gmail.com, Ion Badulescu <ionut@badula.org>
Cc:     ionut@badula.org, leon@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kaixu Xia <kaixuxia@tencent.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] net: adaptec: remove dead code in set_vlan_mode
Message-ID: <20201120151714.0cc2f00b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1605858600-7096-1-git-send-email-kaixuxia@tencent.com>
References: <1605858600-7096-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Nov 2020 15:50:00 +0800 xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> The body of the if statement can be executed only when the variable
> vlan_count equals to 32, so the condition of the while statement can
> not be true and the while statement is dead code. Remove it.
> 
> Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> ---
>  drivers/net/ethernet/adaptec/starfire.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/adaptec/starfire.c b/drivers/net/ethernet/adaptec/starfire.c
> index 555299737b51..ad27a9fa5e95 100644
> --- a/drivers/net/ethernet/adaptec/starfire.c
> +++ b/drivers/net/ethernet/adaptec/starfire.c
> @@ -1754,14 +1754,9 @@ static u32 set_vlan_mode(struct netdev_private *np)
>  		filter_addr += 16;
>  		vlan_count++;
>  	}
> -	if (vlan_count == 32) {
> +	if (vlan_count == 32)
>  		ret |= PerfectFilterVlan;
> -		while (vlan_count < 32) {
> -			writew(0, filter_addr);
> -			filter_addr += 16;
> -			vlan_count++;
> -		}
> -	}
> +
>  	return ret;
>  }
>  #endif /* VLAN_SUPPORT */

This got broken back in 2011:

commit 5da96be53a16a62488316810d0c7c5d58ce3ee4f
Author: Jiri Pirko <jpirko@redhat.com>
Date:   Wed Jul 20 04:54:31 2011 +0000

    starfire: do vlan cleanup
    
    - unify vlan and nonvlan rx path
    - kill np->vlgrp and netdev_vlan_rx_register
    
    Signed-off-by: Jiri Pirko <jpirko@redhat.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

The comparison to 32 was on a different variable before that change.

Ion, do you think anyone is still using this driver?

Maybe it's time we put it in the history book (by which I mean remove
from the kernel).
