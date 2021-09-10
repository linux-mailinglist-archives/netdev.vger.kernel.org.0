Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D161406C60
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 14:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbhIJMmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 08:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235385AbhIJMmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 08:42:08 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A266C0610FF
        for <netdev@vger.kernel.org>; Fri, 10 Sep 2021 05:35:19 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mOfkJ-0004KL-8c; Fri, 10 Sep 2021 14:35:07 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mOfkG-0002CL-J1; Fri, 10 Sep 2021 14:35:04 +0200
Date:   Fri, 10 Sep 2021 14:35:04 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     robin@protonic.nl, linux@rempel-privat.de, socketcan@hartkopp.net,
        mkl@pengutronix.de, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] can: j1939: fix errant alert in j1939_tp_rxtimer
Message-ID: <20210910123504.GI26100@pengutronix.de>
References: <20210906094219.95924-1-william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210906094219.95924-1-william.xuanziyang@huawei.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:18:58 up 204 days, 15:42, 103 users,  load average: 0.13, 0.34,
 0.28
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 06, 2021 at 05:42:19PM +0800, Ziyang Xuan wrote:
> When the session state is J1939_SESSION_DONE, j1939_tp_rxtimer() will
> give an alert "rx timeout, send abort", but do nothing actually.
> Move the alert into session active judgment condition, it is more
> reasonable.
> 
> One of the scenarioes is that j1939_tp_rxtimer() execute followed by
> j1939_xtp_rx_abort_one(). After j1939_xtp_rx_abort_one(), the session
> state is J1939_SESSION_DONE, then j1939_tp_rxtimer() give an alert.
> 
> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>

Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>

Thank you!

> ---
>  net/can/j1939/transport.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
> index 0f8309314075..d3f0a062b400 100644
> --- a/net/can/j1939/transport.c
> +++ b/net/can/j1939/transport.c
> @@ -1226,12 +1226,11 @@ static enum hrtimer_restart j1939_tp_rxtimer(struct hrtimer *hrtimer)
>  		session->err = -ETIME;
>  		j1939_session_deactivate(session);
>  	} else {
> -		netdev_alert(priv->ndev, "%s: 0x%p: rx timeout, send abort\n",
> -			     __func__, session);
> -
>  		j1939_session_list_lock(session->priv);
>  		if (session->state >= J1939_SESSION_ACTIVE &&
>  		    session->state < J1939_SESSION_ACTIVE_MAX) {
> +			netdev_alert(priv->ndev, "%s: 0x%p: rx timeout, send abort\n",
> +				     __func__, session);
>  			j1939_session_get(session);
>  			hrtimer_start(&session->rxtimer,
>  				      ms_to_ktime(J1939_XTP_ABORT_TIMEOUT_MS),
> -- 
> 2.25.1
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
