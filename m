Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6B821C66A
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 23:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgGKV2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 17:28:52 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:47964 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726779AbgGKV2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 17:28:52 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from lariel@mellanox.com)
        with SMTP; 12 Jul 2020 00:28:49 +0300
Received: from gen-l-vrt-029.mtl.labs.mlnx (gen-l-vrt-029.mtl.labs.mlnx [10.237.29.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 06BLSn21028048;
        Sun, 12 Jul 2020 00:28:49 +0300
From:   Ariel Levkovich <lariel@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        Ariel Levkovich <lariel@mellanox.com>
Subject: [PATCH net-next v3 0/4] ] TC datapath hash api
Date:   Sun, 12 Jul 2020 00:28:44 +0300
Message-Id: <20200711212848.20914-1-lariel@mellanox.com>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Supporting datapath hash allows user to set up rules that provide
load balancing of traffic across multiple vports and for ECMP path
selection while keeping the number of rule at minimum.

Instead of matching on exact flow spec, which requires a rule per
flow, user can define rules based on hashing on the packet headers
and distribute the flows to different buckets. The number of rules
in this case will be constant and equal to the number of buckets.

The datapath hash functionality is achieved in two steps -
performing the hash action and then matching on the result, as
part of the packet's classification.

To compute the hash value, the api offers 2 methods:
1. Linux implementation of an asymmetric hash algorithm
which is performed on the L4 headers of the packet.
This method is usable via an extention to act_skbedit and
allows user to provide a basis value to be included in
the computation.

2. User provided bpf program that implements
a hash computation algorithm. This option is usable
via a new type of tc action - action_hash.

Through both methods, the hash value is calculated
and stored in the skb->hash field so it can be matched
later as a key in the cls flower classifier.
where the hash function can be standard asymetric hashing that Linux
offers or alternatively user can provide a bpf program that
performs hash calculation on a packet.

Usage is as follows:

For hash calculation:
$ tc filter add dev ens1f0_0 ingress \
prio 1 chain 0 proto ip \
flower ip_proto tcp \
action hash object-file <file> section <hash_section>\
action goto chain 2

Or:

$ tc filter add dev ens1f0_0 ingress \
prio 1 chain 0 proto ip \
flower ip_proto udp \
action skbedit hash asym_l4 basis <basis> \
action goto chain 2

Matching on hash result:

$ tc filter add dev ens1f0_0 ingress \
prio 1 chain 2 proto ip \
flower hash 0x0/0xf  \
action mirred egress redirect dev ens1f0_1

$ tc filter add dev ens1f0_0 ingress \
prio 1 chain 2 proto ip \
flower hash 0x1/0xf  \
action mirred egress redirect dev ens1f0_2


v2 -> v3:
 *Split hash algorithm option into 2 different actions.
  Asym_l4 available via act_skbedit and bpf via new act_hash.

Ariel Levkovich (4):
  net/sched: Add skb->hash field editing via act_skbedit
  net/sched: Introduce action hash
  net/flow_dissector: add packet hash dissection
  net/sched: cls_flower: Add hash info to flow classification

 include/linux/skbuff.h                 |   4 +
 include/net/act_api.h                  |   2 +
 include/net/flow_dissector.h           |   9 +
 include/net/tc_act/tc_hash.h           |  20 ++
 include/net/tc_act/tc_skbedit.h        |   2 +
 include/uapi/linux/pkt_cls.h           |   4 +
 include/uapi/linux/tc_act/tc_hash.h    |  25 ++
 include/uapi/linux/tc_act/tc_skbedit.h |   7 +
 net/core/flow_dissector.c              |  17 ++
 net/sched/Kconfig                      |  11 +
 net/sched/Makefile                     |   1 +
 net/sched/act_hash.c                   | 348 +++++++++++++++++++++++++
 net/sched/act_skbedit.c                |  38 +++
 net/sched/cls_api.c                    |   1 +
 net/sched/cls_flower.c                 |  16 ++
 15 files changed, 505 insertions(+)
 create mode 100644 include/net/tc_act/tc_hash.h
 create mode 100644 include/uapi/linux/tc_act/tc_hash.h
 create mode 100644 net/sched/act_hash.c

-- 
2.25.2

