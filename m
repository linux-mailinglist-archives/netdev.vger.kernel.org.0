Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF108E5F6F
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 22:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfJZUSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 16:18:04 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:45844 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726422AbfJZUSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 16:18:04 -0400
X-IronPort-AV: E=Sophos;i="5.68,233,1569276000"; 
   d="scan'208";a="408476953"
Received: from ip-121.net-89-2-166.rev.numericable.fr (HELO hadrien) ([89.2.166.121])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Oct 2019 22:17:59 +0200
Date:   Sat, 26 Oct 2019 22:17:59 +0200 (CEST)
From:   Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To:     Joe Perches <joe@perches.com>
cc:     zhanglin <zhang.lin16@zte.com.cn>, davem@davemloft.net,
        cocci <cocci@systeme.lip6.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        mkubecek@suse.cz, jakub.kicinski@netronome.com, ast@kernel.org,
        jiang.xuexin@zte.com.cn, f.fainelli@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com,
        lirongqing@baidu.com, maxime.chevallier@bootlin.com,
        vivien.didelot@gmail.com, dan.carpenter@oracle.com,
        wang.yi59@zte.com.cn, hawk@kernel.org, arnd@arndb.de,
        jiri@mellanox.com, xue.zhihong@zte.com.cn,
        natechancellor@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linyunsheng@huawei.com,
        pablo@netfilter.org, bpf@vger.kernel.org
Subject: Re: [Cocci] [PATCH] net: Zeroing the structure ethtool_wolinfo in
 ethtool_get_wol()
In-Reply-To: <c790578751dd69fb1080b355f5847c9ea5fb0e15.camel@perches.com>
Message-ID: <alpine.DEB.2.21.1910262207540.5545@hadrien>
References: <1572076456-12463-1-git-send-email-zhang.lin16@zte.com.cn> <c790578751dd69fb1080b355f5847c9ea5fb0e15.camel@perches.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Sat, 26 Oct 2019, Joe Perches wrote:

> On Sat, 2019-10-26 at 15:54 +0800, zhanglin wrote:
> > memset() the structure ethtool_wolinfo that has padded bytes
> > but the padded bytes have not been zeroed out.
> []
> > diff --git a/net/core/ethtool.c b/net/core/ethtool.c
> []
> > @@ -1471,11 +1471,13 @@ static int ethtool_reset(struct net_device *dev, char __user *useraddr)
> >
> >  static int ethtool_get_wol(struct net_device *dev, char __user *useraddr)
> >  {
> > -	struct ethtool_wolinfo wol = { .cmd = ETHTOOL_GWOL };
> > +	struct ethtool_wolinfo wol;
> >
> >  	if (!dev->ethtool_ops->get_wol)
> >  		return -EOPNOTSUPP;
> >
> > +	memset(&wol, 0, sizeof(struct ethtool_wolinfo));
> > +	wol.cmd = ETHTOOL_GWOL;
> >  	dev->ethtool_ops->get_wol(dev, &wol);
> >
> >  	if (copy_to_user(useraddr, &wol, sizeof(wol)))
>
> It seems likely there are more of these.
>
> Is there any way for coccinelle to find them?
>
> There are ~4000 structs in include/uapi and
> there are ~3000 uses of copy_to_user in the tree.
>
> $ git grep -P '\bstruct\s+\w+\s*{' include/uapi/ | cut -f2 -d" "|sort|uniq|wc -l
> 3785
> $ git grep -w copy_to_user|wc -l
> 2854
>
> A trivial grep and manual search using:
>
> $ git grep -B20 -w copy_to_user | grep -A20 -P '\bstruct\s+\w+\s*=\s*{'
>
> shows at least 1 (I didn't look very hard and stopped after finding 1):
>
>    include/uapi/linux/utsname.h:struct oldold_utsname {
>    include/uapi/linux/utsname.h-   char sysname[9];
>    include/uapi/linux/utsname.h-   char nodename[9];
>    include/uapi/linux/utsname.h-   char release[9];
>    include/uapi/linux/utsname.h-   char version[9];
>    include/uapi/linux/utsname.h-   char machine[9];
>    include/uapi/linux/utsname.h-};
>
> and
>
>    kernel/sys.c-	struct oldold_utsname tmp = {};
>    kernel/sys.c-
>    kernel/sys.c-	if (!name)
>    kernel/sys.c-		return -EFAULT;
>    kernel/sys.c-
>    kernel/sys.c-	down_read(&uts_sem);
>    kernel/sys.c-	memcpy(&tmp.sysname, &utsname()->sysname, __OLD_UTS_LEN);
>    kernel/sys.c-	memcpy(&tmp.nodename, &utsname()->nodename, __OLD_UTS_LEN);
>    kernel/sys.c-	memcpy(&tmp.release, &utsname()->release, __OLD_UTS_LEN);
>    kernel/sys.c-	memcpy(&tmp.version, &utsname()->version, __OLD_UTS_LEN);
>    kernel/sys.c-	memcpy(&tmp.machine, &utsname()->machine, __OLD_UTS_LEN);
>    kernel/sys.c-	up_read(&uts_sem);
>    kernel/sys.c:	if (copy_to_user(name, &tmp, sizeof(tmp)))
>
> where there is likely 3 bytes of padding after 45 bytes of data
> in the struct.

I looked into this at one point, but didn't get as far as generating
patches.  I think that the approach was roughly to collect the types of
the fields, and then generate code that would use BUILD_BUG_ON to complain
if the sum of the sizes was not the same as the size of the structure.
The problem was that I wasn't sure what was a real problem, nor what was
the best way to solve it.

julia
