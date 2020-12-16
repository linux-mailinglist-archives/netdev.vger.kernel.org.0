Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53C442DC4FA
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 18:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgLPRD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 12:03:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:58846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726721AbgLPRD6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 12:03:58 -0500
Date:   Wed, 16 Dec 2020 09:03:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608138197;
        bh=EJejfOmjOGEUSD8nt3der6vUrzVz5oCmJp3wGTDcTZQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=VfvmvAuDpwkRKUDkcKWGSi8g4az9cAt6GDmvYhq3hdeZOM9yGSdC7u0IYptPeoN9w
         0TxPrirW46k6avuZRrlvtlDxhPltO1Paf3KKFMYt/RxW5dYaireYIGF2QK18Cozo4O
         fvP8TnSxbaE3zEeg2hWUylZfY/dWoUSRC69ZNb8THOL2V7O76I41Z+ASQGBfTQutKJ
         4N6Gg9qW6rUgYhiBXVSxgMvabH28grpXnrrvVnFMCyYsFllR1RUvxlmFfBRuDpNyt7
         fQYULtMcKejyaiD4+fIZRXdMWZ+oVewuAwEZDZYtng5ZkUe2YGF2S3keLAWmXY9gq6
         Ksmohable0tWA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v4] lan743x: fix rx_napi_poll/interrupt ping-pong
Message-ID: <20201216090316.1c273267@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201215161954.5950-1-TheSven73@gmail.com>
References: <20201215161954.5950-1-TheSven73@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Dec 2020 11:19:54 -0500 Sven Van Asbroeck wrote:
> From: Sven Van Asbroeck <thesven73@gmail.com>
> 
> Even if there is more rx data waiting on the chip, the rx napi poll fn
> will never run more than once - it will always read a few buffers, then
> bail out and re-arm interrupts. Which results in ping-pong between napi
> and interrupt.
> 
> This defeats the purpose of napi, and is bad for performance.
> 
> Fix by making the rx napi poll behave identically to other ethernet
> drivers:
> 1. initialize rx napi polling with an arbitrary budget (64).
> 2. in the polling fn, return full weight if rx queue is not depleted,
>    this tells the napi core to "keep polling".
> 3. update the rx tail ("ring the doorbell") once for every 8 processed
>    rx ring buffers.
> 
> Thanks to Jakub Kicinski, Eric Dumazet and Andrew Lunn for their expert
> opinions and suggestions.
> 
> Tested with 20 seconds of full bandwidth receive (iperf3):
>         rx irqs      softirqs(NET_RX)
>         -----------------------------
> before  23827        33620
> after   129          4081
> 
> Tested-by: Sven Van Asbroeck <thesven73@gmail.com> # lan7430
> Fixes: 23f0703c125be ("lan743x: Add main source files for new lan743x driver")
> Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>

Applied, thanks Sven.

I'll leave it out of our stable submission, and expect Sasha's
autoselection bot to pick it up. This should give us more time 
for testing before the patch makes its way to stable trees. 
Let's see how this idea works out for us in practice.
