Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1709D0EE
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 15:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732105AbfHZNp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 09:45:26 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:52959 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732054AbfHZNpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 09:45:25 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 26 Aug 2019 16:45:14 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7QDjEFO000366;
        Mon, 26 Aug 2019 16:45:14 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        pablo@netfilter.org, Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH net-next v3 00/10] Refactor cls hardware offload API to support rtnl-independent drivers
Date:   Mon, 26 Aug 2019 16:44:56 +0300
Message-Id: <20190826134506.9705-1-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, all cls API hardware offloads driver callbacks require caller
to hold rtnl lock when calling them. This patch set introduces new API
that allows drivers to register callbacks that are not dependent on rtnl
lock and unlocked classifiers to offload filters without obtaining rtnl
lock first, which is intended to allow offloading tc rules in parallel.

Recently, new rtnl registration flag RTNL_FLAG_DOIT_UNLOCKED was added.
TC rule update handlers (RTM_NEWTFILTER, RTM_DELTFILTER, etc.) are
already registered with this flag and only take rtnl lock when qdisc or
classifier requires it. Classifiers can indicate that their ops
callbacks don't require caller to hold rtnl lock by setting the
TCF_PROTO_OPS_DOIT_UNLOCKED flag. Unlocked implementation of flower
classifier is now upstreamed. However, this implementation still obtains
rtnl lock before calling hardware offloads API.

Implement following cls API changes:

- Introduce new "unlocked_driver_cb" flag to struct flow_block_offload
  to allow registering and unregistering block hardware offload
  callbacks that do not require caller to hold rtnl lock. Drivers that
  doesn't require users of its tc offload callbacks to hold rtnl lock
  sets the flag to true on block bind/unbind. Internally tcf_block is
  extended with additional lockeddevcnt counter that is used to count
  number of devices that require rtnl lock that block is bound to. When
  this counter is zero, tc_setup_cb_*() functions execute callbacks
  without obtaining rtnl lock.

- Extend cls API single hardware rule update tc_setup_cb_call() function
  with tc_setup_cb_add(), tc_setup_cb_replace(), tc_setup_cb_destroy()
  and tc_setup_cb_reoffload() functions. These new APIs are needed to
  move management of block offload counter, filter in hardware counter
  and flag from classifier implementations to cls API, which is now
  responsible for managing them in concurrency-safe manner. Access to
  cb_list from callback execution code is synchronized by obtaining new
  'cb_lock' rw_semaphore in read mode, which allows executing callbacks
  in parallel, but excludes any modifications of data from
  register/unregister code. tcf_block offloads counter type is changed
  to atomic integer to allow updating the counter concurrently.

- Extend classifier ops with new ops->hw_add() and ops->hw_del()
  callbacks which are used to notify unlocked classifiers when filter is
  successfully added or deleted to hardware without releasing cb_lock.
  This is necessary to update classifier state atomically with callback
  list traversal and updating of all relevant counters and allows
  unlocked classifiers to synchronize with concurrent reoffload without
  requiring any changes to driver callback API implementations.

New tc flow_action infrastructure is also modified to allow its user to
execute without rtnl lock protection. Function tc_setup_flow_action() is
modified to conditionally obtain rtnl lock before accessing action
state. Action data that is accessed by reference is either copied or
reference counted to prevent concurrent action overwrite from
deallocating it. New function tc_cleanup_flow_action() is introduced to
cleanup/release all such data obtained by tc_setup_flow_action().

Flower classifier (only unlocked classifier at the moment) is modified
to use new cls hardware offloads API and no longer obtains rtnl lock
before calling it.

Vlad Buslov (10):
  net: sched: protect block offload-related fields with rw_semaphore
  net: sched: change tcf block offload counter type to atomic_t
  net: sched: refactor block offloads counter usage
  net: sched: notify classifier on successful offload add/delete
  net: sched: add API for registering unlocked offload block callbacks
  net: sched: conditionally obtain rtnl lock in cls hw offloads API
  net: sched: take rtnl lock in tc_setup_flow_action()
  net: sched: take reference to action dev before calling offloads
  net: sched: copy tunnel info when setting flow_action entry->tunnel
  net: sched: flower: don't take rtnl lock for cls hw offloads API

 .../net/ethernet/mellanox/mlx5/core/en_main.c |   2 +
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |   3 +
 include/net/flow_offload.h                    |   1 +
 include/net/pkt_cls.h                         |  21 +-
 include/net/sch_generic.h                     |  41 +--
 include/net/tc_act/tc_tunnel_key.h            |  17 +
 net/sched/cls_api.c                           | 343 +++++++++++++++++-
 net/sched/cls_bpf.c                           |  38 +-
 net/sched/cls_flower.c                        | 124 +++----
 net/sched/cls_matchall.c                      |  31 +-
 net/sched/cls_u32.c                           |  29 +-
 11 files changed, 478 insertions(+), 172 deletions(-)

-- 
2.21.0

