Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1D9270399
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 19:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgIRR6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 13:58:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:60166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbgIRR6x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 13:58:53 -0400
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B36221734;
        Fri, 18 Sep 2020 17:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600451932;
        bh=Z1T7hbqtHBCbMhdQoLwdAAwn0wXBfiMFoCm8Vl9GhZw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=g6/Hj7Hxn3ewBH+c7YX77EBTQk3PJSJTB5UdoBi1ZCPoC15NTUWrVh/7so5lxRg0A
         SZzhVD4Xe9lMeO5Odq1Qu7IypjDPtuyqEl7YM5j9ANo2B+g5sJ+Egfz9frwSEIwVB6
         9T2/B8/lkwFYIzDvBt4MuvQEPDa4FBcGpX/OlqrE=
Message-ID: <7bfebfdc0d7345c4612124ff00e20eebb0ff6cd9.camel@kernel.org>
Subject: Re: [PATCH] Revert "net: linkwatch: add check for netdevice being
 present to linkwatch_do_dev"
From:   Saeed Mahameed <saeed@kernel.org>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Gaku Inami <gaku.inami.xh@renesas.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 18 Sep 2020 10:58:49 -0700
In-Reply-To: <20200901150237.15302-1-geert+renesas@glider.be>
References: <20200901150237.15302-1-geert+renesas@glider.be>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-09-01 at 17:02 +0200, Geert Uytterhoeven wrote:
> This reverts commit 124eee3f6955f7aa19b9e6ff5c9b6d37cb3d1e2c.
> 
> Inami-san reported that this commit breaks bridge support in a Xen
> environment, and that reverting it fixes this.
> 
> During system resume, bridge ports are no longer enabled, as that
> relies
> on the receipt of the NETDEV_CHANGE notification.  This notification
> is
> not sent, as netdev_state_change() is no longer called.
> 
> Note that the condition this commit intended to fix never existed
> upstream, as the patch triggering it and referenced in the commit was
> never applied upstream.  Hence I can confirm s2ram on r8a73a4/ape6evm
> and sh73a0/kzm9g works fine before/after this revert.
> 
> Reported-by Gaku Inami <gaku.inami.xh@renesas.com>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  net/core/link_watch.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/link_watch.c b/net/core/link_watch.c
> index 75431ca9300fb9c4..c24574493ecf95e6 100644
> --- a/net/core/link_watch.c
> +++ b/net/core/link_watch.c
> @@ -158,7 +158,7 @@ static void linkwatch_do_dev(struct net_device
> *dev)
>  	clear_bit(__LINK_STATE_LINKWATCH_PENDING, &dev->state);
>  
>  	rfc2863_policy(dev);
> -	if (dev->flags & IFF_UP && netif_device_present(dev)) {
> +	if (dev->flags & IFF_UP) {

So with your issue the devices is both IFF_UP and !present ? how so ?
I think you should look into that.

I am ok with removing the "dev present" check from here just because we
shouldn't  be expecting IFF_UP && !present .. such thing must be a bug
somewhere else.

>  		if (netif_carrier_ok(dev))
>  			dev_activate(dev);
>  		else

