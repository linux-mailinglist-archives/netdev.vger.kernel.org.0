Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD71403310
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 05:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347533AbhIHDsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 23:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbhIHDsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 23:48:08 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4FA6C061757
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 20:47:00 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mNoXx-0000R3-2h; Wed, 08 Sep 2021 05:46:49 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mNoXt-0006Bz-4O; Wed, 08 Sep 2021 05:46:45 +0200
Date:   Wed, 8 Sep 2021 05:46:45 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     robin@protonic.nl, linux@rempel-privat.de, socketcan@hartkopp.net,
        mkl@pengutronix.de, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] can: j1939: fix errant WARN_ON_ONCE in
 j1939_session_deactivate
Message-ID: <20210908034645.GA26100@pengutronix.de>
References: <20210906094200.95868-1-william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210906094200.95868-1-william.xuanziyang@huawei.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 05:44:33 up 202 days,  7:08, 69 users,  load average: 0.01, 0.07,
 0.08
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for your patches. Please stay on hold, I'll review it end of
this week.

On Mon, Sep 06, 2021 at 05:42:00PM +0800, Ziyang Xuan wrote:
> The conclusion "j1939_session_deactivate() should be called with a
> session ref-count of at least 2" is incorrect. In some concurrent
> scenarios, j1939_session_deactivate can be called with the session
> ref-count less than 2. But there is not any problem because it
> will check the session active state before session putting in
> j1939_session_deactivate_locked().
> 
> Here is the concurrent scenario of the problem reported by syzbot
> and my reproduction log.
> 
>         cpu0                            cpu1
>                                 j1939_xtp_rx_eoma
> j1939_xtp_rx_abort_one
>                                 j1939_session_get_by_addr [kref == 2]
> j1939_session_get_by_addr [kref == 3]
> j1939_session_deactivate [kref == 2]
> j1939_session_put [kref == 1]
> 				j1939_session_completed
> 				j1939_session_deactivate
> 				WARN_ON_ONCE(kref < 2)
> 
> =====================================================
> WARNING: CPU: 1 PID: 21 at net/can/j1939/transport.c:1088 j1939_session_deactivate+0x5f/0x70
> CPU: 1 PID: 21 Comm: ksoftirqd/1 Not tainted 5.14.0-rc7+ #32
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1 04/01/2014
> RIP: 0010:j1939_session_deactivate+0x5f/0x70
> Call Trace:
>  j1939_session_deactivate_activate_next+0x11/0x28
>  j1939_xtp_rx_eoma+0x12a/0x180
>  j1939_tp_recv+0x4a2/0x510
>  j1939_can_recv+0x226/0x380
>  can_rcv_filter+0xf8/0x220
>  can_receive+0x102/0x220
>  ? process_backlog+0xf0/0x2c0
>  can_rcv+0x53/0xf0
>  __netif_receive_skb_one_core+0x67/0x90
>  ? process_backlog+0x97/0x2c0
>  __netif_receive_skb+0x22/0x80
> 
> Fixes: 0c71437dd50d ("can: j1939: j1939_session_deactivate(): clarify lifetime of session object")
> Reported-by: syzbot+9981a614060dcee6eeca@syzkaller.appspotmail.com
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> ---
>  net/can/j1939/transport.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
> index bdc95bd7a851..0f8309314075 100644
> --- a/net/can/j1939/transport.c
> +++ b/net/can/j1939/transport.c
> @@ -1079,10 +1079,6 @@ static bool j1939_session_deactivate(struct j1939_session *session)
>  	bool active;
>  
>  	j1939_session_list_lock(priv);
> -	/* This function should be called with a session ref-count of at
> -	 * least 2.
> -	 */
> -	WARN_ON_ONCE(kref_read(&session->kref) < 2);
>  	active = j1939_session_deactivate_locked(session);
>  	j1939_session_list_unlock(priv);
>  
> -- 
> 2.25.1
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
