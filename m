Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 010717E4CD
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 23:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732685AbfHAVeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 17:34:04 -0400
Received: from smtprelay0011.hostedemail.com ([216.40.44.11]:48370 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728248AbfHAVeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 17:34:03 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 726CB837F24A;
        Thu,  1 Aug 2019 21:34:02 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:7514:7576:7903:9010:10004:10400:10483:10848:10967:11026:11232:11658:11914:12296:12297:12555:12740:12760:12895:12986:13069:13095:13311:13357:13439:14181:14659:14721:19901:19997:21080:21433:21450:21451:21627:21740:30054:30085:30090:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:28,LUA_SUMMARY:none
X-HE-Tag: roll36_23253c12f000e
X-Filterd-Recvd-Size: 2229
Received: from XPS-9350.home (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf07.hostedemail.com (Postfix) with ESMTPA;
        Thu,  1 Aug 2019 21:34:01 +0000 (UTC)
Message-ID: <00ba3c40274538362c9780795340a6a7f8ac28c2.camel@perches.com>
Subject: Re: [PATCH net] ibmveth: use net_err_ratelimited when
 set_multicast_list
From:   Joe Perches <joe@perches.com>
To:     David Miller <davem@davemloft.net>, liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, tlfalcon@linux.ibm.com
Date:   Thu, 01 Aug 2019 14:34:00 -0700
In-Reply-To: <20190801.125114.1466241781699884892.davem@davemloft.net>
References: <20190801090347.8258-1-liuhangbin@gmail.com>
         <20190801.125114.1466241781699884892.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-08-01 at 12:51 -0400, David Miller wrote:
> From: Hangbin Liu <liuhangbin@gmail.com>
> Date: Thu,  1 Aug 2019 17:03:47 +0800
> 
> > When setting lots of multicast list on ibmveth, e.g. add 3000 membership on a
> > multicast group, the following error message flushes our log file
> > 
> > 8507    [  901.478251] ibmveth 30000003 env3: h_multicast_ctrl rc=4 when adding an entry to the filter table
> > ...
> > 1718386 [ 5636.808658] ibmveth 30000003 env3: h_multicast_ctrl rc=4 when adding an entry to the filter table
> > 
> > We got 1.5 million lines of messages in 1.3h. Let's replace netdev_err() by
> > net_err_ratelimited() to avoid this issue. I don't use netdev_err_once() in
> > case h_multicast_ctrl() return different lpar_rc types.
> > 
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> 
> Let's work on fixing what causes this problem, or adding a retry
> mechanism, rather than making the message less painful.
> 
> What is worse is that these failures are not in any way communicated
> back up the callchain to show that the operation didn't complete
> sucessfully.
> 
> This is a real mess in behavior and error handling, don't make it
> worse please.

That looks as though it could be quite a chore.

$ git grep -P '\bndo_set_rx_mode\s*=' | wc -l
326


