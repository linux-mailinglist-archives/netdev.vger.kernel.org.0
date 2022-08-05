Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36B7758ADFA
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 18:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240588AbiHEQUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 12:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238386AbiHEQUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 12:20:46 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE7AFD15
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 09:20:45 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oK03V-0005OB-Nj; Fri, 05 Aug 2022 18:20:09 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oK03U-0006lP-71; Fri, 05 Aug 2022 18:20:08 +0200
Date:   Fri, 5 Aug 2022 18:20:08 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     Robin van der Gracht <robin@protonic.nl>,
        ldv-project@linuxtesting.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-can@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: j1939: fix memory leak of skbs
Message-ID: <20220805162008.GA2585@pengutronix.de>
References: <20220805150216.66313-1-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220805150216.66313-1-pchelkin@ispras.ru>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 05, 2022 at 06:02:16PM +0300, Fedor Pchelkin wrote:
> We need to drop skb references taken in j1939_session_skb_queue() when
> destroying a session in j1939_session_destroy(). Otherwise those skbs
> would be lost.
> 
> Link to Syzkaller info and repro: https://forge.ispras.ru/issues/11743.
> 
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
> 
> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> Suggested-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>

> ---
>  net/can/j1939/transport.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
> index 307ee1174a6e..d7d86c944d76 100644
> --- a/net/can/j1939/transport.c
> +++ b/net/can/j1939/transport.c
> @@ -260,6 +260,8 @@ static void __j1939_session_drop(struct j1939_session *session)
>  
>  static void j1939_session_destroy(struct j1939_session *session)
>  {
> +	struct sk_buff *skb;
> +
>  	if (session->transmission) {
>  		if (session->err)
>  			j1939_sk_errqueue(session, J1939_ERRQUEUE_TX_ABORT);
> @@ -274,7 +276,11 @@ static void j1939_session_destroy(struct j1939_session *session)
>  	WARN_ON_ONCE(!list_empty(&session->sk_session_queue_entry));
>  	WARN_ON_ONCE(!list_empty(&session->active_session_list_entry));
>  
> -	skb_queue_purge(&session->skb_queue);
> +	while ((skb = skb_dequeue(&session->skb_queue)) != NULL) {
> +		/* drop ref taken in j1939_session_skb_queue() */
> +		skb_unref(skb);
> +		kfree_skb(skb);
> +	}
>  	__j1939_session_drop(session);
>  	j1939_priv_put(session->priv);
>  	kfree(session);
> -- 
> 2.25.1
> 
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
