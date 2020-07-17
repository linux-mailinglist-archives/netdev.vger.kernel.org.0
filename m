Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECDB9223B8B
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 14:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbgGQMo2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 17 Jul 2020 08:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbgGQMo2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 08:44:28 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6662C061755
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 05:44:27 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jwPip-0000fy-Uy; Fri, 17 Jul 2020 14:44:15 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jwPik-0002HZ-6Q; Fri, 17 Jul 2020 14:44:10 +0200
Date:   Fri, 17 Jul 2020 14:44:10 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     trix@redhat.com
Cc:     robin@protonic.nl, linux@rempel-privat.de, kernel@pengutronix.de,
        socketcan@hartkopp.net, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org, ecathinds@gmail.com, lkp@intel.com,
        bst@pengutronix.de, maxime.jayat@mobile-devices.fr,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org
Subject: Re: [PATCH] can: j1939: fix double free in j1939_netdev_start
Message-ID: <20200717124410.GA32124@pengutronix.de>
References: <20200710134536.4399-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200710134536.4399-1-trix@redhat.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:15:03 up 38 days, 20:41, 157 users,  load average: 0.23, 0.42,
 0.76
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tom,

On Fri, Jul 10, 2020 at 06:45:36AM -0700, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> clang static analysis flags this error
> 
> j1939/main.c:292:2: warning: Attempt to free released memory [unix.Malloc]
>         kfree(priv);
>         ^~~~~~~~~~~
> 
> The problem block of code is
> 
> 	ret = j1939_can_rx_register(priv);
> 	if (ret < 0)
> 		goto out_priv_put;
> 
> 	return priv;
> 
>  out_priv_put:
> 	j1939_priv_set(ndev, NULL);
> 	dev_put(ndev);
> 	kfree(priv);
> 
> When j1939_can_rx_register fails, it frees priv via the
> j1939_priv_put release function __j1939_priv_release.

In j1939_can_rx_register()...

| static int j1939_can_rx_register(struct j1939_priv *priv)
| {
| 	struct net_device *ndev = priv->ndev;
| 	int ret;

... the function in entered with ref counter == 1.
(Due to kref_init(&priv->kref); in j1939_priv_create())

|
| 	j1939_priv_get(priv);

... then the ref counter is increased by 1, resulting in 2.

| 	ret = can_rx_register(dev_net(ndev), ndev, J1939_CAN_ID, J1939_CAN_MASK,
| 			      j1939_can_recv, priv, "j1939", NULL);
| 	if (ret < 0) {
| 		j1939_priv_put(priv);

And in case of an error, the ref counter is decreased by one again.

| 		return ret;
| 	}
|
| 	return 0;
| }

So we cannot see why clang thinks the memory is double free()d.

> Since j1939_priv_put is used widely, remove the second
> free from j1939_netdev_start.

We might replace the manual kfree() and dev_put() by the dropping the
last ref count and rely on the automatic cleanup.

> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> 
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>  net/can/j1939/main.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/net/can/j1939/main.c b/net/can/j1939/main.c
> index 137054bff9ec..991a74bc491b 100644
> --- a/net/can/j1939/main.c
> +++ b/net/can/j1939/main.c
> @@ -289,7 +289,6 @@ struct j1939_priv *j1939_netdev_start(struct net_device *ndev)
>   out_priv_put:
>  	j1939_priv_set(ndev, NULL);
>  	dev_put(ndev);
> -	kfree(priv);
>  
>  	return ERR_PTR(ret);
>  }

regards,
Oleksij & Marc

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
