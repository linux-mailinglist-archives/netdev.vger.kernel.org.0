Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0570C454D0B
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 19:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238982AbhKQS1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 13:27:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:55012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231303AbhKQS1U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 13:27:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B63261A62;
        Wed, 17 Nov 2021 18:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637173461;
        bh=2JEh2UwgYz/xIl5eN50ViP5URkEEheWC3AhWGRhlF64=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M/7lZOwFEjjWYviIBZZ4C7EZknMatGMqyTWY5YiwooZito6dUdsnVJEtjE1UB8dGV
         GEz5kzV4jkyPSYiM3Xh57H/SAxu2QaGHdDX6IwmmRRmfVFM++HTOlksjrOm4u1XSrA
         /Pu/MhuLLfRSZ9ar4rWD9jJdcaHSjVTv7/qjEtXZZlxgm1xiD36oEbNaO32oCa0GMh
         kHGe1bjGppVZSHsv3+ymWlapCAHlzNbSfOfaofxknKbaueZZ5yhc4mPw4wvQziB0DJ
         82IvqsHfTNs/pzI+Zta+MjjrifSa8VJPMlVrgXUbwc9Smj6AGPy6jZku3LA6J5MaJS
         09eUbeKWgQmFA==
Date:   Wed, 17 Nov 2021 20:24:17 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, eric.dumazet@gmail.com
Subject: Re: [RFC net-next 1/2] net: add netdev_refs debug
Message-ID: <YZVI0cNLwd2flBkd@unreal>
References: <20211117174723.2305681-1-kuba@kernel.org>
 <20211117174723.2305681-2-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117174723.2305681-2-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 09:47:22AM -0800, Jakub Kicinski wrote:
> Debugging netdev ref leaks is still pretty hard. Eric added
> optional use of a normal refcount which is useful for tracking
> abuse of existing users.
> 
> For new code, however, it'd be great if we could actually track
> the refs per-user. Allowing us to detect leaks where they happen.
> This patch introduces a netdev_ref type and uses the debug_objects
> infra to track refs being lost or misused.
> 
> In the future we can extend this structure to also catch those
> who fail to release the ref on unregistering notification.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  MAINTAINERS                 |   1 +
>  include/linux/netdev_refs.h | 104 ++++++++++++++++++++++++++++++++++++
>  lib/Kconfig.debug           |   7 +++
>  net/core/dev.c              |   8 +++
>  4 files changed, 120 insertions(+)
>  create mode 100644 include/linux/netdev_refs.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4c74516e4353..47fe27175c9f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -18482,6 +18482,7 @@ F:	include/uapi/linux/pkt_sched.h
>  F:	include/uapi/linux/tc_act/
>  F:	include/uapi/linux/tc_ematch/
>  F:	net/sched/
> +F:	tools/testing/selftests/tc-testing/
>  
>  TC90522 MEDIA DRIVER
>  M:	Akihiro Tsukada <tskd08@gmail.com>
> diff --git a/include/linux/netdev_refs.h b/include/linux/netdev_refs.h
> new file mode 100644
> index 000000000000..326772ea0a63
> --- /dev/null
> +++ b/include/linux/netdev_refs.h
> @@ -0,0 +1,104 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +
> +#ifndef _LINUX_NETDEV_REFS_H
> +#define _LINUX_NETDEV_REFS_H
> +
> +#include <linux/debugobjects.h>
> +#include <linux/netdevice.h>
> +
> +/* Explicit netdevice references
> + * struct netdev_ref is a storage for a reference. It's equivalent
> + * to a netdev pointer, but when debug is enabled it performs extra checks.
> + * Most users will want to take a reference with netdev_hold(), access it
> + * via netdev_ref_ptr() and release with netdev_put().
> + */
> +
> +struct netdev_ref {
> +	struct net_device *dev;
> +#ifdef CONFIG_DEBUG_OBJECTS_NETDEV_REFS
> +	refcount_t cnt;
> +#endif
> +};
> +
> +extern const struct debug_obj_descr netdev_ref_debug_descr;
> +
> +/* Store a raw, unprotected pointer */
> +static inline void __netdev_ref_store(struct netdev_ref *ref,
> +				      struct net_device *dev)
> +{
> +	ref->dev = dev;
> +
> +#ifdef CONFIG_DEBUG_OBJECTS_NETDEV_REFS
> +	refcount_set(&ref->cnt, 0);

This is very uncommon pattern. I would expect that first pointer access
will start from 1, like all refcount_t users. If you still prefer to
start from 0, i suggest you to use atomic_t. 

IMHO, much better will be to use kref for this type of reference counting.

Thanks
