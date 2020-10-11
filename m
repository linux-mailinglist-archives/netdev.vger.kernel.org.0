Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2943528AA1C
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 22:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728989AbgJKUOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 16:14:45 -0400
Received: from smtprelay0017.hostedemail.com ([216.40.44.17]:45456 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726209AbgJKUOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 16:14:44 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id B9873181D3025;
        Sun, 11 Oct 2020 20:14:43 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3874:4250:4321:5007:6691:10004:10400:10848:10967:11026:11232:11658:11914:12296:12297:12438:12740:12760:12895:13069:13095:13163:13229:13311:13357:13439:13972:14096:14097:14659:14721:21080:21433:21627:21795:21990:30003:30012:30034:30051:30054:30070:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:86,LUA_SUMMARY:none
X-HE-Tag: trip41_401056a271f4
X-Filterd-Recvd-Size: 3000
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Sun, 11 Oct 2020 20:14:41 +0000 (UTC)
Message-ID: <a272d209e84fda3c74385bf104a5f209ae7bc6a1.camel@perches.com>
Subject: Re: [PATCH v2] net: usb: rtl8150: don't incorrectly assign random
 MAC addresses
From:   Joe Perches <joe@perches.com>
To:     Petko Manolov <petkan@nucleusys.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        davem@davemloft.net, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-next@vger.kernel.org, sfr@canb.auug.org.au
Date:   Sun, 11 Oct 2020 13:14:40 -0700
In-Reply-To: <20201011193119.GA4061@p310>
References: <20201010064459.6563-1-anant.thazhemadam@gmail.com>
         <20201011173030.141582-1-anant.thazhemadam@gmail.com>
         <20201011105934.5c988cd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <6307397bd43636fea2e7341d24417cbbc3aaf922.camel@perches.com>
         <20201011193119.GA4061@p310>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2020-10-11 at 22:31 +0300, Petko Manolov wrote:
> On 20-10-11 11:33:00, Joe Perches wrote:
> > On Sun, 2020-10-11 at 10:59 -0700, Jakub Kicinski wrote:
> > > On Sun, 11 Oct 2020 23:00:30 +0530 Anant Thazhemadam wrote:
> > > > In set_ethernet_addr(), if get_registers() succeeds, the ethernet address
> > > > that was read must be copied over. Otherwise, a random ethernet address
> > > > must be assigned.
> > > > 
> > > > get_registers() returns 0 if successful, and negative error number
> > > > otherwise. However, in set_ethernet_addr(), this return value is
> > > > incorrectly checked.
> > > > 
> > > > Since this return value will never be equal to sizeof(node_id), a
> > > > random MAC address will always be generated and assigned to the
> > > > device; even in cases when get_registers() is successful.
> > > > 
> > > > Correctly modifying the condition that checks if get_registers() was
> > > > successful or not fixes this problem, and copies the ethernet address
> > > > appropriately.
> > 
> > There are many unchecked uses of set_registers and get_registers
> >  in this file.
> > 
> > If failures are really expected, then it might be better to fix
> > them up too.
> 
> Checking the return value of each get/set_registers() is going to be a PITA and
> not very helpful.  Doing so when setting the MAC address _does_ make sense as in
> that case it is not a hard error.
> 
> In almost all other occasions if usb_control_msg_send/recv() return an error i'd
> rather dump an error message (from within get/set_registers()) and let the user
> decide whether to get rid of this adapter or start debugging it.

Your code, your choices...

Consider using _once or _ratelimited output too.


