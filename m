Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2B0AE5F41
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 21:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfJZTkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 15:40:33 -0400
Received: from smtprelay0186.hostedemail.com ([216.40.44.186]:42911 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726342AbfJZTkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 15:40:33 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 3C59D180357D1;
        Sat, 26 Oct 2019 19:40:31 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3150:3353:3622:3653:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:6119:6742:6743:7903:10004:10044:10400:10848:11026:11473:11658:11914:12043:12048:12049:12296:12297:12740:12760:12895:13161:13229:13439:14096:14097:14181:14659:14721:21080:21324:21451:21627:21939:30029:30051:30054:30091,0,RBL:47.151.135.224:@perches.com:.lbl8.mailshell.net-62.8.0.100 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:25,LUA_SUMMARY:none
X-HE-Tag: stone20_785fe5ad57825
X-Filterd-Recvd-Size: 3871
Received: from XPS-9350.home (unknown [47.151.135.224])
        (Authenticated sender: joe@perches.com)
        by omf12.hostedemail.com (Postfix) with ESMTPA;
        Sat, 26 Oct 2019 19:40:27 +0000 (UTC)
Message-ID: <c790578751dd69fb1080b355f5847c9ea5fb0e15.camel@perches.com>
Subject: Re: [PATCH] net: Zeroing the structure ethtool_wolinfo in
 ethtool_get_wol()
From:   Joe Perches <joe@perches.com>
To:     zhanglin <zhang.lin16@zte.com.cn>, davem@davemloft.net,
        cocci <cocci@systeme.lip6.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ast@kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com,
        hawk@kernel.org, john.fastabend@gmail.com, mkubecek@suse.cz,
        jiri@mellanox.com, pablo@netfilter.org, f.fainelli@gmail.com,
        maxime.chevallier@bootlin.com, lirongqing@baidu.com,
        vivien.didelot@gmail.com, linyunsheng@huawei.com,
        natechancellor@gmail.com, arnd@arndb.de, dan.carpenter@oracle.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, xue.zhihong@zte.com.cn, wang.yi59@zte.com.cn,
        jiang.xuexin@zte.com.cn
Date:   Sat, 26 Oct 2019 12:40:23 -0700
In-Reply-To: <1572076456-12463-1-git-send-email-zhang.lin16@zte.com.cn>
References: <1572076456-12463-1-git-send-email-zhang.lin16@zte.com.cn>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2019-10-26 at 15:54 +0800, zhanglin wrote:
> memset() the structure ethtool_wolinfo that has padded bytes
> but the padded bytes have not been zeroed out.
[]
> diff --git a/net/core/ethtool.c b/net/core/ethtool.c
[]
> @@ -1471,11 +1471,13 @@ static int ethtool_reset(struct net_device *dev, char __user *useraddr)
>  
>  static int ethtool_get_wol(struct net_device *dev, char __user *useraddr)
>  {
> -	struct ethtool_wolinfo wol = { .cmd = ETHTOOL_GWOL };
> +	struct ethtool_wolinfo wol;
>  
>  	if (!dev->ethtool_ops->get_wol)
>  		return -EOPNOTSUPP;
>  
> +	memset(&wol, 0, sizeof(struct ethtool_wolinfo));
> +	wol.cmd = ETHTOOL_GWOL;
>  	dev->ethtool_ops->get_wol(dev, &wol);
>  
>  	if (copy_to_user(useraddr, &wol, sizeof(wol)))

It seems likely there are more of these.

Is there any way for coccinelle to find them?

There are ~4000 structs in include/uapi and
there are ~3000 uses of copy_to_user in the tree.

$ git grep -P '\bstruct\s+\w+\s*{' include/uapi/ | cut -f2 -d" "|sort|uniq|wc -l
3785
$ git grep -w copy_to_user|wc -l
2854

A trivial grep and manual search using:

$ git grep -B20 -w copy_to_user | grep -A20 -P '\bstruct\s+\w+\s*=\s*{'

shows at least 1 (I didn't look very hard and stopped after finding 1):

   include/uapi/linux/utsname.h:struct oldold_utsname {
   include/uapi/linux/utsname.h-   char sysname[9];
   include/uapi/linux/utsname.h-   char nodename[9];
   include/uapi/linux/utsname.h-   char release[9];
   include/uapi/linux/utsname.h-   char version[9];
   include/uapi/linux/utsname.h-   char machine[9];
   include/uapi/linux/utsname.h-};

and 

   kernel/sys.c-	struct oldold_utsname tmp = {};
   kernel/sys.c-
   kernel/sys.c-	if (!name)
   kernel/sys.c-		return -EFAULT;
   kernel/sys.c-
   kernel/sys.c-	down_read(&uts_sem);
   kernel/sys.c-	memcpy(&tmp.sysname, &utsname()->sysname, __OLD_UTS_LEN);
   kernel/sys.c-	memcpy(&tmp.nodename, &utsname()->nodename, __OLD_UTS_LEN);
   kernel/sys.c-	memcpy(&tmp.release, &utsname()->release, __OLD_UTS_LEN);
   kernel/sys.c-	memcpy(&tmp.version, &utsname()->version, __OLD_UTS_LEN);
   kernel/sys.c-	memcpy(&tmp.machine, &utsname()->machine, __OLD_UTS_LEN);
   kernel/sys.c-	up_read(&uts_sem);
   kernel/sys.c:	if (copy_to_user(name, &tmp, sizeof(tmp)))

where there is likely 3 bytes of padding after 45 bytes of data
in the struct.


