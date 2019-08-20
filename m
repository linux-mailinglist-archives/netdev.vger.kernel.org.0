Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C98495AE5
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 11:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729570AbfHTJXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 05:23:06 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:33624 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729291AbfHTJXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 05:23:06 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i00M4-0003Vv-05; Tue, 20 Aug 2019 11:23:04 +0200
Date:   Tue, 20 Aug 2019 11:23:03 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Vakul Garg <vakul.garg@nxp.com>
Cc:     Florian Westphal <fw@strlen.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Help needed - Kernel lockup while running ipsec
Message-ID: <20190820092303.GM2588@breakpoint.cc>
References: <DB7PR04MB4620CD9AFFAFF8678F803DCE8BA80@DB7PR04MB4620.eurprd04.prod.outlook.com>
 <20190819173810.GK2588@breakpoint.cc>
 <DB7PR04MB4620C6E770C97AB14A04A1D98BAB0@DB7PR04MB4620.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB7PR04MB4620C6E770C97AB14A04A1D98BAB0@DB7PR04MB4620.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vakul Garg <vakul.garg@nxp.com> wrote:
> > > With kernel 4.14.122, I am getting a kernel softlockup while running single
> > static ipsec tunnel.
> > > The problem reproduces mostly after running 8-10 hours of ipsec encap
> > test (on my dual core arm board).
> > >
> > > I found that in function xfrm_policy_lookup_bytype(), the policy in variable
> > 'ret' shows refcnt=0 under problem situation.
> > > This creates an infinite loop in  xfrm_policy_lookup_bytype() and hence the
> > lockup.
> > >
> > > Can some body please provide me pointers about 'refcnt'?
> > > Is it legitimate for 'refcnt' to become '0'? Under what condition can it
> > become '0'?
> > 
> > Yes, when policy is destroyed and the last user calls
> > xfrm_pol_put() which will invoke call_rcu to free the structure.
> 
> It seems that policy reference count never gets decremented during packet ipsec encap.
> It is getting incremented for every frame that hits the policy.
> In setkey -DP output, I see refcnt to be wrapping around after '0'.

Thats a bug.  Does this affect 4.14 only or does this happen on current
tree as well?
