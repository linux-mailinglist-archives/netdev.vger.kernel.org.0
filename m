Return-Path: <netdev+bounces-7413-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CC1472021D
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 14:34:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8FAD2811CF
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 12:34:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A3008476;
	Fri,  2 Jun 2023 12:34:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3899D15BF
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 12:34:33 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9565513E
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 05:34:29 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ore@pengutronix.de>)
	id 1q53yT-0001Kq-Ip; Fri, 02 Jun 2023 14:33:45 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
	(envelope-from <ore@pengutronix.de>)
	id 1q53yP-0000yE-Po; Fri, 02 Jun 2023 14:33:41 +0200
Date: Fri, 2 Jun 2023 14:33:41 +0200
From: Oleksij Rempel <o.rempel@pengutronix.de>
To: Fedor Pchelkin <pchelkin@ispras.ru>
Cc: Oleksij Rempel <linux@rempel-privat.de>,
	Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
	lvc-project@linuxtesting.org,
	Robin van der Gracht <robin@protonic.nl>, linux-can@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>, kernel@pengutronix.de,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] can: j1939: change j1939_netdev_lock type to mutex
Message-ID: <20230602123341.GG17237@pengutronix.de>
References: <20230526171910.227615-1-pchelkin@ispras.ru>
 <20230526171910.227615-2-pchelkin@ispras.ru>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230526171910.227615-2-pchelkin@ispras.ru>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 08:19:09PM +0300, Fedor Pchelkin wrote:
> It turns out access to j1939_can_rx_register() needs to be serialized,
> otherwise j1939_priv can be corrupted when parallel threads call
> j1939_netdev_start() and j1939_can_rx_register() fails. This issue is
> thoroughly covered in other commit which serializes access to
> j1939_can_rx_register().
> 
> Change j1939_netdev_lock type to mutex so that we do not need to remove
> GFP_KERNEL from can_rx_register().
> 
> j1939_netdev_lock seems to be used in normal contexts where mutex usage
> is not prohibited.
> 
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
> 
> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> Suggested-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>

Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>

Thank you!

> ---
> Note that it has been only tested via Syzkaller and not with real
> hardware.
> 
>  net/can/j1939/main.c | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/net/can/j1939/main.c b/net/can/j1939/main.c
> index 821d4ff303b3..6ed79afe19a5 100644
> --- a/net/can/j1939/main.c
> +++ b/net/can/j1939/main.c
> @@ -126,7 +126,7 @@ static void j1939_can_recv(struct sk_buff *iskb, void *data)
>  #define J1939_CAN_ID CAN_EFF_FLAG
>  #define J1939_CAN_MASK (CAN_EFF_FLAG | CAN_RTR_FLAG)
>  
> -static DEFINE_SPINLOCK(j1939_netdev_lock);
> +static DEFINE_MUTEX(j1939_netdev_lock);
>  
>  static struct j1939_priv *j1939_priv_create(struct net_device *ndev)
>  {
> @@ -220,7 +220,7 @@ static void __j1939_rx_release(struct kref *kref)
>  	j1939_can_rx_unregister(priv);
>  	j1939_ecu_unmap_all(priv);
>  	j1939_priv_set(priv->ndev, NULL);
> -	spin_unlock(&j1939_netdev_lock);
> +	mutex_unlock(&j1939_netdev_lock);
>  }
>  
>  /* get pointer to priv without increasing ref counter */
> @@ -248,9 +248,9 @@ static struct j1939_priv *j1939_priv_get_by_ndev(struct net_device *ndev)
>  {
>  	struct j1939_priv *priv;
>  
> -	spin_lock(&j1939_netdev_lock);
> +	mutex_lock(&j1939_netdev_lock);
>  	priv = j1939_priv_get_by_ndev_locked(ndev);
> -	spin_unlock(&j1939_netdev_lock);
> +	mutex_unlock(&j1939_netdev_lock);
>  
>  	return priv;
>  }
> @@ -260,14 +260,14 @@ struct j1939_priv *j1939_netdev_start(struct net_device *ndev)
>  	struct j1939_priv *priv, *priv_new;
>  	int ret;
>  
> -	spin_lock(&j1939_netdev_lock);
> +	mutex_lock(&j1939_netdev_lock);
>  	priv = j1939_priv_get_by_ndev_locked(ndev);
>  	if (priv) {
>  		kref_get(&priv->rx_kref);
> -		spin_unlock(&j1939_netdev_lock);
> +		mutex_unlock(&j1939_netdev_lock);
>  		return priv;
>  	}
> -	spin_unlock(&j1939_netdev_lock);
> +	mutex_unlock(&j1939_netdev_lock);
>  
>  	priv = j1939_priv_create(ndev);
>  	if (!priv)
> @@ -277,20 +277,20 @@ struct j1939_priv *j1939_netdev_start(struct net_device *ndev)
>  	spin_lock_init(&priv->j1939_socks_lock);
>  	INIT_LIST_HEAD(&priv->j1939_socks);
>  
> -	spin_lock(&j1939_netdev_lock);
> +	mutex_lock(&j1939_netdev_lock);
>  	priv_new = j1939_priv_get_by_ndev_locked(ndev);
>  	if (priv_new) {
>  		/* Someone was faster than us, use their priv and roll
>  		 * back our's.
>  		 */
>  		kref_get(&priv_new->rx_kref);
> -		spin_unlock(&j1939_netdev_lock);
> +		mutex_unlock(&j1939_netdev_lock);
>  		dev_put(ndev);
>  		kfree(priv);
>  		return priv_new;
>  	}
>  	j1939_priv_set(ndev, priv);
> -	spin_unlock(&j1939_netdev_lock);
> +	mutex_unlock(&j1939_netdev_lock);
>  
>  	ret = j1939_can_rx_register(priv);
>  	if (ret < 0)
> @@ -308,7 +308,7 @@ struct j1939_priv *j1939_netdev_start(struct net_device *ndev)
>  
>  void j1939_netdev_stop(struct j1939_priv *priv)
>  {
> -	kref_put_lock(&priv->rx_kref, __j1939_rx_release, &j1939_netdev_lock);
> +	kref_put_mutex(&priv->rx_kref, __j1939_rx_release, &j1939_netdev_lock);
>  	j1939_priv_put(priv);
>  }
>  
> -- 
> 2.34.1
> 
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

