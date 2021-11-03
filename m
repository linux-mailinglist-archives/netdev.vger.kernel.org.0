Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57255444260
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 14:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbhKCN25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 09:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231816AbhKCN24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 09:28:56 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA61C061714
        for <netdev@vger.kernel.org>; Wed,  3 Nov 2021 06:26:20 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1miGHI-0002Ee-AK; Wed, 03 Nov 2021 14:26:08 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1miGHH-0005GD-Vr; Wed, 03 Nov 2021 14:26:07 +0100
Date:   Wed, 3 Nov 2021 14:26:07 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>, kernel@pengutronix.de,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 3/3] can: j1939: j1939_tp_cmd_recv(): check the
 dst address of TP.CM_BAM
Message-ID: <20211103132607.GM20681@pengutronix.de>
References: <1635431907-15617-1-git-send-email-zhangchangzhong@huawei.com>
 <1635431907-15617-4-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1635431907-15617-4-git-send-email-zhangchangzhong@huawei.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:24:54 up 258 days, 16:48, 133 users,  load average: 0.03, 0.17,
 0.25
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28, 2021 at 10:38:27PM +0800, Zhang Changzhong wrote:
> The TP.CM_BAM message must be sent to the global address [1], so add a
> check to drop TP.CM_BAM sent to a non-global address.
> 
> Without this patch, the receiver will treat the following packets as
> normal RTS/CTS tranport:
> 18EC0102#20090002FF002301
> 18EB0102#0100000000000000
> 18EB0102#020000FFFFFFFFFF
> 
> [1] SAE-J1939-82 2015 A.3.3 Row 1.
> 
> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>

Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>

> ---
>  net/can/j1939/transport.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
> index 05eb3d0..a271688 100644
> --- a/net/can/j1939/transport.c
> +++ b/net/can/j1939/transport.c
> @@ -2023,6 +2023,11 @@ static void j1939_tp_cmd_recv(struct j1939_priv *priv, struct sk_buff *skb)
>  		extd = J1939_ETP;
>  		fallthrough;
>  	case J1939_TP_CMD_BAM:
> +		if (cmd == J1939_TP_CMD_BAM && !j1939_cb_is_broadcast(skcb)) {
> +			netdev_err_once(priv->ndev, "%s: BAM to unicast (%02x), ignoring!\n",
> +					__func__, skcb->addr.sa);
> +			return;
> +		}
>  		fallthrough;
>  	case J1939_TP_CMD_RTS:
>  		if (skcb->addr.type != extd)
> -- 
> 2.9.5
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
