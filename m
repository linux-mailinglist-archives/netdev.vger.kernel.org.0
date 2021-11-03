Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD1144424E
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 14:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbhKCN0L convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 3 Nov 2021 09:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231151AbhKCN0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 09:26:10 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD75C061203
        for <netdev@vger.kernel.org>; Wed,  3 Nov 2021 06:23:34 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1miGEe-0001tb-E1; Wed, 03 Nov 2021 14:23:24 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1miGEb-000576-Hg; Wed, 03 Nov 2021 14:23:21 +0100
Date:   Wed, 3 Nov 2021 14:23:21 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>, kernel@pengutronix.de,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 1/3] can: j1939: j1939_tp_cmd_recv(): ignore abort
 message in the BAM transport
Message-ID: <20211103132321.GK20681@pengutronix.de>
References: <1635431907-15617-1-git-send-email-zhangchangzhong@huawei.com>
 <1635431907-15617-2-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1635431907-15617-2-git-send-email-zhangchangzhong@huawei.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:22:52 up 258 days, 16:46, 133 users,  load average: 0.02, 0.25,
 0.29
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28, 2021 at 10:38:25PM +0800, Zhang Changzhong wrote:
> This patch prevents BAM transport from being closed by receiving abort
> message, as specified in SAE-J1939-82 2015 (A.3.3 Row 4).
> 
> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>

Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>

> ---
>  net/can/j1939/transport.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
> index 6c0a0eb..05eb3d0 100644
> --- a/net/can/j1939/transport.c
> +++ b/net/can/j1939/transport.c
> @@ -2085,6 +2085,12 @@ static void j1939_tp_cmd_recv(struct j1939_priv *priv, struct sk_buff *skb)
>  		break;
>  
>  	case J1939_ETP_CMD_ABORT: /* && J1939_TP_CMD_ABORT */
> +		if (j1939_cb_is_broadcast(skcb)) {
> +			netdev_err_once(priv->ndev, "%s: abort to broadcast (%02x), ignoring!\n",
> +					__func__, skcb->addr.sa);
> +			return;
> +		}
> +
>  		if (j1939_tp_im_transmitter(skcb))
>  			j1939_xtp_rx_abort(priv, skb, true);
>  
> -- 
> 2.9.5
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
