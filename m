Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A23A308FE
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 08:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfEaGye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 02:54:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:34226 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725963AbfEaGye (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 02:54:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C1C6FAF8D;
        Fri, 31 May 2019 06:54:32 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 28191E00E3; Fri, 31 May 2019 08:54:32 +0200 (CEST)
Date:   Fri, 31 May 2019 08:54:32 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, linville@redhat.com,
        f.fainelli@gmail.com
Subject: Re: [PATCH net-next] ethtool: do not use regs->len after
 ops->get_regs
Message-ID: <20190531065432.GB15954@unicorn.suse.cz>
References: <20190530235450.11824-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190530235450.11824-1-vivien.didelot@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 07:54:50PM -0400, Vivien Didelot wrote:
> The kernel allocates a buffer of size ops->get_regs_len(), and pass
> it to the kernel driver via ops->get_regs() for filling.
> 
> There is no restriction about what the kernel drivers can or cannot
> do with the regs->len member. Drivers usually ignore it or set
> the same size again. However, ethtool_get_regs() must not use this
> value when copying the buffer back to the user, because userspace may
> have allocated a smaller buffer. For instance ethtool does that when
> dumping the raw registers directly into a fixed-size file.
> 
> Software may still make use of the regs->len value updated by the
> kernel driver, but ethtool_get_regs() must use the original regs->len
> given by userspace, up to ops->get_regs_len(), when copying the buffer.
> 
> Also no need to check regbuf twice.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
> ---
>  net/core/ethtool.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/ethtool.c b/net/core/ethtool.c
> index 4a593853cbf2..8f95c7b7cafe 100644
> --- a/net/core/ethtool.c
> +++ b/net/core/ethtool.c
> @@ -1338,38 +1338,40 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
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
> +	else
> +		reglen = regs.len;

This seems wrong. Most drivers do not check regs.len in their get_regs()
handler (I'm not sure if there are any that do) and simply write as much
data as they have. Thus if userspace passes too short regs.len, this
would replace overflow of a userspace buffer for few drivers by overflow
of a kernel buffer for (almost) all drivers.

So while we should use the original regs.len from userspace for final
copy_to_user(), we have to allocate the buffer for driver ->get_regs()
callback with size returned by its ->get_regs_len() callback.

Michal Kubecek

>  
>  	regbuf = vzalloc(reglen);
>  	if (!regbuf)
>  		return -ENOMEM;
>  
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
