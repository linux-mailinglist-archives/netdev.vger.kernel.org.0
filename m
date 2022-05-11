Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F72152336F
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 14:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236732AbiEKMxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 08:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbiEKMxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 08:53:49 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4113A68308
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 05:53:48 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nolqa-0004z8-Cs; Wed, 11 May 2022 14:53:44 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nolqZ-0003oj-Tj; Wed, 11 May 2022 14:53:43 +0200
Date:   Wed, 11 May 2022 14:53:43 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Devid Antonio Filoni <devid.filoni@egluetechnologies.com>,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Jander <david@protonic.nl>
Subject: Re: [PATCH 1/1] can: skb: add and set local_origin flag
Message-ID: <20220511125343.GA24267@pengutronix.de>
References: <20220511121913.2696181-1-o.rempel@pengutronix.de>
 <b631b022-72d5-9160-fd13-f33c80dbbe59@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b631b022-72d5-9160-fd13-f33c80dbbe59@hartkopp.net>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:41:16 up 42 days,  1:10, 82 users,  load average: 0.08, 0.10,
 0.09
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 11, 2022 at 02:38:32PM +0200, Oliver Hartkopp wrote:
> Hi Oleksij,
> 
> On 5/11/22 14:19, Oleksij Rempel wrote:
> > Add new can_skb_priv::local_origin flag to be able detect egress
> > packages even if they was sent directly from kernel and not assigned to
> > some socket.
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > Cc: Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
> > ---
> >   drivers/net/can/dev/skb.c | 3 +++
> >   include/linux/can/skb.h   | 1 +
> >   net/can/raw.c             | 2 +-
> >   3 files changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/can/dev/skb.c b/drivers/net/can/dev/skb.c
> > index 61660248c69e..3e2357fb387e 100644
> > --- a/drivers/net/can/dev/skb.c
> > +++ b/drivers/net/can/dev/skb.c
> > @@ -63,6 +63,7 @@ int can_put_echo_skb(struct sk_buff *skb, struct net_device *dev,
> >   		/* save frame_len to reuse it when transmission is completed */
> >   		can_skb_prv(skb)->frame_len = frame_len;
> > +		can_skb_prv(skb)->local_origin = true;
> >   		skb_tx_timestamp(skb);
> > @@ -200,6 +201,7 @@ struct sk_buff *alloc_can_skb(struct net_device *dev, struct can_frame **cf)
> >   	can_skb_reserve(skb);
> >   	can_skb_prv(skb)->ifindex = dev->ifindex;
> >   	can_skb_prv(skb)->skbcnt = 0;
> > +	can_skb_prv(skb)->local_origin = false;
> >   	*cf = skb_put_zero(skb, sizeof(struct can_frame));
> > @@ -231,6 +233,7 @@ struct sk_buff *alloc_canfd_skb(struct net_device *dev,
> >   	can_skb_reserve(skb);
> >   	can_skb_prv(skb)->ifindex = dev->ifindex;
> >   	can_skb_prv(skb)->skbcnt = 0;
> > +	can_skb_prv(skb)->local_origin = false;
> 
> IMO this patch does not work as intended.
> 
> You probably need to revisit every place where can_skb_reserve() is used,
> e.g. in raw_sendmsg().
> 
> E.g. to make it work for virtual CAN and vxcan interfaces.

ok, i'll take a look on it.

> 
> I'm a bit unsure why we should not stick with the simple skb->sk handling?

In case of J1939 we have kernel generate control frames not associated with any
socket. For example transfer abort messages because no receive socket
was detected. Or there are multiple receive sockets and attaching to one
of it make no sense.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
