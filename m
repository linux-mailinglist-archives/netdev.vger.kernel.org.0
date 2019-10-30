Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB707E9D24
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 15:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfJ3OJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 10:09:24 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55248 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726284AbfJ3OJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 10:09:23 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 30 Oct 2019 16:09:15 +0200
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x9UE9EDa020747;
        Wed, 30 Oct 2019 16:09:14 +0200
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, mleitner@redhat.com, dcaratti@redhat.com,
        mrv@mojatatu.com, roopa@cumulusnetworks.com,
        Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH net-next v2 0/8] Control action percpu counters allocation by netlink flag
Date:   Wed, 30 Oct 2019 16:08:59 +0200
Message-Id: <20191030140907.18561-1-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, significant fraction of CPU time during TC filter allocation
is spent in percpu allocator. Moreover, percpu allocator is protected
with single global mutex which negates any potential to improve its
performance by means of recent developments in TC filter update API that
removed rtnl lock for some Qdiscs and classifiers. In order to
significantly improve filter update rate and reduce memory usage we
would like to allow users to skip percpu counters allocation for
specific action if they don't expect high traffic rate hitting the
action, which is a reasonable expectation for hardware-offloaded setup.
In that case any potential gains to software fast-path performance
gained by usage of percpu-allocated counters compared to regular integer
counters protected by spinlock are not important, but amount of
additional CPU and memory consumed by them is significant.

In order to allow configuring action counters allocation type at
runtime, implement following changes:

- Implement helper functions to update the action counters and use them
  in affected actions instead of updating counters directly. This steps
  abstracts actions implementation from counter types that are being
  used for particular action instance at runtime.

- Modify the new helpers to use percpu counters if they were allocated
  during action initialization and use regular counters otherwise.

- Extend action UAPI TCA_ACT space with TCA_ACT_FLAGS field. Add
  TCA_ACT_FLAGS_NO_PERCPU_STATS action flag and update
  hardware-offloaded actions to not allocate percpu counters when the
  flag is set.

With this changes users that prefer action update slow-path speed over
software fast-path speed can dynamically request actions to skip percpu
counters allocation without affecting other users.

Now, lets look at actual performance gains provided by this change.
Simple test is used to measure insertion rate - iproute2 TC is executed
in parallel by xargs in batch mode, its total execution time is measured
by shell builtin "time" command. The command runs 20 concurrent tc
instances, each with its own batch file with 100k rules:

$ time ls add* | xargs -n 1 -P 20 sudo tc -b

Two main rule profiles are tested. First is simple L2 flower classifier
with single gact drop action. The configuration is chosen as worst case
scenario because with single-action rules pressure on percpu allocator
is minimized. Example rule:

filter add dev ens1f0 protocol ip ingress prio 1 handle 1 flower skip_hw
    src_mac e4:11:0:0:0:0 dst_mac e4:12:0:0:0:0 action drop

Second profile is typical real-world scenario that uses flower
classifier with some L2-4 fields and two actions (tunnel_key+mirred).
Example rule:

filter add dev ens1f0_0 protocol ip ingress prio 1 handle 1 flower
    skip_hw src_mac e4:11:0:0:0:0 dst_mac e4:12:0:0:0:0 src_ip
    192.168.111.1 dst_ip 192.168.111.2 ip_proto udp dst_port 1 src_port
    1 action tunnel_key set id 1 src_ip 2.2.2.2 dst_ip 2.2.2.3 dst_port
    4789 action mirred egress redirect dev vxlan1

 Profile           |        percpu |     no_percpu | X improvement 
                   | (k rules/sec) | (k rules/sec) |               
-------------------+---------------+---------------+---------------
 Gact drop         |           203 |           259 |          1.28 
 tunnel_key+mirred |            92 |           204 |          2.22 

For simple drop action removing percpu allocation leads to ~25%
insertion rate improvement. Perf profiles highlights the bottlenecks.

Perf profile of run with percpu allocation (gact drop):

+ 89.11% 0.48% tc [kernel.vmlinux] [k] entry_SYSCALL_64
+ 88.58% 0.04% tc [kernel.vmlinux] [k] do_syscall_64
+ 87.50% 0.04% tc libc-2.29.so [.] __libc_sendmsg
+ 86.96% 0.04% tc [kernel.vmlinux] [k] __sys_sendmsg
+ 86.85% 0.01% tc [kernel.vmlinux] [k] ___sys_sendmsg
+ 86.60% 0.05% tc [kernel.vmlinux] [k] sock_sendmsg
+ 86.55% 0.12% tc [kernel.vmlinux] [k] netlink_sendmsg
+ 86.04% 0.13% tc [kernel.vmlinux] [k] netlink_unicast
+ 85.42% 0.03% tc [kernel.vmlinux] [k] netlink_rcv_skb
+ 84.68% 0.04% tc [kernel.vmlinux] [k] rtnetlink_rcv_msg
+ 84.56% 0.24% tc [kernel.vmlinux] [k] tc_new_tfilter
+ 75.73% 0.65% tc [cls_flower] [k] fl_change
+ 71.30% 0.03% tc [kernel.vmlinux] [k] tcf_exts_validate
+ 71.27% 0.13% tc [kernel.vmlinux] [k] tcf_action_init
+ 71.06% 0.01% tc [kernel.vmlinux] [k] tcf_action_init_1
+ 70.41% 0.04% tc [act_gact] [k] tcf_gact_init
+ 53.59% 1.21% tc [kernel.vmlinux] [k] __mutex_lock.isra.0
+ 52.34% 0.34% tc [kernel.vmlinux] [k] tcf_idr_create
- 51.23% 2.17% tc [kernel.vmlinux] [k] pcpu_alloc
  - 49.05% pcpu_alloc
    + 39.35% __mutex_lock.isra.0 4.99% memset_erms
    + 2.16% pcpu_alloc_area
  + 2.17% __libc_sendmsg
+ 45.89% 44.33% tc [kernel.vmlinux] [k] osq_lock
+ 9.94% 0.04% tc [kernel.vmlinux] [k] tcf_idr_check_alloc
+ 7.76% 0.00% tc [kernel.vmlinux] [k] tcf_idr_insert
+ 6.50% 0.03% tc [kernel.vmlinux] [k] tfilter_notify
+ 6.24% 6.11% tc [kernel.vmlinux] [k] mutex_spin_on_owner
+ 5.73% 5.32% tc [kernel.vmlinux] [k] memset_erms
+ 5.31% 0.18% tc [kernel.vmlinux] [k] tcf_fill_node

Here bottleneck is clearly in pcpu_alloc() function that takes more than
half CPU time, which is mostly wasted busy-waiting for internal percpu
allocator global lock.

With percpu allocation removed (gact drop):

+ 87.50% 0.51% tc [kernel.vmlinux] [k] entry_SYSCALL_64
+ 86.94% 0.07% tc [kernel.vmlinux] [k] do_syscall_64
+ 85.75% 0.04% tc libc-2.29.so [.] __libc_sendmsg
+ 85.00% 0.07% tc [kernel.vmlinux] [k] __sys_sendmsg
+ 84.84% 0.07% tc [kernel.vmlinux] [k] ___sys_sendmsg
+ 84.59% 0.01% tc [kernel.vmlinux] [k] sock_sendmsg
+ 84.58% 0.14% tc [kernel.vmlinux] [k] netlink_sendmsg
+ 83.95% 0.12% tc [kernel.vmlinux] [k] netlink_unicast
+ 83.34% 0.01% tc [kernel.vmlinux] [k] netlink_rcv_skb
+ 82.39% 0.12% tc [kernel.vmlinux] [k] rtnetlink_rcv_msg
+ 82.16% 0.25% tc [kernel.vmlinux] [k] tc_new_tfilter
+ 75.13% 0.84% tc [cls_flower] [k] fl_change
+ 69.92% 0.05% tc [kernel.vmlinux] [k] tcf_exts_validate
+ 69.87% 0.11% tc [kernel.vmlinux] [k] tcf_action_init
+ 69.61% 0.02% tc [kernel.vmlinux] [k] tcf_action_init_1
- 68.80% 0.10% tc [act_gact] [k] tcf_gact_init
  - 68.70% tcf_gact_init
    + 36.08% tcf_idr_check_alloc
    + 31.88% tcf_idr_insert
+ 63.72% 0.58% tc [kernel.vmlinux] [k] __mutex_lock.isra.0
+ 58.80% 56.68% tc [kernel.vmlinux] [k] osq_lock
+ 36.08% 0.04% tc [kernel.vmlinux] [k] tcf_idr_check_alloc
+ 31.88% 0.01% tc [kernel.vmlinux] [k] tcf_idr_insert

The gact actions (like all other actions types) are inserted in single
idr instance protected by global (per namespace) lock that becomes new
bottleneck with such simple rule profile and prevents achieving 2x+
performance increase that can be expected by looking at profiling data
for insertion action with percpu counter.

Perf profile of run with percpu allocation (tunnel_key+mirred):

+ 91.95% 0.21% tc [kernel.vmlinux] [k] entry_SYSCALL_64
+ 91.74% 0.06% tc [kernel.vmlinux] [k] do_syscall_64
+ 90.74% 0.01% tc libc-2.29.so [.] __libc_sendmsg
+ 90.52% 0.01% tc [kernel.vmlinux] [k] __sys_sendmsg
+ 90.50% 0.04% tc [kernel.vmlinux] [k] ___sys_sendmsg
+ 90.41% 0.02% tc [kernel.vmlinux] [k] sock_sendmsg
+ 90.38% 0.04% tc [kernel.vmlinux] [k] netlink_sendmsg
+ 90.10% 0.06% tc [kernel.vmlinux] [k] netlink_unicast
+ 89.76% 0.01% tc [kernel.vmlinux] [k] netlink_rcv_skb
+ 89.28% 0.04% tc [kernel.vmlinux] [k] rtnetlink_rcv_msg
+ 89.15% 0.03% tc [kernel.vmlinux] [k] tc_new_tfilter
+ 83.41% 0.33% tc [cls_flower] [k] fl_change
+ 81.17% 0.04% tc [kernel.vmlinux] [k] tcf_exts_validate
+ 81.13% 0.06% tc [kernel.vmlinux] [k] tcf_action_init
+ 81.04% 0.04% tc [kernel.vmlinux] [k] tcf_action_init_1
- 73.59% 2.16% tc [kernel.vmlinux] [k] pcpu_alloc
  - 71.42% pcpu_alloc
    + 61.41% __mutex_lock.isra.0 5.02% memset_erms
    + 2.93% pcpu_alloc_area
  + 2.16% __libc_sendmsg
+ 63.58% 0.17% tc [kernel.vmlinux] [k] tcf_idr_create
+ 63.40% 0.60% tc [kernel.vmlinux] [k] __mutex_lock.isra.0
+ 57.85% 56.38% tc [kernel.vmlinux] [k] osq_lock
+ 46.27% 0.13% tc [act_tunnel_key] [k] tunnel_key_init
+ 34.26% 0.02% tc [act_mirred] [k] tcf_mirred_init
+ 10.99% 0.00% tc [kernel.vmlinux] [k] dst_cache_init
+ 5.32% 5.11% tc [kernel.vmlinux] [k] memset_erms

With two times more actions pressure on percpu allocator doubles, so now
it takes ~74% of CPU execution time.

With percpu allocation removed (tunnel_key+mirred):

+ 86.02% 0.50% tc [kernel.vmlinux] [k] entry_SYSCALL_64
+ 85.51% 0.12% tc [kernel.vmlinux] [k] do_syscall_64
+ 84.40% 0.03% tc libc-2.29.so [.] __libc_sendmsg
+ 83.84% 0.03% tc [kernel.vmlinux] [k] __sys_sendmsg
+ 83.72% 0.01% tc [kernel.vmlinux] [k] ___sys_sendmsg
+ 83.56% 0.01% tc [kernel.vmlinux] [k] sock_sendmsg
+ 83.50% 0.08% tc [kernel.vmlinux] [k] netlink_sendmsg
+ 83.02% 0.17% tc [kernel.vmlinux] [k] netlink_unicast
+ 82.48% 0.00% tc [kernel.vmlinux] [k] netlink_rcv_skb
+ 81.89% 0.11% tc [kernel.vmlinux] [k] rtnetlink_rcv_msg
+ 81.71% 0.25% tc [kernel.vmlinux] [k] tc_new_tfilter
+ 73.99% 0.63% tc [cls_flower] [k] fl_change
+ 69.72% 0.00% tc [kernel.vmlinux] [k] tcf_exts_validate
+ 69.72% 0.09% tc [kernel.vmlinux] [k] tcf_action_init
+ 69.53% 0.05% tc [kernel.vmlinux] [k] tcf_action_init_1
+ 53.08% 0.91% tc [kernel.vmlinux] [k] __mutex_lock.isra.0
+ 45.52% 43.99% tc [kernel.vmlinux] [k] osq_lock
- 36.02% 0.21% tc [act_tunnel_key] [k] tunnel_key_init
  - 35.81% tunnel_key_init
    + 15.95% tcf_idr_check_alloc
    + 13.91% tcf_idr_insert
    - 4.70% dst_cache_init
      + 4.68% pcpu_alloc
+ 33.22% 0.04% tc [kernel.vmlinux] [k] tcf_idr_check_alloc
+ 32.34% 0.05% tc [act_mirred] [k] tcf_mirred_init
+ 28.24% 0.01% tc [kernel.vmlinux] [k] tcf_idr_insert
+ 7.79% 0.05% tc [kernel.vmlinux] [k] idr_alloc_u32
+ 7.67% 7.35% tc [kernel.vmlinux] [k] idr_get_free
+ 6.46% 6.22% tc [kernel.vmlinux] [k] mutex_spin_on_owner
+ 5.11% 0.05% tc [kernel.vmlinux] [k] tfilter_notify

With percpu allocation removed insertion rate is increased by ~120%.
Such rule profile scales much better than simple single action because
both types of actions were competing for single lock in percpu
allocator, but not for action idr lock, which is per-action. Note that
percpu allocator is still used by dst_cache in tunnel_key actions and
consumes 4.68% CPU time. Dst_cache seems like good opportunity for
further insertion rate optimization but is not addressed by this change.

Another improvement provided by this change is significantly reduced
memory usage. The test is implemented by sampling "used memory" value
from "vmstat -s" command output. Following table includes memory usage
measurements for same two configurations that were used for measuring
insertion rate:

 Profile           | Mem per rule | Mem per rule no_percpu | Less memory used 
                   |         (KB) |                   (KB) |             (KB) 
-------------------+--------------+------------------------+------------------
 Gact drop         |         3.91 |                   2.51 |              1.4 
 tunnel_key+mirred |         6.73 |                   3.91 |              2.8 

Results indicate that memory usage of percpu allocator per action is
~1.4 KB. Note that any measurements of percpu allocator memory usage is
inherently tied to particular setup since memory usage is linear to
number of cores in system. It is to be expected that on current top of
the line servers percpu allocator memory usage will be 2-5x more than on
24 CPUs setup that was used for testing.

Setup details: 2x Intel(R) Xeon(R) CPU E5-2620 v3 @ 2.40GHz, 32GB memory

Patches applied on top of net-next branch:

commit 2203cbf2c8b58a1e3bef98c47531d431d11639a0 (net-next) Author:
Russell King <rmk+kernel@armlinux.org.uk> Date: Tue Oct 15 11:38:39 2019
+0100

net: sfp: move fwnode parsing into sfp-bus layer

Changes V1 -> V2:

- Include memory measurements.

Vlad Buslov (8):
  net: sched: extract common action counters update code into function
  net: sched: extract bstats update code into function
  net: sched: extract qstats update code into functions
  net: sched: don't expose action qstats to skb_tc_reinsert()
  net: sched: modify stats helper functions to support regular stats
  net: sched: extend TCA_ACT space with TCA_ACT_FLAGS
  net: sched: update action implementations to support flags
  tc-testing: implement tests for new fast_init action flag

 include/net/act_api.h                         | 46 +++++++++++++++-
 include/net/sch_generic.h                     | 12 +---
 include/uapi/linux/pkt_cls.h                  |  5 ++
 net/sched/act_api.c                           | 55 ++++++++++++++++++-
 net/sched/act_bpf.c                           |  5 +-
 net/sched/act_connmark.c                      |  4 +-
 net/sched/act_csum.c                          | 10 ++--
 net/sched/act_ct.c                            | 16 ++----
 net/sched/act_ctinfo.c                        |  4 +-
 net/sched/act_gact.c                          | 21 +++----
 net/sched/act_ife.c                           |  5 +-
 net/sched/act_ipt.c                           | 12 ++--
 net/sched/act_mirred.c                        | 19 +++----
 net/sched/act_mpls.c                          |  5 +-
 net/sched/act_nat.c                           |  4 +-
 net/sched/act_pedit.c                         |  5 +-
 net/sched/act_police.c                        |  9 +--
 net/sched/act_sample.c                        |  4 +-
 net/sched/act_simple.c                        |  5 +-
 net/sched/act_skbedit.c                       |  4 +-
 net/sched/act_skbmod.c                        |  4 +-
 net/sched/act_tunnel_key.c                    |  9 +--
 net/sched/act_vlan.c                          | 16 +++---
 .../tc-testing/tc-tests/actions/csum.json     | 24 ++++++++
 .../tc-testing/tc-tests/actions/ct.json       | 24 ++++++++
 .../tc-testing/tc-tests/actions/gact.json     | 24 ++++++++
 .../tc-testing/tc-tests/actions/mirred.json   | 24 ++++++++
 .../tc-tests/actions/tunnel_key.json          | 24 ++++++++
 .../tc-testing/tc-tests/actions/vlan.json     | 24 ++++++++
 29 files changed, 321 insertions(+), 102 deletions(-)

-- 
2.21.0

