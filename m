Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B70AC551517
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 12:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240874AbiFTKCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 06:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240775AbiFTKCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 06:02:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96BE513EA5;
        Mon, 20 Jun 2022 03:02:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59CEFB80FBD;
        Mon, 20 Jun 2022 10:02:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2111C3411B;
        Mon, 20 Jun 2022 10:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655719351;
        bh=1Qix9NjjwRWFg9AdThL/ttBW7iUNhaFy23vyffkXhao=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=qTPctW0Iv73c1Acdc9eDe/gAi8E44hgW3RmEHZH3wOXop+ey92ZL8HrMu/y9dTSm/
         BoIMcEOdeLV16nG872tZRRjMBjP6lZ4Z2H08l+pURt8dc8j2f+M8+ugUde6d5q4Fp4
         B/x9dypApDlNhYYMGxeq8BhO3oBSbpGHTdG+FtMxuw8CW8fmhoIqM5zN4MtYon/49t
         EEKyVhMSzujNnyvvJtQGNqi+wjCNVKpSKGBedcf+NYM9XY+R/GvNlOWRyqKrsjwRnB
         6nXzyxDPRawn98BmO14gcB4eWbGEiisppIGEw/7ndBLc4YdRiwzxfxbutL58QGBNxu
         ZgJsHe1hhsocw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v6 1/2] ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <d57bbedc857950659bfacac0ab48790c1eda00c8.1655145743.git.paskripkin@gmail.com>
References: <d57bbedc857950659bfacac0ab48790c1eda00c8.1655145743.git.paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     toke@toke.dk, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+03110230a11411024147@syzkaller.appspotmail.com,
        syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165571934517.23287.2362581008087180339.kvalo@kernel.org>
Date:   Mon, 20 Jun 2022 10:02:28 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pavel Skripkin <paskripkin@gmail.com> wrote:

> Syzbot reported use-after-free Read in ath9k_hif_usb_rx_cb() [0]. The
> problem was in incorrect htc_handle->drv_priv initialization.
> 
> Probable call trace which can trigger use-after-free:
> 
> ath9k_htc_probe_device()
>   /* htc_handle->drv_priv = priv; */
>   ath9k_htc_wait_for_target()      <--- Failed
>   ieee80211_free_hw()              <--- priv pointer is freed
> 
> <IRQ>
> ...
> ath9k_hif_usb_rx_cb()
>   ath9k_hif_usb_rx_stream()
>    RX_STAT_INC()                <--- htc_handle->drv_priv access
> 
> In order to not add fancy protection for drv_priv we can move
> htc_handle->drv_priv initialization at the end of the
> ath9k_htc_probe_device() and add helper macro to make
> all *_STAT_* macros NULL safe, since syzbot has reported related NULL
> deref in that macros [1]
> 
> Link: https://syzkaller.appspot.com/bug?id=6ead44e37afb6866ac0c7dd121b4ce07cb665f60 [0]
> Link: https://syzkaller.appspot.com/bug?id=b8101ffcec107c0567a0cd8acbbacec91e9ee8de [1]
> Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
> Reported-and-tested-by: syzbot+03110230a11411024147@syzkaller.appspotmail.com
> Reported-and-tested-by: syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

2 patches applied to ath-next branch of ath.git, thanks.

0ac4827f78c7 ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
d7fc76039b74 ath9k: htc: clean up statistics macros

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/d57bbedc857950659bfacac0ab48790c1eda00c8.1655145743.git.paskripkin@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

