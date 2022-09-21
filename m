Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 033DC5E5696
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 01:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiIUXJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 19:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiIUXJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 19:09:56 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 432AA7DF7B;
        Wed, 21 Sep 2022 16:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663801795; x=1695337795;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=5cyZOuXI8ihAJ7BKnFi1CysrJo6d0Rl8C0GHZe45LqQ=;
  b=bY/HentlwwEXTYdUiVnhrHTjjv+heFdNgr73aEIviVB39RC14fylzVd5
   ZeAR1G50V0PUVTrtrKgPE3PrP80I3p83ZM7mfwGVGqQLzEzlFCSufukda
   k9N4hp0f+ve7p5VDtvTNg31bf55/zRLlqL8+nya9pgkMbgTvNRo+AsJz8
   muMNgkOyN9w7g9JcfXQmFSjg+GJpH+/5BKMSXdMx6laZL9gOUbDpnaCqt
   JlB5w18/dr+nMzbjk79qoblc3OyhQ/jF7azitmUevTvGxZ/lOXEOJFzAy
   F9ejXNCIDrbluR6x5lHkAV9P8XvKo+bC7bmOlncbAzUgGm7j57XHlTZJ6
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="326464721"
X-IronPort-AV: E=Sophos;i="5.93,334,1654585200"; 
   d="scan'208";a="326464721"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 16:09:54 -0700
X-IronPort-AV: E=Sophos;i="5.93,334,1654585200"; 
   d="scan'208";a="619556540"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.10])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 16:09:54 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net/sched: taprio: remove unnecessary
 taprio_list_lock
In-Reply-To: <20220921095632.1379251-1-vladimir.oltean@nxp.com>
References: <20220921095632.1379251-1-vladimir.oltean@nxp.com>
Date:   Wed, 21 Sep 2022 16:09:55 -0700
Message-ID: <87sfkkfhoc.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> The 3 functions that want access to the taprio_list:
> taprio_dev_notifier(), taprio_destroy() and taprio_init() are all called
> with the rtnl_mutex held, therefore implicitly serialized with respect
> to each other. A spin lock serves no purpose.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/sched/sch_taprio.c | 7 -------
>  1 file changed, 7 deletions(-)
>
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 1ab92968c1e3..163255e0cd77 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -27,7 +27,6 @@
>  #include <net/tcp.h>
>  
>  static LIST_HEAD(taprio_list);
> -static DEFINE_SPINLOCK(taprio_list_lock);
>  
>  #define TAPRIO_ALL_GATES_OPEN -1
>  
> @@ -1082,7 +1081,6 @@ static int taprio_dev_notifier(struct notifier_block *nb, unsigned long event,
>  	if (event != NETDEV_UP && event != NETDEV_CHANGE)
>  		return NOTIFY_DONE;
>  
> -	spin_lock(&taprio_list_lock);
>  	list_for_each_entry(q, &taprio_list, taprio_list) {
>  		qdev = qdisc_dev(q->root);
>  		if (qdev == dev) {

Optional simplification: do you mind removing 'found' and moving the
call to taprio_set_picos_per_byte() here?

Anyway,

Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>

> @@ -1090,7 +1088,6 @@ static int taprio_dev_notifier(struct notifier_block *nb, unsigned long event,
>  			break;
>  		}
>  	}
> -	spin_unlock(&taprio_list_lock);
>  
>  	if (found)
>  		taprio_set_picos_per_byte(dev, q);
> @@ -1602,9 +1599,7 @@ static void taprio_destroy(struct Qdisc *sch)
>  	struct sched_gate_list *oper, *admin;
>  	unsigned int i;
>  
> -	spin_lock(&taprio_list_lock);
>  	list_del(&q->taprio_list);
> -	spin_unlock(&taprio_list_lock);
>  
>  	/* Note that taprio_reset() might not be called if an error
>  	 * happens in qdisc_create(), after taprio_init() has been called.
> @@ -1653,9 +1648,7 @@ static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
>  	q->clockid = -1;
>  	q->flags = TAPRIO_FLAGS_INVALID;
>  
> -	spin_lock(&taprio_list_lock);
>  	list_add(&q->taprio_list, &taprio_list);
> -	spin_unlock(&taprio_list_lock);
>  
>  	if (sch->parent != TC_H_ROOT) {
>  		NL_SET_ERR_MSG_MOD(extack, "Can only be attached as root qdisc");
> -- 
> 2.34.1
>


Cheers,
-- 
Vinicius
