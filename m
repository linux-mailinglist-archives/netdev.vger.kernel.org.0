Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 886E25A963B
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 14:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233125AbiIAMEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 08:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233240AbiIAMEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 08:04:40 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57FDFE02A
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 05:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662033880; x=1693569880;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1VZETW+lYPSSAj1gPR1ChU5vmyR8Mqu/SV+ocHcR0WQ=;
  b=AYbeoyA847hWh5avT+W3QkSzwL0YGr1VJBZHqkkYVQc9xD4tm3v+Zkux
   DfblC1Dwsd2uK6mS0coYwpuElHzH+xDEJUdvViQyS8LRC9eJ8EBa+V6W/
   YzH9HKOE4FR69wwJjEpFKD2nyJdrGngMhagrJLDzY9xLSTmNIAt7EUPPw
   Oy6mLLgfqfN2Vvi3rgyM67Z2hnDup1nQiz+AtlK9m6ba/1s/5r6A2m/Kq
   RK5x21k89t6XaaeEqRNSKYzevxtv5YYLWnkymQBOybZWQ5GhEFYoplKdl
   NzMbOIsv5Iv+ogSjsG0uiIz5LbXYaE4JoR7h05NnCuTebQVuX5moSiirJ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="282674248"
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="282674248"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 05:04:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="608532252"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga007.jf.intel.com with ESMTP; 01 Sep 2022 05:04:35 -0700
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 281C4XRg024211;
        Thu, 1 Sep 2022 13:04:33 +0100
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        marcin.szycik@linux.intel.com, michal.swiatkowski@linux.intel.com,
        kurt@linutronix.de, boris.sukholitko@broadcom.com,
        vladbu@nvidia.com, komachi.yoshiki@gmail.com, paulb@nvidia.com,
        baowen.zheng@corigine.com, louis.peens@corigine.com,
        simon.horman@corigine.com, pablo@netfilter.org,
        maksym.glubokiy@plvision.eu, intel-wired-lan@lists.osuosl.org,
        jchapman@katalix.com, gnault@redhat.com
Subject: [RFC PATCH net-next v3 0/5] ice: L2TPv3 offload support
Date:   Thu,  1 Sep 2022 14:01:26 +0200
Message-Id: <20220901120131.1373568-1-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

v2: rebase
v3: refactor of __skb_flow_dissect_l2tpv3

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
2.31.1

