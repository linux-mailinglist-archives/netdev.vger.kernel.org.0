Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0075379AE
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 13:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235627AbiE3LTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 07:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbiE3LTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 07:19:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB6F723F;
        Mon, 30 May 2022 04:19:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69AC7B80D80;
        Mon, 30 May 2022 11:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11DD9C385B8;
        Mon, 30 May 2022 11:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653909588;
        bh=jB0MVIdn8WlgNUy4ciQ0vHBFgioYsWLUFQJQmy6Vqm8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=s8jMUV5xtidVexQ9IBGsrfzG5cTNTt5VUTgs4fjQQGzWEmw08e6Bu3fhsPFDhXtTL
         Z124M0oIBAbOM/6e33coPy+jxYoeElsg1PU3jqm7vBYX/2BIwJzIH1s3WZ2RjqCskR
         yNmdhL1wWY4FYJxVCvQbMbQzkHvqssU8Fvv80oJjkW9/8hsjmioaHqxSE8djofEIq3
         rE2OQXBQDGywA2SSWUKclL0nHk26ZUlOEK+ZLbYrAKltYlWsfAnjMJObxbA0W5p5uH
         2XHSaY8xvP8gY5lzfj3uoKHLf6EF3pBOU+n7DoveW41HrWcSyBc/VfaFUJe7ckegPu
         RsZNyQNlBUgkA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC] ath11k: fix netdev open race
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220517103436.15867-1-johan+linaro@kernel.org>
References: <20220517103436.15867-1-johan+linaro@kernel.org>
To:     Johan Hovold <johan+linaro@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165390958400.3436.14756419956692693750.kvalo@kernel.org>
Date:   Mon, 30 May 2022 11:19:45 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johan Hovold <johan+linaro@kernel.org> wrote:

> Make sure to allocate resources needed before registering the device.
> 
> This specifically avoids having a racing open() trigger a BUG_ON() in
> mod_timer() when ath11k_mac_op_start() is called before the
> mon_reap_timer as been set up.
> 
> I did not see this issue with next-20220310, but I hit it on every probe
> with next-20220511. Perhaps some timing changed in between.
> 
> Here's the backtrace:
> 
> [   51.346947] kernel BUG at kernel/time/timer.c:990!
> [   51.346958] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
> ...
> [   51.578225] Call trace:
> [   51.583293]  __mod_timer+0x298/0x390
> [   51.589518]  mod_timer+0x14/0x20
> [   51.595368]  ath11k_mac_op_start+0x41c/0x4a0 [ath11k]
> [   51.603165]  drv_start+0x38/0x60 [mac80211]
> [   51.610110]  ieee80211_do_open+0x29c/0x7d0 [mac80211]
> [   51.617945]  ieee80211_open+0x60/0xb0 [mac80211]
> [   51.625311]  __dev_open+0x100/0x1c0
> [   51.631420]  __dev_change_flags+0x194/0x210
> [   51.638214]  dev_change_flags+0x24/0x70
> [   51.644646]  do_setlink+0x228/0xdb0
> [   51.650723]  __rtnl_newlink+0x460/0x830
> [   51.657162]  rtnl_newlink+0x4c/0x80
> [   51.663229]  rtnetlink_rcv_msg+0x124/0x390
> [   51.669917]  netlink_rcv_skb+0x58/0x130
> [   51.676314]  rtnetlink_rcv+0x18/0x30
> [   51.682460]  netlink_unicast+0x250/0x310
> [   51.688960]  netlink_sendmsg+0x19c/0x3e0
> [   51.695458]  ____sys_sendmsg+0x220/0x290
> [   51.701938]  ___sys_sendmsg+0x7c/0xc0
> [   51.708148]  __sys_sendmsg+0x68/0xd0
> [   51.714254]  __arm64_sys_sendmsg+0x28/0x40
> [   51.720900]  invoke_syscall+0x48/0x120
> 
> Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3
> 
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Fixes: 840c36fa727a ("ath11k: dp: stop rx pktlog before suspend")
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

d4ba1ff87b17 ath11k: fix netdev open race

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220517103436.15867-1-johan+linaro@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

