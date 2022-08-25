Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8975A0532
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 02:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiHYAdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 20:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiHYAde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 20:33:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE0E8C474;
        Wed, 24 Aug 2022 17:33:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 684ED61A78;
        Thu, 25 Aug 2022 00:33:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40059C433C1;
        Thu, 25 Aug 2022 00:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661387611;
        bh=3yxsP6DawL5+lHuusAb977k18cNkRTLfgXocBtYSv1o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oGJkgMPUbZFMjG8O/7KdMb+vxZpJH+5niJeB5INpD8x3qYjLkUAwWFAEXr5JNN1eo
         Zvf29lZuGkCpHP0RE/bBdynwQoc8oxWiELrbP6kyLDky2jSG7ggF/8yGnTB04Gjxo1
         pMFYLznoGdT4pFmceHv0wgl291f+JjhUcTezFMoo=
Date:   Wed, 24 Aug 2022 17:33:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <songmuchun@bytedance.com>,
        =?ISO-8859-1?Q? "Michal_Koutn=FD" ?= <mkoutny@suse.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Feng Tang <feng.tang@intel.com>,
        Oliver Sang <oliver.sang@intel.com>, lkp@lists.01.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] mm: page_counter: rearrange struct page_counter
 fields
Message-Id: <20220824173330.2a15bcda24d2c3c248bc43c7@linux-foundation.org>
In-Reply-To: <20220825000506.239406-3-shakeelb@google.com>
References: <20220825000506.239406-1-shakeelb@google.com>
        <20220825000506.239406-3-shakeelb@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Aug 2022 00:05:05 +0000 Shakeel Butt <shakeelb@google.com> wrote:

> With memcg v2 enabled, memcg->memory.usage is a very hot member for
> the workloads doing memcg charging on multiple CPUs concurrently.
> Particularly the network intensive workloads. In addition, there is a
> false cache sharing between memory.usage and memory.high on the charge
> path. This patch moves the usage into a separate cacheline and move all
> the read most fields into separate cacheline.
> 
> To evaluate the impact of this optimization, on a 72 CPUs machine, we
> ran the following workload in a three level of cgroup hierarchy.
> 
>  $ netserver -6
>  # 36 instances of netperf with following params
>  $ netperf -6 -H ::1 -l 60 -t TCP_SENDFILE -- -m 10K
> 
> Results (average throughput of netperf):
> Without (6.0-rc1)	10482.7 Mbps
> With patch		12413.7 Mbps (18.4% improvement)
> 
> With the patch, the throughput improved by 18.4%.
> 
> One side-effect of this patch is the increase in the size of struct
> mem_cgroup. For example with this patch on 64 bit build, the size of
> struct mem_cgroup increased from 4032 bytes to 4416 bytes. However for
> the performance improvement, this additional size is worth it. In
> addition there are opportunities to reduce the size of struct
> mem_cgroup like deprecation of kmem and tcpmem page counters and
> better packing.

Did you evaluate the effects of using a per-cpu counter of some form?
