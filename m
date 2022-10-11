Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79B965FABB2
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 06:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiJKEkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 00:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiJKEkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 00:40:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B6AA2229B;
        Mon, 10 Oct 2022 21:40:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 080B5610A3;
        Tue, 11 Oct 2022 04:40:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF425C433C1;
        Tue, 11 Oct 2022 04:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665463203;
        bh=e9KKMgIAQyHBhjea4hfYXUv3pPjTlJgQE4f/Urrev4M=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=XYtd+pgy7yj9aLks14aUZO7hd6jVsPWFetH7s8xxMOMWEb9l16B+/AyJwTKdnEQTc
         vOZ5Nr2P+bpUsU34Uievayvp7sHkGNlSOehX2J53ieVkmuNIRLOpRU8XA2cSX8E+Y/
         fwLhmkl5fbtXb19mRSfzMpUAel3KNFTkA5KJtZYlExPduYSHd9cHzO3Bj06SAedCC5
         d6dxMSzYu0IjHtnlhWNNjRkc1a6765LCeoCej3TTHAqeJJtE4ZzUS3vLJ0bfgpqxjo
         vHIQTEhNMySHkmTTLt2qhEWdQZR3yEOCkgloUmhdU9yn9wkNLWJTzSGLzSPTvcjie1
         Y61AIxf0dhbkg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] ath9k: hif_usb: Fix use-after-free in
 ath9k_hif_usb_reg_in_cb()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221008114917.21404-1-pchelkin@ispras.ru>
References: <20221008114917.21404-1-pchelkin@ispras.ru>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Fedor Pchelkin <pchelkin@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166546319878.5539.2693721312600090208.kvalo@kernel.org>
Date:   Tue, 11 Oct 2022 04:40:00 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fedor Pchelkin <pchelkin@ispras.ru> wrote:

> It is possible that skb is freed in ath9k_htc_rx_msg(), then
> usb_submit_urb() fails and we try to free skb again. It causes
> use-after-free bug. Moreover, if alloc_skb() fails, urb->context becomes
> NULL but rx_buf is not freed and there can be a memory leak.
> 
> The patch removes unnecessary nskb and makes skb processing more clear: it
> is supposed that ath9k_htc_rx_msg() either frees old skb or passes its
> managing to another callback function.
> 
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
> 
> Fixes: 3deff76095c4 ("ath9k_htc: Increase URB count for REG_IN pipe")
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

dd95f2239fc8 wifi: ath9k: hif_usb: Fix use-after-free in ath9k_hif_usb_reg_in_cb()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221008114917.21404-1-pchelkin@ispras.ru/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

