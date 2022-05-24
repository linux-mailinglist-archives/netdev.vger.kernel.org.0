Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C59453240D
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 09:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235235AbiEXH15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 03:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiEXH0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 03:26:31 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537251145D;
        Tue, 24 May 2022 00:26:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B1E04CE1A54;
        Tue, 24 May 2022 07:26:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1474CC34100;
        Tue, 24 May 2022 07:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653377186;
        bh=bIROaGOZbF93Xt0aHUg1j/Xrg0023fKyXPwCzZwVCaQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cK34n+iF/tkd+qGzXLOY68MrWM0kGjGMv7m8Tmu9tc6YmeNSSr5dDp3yugtJvZyqh
         1HyARCzxvwupVDVgf+4eMX37hSuwlEEOrpOT4GfxITMMG28M0XeR3H3m2Gry9UFF5A
         fDwsr2eK6aqYAx784UpRUf9Mc6bfEbRUCZMno0zf+cl20DVtOSB5MRZW+WF4M82V2L
         irGYe4xG9Zhx44jfeueCvBvVVCrBx3jCBUv52rbzkVY1HPYpvMVazxy8qQaMDsW93/
         7xD3Qh1Nyi/cvzsp4Q0yRVngUR9NshAdEOGoVv8h5sPNKnCKdZOQikB8mhRE8CvgoO
         eRpJSGrJu50Bg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1ntOvv-0001yU-4e; Tue, 24 May 2022 09:26:23 +0200
Date:   Tue, 24 May 2022 09:26:23 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] ath11k: fix netdev open race
Message-ID: <YoyIn5L8cIwxHxR0@hovoldconsulting.com>
References: <20220517103436.15867-1-johan+linaro@kernel.org>
 <YouezMIwm3PYxOKY@hovoldconsulting.com>
 <875ylwysoy.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875ylwysoy.fsf@kernel.org>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 23, 2022 at 10:06:37PM +0300, Kalle Valo wrote:
> Johan Hovold <johan@kernel.org> writes:
> 
> > On Tue, May 17, 2022 at 12:34:36PM +0200, Johan Hovold wrote:
> >> Make sure to allocate resources needed before registering the device.
> >> 
> >> This specifically avoids having a racing open() trigger a BUG_ON() in
> >> mod_timer() when ath11k_mac_op_start() is called before the
> >> mon_reap_timer as been set up.
> >> 
> >> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> >> Fixes: 840c36fa727a ("ath11k: dp: stop rx pktlog before suspend")
> >> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> >> ---
> >
> > For completeness:
> >
> > Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3
> 
> Thanks, added in the pending branch.
> 
> You submitted this as RFC but do you mind if I apply this anyway? The
> patch looks good and passes my tests. But I do wonder why I haven't seen
> the crash...

If it looks good to you then please do apply it.

I was just worried that there may be some subtle reason for why
ath11k_dp_pdev_alloc() was called after netdev registration in the first
place and that it might need to be split up so that for example
ath11k_dp_rx_pdev_mon_attach() isn't called until after registration.

I did not see this issue with next-20220310, but I hit it on every probe
with next-20220511. Perhaps some timing changed in between.

Here's the backtrace for completeness in case someone else starts hitting
this and searches the archives:

[   51.346947] kernel BUG at kernel/time/timer.c:990!
[   51.346958] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
...
[   51.578225] Call trace:
[   51.583293]  __mod_timer+0x298/0x390
[   51.589518]  mod_timer+0x14/0x20
[   51.595368]  ath11k_mac_op_start+0x41c/0x4a0 [ath11k]
[   51.603165]  drv_start+0x38/0x60 [mac80211]
[   51.610110]  ieee80211_do_open+0x29c/0x7d0 [mac80211]
[   51.617945]  ieee80211_open+0x60/0xb0 [mac80211]
[   51.625311]  __dev_open+0x100/0x1c0
[   51.631420]  __dev_change_flags+0x194/0x210
[   51.638214]  dev_change_flags+0x24/0x70
[   51.644646]  do_setlink+0x228/0xdb0
[   51.650723]  __rtnl_newlink+0x460/0x830
[   51.657162]  rtnl_newlink+0x4c/0x80
[   51.663229]  rtnetlink_rcv_msg+0x124/0x390
[   51.669917]  netlink_rcv_skb+0x58/0x130
[   51.676314]  rtnetlink_rcv+0x18/0x30
[   51.682460]  netlink_unicast+0x250/0x310
[   51.688960]  netlink_sendmsg+0x19c/0x3e0
[   51.695458]  ____sys_sendmsg+0x220/0x290
[   51.701938]  ___sys_sendmsg+0x7c/0xc0
[   51.708148]  __sys_sendmsg+0x68/0xd0
[   51.714254]  __arm64_sys_sendmsg+0x28/0x40
[   51.720900]  invoke_syscall+0x48/0x120

Johan
