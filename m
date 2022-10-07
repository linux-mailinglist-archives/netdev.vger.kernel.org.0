Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11295F7C57
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 19:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiJGRhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 13:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiJGRhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 13:37:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85DB6844C9;
        Fri,  7 Oct 2022 10:37:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49C48B818F6;
        Fri,  7 Oct 2022 17:37:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A83C433C1;
        Fri,  7 Oct 2022 17:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665164235;
        bh=DTi6b14jSbRm34BKFC8dqXZhMaF4Gk/Bls6TIZ9xCD0=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=hRxOsuP0Y9X56bZCSdp6BS8JHRs7LiLYqN0Zz0r5zoe4/I382uFiV565tzcKcDWRJ
         evNEOetwdTf25ktD1+arDCXWqHs5f1xzPCmA8/x4SqgbHJ9Yn3zFtWRZi67Xf5Z01Q
         qCysiJzRcWIPTAGhCLGzdE71t7fPV/gLdA/xSUsE5RWYwv7vXGQ9jXxpFZV+f8wPZE
         wMPvknLlBj+RE4+xzXfWZXTj0WOzMz16G3+IqxwGinA4ZHtdUphYR2MVyCih2IJ1Uv
         rKLp+P2s8xzLdq+Bv14TwzY0J6FS8qUjfGkhV8HssoJuKlxiWSKk9XeDtdF29jZrgI
         XuKBEq78asdnA==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id CE7CF64EF23; Fri,  7 Oct 2022 19:37:12 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     Alexander Potapenko <glider@google.com>, glider@google.com
Cc:     ath9k-devel@qca.qualcomm.com, davem@davemloft.net, kuba@kernel.org,
        kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzbot+2ca247c2d60c7023de7f@syzkaller.appspotmail.com
Subject: Re: [PATCH] ath9k: fix an uninit value use in ath9k_htc_rx_msg()
In-Reply-To: <20220825080555.3643572-1-glider@google.com>
References: <20220825080555.3643572-1-glider@google.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 07 Oct 2022 19:37:12 +0200
Message-ID: <87leprcz7b.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Potapenko <glider@google.com> writes:

> ath9k_htc_rx_msg() assumes skb->data contains a full
> `struct htc_frame_hdr`, thus it needs a call to pskb_may_pull()
> to ensure there is enough data.
>
> This fixes a long-standing issue reported by KMSAN:
>
>   BUG: KMSAN: uninit-value in ath9k_htc_rx_msg+0x544/0x980 drivers/net/wireless/ath/ath9k/htc_hst.c:417
>    ath9k_htc_rx_msg+0x544/0x980 drivers/net/wireless/ath/ath9k/htc_hst.c:417
>    ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:653 [inline]
>    ath9k_hif_usb_rx_cb+0x196a/0x1f10 drivers/net/wireless/ath/ath9k/hif_usb.c:686
>    __usb_hcd_giveback_urb+0x522/0x740 drivers/usb/core/hcd.c:1670
>    usb_hcd_giveback_urb+0x150/0x620 drivers/usb/core/hcd.c:1747
>    dummy_timer+0xd3f/0x4f20 drivers/usb/gadget/udc/dummy_hcd.c:1988
>    call_timer_fn+0x43/0x480 kernel/time/timer.c:1474
>    expire_timers+0x272/0x610 kernel/time/timer.c:1519
>    __run_timers+0x5bc/0x8c0 kernel/time/timer.c:1790
>   ...
>
>   Uninit was created at:
>   ...
>    __alloc_skb+0x34a/0xd70 net/core/skbuff.c:426
>    __netdev_alloc_skb+0x126/0x780 net/core/skbuff.c:494
>    __dev_alloc_skb include/linux/skbuff.h:3264 [inline]
>    ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:635 [inline]
>    ath9k_hif_usb_rx_cb+0xe7b/0x1f10 drivers/net/wireless/ath/ath9k/hif_usb.c:686
>    __usb_hcd_giveback_urb+0x522/0x740 drivers/usb/core/hcd.c:1670
>   ...
>
> Reported-by: syzbot+2ca247c2d60c7023de7f@syzkaller.appspotmail.com
> Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
> Signed-off-by: Alexander Potapenko <glider@google.com>

This has been fixed (in a different way) by commit:
b383e8abed41 ("wifi: ath9k: avoid uninit memory read in ath9k_htc_rx_msg()")

-Toke
