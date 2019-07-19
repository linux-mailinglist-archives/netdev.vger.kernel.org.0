Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 692236E899
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 18:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730822AbfGSQU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 12:20:28 -0400
Received: from mail.us.es ([193.147.175.20]:42816 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729186AbfGSQU2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jul 2019 12:20:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7C858C1A67
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 18:20:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6BBEA115103
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 18:20:26 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4ED6E1150DA; Fri, 19 Jul 2019 18:20:26 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3F12FDA704;
        Fri, 19 Jul 2019 18:20:24 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 19 Jul 2019 18:20:24 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [47.60.47.94])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 713E24265A31;
        Fri, 19 Jul 2019 18:20:23 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@resnulli.us,
        jakub.kicinski@netronome.com, pshelar@ovn.org
Subject: [PATCH nf,v5 0/4] flow_offload fixes
Date:   Fri, 19 Jul 2019 18:20:12 +0200
Message-Id: <20190719162016.10243-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains fixes for the flow_offload infrastructure:

1) Fix possible build breakage before patch 3/4. Both the flow_offload
   infrastructure and OVS define the flow_stats structure. Patch 3/4 in
   this batch indirectly pulls in the flow_stats definition from
   include/net/flow_offload.h into OVS, leading to structure redefinition
   compile-time errors.

2) Remove netns parameter from flow_block_cb_alloc(), this is not
   required as Jiri suggests. The flow_block_cb_is_busy() function uses
   the per-driver block list to check for used blocks which was the
   original intention for this parameter.

3) Rename tc_setup_cb_t to flow_setup_cb_t. This callback is not
   exclusive of tc anymore, this might confuse the reader as Jiri
   suggests, fix this semantic inconsistency.

   Add #include <linux/list.h> to include/net/netfilter/nf_tables_offload.h
   to avoid a compile break with CONFIG_HEADER_TEST=y.

4) Fix block sharing feature: Add flow_block structure and use it,
   update flow_block_cb_lookup() to use this flow_block object.

Please, apply, thank you.

Pablo Neira Ayuso (4):
  net: openvswitch: rename flow_stats to sw_flow_stats
  net: flow_offload: remove netns parameter from flow_block_cb_alloc()
  net: flow_offload: rename tc_setup_cb_t to flow_setup_cb_t
  net: flow_offload: add flow_block structure and use it

 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  5 ++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     | 15 ++++++-----
 drivers/net/ethernet/mscc/ocelot_flower.c          | 11 ++++----
 drivers/net/ethernet/mscc/ocelot_tc.c              |  6 ++---
 .../net/ethernet/netronome/nfp/flower/offload.c    | 11 ++++----
 include/net/flow_offload.h                         | 30 ++++++++++++++++------
 include/net/netfilter/nf_tables.h                  |  5 ++--
 include/net/pkt_cls.h                              |  5 ++--
 include/net/sch_generic.h                          |  8 +++---
 net/core/flow_offload.c                            | 22 ++++++++--------
 net/dsa/slave.c                                    |  6 ++---
 net/netfilter/nf_tables_api.c                      |  2 +-
 net/netfilter/nf_tables_offload.c                  |  5 ++--
 net/openvswitch/flow.c                             |  8 +++---
 net/openvswitch/flow.h                             |  4 +--
 net/openvswitch/flow_table.c                       |  8 +++---
 net/sched/cls_api.c                                | 12 ++++++---
 net/sched/cls_bpf.c                                |  2 +-
 net/sched/cls_flower.c                             |  2 +-
 net/sched/cls_matchall.c                           |  2 +-
 net/sched/cls_u32.c                                |  6 ++---
 21 files changed, 94 insertions(+), 81 deletions(-)

-- 
2.11.0


