Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF0F437561
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 12:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232527AbhJVKZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 06:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232483AbhJVKZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 06:25:33 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82DDC061764
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 03:23:15 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mdrhb-0004xv-Ph; Fri, 22 Oct 2021 12:23:07 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mdrha-0000Bq-D4; Fri, 22 Oct 2021 12:23:06 +0200
Date:   Fri, 22 Oct 2021 12:23:06 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>, kernel@pengutronix.de,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-can@vger.kernel.org
Subject: Re: [PATCH net 2/3] can: j1939: j1939_can_recv(): ignore messages
 with invalid source address
Message-ID: <20211022102306.GB20681@pengutronix.de>
References: <1634825057-47915-1-git-send-email-zhangchangzhong@huawei.com>
 <1634825057-47915-3-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1634825057-47915-3-git-send-email-zhangchangzhong@huawei.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:22:09 up 246 days, 13:46, 123 users,  load average: 0.07, 0.13,
 0.15
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 21, 2021 at 10:04:16PM +0800, Zhang Changzhong wrote:
> According to SAE-J1939-82 2015 (A.3.6 Row 2), a receiver should never
> send TP.CM_CTS to the global address, so we can add a check in
> j1939_can_recv() to drop messages with invalid source address.
> 
> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>

NACK. This will break Address Claiming, where first message is SA == 0xff

> ---
>  net/can/j1939/main.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/can/j1939/main.c b/net/can/j1939/main.c
> index 08c8606..4f1e4bb 100644
> --- a/net/can/j1939/main.c
> +++ b/net/can/j1939/main.c
> @@ -75,6 +75,10 @@ static void j1939_can_recv(struct sk_buff *iskb, void *data)
>  	skcb->addr.pgn = (cf->can_id >> 8) & J1939_PGN_MAX;
>  	/* set default message type */
>  	skcb->addr.type = J1939_TP;
> +	if (!j1939_address_is_valid(skcb->addr.sa))
> +		/* ignore messages whose sa is broadcast address */
> +		goto done;
> +
>  	if (j1939_pgn_is_pdu1(skcb->addr.pgn)) {
>  		/* Type 1: with destination address */
>  		skcb->addr.da = skcb->addr.pgn;
> -- 
> 2.9.5
> 
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
