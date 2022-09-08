Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD2215B2445
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 19:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiIHRRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 13:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiIHRRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 13:17:20 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC9FACAC78
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 10:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662657439; x=1694193439;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=V2YsRguj/UCTTl115hMydgNCtYK9SKQ/6WZTsWru+U0=;
  b=Lz0wrUxZA9Qt7rcJH4+NNyorIpViMkAK8ZepsQMxHlSXgCTXdSZbd70N
   ypsL6gyO4b7XcJbkG7qMbjt4TPS5rjFkE+wQCkhttft8g8Nf1X/2A7rcq
   rWiF00l/5dZzYTYGnUNMa2pB8NiDP5otOa6oeW0A2/CY0bCheD0GnrlTR
   n4rxOE0SikF0WsLq9lDZtBv260u1QMHDb4QuTR2goYxNRDZxQXscfYTmK
   EyvvZtsPFAMmBo0VGaPXq4xgYmmUQe4fOtKsLExFC0Q3DYnhuxik3kaGJ
   PbtM23vcu22geBQDcm9q5A1GgEyGj4v3WCnzQvS1W3JJ536EgrD3tZVpQ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="297267558"
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="297267558"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 10:16:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="860117809"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 08 Sep 2022 10:16:54 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        wojciech.drewek@intel.com, simon.horman@corigine.com,
        kurt@linutronix.de, komachi.yoshiki@gmail.com,
        jchapman@katalix.com, boris.sukholitko@broadcom.com,
        louis.peens@corigine.com, gnault@redhat.com, vladbu@nvidia.com,
        pablo@netfilter.org, baowen.zheng@corigine.com,
        maksym.glubokiy@plvision.eu, jiri@resnulli.us, paulb@nvidia.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com
Subject: [PATCH net-next v1 0/5][pull request] ice: L2TPv3 offload support
Date:   Thu,  8 Sep 2022 10:16:39 -0700
Message-Id: <20220908171644.1282191-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wojciech Drewek says:

Add support for dissecting L2TPv3 session id in flow dissector. Add support
for this field in tc-flower and support offloading L2TPv3. Finally, add
support for hardware offload of L2TPv3 packets based on session id in
switchdev mode in ice driver.

Example filter:
  # tc filter add dev $PF1 ingress prio 1 protocol ip \
      flower \
        ip_proto l2tp \
        l2tpv3_sid 1234 \
        skip_sw \
      action mirred egress redirect dev $VF1_PR

Changes in iproute2 are required to use the new fields.

ICE COMMS DDP package is required to create a filter in ice.
COMMS DDP package contains profiles of more advanced protocols.
Without COMMS DDP package hw offload will not work, however
sw offload will still work.
---
v1: fix typos

From RFC:
v2: rebase
v3: refactor of __skb_flow_dissect_l2tpv3

The following are changes since commit 75554fe00f941c3c3d9344e88708093a14d2b4b8:
  net: sparx5: fix function return type to match actual type
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Marcin Szycik (1):
  ice: Add L2TPv3 hardware offload support

Wojciech Drewek (4):
  uapi: move IPPROTO_L2TP to in.h
  flow_dissector: Add L2TPv3 dissectors
  net/sched: flower: Add L2TPv3 filter
  flow_offload: Introduce flow_match_l2tpv3

 .../ethernet/intel/ice/ice_protocol_type.h    |  8 +++
 drivers/net/ethernet/intel/ice/ice_switch.c   | 70 ++++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   | 27 ++++++-
 drivers/net/ethernet/intel/ice/ice_tc_lib.h   |  6 ++
 include/net/flow_dissector.h                  |  9 +++
 include/net/flow_offload.h                    |  6 ++
 include/uapi/linux/in.h                       |  2 +
 include/uapi/linux/l2tp.h                     |  2 -
 include/uapi/linux/pkt_cls.h                  |  2 +
 net/core/flow_dissector.c                     | 28 ++++++++
 net/core/flow_offload.c                       |  7 ++
 net/sched/cls_flower.c                        | 16 +++++
 12 files changed, 179 insertions(+), 4 deletions(-)

-- 
2.35.1

