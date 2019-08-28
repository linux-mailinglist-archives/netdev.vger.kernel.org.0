Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48FDAA0768
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 18:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfH1QbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 12:31:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:7940 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726472AbfH1QbF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 12:31:05 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Aug 2019 09:31:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,441,1559545200"; 
   d="scan'208";a="381336519"
Received: from unknown (HELO ellie) ([10.24.12.211])
  by fmsmga006.fm.intel.com with ESMTP; 28 Aug 2019 09:31:04 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        vedang.patel@intel.com, leandro.maciel.dorileo@intel.com
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net 1/3] taprio: Fix kernel panic in taprio_destroy
In-Reply-To: <20190828144829.32570-2-olteanv@gmail.com>
References: <20190828144829.32570-1-olteanv@gmail.com> <20190828144829.32570-2-olteanv@gmail.com>
Date:   Wed, 28 Aug 2019 09:31:04 -0700
Message-ID: <87a7btqmk7.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Vladimir Oltean <olteanv@gmail.com> writes:

> taprio_init may fail earlier than this line:
>
> 	list_add(&q->taprio_list, &taprio_list);
>
> i.e. due to the net device not being multi queue.

Good catch.

>
> Attempting to remove q from the global taprio_list when it is not part
> of it will result in a kernel panic.
>
> Fix it by iterating through the list and removing it only if found.
>
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---
>  net/sched/sch_taprio.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 540bde009ea5..f1eea8c68011 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -1199,12 +1199,17 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>  
>  static void taprio_destroy(struct Qdisc *sch)
>  {
> -	struct taprio_sched *q = qdisc_priv(sch);
> +	struct taprio_sched *p, *q = qdisc_priv(sch);
>  	struct net_device *dev = qdisc_dev(sch);
> +	struct list_head *pos, *tmp;
>  	unsigned int i;
>  
>  	spin_lock(&taprio_list_lock);
> -	list_del(&q->taprio_list);
> +	list_for_each_safe(pos, tmp, &taprio_list) {
> +		p = list_entry(pos, struct taprio_sched, taprio_list);
> +		if (p == q)
> +			list_del(&q->taprio_list);
> +	}

Personally, I would do things differently, I am thinking: adding the
taprio instance earlier to the list in taprio_init(), and keeping
taprio_destroy() the way it is now. But take this more as a suggestion
:-)


Cheers,
--
Vinicius

