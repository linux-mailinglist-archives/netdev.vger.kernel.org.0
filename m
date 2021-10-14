Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1661A42D924
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 14:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhJNMRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 08:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbhJNMRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 08:17:01 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9675FC061570
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 05:14:56 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mazdB-0002Q8-4c; Thu, 14 Oct 2021 14:14:41 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mazd5-0000Ck-Bp; Thu, 14 Oct 2021 14:14:35 +0200
Date:   Thu, 14 Oct 2021 14:14:35 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>, kernel@pengutronix.de,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        Maxime Jayat <maxime.jayat@mobile-devices.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] can: j1939: j1939_xtp_rx_rts_session_new(): abort TP
 less than 9 bytes
Message-ID: <20211014121435.GA7427@pengutronix.de>
References: <1634203601-3460-1-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1634203601-3460-1-git-send-email-zhangchangzhong@huawei.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:13:58 up 238 days, 15:37, 145 users,  load average: 0.23, 0.38,
 0.40
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 14, 2021 at 05:26:40PM +0800, Zhang Changzhong wrote:
> The receiver should abort TP if 'total message size' in TP.CM_RTS and
> TP.CM_BAM is less than 9 or greater than 1785 [1], but currently the
> j1939 stack only checks the upper bound and the receiver will accept the
> following broadcast message:
>   vcan1  18ECFF00   [8]  20 08 00 02 FF 00 23 01
>   vcan1  18EBFF00   [8]  01 00 00 00 00 00 00 00
>   vcan1  18EBFF00   [8]  02 00 FF FF FF FF FF FF
> 
> This patch adds check for the lower bound and abort illegal TP.
> 
> [1] SAE-J1939-82 A.3.4 Row 2 and A.3.6 Row 6.
> 
> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>

Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Thank you!

> ---
>  net/can/j1939/j1939-priv.h | 1 +
>  net/can/j1939/transport.c  | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/net/can/j1939/j1939-priv.h b/net/can/j1939/j1939-priv.h
> index f6df208..16af1a7 100644
> --- a/net/can/j1939/j1939-priv.h
> +++ b/net/can/j1939/j1939-priv.h
> @@ -330,6 +330,7 @@ int j1939_session_activate(struct j1939_session *session);
>  void j1939_tp_schedule_txtimer(struct j1939_session *session, int msec);
>  void j1939_session_timers_cancel(struct j1939_session *session);
>  
> +#define J1939_MIN_TP_PACKET_SIZE 9
>  #define J1939_MAX_TP_PACKET_SIZE (7 * 0xff)
>  #define J1939_MAX_ETP_PACKET_SIZE (7 * 0x00ffffff)
>  
> diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
> index bb5c4b8..b685d31 100644
> --- a/net/can/j1939/transport.c
> +++ b/net/can/j1939/transport.c
> @@ -1609,6 +1609,8 @@ j1939_session *j1939_xtp_rx_rts_session_new(struct j1939_priv *priv,
>  			abort = J1939_XTP_ABORT_FAULT;
>  		else if (len > priv->tp_max_packet_size)
>  			abort = J1939_XTP_ABORT_RESOURCE;
> +		else if (len < J1939_MIN_TP_PACKET_SIZE)
> +			abort = J1939_XTP_ABORT_FAULT;
>  	}
>  
>  	if (abort != J1939_XTP_NO_ABORT) {
> -- 
> 2.9.5
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
