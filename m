Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4774E145E2
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 10:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbfEFISJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 04:18:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:58314 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725836AbfEFISI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 May 2019 04:18:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5DEC3AEE8;
        Mon,  6 May 2019 08:18:07 +0000 (UTC)
Message-ID: <1557130666.12778.3.camel@suse.com>
Subject: Re: [PATCH v2] usbnet: fix kernel crash after disconnect
From:   Oliver Neukum <oneukum@suse.com>
To:     David Miller <davem@davemloft.net>, Jan.Kloetzke@preh.de
Cc:     jan@kloetzke.net, linux-usb@vger.kernel.org, netdev@vger.kernel.org
Date:   Mon, 06 May 2019 10:17:46 +0200
In-Reply-To: <20190505.004556.492323065607253635.davem@davemloft.net>
References: <1556563688.20085.31.camel@suse.com>
         <20190430141440.9469-1-Jan.Kloetzke@preh.de>
         <20190505.004556.492323065607253635.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On So, 2019-05-05 at 00:45 -0700, David Miller wrote:
> From: Kloetzke Jan <Jan.Kloetzke@preh.de>
> Date: Tue, 30 Apr 2019 14:15:07 +0000
> 
> > @@ -1431,6 +1432,11 @@ netdev_tx_t usbnet_start_xmit (struct sk_buff *skb,
> >               spin_unlock_irqrestore(&dev->txq.lock, flags);
> >               goto drop;
> >       }
> > +     if (WARN_ON(netif_queue_stopped(net))) {
> > +             usb_autopm_put_interface_async(dev->intf);
> > +             spin_unlock_irqrestore(&dev->txq.lock, flags);
> > +             goto drop;
> > +     }
> 
> If this is known to happen and is expected, then we should not warn.
> 

Hi,

yes this is the point. Can ndo_start_xmit() and ndo_stop() race?
If not, why does the patch fix the observed issue and what
prevents the race? Something is not clear here.

	Regards
		Oliver

