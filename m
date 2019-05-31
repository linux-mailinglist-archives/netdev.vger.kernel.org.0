Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0C031028
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 16:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfEaO1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 10:27:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:59624 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726515AbfEaO1w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 10:27:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B2C73ADCF;
        Fri, 31 May 2019 14:27:50 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 10B91E00E3; Fri, 31 May 2019 16:27:50 +0200 (CEST)
Date:   Fri, 31 May 2019 16:27:50 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, linville@redhat.com,
        f.fainelli@gmail.com
Subject: Re: [PATCH net-next] ethtool: do not use regs->len after
 ops->get_regs
Message-ID: <20190531142750.GE15954@unicorn.suse.cz>
References: <20190530235450.11824-1-vivien.didelot@gmail.com>
 <20190531065432.GB15954@unicorn.suse.cz>
 <20190531101501.GB23464@t480s.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531101501.GB23464@t480s.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 10:15:01AM -0400, Vivien Didelot wrote:
> Hi Michal,
> 
> On Fri, 31 May 2019 08:54:32 +0200, Michal Kubecek <mkubecek@suse.cz> wrote:
> > On Thu, May 30, 2019 at 07:54:50PM -0400, Vivien Didelot wrote:
> > > The kernel allocates a buffer of size ops->get_regs_len(), and pass
> > > it to the kernel driver via ops->get_regs() for filling.
> > > 
> > > There is no restriction about what the kernel drivers can or cannot
> > > do with the regs->len member. Drivers usually ignore it or set
> > > the same size again. However, ethtool_get_regs() must not use this
> > > value when copying the buffer back to the user, because userspace may
> > > have allocated a smaller buffer. For instance ethtool does that when
> > > dumping the raw registers directly into a fixed-size file.
> > > 
> > > Software may still make use of the regs->len value updated by the
> > > kernel driver, but ethtool_get_regs() must use the original regs->len
> > > given by userspace, up to ops->get_regs_len(), when copying the buffer.
> > > 
> > > Also no need to check regbuf twice.
> > > 
> > > Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
> > > ---
> > >  net/core/ethtool.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/net/core/ethtool.c b/net/core/ethtool.c
> > > index 4a593853cbf2..8f95c7b7cafe 100644
> > > --- a/net/core/ethtool.c
> > > +++ b/net/core/ethtool.c
> > > @@ -1338,38 +1338,40 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
> > >  static int ethtool_get_regs(struct net_device *dev, char __user *useraddr)
> > >  {
> > >  	struct ethtool_regs regs;
> > >  	const struct ethtool_ops *ops = dev->ethtool_ops;
> > >  	void *regbuf;
> > >  	int reglen, ret;
> > >  
> > >  	if (!ops->get_regs || !ops->get_regs_len)
> > >  		return -EOPNOTSUPP;
> > >  
> > >  	if (copy_from_user(&regs, useraddr, sizeof(regs)))
> > >  		return -EFAULT;
> > >  
> > >  	reglen = ops->get_regs_len(dev);
> > >  	if (reglen <= 0)
> > >  		return reglen;
> > >  
> > >  	if (regs.len > reglen)
> > >  		regs.len = reglen;
> > > +	else
> > > +		reglen = regs.len;
> > 
> > This seems wrong. Most drivers do not check regs.len in their get_regs()
> > handler (I'm not sure if there are any that do) and simply write as much
> > data as they have. Thus if userspace passes too short regs.len, this
> > would replace overflow of a userspace buffer for few drivers by overflow
> > of a kernel buffer for (almost) all drivers.
> > 
> > So while we should use the original regs.len from userspace for final
> > copy_to_user(), we have to allocate the buffer for driver ->get_regs()
> > callback with size returned by its ->get_regs_len() callback.
> 
> Either I've completely screwed my patch, or you have misread it. This patch
> actually just stores the original value of regs.len passed by userspace to
> the kernel into reglen, before calling ops->get_regs().
> 
> But the kernel still allocates ops->get_regs_len() and passes that to the
> kernel drivers, as this is the only size drivers must care about.
> 
> Then the kernel only copies what the userspace (originally) requested,
> up to ops->get_regs_len().
> 
> In other words, if userspace requested a bigger buffer only ops->get_regs_len()
> get copied, if the userspace requested a smaller buffer only that length
> get copied.

The problem with this patch is not with what gets copied to userspace
but with the buffer allocated for driver callback. With this patch, the
code looks like this:

	reglen = ops->get_regs_len(dev);
	if (reglen <= 0)
		return reglen;

Here we get actual dump size from driver and put it into reglen.

	if (regs.len > reglen)
		regs.len = reglen;
	else
		reglen = regs.len;

If userspace buffer is insufficient, i.e. regs.len < reglen, we shrink
reglen to regs.len.

	regbuf = vzalloc(reglen);
	if (!regbuf)
		return -ENOMEM;

Here we allocate a buffer of size reglen (which has been shrunk to
regs.len from userspace).

	ops->get_regs(dev, &regs, regbuf);

And pass that buffer to driver's ->get_regs() callback. But these
callbacks mostly ignore regs.len and simply write as much data as they
have (size equal to what ->get_regs_len() returned). So if regs.len
provided by userspace is strictly shorter than actual dump size, driver
writes past the buffer allocated above.

Michal
