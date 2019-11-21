Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED3BA1051E6
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 12:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfKUL6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 06:58:23 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:21309
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726197AbfKUL6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 06:58:22 -0500
X-IronPort-AV: E=Sophos;i="5.69,224,1571695200"; 
   d="scan'208";a="327507864"
Received: from portablejulia.rsr.lip6.fr ([132.227.76.63])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Nov 2019 12:58:18 +0100
Date:   Thu, 21 Nov 2019 12:58:18 +0100 (CET)
From:   Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: julia@hadrien
To:     Michal Kubecek <mkubecek@suse.cz>
cc:     "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        jakub.kicinski@netronome.com, ast@kernel.org,
        natechancellor@gmail.com, jiang.xuexin@zte.com.cn,
        cocci <cocci@systeme.lip6.fr>, f.fainelli@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com,
        lirongqing@baidu.com, maxime.chevallier@bootlin.com,
        vivien.didelot@gmail.com, dan.carpenter@oracle.com,
        wang.yi59@zte.com.cn, hawk@kernel.org, arnd@arndb.de,
        jiri@mellanox.com, xue.zhihong@zte.com.cn,
        zhanglin <zhang.lin16@zte.com.cn>,
        Thomas Gleixner <tglx@linutronix.de>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linyunsheng@huawei.com, pablo@netfilter.org,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        davem@davemloft.net
Subject: Re: [Cocci] [PATCH] net: Zeroing the structure ethtool_wolinfo in
 ethtool_get_wol()
In-Reply-To: <20191121111917.GE29650@unicorn.suse.cz>
Message-ID: <alpine.DEB.2.21.1911211245180.12163@hadrien>
References: <1572076456-12463-1-git-send-email-zhang.lin16@zte.com.cn> <c790578751dd69fb1080b355f5847c9ea5fb0e15.camel@perches.com> <bc150c6a-6d3e-ff01-e40e-840e8a385bda@metux.net> <20191121111917.GE29650@unicorn.suse.cz>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Thu, 21 Nov 2019, Michal Kubecek wrote:

> On Thu, Nov 21, 2019 at 11:23:34AM +0100, Enrico Weigelt, metux IT consult wrote:
> > On 26.10.19 21:40, Joe Perches wrote:
> > > On Sat, 2019-10-26 at 15:54 +0800, zhanglin wrote:
> > >> memset() the structure ethtool_wolinfo that has padded bytes
> > >> but the padded bytes have not been zeroed out.
> > > []
> > >> diff --git a/net/core/ethtool.c b/net/core/ethtool.c
> > > []
> > >> @@ -1471,11 +1471,13 @@ static int ethtool_reset(struct net_device *dev, char __user *useraddr)
> > >>
> > >>  static int ethtool_get_wol(struct net_device *dev, char __user *useraddr)
> > >>  {
> > >> -	struct ethtool_wolinfo wol = { .cmd = ETHTOOL_GWOL };
> > >> +	struct ethtool_wolinfo wol;
> > >>
> > >>  	if (!dev->ethtool_ops->get_wol)
> > >>  		return -EOPNOTSUPP;
> > >>
> > >> +	memset(&wol, 0, sizeof(struct ethtool_wolinfo));
> > >> +	wol.cmd = ETHTOOL_GWOL;
> > >>  	dev->ethtool_ops->get_wol(dev, &wol);
> > >>
> > >>  	if (copy_to_user(useraddr, &wol, sizeof(wol)))
> > >
> > > It seems likely there are more of these.
> > >
> > > Is there any way for coccinelle to find them?
> >
> > Just curios: is static struct initialization (on stack) something that
> > should be avoided ? I've been under the impression that static
> > initialization allows thinner code and gives the compiler better chance
> > for optimizations.
>
> Not in general. The (potential) problem here is that the structure has
> padding and it is as a whole (i.e. including the padding) copied to
> userspace. While I'm not aware of a compiler that wouldn't actually
> initialize the whole data block including the padding in this case, the
> C standard provides no guarantee about that so that to be sure we cannot
> leak leftover kernel data to userspace, we need to explicitly initialize
> the whole block.

I'm not sure that it is likely that the compiler will do anything other
than ensure that all the fields are initialized.  Among the files that I
could compile, the only case with actual padding and no memset, memcpy,
copy_from_user or structure assignment that I could find was

drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c

There is the code struct drm_amdgpu_info_device dev_info = {};

but I couldn't see any thing in the assembly language that seemed to zero
the structure.  gcc probably thought its job was done because all fields
are subsequently initialized.  But the size of the structure does not seem
to be the same as the sum of the size of the fields.

The set of fields was collected with Coccinelle, which could be unreliable
for this task.

julia

>
> If the structure is not going to be copied to userspace (or otherwise
> exposed), using the initializer is fully sufficient and looks cleaner.
>
> Michal Kubecek
> _______________________________________________
> Cocci mailing list
> Cocci@systeme.lip6.fr
> https://systeme.lip6.fr/mailman/listinfo/cocci
>
