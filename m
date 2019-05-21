Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2E6724C1D
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 12:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfEUKBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 06:01:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:57630 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726138AbfEUKBl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 May 2019 06:01:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 981ADAE48;
        Tue, 21 May 2019 10:01:40 +0000 (UTC)
Message-ID: <1558432122.12672.12.camel@suse.com>
Subject: Re: [PATCH v2] usbnet: fix kernel crash after disconnect
From:   Oliver Neukum <oneukum@suse.com>
To:     Kloetzke Jan <Jan.Kloetzke@preh.de>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     "jan@kloetzke.net" <jan@kloetzke.net>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date:   Tue, 21 May 2019 11:48:42 +0200
In-Reply-To: <1557990629.19453.7.camel@preh.de>
References: <1556563688.20085.31.camel@suse.com>
         <20190430141440.9469-1-Jan.Kloetzke@preh.de>
         <20190505.004556.492323065607253635.davem@davemloft.net>
         <1557130666.12778.3.camel@suse.com> <1557990629.19453.7.camel@preh.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Do, 2019-05-16 at 07:10 +0000, Kloetzke Jan wrote:
> Am Montag, den 06.05.2019, 10:17 +0200 schrieb Oliver Neukum:
> > On So, 2019-05-05 at 00:45 -0700, David Miller wrote:
> > > From: Kloetzke Jan <Jan.Kloetzke@preh.de>
> > > Date: Tue, 30 Apr 2019 14:15:07 +0000
> > > 
> > > > @@ -1431,6 +1432,11 @@ netdev_tx_t usbnet_start_xmit (struct sk_buff *skb,
> > > >               spin_unlock_irqrestore(&dev->txq.lock, flags);
> > > >               goto drop;
> > > >       }
> > > > +     if (WARN_ON(netif_queue_stopped(net))) {
> > > > +             usb_autopm_put_interface_async(dev->intf);
> > > > +             spin_unlock_irqrestore(&dev->txq.lock, flags);
> > > > +             goto drop;
> > > > +     }
> > > 
> > > If this is known to happen and is expected, then we should not warn.
> > > 
> > 
> > Hi,
> > 
> > yes this is the point. Can ndo_start_xmit() and ndo_stop() race?
> > If not, why does the patch fix the observed issue and what
> > prevents the race? Something is not clear here.
> 
> Dave, could you shed some light on Olivers question? If the race can
> happen then we can stick to v1 because the WARN_ON is indeed pointless.
> Otherwise it's not clear why it made the problem go away for us and v2
> may be the better option...

Hi,

as Dave confirmed that the race exists, could you resubmit without
the WARN ?

	Regards
		Oliver

