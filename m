Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77033EA76
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 20:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbfD2SsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 14:48:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:42986 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729023AbfD2SsW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 14:48:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4FE4AAD7B;
        Mon, 29 Apr 2019 18:48:21 +0000 (UTC)
Message-ID: <1556563688.20085.31.camel@suse.com>
Subject: Re: [PATCH] usbnet: fix kernel crash after disconnect
From:   Oliver Neukum <oneukum@suse.com>
To:     Jan =?ISO-8859-1?Q?Kl=F6tzke?= <jan@kloetzke.net>,
        David Miller <davem@davemloft.net>
Cc:     Jan.Kloetzke@preh.de, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Mon, 29 Apr 2019 20:48:08 +0200
In-Reply-To: <20190419071752.GG1084@tuxedo>
References: <20190417091849.7475-1-Jan.Kloetzke@preh.de>
         <1555569464.7835.4.camel@suse.com> <1555574578.4173.215.camel@preh.de>
         <20190418.163544.2153438649838575906.davem@davemloft.net>
         <20190419071752.GG1084@tuxedo>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fr, 2019-04-19 at 09:17 +0200, Jan Klötzke  wrote:
> Hi David,
> 
> On Thu, Apr 18, 2019 at 04:35:44PM -0700, David Miller wrote:
> > From: Kloetzke Jan <Jan.Kloetzke@preh.de>
> > Date: Thu, 18 Apr 2019 08:02:59 +0000
> > 
> > > I think this assumption is not correct. As far as I understand the
> > > networking code it is still possible that the ndo_start_xmit callback
> > > is called while ndo_stop is running and even after ndo_stop has
> > > returned. You can only be sure after unregister_netdev() has returned.
> > > Maybe some networking folks can comment on that.
> > 
> > The kernel loops over the devices being unregistered, and first it clears
> > the __LINK_STATE_START on all of them, then it invokes ->ndo_stop() on
> > all of them.
> > 
> > __LINK_STATE_START controls what netif_running() returns.
> > 
> > All calls to ->ndo_start_xmit() are guarded by netif_running() checks.
> > 
> > So when ndo_stop is invoked you should get no more ndo_start_xmit
> > invocations on that device.  Otherwise how could you shut down DMA
> > resources and turn off the TX engine properly?
> 
> But you could still race with another CPU that is past the
> netif_running() check, can you? So the driver has to make sure that it
> gracefully handles concurrent ->ndo_start_xmit() and ->ndo_stop() calls.

Looking at dev_direct_xmit(struct sk_buff *skb, u16 queue_id)
this indeed seems possible. But the documentation says that it is not.

Dave?

> Or are there any locks/barriers involved that make sure all
> ->ndo_start_xmit() calls have returned before invoking ->ndo_stop()?

Jan,

could you make versio of your patch that gives a WARNing if this race
triggers?

	Regards
		Oliver

