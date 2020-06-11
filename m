Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3367F1F61D2
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 08:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgFKGmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 02:42:51 -0400
Received: from smtprelay0024.hostedemail.com ([216.40.44.24]:53622 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726147AbgFKGmv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 02:42:51 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 3ECF0182CED34;
        Thu, 11 Jun 2020 06:42:49 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3872:3874:4250:4321:5007:6119:6691:7903:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12297:12740:12760:12895:13161:13229:13439:14659:14721:21080:21433:21611:21627:21740:21939:21990:30012:30045:30054:30070:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: milk04_120e82326dd1
X-Filterd-Recvd-Size: 3673
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf14.hostedemail.com (Postfix) with ESMTPA;
        Thu, 11 Jun 2020 06:42:47 +0000 (UTC)
Message-ID: <bc92ee5948c3e71b8f1de1930336bbe162d00b34.camel@perches.com>
Subject: Re: [PATCH v3 6/7] venus: Make debug infrastructure more flexible
From:   Joe Perches <joe@perches.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Jason Baron <jbaron@akamai.com>
Date:   Wed, 10 Jun 2020 23:42:43 -0700
In-Reply-To: <20200611062648.GA2529349@kroah.com>
References: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
         <20200609104604.1594-7-stanimir.varbanov@linaro.org>
         <20200609111414.GC780233@kroah.com>
         <dc85bf9e-e3a6-15a1-afaa-0add3e878573@linaro.org>
         <20200610133717.GB1906670@kroah.com>
         <31e1aa72b41f9ff19094476033511442bb6ccda0.camel@perches.com>
         <2fab7f999a6b5e5354b23d06aea31c5018b9ce18.camel@perches.com>
         <20200611062648.GA2529349@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-06-11 at 08:26 +0200, Greg Kroah-Hartman wrote:
> On Wed, Jun 10, 2020 at 01:23:56PM -0700, Joe Perches wrote:
> > On Wed, 2020-06-10 at 12:49 -0700, Joe Perches wrote:
> > > On Wed, 2020-06-10 at 15:37 +0200, Greg Kroah-Hartman wrote:
> > > > Please work with the infrastructure we have, we have spent a lot of time
> > > > and effort to make it uniform to make it easier for users and
> > > > developers.
> > > 
> > > Not quite.
> > > 
> > > This lack of debug grouping by type has been a
> > > _long_ standing issue with drivers.
> > > 
> > > > Don't regress and try to make driver-specific ways of doing
> > > > things, that way lies madness...
> > > 
> > > It's not driver specific, it allows driver developers to
> > > better isolate various debug states instead of keeping
> > > lists of specific debug messages and enabling them
> > > individually.
> > 
> > For instance, look at the homebrew content in
> > drivers/gpu/drm/drm_print.c that does _not_ use
> > dynamic_debug.
> > 
> > MODULE_PARM_DESC(debug, "Enable debug output, where each bit enables a debug category.\n"
> > "\t\tBit 0 (0x01)  will enable CORE messages (drm core code)\n"
> > "\t\tBit 1 (0x02)  will enable DRIVER messages (drm controller code)\n"
> > "\t\tBit 2 (0x04)  will enable KMS messages (modesetting code)\n"
> > "\t\tBit 3 (0x08)  will enable PRIME messages (prime code)\n"
> > "\t\tBit 4 (0x10)  will enable ATOMIC messages (atomic code)\n"
> > "\t\tBit 5 (0x20)  will enable VBL messages (vblank code)\n"
> > "\t\tBit 7 (0x80)  will enable LEASE messages (leasing code)\n"
> > "\t\tBit 8 (0x100) will enable DP messages (displayport code)");
> > module_param_named(debug, __drm_debug, int, 0600);
> > 
> > void drm_dev_dbg(const struct device *dev, enum drm_debug_category category,
> > 		 const char *format, ...)
> > {
> > 	struct va_format vaf;
> > 	va_list args;
> > 
> > 	if (!drm_debug_enabled(category))
> > 		return;
> 
> Ok, and will this proposal be able to handle stuff like this?

Yes, that's the entire point.

If it doesn't have the capability to handle stuff like this,
then no, it wouldn't be a good or useful change.

That includes the ability to work without dynamic debug and
perhaps still use a MODULE_PARM_DESC. 

