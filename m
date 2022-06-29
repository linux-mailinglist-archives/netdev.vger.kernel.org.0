Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E292A560360
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 16:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232887AbiF2Oka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 10:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbiF2Ok1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 10:40:27 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52A4369D3
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 07:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656513626; x=1688049626;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=o3+KChBf4+3ZJMDHGT08ONBg+wKGFRjSPMoH4qjIIkM=;
  b=APj4n4Vjqq8bu+5+iP93bW2ubd/8pCi485XqmlRVi2cuoMrZJDqvXw3B
   NMl+CFJNUfcrJWg1zdOvp95Ia0F0w9efba+t7BXkCBYuMwyjxaPrDPPvU
   ceg8SKzpCkDkiGJQFkEwAbxICMF3xHvXg3zpDK4X5rr068r2l9CnIufa3
   irnxgK2XpvMf43cfjrKypJ9I6+YwCdALMcem5gd8++pRFHPFdC8Oa7hF0
   ajcM15BVvJyCUlEmBfYuVMHSAKEJ/PQdlzR5owRigSKBk14H8jEDd77wD
   RoUHxolX9QeYd2KVkMgujORIqBsIRgVlAa7WZhJ2iIIEGvKYtR4dKrWgD
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="343734757"
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="343734757"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 07:40:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="680529634"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Jun 2022 07:40:21 -0700
Received: from rozewie.igk.intel.com (rozewie.igk.intel.com [10.211.8.69])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25TEeJ3X022901;
        Wed, 29 Jun 2022 15:40:19 +0100
From:   Marcin Szycik <marcin.szycik@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     anthony.l.nguyen@intel.com, davem@davemloft.net,
        xiyou.wangcong@gmail.com, jesse.brandeburg@intel.com,
        gustavoars@kernel.org, baowen.zheng@corigine.com,
        boris.sukholitko@broadcom.com, edumazet@google.com,
        kuba@kernel.org, jhs@mojatatu.com, jiri@resnulli.us,
        kurt@linutronix.de, pablo@netfilter.org, pabeni@redhat.com,
        paulb@nvidia.com, simon.horman@corigine.com,
        komachi.yoshiki@gmail.com, zhangkaiheb@126.com,
        intel-wired-lan@lists.osuosl.org,
        michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        alexandr.lobakin@intel.com, gnault@redhat.com,
        mostrows@earthlink.net, paulus@samba.org,
        Marcin Szycik <marcin.szycik@linux.intel.com>
Subject: [RFC PATCH net-next v3 0/4] ice: PPPoE offload support
Date:   Wed, 29 Jun 2022 16:38:55 +0200
Message-Id: <20220629143859.209028-1-marcin.szycik@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for dissecting PPPoE and PPP-specific fields in flow dissector:
PPPoE session id and PPP protocol type. Add support for those fields in
tc-flower and support offloading PPPoE. Finally, add support for hardware
offload of PPPoE packets in switchdev mode in ice driver.

Example filter:
tc filter add dev $PF1 ingress protocol ppp_ses prio 1 flower pppoe_sid \
    1234 ppp_proto ip skip_sw action mirred egress redirect dev $VF1_PR

Changes in iproute2 are required to use the new fields (will be submitted
soon).

ICE COMMS DDP package is required to create a filter in ice.

Note: currently matching on vlan + PPPoE fields is not supported. Patch [0]
will add this feature.

[0] https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20220420210048.5809-1-martyna.szapar-mudlaw@intel.com

v3: revert byte order changes in is_ppp_proto_supported from previous
    version, add kernel-doc for is_ppp_proto_supported, add more CC
v2: cosmetic changes

Marcin Szycik (1):
  ice: Add support for PPPoE hardware offload

Wojciech Drewek (3):
  flow_dissector: Add PPPoE dissectors
  net/sched: flower: Add PPPoE filter
  flow_offload: Introduce flow_match_pppoe

 drivers/net/ethernet/intel/ice/ice.h          |   1 +
 .../net/ethernet/intel/ice/ice_flex_pipe.c    |   5 +-
 .../ethernet/intel/ice/ice_protocol_type.h    |  11 ++
 drivers/net/ethernet/intel/ice/ice_switch.c   | 165 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   |  95 ++++++++--
 drivers/net/ethernet/intel/ice/ice_tc_lib.h   |   8 +
 include/net/flow_dissector.h                  |  11 ++
 include/net/flow_offload.h                    |   6 +
 include/uapi/linux/pkt_cls.h                  |   3 +
 net/core/flow_dissector.c                     |  55 +++++-
 net/core/flow_offload.c                       |   7 +
 net/sched/cls_flower.c                        |  46 +++++
 12 files changed, 396 insertions(+), 17 deletions(-)

-- 
2.35.1

