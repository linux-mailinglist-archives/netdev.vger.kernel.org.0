Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29BB3547B08
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 18:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbiFLQXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 12:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiFLQXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 12:23:10 -0400
Received: from mail.enpas.org (zhong.enpas.org [46.38.239.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 92AB3579B6;
        Sun, 12 Jun 2022 09:23:09 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by mail.enpas.org (Postfix) with ESMTPSA id EAF23FF9E2;
        Sun, 12 Jun 2022 16:23:07 +0000 (UTC)
Date:   Sun, 12 Jun 2022 18:23:02 +0200
From:   Max Staudt <max@enpas.org>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-kernel@vger.kernel.org,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 05/13] can: slcan: simplify the device de-allocation
Message-ID: <20220612182302.36bdd9b9.max@enpas.org>
In-Reply-To: <CABGWkvroJG16AOu8BODhVu068jacjHWbkkY9TCF4PQ7rgANVXA@mail.gmail.com>
References: <20220608165116.1575390-1-dario.binacchi@amarulasolutions.com>
        <20220608165116.1575390-6-dario.binacchi@amarulasolutions.com>
        <eae65531-bf9f-4e2e-97ca-a79a8aa833fc@hartkopp.net>
        <CABGWkvroJG16AOu8BODhVu068jacjHWbkkY9TCF4PQ7rgANVXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 11 Jun 2022 12:46:04 +0200
Dario Binacchi <dario.binacchi@amarulasolutions.com> wrote:

> > As written before I would like to discuss this change out of your
> > patch series "can: slcan: extend supported features" as it is no
> > slcan feature extension AND has to be synchronized with the
> > drivers/net/slip/slip.c implementation.  
> 
> Why do you need to synchronize it with  drivers/net/slip/slip.c
> implementation ?

Because slcan.c is a derivative of slip.c and the code still looks
*very* similar, so improvements in one file should be ported to the
other and vice versa. This has happened several times now.


> > When it has not real benefit and introduces more code and may create
> > side effects, this beautification should probably be omitted at all.
> >  
> 
> I totally agree with you. I would have already dropped it if this
> patch didn't make sense. But since I seem to have understood that
> this is not the case, I do not understand why it cannot be improved
> in this series.

This series is mostly about adding netlink support. If there is a point
of contention about a beautification, it may be easier to discuss that
separately, so the netlink code can be merged while the beautification
is still being discussed.


On another note, the global array of slcan_devs is really unnecessary
and maintaining it is a mess - as seen in some of your patches, that
have to account for it in tons of places and get complicated because of
it.

slcan_devs is probably grandfathered from a very old kernel, since
slip.c is about 30 years old, so I suggest to remove it entirely. In
fact, it may be easier to patch slcan_devs away first, and that will
simplify your open/close patches - your decision :)


If you wish to implement the slcan_devs removal, here are some hints:

The private struct can just be allocated as part of struct can_priv in
slcan_open(), like so:

  struct net_device *dev;
  dev = alloc_candev(sizeof(struct slcan), 0);

And then accessed like so:

  struct slcan *sl = netdev_priv(dev);

Make sure to add struct can_priv as the first member of struct slcan:

  /* This must be the first member when using alloc_candev() */
  struct can_priv can;


> The cover letter highlighted positive reactions to the series because
> the module had been requiring these kinds of changes for quite
> some time. So, why not take the opportunity to finalize this patch in
> this series even if it doesn't extend the supported features ?

Because... I can only speak for myself, but I'd merge all the
unambiguous stuff first and discuss the difficult stuff later, if there
are no interdependencies :)



Max
