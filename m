Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB6343DB8B
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 08:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbhJ1GyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 02:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbhJ1GyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 02:54:22 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D014C061570
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 23:51:56 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mfzGN-0000tD-06; Thu, 28 Oct 2021 08:51:47 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mfzGK-0000Ht-Ae; Thu, 28 Oct 2021 08:51:44 +0200
Date:   Thu, 28 Oct 2021 08:51:44 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     Robin van der Gracht <robin@protonic.nl>,
        linux-kernel@vger.kernel.org,
        Oleksij Rempel <linux@rempel-privat.de>,
        netdev@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net 2/3] can: j1939: j1939_can_recv(): ignore messages
 with invalid source address
Message-ID: <20211028065144.GE20681@pengutronix.de>
References: <1634825057-47915-1-git-send-email-zhangchangzhong@huawei.com>
 <1634825057-47915-3-git-send-email-zhangchangzhong@huawei.com>
 <20211022102306.GB20681@pengutronix.de>
 <9c636d7f-70df-18c9-66ed-46eb21f4ffbb@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9c636d7f-70df-18c9-66ed-46eb21f4ffbb@huawei.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:46:42 up 252 days, 10:10, 114 users,  load average: 0.11, 0.11,
 0.12
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Oct 25, 2021 at 03:30:57PM +0800, Zhang Changzhong wrote:
> On 2021/10/22 18:23, Oleksij Rempel wrote:
> > On Thu, Oct 21, 2021 at 10:04:16PM +0800, Zhang Changzhong wrote:
> >> According to SAE-J1939-82 2015 (A.3.6 Row 2), a receiver should never
> >> send TP.CM_CTS to the global address, so we can add a check in
> >> j1939_can_recv() to drop messages with invalid source address.
> >>
> >> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> >> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> > 
> > NACK. This will break Address Claiming, where first message is SA == 0xff
> 
> I know that 0xfe can be used as a source address, but which message has a source
> address of 0xff?
> 
> According to SAE-J1939-81 2017 4.2.2.8：
> 
>   The network address 255, also known as the Global address, is permitted in the
>   Destination Address field of the SAE J1939 message identifier but never in the
>   Source Address field.

You are right. Thx!

Are you using any testing frameworks?
Can you please take a look here:
https://github.com/linux-can/can-tests/tree/master/j1939

We are using this scripts for regression testing of some know bugs.

> 
> > 
> >> ---
> >>  net/can/j1939/main.c | 4 ++++
> >>  1 file changed, 4 insertions(+)
> >>
> >> diff --git a/net/can/j1939/main.c b/net/can/j1939/main.c
> >> index 08c8606..4f1e4bb 100644
> >> --- a/net/can/j1939/main.c
> >> +++ b/net/can/j1939/main.c
> >> @@ -75,6 +75,10 @@ static void j1939_can_recv(struct sk_buff *iskb, void *data)
> >>  	skcb->addr.pgn = (cf->can_id >> 8) & J1939_PGN_MAX;
> >>  	/* set default message type */
> >>  	skcb->addr.type = J1939_TP;
> >> +	if (!j1939_address_is_valid(skcb->addr.sa))
> >> +		/* ignore messages whose sa is broadcast address */
> >> +		goto done;

Please add some warning once message here. We wont to know if something bad
is happening on the bus.

> >> +
> >>  	if (j1939_pgn_is_pdu1(skcb->addr.pgn)) {
> >>  		/* Type 1: with destination address */
> >>  		skcb->addr.da = skcb->addr.pgn;
> >> -- 
> >> 2.9.5
> >>
> >>
> >>
> > 
> 
> 

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
