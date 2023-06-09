Return-Path: <netdev+bounces-9405-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9F43728C91
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 02:42:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A3591C20F0C
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 00:42:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4079A806;
	Fri,  9 Jun 2023 00:42:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3442D7E9
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 00:42:03 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A195D2697
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 17:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686271321; x=1717807321;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=otc5OnqEPusE4PqkTyZLPWMfbHd/XyUCR+rWu9nnFhM=;
  b=X5MYLFrqURgoz6VOekUnejHt1CequBrJPltGymTz9Ujq+L3aeMDGagVO
   qdHabkIeWdcBjVs3lFWLqRb3V+XGFoUYWzGtgbDJCjmbllkr0hvxWICIS
   e9PjY2Yl/ejEl3ZY2aoZ8XQm5A90fv8lnlpzivvngdOm3Ax8wmyN4Evq1
   3k7yMnmszNsn0/eilPRpi7/Unf1Yq5T5iOvkntTIBC/mYBkF6rDDsiAwk
   dbG82sPP8+NxX6yxeICjrhJsOoatNBf2nsmQMV9w6Wxv7KsirZPF9gPCm
   N8eMmXV2VgiKRaUG7KjDyA7OVJoSAani2FpH0jIEsKEVF5dBBnhHak1Fb
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="337832775"
X-IronPort-AV: E=Sophos;i="6.00,228,1681196400"; 
   d="scan'208";a="337832775"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 17:42:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="660573990"
X-IronPort-AV: E=Sophos;i="6.00,228,1681196400"; 
   d="scan'208";a="660573990"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.17])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 17:42:01 -0700
From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
To: Zhengchao Shao <shaozhengchao@huawei.com>, netdev@vger.kernel.org,
 jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com
Cc: vladimir.oltean@nxp.com, weiyongjun1@huawei.com, yuehaibing@huawei.com,
 shaozhengchao@huawei.com
Subject: Re: [PATCH net,v2] net/sched: taprio: fix slab-out-of-bounds Read
 in taprio_dequeue_from_txq
In-Reply-To: <20230608062756.3626573-1-shaozhengchao@huawei.com>
References: <20230608062756.3626573-1-shaozhengchao@huawei.com>
Date: Thu, 08 Jun 2023 17:42:00 -0700
Message-ID: <87zg59sbzb.fsf@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Zhengchao Shao <shaozhengchao@huawei.com> writes:

> As shown in [1], out-of-bounds access occurs in two cases:
> 1)when the qdisc of the taprio type is used to replace the previously
> configured taprio, count and offset in tc_to_txq can be set to 0. In this
> case, the value of *txq in taprio_next_tc_txq() will increases
> continuously. When the number of accessed queues exceeds the number of
> queues on the device, out-of-bounds access occurs.

The more I think about this, the more I think the problem is somewhere
else, i.e. even enqueuing a packet from a TC with zero queues associated
with it doesn't make much sense.

The behaviors that make more sense to me are:
  1. reject configurations with '0@0' as invalid;
  2. drop the packets from TCs mapped to the "empty set" queue (0@0)
  during enqueue();

btw, (2) sounds better to me at this point.

Or is there another valid/sensible interpretation to '0@0' that I am missing? 

> 2)When packets are dequeued, taprio can be deleted. In this case, the tc
> rule of dev is cleared. The count and offset values are also set to 0. In
> this case, out-of-bounds access is also caused.

This looks like more like working around the issue than fixing it, and
it just happens, it's a coincidence, that both issues have the same
symptoms.

>
> Now the restriction on the queue number is added.
>
> [1] https://groups.google.com/g/syzkaller-bugs/c/_lYOKgkBVMg
> Fixes: 2f530df76c8c ("net/sched: taprio: give higher priority to higher TCs in software dequeue mode")
> Reported-by: syzbot+04afcb3d2c840447559a@syzkaller.appspotmail.com
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
> v2: set q->cur_txq[tc] to prevent out-of-bounds access during next dequeue
> ---
>  net/sched/sch_taprio.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 3c4c2c334878..82983a6eb8f8 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -799,6 +799,9 @@ static struct sk_buff *taprio_dequeue_tc_priority(struct Qdisc *sch,
>  
>  			taprio_next_tc_txq(dev, tc, &q->cur_txq[tc]);
>  
> +			if (q->cur_txq[tc] >= dev->num_tx_queues)
> +				q->cur_txq[tc] = first_txq;
> +
>  			if (skb)
>  				return skb;
>  		} while (q->cur_txq[tc] != first_txq);
> -- 
> 2.34.1
>
>

-- 
Vinicius

