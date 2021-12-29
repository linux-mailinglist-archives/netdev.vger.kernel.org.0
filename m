Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24D9248162B
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 20:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhL2TOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 14:14:03 -0500
Received: from mga12.intel.com ([192.55.52.136]:38228 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229958AbhL2TOD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Dec 2021 14:14:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640805243; x=1672341243;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=ZPhwE10OK5EgjmXYm/gtOuEv6n/rFe1OjWbPWqtq9GQ=;
  b=YHVSFMhqFXjDbujwr16FxItWDux0jXPUDlr/xoFlBprcxrO2yJB+wpfB
   REoJmSwToQHYs4Y5NeJVIRTQ6UMDGr1j3rQaJcV7Rn436WTEJV40b0jy2
   PmMYwjAVBqUYUQp6oGbMwBQDYs3peM2HQI95apXzMksJLhEkuV14W60Fp
   LmgXPcOf29KSXi4+ohnYKmVvPKWFhqtvMLRuhQv02UteXZADf9qU+Fu+b
   KoZuEEzWD9AdLub+VW/fwVB2LNhUwB0MhyADM2VKn+X7x1w1BlFZNjWWs
   N9jqWCNebpI5j2VSNP5tEcfjSflbLvAQDNHZ2PgSHLw1ZjNi5I1zPBHUY
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10212"; a="221556523"
X-IronPort-AV: E=Sophos;i="5.88,246,1635231600"; 
   d="scan'208";a="221556523"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2021 11:14:03 -0800
X-IronPort-AV: E=Sophos;i="5.88,246,1635231600"; 
   d="scan'208";a="554591645"
Received: from andreev1-mobl1.amr.corp.intel.com (HELO vcostago-mobl3) ([10.212.96.86])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2021 11:13:54 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     xiangxia.m.yue@gmail.com, netdev@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [net-next v5 1/2] net: sched: use queue_mapping to pick tx queue
In-Reply-To: <20211220123839.54664-2-xiangxia.m.yue@gmail.com>
References: <20211220123839.54664-1-xiangxia.m.yue@gmail.com>
 <20211220123839.54664-2-xiangxia.m.yue@gmail.com>
Date:   Wed, 29 Dec 2021 16:13:50 -0300
Message-ID: <87k0fn2pht.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xiangxia.m.yue@gmail.com writes:

> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> This patch fixes issue:
> * If we install tc filters with act_skbedit in clsact hook.
>   It doesn't work, because netdev_core_pick_tx() overwrites
>   queue_mapping.
>
>   $ tc filter ... action skbedit queue_mapping 1
>
> And this patch is useful:
> * We can use FQ + EDT to implement efficient policies. Tx queues
>   are picked by xps, ndo_select_queue of netdev driver, or skb hash
>   in netdev_core_pick_tx(). In fact, the netdev driver, and skb
>   hash are _not_ under control. xps uses the CPUs map to select Tx
>   queues, but we can't figure out which task_struct of pod/containter
>   running on this cpu in most case. We can use clsact filters to classify
>   one pod/container traffic to one Tx queue. Why ?
>
>   In containter networking environment, there are two kinds of pod/
>   containter/net-namespace. One kind (e.g. P1, P2), the high throughput
>   is key in these applications. But avoid running out of network resource,
>   the outbound traffic of these pods is limited, using or sharing one
>   dedicated Tx queues assigned HTB/TBF/FQ Qdisc. Other kind of pods
>   (e.g. Pn), the low latency of data access is key. And the traffic is not
>   limited. Pods use or share other dedicated Tx queues assigned FIFO Qdisc.
>   This choice provides two benefits. First, contention on the HTB/FQ Qdisc
>   lock is significantly reduced since fewer CPUs contend for the same queue.
>   More importantly, Qdisc contention can be eliminated completely if each
>   CPU has its own FIFO Qdisc for the second kind of pods.
>
>   There must be a mechanism in place to support classifying traffic based on
>   pods/container to different Tx queues. Note that clsact is outside of Qdisc
>   while Qdisc can run a classifier to select a sub-queue under the
>   lock.

One alternative, I don't know if it would work for you, it to use the
net_prio cgroup + mqprio.

Something like this:

* create the cgroup
  $ mkdir -p /sys/fs/cgroup/net_prio/<CGROUP_NAME>
* assign priorities to the cgroup (per interface)
  $ echo "<IFACE> <PRIO>" >> /sys/fs/cgroup/net_prio/<CGROUP_NAME>/net_prio.ifpriomap"
* use the cgroup in applications that do not set SO_PRIORITY
  $ cgexec -g net_prio:<CGROUP_NAME> <application>
* configure mqprio
  $ tc qdisc replace dev $IFACE parent root handle 100 mqprio \
      num_tc 3 \
      map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
      queues 1@0 1@1 2@2 \
      hw 0

This would map all traffic with SO_PRIORITY 3 to TX queue 0, for example.

But I agree that skbedit's queue_mapping not working is unexpected and
should be fixed.


Cheers,
-- 
Vinicius
