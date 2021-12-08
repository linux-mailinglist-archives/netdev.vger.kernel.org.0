Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F31346DB4B
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 19:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235445AbhLHSm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 13:42:26 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60208 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbhLHSm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 13:42:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9253B82249;
        Wed,  8 Dec 2021 18:38:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E22E2C00446;
        Wed,  8 Dec 2021 18:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638988731;
        bh=e74LIxMWq2izW3ew6ITjk9h0G9320RPT2aDHAhH5/c0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ANO8jL7E4oBiKF3IHwFtlzH7jJ25cp3nJmJywJtyFMtiHhrkALQM1HjcaQWm8/o2t
         EQcDZZNm2J9cEQgyyx7Vc7/ZyC3+iiODDWC/pty6j8JWovOVVPuJqA2M1MfY16iizX
         VGN6omPg1xqrJYR7Ruyx7XUNbNWy/r7AVGO5owtRMOJRRwwADsUraYrfF+zUxnB1RB
         fCwVEtIkSmHO2qHgr2FUVonF9DOZSKXyarYZLnfTJJGmIzXuiC2imq0A2nTNHyZqE/
         7UHGUz6oZW63j8H+4epbQKUResELenJr2us9+D+eqp0XT4Oea4zxltHXDoe+/ISyxw
         2vztR/vYQDsgw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: mwifiex: Fix possible ABBA deadlock
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <YaV0pllJ5p/EuUat@google.com>
References: <YaV0pllJ5p/EuUat@google.com>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>, amitkarwar@gmail.com,
        ganapathi017@gmail.com, sharvari.harisangam@nxp.com,
        huxinming820@gmail.com, kvalo@codeaurora.org,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Doug Anderson <dianders@chromium.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163898872691.25635.1629545558418383431.kvalo@kernel.org>
Date:   Wed,  8 Dec 2021 18:38:48 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Brian Norris <briannorris@chromium.org> wrote:

> Quoting Jia-Ju Bai <baijiaju1990@gmail.com>:
> 
>   mwifiex_dequeue_tx_packet()
>      spin_lock_bh(&priv->wmm.ra_list_spinlock); --> Line 1432 (Lock A)
>      mwifiex_send_addba()
>        spin_lock_bh(&priv->sta_list_spinlock); --> Line 608 (Lock B)
> 
>   mwifiex_process_sta_tx_pause()
>      spin_lock_bh(&priv->sta_list_spinlock); --> Line 398 (Lock B)
>      mwifiex_update_ralist_tx_pause()
>        spin_lock_bh(&priv->wmm.ra_list_spinlock); --> Line 941 (Lock A)
> 
> Similar report for mwifiex_process_uap_tx_pause().
> 
> While the locking expectations in this driver are a bit unclear, the
> Fixed commit only intended to protect the sta_ptr, so we can drop the
> lock as soon as we're done with it.
> 
> IIUC, this deadlock cannot actually happen, because command event
> processing (which calls mwifiex_process_sta_tx_pause()) is
> sequentialized with TX packet processing (e.g.,
> mwifiex_dequeue_tx_packet()) via the main loop (mwifiex_main_process()).
> But it's good not to leave this potential issue lurking.
> 
> Fixes: f0f7c2275fb9 ("mwifiex: minor cleanups w/ sta_list_spinlock in cfg80211.c")
> Cc: Douglas Anderson <dianders@chromium.org>
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Link: https://lore.kernel.org/linux-wireless/0e495b14-efbb-e0da-37bd-af6bd677ee2c@gmail.com/
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> Reviewed-by: Douglas Anderson <dianders@chromium.org>

Patch applied to wireless-drivers-next.git, thanks.

1b8bb8919ef8 mwifiex: Fix possible ABBA deadlock

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/YaV0pllJ5p/EuUat@google.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

