Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE0195B18
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 11:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbfHTJiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 05:38:03 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:33672 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728414AbfHTJiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 05:38:02 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i00aW-0003Z8-K3; Tue, 20 Aug 2019 11:38:00 +0200
Date:   Tue, 20 Aug 2019 11:38:00 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Vakul Garg <vakul.garg@nxp.com>
Cc:     Florian Westphal <fw@strlen.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Help needed - Kernel lockup while running ipsec
Message-ID: <20190820093800.GN2588@breakpoint.cc>
References: <DB7PR04MB4620CD9AFFAFF8678F803DCE8BA80@DB7PR04MB4620.eurprd04.prod.outlook.com>
 <20190819173810.GK2588@breakpoint.cc>
 <DB7PR04MB4620C6E770C97AB14A04A1D98BAB0@DB7PR04MB4620.eurprd04.prod.outlook.com>
 <20190820092303.GM2588@breakpoint.cc>
 <DB7PR04MB4620487074796FBC015AFD098BAB0@DB7PR04MB4620.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB7PR04MB4620487074796FBC015AFD098BAB0@DB7PR04MB4620.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vakul Garg <vakul.garg@nxp.com> wrote:
> 
> 
> > -----Original Message-----
> > From: Florian Westphal <fw@strlen.de>
> > Sent: Tuesday, August 20, 2019 2:53 PM
> > To: Vakul Garg <vakul.garg@nxp.com>
> > Cc: Florian Westphal <fw@strlen.de>; netdev@vger.kernel.org
> > Subject: Re: Help needed - Kernel lockup while running ipsec
> > 
> > Vakul Garg <vakul.garg@nxp.com> wrote:
> > > > > With kernel 4.14.122, I am getting a kernel softlockup while
> > > > > running single
> > > > static ipsec tunnel.
> > > > > The problem reproduces mostly after running 8-10 hours of ipsec
> > > > > encap
> > > > test (on my dual core arm board).
> > > > >
> > > > > I found that in function xfrm_policy_lookup_bytype(), the policy
> > > > > in variable
> > > > 'ret' shows refcnt=0 under problem situation.
> > > > > This creates an infinite loop in  xfrm_policy_lookup_bytype() and
> > > > > hence the
> > > > lockup.
> > > > >
> > > > > Can some body please provide me pointers about 'refcnt'?
> > > > > Is it legitimate for 'refcnt' to become '0'? Under what condition
> > > > > can it
> > > > become '0'?
> > > >
> > > > Yes, when policy is destroyed and the last user calls
> > > > xfrm_pol_put() which will invoke call_rcu to free the structure.
> > >
> > > It seems that policy reference count never gets decremented during packet
> > ipsec encap.
> > > It is getting incremented for every frame that hits the policy.
> > > In setkey -DP output, I see refcnt to be wrapping around after '0'.
> > 
> > Thats a bug.  Does this affect 4.14 only or does this happen on current tree
> > as well?
>  
> I am yet to try it on 4.19.
> Can you help me with the right fix? Which part of code should it get decremented?
> I am not conversant with xfrm code.

Normally policy reference counts get decremented when the skb is free'd, via dst
destruction (xfrm_dst_destroy()).

Do you see a dst leak as well?

