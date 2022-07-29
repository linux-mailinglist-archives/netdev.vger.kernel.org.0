Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68E65584A8F
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 06:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233734AbiG2EXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 00:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232910AbiG2EXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 00:23:01 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3292B77A54
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 21:23:00 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oHHWS-0001Up-I9; Fri, 29 Jul 2022 06:22:48 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oHHWP-0002bH-0o; Fri, 29 Jul 2022 06:22:45 +0200
Date:   Fri, 29 Jul 2022 06:22:44 +0200
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
        ldv-project@linuxtesting.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: Re: [PATCH] can: j1939: fix memory leak of skbs
Message-ID: <20220729042244.GC30201@pengutronix.de>
References: <20220708175949.539064-1-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220708175949.539064-1-pchelkin@ispras.ru>
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Fedor,

thank you for work.

On Fri, Jul 08, 2022 at 08:59:49PM +0300, Fedor Pchelkin wrote:
> Syzkaller reported memory leak of skbs introduced with the commit
> 2030043e616c ("can: j1939: fix Use-after-Free, hold skb ref while in use").
> 
> Link to Syzkaller info and repro: https://forge.ispras.ru/issues/11743
> 
> The suggested solution was tested on the new memory-leak Syzkaller repro
> and on the old use-after-free repro (that use-after-free bug was solved
> with aforementioned commit). Although there can probably be another
> situations when the numbers of skb_get() and skb_unref() calls don't match
> and I don't see it in right way.
> 
> Moreover, skb_unref() call can be harmlessly removed from line 338 in
> j1939_session_skb_drop_old() (/net/can/j1939/transport.c). But then I
> assume this removal ruins the whole reference counts logic...
> 
> Overall, there is definitely something not clear in skb reference counts
> management with skb_get() and skb_unref(). The solution we suggested fixes
> the leaks and use-after-free's induced by Syzkaller but perhaps the origin
> of the problem can be somewhere else.
> 
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  net/can/j1939/transport.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
> index 307ee1174a6e..9600b339cbf8 100644
> --- a/net/can/j1939/transport.c
> +++ b/net/can/j1939/transport.c
> @@ -356,7 +356,6 @@ void j1939_session_skb_queue(struct j1939_session *session,
>  
>  	skcb->flags |= J1939_ECU_LOCAL_SRC;
>  
> -	skb_get(skb);
>  	skb_queue_tail(&session->skb_queue, skb);
>  }

This skb_get() is counter part of skb_unref()
j1939_session_skb_drop_old().

Initial issue can be reproduced by using real (slow) CAN with j1939cat[1]
tool. Both parts should be started to make sure the j1939_session_tx_dat() will
actually start using the queue. After pushing about 100K of data, application
will try to close the socket and exit. After socket is closed, all skb related
to this socket will be freed and j1939_session_tx_dat() will use freed skbs.

NACK for this patch.

1. https://github.com/linux-can/can-utils/blob/master/j1939cat.c
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
