Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5F0246543
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 13:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgHQLZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 07:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbgHQLZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 07:25:48 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD868C061389
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 04:25:47 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1k7dGs-0000cH-Ab; Mon, 17 Aug 2020 13:25:46 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1k7dGr-0005NK-Q0; Mon, 17 Aug 2020 13:25:45 +0200
Date:   Mon, 17 Aug 2020 13:25:45 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] iproute2: ip maddress: Check multiaddr length
Message-ID: <20200817112545.GF13023@pengutronix.de>
References: <20200814084626.22953-1-s.hauer@pengutronix.de>
 <20200814082756.18888961@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200814082756.18888961@hermes.lan>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:54:41 up 179 days, 18:25, 162 users,  load average: 0.06, 0.18,
 0.25
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 14, 2020 at 08:27:56AM -0700, Stephen Hemminger wrote:
> On Fri, 14 Aug 2020 10:46:26 +0200
> Sascha Hauer <s.hauer@pengutronix.de> wrote:
> 
> > ip maddress add|del takes a MAC address as argument, so insist on
> > getting a length of ETH_ALEN bytes. This makes sure the passed argument
> > is actually a MAC address and especially not an IPv4 address which
> > was previously accepted and silently taken as a MAC address.
> > 
> > While at it, do not print *argv in the error path as this has been
> > modified by ll_addr_a2n() and doesn't contain the full string anymore,
> > which can lead to misleading error messages.
> > 
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > ---
> >  ip/ipmaddr.c | 11 +++++++----
> >  1 file changed, 7 insertions(+), 4 deletions(-)
> > 
> > diff --git a/ip/ipmaddr.c b/ip/ipmaddr.c
> > index 3400e055..9979ed58 100644
> > --- a/ip/ipmaddr.c
> > +++ b/ip/ipmaddr.c
> > @@ -291,7 +291,7 @@ static int multiaddr_modify(int cmd, int argc, char **argv)
> >  {
> >  	struct ifreq ifr = {};
> >  	int family;
> > -	int fd;
> > +	int fd, len;
> >  
> >  	if (cmd == RTM_NEWADDR)
> >  		cmd = SIOCADDMULTI;
> > @@ -313,9 +313,12 @@ static int multiaddr_modify(int cmd, int argc, char **argv)
> >  				usage();
> >  			if (ifr.ifr_hwaddr.sa_data[0])
> >  				duparg("address", *argv);
> > -			if (ll_addr_a2n(ifr.ifr_hwaddr.sa_data,
> > -					14, *argv) < 0) {
> > -				fprintf(stderr, "Error: \"%s\" is not a legal ll address.\n", *argv);
> > +			len = ll_addr_a2n(ifr.ifr_hwaddr.sa_data, 14, *argv);
> 
> While you are at it, get rid of the hard code 14 here and use sizeof(ifr.ifr_hwaddr.sa_data)?

Ok. I just sent out a v2.

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
