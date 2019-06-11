Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE633D0CD
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 17:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404786AbfFKP3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 11:29:52 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:42586 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387864AbfFKP3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 11:29:52 -0400
X-Greylist: delayed 1607 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Jun 2019 11:29:51 EDT
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1haiIg-00066R-Rk; Tue, 11 Jun 2019 17:03:02 +0200
Date:   Tue, 11 Jun 2019 17:03:02 +0200
From:   Florian Westphal <fw@strlen.de>
To:     John Hurley <john.hurley@netronome.com>
Cc:     Florian Westphal <fw@strlen.de>,
        David Miller <davem@davemloft.net>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        oss-drivers@netronome.com
Subject: Re: [RFC net-next v2 1/1] net: sched: protect against loops in TC
 filter hooks
Message-ID: <20190611150302.smeuvloq7vvtcccp@breakpoint.cc>
References: <1559825374-32117-1-git-send-email-john.hurley@netronome.com>
 <20190606125818.bvo5im2wqj365tai@breakpoint.cc>
 <20190606.111954.2036000288766363267.davem@davemloft.net>
 <20190606195255.4uelltuxptwobhiv@breakpoint.cc>
 <CAK+XE=m_Z=A6JXYvVzBBk+SPw5xnc_B3UsLfG81G5-kjrUNnzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK+XE=m_Z=A6JXYvVzBBk+SPw5xnc_B3UsLfG81G5-kjrUNnzA@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Hurley <john.hurley@netronome.com> wrote:
> On Thu, Jun 6, 2019 at 8:52 PM Florian Westphal <fw@strlen.de> wrote:
> >
> > David Miller <davem@davemloft.net> wrote:
> > > From: Florian Westphal <fw@strlen.de>
> > > Date: Thu, 6 Jun 2019 14:58:18 +0200
> > >
> > > >> @@ -827,6 +828,7 @@ struct sk_buff {
> > > >>    __u8                    tc_at_ingress:1;
> > > >>    __u8                    tc_redirected:1;
> > > >>    __u8                    tc_from_ingress:1;
> > > >> +  __u8                    tc_hop_count:2;
> > > >
> > > > I dislike this, why can't we just use a pcpu counter?
> > >
> > > I understand that it's because the only precise context is per-SKB not
> > > per-cpu doing packet processing.  This has been discussed before.
> >
> > I don't think its worth it, and it won't work with physical-world
> > loops (e.g. a bridge setup with no spanning tree and a closed loop).
> >
> > Also I fear that if we start to do this for tc, we will also have to
> > followup later with more l2 hopcounts for other users, e.g. veth,
> > bridge, ovs, and so on.
> 
> Hi David/Florian,
> Moving forward with this, should we treat the looping and recursion as
> 2 separate issues and at least prevent the potential stack overflow
> panics caused by the recursion?
> The pcpu counter should protect against this.

As outlined above, I think they are different issues.

> Are there context specific issues that we may miss by doing this?

I can't think of any.

> If not I will respin with the pcpu counter in act_mirred.

Sounds good to me, thanks.
