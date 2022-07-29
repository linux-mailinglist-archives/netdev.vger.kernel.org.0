Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 185E458518C
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 16:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237064AbiG2O0w convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 29 Jul 2022 10:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237034AbiG2O0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 10:26:51 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F65CE00
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 07:26:50 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oHQwn-0000r1-E9; Fri, 29 Jul 2022 16:26:37 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oHQwk-0002Ri-Ul; Fri, 29 Jul 2022 16:26:34 +0200
Date:   Fri, 29 Jul 2022 16:26:34 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>, kernel@pengutronix.de,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH v2] can: j1939: Replace WARN_ON_ONCE with
 netdev_warn_once() in j1939_sk_queue_activate_next_locked()
Message-ID: <20220729142634.GD10850@pengutronix.de>
References: <20220728165828.GB30201@pengutronix.de>
 <20220729140609.980154-1-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20220729140609.980154-1-pchelkin@ispras.ru>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 05:06:09PM +0300, Fedor Pchelkin wrote:
> We should warn user-space that it is doing something wrong when trying to
> activate sessions with identical parameters but WARN_ON_ONCE macro can not
> be used here as it serves a different purpose.
> 
> So it would be good to replace it with netdev_warn_once() message.
> 
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
> 
> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>

> ---
> v1 -> v2: Used netdev_warn_once() instead of pr_warn_once()
> 
>  net/can/j1939/socket.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
> index f5ecfdcf57b2..09e1d78bd22c 100644
> --- a/net/can/j1939/socket.c
> +++ b/net/can/j1939/socket.c
> @@ -178,7 +178,10 @@ static void j1939_sk_queue_activate_next_locked(struct j1939_session *session)
>  	if (!first)
>  		return;
>  
> -	if (WARN_ON_ONCE(j1939_session_activate(first))) {
> +	if (j1939_session_activate(first)) {
> +		netdev_warn_once(first->priv->ndev,
> +						 "%s: 0x%p: Identical session is already activated.\n",
> +						 __func__, first);
>  		first->err = -EBUSY;
>  		goto activate_next;
>  	} else {
> -- 
> 2.25.1
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
