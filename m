Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12FBA1D2E8C
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 13:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbgENLkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 07:40:43 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:39806 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726216AbgENLkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 07:40:42 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 14 May 2020 14:40:36 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 04EBeZKa031451;
        Thu, 14 May 2020 14:40:36 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, dcaratti@redhat.com, marcelo.leitner@gmail.com,
        Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH net-next 0/4] Implement filter terse dump mode support
Date:   Thu, 14 May 2020 14:40:22 +0300
Message-Id: <20200514114026.27047-1-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement support for terse dump mode which provides only essential
classifier/action info (handle, stats, cookie, etc.). Use new
TCA_DUMP_FLAGS_TERSE flag to prevent copying of unnecessary data from
kernel.

Implement classifier-action terse dump mode

Output rate of current upstream kernel TC filter dump implementation if
relatively low (~100k rules/sec depending on configuration). This
constraint impacts performance of software switch implementation that
rely on TC for their datapath implementation and periodically call TC
filter dump to update rules stats. Moreover, TC filter dump output a lot
of static data that don't change during the filter lifecycle (filter
key, specific action details, etc.) which constitutes significant
portion of payload on resulting netlink packets and increases amount of
syscalls necessary to dump all filters on particular Qdisc. In order to
significantly improve filter dump rate this patch sets implement new
mode of TC filter dump operation named "terse dump" mode. In this mode
only parameters necessary to identify the filter (handle, action cookie,
etc.) and data that can change during filter lifecycle (filter flags,
action stats, etc.) are preserved in dump output while everything else
is omitted.

Userspace API is implemented using new TCA_DUMP_FLAGS tlv with only
available flag value TCA_DUMP_FLAGS_TERSE. Internally, new API requires
individual classifier support (new tcf_proto_ops->terse_dump()
callback). Support for action terse dump is implemented in act API and
don't require changing individual action implementations.

The following table provides performance comparison between regular
filter dump and new terse dump mode for two classifier-action profiles:
one minimal config with L2 flower classifier and single gact action and
another heavier config with L2+5tuple flower classifier with
tunnel_key+mirred actions.

 Classifier-action type      |        dump |  terse dump | X improvement 
                             | (rules/sec) | (rules/sec) |               
-----------------------------+-------------+-------------+---------------
 L2 with gact                |       141.8 |       293.2 |          2.07 
 L2+5tuple tunnel_key+mirred |        76.4 |       198.8 |          2.60 

Benchmark details: to measure the rate tc filter dump and terse dump
commands are invoked on ingress Qdisc that have one million filters
configured using following commands.

> time sudo tc -s filter show dev ens1f0 ingress >/dev/null

> time sudo tc -s filter show terse dev ens1f0 ingress >/dev/null

Value in results table is calculated by dividing 1000000 total rules by
"real" time reported by time command.

Setup details: 2x Intel(R) Xeon(R) CPU E5-2620 v3 @ 2.40GHz, 32GB memory

Vlad Buslov (4):
  net: sched: introduce terse dump flag
  net: sched: implement terse dump support in act
  net: sched: cls_flower: implement terse dump support
  selftests: implement flower classifier terse dump tests

 include/net/act_api.h                         |  2 +-
 include/net/pkt_cls.h                         |  1 +
 include/net/sch_generic.h                     |  4 ++
 include/uapi/linux/rtnetlink.h                |  6 ++
 net/sched/act_api.c                           | 30 ++++++--
 net/sched/cls_api.c                           | 70 ++++++++++++++++---
 net/sched/cls_flower.c                        | 43 ++++++++++++
 .../tc-testing/tc-tests/filters/tests.json    | 38 ++++++++++
 8 files changed, 177 insertions(+), 17 deletions(-)

-- 
2.21.0

