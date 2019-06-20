Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA914CF33
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 15:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731954AbfFTNmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 09:42:36 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:43629 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731743AbfFTNme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 09:42:34 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 20 Jun 2019 16:42:29 +0300
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (reg-r-vrt-019-180.mtr.labs.mlnx [10.213.19.180])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x5KDgSlL022418;
        Thu, 20 Jun 2019 16:42:28 +0300
From:   Paul Blakey <paulb@mellanox.com>
To:     Jiri Pirko <jiri@mellanox.com>, Paul Blakey <paulb@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>
Cc:     Rony Efraim <ronye@mellanox.com>, nst-kernel@redhat.com,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>
Subject: [PATCH net-next v2 0/4] net/sched: Introduce tc connection tracking
Date:   Thu, 20 Jun 2019 16:42:17 +0300
Message-Id: <1561038141-31370-1-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patch series add connection tracking capabilities in tc sw datapath.
It does so via a new tc action, called act_ct, and new tc flower classifier matching
on conntrack state, mark and label.

Usage is as follows:
$ tc qdisc add dev ens1f0_0 ingress
$ tc qdisc add dev ens1f0_1 ingress

$ tc filter add dev ens1f0_0 ingress \
  prio 1 chain 0 proto ip \
  flower ip_proto tcp ct_state -trk \
  action ct zone 2 pipe \
  action goto chain 2
$ tc filter add dev ens1f0_0 ingress \
  prio 1 chain 2 proto ip \
  flower ct_state +trk+new \
  action ct zone 2 commit mark 0xbb nat src addr 5.5.5.7 pipe \
  action mirred egress redirect dev ens1f0_1
$ tc filter add dev ens1f0_0 ingress \
  prio 1 chain 2 proto ip \
  flower ct_zone 2 ct_mark 0xbb ct_state +trk+est \
  action ct nat pipe \
  action mirred egress redirect dev ens1f0_1

$ tc filter add dev ens1f0_1 ingress \
  prio 1 chain 0 proto ip \
  flower ip_proto tcp ct_state -trk \
  action ct zone 2 pipe \
  action goto chain 1
$ tc filter add dev ens1f0_1 ingress \
  prio 1 chain 1 proto ip \
  flower ct_zone 2 ct_mark 0xbb ct_state +trk+est \
  action ct nat pipe \
  action mirred egress redirect dev ens1f0_0

The pattern used in the design here closely resembles OvS, as the plan is to also offload
OvS conntrack rules to tc. OvS datapath rules uses it's recirculation mechanism to send
specific packets to conntrack, and return with the new conntrack state (ct_state) on some other recirc_id
to be matched again (we use goto chain for this).

This results in the following OvS datapath rules:

recirc_id(0),in_port(ens1f0_0),ct_state(-trk),... actions:ct(zone=2),recirc(2)
recirc_id(2),in_port(ens1f0_0),ct_state(+new+trk),ct_mark(0xbb),... actions:ct(commit,zone=2,nat(src=5.5.5.7),mark=0xbb),ens1f0_1
recirc_id(2),in_port(ens1f0_0),ct_state(+est+trk),ct_mark(0xbb),... actions:ct(zone=2,nat),ens1f0_1

recirc_id(1),in_port(ens1f0_1),ct_state(-trk),... actions:ct(zone=2),recirc(1)
recirc_id(1),in_port(ens1f0_1),ct_state(+est+trk),... actions:ct(zone=2,nat),ens1f0_0

Changelog:
	See individual patches.

Paul Blakey (4):
  net/sched: Introduce action ct
  net/flow_dissector: add connection tracking dissection
  net/sched: cls_flower: Add matching on conntrack info
  tc-tests: Add tc action ct tests

 include/linux/skbuff.h                             |  10 +
 include/net/flow_dissector.h                       |  15 +
 include/net/flow_offload.h                         |   5 +
 include/net/tc_act/tc_ct.h                         |  64 ++
 include/uapi/linux/pkt_cls.h                       |  17 +
 include/uapi/linux/tc_act/tc_ct.h                  |  41 +
 net/core/flow_dissector.c                          |  44 +
 net/sched/Kconfig                                  |  11 +
 net/sched/Makefile                                 |   1 +
 net/sched/act_ct.c                                 | 978 +++++++++++++++++++++
 net/sched/cls_api.c                                |   5 +
 net/sched/cls_flower.c                             | 127 ++-
 .../selftests/tc-testing/tc-tests/actions/ct.json  | 314 +++++++
 13 files changed, 1627 insertions(+), 5 deletions(-)
 create mode 100644 include/net/tc_act/tc_ct.h
 create mode 100644 include/uapi/linux/tc_act/tc_ct.h
 create mode 100644 net/sched/act_ct.c
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/actions/ct.json

-- 
1.8.3.1

