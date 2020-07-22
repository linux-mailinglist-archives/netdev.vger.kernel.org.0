Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34BB722A1BF
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 00:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732999AbgGVWEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 18:04:07 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58755 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728198AbgGVWEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 18:04:06 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from lariel@mellanox.com)
        with SMTP; 23 Jul 2020 01:04:00 +0300
Received: from gen-l-vrt-029.mtl.labs.mlnx (gen-l-vrt-029.mtl.labs.mlnx [10.237.29.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 06MM403Y015652;
        Thu, 23 Jul 2020 01:04:00 +0300
From:   Ariel Levkovich <lariel@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jiri@mellanox.com, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        Ariel Levkovich <lariel@mellanox.com>
Subject: [PATCH net-next v4 0/2] TC datapath hash api
Date:   Thu, 23 Jul 2020 01:02:59 +0300
Message-Id: <20200722220301.4575-1-lariel@mellanox.com>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hash based packet classification allows user to set up rules that
provide load balancing of traffic across multiple vports and
for ECMP path selection while keeping the number of rule at minimum.

Instead of matching on exact flow spec, which requires a rule per
flow, user can define rules based on a their hash value and distribute
the flows to different buckets. The number of rules
in this case will be constant and equal to the number of buckets.

The series introduces an extention to the cls flower classifier
and allows user to add rules that match on the hash value that
is stored in skb->hash while assuming the value was set prior to
the classification.

Setting the skb->hash can be done in various ways and is not defined
in this series - for example:
1. By the device driver upon processing an rx packet.
2. Using tc action bpf with a program which computes and sets the
skb->hash value.

$ tc filter add dev ens1f0_0 ingress \
prio 1 chain 2 proto ip \
flower hash 0x0/0xf  \
action mirred egress redirect dev ens1f0_1

$ tc filter add dev ens1f0_0 ingress \
prio 1 chain 2 proto ip \
flower hash 0x1/0xf  \
action mirred egress redirect dev ens1f0_2

v3 -> v4:
 *Drop hash setting code leaving only the classidication parts.
  Setting the hash will be possible via existing tc action bpf.

v2 -> v3:
 *Split hash algorithm option into 2 different actions.
  Asym_l4 available via act_skbedit and bpf via new act_hash.

Ariel Levkovich (2):
  net/flow_dissector: add packet hash dissection
  net/sched: cls_flower: Add hash info to flow classification

 include/linux/skbuff.h       |  4 ++++
 include/net/flow_dissector.h |  9 +++++++++
 include/uapi/linux/pkt_cls.h |  3 +++
 net/core/flow_dissector.c    | 17 +++++++++++++++++
 net/sched/cls_flower.c       | 16 ++++++++++++++++
 5 files changed, 49 insertions(+)

-- 
2.25.2

