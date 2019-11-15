Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBACFE71C
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 22:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfKOVU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 16:20:59 -0500
Received: from mga02.intel.com ([134.134.136.20]:49920 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbfKOVU7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Nov 2019 16:20:59 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Nov 2019 13:20:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,309,1569308400"; 
   d="scan'208";a="406794692"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.26])
  by fmsmga006.fm.intel.com with ESMTP; 15 Nov 2019 13:20:58 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        netdev@vger.kernel.org, davem@davemloft.net
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        linux-kernel@vger.kernel.org,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: Re: [net-next PATCH] taprio: don't reject same mqprio settings
In-Reply-To: <20191115015607.11291-1-ivan.khoronzhuk@linaro.org>
References: <20191115015607.11291-1-ivan.khoronzhuk@linaro.org>
Date:   Fri, 15 Nov 2019 13:21:02 -0800
Message-ID: <87mucwhm4h.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> writes:

> The taprio qdisc allows to set mqprio setting but only once. In case
> if mqprio settings are provided next time the error is returned as
> it's not allowed to change traffic class mapping in-flignt and that
> is normal. But if configuration is absolutely the same - no need to
> return error. It allows to provide same command couple times,
> changing only base time for instance, or changing only scheds maps,
> but leaving mqprio setting w/o modification. It more corresponds the
> message: "Changing the traffic mapping of a running schedule is not
> supported", so reject mqprio if it's really changed.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---
>  net/sched/sch_taprio.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 7cd68628c637..bd844f2cbf7a 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -1347,6 +1347,26 @@ static int taprio_parse_clockid(struct Qdisc *sch, struct nlattr **tb,
>  	return err;
>  }
>  
> +static int taprio_mqprio_cmp(struct net_device *dev,
> +			     struct tc_mqprio_qopt *mqprio)

Nitpick: for these kinds of functions I like to add a 'const' to the parameters
at least as documentation that it doesn't modify its arguments.

> +{
> +	int i;
> +
> +	if (mqprio->num_tc != dev->num_tc)
> +		return -1;

Optional: you could move the check for a NULL mqprio inside this
function. Perhaps, for that to make sense you would need to change the
function name to taprio_mqprio_check() or something.

These are all optional.

Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
