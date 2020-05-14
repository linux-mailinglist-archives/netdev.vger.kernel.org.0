Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75C3A1D31C0
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 15:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgENNtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 09:49:02 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:53782 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726073AbgENNtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 09:49:02 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 14 May 2020 16:48:59 +0300
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 04EDmxb7025987;
        Thu, 14 May 2020 16:48:59 +0300
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next 0/3] net/sched: act_ct: Add support for specifying tuple offload policy
Date:   Thu, 14 May 2020 16:48:27 +0300
Message-Id: <1589464110-7571-1-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds support for specifying the offload policy of act ct
offloaded flows to the nf flow table (and then hardware).

policy_pkts - specifies after how many software packets to offload
a flow to the flow table

policy_timeout - specifies the aging timeout, in seconds, from last seen
packet

Usage is:
$ tc filter add dev ens1f0_0 ingress chain 0 flower ct_state -trk \
action ct policy_timeout 120 policy_pkts 10 pipe \
action goto chain 1

$ tc filter add dev ens1f0_0 ingress chain 1 flower ct_state +trk+new \
action ct commit policy_timeout 120 policy_pkts 10 pipe \
action mirred egress redirect dev ens1f0_1

$ tc filter add dev ens1f0_0 ingress chain 1 flower ct_state +trk+est \
action mirred egress redirect dev ens1f0_1

To avoid conflicting policies, the policy is applied per zone on the first
act ct instance for that zone, and must be repeated in all further act ct
instances of the same zone.

Paul Blakey (3):
  netfilter: flowtable: Control flow offload timeout interval
  net/sched: act_ct: Add policy_pkts tuple offload control policy
  net/sched: act_ct: Add policy_timeout tuple offload control policy

 include/net/netfilter/nf_flow_table.h |  7 ++-
 include/net/tc_act/tc_ct.h            |  5 ++
 include/uapi/linux/tc_act/tc_ct.h     |  2 +
 net/netfilter/nf_flow_table_core.c    | 12 ++++-
 net/netfilter/nf_flow_table_offload.c |  5 +-
 net/sched/act_ct.c                    | 93 ++++++++++++++++++++++++++++++++++-
 6 files changed, 117 insertions(+), 7 deletions(-)

-- 
1.8.3.1

