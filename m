Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C567B649382
	for <lists+netdev@lfdr.de>; Sun, 11 Dec 2022 11:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiLKKMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 05:12:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLKKMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 05:12:13 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 49208C77F;
        Sun, 11 Dec 2022 02:12:09 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 00/12] Netfilter/IPVS updates for net-next
Date:   Sun, 11 Dec 2022 11:11:52 +0100
Message-Id: <20221211101204.1751-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter/IPVS updates for net-next:

1) Incorrect error check in nft_expr_inner_parse(), from Dan Carpenter.

2) Add DATA_SENT state to SCTP connection tracking helper, from
   Sriram Yagnaraman.

3) Consolidate nf_confirm for ipv4 and ipv6, from Florian Westphal.

4) Add bitmask support for ipset, from Vishwanath Pai.

5) Handle icmpv6 redirects as RELATED, from Florian Westphal.

6) Add WARN_ON_ONCE() to impossible case in flowtable datapath,
   from Li Qiong.

7) A large batch of IPVS updates to replace timer-based estimators by
   kthreads to scale up wrt. CPUs and workload (millions of estimators).

Julian Anastasov says:

	This patchset implements stats estimation in kthread context.
It replaces the code that runs on single CPU in timer context every 2
seconds and causing latency splats as shown in reports [1], [2], [3].
The solution targets setups with thousands of IPVS services,
destinations and multi-CPU boxes.

	Spread the estimation on multiple (configured) CPUs and multiple
time slots (timer ticks) by using multiple chains organized under RCU
rules.  When stats are not needed, it is recommended to use
run_estimation=0 as already implemented before this change.

RCU Locking:

- As stats are now RCU-locked, tot_stats, svc and dest which
hold estimator structures are now always freed from RCU
callback. This ensures RCU grace period after the
ip_vs_stop_estimator() call.

Kthread data:

- every kthread works over its own data structure and all
such structures are attached to array. For now we limit
kthreads depending on the number of CPUs.

- even while there can be a kthread structure, its task
may not be running, eg. before first service is added or
while the sysctl var is set to an empty cpulist or
when run_estimation is set to 0 to disable the estimation.

- the allocated kthread context may grow from 1 to 50
allocated structures for timer ticks which saves memory for
setups with small number of estimators

- a task and its structure may be released if all
estimators are unlinked from its chains, leaving the
slot in the array empty

- every kthread data structure allows limited number
of estimators. Kthread 0 is also used to initially
calculate the max number of estimators to allow in every
chain considering a sub-100 microsecond cond_resched
rate. This number can be from 1 to hundreds.

- kthread 0 has an additional job of optimizing the
adding of estimators: they are first added in
temp list (est_temp_list) and later kthread 0
distributes them to other kthreads. The optimization
is based on the fact that newly added estimator
should be estimated after 2 seconds, so we have the
time to offload the adding to chain from controlling
process to kthread 0.

- to add new estimators we use the last added kthread
context (est_add_ktid). The new estimators are linked to
the chains just before the estimated one, based on add_row.
This ensures their estimation will start after 2 seconds.
If estimators are added in bursts, common case if all
services and dests are initially configured, we may
spread the estimators to more chains and as result,
reducing the initial delay below 2 seconds.

Many thanks to Jiri Wiesner for his valuable comments
and for spending a lot of time reviewing and testing
the changes on different platforms with 48-256 CPUs and
1-8 NUMA nodes under different cpufreq governors.

The new IPVS estimators do not use workqueue infrastructure
because:

- The estimation can take long time when using multiple IPVS rules (eg.
  millions estimator structures) and especially when box has multiple
  CPUs due to the for_each_possible_cpu usage that expects packets from
  any CPU. With est_nice sysctl we have more control how to prioritize the
  estimation kthreads compared to other processes/kthreads that have
  latency requirements (such as servers). As a benefit, we can see these
  kthreads in top and decide if we will need some further control to limit
  their CPU usage (max number of structure to estimate per kthread).

- with kthreads we run code that is read-mostly, no write/lock
  operations to process the estimators in 2-second intervals.

- work items are one-shot: as estimators are processed every
  2 seconds, they need to be re-added every time. This again
  loads the timers (add_timer) if we use delayed works, as there are
  no kthreads to do the timings.

[1] Report from Yunhong Jiang:
    https://lore.kernel.org/netdev/D25792C1-1B89-45DE-9F10-EC350DC04ADC@gmail.com/
[2] https://marc.info/?l=linux-virtual-server&m=159679809118027&w=2
[3] Report from Dust:
    https://archive.linuxvirtualserver.org/html/lvs-devel/2020-12/msg00000.html

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git

Thanks.

----------------------------------------------------------------

The following changes since commit 339e79dfb087075cbc27d3a902457574c4dac182:

  Merge branch 'cleanup-ocelot_stats-exposure' (2022-11-22 15:36:46 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git HEAD

for you to fetch changes up to 144361c1949f227df9244302da02c258a363b674:

  ipvs: run_estimation should control the kthread tasks (2022-12-10 22:44:43 +0100)

----------------------------------------------------------------
Dan Carpenter (1):
      netfilter: nft_inner: fix IS_ERR() vs NULL check

Florian Westphal (2):
      netfilter: conntrack: merge ipv4+ipv6 confirm functions
      netfilter: conntrack: set icmpv6 redirects as RELATED

Julian Anastasov (6):
      ipvs: add rcu protection to stats
      ipvs: use common functions for stats allocation
      ipvs: use u64_stats_t for the per-cpu counters
      ipvs: use kthreads for stats estimation
      ipvs: add est_cpulist and est_nice sysctl vars
      ipvs: run_estimation should control the kthread tasks

Li Qiong (1):
      netfilter: flowtable: add a 'default' case to flowtable datapath

Sriram Yagnaraman (1):
      netfilter: conntrack: add sctp DATA_SENT state

Vishwanath Pai (1):
      netfilter: ipset: Add support for new bitmask parameter

 Documentation/networking/ipvs-sysctl.rst           |  24 +-
 include/linux/netfilter/ipset/ip_set.h             |  10 +
 include/net/ip_vs.h                                | 171 +++-
 include/net/netfilter/nf_conntrack_core.h          |   3 +-
 include/uapi/linux/netfilter/ipset/ip_set.h        |   2 +
 include/uapi/linux/netfilter/nf_conntrack_sctp.h   |   1 +
 include/uapi/linux/netfilter/nfnetlink_cttimeout.h |   1 +
 net/bridge/netfilter/nf_conntrack_bridge.c         |  32 +-
 net/netfilter/ipset/ip_set_hash_gen.h              |  71 +-
 net/netfilter/ipset/ip_set_hash_ip.c               |  19 +-
 net/netfilter/ipset/ip_set_hash_ipport.c           |  24 +-
 net/netfilter/ipset/ip_set_hash_netnet.c           |  26 +-
 net/netfilter/ipvs/ip_vs_core.c                    |  40 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     | 448 +++++++++--
 net/netfilter/ipvs/ip_vs_est.c                     | 882 +++++++++++++++++++--
 net/netfilter/nf_conntrack_proto.c                 | 124 ++-
 net/netfilter/nf_conntrack_proto_icmpv6.c          |  53 ++
 net/netfilter/nf_conntrack_proto_sctp.c            | 104 ++-
 net/netfilter/nf_conntrack_standalone.c            |   8 +
 net/netfilter/nf_flow_table_ip.c                   |   8 +
 net/netfilter/nf_tables_api.c                      |   4 +-
 .../selftests/netfilter/conntrack_icmp_related.sh  |  36 +-
 22 files changed, 1731 insertions(+), 360 deletions(-)
