Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B17858A913
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 11:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235839AbiHEJzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 05:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237707AbiHEJza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 05:55:30 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DBA13D66
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 02:55:29 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oJu32-0006qq-Pl; Fri, 05 Aug 2022 11:55:16 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oJu31-0002Sn-AS; Fri, 05 Aug 2022 11:55:15 +0200
Date:   Fri, 5 Aug 2022 11:55:15 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>, kernel@pengutronix.de,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: Re: [PATCH] can: j1939: fix memory leak of skbs
Message-ID: <20220805095515.GA10667@pengutronix.de>
References: <20220708175949.539064-1-pchelkin@ispras.ru>
 <20220729042244.GC30201@pengutronix.de>
 <18aa0617-0afe-2543-89cf-2f04c682ea88@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <18aa0617-0afe-2543-89cf-2f04c682ea88@ispras.ru>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 05, 2022 at 11:56:18AM +0300, Fedor Pchelkin wrote:
> Hi Oleksij,
> 
> On 29.07.2022 07:22, Oleksij Rempel wrote:
> > Initial issue can be reproduced by using real (slow) CAN with j1939cat[1]
> > tool. Both parts should be started to make sure the j1939_session_tx_dat() will
> > actually start using the queue. After pushing about 100K of data, application
> > will try to close the socket and exit. After socket is closed, all skb related
> > to this socket will be freed and j1939_session_tx_dat() will use freed skbs.
> 
> Ok, the patch I suggested was a kind of a guess, now I understand that
> it breaks important logic.
> 
> On 29.07.2022 07:22, Oleksij Rempel wrote:
> > This skb_get() is counter part of skb_unref()
> > j1939_session_skb_drop_old().
> 
> However, we have a case [1] where j1939_session_skb_queue() is called
> but the corresponding j1939_session_skb_drop_old() is not called and it
> causes a memory leak.
> 
> I tried to investigate it a little bit: the thing is that
> j1939_session_skb_drop_old() can be called only when processing
> J1939_ETP_CMD_CTS. On the contrary, as I can see,
> j1939_session_skb_queue() can be called independently from
> J1939_ETP_CMD_CTS so the two functions obviously do not correspond to
> each other.
> 
> In reproducer case there is a J1939_ETP_CMD_RTS processing, then
> we send some messages (where j1939_session_skb_queue() is called) and
> after that J1939_ETP_CMD_ABORT is processed and we lose those skbs.

Ah.. good point.
In this case it will go to:
  j1939_session_destroy()
    skb_queue_purge(&session->skb_queue)
      kfree_skb(skb);

And in the normal path we have:
  j1939_session_skb_drop_old()
    skb_unref(do_skb);
    kfree_skb(do_skb);

It means skb_queue_purge() should be replaced with something like:
	while ((skb = skb_dequeue(list)) != NULL) {
		/* drop ref taken in j1939_session_skb_queue() */
		skb_unref(skb);
		kfree_skb(skb);
	}

Can you please test it?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
