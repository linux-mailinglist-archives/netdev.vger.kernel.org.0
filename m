Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B64942A2DB
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 13:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236084AbhJLLML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 07:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236004AbhJLLMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 07:12:10 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62D59C061570
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 04:10:09 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1maFfR-0000pY-TU; Tue, 12 Oct 2021 13:09:57 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1maFfP-0006zX-Hb; Tue, 12 Oct 2021 13:09:55 +0200
Date:   Tue, 12 Oct 2021 13:09:55 +0200
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
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org
Subject: Re: [PATCH net] can: j1939: j1939_xtp_rx_dat_one(): cancel session
 if receive TP.DT with error length
Message-ID: <20211012110955.GB14971@pengutronix.de>
References: <1632972800-45091-1-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1632972800-45091-1-git-send-email-zhangchangzhong@huawei.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:09:29 up 236 days, 14:33, 141 users,  load average: 0.24, 0.26,
 0.29
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 11:33:20AM +0800, Zhang Changzhong wrote:
> According to SAE-J1939-21, the data length of TP.DT must be 8 bytes, so
> cancel session when receive unexpected TP.DT message.
> 
> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>

Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>

Thank you!

> ---
>  net/can/j1939/transport.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
> index bb5c4b8..eedaeaf 100644
> --- a/net/can/j1939/transport.c
> +++ b/net/can/j1939/transport.c
> @@ -1789,6 +1789,7 @@ static void j1939_xtp_rx_dpo(struct j1939_priv *priv, struct sk_buff *skb,
>  static void j1939_xtp_rx_dat_one(struct j1939_session *session,
>  				 struct sk_buff *skb)
>  {
> +	enum j1939_xtp_abort abort = J1939_XTP_ABORT_FAULT;
>  	struct j1939_priv *priv = session->priv;
>  	struct j1939_sk_buff_cb *skcb, *se_skcb;
>  	struct sk_buff *se_skb = NULL;
> @@ -1803,9 +1804,11 @@ static void j1939_xtp_rx_dat_one(struct j1939_session *session,
>  
>  	skcb = j1939_skb_to_cb(skb);
>  	dat = skb->data;
> -	if (skb->len <= 1)
> +	if (skb->len != 8) {
>  		/* makes no sense */
> +		abort = J1939_XTP_ABORT_UNEXPECTED_DATA;
>  		goto out_session_cancel;
> +	}
>  
>  	switch (session->last_cmd) {
>  	case 0xff:
> @@ -1904,7 +1907,7 @@ static void j1939_xtp_rx_dat_one(struct j1939_session *session,
>   out_session_cancel:
>  	kfree_skb(se_skb);
>  	j1939_session_timers_cancel(session);
> -	j1939_session_cancel(session, J1939_XTP_ABORT_FAULT);
> +	j1939_session_cancel(session, abort);
>  	j1939_session_put(session);
>  }
>  
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
