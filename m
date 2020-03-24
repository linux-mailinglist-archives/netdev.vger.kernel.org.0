Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2938F191A1B
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 20:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbgCXTiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 15:38:23 -0400
Received: from mga05.intel.com ([192.55.52.43]:63798 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbgCXTiX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 15:38:23 -0400
IronPort-SDR: erS7VRQhMP+1CiSzJsYlHdNz5nDwV1NQvT+xKaefGAJeTJ38Q+0edBa3WfOacubKWZrYtXL0Dn
 Aeh30IdtA/jQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2020 12:38:23 -0700
IronPort-SDR: JGvBLPEwDzu7crDz4YyCCqokMHH/XsvWmViKSFWwT8gdGqzWo1y6CTX94nkgr7+WYrm4miu1Qy
 JbWJ/rkegoKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,301,1580803200"; 
   d="scan'208";a="448001100"
Received: from lrugelex-mobl.amr.corp.intel.com (HELO ellie) ([10.134.41.192])
  by fmsmga006.fm.intel.com with ESMTP; 24 Mar 2020 12:38:22 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Zh-yuan Ye <ye.zh-yuan@socionext.com>, netdev@vger.kernel.org
Cc:     okamoto.satoru@socionext.com, kojima.masahisa@socionext.com,
        kuba@kernel.org, Zh-yuan Ye <ye.zh-yuan@socionext.com>
Subject: Re: [PATCH net v3] net: cbs: Fix software cbs to consider packet sending time
In-Reply-To: <20200324082825.3095-1-ye.zh-yuan@socionext.com>
References: <20200324082825.3095-1-ye.zh-yuan@socionext.com>
Date:   Tue, 24 Mar 2020 12:38:22 -0700
Message-ID: <87k139czm9.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zh-yuan Ye <ye.zh-yuan@socionext.com> writes:

> Currently the software CBS does not consider the packet sending time
> when depleting the credits. It caused the throughput to be
> Idleslope[kbps] * (Port transmit rate[kbps] / |Sendslope[kbps]|) where
> Idleslope * (Port transmit rate / (Idleslope + |Sendslope|)) = Idleslope
> is expected. In order to fix the issue above, this patch takes the time
> when the packet sending completes into account by moving the anchor time
> variable "last" ahead to the send completion time upon transmission and
> adding wait when the next dequeue request comes before the send
> completion time of the previous packet.
>
> changelog:
> V2->V3:
>  - remove unnecessary whitespace cleanup
>  - add the checks if port_rate is 0 before division
>
> V1->V2:
>  - combine variable "send_completed" into "last"
>  - add the comment for estimate of the packet sending
>
> Fixes: 585d763af09c ("net/sched: Introduce Credit Based Shaper (CBS) qdisc")
> Signed-off-by: Zh-yuan Ye <ye.zh-yuan@socionext.com>
> Reviewed-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> ---
>  net/sched/sch_cbs.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/net/sched/sch_cbs.c b/net/sched/sch_cbs.c
> index b2905b03a432..2eaac2ff380f 100644
> --- a/net/sched/sch_cbs.c
> +++ b/net/sched/sch_cbs.c
> @@ -181,6 +181,11 @@ static struct sk_buff *cbs_dequeue_soft(struct Qdisc *sch)
>  	s64 credits;
>  	int len;
>  
> +	/* The previous packet is still being sent */
> +	if (now < q->last) {
> +		qdisc_watchdog_schedule_ns(&q->watchdog, q->last);
> +		return NULL;
> +	}
>  	if (q->credits < 0) {
>  		credits = timediff_to_credits(now - q->last, q->idleslope);
>  
> @@ -212,7 +217,12 @@ static struct sk_buff *cbs_dequeue_soft(struct Qdisc *sch)
>  	credits += q->credits;
>  
>  	q->credits = max_t(s64, credits, q->locredit);
> -	q->last = now;
> +	/* Estimate of the transmission of the last byte of the packet in ns */
> +	if (unlikely(atomic64_read(&q->port_rate) == 0))

Minor suggestion. I would only move 'atomic64_read()' to outside the
condition, so reading 'q->port_rate' is done only once.

It's looking good. When I saw the problems that the software mode
had with larger packets I should have thought of something like this.
Thanks for solving this.


Cheers,
-- 
Vinicius
