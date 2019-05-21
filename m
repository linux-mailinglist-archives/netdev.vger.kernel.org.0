Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07D45244ED
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 02:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbfEUAJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 20:09:24 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59690 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbfEUAJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 20:09:24 -0400
Received: from localhost (50-78-161-185-static.hfc.comcastbusiness.net [50.78.161.185])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 73B4C13F61587;
        Mon, 20 May 2019 17:09:23 -0700 (PDT)
Date:   Mon, 20 May 2019 20:09:22 -0400 (EDT)
Message-Id: <20190520.200922.2277656639346033061.davem@davemloft.net>
To:     Jan.Kloetzke@preh.de
Cc:     oneukum@suse.com, jan@kloetzke.net, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v2] usbnet: fix kernel crash after disconnect
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1557990629.19453.7.camel@preh.de>
References: <20190505.004556.492323065607253635.davem@davemloft.net>
        <1557130666.12778.3.camel@suse.com>
        <1557990629.19453.7.camel@preh.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 May 2019 17:09:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kloetzke Jan <Jan.Kloetzke@preh.de>
Date: Thu, 16 May 2019 07:10:30 +0000

> Am Montag, den 06.05.2019, 10:17 +0200 schrieb Oliver Neukum:
>> On So, 2019-05-05 at 00:45 -0700, David Miller wrote:
>> > From: Kloetzke Jan <Jan.Kloetzke@preh.de>
>> > Date: Tue, 30 Apr 2019 14:15:07 +0000
>> > 
>> > > @@ -1431,6 +1432,11 @@ netdev_tx_t usbnet_start_xmit (struct sk_buff *skb,
>> > >               spin_unlock_irqrestore(&dev->txq.lock, flags);
>> > >               goto drop;
>> > >       }
>> > > +     if (WARN_ON(netif_queue_stopped(net))) {
>> > > +             usb_autopm_put_interface_async(dev->intf);
>> > > +             spin_unlock_irqrestore(&dev->txq.lock, flags);
>> > > +             goto drop;
>> > > +     }
>> > 
>> > If this is known to happen and is expected, then we should not warn.
>> > 
>> 
>> yes this is the point. Can ndo_start_xmit() and ndo_stop() race?
>> If not, why does the patch fix the observed issue and what
>> prevents the race? Something is not clear here.
> 
> Dave, could you shed some light on Olivers question? If the race can
> happen then we can stick to v1 because the WARN_ON is indeed pointless.
> Otherwise it's not clear why it made the problem go away for us and v2
> may be the better option...

Yes I think they can race.   ->ndo_stop() executes and stops the queue,
then we get an RCU grace period so that all parallel executions of
->ndo_start_xmit() complete.

But I wonder, this can probably cause problems because some drivers have
"stop queue and re-check" logic, f.e. in drivers/net/tg3.c we have:

	if (unlikely(tg3_tx_avail(tnapi) <= (MAX_SKB_FRAGS + 1))) {
		netif_tx_stop_queue(txq);

		/* netif_tx_stop_queue() must be done before checking
		 * checking tx index in tg3_tx_avail() below, because in
		 * tg3_tx(), we update tx index before checking for
		 * netif_tx_queue_stopped().
		 */
		smp_mb();
		if (tg3_tx_avail(tnapi) > TG3_TX_WAKEUP_THRESH(tnapi))
			netif_tx_wake_queue(txq);
	}

which in the racey scenerio would undo ->ndo_stop()'s work which is
completely unexpected.

Hmmm...
