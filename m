Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA9B49D88F
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 03:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235447AbiA0Czy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 21:55:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235355AbiA0Czy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 21:55:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40129C06161C;
        Wed, 26 Jan 2022 18:55:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2155615C6;
        Thu, 27 Jan 2022 02:55:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0323DC340E7;
        Thu, 27 Jan 2022 02:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643252153;
        bh=OIXCx8u8XiNTdbHm8Qzedtuglcqhczz5oQQNj2qRhSE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bsX1Q0HbP6j0fkQcAfCAtNBtapvdfKPpgB29m8iiWEEUGhsJT+W+TFdNEsDDTy4lm
         eJJmF0ux8RrSIcwTF77O2ex9nAdHkDV3ozDR5f/jp1NuBwSRpixAjxufY9d+s/SRGy
         rEu0EwcWY8LBixDsp3Ni3SfAzsbdj2G4Lv3siVLTlI9w7cUR711HDcZJFvKQ8c+xAD
         TzPvC0Id+H7+xwffGfFJKDxhiIrlTu7iedvm8yQMzf5QJwmw/MSeurq1nJ0A4Lsw8F
         cMIdT6SpQ9VlaVCzX/qPNQDQXE20ldcujL/x5KSVF119XLTvrU+w1kJDl7ixHawuuO
         8UUhH/pAIFkOA==
Date:   Wed, 26 Jan 2022 18:55:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeffrey Ji <jeffreyjilinux@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Brian Vazquez <brianvv@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jeffreyji <jeffreyji@google.com>
Subject: Re: [PATCH v4 net-next] net-core: add InMacErrors counter
Message-ID: <20220126185552.57d5b99e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220125232424.2487391-1-jeffreyji@google.com>
References: <20220125232424.2487391-1-jeffreyji@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jan 2022 23:24:24 +0000 Jeffrey Ji wrote:
> v3-4:
> Remove Change-Id
> 
> v2:
> Use skb_free_reason() for tracing
> Add real-life example in patch msg
> 
> Signed-off-by: jeffreyji <jeffreyji@google.com>
> ---
>  include/linux/skbuff.h    |  1 +
>  include/uapi/linux/snmp.h |  1 +
>  net/ipv4/ip_input.c       |  7 +++++--
>  net/ipv4/proc.c           |  1 +
>  net/ipv6/ip6_input.c      | 12 +++++++-----
>  net/ipv6/proc.c           |  1 +
>  6 files changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index bf11e1fbd69b..04a36352f677 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -320,6 +320,7 @@ enum skb_drop_reason {
>  	SKB_DROP_REASON_TCP_CSUM,
>  	SKB_DROP_REASON_TCP_FILTER,
>  	SKB_DROP_REASON_UDP_CSUM,
> +	SKB_DROP_REASON_BAD_DEST_MAC,

Ah, sorry I missed that you pulled in the reason in v3, I thought you'd
leave it to Menglong. Either way is fine, but "BAD_DEST_MAC" is
probably not the most fortunate name for this reason code.
Menglong had OTHERHOST - that seems more intuitive to me, the MAC
address is not bad, it's just not the address of the local host.
