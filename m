Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52F249953D
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 15:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389139AbfHVNhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 09:37:16 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:46740 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725797AbfHVNhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 09:37:15 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i0nH5-0003qU-MC; Thu, 22 Aug 2019 15:37:11 +0200
Date:   Thu, 22 Aug 2019 15:37:11 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Greg KH <greg@kroah.com>
Cc:     Florian Westphal <fw@strlen.de>, stable@vger.kernel.org,
        vakul.garg@nxp.com, netdev@vger.kernel.org,
        Kristian Evensen <kristian.evensen@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH 4.14.y stable] xfrm: policy: remove pcpu policy cache
Message-ID: <20190822133711.GG20113@breakpoint.cc>
References: <DB7PR04MB46208495C3ADCCD58B1131C88BA50@DB7PR04MB4620.eurprd04.prod.outlook.com>
 <20190822112109.13269-1-fw@strlen.de>
 <20190822130941.GA15754@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190822130941.GA15754@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greg KH <greg@kroah.com> wrote:
> On Thu, Aug 22, 2019 at 01:21:09PM +0200, Florian Westphal wrote:
> > commit e4db5b61c572475bbbcf63e3c8a2606bfccf2c9d upstream.
> > 
> > Kristian Evensen says:
> >   In a project I am involved in, we are running ipsec (Strongswan) on
> >   different mt7621-based routers. Each router is configured as an
> >   initiator and has around ~30 tunnels to different responders (running
> >   on misc. devices). Before the flow cache was removed (kernel 4.9), we
> >   got a combined throughput of around 70Mbit/s for all tunnels on one
> >   router. However, we recently switched to kernel 4.14 (4.14.48), and
> >   the total throughput is somewhere around 57Mbit/s (best-case). I.e., a
> >   drop of around 20%. Reverting the flow cache removal restores, as
> >   expected, performance levels to that of kernel 4.9.
> > 
> > When pcpu xdst exists, it has to be validated first before it can be
> > used.
> > 
> > A negative hit thus increases cost vs. no-cache.
> > 
> > As number of tunnels increases, hit rate decreases so this pcpu caching
> > isn't a viable strategy.
> > 
> > Furthermore, the xdst cache also needs to run with BH off, so when
> > removing this the bh disable/enable pairs can be removed too.
> > 
> > Kristian tested a 4.14.y backport of this change and reported
> > increased performance:
> > 
> >   In our tests, the throughput reduction has been reduced from around -20%
> >   to -5%. We also see that the overall throughput is independent of the
> >   number of tunnels, while before the throughput was reduced as the number
> >   of tunnels increased.
> > 
> > Reported-by: Kristian Evensen <kristian.evensen@gmail.com>
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> > ---
> >  Vakul Garg reports traffic going via ipsec tunnels will cause the kernel
> >  to spin in an infinite loop due to xfrm policy reference count
> >  overflowing and becoming 0.
> >  The refcount leak is in the pcpu cache.  Instead of fixing this, just
> >  remove the pcpu cache -- its not present in any other stable release.
> >  Vakul reported that this patch fixes the problem.
> > 
> >  There are no major deviations from the upstream revert; conflicts
> >  were only due to context.
> 
> Now queued up, does 4.9.y also need this?

No, 4.14 was the first kernel with this thing and its already gone in
4.19.
