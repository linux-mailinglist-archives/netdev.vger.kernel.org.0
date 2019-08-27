Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C100F9E4D6
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 11:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729522AbfH0Juj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 05:50:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47246 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728178AbfH0Juj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 05:50:39 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6285D308218D;
        Tue, 27 Aug 2019 09:50:39 +0000 (UTC)
Received: from localhost (ovpn-112-31.ams2.redhat.com [10.36.112.31])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D4F925D9C3;
        Tue, 27 Aug 2019 09:50:35 +0000 (UTC)
Date:   Tue, 27 Aug 2019 11:50:31 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Li Shuang <shuali@redhat.com>
Subject: Re: [PATCH net] net/sched: pfifo_fast: fix wrong dereference when
 qdisc is reset
Message-ID: <20190827115031.43fcbac5@redhat.com>
In-Reply-To: <0598164c6e32684e57c7656f0b8aca0813c51f42.1566861256.git.dcaratti@redhat.com>
References: <0598164c6e32684e57c7656f0b8aca0813c51f42.1566861256.git.dcaratti@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Tue, 27 Aug 2019 09:50:39 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Aug 2019 01:15:16 +0200
Davide Caratti <dcaratti@redhat.com> wrote:

> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
> index 11c03cf4aa74..c89b787785a1 100644
> --- a/net/sched/sch_generic.c
> +++ b/net/sched/sch_generic.c
> @@ -688,12 +688,14 @@ static void pfifo_fast_reset(struct Qdisc *qdisc)
>  			kfree_skb(skb);
>  	}
>  
> -	for_each_possible_cpu(i) {
> -		struct gnet_stats_queue *q = per_cpu_ptr(qdisc->cpu_qstats, i);
> +	if (qdisc_is_percpu_stats(qdisc))

This needs curly brackets, as the block has multiple lines (for coding
style only).

> +		for_each_possible_cpu(i) {
> +			struct gnet_stats_queue *q =
> +				per_cpu_ptr(qdisc->cpu_qstats, i);

And you could split declaration and assignment here, it takes two lines
anyway and becomes more readable.

-- 
Stefano
