Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9114D584484
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 18:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232122AbiG1Q6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 12:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbiG1Q6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 12:58:46 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAEDB5FAC2
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 09:58:45 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oH6qG-00082K-1X; Thu, 28 Jul 2022 18:58:32 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oH6qC-0001DX-8P; Thu, 28 Jul 2022 18:58:28 +0200
Date:   Thu, 28 Jul 2022 18:58:28 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>, kernel@pengutronix.de,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        Bastian Stender <bst@pengutronix.de>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH] can: j1939: Replace WARN_ON_ONCE with pr_warn_once() in
 j1939_sk_queue_activate_next_locked()
Message-ID: <20220728165828.GB30201@pengutronix.de>
References: <7ea40c0e-e696-3537-c2a4-a8eccf4695d0@ispras.ru>
 <20220728163429.214758-1-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220728163429.214758-1-pchelkin@ispras.ru>
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

Hi Fedor,

thank you for your patch.

On Thu, Jul 28, 2022 at 07:34:29PM +0300, Fedor Pchelkin wrote:
> We should warn user-space that it is doing something wrong when trying to
> activate sessions with identical parameters but WARN_ON_ONCE macro can not
> be used here as it serves a different purpose.
> 
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
> 
> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  net/can/j1939/socket.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
> index f5ecfdcf57b2..67e8b50b8bc1 100644
> --- a/net/can/j1939/socket.c
> +++ b/net/can/j1939/socket.c
> @@ -178,7 +178,8 @@ static void j1939_sk_queue_activate_next_locked(struct j1939_session *session)
>  	if (!first)
>  		return;
>  
> -	if (WARN_ON_ONCE(j1939_session_activate(first))) {
> +	if (j1939_session_activate(first)) {
> +		pr_warn_once("can: j1939: Identical session is already activated.\n");

please use netdev_warn_once().
Otherwise looks good.

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
