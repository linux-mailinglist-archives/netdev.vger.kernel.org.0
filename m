Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB0DD427442
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 01:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243826AbhJHXks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 19:40:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:35598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231964AbhJHXks (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 19:40:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E584960F5E;
        Fri,  8 Oct 2021 23:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633736332;
        bh=WO0pML6xMM371AaMskdNnaJHXhrC/htRsBswc1itHig=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oQ/8Pd6lQQspDbTbFaU/1vxYkMPLnr6ug7Vzg5KzQI8RNDOjoajE1f81fIT6Tc/Mf
         W7D95IkfA1gQhpuzg/a5UuYga/mQWkxlGDhpgt7g8k6ZoiFSjTfwjVD40tiyXUX0wC
         3xlRpHjjUAp+o/5JiAwxyg4Y23Hmlc98sxzwE/viAKlRjK0gHoYLpjJmYqhFi63knZ
         RYW2hcaOov7QuJBhDI0esqZmoTdHx3E52Bzf8LMTE1Bjb+ZWKWw2s2JLk2gQpz7TRQ
         o+b/sXqeZz/MD0C2TK9K/9+XULnIkHmR9W/Yz5qr0riK8xgvTWVIOEaCOKyYhunwCt
         OLdZDYpV5ZMCA==
Date:   Fri, 8 Oct 2021 16:38:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>
Subject: Re: [PATCH net-next 3/4] gen_stats: Add instead Set the value in
 __gnet_stats_copy_queue().
Message-ID: <20211008163851.3963b94e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211007175000.2334713-4-bigeasy@linutronix.de>
References: <20211007175000.2334713-1-bigeasy@linutronix.de>
        <20211007175000.2334713-4-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Oct 2021 19:49:59 +0200 Sebastian Andrzej Siewior wrote:
> --- a/net/core/gen_stats.c
> +++ b/net/core/gen_stats.c
> @@ -312,14 +312,14 @@ void __gnet_stats_copy_queue(struct gnet_stats_queue *qstats,
>  	if (cpu) {
>  		__gnet_stats_copy_queue_cpu(qstats, cpu);
>  	} else {
> -		qstats->qlen = q->qlen;
> -		qstats->backlog = q->backlog;
> -		qstats->drops = q->drops;
> -		qstats->requeues = q->requeues;
> -		qstats->overlimits = q->overlimits;
> +		qstats->qlen += q->qlen;
> +		qstats->backlog += q->backlog;
> +		qstats->drops += q->drops;
> +		qstats->requeues += q->requeues;
> +		qstats->overlimits += q->overlimits;
>  	}
>  
> -	qstats->qlen = qlen;
> +	qstats->qlen += qlen;

Looks like qlen is going to be added twice for the non-per-cpu case?
