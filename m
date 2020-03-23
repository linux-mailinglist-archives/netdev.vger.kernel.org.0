Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA1F18FBBD
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 18:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgCWRrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 13:47:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:59126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725880AbgCWRrQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 13:47:16 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6519020714;
        Mon, 23 Mar 2020 17:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584985635;
        bh=BUv2Z30FSVqIgeZp/8OHWMjY7R6pYb4AOYvZbdSkCDE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mKlUTiKppp0ozfgWUVx21js2vJ7SeNo0SmNOVntoeJzYj9uR+sGj/Ns7pFQymXDq2
         W+jbFPHP7ziFOgHwkqWJy2SekUce5ueWhWPz1mjYAZKjz9Zz9UUXFX3hvohp+pIZko
         3RZIQCoH3U80UDTAYmRzpxRRZxst98oCnw5TTY5A=
Date:   Mon, 23 Mar 2020 10:47:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zh-yuan Ye <ye.zh-yuan@socionext.com>
Cc:     netdev@vger.kernel.org, okamoto.satoru@socionext.com,
        kojima.masahisa@socionext.com, vinicius.gomes@intel.com
Subject: Re: [PATCH net v2] net: cbs: Fix software cbs to consider packet
 sending time
Message-ID: <20200323104713.50d32643@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200323061709.1881-1-ye.zh-yuan@socionext.com>
References: <20200323061709.1881-1-ye.zh-yuan@socionext.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Minor comments, while waiting for more in-depth review from Vinicius :)

On Mon, 23 Mar 2020 15:17:09 +0900 Zh-yuan Ye wrote:
> Currently the software CBS does not consider the packet sending time
> when depleting the credits. It caused the throughput to be
> Idleslope[kbps] * (Port transmit rate[kbps] / |Sendslope[kbps]|) where
> Idleslope * (Port transmit rate / (Idleslope + |Sendslope|)) = Idleslope
> is expected. In order to fix the issue above, this patch takes the time
> when the packet sending completes into account by moving the anchor time
> variable "last" ahead to the send completion time upon transmission and
> adding wait when the next dequeue request comes before the send
> completion time of the previous packet.

Please add a Fixes tag.

> Signed-off-by: Zh-yuan Ye <ye.zh-yuan@socionext.com>
> ---
> changes in v2:
>  - combine variable "send_completed" into "last"
>  - add the comment for estimate of the packet sending

You can keep those inside the commit message for networking patches

> diff --git a/net/sched/sch_cbs.c b/net/sched/sch_cbs.c
> index b2905b03a432..20f95f0b9d5b 100644
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
> @@ -192,7 +197,6 @@ static struct sk_buff *cbs_dequeue_soft(struct Qdisc *sch)
>  
>  			delay = delay_from_credits(q->credits, q->idleslope);
>  			qdisc_watchdog_schedule_ns(&q->watchdog, now + delay);
> -

Please don't do whitespace cleanup like this in a bug fix. Bug fixes
should be minimal to avoid conflicts.

>  			q->last = now;
>  
>  			return NULL;
> @@ -212,7 +216,9 @@ static struct sk_buff *cbs_dequeue_soft(struct Qdisc *sch)
>  	credits += q->credits;
>  
>  	q->credits = max_t(s64, credits, q->locredit);
> -	q->last = now;
> +	/* Estimate of the transmission of the last byte of the packet in ns */
> +	q->last = now + div64_s64(len * NSEC_PER_SEC,
> +				  atomic64_read(&q->port_rate));

credits_from_len() checks if port_rate is 0 before division. Can you double check 
it's unnecessary?

>  
>  	return skb;
>  }

