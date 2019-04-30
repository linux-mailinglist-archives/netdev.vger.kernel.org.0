Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83D07ED7C
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 02:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729238AbfD3AGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 20:06:18 -0400
Received: from mga05.intel.com ([192.55.52.43]:32977 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728844AbfD3AGR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 20:06:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Apr 2019 17:06:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,411,1549958400"; 
   d="scan'208";a="146933125"
Received: from dorilex.jf.intel.com (HELO dorilex) ([10.54.70.84])
  by fmsmga007.fm.intel.com with ESMTP; 29 Apr 2019 17:06:17 -0700
From:   Leandro Dorileo <l@dorileo.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Leandro Dorileo <leandro.maciel.dorileo@intel.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: Re: [PATCH net-next 3/5] net/sched: taprio: fix build without 64bit div
In-Reply-To: <20190417205159.30938-4-jakub.kicinski@netronome.com>
References: <20190417205159.30938-1-jakub.kicinski@netronome.com> <20190417205159.30938-4-jakub.kicinski@netronome.com>
Date:   Mon, 29 Apr 2019 17:04:21 -0700
Message-ID: <87y33s1hq2.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi,

Jakub Kicinski <jakub.kicinski@netronome.com> writes:

> Recent changes to taprio did not use the correct div64 helpers,
> leading to:
>
> net/sched/sch_taprio.o: In function `taprio_dequeue':
> sch_taprio.c:(.text+0x34a): undefined reference to `__divdi3'
> net/sched/sch_taprio.o: In function `advance_sched':
> sch_taprio.c:(.text+0xa0b): undefined reference to `__divdi3'
> net/sched/sch_taprio.o: In function `taprio_init':
> sch_taprio.c:(.text+0x1450): undefined reference to `__divdi3'
> /home/jkicinski/devel/linux/Makefile:1032: recipe for target 'vmlinux' failed
>
> Use math64 helpers.
>
> Fixes: 7b9eba7ba0c1 ("net/sched: taprio: fix picos_per_byte miscalculation")
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>


Acked-by: Leandro Dorileo <leandro.maciel.dorileo@intel.com>


> ---
> CC: Leandro Dorileo <leandro.maciel.dorileo@intel.com>
> CC: Vinicius Costa Gomes <vinicius.gomes@intel.com>
>
>  net/sched/sch_taprio.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
>
> diff --git a/net/sched/sch_taprio.c b/net/
> sched/sch_taprio.c
> index 1b0fb80162e6..001182aa3959 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -13,6 +13,7 @@
>  #include <linux/list.h>
>  #include <linux/errno.h>
>  #include <linux/skbuff.h>
> +#include <linux/math64.h>
>  #include <linux/module.h>
>  #include <linux/spinlock.h>
>  #include <net/netlink.h>
> @@ -121,7 +122,14 @@ static struct sk_buff *taprio_peek(struct Qdisc *sch)
>  
>  static inline int length_to_duration(struct taprio_sched *q, int len)
>  {
> -	return (len * atomic64_read(&q->picos_per_byte)) / 1000;
> +	return div_u64(len * atomic64_read(&q->picos_per_byte), 1000);
> +}
> +
> +static void taprio_set_budget(struct taprio_sched *q, struct sched_entry *entry)
> +{
> +	atomic_set(&entry->budget,
> +		   div64_u64((u64)entry->interval * 1000,
> +			     atomic64_read(&q->picos_per_byte)));
>  }
>  
>  static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
> @@ -241,8 +249,7 @@ static enum hrtimer_restart advance_sched(struct hrtimer *timer)
>  	close_time = k
> time_add_ns(entry->close_time, next->interval);
>  
>  	next->close_time = close_time;
> -	atomic_set(&next->budget,
> -		   (next->interval * 1000) / atomic64_read(&q->picos_per_byte));
> +	taprio_set_budget(q, next);
>  
>  first_run:
>  	rcu_assign_pointer(q->current_entry, next);
> @@ -575,9 +582,7 @@ static void taprio_start_sched(struct Qdisc *sch, ktime_t start)
>  				 list);
>  
>  	first->close_time = ktime_add_ns(start, first->interval);
> -	atomic_set(&first->budget,
> -		   (first->interval * 1000) /
> -		   atomic64_read(&q->picos_per_byte));
> +	taprio_set_budget(q, first);
>  	rcu_assign_pointer(q->current_entry, NULL);
>  
>  	spin_unlock_irqrestore(&q->current_entry_lock, flags);
> -- 
> 2.21.0
