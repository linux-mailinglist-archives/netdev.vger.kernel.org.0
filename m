Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A91DF426A19
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 13:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244029AbhJHLt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 07:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243682AbhJHLtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 07:49:06 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A9B7C02B840
        for <netdev@vger.kernel.org>; Fri,  8 Oct 2021 04:34:27 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mYo8o-0007LY-9v; Fri, 08 Oct 2021 13:34:18 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mYo8l-0005QK-Ta; Fri, 08 Oct 2021 13:34:15 +0200
Date:   Fri, 8 Oct 2021 13:34:15 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     robin@protonic.nl, linux@rempel-privat.de, socketcan@hartkopp.net,
        mkl@pengutronix.de, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] can: j1939: fix UAF for rx_kref of j1939_priv
Message-ID: <20211008113415.GG29653@pengutronix.de>
References: <20210926104757.2021540-1-william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210926104757.2021540-1-william.xuanziyang@huawei.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:32:28 up 232 days, 14:56, 143 users,  load average: 0.08, 0.14,
 0.16
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sun, Sep 26, 2021 at 06:47:57PM +0800, Ziyang Xuan wrote:
> It will trigger UAF for rx_kref of j1939_priv as following.
> 
>         cpu0                                    cpu1
> j1939_sk_bind(socket0, ndev0, ...)
> j1939_netdev_start
>                                         j1939_sk_bind(socket1, ndev0, ...)
>                                         j1939_netdev_start
> j1939_priv_set
>                                         j1939_priv_get_by_ndev_locked
> j1939_jsk_add
> .....
> j1939_netdev_stop
> kref_put_lock(&priv->rx_kref, ...)
>                                         kref_get(&priv->rx_kref, ...)
>                                         REFCOUNT_WARN("addition on 0;...")
> 
> ====================================================
> refcount_t: addition on 0; use-after-free.
> WARNING: CPU: 1 PID: 20874 at lib/refcount.c:25 refcount_warn_saturate+0x169/0x1e0
> RIP: 0010:refcount_warn_saturate+0x169/0x1e0
> Call Trace:
>  j1939_netdev_start+0x68b/0x920
>  j1939_sk_bind+0x426/0xeb0
>  ? security_socket_bind+0x83/0xb0
> 
> The rx_kref's kref_get() and kref_put() should use j1939_netdev_lock to
> protect.
> 
> Fixes: 9d71dd0c70099 ("can: add support of SAE J1939 protocol")
> Reported-by: syzbot+85d9878b19c94f9019ad@syzkaller.appspotmail.com
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>

Thank you!

Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>

> ---
>  net/can/j1939/main.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/net/can/j1939/main.c b/net/can/j1939/main.c
> index 08c8606cfd9c..9bc55ecb37f9 100644
> --- a/net/can/j1939/main.c
> +++ b/net/can/j1939/main.c
> @@ -249,11 +249,14 @@ struct j1939_priv *j1939_netdev_start(struct net_device *ndev)
>  	struct j1939_priv *priv, *priv_new;
>  	int ret;
>  
> -	priv = j1939_priv_get_by_ndev(ndev);
> +	spin_lock(&j1939_netdev_lock);
> +	priv = j1939_priv_get_by_ndev_locked(ndev);
>  	if (priv) {
>  		kref_get(&priv->rx_kref);
> +		spin_unlock(&j1939_netdev_lock);
>  		return priv;
>  	}
> +	spin_unlock(&j1939_netdev_lock);
>  
>  	priv = j1939_priv_create(ndev);
>  	if (!priv)
> @@ -269,10 +272,10 @@ struct j1939_priv *j1939_netdev_start(struct net_device *ndev)
>  		/* Someone was faster than us, use their priv and roll
>  		 * back our's.
>  		 */
> +		kref_get(&priv_new->rx_kref);
>  		spin_unlock(&j1939_netdev_lock);
>  		dev_put(ndev);
>  		kfree(priv);
> -		kref_get(&priv_new->rx_kref);
>  		return priv_new;
>  	}
>  	j1939_priv_set(ndev, priv);
> -- 
> 2.25.1
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
