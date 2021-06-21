Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 888843AE289
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 06:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhFUEuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 00:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbhFUEuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 00:50:16 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B334BC061574
        for <netdev@vger.kernel.org>; Sun, 20 Jun 2021 21:48:02 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lvBqp-0001NE-K1; Mon, 21 Jun 2021 06:47:59 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1lvBqn-0000AG-L0; Mon, 21 Jun 2021 06:47:57 +0200
Date:   Mon, 21 Jun 2021 06:47:57 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Norbert Slusarek <nslusarek@gmx.net>
Cc:     netdev@vger.kernel.org, socketcan@hartkopp.net,
        linux-can@vger.kernel.org, mkl@pengutronix.de,
        kernel@pengutronix.de, kuba@kernel.org, davem@davemloft.net
Subject: Re: [PATCH] can: j1939: prevent allocation of j1939 filter for
 optlen = 0
Message-ID: <20210621044757.vchomm57vno6qq5n@pengutronix.de>
References: <20210620123842.117975-1-nslusarek@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210620123842.117975-1-nslusarek@gmx.net>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 06:47:13 up 200 days, 18:53, 32 users,  load average: 0.01, 0.04,
 0.00
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Norbert,

On Sun, Jun 20, 2021 at 02:38:42PM +0200, Norbert Slusarek wrote:
> If optval != NULL and optlen = 0 are specified for SO_J1939_FILTER in
> j1939_sk_setsockopt(), memdup_sockptr() will return ZERO_PTR for 0 size
> allocation. The new filter will be mistakenly assigned ZERO_PTR.
> This patch checks for optlen != 0 and filter will be assigned NULL
> in case of optlen = 0.
> 
> Fixes: a7b75c5a8c41 ("net: pass a sockptr_t into ->setsockopt")
> Signed-off-by: Norbert Slusarek <nslusarek@gmx.net>

Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>

Thank you!

> ---
>  net/can/j1939/socket.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
> index 56aa66147d5a..ff20cb629200 100644
> --- a/net/can/j1939/socket.c
> +++ b/net/can/j1939/socket.c
> @@ -673,7 +673,7 @@ static int j1939_sk_setsockopt(struct socket *sock, int level, int optname,
> 
>  	switch (optname) {
>  	case SO_J1939_FILTER:
> -		if (!sockptr_is_null(optval)) {
> +		if (!sockptr_is_null(optval) && optlen != 0) {
>  			struct j1939_filter *f;
>  			int c;
> 
> --
> 2.30.2
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
