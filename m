Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E80C47E179
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 19:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387908AbfHARyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 13:54:06 -0400
Received: from smtprelay0092.hostedemail.com ([216.40.44.92]:41420 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727508AbfHARyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 13:54:05 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id B534C1802912A;
        Thu,  1 Aug 2019 17:54:04 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:599:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:2110:2393:2553:2559:2562:2828:2915:3138:3139:3140:3141:3142:3355:3622:3865:3867:3868:3871:3873:3874:4321:4605:5007:10004:10400:10848:11026:11232:11233:11473:11658:11914:12043:12291:12297:12438:12555:12683:12740:12760:12895:12986:13439:14093:14097:14659:14721:21080:21427:21451:21627:30012:30054:30056:30069:30070:30075:30090:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:27,LUA_SUMMARY:none
X-HE-Tag: cake25_65f8dfe37058
X-Filterd-Recvd-Size: 4514
Received: from XPS-9350.home (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf09.hostedemail.com (Postfix) with ESMTPA;
        Thu,  1 Aug 2019 17:54:03 +0000 (UTC)
Message-ID: <26b07ca8aeb4b7996a86a55eb68390739d4f482b.camel@perches.com>
Subject: Re: [PATCH net] ibmveth: use net_err_ratelimited when
 set_multicast_list
From:   Joe Perches <joe@perches.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Thomas Falcon <tlfalcon@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>
Date:   Thu, 01 Aug 2019 10:54:02 -0700
In-Reply-To: <20190801141006.GS18865@dhcp-12-139.nay.redhat.com>
References: <20190801090347.8258-1-liuhangbin@gmail.com>
         <209f7fe62e2a79cd8c02b104b8e3babdd16bff30.camel@perches.com>
         <20190801141006.GS18865@dhcp-12-139.nay.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-08-01 at 22:10 +0800, Hangbin Liu wrote:
> On Thu, Aug 01, 2019 at 03:28:43AM -0700, Joe Perches wrote:
> > Perhaps add the netdev_<level>_ratelimited variants and use that instead
> > 
> > Somthing like:
> 
> Yes, that looks better. Do you mind if I take your code and add your
> Signed-off-by info?

Well, if you test and verify all the paths,
(I did not and just wrote that without testing),
you could add something like "Suggested-by:".

cheers, Joe

> Thanks
> Hangbin
> > ---
> >  include/linux/netdevice.h | 54 +++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 54 insertions(+)
> > 
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index 88292953aa6f..37116019e14f 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -4737,6 +4737,60 @@ do {								\
> >  #define netdev_info_once(dev, fmt, ...) \
> >  	netdev_level_once(KERN_INFO, dev, fmt, ##__VA_ARGS__)
> >  
> > +#define netdev_level_ratelimited(netdev_level, dev, fmt, ...)		\
> > +do {									\
> > +	static DEFINE_RATELIMIT_STATE(_rs,				\
> > +				      DEFAULT_RATELIMIT_INTERVAL,	\
> > +				      DEFAULT_RATELIMIT_BURST);		\
> > +	if (__ratelimit(&_rs))						\
> > +		netdev_level(dev, fmt, ##__VA_ARGS__);			\
> > +} while (0)
> > +
> > +#define netdev_emerg_ratelimited(dev, fmt, ...)				\
> > +	netdev_level_ratelimited(netdev_emerg, dev, fmt, ##__VA_ARGS__)
> > +#define netdev_alert_ratelimited(dev, fmt, ...)				\
> > +	netdev_level_ratelimited(netdev_alert, dev, fmt, ##__VA_ARGS__)
> > +#define netdev_crit_ratelimited(dev, fmt, ...)				\
> > +	netdev_level_ratelimited(netdev_crit, dev, fmt, ##__VA_ARGS__)
> > +#define netdev_err_ratelimited(dev, fmt, ...)				\
> > +	netdev_level_ratelimited(netdev_err, dev, fmt, ##__VA_ARGS__)
> > +#define netdev_warn_ratelimited(dev, fmt, ...)				\
> > +	netdev_level_ratelimited(netdev_warn, dev, fmt, ##__VA_ARGS__)
> > +#define netdev_notice_ratelimited(dev, fmt, ...)			\
> > +	netdev_level_ratelimited(netdev_notice, dev, fmt, ##__VA_ARGS__)
> > +#define netdev_info_ratelimited(dev, fmt, ...)				\
> > +	netdev_level_ratelimited(netdev_info, dev, fmt, ##__VA_ARGS__)
> > +
> > +#if defined(CONFIG_DYNAMIC_DEBUG)
> > +/* descriptor check is first to prevent flooding with "callbacks suppressed" */
> > +#define netdev_dbg_ratelimited(dev, fmt, ...)				\
> > +do {									\
> > +	static DEFINE_RATELIMIT_STATE(_rs,				\
> > +				      DEFAULT_RATELIMIT_INTERVAL,	\
> > +				      DEFAULT_RATELIMIT_BURST);		\
> > +	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);			\
> > +	if (DYNAMIC_DEBUG_BRANCH(descriptor) &&				\
> > +	    __ratelimit(&_rs))						\
> > +		__dynamic_netdev_dbg(&descriptor, dev, fmt,		\
> > +				     ##__VA_ARGS__);			\
> > +} while (0)
> > +#elif defined(DEBUG)
> > +#define netdev_dbg_ratelimited(dev, fmt, ...)				\
> > +do {									\
> > +	static DEFINE_RATELIMIT_STATE(_rs,				\
> > +				      DEFAULT_RATELIMIT_INTERVAL,	\
> > +				      DEFAULT_RATELIMIT_BURST);		\
> > +	if (__ratelimit(&_rs))						\
> > +		netdev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__);	\
> > +} while (0)
> > +#else
> > +#define netdev_dbg_ratelimited(dev, fmt, ...)				\
> > +do {									\
> > +	if (0)								\
> > +		netdev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__);	\
> > +} while (0)
> > +#endif
> > +
> >  #define MODULE_ALIAS_NETDEV(device) \
> >  	MODULE_ALIAS("netdev-" device)
> >  
> > 
> > 

