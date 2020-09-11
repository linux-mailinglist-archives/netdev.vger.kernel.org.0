Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630F8265999
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 08:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725773AbgIKGu7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 11 Sep 2020 02:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgIKGu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 02:50:58 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25597C061573
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 23:50:57 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kGctS-0007Mq-QE; Fri, 11 Sep 2020 08:50:46 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1kGctN-0005XU-8x; Fri, 11 Sep 2020 08:50:41 +0200
Date:   Fri, 11 Sep 2020 08:50:41 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     robin@protonic.nl, linux@rempel-privat.de, kernel@pengutronix.de,
        socketcan@hartkopp.net, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org, linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] can: j1939: j1939_sk_bind(): return failure if
 netdev is down
Message-ID: <20200911065041.v4cetsbokqhdmbd4@pengutronix.de>
References: <1599460308-18770-1-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1599460308-18770-1-git-send-email-zhangchangzhong@huawei.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:47:40 up 300 days, 22:06, 291 users,  load average: 0.00, 0.04,
 0.06
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 07, 2020 at 02:31:48PM +0800, Zhang Changzhong wrote:
> When a netdev down event occurs after a successful call to
> j1939_sk_bind(), j1939_netdev_notify() can handle it correctly.
> 
> But if the netdev already in down state before calling j1939_sk_bind(),
> j1939_sk_release() will stay in wait_event_interruptible() blocked
> forever. Because in this case, j1939_netdev_notify() won't be called and
> j1939_tp_txtimer() won't call j1939_session_cancel() or other function
> to clear session for ENETDOWN error, this lead to mismatch of
> j1939_session_get/put() and jsk->skb_pending will never decrease to
> zero.
> 
> To reproduce it use following commands:
> 1. ip link add dev vcan0 type vcan
> 2. j1939acd -r 100,80-120 1122334455667788 vcan0
> 3. presses ctrl-c and thread will be blocked forever
> 
> This patch adds check for ndev->flags in j1939_sk_bind() to avoid this
> kind of situation and return with -ENETDOWN.
> 
> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>

Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>

Thank you!

> ---
>  net/can/j1939/socket.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
> index 1be4c89..f239665 100644
> --- a/net/can/j1939/socket.c
> +++ b/net/can/j1939/socket.c
> @@ -475,6 +475,12 @@ static int j1939_sk_bind(struct socket *sock, struct sockaddr *uaddr, int len)
>  			goto out_release_sock;
>  		}
>  
> +		if (!(ndev->flags & IFF_UP)) {
> +			dev_put(ndev);
> +			ret = -ENETDOWN;
> +			goto out_release_sock;
> +		}
> +
>  		priv = j1939_netdev_start(ndev);
>  		dev_put(ndev);
>  		if (IS_ERR(priv)) {
> -- 
> 2.9.5
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
