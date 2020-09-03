Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D44E525CCEE
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 23:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbgICV60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 17:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbgICV60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 17:58:26 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096A6C061244;
        Thu,  3 Sep 2020 14:58:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8335F1278BDC7;
        Thu,  3 Sep 2020 14:41:38 -0700 (PDT)
Date:   Thu, 03 Sep 2020 14:58:24 -0700 (PDT)
Message-Id: <20200903.145824.62292077708642050.davem@davemloft.net>
To:     geert+renesas@glider.be
Cc:     hkallweit1@gmail.com, f.fainelli@gmail.com, andrew@lunn.ch,
        kuba@kernel.org, gaku.inami.xh@renesas.com,
        yoshihiro.shimoda.uh@renesas.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "net: linkwatch: add check for netdevice being
 present to linkwatch_do_dev"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200901150237.15302-1-geert+renesas@glider.be>
References: <20200901150237.15302-1-geert+renesas@glider.be>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 03 Sep 2020 14:41:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>
Date: Tue,  1 Sep 2020 17:02:37 +0200

> This reverts commit 124eee3f6955f7aa19b9e6ff5c9b6d37cb3d1e2c.

Heiner, please review this.

Thank you.

> Inami-san reported that this commit breaks bridge support in a Xen
> environment, and that reverting it fixes this.
> 
> During system resume, bridge ports are no longer enabled, as that relies
> on the receipt of the NETDEV_CHANGE notification.  This notification is
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
> @@ -158,7 +158,7 @@ static void linkwatch_do_dev(struct net_device *dev)
>  	clear_bit(__LINK_STATE_LINKWATCH_PENDING, &dev->state);
>  
>  	rfc2863_policy(dev);
> -	if (dev->flags & IFF_UP && netif_device_present(dev)) {
> +	if (dev->flags & IFF_UP) {
>  		if (netif_carrier_ok(dev))
>  			dev_activate(dev);
>  		else
> -- 
> 2.17.1
> 
