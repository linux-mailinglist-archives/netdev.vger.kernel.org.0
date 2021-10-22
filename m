Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE3143756E
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 12:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232649AbhJVKb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 06:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232633AbhJVKb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 06:31:26 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2DFC061764
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 03:29:09 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mdrnH-0005WW-DE; Fri, 22 Oct 2021 12:28:59 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mdrnG-0000Ns-TT; Fri, 22 Oct 2021 12:28:58 +0200
Date:   Fri, 22 Oct 2021 12:28:58 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>, kernel@pengutronix.de,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 3/3] can: j1939: j1939_tp_cmd_recv(): check the dst
 address of TP.CM_BAM
Message-ID: <20211022102858.GC20681@pengutronix.de>
References: <1634825057-47915-1-git-send-email-zhangchangzhong@huawei.com>
 <1634825057-47915-4-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1634825057-47915-4-git-send-email-zhangchangzhong@huawei.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:27:34 up 246 days, 13:51, 123 users,  load average: 0.16, 0.13,
 0.14
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 21, 2021 at 10:04:17PM +0800, Zhang Changzhong wrote:
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
> ---
>  net/can/j1939/transport.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
> index 2efa606..93ec0c3 100644
> --- a/net/can/j1939/transport.c
> +++ b/net/can/j1939/transport.c
> @@ -2019,6 +2019,8 @@ static void j1939_tp_cmd_recv(struct j1939_priv *priv, struct sk_buff *skb)
>  		extd = J1939_ETP;
>  		fallthrough;
>  	case J1939_TP_CMD_BAM:
> +		if (!j1939_cb_is_broadcast(skcb))

Please add here netdev_err_once("with some message"), we need to know if
some MCU makes bad things.

> +			return;
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
