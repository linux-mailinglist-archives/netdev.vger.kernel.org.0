Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA393BCCB
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 21:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389072AbfFJTZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 15:25:13 -0400
Received: from smtprelay0006.hostedemail.com ([216.40.44.6]:56717 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388793AbfFJTZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 15:25:12 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 2E93918029127;
        Mon, 10 Jun 2019 19:25:11 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:599:800:960:966:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2196:2199:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3872:4321:4385:4605:5007:7514:7576:7903:10004:10400:10848:10967:11232:11658:11914:12295:12296:12555:12663:12740:12760:12895:12986:13069:13311:13357:13439:14096:14097:14181:14659:14721:21080:21324:21451:21627:30054:30090:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:25,LUA_SUMMARY:none
X-HE-Tag: party74_66197af95055a
X-Filterd-Recvd-Size: 2276
Received: from XPS-9350.home (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf09.hostedemail.com (Postfix) with ESMTPA;
        Mon, 10 Jun 2019 19:25:00 +0000 (UTC)
Message-ID: <13f306216ca9bcad563da4d86c55549645e061af.camel@perches.com>
Subject: Re: [PATCH] ipv6: exthdrs: fix warning comparison to bool
From:   Joe Perches <joe@perches.com>
To:     David Miller <davem@davemloft.net>, hariprasad.kelam@gmail.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 10 Jun 2019 12:24:58 -0700
In-Reply-To: <20190609.195420.1742255944804133266.davem@davemloft.net>
References: <20190608083532.GA7288@hari-Inspiron-1545>
         <20190609.195420.1742255944804133266.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2019-06-09 at 19:54 -0700, David Miller wrote:
> From: Hariprasad Kelam <hariprasad.kelam@gmail.com>
> Date: Sat, 8 Jun 2019 14:05:33 +0530
> 
> > Fix below warning reported by coccicheck
> > 
> > net/ipv6/exthdrs.c:180:9-29: WARNING: Comparison to bool
> > 
> > Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
>  ...
> > diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
> > index ab5add0..e137325 100644
> > --- a/net/ipv6/exthdrs.c
> > +++ b/net/ipv6/exthdrs.c
> > @@ -177,7 +177,7 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
> >                                       /* type specific length/alignment
> >                                          checks will be performed in the
> >                                          func(). */
> > -                                     if (curr->func(skb, off) == false)
> > +                                     if (!curr->func(skb, off))
> 
> curr->func() returns type 'bool', whats wrong with comparing against the
> same type?
> 
> I'm not applying stuff like this, sorry.

Looking at the function, it seems odd to have
some direct uses of "return false" and others
of "goto bad" where bad: does kfree_skb.

If all of the direct uses of return false are
correct, it could be useful to document why.


