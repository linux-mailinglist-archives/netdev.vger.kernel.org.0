Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD7CF33647
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 19:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728903AbfFCRPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 13:15:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:35558 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727137AbfFCRPO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 13:15:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 077DCAD56;
        Mon,  3 Jun 2019 17:15:12 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 9A676E00E3; Mon,  3 Jun 2019 19:15:12 +0200 (CEST)
Date:   Mon, 3 Jun 2019 19:15:12 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, linville@redhat.com,
        f.fainelli@gmail.com
Subject: Re: [PATCH net] ethtool: fix potential userspace buffer overflow
Message-ID: <20190603171512.GJ15954@unicorn.suse.cz>
References: <20190531231221.29460-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531231221.29460-1-vivien.didelot@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 07:12:21PM -0400, Vivien Didelot wrote:
> ethtool_get_regs() allocates a buffer of size ops->get_regs_len(),
> and pass it to the kernel driver via ops->get_regs() for filling.
> 
> There is no restriction about what the kernel drivers can or cannot do
> with the open ethtool_regs structure. They usually set regs->version
> and ignore regs->len or set it to the same size as ops->get_regs_len().
> 
> Userspace may actually allocate a smaller buffer for registers dump,
> for instance ethtool does that when dumping the raw registers directly
> into a fixed-size file.

This is not exactly true. AFAICS ethtool always calls the ETHTOOL_GREGS
ioctl with the size returned by ETHTOOL_GDRVINFO. Only after that it may
replace regs->len with file length but it's a file it _reads_ and
replaces the dump (or part of it) with it. (Which doesn't seem to make
sense: if ethtool(8) man page says ethtool is to display registers from
a previously saved dump, why does ethtool execute the ETHTOOL_GREGS
request at all?)
 
> Because the current code uses the regs.len value potentially updated
> by the driver when copying the buffer back to userspace, we may
> actually cause a userspace buffer overflow in the final copy_to_user()
> call.
> 
> To fix this, make this case obvious and store regs.len before calling
> ops->get_regs(), to only copy as much data as requested by userspace,
> up to the value returned by ops->get_regs_len().
> 
> While at it, remove the redundant check for non-null regbuf.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com> ---
> net/core/ethtool.c | 5 ++++- 1 file changed, 4 insertions(+), 1
> deletion(-)
> 
> diff --git a/net/core/ethtool.c b/net/core/ethtool.c index
> 43e9add58340..1a0196fbb49c 100644 --- a/net/core/ethtool.c +++
> b/net/core/ethtool.c @@ -1338,38 +1338,41 @@ static noinline_for_stack
> int ethtool_set_rxfh(struct net_device *dev, static int
> ethtool_get_regs(struct net_device *dev, char __user *useraddr) {
> struct ethtool_regs regs; const struct ethtool_ops *ops =
> dev->ethtool_ops; void *regbuf; int reglen, ret;
>  
>  	if (!ops->get_regs || !ops->get_regs_len) return -EOPNOTSUPP;
>  
>  	if (copy_from_user(&regs, useraddr, sizeof(regs))) return
>  	-EFAULT;
>  
>  	reglen = ops->get_regs_len(dev); if (reglen <= 0) return reglen;
>  
>  	if (regs.len > reglen) regs.len = reglen;
>  
>  	regbuf = vzalloc(reglen); if (!regbuf) return -ENOMEM;
>  
> +	if (regs.len < reglen) +		reglen = regs.len; +
> ops->get_regs(dev, &regs, regbuf);
>  
>  	ret = -EFAULT; if (copy_to_user(useraddr, &regs, sizeof(regs)))
>  	goto out; useraddr += offsetof(struct ethtool_regs, data); -
>  	if (regbuf && copy_to_user(useraddr, regbuf, regs.len)) +
>  	if (copy_to_user(useraddr, regbuf, reglen)) goto out; ret = 0;
>  
>   out: vfree(regbuf); return ret; }

Yes, this will address overflowing the userspace buffer. It will still
either preserve regs.len or replace it with full dump length, depending
on the driver. But to address that, we should first agree which it
should be. I'm afraid there is no good choice, setting regs.len to size
actually returned is IMHO less bad.

Michal
