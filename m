Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A12EC473AF
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 09:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbfFPHmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 03:42:04 -0400
Received: from mga03.intel.com ([134.134.136.65]:18597 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725860AbfFPHmD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Jun 2019 03:42:03 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jun 2019 00:42:03 -0700
X-ExtLoop1: 1
Received: from shbuild888.sh.intel.com (HELO localhost) ([10.239.147.114])
  by fmsmga008.fm.intel.com with ESMTP; 16 Jun 2019 00:42:01 -0700
Date:   Sun, 16 Jun 2019 15:42:12 +0800
From:   Feng Tang <feng.tang@intel.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net 3/4] tcp: add tcp_tx_skb_cache sysctl
Message-ID: <20190616074212.2cgkb324wkf6c4in@shbuild888>
References: <20190614232221.248392-1-edumazet@google.com>
 <20190614232221.248392-4-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614232221.248392-4-edumazet@google.com>
User-Agent: NeoMutt/20170609 (1.8.3)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On Fri, Jun 14, 2019 at 04:22:20PM -0700, Eric Dumazet wrote:
> Feng Tang reported a performance regression after introduction
> of per TCP socket tx/rx caches, for TCP over loopback (netperf)
> 
> There is high chance the regression is caused by a change on
> how well the 32 KB per-thread page (current->task_frag) can
> be recycled, and lack of pcp caches for order-3 pages.

Exactly! When I checked the regression, I did several experiments,
and thought of the simliar idea to add the per-CPU orderX pcp list,
the other idea is to add a order3 list in per-cpu softnet_data as
local cache.

Thanks,
Feng

> 
> I could not reproduce the regression myself, cpus all being
> spinning on the mm spinlocks for page allocs/freeing, regardless
> of enabling or disabling the per tcp socket caches.
> 
> It seems best to disable the feature by default, and let
> admins enabling it.
> 
> MM layer either needs to provide scalable order-3 pages
> allocations, or could attempt a trylock on zone->lock if
> the caller only attempts to get a high-order page and is
> able to fallback to order-0 ones in case of pressure.
> 
> Tests run on a 56 cores host (112 hyper threads)
> 
> -	35.49%	netperf 		 [kernel.vmlinux]	  [k] queued_spin_lock_slowpath
>    - 35.49% queued_spin_lock_slowpath
> 	  - 18.18% get_page_from_freelist
> 		 - __alloc_pages_nodemask
> 			- 18.18% alloc_pages_current
> 				 skb_page_frag_refill
> 				 sk_page_frag_refill
> 				 tcp_sendmsg_locked
> 				 tcp_sendmsg
> 				 inet_sendmsg
> 				 sock_sendmsg
> 				 __sys_sendto
> 				 __x64_sys_sendto
> 				 do_syscall_64
> 				 entry_SYSCALL_64_after_hwframe
> 				 __libc_send
> 	  + 17.31% __free_pages_ok
> +	31.43%	swapper 		 [kernel.vmlinux]	  [k] intel_idle
> +	 9.12%	netperf 		 [kernel.vmlinux]	  [k] copy_user_enhanced_fast_string
> +	 6.53%	netserver		 [kernel.vmlinux]	  [k] copy_user_enhanced_fast_string
> +	 0.69%	netserver		 [kernel.vmlinux]	  [k] queued_spin_lock_slowpath
> +	 0.68%	netperf 		 [kernel.vmlinux]	  [k] skb_release_data
> +	 0.52%	netperf 		 [kernel.vmlinux]	  [k] tcp_sendmsg_locked
> 	 0.46%	netperf 		 [kernel.vmlinux]	  [k] _raw_spin_lock_irqsave
> 
> Fixes: 472c2e07eef0 ("tcp: add one skb cache for tx")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Feng Tang <feng.tang@intel.com>
> ---
>  include/net/sock.h         | 4 +++-
>  net/ipv4/sysctl_net_ipv4.c | 8 ++++++++
>  2 files changed, 11 insertions(+), 1 deletion(-)
 
