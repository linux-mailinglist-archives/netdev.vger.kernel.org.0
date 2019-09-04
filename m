Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A035A877E
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729923AbfIDN4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 09:56:45 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:38931 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729640AbfIDN4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 09:56:45 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 4 Sep 2019 16:56:41 +0300
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (reg-r-vrt-019-180.mtr.labs.mlnx [10.213.19.180])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x84DufkQ014996;
        Wed, 4 Sep 2019 16:56:41 +0300
From:   Paul Blakey <paulb@mellanox.com>
To:     Pravin B Shelar <pshelar@ovn.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Justin Pettit <jpettit@nicira.com>,
        Simon Horman <simon.horman@netronome.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Rony Efraim <ronye@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>
Subject: [PATCH net-next v4 0/1] tc SKB extension for tc Chains/Conntrack hardware offload
Date:   Wed,  4 Sep 2019 16:56:36 +0300
Message-Id: <1567605397-14060-1-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following patch introduces a new SKB extension to support hardware offload of 
multi chain rules such as by connection tracking scenarios.
The patch is required for two use-cases. The first, implemented here,
uses the extension for tc -> OvS miss path. 
A following patch set will reuse this extension to pass information from HW/Driver -> tc miss path.

The HW/Driver -> tc miss path:
In tc multi chain rules scenarios, some of the rules might be offloaded
and some not (e.g skip_hw, unsupported rules by HW, vxlan encapsulation, 
offload order, etc).
Therefore, HW can miss at any point of the processing chain.
SW will need to continue processing in correct tc chain where the HW 
left off, as HW might have modified the packet and updated stats for it.
This scenario can reuse this tc SKB extension to restore the tc chain.

skb extension was chosen over skb control block, as skb control block acts a scratchpad area
for storing temporary information and isn't suppose to be pass around between different
layers of processing. HW/Driver -> tc - >OvS  are different layers, and not necessarily 
processing the packet one after another.
There can be bridges, tunnel devices, VLAN devices, Netfilter (Conntrack) and a host of
other entities processing the packet in between so we can't guarantee the control block
integrity between this main processing entities (HW/Driver, Tc, Ovs).
So if we'll use the control block, it will restrict such use cases.
For example, the napi API which we use, uses the control block and comes right after our
driver layer. This will overwrite any usage of CB by us.

Thanks,
Paul B.

Paul Blakey (1):
  net: openvswitch: Set OvS recirc_id from tc chain index

 include/linux/skbuff.h           | 13 +++++++++++++
 include/uapi/linux/openvswitch.h |  3 +++
 net/core/skbuff.c                |  6 ++++++
 net/openvswitch/datapath.c       | 38 +++++++++++++++++++++++++++++++++-----
 net/openvswitch/datapath.h       |  2 ++
 net/openvswitch/flow.c           | 13 +++++++++++++
 net/sched/Kconfig                | 13 +++++++++++++
 net/sched/cls_api.c              | 12 ++++++++++++
 8 files changed, 95 insertions(+), 5 deletions(-)

-- 
1.8.3.1

