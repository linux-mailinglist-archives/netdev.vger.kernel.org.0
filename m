Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3F7649090E
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 13:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237054AbiAQM5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 07:57:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34104 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231817AbiAQM5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 07:57:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAE63611D6;
        Mon, 17 Jan 2022 12:57:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51487C36AE3;
        Mon, 17 Jan 2022 12:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642424231;
        bh=KYCJFH4TJNJVoyp6LMjBK914/TONjYQ+DoTq7OLwXTw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=gm8FXLd/Ub7vOouMlpStEqLksxhtLS+2LSnYN+drUS5x8juNuJTil1Us+nju//kFk
         0Up/1AnWefkkLOAg6f7UdkTyZ67pq9cduaeMztpRxgZ70h6wJO9u0hRLx5H4mRjMe6
         Jku52Zo94zFgFHRWyyASCPwUPShEOS2hZCWu03ITByb3bj+IJ8PtOtcbnlMsOCExDf
         surKlCAXdms2bDnIW/mtALPR1i2T05oJzvbCw7cHgrCwFAxhyKcsMq8LejsTC+DThx
         GZdtB8gJt1Q6YLoY/WeM5FWKwCFBvMTgjmvVciVmXaxRqsisIzn18RDDc/b3iYs55I
         dLNUR0SJY0MWA==
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
Message-ID: <164242422410.16718.5618838300043178474.kvalo@kernel.org>
Date:   Mon, 17 Jan 2022 12:57:08 +0000 (UTC)
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

How did you test this? As syzbot is mentioned I assume you did not test this on
a real device, it would help a lot if this is clearly mentioned in the commit
log. My trust on syzbot fixes is close to zero due to bad past history.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220115122733.11160-1-paskripkin@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

