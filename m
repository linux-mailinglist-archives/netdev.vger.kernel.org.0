Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E7A1F06D3
	for <lists+netdev@lfdr.de>; Sat,  6 Jun 2020 15:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgFFNnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jun 2020 09:43:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:47058 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726078AbgFFNnQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Jun 2020 09:43:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id ECAEEAAC3;
        Sat,  6 Jun 2020 13:43:17 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 21DD6604AD; Sat,  6 Jun 2020 15:43:14 +0200 (CEST)
Date:   Sat, 6 Jun 2020 15:43:14 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Heiko Thiery <heiko.thiery@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: ethtool build failure
Message-ID: <20200606134314.kphjg6mkdbcjsx6l@lion.mk-sys.cz>
References: <CAEyMn7a5SwQtMxrrJ-C0Jy6THZcCCPXp5ouC+jRLH4ySK-8p_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEyMn7a5SwQtMxrrJ-C0Jy6THZcCCPXp5ouC+jRLH4ySK-8p_A@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 06, 2020 at 03:24:22PM +0200, Heiko Thiery wrote:
> Hi Michael et all,
> 
> I'm digging in the reason for a failure when building ethtool with
> buildroot [1].
> 
> I see the following error:
> ---
> data/buildroot/buildroot-test/instance-0/output/host/bin/i686-linux-gcc
> -DHAVE_CONFIG_H -I.  -I./uapi  -D_LARGEFILE_SOURCE
> -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -Wall -D_LARGEFILE_SOURCE
> -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64  -Os   -static -c -o
> netlink/desc-rtnl.o netlink/desc-rtnl.c
> In file included from ./uapi/linux/ethtool_netlink.h:12,
>                  from netlink/desc-ethtool.c:7:
> ./uapi/linux/ethtool.h:1294:19: warning: implicit declaration of
> function '__KERNEL_DIV_ROUND_UP' [-Wimplicit-function-declaration]
>   __u32 queue_mask[__KERNEL_DIV_ROUND_UP(MAX_NUM_QUEUE, 32)];
>                    ^~~~~~~~~~~~~~~~~~~~~
> ./uapi/linux/ethtool.h:1294:8: error: variably modified 'queue_mask'
> at file scope
>   __u32 queue_mask[__KERNEL_DIV_ROUND_UP(MAX_NUM_QUEUE, 32)];
>         ^~~~~~~~~~
> ---

Thank you for the report. This is fixed by first part of this patch:

  https://patchwork.ozlabs.org/project/netdev/patch/bb60cbfe99071fca4b0ea9e62d67a2341d8dd652.1590707335.git.mkubecek@suse.cz/

I'm going to apply it (with the rest of the series) this weekend.

> The problems seems to be injected by the "warning: implicit
> declaration of function".
> 
> When I move the __KERNEL_DIV_ROUND_UP macro right beside usage in
> "uapi/linux/ethtool.h" the failure is gone.
> 
> ---
> diff --git a/uapi/linux/ethtool.h b/uapi/linux/ethtool.h
> index d3dcb45..6710fa0 100644
> --- a/uapi/linux/ethtool.h
> +++ b/uapi/linux/ethtool.h
> @@ -1288,6 +1288,11 @@ enum ethtool_sfeatures_retval_bits {
>   * @queue_mask: Bitmap of the queues which sub command apply to
>   * @data: A complete command structure following for each of the
> queues addressed
>   */
> +/* ethtool.h epxects __KERNEL_DIV_ROUND_UP to be defined by <linux/kernel.h> */
> +#include <linux/kernel.h>
> +#ifndef __KERNEL_DIV_ROUND_UP
> +#define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
> +#endif
>  struct ethtool_per_queue_op {
>         __u32   cmd;
>         __u32   sub_command;
> ---

This would fix the warning and error too but uapi/linux/ethtool.h is
a sanitized copy of a kernel header which we import and do not apply
further changes. Moreover, there is no need to have multiple definitions
of the same macro and there is already one in internal.h.

Michal
