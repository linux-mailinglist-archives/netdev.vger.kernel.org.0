Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD3010514B
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 12:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfKULTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 06:19:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:60160 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726165AbfKULTW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 06:19:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 93A30B049;
        Thu, 21 Nov 2019 11:19:19 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 9A4A9E03A4; Thu, 21 Nov 2019 12:19:17 +0100 (CET)
Date:   Thu, 21 Nov 2019 12:19:17 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Cc:     Joe Perches <joe@perches.com>, zhanglin <zhang.lin16@zte.com.cn>,
        davem@davemloft.net, cocci <cocci@systeme.lip6.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        jakub.kicinski@netronome.com, ast@kernel.org,
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
Message-ID: <20191121111917.GE29650@unicorn.suse.cz>
References: <1572076456-12463-1-git-send-email-zhang.lin16@zte.com.cn>
 <c790578751dd69fb1080b355f5847c9ea5fb0e15.camel@perches.com>
 <bc150c6a-6d3e-ff01-e40e-840e8a385bda@metux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc150c6a-6d3e-ff01-e40e-840e8a385bda@metux.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 11:23:34AM +0100, Enrico Weigelt, metux IT consult wrote:
> On 26.10.19 21:40, Joe Perches wrote:
> > On Sat, 2019-10-26 at 15:54 +0800, zhanglin wrote:
> >> memset() the structure ethtool_wolinfo that has padded bytes
> >> but the padded bytes have not been zeroed out.
> > []
> >> diff --git a/net/core/ethtool.c b/net/core/ethtool.c
> > []
> >> @@ -1471,11 +1471,13 @@ static int ethtool_reset(struct net_device *dev, char __user *useraddr)
> >>  
> >>  static int ethtool_get_wol(struct net_device *dev, char __user *useraddr)
> >>  {
> >> -	struct ethtool_wolinfo wol = { .cmd = ETHTOOL_GWOL };
> >> +	struct ethtool_wolinfo wol;
> >>  
> >>  	if (!dev->ethtool_ops->get_wol)
> >>  		return -EOPNOTSUPP;
> >>  
> >> +	memset(&wol, 0, sizeof(struct ethtool_wolinfo));
> >> +	wol.cmd = ETHTOOL_GWOL;
> >>  	dev->ethtool_ops->get_wol(dev, &wol);
> >>  
> >>  	if (copy_to_user(useraddr, &wol, sizeof(wol)))
> > 
> > It seems likely there are more of these.
> > 
> > Is there any way for coccinelle to find them?
> 
> Just curios: is static struct initialization (on stack) something that
> should be avoided ? I've been under the impression that static
> initialization allows thinner code and gives the compiler better chance
> for optimizations.

Not in general. The (potential) problem here is that the structure has
padding and it is as a whole (i.e. including the padding) copied to
userspace. While I'm not aware of a compiler that wouldn't actually
initialize the whole data block including the padding in this case, the
C standard provides no guarantee about that so that to be sure we cannot
leak leftover kernel data to userspace, we need to explicitly initialize
the whole block.

If the structure is not going to be copied to userspace (or otherwise
exposed), using the initializer is fully sufficient and looks cleaner.

Michal Kubecek
