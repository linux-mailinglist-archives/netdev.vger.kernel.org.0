Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C514A4127B5
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 23:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234951AbhITVGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 17:06:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232273AbhITVED (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 17:04:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02B2361107;
        Mon, 20 Sep 2021 21:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632171756;
        bh=yhw6MJGdpGrujZvqXR9hMEFV24CcnnxvNrfXDRNVGdU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IeFVef4xe6+fbrMgbNzoKSGTUtC+6Sm70dWJlI+zDrFly+TkL1qs844wYpvA3wF8X
         ifmYicMFMFAA7GMsErtEeoeopKnfcAAjg2zpvBYOP4o9VI/xxTAZWPJDy8YZxCLyCo
         xzbppS3ndw1jpV/vFQkKu+wjAqPGEgDKqd0TsYQ72XAC4bd89ege7ktgefYcSaxInT
         DtvOFQ9S00n9T2MCzcpG6WP7+8UtZ/LDtyZrVXcUUkXaAlMQXELoPYX4ABiX5fAI0K
         e1owMedN8czGJv9HiBFGewMe0ccz2Ad6s1csmOFopq3IbirTRmsZuQYDTdqj1LpqEO
         gYmMgYr2gho6Q==
Date:   Mon, 20 Sep 2021 14:02:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mianhan Liu <liumh1@shanghaitech.edu.cn>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] net/ipv4/sysctl_net_ipv4.c: remove superfluous
 header files from sysctl_net_ipv4.c
Message-ID: <20210920140235.49b887fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210920134200.31481-1-liumh1@shanghaitech.edu.cn>
References: <20210920134200.31481-1-liumh1@shanghaitech.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Sep 2021 21:42:00 +0800 Mianhan Liu wrote:
> sysctl_net_ipv4.c hasn't use any macro or function declared in mm.h, module.h,
> igmp.h, inetdevice.h, swap.h, slab.h, nsproxy.h, snmp.h, route.h and inet_frag.h. 
> Thus, these files can be removed from sysctl_net_ipv4.c safely without affecting
> the compilation of the net module.

How did you arrive at this conclusion? It certainly uses linux/slab.h
as it calls kmalloc(). Please don't introduce dependencies on
second-order includes. If file uses a function, define, struct etc.
from a header it should directly include that header. Just because the
code still compiles doesn't mean the change is for good.

> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> index 6f1e64d49..f8e39d00b 100644
> --- a/net/ipv4/sysctl_net_ipv4.c
> +++ b/net/ipv4/sysctl_net_ipv4.c
> @@ -6,25 +6,15 @@
>   * Added /proc/sys/net/ipv4 directory entry (empty =) ). [MS]
>   */
>  
> -#include <linux/mm.h>
> -#include <linux/module.h>
>  #include <linux/sysctl.h>
> -#include <linux/igmp.h>
> -#include <linux/inetdevice.h>
>  #include <linux/seqlock.h>
>  #include <linux/init.h>
> -#include <linux/slab.h>
> -#include <linux/nsproxy.h>
> -#include <linux/swap.h>
> -#include <net/snmp.h>
>  #include <net/icmp.h>
>  #include <net/ip.h>
>  #include <net/ip_fib.h>
> -#include <net/route.h>
>  #include <net/tcp.h>
>  #include <net/udp.h>
>  #include <net/cipso_ipv4.h>
> -#include <net/inet_frag.h>
>  #include <net/ping.h>
>  #include <net/protocol.h>
>  #include <net/netevent.h>

