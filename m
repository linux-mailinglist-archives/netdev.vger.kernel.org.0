Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C435F559A8F
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 15:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbiFXNmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 09:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232215AbiFXNmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 09:42:33 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D9DD45AE0
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 06:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656078151; x=1687614151;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UN1zVcZt17t43F9YUs2koAAnwY/AV/i1iLRoI+KLsh8=;
  b=lkCZTKZMsugoU7A/1u4uHCCna1NCMldpOhvcT/9l22SgiaMQvB3kItG8
   i6APHxWaIp3pYTYRDU3D3VWEfV/3lEsjoc9PW/kCYrZLkRB6TmNpANneK
   f619xFSmPT9+E1Q42dEn8wokLwO/QZP3V0dcbN+txTKKZ6Pnp0Zi8EZCs
   OJsBwfYCwb7JjbNb1f4LBvoLyROB3gnZJf3hRiB5SwSi3risA0OJ8Ojw4
   8CntI+D6Puqwyt+rgCrmMdG8WhuOi5TRWkpa6F75YUxFLD/Pu8XMreFjM
   SpYDJ0DA8WNee5oDm/KKoS0yDy3oQMBHLhzNftc7MGtqSVj5VkRJN3VqG
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="264041757"
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="264041757"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 06:42:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="621720579"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga001.jf.intel.com with ESMTP; 24 Jun 2022 06:42:20 -0700
Received: from rozewie.igk.intel.com (rozewie.igk.intel.com [10.211.8.69])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25ODgI7W005567;
        Fri, 24 Jun 2022 14:42:18 +0100
From:   Marcin Szycik <marcin.szycik@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     anthony.l.nguyen@intel.com, davem@davemloft.net,
        xiyou.wangcong@gmail.com, jesse.brandeburg@intel.com,
        gustavoars@kernel.org, baowen.zheng@corigine.com,
        boris.sukholitko@broadcom.com, elic@nvidia.com,
        edumazet@google.com, kuba@kernel.org, jhs@mojatatu.com,
        jiri@resnulli.us, kurt@linutronix.de, pablo@netfilter.org,
        pabeni@redhat.com, paulb@nvidia.com, simon.horman@corigine.com,
        komachi.yoshiki@gmail.com, zhangkaiheb@126.com,
        intel-wired-lan@lists.osuosl.org,
        michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        Marcin Szycik <marcin.szycik@linux.intel.com>
Subject: [RFC PATCH net-next 0/4] ice: PPPoE offload support
Date:   Fri, 24 Jun 2022 15:41:30 +0200
Message-Id: <20220624134134.13605-1-marcin.szycik@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

Changes in iproute2 are required to use the new fields.

ICE COMMS DDP package is required to create a filter in ice.

Note: currently matching on vlan + PPPoE fields is not supported. Patch [0]
will add this feature.

[0] https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20220420210048.5809-1-martyna.szapar-mudlaw@intel.com

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
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   |  94 ++++++++--
 drivers/net/ethernet/intel/ice/ice_tc_lib.h   |   8 +
 include/net/flow_dissector.h                  |  11 ++
 include/net/flow_offload.h                    |   6 +
 include/uapi/linux/pkt_cls.h                  |   3 +
 net/core/flow_dissector.c                     |  51 +++++-
 net/core/flow_offload.c                       |   7 +
 net/sched/cls_flower.c                        |  46 +++++
 12 files changed, 391 insertions(+), 17 deletions(-)

-- 
2.35.1

