Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4539C29EBC7
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 13:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbgJ2MYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 08:24:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51958 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgJ2MYf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 08:24:35 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kY6ya-0049Sx-4A; Thu, 29 Oct 2020 13:24:20 +0100
Date:   Thu, 29 Oct 2020 13:24:20 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Zou Wei <zou_wei@huawei.com>
Cc:     rain.1986.08.12@gmail.com, zyjzyj2000@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] net: nvidia: forcedeth: remove useless if/else
Message-ID: <20201029122420.GG933237@lunn.ch>
References: <1603938614-53589-1-git-send-email-zou_wei@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1603938614-53589-1-git-send-email-zou_wei@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 10:30:14AM +0800, Zou Wei wrote:
> Fix the following coccinelle report:
> 
> ./drivers/net/ethernet/nvidia/forcedeth.c:3479:8-10:
> WARNING: possible condition with no effect (if == else)
> 
> Both branches are the same, so remove the else if/else altogether.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zou Wei <zou_wei@huawei.com>
> ---
>  drivers/net/ethernet/nvidia/forcedeth.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
> index 2fc10a3..87ed7e1 100644
> --- a/drivers/net/ethernet/nvidia/forcedeth.c
> +++ b/drivers/net/ethernet/nvidia/forcedeth.c
> @@ -3476,9 +3476,6 @@ static int nv_update_linkspeed(struct net_device *dev)
>  	} else if (adv_lpa & LPA_10FULL) {
>  		newls = NVREG_LINKSPEED_FORCE|NVREG_LINKSPEED_10;
>  		newdup = 1;
> -	} else if (adv_lpa & LPA_10HALF) {
> -		newls = NVREG_LINKSPEED_FORCE|NVREG_LINKSPEED_10;
> -		newdup = 0;
>  	} else {
>  		newls = NVREG_LINKSPEED_FORCE|NVREG_LINKSPEED_10;
>  		newdup = 0;

I think the original code is more readable. The idea is, you look at
what each end of the link can do, and work your way from fastest to
slowest finding one in common. That is what the four if () do. If
there is no speed in common, the link is probably not going to work,
but default to 10Half, because all devices should in theory support
that. That is the last else. The change makes it a lot less clear
about this last past.

How about this instead. It keeps the idea of, we have nothing else
better, do 10Half.

This is not even compile tested.

    Andrew


diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 2fc10a36afa4..f626bd6c0dfc 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -3467,6 +3467,8 @@ static int nv_update_linkspeed(struct net_device *dev)
 
        /* FIXME: handle parallel detection properly */
        adv_lpa = lpa & adv;
+       newls = NVREG_LINKSPEED_FORCE|NVREG_LINKSPEED_10;
+       newdup = 0;
        if (adv_lpa & LPA_100FULL) {
                newls = NVREG_LINKSPEED_FORCE|NVREG_LINKSPEED_100;
                newdup = 1;
@@ -3479,9 +3481,6 @@ static int nv_update_linkspeed(struct net_device *dev)
        } else if (adv_lpa & LPA_10HALF) {
                newls = NVREG_LINKSPEED_FORCE|NVREG_LINKSPEED_10;
                newdup = 0;
-       } else {
-               newls = NVREG_LINKSPEED_FORCE|NVREG_LINKSPEED_10;
-               newdup = 0;
        }
 
 set_speed:
