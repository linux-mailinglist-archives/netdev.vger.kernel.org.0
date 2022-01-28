Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E41F849F971
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 13:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244641AbiA1Mck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 07:32:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232014AbiA1Mcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 07:32:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C18C061714;
        Fri, 28 Jan 2022 04:32:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 685B961B08;
        Fri, 28 Jan 2022 12:32:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5ADAC340E0;
        Fri, 28 Jan 2022 12:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643373158;
        bh=mqbTy9CsLz7Cz2KBshUwDl4dlexueqKy20esKjv4qhM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=eou5gWcQ/FRrzLFCDXr5vWv4vCocX6fM1uLc7tO0L/2pISGj6RbfXXQ75VCkoe9Xr
         0MaC4up0j6UWNaqSAMWaeHqPsD+kne0V4z3qAHv2HR2/rMlJQStk8vpiA4ozqtMXyE
         ET/M+tYxABzRBYdc0W+fyvN1G8TlMuGOZFI1UvfaF8/7M1XgVEp6fdxMVvIuFG+ZVF
         JQv8n8//oedwUDGV74VKIl2aHlqmcasFJCNePlnTkSEhuasOUlMgedo0SXFe51fUgR
         Z8QDZv85zHTWPuSCXwBEKQeas/fz5FguxrSzPIXdD8ZkY6H0qRiYKUw90+fbbDWDXs
         QU4Bj0sUVqHng==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath9k_htc: fix uninit value bugs
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220115122733.11160-1-paskripkin@gmail.com>
References: <20220115122733.11160-1-paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, linville@tuxdriver.com,
        vasanth@atheros.com, Sujith.Manoharan@atheros.com,
        senthilkumar@atheros.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+f83a1df1ed4f67e8d8ad@syzkaller.appspotmail.com
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164337315159.4876.15861801637015517784.kvalo@kernel.org>
Date:   Fri, 28 Jan 2022 12:32:35 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pavel Skripkin <paskripkin@gmail.com> wrote:

> Syzbot reported 2 KMSAN bugs in ath9k. All of them are caused by missing
> field initialization.
> 
> In htc_connect_service() svc_meta_len and pad are not initialized. Based
> on code it looks like in current skb there is no service data, so simply
> initialize svc_meta_len to 0.
> 
> htc_issue_send() does not initialize htc_frame_hdr::control array. Based
> on firmware code, it will initialize it by itself, so simply zero whole
> array to make KMSAN happy
> 
> Fail logs:
> 
> BUG: KMSAN: kernel-usb-infoleak in usb_submit_urb+0x6c1/0x2aa0 drivers/usb/core/urb.c:430
>  usb_submit_urb+0x6c1/0x2aa0 drivers/usb/core/urb.c:430
>  hif_usb_send_regout drivers/net/wireless/ath/ath9k/hif_usb.c:127 [inline]
>  hif_usb_send+0x5f0/0x16f0 drivers/net/wireless/ath/ath9k/hif_usb.c:479
>  htc_issue_send drivers/net/wireless/ath/ath9k/htc_hst.c:34 [inline]
>  htc_connect_service+0x143e/0x1960 drivers/net/wireless/ath/ath9k/htc_hst.c:275
> ...
> 
> Uninit was created at:
>  slab_post_alloc_hook mm/slab.h:524 [inline]
>  slab_alloc_node mm/slub.c:3251 [inline]
>  __kmalloc_node_track_caller+0xe0c/0x1510 mm/slub.c:4974
>  kmalloc_reserve net/core/skbuff.c:354 [inline]
>  __alloc_skb+0x545/0xf90 net/core/skbuff.c:426
>  alloc_skb include/linux/skbuff.h:1126 [inline]
>  htc_connect_service+0x1029/0x1960 drivers/net/wireless/ath/ath9k/htc_hst.c:258
> ...
> 
> Bytes 4-7 of 18 are uninitialized
> Memory access of size 18 starts at ffff888027377e00
> 
> BUG: KMSAN: kernel-usb-infoleak in usb_submit_urb+0x6c1/0x2aa0 drivers/usb/core/urb.c:430
>  usb_submit_urb+0x6c1/0x2aa0 drivers/usb/core/urb.c:430
>  hif_usb_send_regout drivers/net/wireless/ath/ath9k/hif_usb.c:127 [inline]
>  hif_usb_send+0x5f0/0x16f0 drivers/net/wireless/ath/ath9k/hif_usb.c:479
>  htc_issue_send drivers/net/wireless/ath/ath9k/htc_hst.c:34 [inline]
>  htc_connect_service+0x143e/0x1960 drivers/net/wireless/ath/ath9k/htc_hst.c:275
> ...
> 
> Uninit was created at:
>  slab_post_alloc_hook mm/slab.h:524 [inline]
>  slab_alloc_node mm/slub.c:3251 [inline]
>  __kmalloc_node_track_caller+0xe0c/0x1510 mm/slub.c:4974
>  kmalloc_reserve net/core/skbuff.c:354 [inline]
>  __alloc_skb+0x545/0xf90 net/core/skbuff.c:426
>  alloc_skb include/linux/skbuff.h:1126 [inline]
>  htc_connect_service+0x1029/0x1960 drivers/net/wireless/ath/ath9k/htc_hst.c:258
> ...
> 
> Bytes 16-17 of 18 are uninitialized
> Memory access of size 18 starts at ffff888027377e00
> 
> Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
> Reported-by: syzbot+f83a1df1ed4f67e8d8ad@syzkaller.appspotmail.com
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

d1e0df1c57bd ath9k_htc: fix uninit value bugs

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220115122733.11160-1-paskripkin@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

