Return-Path: <netdev+bounces-5856-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 62DC87132B6
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 07:57:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F1DB81C2113B
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 05:57:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8C4015B5;
	Sat, 27 May 2023 05:57:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56CB644
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 05:57:23 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D15C116
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 22:57:22 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ore@pengutronix.de>)
	id 1q2mvL-0005pl-A3; Sat, 27 May 2023 07:57:07 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
	(envelope-from <ore@pengutronix.de>)
	id 1q2mvI-0004cX-A8; Sat, 27 May 2023 07:57:04 +0200
Date: Sat, 27 May 2023 07:57:04 +0200
From: Oleksij Rempel <o.rempel@pengutronix.de>
To: Fedor Pchelkin <pchelkin@ispras.ru>
Cc: Oleksij Rempel <linux@rempel-privat.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>, kernel@pengutronix.de,
	Robin van der Gracht <robin@protonic.nl>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
	linux-can@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	lvc-project@linuxtesting.org
Subject: Re: [PATCH 2/2] can: j1939: avoid possible use-after-free when
 j1939_can_rx_register fails
Message-ID: <20230527055704.GA17237@pengutronix.de>
References: <20230526171910.227615-1-pchelkin@ispras.ru>
 <20230526171910.227615-3-pchelkin@ispras.ru>
 <20230526181500.GA26860@pengutronix.de>
 <20230526185026.33pcjvoyq5jzlnxk@fpc>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230526185026.33pcjvoyq5jzlnxk@fpc>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
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

Hi Fedor,

On Fri, May 26, 2023 at 09:50:26PM +0300, Fedor Pchelkin wrote:
> Hi Oleksij,
> 
> thanks for the reply!
> 
> On Fri, May 26, 2023 at 08:15:00PM +0200, Oleksij Rempel wrote:
> > Hi Fedor,
> > 
> > On Fri, May 26, 2023 at 08:19:10PM +0300, Fedor Pchelkin wrote:
> > 
> > 
> > Thank you for your investigation. How about this change?
> > --- a/net/can/j1939/main.c
> > +++ b/net/can/j1939/main.c
> > @@ -285,8 +285,7 @@ struct j1939_priv *j1939_netdev_start(struct net_device *ndev)
> >                  */
> >                 kref_get(&priv_new->rx_kref);
> >                 spin_unlock(&j1939_netdev_lock);
> > -               dev_put(ndev);
> > -               kfree(priv);
> > +               j1939_priv_put(priv);
> 
> I don't think that's good because the priv which is directly freed here is
> still local to the thread, and parallel threads don't have any access to
> it. j1939_priv_create() has allocated a fresh priv and called dev_hold()
> so dev_put() and kfree() here are okay.
> 
> >                 return priv_new;
> >         }
> >         j1939_priv_set(ndev, priv);
> > @@ -300,8 +299,7 @@ struct j1939_priv *j1939_netdev_start(struct net_device *ndev)
> >  
> >   out_priv_put:
> >         j1939_priv_set(ndev, NULL);
> > -       dev_put(ndev);
> > -       kfree(priv);
> > +       j1939_priv_put(priv);
> >  
> >         return ERR_PTR(ret);
> >  }
> > 
> > If I see it correctly, the problem is kfree() which is called without respecting
> > the ref counting. If CPU1 has priv_new, refcounting is increased. The priv will
> > not be freed on this place.
> 
> With your suggestion, I think it doesn't work correctly if
> j1939_can_rx_register() fails and we go to out_priv_put. The priv is kept
> but the parallel thread which may have already grabbed it thinks that
> j1939_can_rx_register() has succeeded when actually it hasn't succeed.
> Moreover, j1939_priv_set() makes it NULL on error path so that priv cannot
> be accessed from ndev.
> 
> I also considered the alternatives where we don't have to serialize access
> to j1939_can_rx_register() and subsequently introduce mutex. But with
> current j1939_netdev_start() implementation I can't see how to fix the
> racy bug without it.
 
Ok, it make sense.

I'll try to do some testing next week. If i'll forget it, please feel
free to ping me.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

