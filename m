Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE2B53628F
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 14:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348451AbiE0M2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 08:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355284AbiE0M1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 08:27:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5398DA5;
        Fri, 27 May 2022 05:06:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06BDCB824D8;
        Fri, 27 May 2022 12:06:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8554BC385A9;
        Fri, 27 May 2022 12:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653653199;
        bh=fPR03DvN6aZCOlnsEZXaYA7hSzVMz0SsOW9oln+FOMg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=F5r1R/3pIR8wIVp5nBZnJpKz9BS0ECMiDAdNrh5eEazvJH/fZeVNJu6UQ6933OaW3
         803TrXtUatxRXokzpOrYNZMqxmyKEL22HN2Shvjff8FXu7H1Vr0F/Q51ZJyb4qbcYd
         aC4yuQdR5gxOb9PxCEaCuwI4Egq6/fAj1D87GVEpLxdO+oqBHWPBaE+t/rmfszV+eB
         jjmCkfN3EGo+uUExNnDFrLGbLYQn/I2fbrB9GugdN5G3cMTFkNrbm9AddEikKfbGav
         4ByKTY6pRvYtNwj1yC1M/Mux+wQOBCWNAZ65n9YagKD/sNf29uWtbHwaIcM6bCBeIA
         i8y2lXJ9XnMGQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] ath11k: fix netdev open race
References: <20220517103436.15867-1-johan+linaro@kernel.org>
        <YouezMIwm3PYxOKY@hovoldconsulting.com> <875ylwysoy.fsf@kernel.org>
        <YoyIn5L8cIwxHxR0@hovoldconsulting.com>
Date:   Fri, 27 May 2022 15:06:35 +0300
In-Reply-To: <YoyIn5L8cIwxHxR0@hovoldconsulting.com> (Johan Hovold's message
        of "Tue, 24 May 2022 09:26:23 +0200")
Message-ID: <87mtf3p4c4.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johan Hovold <johan@kernel.org> writes:

> On Mon, May 23, 2022 at 10:06:37PM +0300, Kalle Valo wrote:
>> Johan Hovold <johan@kernel.org> writes:
>> 
>> > On Tue, May 17, 2022 at 12:34:36PM +0200, Johan Hovold wrote:
>> >> Make sure to allocate resources needed before registering the device.
>> >> 
>> >> This specifically avoids having a racing open() trigger a BUG_ON() in
>> >> mod_timer() when ath11k_mac_op_start() is called before the
>> >> mon_reap_timer as been set up.
>> >> 
>> >> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
>> >> Fixes: 840c36fa727a ("ath11k: dp: stop rx pktlog before suspend")
>> >> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
>> >> ---
>> >
>> > For completeness:
>> >
>> > Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3
>> 
>> Thanks, added in the pending branch.
>> 
>> You submitted this as RFC but do you mind if I apply this anyway? The
>> patch looks good and passes my tests. But I do wonder why I haven't seen
>> the crash...
>
> If it looks good to you then please do apply it.
>
> I was just worried that there may be some subtle reason for why
> ath11k_dp_pdev_alloc() was called after netdev registration in the first
> place and that it might need to be split up so that for example
> ath11k_dp_rx_pdev_mon_attach() isn't called until after registration.

At least I'm not aware of anything like that? Any comments from others?

> I did not see this issue with next-20220310, but I hit it on every probe
> with next-20220511. Perhaps some timing changed in between.
>
> Here's the backtrace for completeness in case someone else starts hitting
> this and searches the archives:
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

Thanks, this is good info and I added this to the commit log.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
