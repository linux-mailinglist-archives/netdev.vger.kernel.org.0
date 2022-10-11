Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47C255FABAA
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 06:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiJKEhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 00:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiJKEhl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 00:37:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126E986836;
        Mon, 10 Oct 2022 21:37:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4B72B811DD;
        Tue, 11 Oct 2022 04:37:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C765EC433C1;
        Tue, 11 Oct 2022 04:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665463058;
        bh=FQUIduYjUEs0jAEeoQ8x7+CP+UDbb8VwcjP+WAUjftY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=YhGkFz9iLYo78Wfo2qnLyIlHdvjm89Lna140Qzi583JCmLd6ARDUiZWPXN3j+jP2B
         a9sTt4tkLH3wFr4rvCWj6wu9EyWThdw2XIpZPjjULGQiVuK06k2y7aol+oby+t9z5q
         u/wsv4yWqfandXlmdI570eb3/mquaebkFjebokCFBuoLd2no5tW+W1sdF6ubEohvBj
         8jjg/wN0vBWoDd0lCng5DyE9R2BGTjd3FSxNhOB/Ef4LBpCzgBdm4nlFFF1ovir0Mu
         bnFwXH+NzjUZzO0VDdBZ/mR+rWOIE7c/5/54LsY++yipexW+Z9P2VfsdjOEmKNTOik
         SZCA3HBD2Hm2A==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ath9k: hif_usb: fix memory leak of urbs in
 ath9k_hif_usb_dealloc_tx_urbs()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220725151359.283704-1-pchelkin@ispras.ru>
References: <20220725151359.283704-1-pchelkin@ispras.ru>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Fedor Pchelkin <pchelkin@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Brooke Basile <brookebasile@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166546305360.5539.195125262037434814.kvalo@kernel.org>
Date:   Tue, 11 Oct 2022 04:37:35 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fedor Pchelkin <pchelkin@ispras.ru> wrote:

> Syzkaller reports a long-known leak of urbs in
> ath9k_hif_usb_dealloc_tx_urbs().
> 
> The cause of the leak is that usb_get_urb() is called but usb_free_urb()
> (or usb_put_urb()) is not called inside usb_kill_urb() as urb->dev or
> urb->ep fields have not been initialized and usb_kill_urb() returns
> immediately.
> 
> The patch removes trying to kill urbs located in hif_dev->tx.tx_buf
> because hif_dev->tx.tx_buf is not supposed to contain urbs which are in
> pending state (the pending urbs are stored in hif_dev->tx.tx_pending).
> The tx.tx_lock is acquired so there should not be any changes in the list.
> 
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
> 
> Fixes: 03fb92a432ea ("ath9k: hif_usb: fix race condition between usb_get_urb() and usb_kill_anchored_urbs()")
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

c2a94de38c74 wifi: ath9k: hif_usb: fix memory leak of urbs in ath9k_hif_usb_dealloc_tx_urbs()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220725151359.283704-1-pchelkin@ispras.ru/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

