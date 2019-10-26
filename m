Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAC1AE5DF8
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 17:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfJZPwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 11:52:44 -0400
Received: from smtprelay0139.hostedemail.com ([216.40.44.139]:42968 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726162AbfJZPwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 11:52:44 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 3BE0718002DDF;
        Sat, 26 Oct 2019 15:52:42 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3150:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:5007:6119:6742:6743:10004:10400:10848:11026:11232:11658:11914:12043:12296:12297:12679:12740:12760:12895:13069:13161:13229:13311:13357:13439:14659:14721:21080:21451:21627:30051:30054:30070:30090:30091,0,RBL:47.151.135.224:@perches.com:.lbl8.mailshell.net-62.8.0.100 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:25,LUA_SUMMARY:none
X-HE-Tag: edge41_171fe4bc67f48
X-Filterd-Recvd-Size: 3064
Received: from XPS-9350.home (unknown [47.151.135.224])
        (Authenticated sender: joe@perches.com)
        by omf12.hostedemail.com (Postfix) with ESMTPA;
        Sat, 26 Oct 2019 15:52:38 +0000 (UTC)
Message-ID: <ec9c36dddd1fb3d7cf339bcfba006f15f51b9120.camel@perches.com>
Subject: Re: [PATCH] net: Zeroing the structure ethtool_wolinfo in
 ethtool_get_wol()
From:   Joe Perches <joe@perches.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        zhanglin <zhang.lin16@zte.com.cn>
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, mkubecek@suse.cz, jiri@mellanox.com,
        pablo@netfilter.org, f.fainelli@gmail.com,
        maxime.chevallier@bootlin.com, lirongqing@baidu.com,
        vivien.didelot@gmail.com, linyunsheng@huawei.com,
        natechancellor@gmail.com, arnd@arndb.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        xue.zhihong@zte.com.cn, wang.yi59@zte.com.cn,
        jiang.xuexin@zte.com.cn
Date:   Sat, 26 Oct 2019 08:52:35 -0700
In-Reply-To: <20191026142458.GJ23523@kadam>
References: <1572076456-12463-1-git-send-email-zhang.lin16@zte.com.cn>
         <20191026142458.GJ23523@kadam>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2019-10-26 at 17:24 +0300, Dan Carpenter wrote:
> On Sat, Oct 26, 2019 at 03:54:16PM +0800, zhanglin wrote:
> > memset() the structure ethtool_wolinfo that has padded bytes
> > but the padded bytes have not been zeroed out.
[]
> > diff --git a/net/core/ethtool.c b/net/core/ethtool.c
[]
> > @@ -1471,11 +1471,13 @@ static int ethtool_reset(struct net_device *dev, char __user *useraddr)
> >  
> >  static int ethtool_get_wol(struct net_device *dev, char __user *useraddr)
> >  {
> > -	struct ethtool_wolinf wol = { .cmd = ETHTOOL_GWOL };
> > +	struct ethtool_wolinfo wol;
> >  
> 
> How did you detect that they weren't initialized?  Is this a KASAN
> thing?
> 
> Most of the time GCC will zero out the padding bytes when you have an
> initializer like this, but sometimes it just makes the intialization a
> series of assignments which leaves the holes uninitialized.  I wish I
> knew the rules so that I could check for it in Smatch.  Or even better,
> I wish that there were an option to always zero the holes in this
> situation...

The standard doesn't specify what happens to the padding so
it's not just for gcc, it's compiler dependent.

So anything that's used in a copy_to_user with any possible
padding should either be zalloc'd or memset before assigned.

In this case:

include/uapi/linux/ethtool.h:#define SOPASS_MAX 6

and

include/uapi/linux/ethtool.h:struct ethtool_wolinfo {
include/uapi/linux/ethtool.h-   __u32   cmd;
include/uapi/linux/ethtool.h-   __u32   supported;
include/uapi/linux/ethtool.h-   __u32   wolopts;
include/uapi/linux/ethtool.h-   __u8    sopass[SOPASS_MAX];
include/uapi/linux/ethtool.h-};

so there's likely a couple bytes of trailing padding.


