Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33AA64A9173
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 01:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356196AbiBDAKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 19:10:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356170AbiBDAKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 19:10:42 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938ADC061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 16:10:42 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id 77so813992pgc.0
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 16:10:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=xHptnaDU8SEzmk9iWtjo28qNFBKlkNC/jqODiTe7seY=;
        b=RZaTvu4yBfk11OBlw/tccquN8uhkP1ZXJfEuTqTB63SRZASNFG7dKNH40cHMftMzw9
         4ThbP21GszkP7XIuul/xckQukhwaF9iZvXxYd1J0006bnr0WMUyPAzvkw3xEdNhx8MGS
         QPmXvlTM8J8qK64pL/FOiA4j16HjfZqk+7F88=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xHptnaDU8SEzmk9iWtjo28qNFBKlkNC/jqODiTe7seY=;
        b=AEYlGIicCs5klRFKjeSwaoweb2L3iBJwLQNgqTVeFNWvSbMeAi8DYho2PeQfwgzPgO
         g6K1BG9fPoRbEwUyMf0BCHfzd0MncEpqKhoh65SYllqOn0XaTehwLgLmiZwMaSsWn8C9
         p88XTxsJ8Iruch1Rs1LobDqCsfGW3hqyZPTMmQp5IllMTiPousrSjVb25sRbhv+p4Jnb
         2jnHtF3IPo3GpsnOpiZ9/IgqJJkO10h2Eggmtu78n115qBGOBp3MIisxhj7EECHtXI6I
         H+8pnkNDtK8yWX0kj2uo14J+7T+01Ge8zw1PG5VZygLq2s6KwnY+SFSxag+31ouFwshP
         3fjw==
X-Gm-Message-State: AOAM5301FLr8NkLOKxvXzqU0YsT5rvcd+3sPQlXg/CiY44VpKGYBf2re
        OCB4ctPgcIEl7Wv5rZ4BnWPeLiqRAXwruhuM2IBC7xh1PRdgUKr9+9mq571asle/iiRtHpEt+nb
        oG7T4ed00CH2h3ldsxhr9PWp92n3aln23MTmouOsq8xJjsrIF4u/DXxHELWTWkyfTrwQ6
X-Google-Smtp-Source: ABdhPJzPsQ51upH5s6vSDXal0uBEQQa+1MjtjMmPMS51XrWpyVA4Symx2Yaj0m+9OLcYLCJhnpEUHQ==
X-Received: by 2002:aa7:96bb:: with SMTP id g27mr574412pfk.43.1643933441510;
        Thu, 03 Feb 2022 16:10:41 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id z22sm159822pfe.42.2022.02.03.16.10.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Feb 2022 16:10:40 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        saeed@kernel.org, ttoukan.linux@gmail.com, brouer@redhat.com
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v4 00/11] page_pool: Add page_pool stat counters
Date:   Thu,  3 Feb 2022 16:09:22 -0800
Message-Id: <1643933373-6590-1-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings:

Welcome to v4.

This revision changes stats to be per-cpu and per-pool after getting
feedback from Ilias, Tariq, and Jesper.

This revision exposes a single API: page_pool_get_stats which fills in a
caller provided struct page_pool_stats with the summed per-cpu stats for
the specified pool. The intention is that drivers will use this API to
access pool stats so that they can be exposed to the user via ethtool,
debugfs, etc.

I chose this method because pulling struct page_pool_stats into page_pool.c
would require exposing a large number of APIs for accessing individual
field values. The obvious downside is that changing the struct fields could
break driver code. I don't have a strong sense for what the page_pool
maintainers would prefer, so I chose the simplest thing for v4.

I re-ran the benchmarks using a larger number of loops and cpus, as
documented below. I've summarized the results below; links to the raw
output with this series applied with stats off [1] and stats on [2] are
included for examination.

Test system:
	- 2x Intel(R) Xeon(R) Gold 6140 CPU @ 2.30GHz
	- 2 NUMA zones, with 18 cores per zone and 2 threads per core

bench_page_pool_simple results, loops=200000000
test name			stats enabled		stats disabled
				cycles	nanosec		cycles	nanosec

for_loop			0	0.335		0	0.336
atomic_inc 			14	6.209		13	6.027
lock				31	13.571		31	13.935

no-softirq-page_pool01		70	30.783		68	29.959
no-softirq-page_pool02		73	32.124		72	31.412
no-softirq-page_pool03		112	49.060		108	47.373

tasklet_page_pool01_fast_path	14	6.413		13	5.833
tasklet_page_pool02_ptr_ring	41	17.939		39	17.370
tasklet_page_pool03_slow	110	48.179		108	47.173

bench_page_pool_cross_cpu results, loops=20000000 returning_cpus=4:
test name			stats enabled		stats disabled
				cycles	nanosec		cycles	nanosec

page_pool_cross_cpu CPU(0)	4101	1787.639	3990	1739.178
page_pool_cross_cpu CPU(1)	4107	1790.281	3987	1737.756
page_pool_cross_cpu CPU(2)	4102	1787.777	3991	1739.731
page_pool_cross_cpu CPU(3)	4108	1790.455	3991	1739.703
page_pool_cross_cpu CPU(4)	1027	447.614		997	434.933

page_pool_cross_cpu average	3489	-		3391	-

Thanks.

[1]: https://gist.githubusercontent.com/jdamato-fsly/343814d33ed75372e98782b796b607a4/raw/9f440a0b38f3eff37b76b914934620625172a0f4/v4%2520with%2520stats%2520off
[2]: https://gist.githubusercontent.com/jdamato-fsly/343814d33ed75372e98782b796b607a4/raw/9f440a0b38f3eff37b76b914934620625172a0f4/v4%2520with%2520stats%2520on

v3 -> v4:
	- Restructured stats to be per-cpu per-pool.
	- Global stats and proc file were removed.
	- Exposed an API (page_pool_get_stats) for batching the pool stats.

v2 -> v3:
	- patch 8/10 ("Add stat tracking cache refill") fixed placement of
	  counter increment.
	- patch 10/10 ("net-procfs: Show page pool stats in proc") updated:
		- fix unused label warning from kernel test robot,
		- fixed page_pool_seq_show to only display the refill stat
		  once,
		- added a remove_proc_entry for page_pool_stat to
		  dev_proc_net_exit.

v1 -> v2:
	- A new kernel config option has been added, which defaults to N,
	   preventing this code from being compiled in by default
	- The stats structure has been converted to a per-cpu structure
	- The stats are now exported via proc (/proc/net/page_pool_stat)

Joe Damato (11):
  page_pool: kconfig: Add flag for page pool stats
  page_pool: Add per-pool-per-cpu struct.
  page_pool: Allocate and free stats structure
  page_pool: Add macro for incrementing alloc stats
  page_pool: Add fast path stat
  page_pool: Add slow path order-0 stat
  page_pool: Add slow path high order alloc stat
  page_pool: Add stat tracking empty ring
  page_pool: Add stat tracking cache refill
  page_pool: Add a stat tracking waived pages
  page_pool: Add function to batch and return stats

 include/net/page_pool.h | 27 +++++++++++++++++++++
 net/Kconfig             | 12 ++++++++++
 net/core/page_pool.c    | 64 +++++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 99 insertions(+), 4 deletions(-)

-- 
2.7.4

