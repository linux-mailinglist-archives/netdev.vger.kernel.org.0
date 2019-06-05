Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF7FE36526
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 22:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfFEUMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 16:12:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:60674 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726502AbfFEUMa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 16:12:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 29CF3AECA;
        Wed,  5 Jun 2019 20:12:29 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 83571E00E3; Wed,  5 Jun 2019 22:12:28 +0200 (CEST)
Date:   Wed, 5 Jun 2019 22:12:28 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, linville@redhat.com,
        f.fainelli@gmail.com
Subject: Re: [PATCH net v2] ethtool: fix potential userspace buffer overflow
Message-ID: <20190605201228.GA21536@unicorn.suse.cz>
References: <20190603205713.28121-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603205713.28121-1-vivien.didelot@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 03, 2019 at 04:57:13PM -0400, Vivien Didelot wrote:
> ethtool_get_regs() allocates a buffer of size ops->get_regs_len(),
> and pass it to the kernel driver via ops->get_regs() for filling.
> 
> There is no restriction about what the kernel drivers can or cannot do
> with the open ethtool_regs structure. They usually set regs->version
> and ignore regs->len or set it to the same size as ops->get_regs_len().
> 
> But if userspace allocates a smaller buffer for the registers dump,
> we would cause a userspace buffer overflow in the final copy_to_user()
> call, which uses the regs.len value potentially reset by the driver.
> 
> To fix this, make this case obvious and store regs.len before calling
> ops->get_regs(), to only copy as much data as requested by userspace,
> up to the value returned by ops->get_regs_len().
> 
> While at it, remove the redundant check for non-null regbuf.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

I believe we should also unify returned regs.len value as discussed
before. While the easiest way to do that would be copying regs.len to
reglen uncoditionally and restoring regs.len after the call to
ops->get_regs(), we should also clarify the documentation and clean up
in-tree drivers modifying regs.len (probably also add a warning); this
would be rather material for net-next.

Michal Kubecek

> ---
>  net/core/ethtool.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/ethtool.c b/net/core/ethtool.c
> index 43e9add58340..1a0196fbb49c 100644
> --- a/net/core/ethtool.c
> +++ b/net/core/ethtool.c
> @@ -1338,38 +1338,41 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
>  static int ethtool_get_regs(struct net_device *dev, char __user *useraddr)
>  {
>  	struct ethtool_regs regs;
>  	const struct ethtool_ops *ops = dev->ethtool_ops;
>  	void *regbuf;
>  	int reglen, ret;
>  
>  	if (!ops->get_regs || !ops->get_regs_len)
>  		return -EOPNOTSUPP;
>  
>  	if (copy_from_user(&regs, useraddr, sizeof(regs)))
>  		return -EFAULT;
>  
>  	reglen = ops->get_regs_len(dev);
>  	if (reglen <= 0)
>  		return reglen;
>  
>  	if (regs.len > reglen)
>  		regs.len = reglen;
>  
>  	regbuf = vzalloc(reglen);
>  	if (!regbuf)
>  		return -ENOMEM;
>  
> +	if (regs.len < reglen)
> +		reglen = regs.len;
> +
>  	ops->get_regs(dev, &regs, regbuf);
>  
>  	ret = -EFAULT;
>  	if (copy_to_user(useraddr, &regs, sizeof(regs)))
>  		goto out;
>  	useraddr += offsetof(struct ethtool_regs, data);
> -	if (regbuf && copy_to_user(useraddr, regbuf, regs.len))
> +	if (copy_to_user(useraddr, regbuf, reglen))
>  		goto out;
>  	ret = 0;
>  
>   out:
>  	vfree(regbuf);
>  	return ret;
>  }
> -- 
> 2.21.0
> 
