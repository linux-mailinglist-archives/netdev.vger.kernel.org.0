Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3E3469C6DC
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 09:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbjBTIhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 03:37:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbjBTIhr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 03:37:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 877DEC173;
        Mon, 20 Feb 2023 00:37:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 240A960D14;
        Mon, 20 Feb 2023 08:37:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38329C433EF;
        Mon, 20 Feb 2023 08:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676882265;
        bh=8f1D+Z12x203nZ+u4Ux3xh5ZrKibvtIrydWkzQU+56Q=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=J+/B7nAe5f9il3veO94aI8Hh3B3xMVn8q2b+e4Nyyf94/2FRzaMrngyAuZNd5R5dR
         ToC0y4KtRsHfPD6MYl1pYlHpws821vIjvn4+l3xGxFAbFlyL4Ue2rsDjU3W7kMVa+d
         agNGwjl0o7dA89WBXIE0y72qUTCWQe4osLkuLoooCrtsuXwmKI57HysJufB7Gqehlc
         9iRAGN8S32BxrKxLKiwY3wVqXLgg1pa+ERrXcPRmMFE8hjnfTZYQgO+gj2W22XuXPb
         vewQ9tTVJYV7l9IZFXCAhvNMMnDPs51mapQEhuXm7GiAAZo1uf668QVyWWQ//ca9T6
         IxNsl3knhpEVQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] wifi: ath9k: hif_usb: fix memory leak of remain_skbs
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230216192301.171225-1-pchelkin@ispras.ru>
References: <20230216192301.171225-1-pchelkin@ispras.ru>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Fedor Pchelkin <pchelkin@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        Sujith <Sujith.Manoharan@atheros.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167688226015.14547.4105031164062173921.kvalo@kernel.org>
Date:   Mon, 20 Feb 2023 08:37:42 +0000 (UTC)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fedor Pchelkin <pchelkin@ispras.ru> wrote:

> hif_dev->remain_skb is allocated and used exclusively in
> ath9k_hif_usb_rx_stream(). It is implied that an allocated remain_skb is
> processed and subsequently freed (in error paths) only during the next
> call of ath9k_hif_usb_rx_stream().
> 
> So, if the urbs are deallocated between those two calls due to the device
> deinitialization or suspend, it is possible that ath9k_hif_usb_rx_stream()
> is not called next time and the allocated remain_skb is leaked. Our local
> Syzkaller instance was able to trigger that.
> 
> remain_skb makes sense when receiving two consecutive urbs which are
> logically linked together, i.e. a specific data field from the first skb
> indicates a cached skb to be allocated, memcpy'd with some data and
> subsequently processed in the next call to ath9k_hif_usb_rx_stream(). Urbs
> deallocation supposedly makes that link irrelevant so we need to free the
> cached skb in those cases.
> 
> Fix the leak by introducing a function to explicitly free remain_skb (if
> it is not NULL) when the rx urbs have been deallocated. remain_skb is NULL
> when it has not been allocated at all (hif_dev struct is kzalloced) or
> when it has been processed in next call to ath9k_hif_usb_rx_stream().
> 
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
> 
> Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

7654cc03eb69 wifi: ath9k: hif_usb: fix memory leak of remain_skbs

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230216192301.171225-1-pchelkin@ispras.ru/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

