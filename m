Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 658C5F8EB2
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 12:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfKLLh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 06:37:27 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:33279 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbfKLLh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 06:37:27 -0500
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1iUUU8-00066K-MK; Tue, 12 Nov 2019 12:37:24 +0100
Received: from ukl by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ukl@pengutronix.de>)
        id 1iUUU8-0003DF-1s; Tue, 12 Nov 2019 12:37:24 +0100
Date:   Tue, 12 Nov 2019 12:37:24 +0100
From:   Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     dev.kurt@vandijck-laurijssen.be, mkl@pengutronix.de,
        wg@grandegger.com, netdev@vger.kernel.org, kernel@pengutronix.de,
        linux-can@vger.kernel.org
Subject: Re: [PATCH v1 1/9] can: af_can: export can_sock_destruct()
Message-ID: <20191112113724.pff6atmyii5ri4my@pengutronix.de>
References: <20191112111600.18719-1-o.rempel@pengutronix.de>
 <20191112111600.18719-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191112111600.18719-2-o.rempel@pengutronix.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Tue, Nov 12, 2019 at 12:15:52PM +0100, Oleksij Rempel wrote:
> In j1939 we need our own struct sock::sk_destruct callback. Export the
> generic af_can can_sock_destruct() that allows us to chain-call it.
> 
> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  include/linux/can/core.h | 1 +
>  net/can/af_can.c         | 3 ++-
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/can/core.h b/include/linux/can/core.h
> index 8339071ab08b..e20a0cd09ba5 100644
> --- a/include/linux/can/core.h
> +++ b/include/linux/can/core.h
> @@ -65,5 +65,6 @@ extern void can_rx_unregister(struct net *net, struct net_device *dev,
>  			      void *data);
>  
>  extern int can_send(struct sk_buff *skb, int loop);
> +void can_sock_destruct(struct sock *sk);
>  
>  #endif /* !_CAN_CORE_H */
> diff --git a/net/can/af_can.c b/net/can/af_can.c
> index 5518a7d9eed9..128d37a4c2e0 100644
> --- a/net/can/af_can.c
> +++ b/net/can/af_can.c
> @@ -86,11 +86,12 @@ static atomic_t skbcounter = ATOMIC_INIT(0);
>  
>  /* af_can socket functions */
>  
> -static void can_sock_destruct(struct sock *sk)
> +void can_sock_destruct(struct sock *sk)
>  {
>  	skb_queue_purge(&sk->sk_receive_queue);
>  	skb_queue_purge(&sk->sk_error_queue);
>  }
> +EXPORT_SYMBOL(can_sock_destruct);

If the users are only expected to be another can module, it might make
sense to use a namespace here?!

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |
