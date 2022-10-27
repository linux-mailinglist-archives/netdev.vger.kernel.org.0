Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2A6360F635
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 13:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235126AbiJ0LaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 07:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235283AbiJ0LaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 07:30:05 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6156626567
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 04:30:04 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oo159-0007Rd-On; Thu, 27 Oct 2022 13:29:55 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oo159-0001ku-1K; Thu, 27 Oct 2022 13:29:55 +0200
Date:   Thu, 27 Oct 2022 13:29:55 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        robin@protonic.nl, linux@rempel-privat.de, kernel@pengutronix.de,
        socketcan@hartkopp.net, mkl@pengutronix.de
Subject: Re: [PATCH v2] can: j1939: transport: replace kfree_skb() with
 dev_kfree_skb_irq()
Message-ID: <20221027112955.GA17401@pengutronix.de>
References: <20221027091237.2290111-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221027091237.2290111-1-yangyingliang@huawei.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 27, 2022 at 05:12:37PM +0800, Yang Yingliang wrote:
> It is not allowed to call kfree_skb() from hardware interrupt
> context or with interrupts being disabled. The skb is unlinked
> from the queue, so it can be freed after spin_unlock_irqrestore().
> 
> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>

> ---
> v1 -> v2:
>   Move kfree_skb() after spin_unlock_irqrestore().
> ---
>  net/can/j1939/transport.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
> index d7d86c944d76..55f29c9f9e08 100644
> --- a/net/can/j1939/transport.c
> +++ b/net/can/j1939/transport.c
> @@ -342,10 +342,12 @@ static void j1939_session_skb_drop_old(struct j1939_session *session)
>  		__skb_unlink(do_skb, &session->skb_queue);
>  		/* drop ref taken in j1939_session_skb_queue() */
>  		skb_unref(do_skb);
> +		spin_unlock_irqrestore(&session->skb_queue.lock, flags);
>  
>  		kfree_skb(do_skb);
> +	} else {
> +		spin_unlock_irqrestore(&session->skb_queue.lock, flags);
>  	}
> -	spin_unlock_irqrestore(&session->skb_queue.lock, flags);
>  }
>  
>  void j1939_session_skb_queue(struct j1939_session *session,
> -- 
> 2.25.1
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
