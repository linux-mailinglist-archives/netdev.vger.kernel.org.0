Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85774C31B2
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 12:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731030AbfJAKog convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 1 Oct 2019 06:44:36 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:40903 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbfJAKog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 06:44:36 -0400
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iFFdu-0000tI-3F; Tue, 01 Oct 2019 12:44:30 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1iFFds-0008HI-2B; Tue, 01 Oct 2019 12:44:28 +0200
Date:   Tue, 1 Oct 2019 12:44:28 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Colin King <colin.king@canonical.com>
Cc:     Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] can: fix resource leak of skb on error return paths
Message-ID: <20191001104428.welkedinv7322tq4@pengutronix.de>
References: <20190918101156.24370-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20190918101156.24370-1-colin.king@canonical.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:40:48 up 136 days, 16:58, 90 users,  load average: 0.09, 0.06,
 0.07
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 18, 2019 at 11:11:56AM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the error return paths do not free skb and this results
> in a memory leak. Fix this by freeing them before the return.
> 
> Addresses-Coverity: ("Resource leak")
> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>

> ---
>  net/can/j1939/socket.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
> index 37c1040bcb9c..5c6eabcb5df1 100644
> --- a/net/can/j1939/socket.c
> +++ b/net/can/j1939/socket.c
> @@ -909,8 +909,10 @@ void j1939_sk_errqueue(struct j1939_session *session,
>  	memset(serr, 0, sizeof(*serr));
>  	switch (type) {
>  	case J1939_ERRQUEUE_ACK:
> -		if (!(sk->sk_tsflags & SOF_TIMESTAMPING_TX_ACK))
> +		if (!(sk->sk_tsflags & SOF_TIMESTAMPING_TX_ACK)) {
> +			kfree_skb(skb);
>  			return;
> +		}
>  
>  		serr->ee.ee_errno = ENOMSG;
>  		serr->ee.ee_origin = SO_EE_ORIGIN_TIMESTAMPING;
> @@ -918,8 +920,10 @@ void j1939_sk_errqueue(struct j1939_session *session,
>  		state = "ACK";
>  		break;
>  	case J1939_ERRQUEUE_SCHED:
> -		if (!(sk->sk_tsflags & SOF_TIMESTAMPING_TX_SCHED))
> +		if (!(sk->sk_tsflags & SOF_TIMESTAMPING_TX_SCHED)) {
> +			kfree_skb(skb);
>  			return;
> +		}
>  
>  		serr->ee.ee_errno = ENOMSG;
>  		serr->ee.ee_origin = SO_EE_ORIGIN_TIMESTAMPING;
> -- 
> 2.20.1
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
