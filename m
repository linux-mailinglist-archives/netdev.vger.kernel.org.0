Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 794BD5A0B83
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 10:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237417AbiHYIbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 04:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233811AbiHYIbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 04:31:10 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE18A5983;
        Thu, 25 Aug 2022 01:31:05 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661416263;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9JreSlxKXQR3ziGAdiDnXffdkc+9SIm7IIEFiG45Z3U=;
        b=WhXhEqkbiX1TKDvyv9ByY4wFjR+PslXkJm1X1zFtwOHG+RWLsu2KluUQkTqA5aYnhVpRRD
        lOGVOgpLskeEqjQIYBICwBS3/Kbho1OSJhYob4VUfH5fdlJTDhTBDKIUpUCFvfag6qTigX
        vPAT6fwpRLN0nC2K/hWDCoI98nmX++Q=
MIME-Version: 1.0
Subject: Re: [PATCH v2 3/3] memcg: increase MEMCG_CHARGE_BATCH to 64
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20220825000506.239406-4-shakeelb@google.com>
Date:   Thu, 25 Aug 2022 16:30:48 +0800
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <songmuchun@bytedance.com>,
        =?utf-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Feng Tang <feng.tang@intel.com>,
        Oliver Sang <oliver.sang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, lkp@lists.01.org,
        cgroups@vger.kernel.org, Linux MM <linux-mm@kvack.org>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <4A0F7B38-2701-486D-A847-DCC4B49F8EAF@linux.dev>
References: <20220825000506.239406-1-shakeelb@google.com>
 <20220825000506.239406-4-shakeelb@google.com>
To:     Shakeel Butt <shakeelb@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Aug 25, 2022, at 08:05, Shakeel Butt <shakeelb@google.com> wrote:
> 
> For several years, MEMCG_CHARGE_BATCH was kept at 32 but with bigger
> machines and the network intensive workloads requiring througput in
> Gbps, 32 is too small and makes the memcg charging path a bottleneck.
> For now, increase it to 64 for easy acceptance to 6.0. We will need to
> revisit this in future for ever increasing demand of higher performance.
> 
> Please note that the memcg charge path drain the per-cpu memcg charge
> stock, so there should not be any oom behavior change. Though it does
> have impact on rstat flushing and high limit reclaim backoff.
> 
> To evaluate the impact of this optimization, on a 72 CPUs machine, we
> ran the following workload in a three level of cgroup hierarchy.
> 
> $ netserver -6
> # 36 instances of netperf with following params
> $ netperf -6 -H ::1 -l 60 -t TCP_SENDFILE -- -m 10K
> 
> Results (average throughput of netperf):
> Without (6.0-rc1)       10482.7 Mbps
> With patch              17064.7 Mbps (62.7% improvement)
> 
> With the patch, the throughput improved by 62.7%.

This is very impressive.

> 
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
> Reviewed-by: Feng Tang <feng.tang@intel.com>
> Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

Acked-by: Muchun Song <songmuchun@bytedance.com>

Thanks.
