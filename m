Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 788CD911E8
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 18:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbfHQQRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 12:17:25 -0400
Received: from smtprelay0152.hostedemail.com ([216.40.44.152]:48177 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725945AbfHQQRZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 12:17:25 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id A07731800BC36;
        Sat, 17 Aug 2019 16:17:23 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:4250:4321:4605:5007:6119:7514:7903:10004:10400:10848:11026:11232:11473:11658:11914:12043:12291:12296:12297:12683:12740:12760:12895:13069:13149:13230:13311:13357:13439:14096:14097:14181:14659:14721:21080:21451:21627:30054:30075:30090:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:28,LUA_SUMMARY:none
X-HE-Tag: oven99_5d7e0eb857a12
X-Filterd-Recvd-Size: 2692
Received: from XPS-9350.home (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf20.hostedemail.com (Postfix) with ESMTPA;
        Sat, 17 Aug 2019 16:17:22 +0000 (UTC)
Message-ID: <a146c1356b4272c481e5cc63666c6e58b8442407.camel@perches.com>
Subject: Re: [PATCH 1/2] PTP: introduce new versions of IOCTLs
From:   Joe Perches <joe@perches.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Cc:     Christopher S Hall <christopher.s.hall@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sat, 17 Aug 2019 09:17:20 -0700
In-Reply-To: <20190817155927.GA1540@localhost>
References: <20190814074712.10684-1-felipe.balbi@linux.intel.com>
         <20190817155927.GA1540@localhost>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2019-08-17 at 08:59 -0700, Richard Cochran wrote:
> On Wed, Aug 14, 2019 at 10:47:11AM +0300, Felipe Balbi wrote:
> > The current version of the IOCTL have a small problem which prevents us
> > from extending the API by making use of reserved fields. In these new
> > IOCTLs, we are now making sure that flags and rsv fields are zero which
> > will allow us to extend the API in the future.
> > 
> > Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
> > ---
> >  drivers/ptp/ptp_chardev.c      | 58 ++++++++++++++++++++++++++++++++--
> >  include/uapi/linux/ptp_clock.h | 12 +++++++
> >  2 files changed, 68 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
[]
> > @@ -123,9 +123,11 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
> >  	struct timespec64 ts;
> >  	int enable, err = 0;
> >  
> > +	memset(&req, 0, sizeof(req));
> 
> Nit: please leave a blank line between memset() and switch/case.

or just initialize the declaration of req with = {}

Is there a case where this initialization is
unnecessary such that it impacts performance
given the use in ptp_ioctl?

caps for instance is memset to zero only in
PTP_CLOCK_GETCAP

req is used in only 3 of the case blocks.

	case PTP_EXTTS_REQUEST:
	case PTP_PEROUT_REQUEST:
	case PTP_ENABLE_PPS:

Maybe it would be better to move the memset(&req...)
into each of the case blocks.

> >  	switch (cmd) {
> >  
> >  	case PTP_CLOCK_GETCAPS:
> > +	case PTP_CLOCK_GETCAPS2:
> >  		memset(&caps, 0, sizeof(caps));
> >  		caps.max_adj = ptp->info->max_adj;
> >  		caps.n_alarm = ptp->info->n_alarm;
> 
> Reviewed-by: Richard Cochran <richardcochran@gmail.com>
> 

