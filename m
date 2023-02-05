Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0814268AFAC
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 13:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjBEMKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 07:10:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjBEMKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 07:10:45 -0500
Received: from mx11lb.world4you.com (mx11lb.world4you.com [81.19.149.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A6241BAEF
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 04:10:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7mTIxy5zT4wh8BePIIFmYWu6SgFkDHD0MGftQ4g0q4E=; b=m2HqmcHKkBTPVEOSCFi9lnwLjM
        FbEI+KfyBLYetId3Ha8mT4vNB9ISBl7BQaT0iHqOy63Nv+8RWN4oX8XDo0Ry2/7bkNTKKi4nSlvjt
        LG5rlTN+ex84Yd3qbAHi5SwbqgH1RrbMNOoiuP2on4DMSNluIqGCTClRqLa0kQJ1wdBg=;
Received: from [88.117.49.184] (helo=[10.0.0.160])
        by mx11lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pOdqt-0003Ue-Um; Sun, 05 Feb 2023 13:10:36 +0100
Message-ID: <58608f36-8ea7-77e0-4b36-efe9f255764d@engleder-embedded.com>
Date:   Sun, 5 Feb 2023 13:10:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v5 net-next 11/17] net/sched: taprio: centralize mqprio
 qopt validation
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Simon Horman <simon.horman@corigine.com>
References: <20230202003621.2679603-1-vladimir.oltean@nxp.com>
 <20230202003621.2679603-12-vladimir.oltean@nxp.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <20230202003621.2679603-12-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.02.23 01:36, Vladimir Oltean wrote:
> There is a lot of code in taprio which is "borrowed" from mqprio.
> It makes sense to put a stop to the "borrowing" and start actually
> reusing code.
> 
> Because taprio and mqprio are built as part of different kernel modules,
> code reuse can only take place either by writing it as static inline
> (limiting), putting it in sch_generic.o (not generic enough), or
> creating a third auto-selectable kernel module which only holds library
> code. I opted for the third variant.
> 
> In a previous change, mqprio gained support for reverse TC:TXQ mappings,
> something which taprio still denies. Make taprio use the same validation
> logic so that it supports this configuration as well.
> 
> The taprio code didn't enforce TXQ overlaps in txtime-assist mode and
> that looks intentional, even if I've no idea why that might be. Preserve
> that, but add a comment.
> 
> There isn't any dedicated MAINTAINERS entry for mqprio, so nothing to
> update there.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

<...>

> +++ b/net/sched/sch_mqprio.c
> @@ -17,6 +17,8 @@
>   #include <net/sch_generic.h>
>   #include <net/pkt_cls.h>
>   
> +#include "sch_mqprio_lib.h"
> +
>   struct mqprio_sched {
>   	struct Qdisc		**qdiscs;
>   	u16 mode;
> @@ -27,59 +29,6 @@ struct mqprio_sched {
>   	u64 max_rate[TC_QOPT_MAX_QUEUE];
>   };
>   
> -/* Returns true if the intervals [a, b) and [c, d) overlap. */
> -static bool intervals_overlap(int a, int b, int c, int d)
> -{
> -	int left = max(a, c), right = min(b, d);
> -
> -	return left < right;
> -}

<...>

> +++ b/net/sched/sch_mqprio_lib.c
> @@ -0,0 +1,100 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include <linux/net.h>
> +#include <linux/netdevice.h>
> +#include <linux/netlink.h>
> +#include <linux/types.h>
> +#include <net/pkt_sched.h>
> +
> +#include "sch_mqprio_lib.h"
> +
> +static bool intervals_overlap(int a, int b, int c, int d)

You may could keep the comment for this function.
/* Returns true if the intervals [a, b) and [c, d) overlap. */

Reviewed-by: Gerhard Engleder <gerhard@engleder-embedded.com>

Gerhard
