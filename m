Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9D3158BB0
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 10:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbgBKJTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 04:19:39 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:50207 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727682AbgBKJTj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 04:19:39 -0500
Received: from Internal Mail-Server by MTLPINE2 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 11 Feb 2020 11:19:37 +0200
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 01B9Jbgt031153;
        Tue, 11 Feb 2020 11:19:37 +0200
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        pablo@netfilter.org, marcelo.leitner@gmail.com,
        Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH net-next 0/4] Remove rtnl lock dependency from flow_action infra
Date:   Tue, 11 Feb 2020 11:19:14 +0200
Message-Id: <20200211091918.20974-1-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, TC flow_action infrastructure code obtain rtnl lock before
accessing action state in tc_setup_flow_action() function and releases
it afterwards. This behavior is not supposed to impact TC filter
insertion rate because filling flow_action representation is only a
small part of creating new filter and expensive operations (hardware
offload callbacks, classifiers, cls API code that creates chains and
classifiers instances) already support unlocked execution. However,
typical vswitch implementation might need to also dump TC filters
concurrently, for example to age out unused flows or update flow
counters. TC dump is fully serialized and holds rtnl lock during its
whole execution in kernel space. As such, it can significantly impact
concurrent tasks that try to intermittently obtain rtnl lock when
filling intermediate representation for new filter offload (performance
evaluation at the end of this mail).

Refactor flow_action cls API infrastructure and its dependencies to not
rely on rtnl lock for synchronization. Patch set overview:

- Refactor tc_setup_flow_action() to obtain action tcf_lock when
  accessing action state. Fix its dependencies to not obtain tcf_lock
  themselves and assume that caller already holds it (needs to be done
  in same patch to prevent deadlock) and not to call sleeping functions
  (needs to be done in same patch to prevent "sleeping while atomic"
  dmesg warnings).

- Refactor action helper functions to require tcf_lock instead of rtnl.
  Internally, all of the actions already use tcf_lock for
  synchronization to accommodate unlocked classifier API, so this change
  relies on already existing functionality.

- Remove rtnl lock and "rtnl_held" argument from tc_setup_flow_action()
  function.


To test the change, multiple concurrent TC instances are invoked with
following command:

time ls add* | xargs -n 1 -P 100 sudo tc -b

Ten batch files with following typical rules (100k each) are used:

filter add dev ens1f0_0 protocol ip ingress prio 1 handle 1 flower
	src_mac e4:11:0:0:0:0 dst_mac e4:12:0:0:0:0 src_ip 192.168.111.1
	dst_ip 192.168.111.2 ip_proto udp dst_port 1 src_port 1 action
	tunnel_key set id 1 src_ip 2.2.2.2 dst_ip 2.2.2.3 dst_port 4789
	no_percpu action mirred egress redirect dev vxlan1 no_percpu

TC dump of same device is called in infinite loop from five concurrent
instances:

while true do tc -s filter show dev $NIC ingress >/dev/null done

Results obtained on current net-next commit 9f68e3655aae ("Merge tag
'drm-next-2020-01-30' of git://anongit.freedesktop.org/drm/drm"):

               | net-next | this change 
---------------+----------+-------------
 TC add        | 6.3s     | 6.3s        
 TC add + dump | 29.3s    | 6.8s        

Test results confirm significant impact of concurrent TC dump. The
impact is almost fully mitigated by proposed change (differences can be
attributed to contention for chain and tp locks between add and dump TC
instances).

Vlad Buslov (4):
  net: sched: lock action when translating it to flow_action infra
  net: sched: refactor police action helpers to require tcf_lock
  net: sched: refactor ct action helpers to require tcf_lock
  net: sched: don't take rtnl lock during flow_action setup

 include/net/pkt_cls.h              |  2 +-
 include/net/tc_act/tc_ct.h         |  6 ++++--
 include/net/tc_act/tc_police.h     |  6 ++++--
 include/net/tc_act/tc_tunnel_key.h |  2 +-
 net/sched/act_sample.c             |  2 --
 net/sched/cls_api.c                | 25 ++++++++++++-------------
 net/sched/cls_flower.c             |  6 ++----
 net/sched/cls_matchall.c           |  4 ++--
 8 files changed, 26 insertions(+), 27 deletions(-)

-- 
2.21.0

