Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6B7257FF98
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 15:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235480AbiGYNJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 09:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235481AbiGYNJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 09:09:32 -0400
Received: from mail.enpas.org (zhong.enpas.org [46.38.239.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 22AF013D76;
        Mon, 25 Jul 2022 06:09:28 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by mail.enpas.org (Postfix) with ESMTPSA id 430C0FF9C3;
        Mon, 25 Jul 2022 13:09:26 +0000 (UTC)
Date:   Mon, 25 Jul 2022 15:09:20 +0200
From:   Max Staudt <max@enpas.org>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 2/5] can: slcan: remove legacy infrastructure
Message-ID: <20220725150920.63ac3a77.max@enpas.org>
In-Reply-To: <CABGWkvrgX+9J-rOb-EO1wXVAZQ5phwKKpbc-iD491rD9zn5UpQ@mail.gmail.com>
References: <20220716170007.2020037-1-dario.binacchi@amarulasolutions.com>
        <20220716170007.2020037-3-dario.binacchi@amarulasolutions.com>
        <20220717233842.1451e349.max@enpas.org>
        <CABGWkvrgX+9J-rOb-EO1wXVAZQ5phwKKpbc-iD491rD9zn5UpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jul 2022 08:40:24 +0200
Dario Binacchi <dario.binacchi@amarulasolutions.com> wrote:

> > > @@ -883,72 +786,50 @@ static int slcan_open(struct tty_struct *tty)
> > >       if (!tty->ops->write)
> > >               return -EOPNOTSUPP;
> > >
> > > -     /* RTnetlink lock is misused here to serialize concurrent
> > > -      * opens of slcan channels. There are better ways, but it is
> > > -      * the simplest one.
> > > -      */
> > > -     rtnl_lock();
> > > +     dev = alloc_candev(sizeof(*sl), 1);
> > > +     if (!dev)
> > > +             return -ENFILE;
> > >
> > > -     /* Collect hanged up channels. */
> > > -     slc_sync();
> > > +     sl = netdev_priv(dev);
> > >
> > > -     sl = tty->disc_data;
> > > +     /* Configure TTY interface */
> > > +     tty->receive_room = 65536; /* We don't flow control */
> > > +     sl->rcount   = 0;
> > > +     sl->xleft    = 0;  
> >
> > I suggest moving the zeroing to slc_open() - i.e. to the netdev open
> > function. As a bonus, you can then remove the same two assignments from
> > slc_close() (see above). They are only used when netif_running(), with
> > appropiate guards already in place as far as I can see.  
> 
> I think it is better to keep the code as it is, since at the entry of
> the netdev
> open function, netif_running already returns true (it is set to true by the
> calling function) and therefore it would be less safe to reset the
> rcount and xleft
> fields.

Wow, great catch!

I wonder why __LINK_STATE_START is set before ->ndo_open() is called...?


Since the drivers are similar, I've checked can327. It is unaffected,
because the counters are additionally guarded by a spinlock. Same in
slcan, where netdev_close() takes the spinlock to reset the counters.

So you *could* move them to netdev_open() *if* they are always guarded
by the slcan lock.

Or, leave it as it is, as it seems to be correct. Your choice :)


Thank you!

Max
