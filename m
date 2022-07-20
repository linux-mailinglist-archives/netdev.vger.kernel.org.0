Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5439557BE4D
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 21:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiGTTOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 15:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiGTTOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 15:14:21 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE445722E
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 12:14:20 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oEF90-0004W8-0J; Wed, 20 Jul 2022 21:14:02 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oEF8v-0005MV-H8; Wed, 20 Jul 2022 21:13:57 +0200
Date:   Wed, 20 Jul 2022 21:13:57 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Elenita Hinds <ecathinds@gmail.com>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: Re: [PATCH] can: j1939: Remove unnecessary WARN_ON_ONCE in
 j1939_sk_queue_activate_next_locked()
Message-ID: <20220720191357.GB5600@pengutronix.de>
References: <20220720110645.519601-1-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220720110645.519601-1-pchelkin@ispras.ru>
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

On Wed, Jul 20, 2022 at 02:06:45PM +0300, Fedor Pchelkin wrote:
> The purpose of WARN_ON_ONCE if the session with the same parameters
> has already been activated and is currently in active_session_list is
> not very clear. Is this warning implemented to indicate that userspace
> is doing something wrong?

yes.

> As far as I can see, there are two lists: active_session_list (which
> is for the whole device) and sk_session_queue (which is unique for
> each j1939_sock), and the situation when we have two sessions with
> the same type, addresses and destinations in two different
> sk_session_queues (owned by two different sockets) is actually highly
> probable - one is active and the other is willing to become active
> but the j1939_session_activate() does not let that happen. It is
> correct behaviour as I assume.

No. It is not typical use case and most probably it will create
problems. Are you working on some system where this use case is valid?

> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
> 
> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
>
> ---
>  net/can/j1939/socket.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
> index f5ecfdcf57b2..be4b73afa16c 100644
> --- a/net/can/j1939/socket.c
> +++ b/net/can/j1939/socket.c
> @@ -178,7 +178,7 @@ static void j1939_sk_queue_activate_next_locked(struct j1939_session *session)
>  	if (!first)
>  		return;
>  
> -	if (WARN_ON_ONCE(j1939_session_activate(first))) {
> +	if (j1939_session_activate(first)) {
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
