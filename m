Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0FB444251
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 14:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbhKCN06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 09:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbhKCN05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 09:26:57 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DA9AC061714
        for <netdev@vger.kernel.org>; Wed,  3 Nov 2021 06:24:21 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1miGFK-0001xv-Lx; Wed, 03 Nov 2021 14:24:06 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1miGFK-00057y-CY; Wed, 03 Nov 2021 14:24:06 +0100
Date:   Wed, 3 Nov 2021 14:24:06 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>, kernel@pengutronix.de,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 2/3] can: j1939: j1939_can_recv(): ignore messages
 with invalid source address
Message-ID: <20211103132406.GL20681@pengutronix.de>
References: <1635431907-15617-1-git-send-email-zhangchangzhong@huawei.com>
 <1635431907-15617-3-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1635431907-15617-3-git-send-email-zhangchangzhong@huawei.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:23:46 up 258 days, 16:47, 133 users,  load average: 0.08, 0.22,
 0.27
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28, 2021 at 10:38:26PM +0800, Zhang Changzhong wrote:
> According to SAE-J1939-82 2015 (A.3.6 Row 2), a receiver should never
> send TP.CM_CTS to the global address, so we can add a check in
> j1939_can_recv() to drop messages with invalid source address.
> 
> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>

Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>

> ---
>  net/can/j1939/main.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/net/can/j1939/main.c b/net/can/j1939/main.c
> index 9bc55ec..461894e 100644
> --- a/net/can/j1939/main.c
> +++ b/net/can/j1939/main.c
> @@ -75,6 +75,12 @@ static void j1939_can_recv(struct sk_buff *iskb, void *data)
>  	skcb->addr.pgn = (cf->can_id >> 8) & J1939_PGN_MAX;
>  	/* set default message type */
>  	skcb->addr.type = J1939_TP;
> +	if (!j1939_address_is_valid(skcb->addr.sa)) {
> +		netdev_err_once(priv->ndev, "%s: sa is broadcast address, ignoring!\n",
> +				__func__);
> +		goto done;
> +	}
> +
>  	if (j1939_pgn_is_pdu1(skcb->addr.pgn)) {
>  		/* Type 1: with destination address */
>  		skcb->addr.da = skcb->addr.pgn;
> -- 
> 2.9.5
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
