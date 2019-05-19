Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C08FE228BC
	for <lists+netdev@lfdr.de>; Sun, 19 May 2019 22:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730123AbfESU2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 May 2019 16:28:04 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:53956 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730116AbfESU2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 May 2019 16:28:03 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hSSPS-0004g9-41; Sun, 19 May 2019 22:27:54 +0200
Date:   Sun, 19 May 2019 22:27:53 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Thomas Haller <thaller@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 4.9 41/51] fib_rules: return 0 directly if an exactly
 same rule exists when NLM_F_EXCL not supplied
Message-ID: <20190519202753.p5hsfe2uqmgsfbcq@breakpoint.cc>
References: <20190515090616.669619870@linuxfoundation.org>
 <20190515090628.066392616@linuxfoundation.org>
 <20190519154348.GA113991@archlinux-epyc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190519154348.GA113991@archlinux-epyc>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nathan Chancellor <natechancellor@gmail.com> wrote:
> On Wed, May 15, 2019 at 12:56:16PM +0200, Greg Kroah-Hartman wrote:
> > From: Hangbin Liu <liuhangbin@gmail.com>
> > 
> > [ Upstream commit e9919a24d3022f72bcadc407e73a6ef17093a849 ]

[..]

> > Fixes: 153380ec4b9 ("fib_rules: Added NLM_F_EXCL support to fib_nl_newrule")
> > Reported-by: Thomas Haller <thaller@redhat.com>
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  net/core/fib_rules.c |    6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > --- a/net/core/fib_rules.c
> > +++ b/net/core/fib_rules.c
> > @@ -429,9 +429,9 @@ int fib_nl_newrule(struct sk_buff *skb,
> >  	if (rule->l3mdev && rule->table)
> >  		goto errout_free;
> >  
> > -	if ((nlh->nlmsg_flags & NLM_F_EXCL) &&
> > -	    rule_exists(ops, frh, tb, rule)) {
> > -		err = -EEXIST;
> > +	if (rule_exists(ops, frh, tb, rule)) {
> > +		if (nlh->nlmsg_flags & NLM_F_EXCL)
> > +			err = -EEXIST;
> This commit is causing issues on Android devices when Wi-Fi and mobile
> data are both enabled. The device will do a soft reboot consistently.

Not surprising, the patch can't be applied to 4.9 as-is.

In 4.9, code looks like this:

 err = -EINVAL;
 /* irrelevant */
 if (rule_exists(ops, frh, tb, rule)) {
  if (nlh->nlmsg_flags & NLM_F_EXCL)
    err = -EEXIST;
    goto errout_free;
 }

So, if rule_exists() is true, we return -EINVAL to caller
instead of 0, unlike upstream.

I don't think this commit is stable material.
