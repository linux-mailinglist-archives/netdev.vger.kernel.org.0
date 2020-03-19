Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51B8F18BDA3
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 18:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbgCSRKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 13:10:17 -0400
Received: from mga05.intel.com ([192.55.52.43]:55535 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727235AbgCSRKR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 13:10:17 -0400
IronPort-SDR: Gp9cisrGBq1QSTNdiXAEbP1GNp2rHUXjZKjxLLAgiWf8Mn/ZlVXf+NUST76ni00kE1i5tKeODT
 JSBU6afoT/og==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2020 10:10:17 -0700
IronPort-SDR: DQJQSdBoGIgvMQE3FGM/3PTZZ5fW3UlFDqwtmCCXggvQkJ3w2ZJnpzgf0G0ANxJSbsa9cVci4R
 N4SRKHBrv5ZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,572,1574150400"; 
   d="scan'208";a="446295305"
Received: from houfeich-mobl1.amr.corp.intel.com (HELO ellie) ([10.255.71.146])
  by fmsmga006.fm.intel.com with ESMTP; 19 Mar 2020 10:10:16 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Zh-yuan Ye <ye.zh-yuan@socionext.com>, netdev@vger.kernel.org
Cc:     okamoto.satoru@socionext.com, kojima.masahisa@socionext.com,
        Zh-yuan Ye <ye.zh-yuan@socionext.com>
Subject: Re: [PATCH net] net: cbs: Fix software cbs to consider packet
In-Reply-To: <20200319075659.3126-1-ye.zh-yuan@socionext.com>
References: <20200319075659.3126-1-ye.zh-yuan@socionext.com>
Date:   Thu, 19 Mar 2020 10:10:15 -0700
Message-ID: <87lfnwfeyw.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Zh-yuan Ye <ye.zh-yuan@socionext.com> writes:

> Currently the software CBS does not consider the packet sending time
> when depleting the credits. It caused the throughput to be
> Idleslope[kbps] * (Port transmit rate[kbps] / |Sendslope[kbps]|) where
> Idleslope * (Port transmit rate / (Idleslope + |Sendslope|)) is expected.
> In order to fix the issue above, this patch takes the time when the
> packet sending completes into account by moving the anchor time variable
> "last" ahead to the send completion time upon transmission and adding
> wait when the next dequeue request comes before the send completion time
> of the previous packet.
>
> Signed-off-by: Zh-yuan Ye <ye.zh-yuan@socionext.com>
> ---

You raise good points here.

What I am thinking is that perhaps we could replace 'q->last' by this
'send_completed' idea, then we could have a more precise software mode
when we take into account when we dequeue the "last byte" of the packet.

>  net/sched/sch_cbs.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/net/sched/sch_cbs.c b/net/sched/sch_cbs.c
> index b2905b03a432..a78b8a750bd9 100644
> --- a/net/sched/sch_cbs.c
> +++ b/net/sched/sch_cbs.c
> @@ -71,6 +71,7 @@ struct cbs_sched_data {
>  	int queue;
>  	atomic64_t port_rate; /* in bytes/s */
>  	s64 last; /* timestamp in ns */
> +	s64 send_completed; /* timestamp in ns */

So, my suggestion is to replace 'last' by the 'send_completed' concept.

And as an optional suggestion, I think that changing the 'last' name by
something like 'last_byte' with a comment saying "estimate of the
transmission of the last byte of the packet, in ns" could be worth
thinking about.

Do you see any problems?


Cheers,
-- 
Vinicius
