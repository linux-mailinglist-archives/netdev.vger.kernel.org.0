Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C373E308FA4
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 22:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbhA2Vvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 16:51:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:55260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231169AbhA2Vvi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 16:51:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A36364E0C;
        Fri, 29 Jan 2021 21:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611957057;
        bh=5+lld+N8zB2tC711wNInjkm314ATqhCIpTgNUZfW8m4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SGatY2Ggwjqdt7I/Tz2LIO1C8j9i59BYXCLHz9TX9qe8ZipiXObgZWVEKDgypmLHt
         GztLTrzR27Jr3ZFbf80yAreVPjVOkVmPIt4Z0/GXw/GgxWON4WSYiWFy1wN+NpAl+e
         EnZ9Nnv3lGCZySxWMPmlC8GjfH6EWlLt8E2cdEBx9LSfO7/8Sdg77SwWE7f9KhID6R
         H9spnjIqQPiNslYMNB3fy/Bk4u0Uxvs8elvHmE2u2Un7kFKmnB6O+iI1WM5oqDgt+E
         denbPbZRF46TmbPjr7ovvTM0HfT2OA4QZYOpu+WT39E4TazQHq5hQ29tX69Q6YtfJn
         RQQ9VZN3uMciQ==
Date:   Fri, 29 Jan 2021 13:50:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chris Mi <cmi@nvidia.com>
Cc:     netdev@vger.kernel.org, jiri@nvidia.com, saeedm@nvidia.com,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next v4] net: psample: Introduce stubs to remove NIC
 driver dependency
Message-ID: <20210129135056.0e6733eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210128014543.521151-1-cmi@nvidia.com>
References: <20210128014543.521151-1-cmi@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jan 2021 09:45:43 +0800 Chris Mi wrote:
> In order to send sampled packets to userspace, NIC driver calls
> psample api directly. But it creates a hard dependency on module
> psample. Introduce psample_ops to remove the hard dependency.
> It is initialized when psample module is loaded and set to NULL
> when the module is unloaded.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Chris Mi <cmi@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>

> diff --git a/include/net/psample.h b/include/net/psample.h
> index 68ae16bb0a4a..e6a73128de59 100644
> --- a/include/net/psample.h
> +++ b/include/net/psample.h
> @@ -4,6 +4,7 @@
>  
>  #include <uapi/linux/psample.h>
>  #include <linux/list.h>
> +#include <linux/skbuff.h>

Forward declaration should be enough.

>  struct psample_group {
>  	struct list_head list;

>  static void __exit psample_module_exit(void)
>  {
> +	RCU_INIT_POINTER(psample_ops, NULL);

I think you can use rcu_assign_pointer(), it handles constants 
right these days.

Please add a comment here saying that you depend on
genl_unregister_family() executing synchronize_rcu() 
and name the function where it does so.

>  	genl_unregister_family(&psample_nl_family);
>  }

> diff --git a/net/sched/psample_stub.c b/net/sched/psample_stub.c
> new file mode 100644
> index 000000000000..0615a7b64000
> --- /dev/null
> +++ b/net/sched/psample_stub.c
> @@ -0,0 +1,7 @@
> +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
> +/* Copyright (c) 2021 Mellanox Technologies. */
> +
> +#include <net/psample.h>

Forward declaration is sufficient.

> +const struct psample_ops __rcu *psample_ops __read_mostly;
> +EXPORT_SYMBOL_GPL(psample_ops);

