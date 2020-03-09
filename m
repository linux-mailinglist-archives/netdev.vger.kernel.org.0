Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 589D417EBC3
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 23:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbgCIWM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 18:12:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:56100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726937AbgCIWM6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 18:12:58 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F2EC2465A;
        Mon,  9 Mar 2020 22:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583791977;
        bh=JnNUYNf7la5refBm6BR5X6hhXSWx806urFsEgdcdFxg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=buHZ00zfavJZ3SF7EAXpdnicu9FpeeMZ1qLd5XNC4b8+zTBV7lrmmyFIYa+/7ly/S
         yEZk8+1zMNHXECQ/VAb4LeTnrXwJRu7FmN2zmFylj6jfU4VTHnMkf9p4o+VZZMkj7Z
         RELX+oiJRhQXgvkgS3asMTkCPt/Ppm45pr3WM7sA=
Date:   Mon, 9 Mar 2020 15:12:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        petrm@mellanox.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 3/6] net: sched: RED: Introduce an ECN
 tail-dropping mode
Message-ID: <20200309151255.29bb3a4b@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200309183503.173802-4-idosch@idosch.org>
References: <20200309183503.173802-1-idosch@idosch.org>
        <20200309183503.173802-4-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  9 Mar 2020 20:35:00 +0200 Ido Schimmel wrote:
> diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
> index f9839d68b811..d72db7643a37 100644
> --- a/net/sched/sch_red.c
> +++ b/net/sched/sch_red.c
> @@ -44,7 +44,8 @@ struct red_sched_data {
>  	struct Qdisc		*qdisc;
>  };
>  
> -#define RED_SUPPORTED_FLAGS (TC_RED_ECN | TC_RED_HARDDROP | TC_RED_ADAPTATIVE)
> +#define RED_SUPPORTED_FLAGS (TC_RED_ECN | TC_RED_HARDDROP | \
> +			     TC_RED_ADAPTATIVE | TC_RED_TAILDROP)
>  
>  static inline int red_use_ecn(struct red_sched_data *q)
>  {
> @@ -56,6 +57,11 @@ static inline int red_use_harddrop(struct red_sched_data *q)
>  	return q->flags & TC_RED_HARDDROP;
>  }
>  
> +static inline int red_use_taildrop(struct red_sched_data *q)

Please don't do static inlines in C code, even if the neighboring code
does.

> +{
> +	return q->flags & TC_RED_TAILDROP;
> +}
> +
>  static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch,
>  		       struct sk_buff **to_free)
>  {
> @@ -76,23 +82,36 @@ static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch,
>  
>  	case RED_PROB_MARK:
>  		qdisc_qstats_overlimit(sch);
> -		if (!red_use_ecn(q) || !INET_ECN_set_ce(skb)) {
> +		if (!red_use_ecn(q)) {
>  			q->stats.prob_drop++;
>  			goto congestion_drop;
>  		}
>  
> -		q->stats.prob_mark++;
> +		if (INET_ECN_set_ce(skb)) {
> +			q->stats.prob_mark++;
> +		} else if (red_use_taildrop(q)) {

This condition is inverted, no?

If user requested taildrop the packet should be queued.

> +			q->stats.prob_drop++;
> +			goto congestion_drop;
> +		}
> +
> +		/* Non-ECT packet in ECN taildrop mode: queue it. */
>  		break;
>  
>  	case RED_HARD_MARK:
>  		qdisc_qstats_overlimit(sch);
> -		if (red_use_harddrop(q) || !red_use_ecn(q) ||
> -		    !INET_ECN_set_ce(skb)) {
> +		if (red_use_harddrop(q) || !red_use_ecn(q)) {
> +			q->stats.forced_drop++;
> +			goto congestion_drop;
> +		}
> +
> +		if (INET_ECN_set_ce(skb)) {
> +			q->stats.forced_mark++;
> +		} else if (!red_use_taildrop(q)) {

This one looks correct.

>  			q->stats.forced_drop++;
>  			goto congestion_drop;
>  		}
>  
> -		q->stats.forced_mark++;
> +		/* Non-ECT packet in ECN taildrop mode: queue it. */
>  		break;
>  	}
>  
