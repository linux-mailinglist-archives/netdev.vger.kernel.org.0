Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 790F5459EB1
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 09:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234217AbhKWI5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 03:57:45 -0500
Received: from pi.codeconstruct.com.au ([203.29.241.158]:55532 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbhKWI5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 03:57:42 -0500
Received: from pecola.lan (unknown [159.196.93.152])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id 9DA772012D;
        Tue, 23 Nov 2021 16:54:32 +0800 (AWST)
Message-ID: <75731fa707871b20444a10c28e9883778fcd6688.camel@codeconstruct.com.au>
Subject: Re: [PATCH net-next v2] mctp: Add MCTP-over-serial transport binding
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     Jiri Slaby <jirislaby@kernel.org>, netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Tue, 23 Nov 2021 16:54:31 +0800
In-Reply-To: <e6c37dee-89a5-d56d-bf53-55ac4bec9083@kernel.org>
References: <20211123015952.2998176-1-jk@codeconstruct.com.au>
         <e6c37dee-89a5-d56d-bf53-55ac4bec9083@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.0-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri,

Thanks for taking a look at the patch, some comments inline.

> > +       /* ... or the next byte to send is an escaped byte; requiring a
> > +        * single-byte chunk...
> 
> This is not a correct multi-line comment. Or does net/ differ in
> this?

Yep, different for net/:

 https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html#is-the-comment-style-convention-different-for-the-networking-content

(even though I guess we're technically drivers/net/ here...)

> > +static netdev_tx_t mctp_serial_tx(struct sk_buff *skb, struct net_device *ndev)
> > +{
> > +       struct mctp_serial *dev = netdev_priv(ndev);
> > +       unsigned long flags;
> > +
> > +       WARN_ON(dev->txstate != STATE_IDLE);
> > +
> > +       if (skb->len > MCTP_SERIAL_MTU) {
> 
> Shouldn't you implement ndo_change_mtu to forbid larger frames
> instead?

Even better, I can set the dev min and max MTUs in _setup, so we'll get
the netlink extacks reported too. However, I'd still like to leave this
is in to ensure there's no way to overrun the tx buffer.

> > +static void mctp_serial_rx(struct mctp_serial *dev)
> > +{
> > +       struct mctp_skb_cb *cb;
> > +       struct sk_buff *skb;
> > +
> > +       if (dev->rxfcs != dev->rxfcs_rcvd) {
> > +               dev->netdev->stats.rx_dropped++;
> > +               dev->netdev->stats.rx_crc_errors++;
> > +               return;
> > +       }
> > +
> > +       skb = netdev_alloc_skb(dev->netdev, dev->rxlen);
> 
> Just thinking… Wouldn't it be easier to have dev->skb instead of 
> dev->rxbuf and push data to it directly in all those
> mctp_serial_push*()?

There's not a huge benefit to doing so - we still need the RX state
machine, so will still need the mctp_serial_push_* code. Having the
rxbuf means we will always have a buffer available for pushed data,
rather than extra conditions in the rx state machine for if we've failed
to allocate the next skb.

Doing this as a final stage in the rx path means we can keep the state
machine a little simpler, and perform the drop in a single location.

The downside to the current approach is the extra copy in skb_put_data()
though, but we're not really dealing with high-bandwidth links here.

I'm happy to change if there's particular preference either way though!

> > +static int mctp_serial_open(struct tty_struct *tty)
> > +{
> > +       struct mctp_serial *dev;
> > +       struct net_device *ndev;
> > +       char name[32];
> > +       int idx, rc;
> > +
> > +       if (!capable(CAP_NET_ADMIN))
> > +               return -EPERM;
> > +
> > +       if (!tty->ops->write)
> > +               return -EOPNOTSUPP;
> > +
> > +       if (tty->disc_data)
> > +               return -EEXIST;
> 
> This should never happen™.

OK, excellent, I'll remove.

> > +static void mctp_serial_close(struct tty_struct *tty)
> > +{
> > +       struct mctp_serial *dev = tty->disc_data;
> > +       int idx = dev->idx;
> > +
> > +       unregister_netdev(dev->netdev);
> > +       ida_free(&mctp_serial_ida, idx);
> 
> No tx_work flushing/cancelling?

Ooh, yeah. I'll fix in v4.

Cheers,


Jeremy
