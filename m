Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41ED2211301
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 20:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgGASrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 14:47:32 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:39063 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726441AbgGASr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 14:47:28 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from lariel@mellanox.com)
        with SMTP; 1 Jul 2020 21:47:25 +0300
Received: from gen-l-vrt-029.mtl.labs.mlnx (gen-l-vrt-029.mtl.labs.mlnx [10.237.29.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 061IlPe1000637;
        Wed, 1 Jul 2020 21:47:25 +0300
From:   Ariel Levkovich <lariel@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        Ariel Levkovich <lariel@mellanox.com>
Subject: [PATCH net-next v2 0/3] ] TC datapath hash api
Date:   Wed,  1 Jul 2020 21:47:16 +0300
Message-Id: <20200701184719.8421-1-lariel@mellanox.com>
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

The api allows user to define a filter with a tc hash action
where the hash function can be standard asymetric hashing that Linux
offers or alternatively user can provide a bpf program that
performs hash calculation on a packet.

Usage is as follows:

$ tc filter add dev ens1f0_0 ingress \
prio 1 chain 0 proto ip \
flower ip_proto tcp \
action hash bpf object-file <file> \
action goto chain 2

$ tc filter add dev ens1f0_0 ingress \
prio 1 chain 0 proto ip \
flower ip_proto udp \
action hash bpf asym_l4 basis <basis> \
action goto chain 2

$ tc filter add dev ens1f0_0 ingress \
prio 1 chain 2 proto ip \
flower hash 0x0/0xf  \
action mirred egress redirect dev ens1f0_1

$ tc filter add dev ens1f0_0 ingress \
prio 1 chain 2 proto ip \
flower hash 0x1/0xf  \
action mirred egress redirect dev ens1f0_2

Ariel Levkovich (3):
  net/sched: Introduce action hash
  net/flow_dissector: add packet hash dissection
  net/sched: cls_flower: Add hash info to flow classification

 include/linux/skbuff.h              |   4 +
 include/net/act_api.h               |   2 +
 include/net/flow_dissector.h        |   9 +
 include/net/tc_act/tc_hash.h        |  22 ++
 include/uapi/linux/pkt_cls.h        |   4 +
 include/uapi/linux/tc_act/tc_hash.h |  32 +++
 net/core/flow_dissector.c           |  17 ++
 net/sched/Kconfig                   |  11 +
 net/sched/Makefile                  |   1 +
 net/sched/act_hash.c                | 389 ++++++++++++++++++++++++++++
 net/sched/cls_api.c                 |   1 +
 net/sched/cls_flower.c              |  16 ++
 12 files changed, 508 insertions(+)
 create mode 100644 include/net/tc_act/tc_hash.h
 create mode 100644 include/uapi/linux/tc_act/tc_hash.h
 create mode 100644 net/sched/act_hash.c

-- 
2.25.2

