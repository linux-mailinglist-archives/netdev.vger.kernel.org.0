Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0939356B9A8
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 14:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237559AbiGHMY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 08:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237157AbiGHMY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 08:24:57 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEAE8C08
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 05:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657283096; x=1688819096;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QoY4frX9pDEHOXtqopiLvr0uO54PNTdpZFPrw6NlCSQ=;
  b=ACvpeWwG7gFfI9P+QJnoS/r9MJFdXKY92kBcNjQn6rAJp7bJgg5X0NU8
   qXVCvALu49a8M4smPNaLmNJmWXulPYJncr6AlDq/w9IaUt5p91mkgO3Nw
   uXW3ODjjIcUivNB2n20g4cDFSf0X9ZrwgmofENLum+NB5qk3M2aXFoWJp
   L04zJHKC8KfhCtvXf48OwzP8C7UDtgy88+R4IJkLYXyhMW4gY9k6wFUH0
   pSKkipdwiZm5baNVFvPWNp3oUBfdOLS6/DSbQ0JnEr8Wwl6UpzHDod1AW
   MNrRQFHy51xFvPILqW7M5KhPml3gws4vQmKIBqryvVgInQIEMsmpakKzU
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10401"; a="285397368"
X-IronPort-AV: E=Sophos;i="5.92,255,1650956400"; 
   d="scan'208";a="285397368"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2022 05:24:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,255,1650956400"; 
   d="scan'208";a="626690550"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga001.jf.intel.com with ESMTP; 08 Jul 2022 05:24:51 -0700
Received: from rozewie.igk.intel.com (rozewie.igk.intel.com [10.211.8.69])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 268COncY014111;
        Fri, 8 Jul 2022 13:24:49 +0100
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
Subject: [RFC PATCH net-next v4 0/4] ice: PPPoE offload support
Date:   Fri,  8 Jul 2022 14:24:17 +0200
Message-Id: <20220708122421.19309-1-marcin.szycik@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

v4:
  * PPPoE header validation
  * added MPLS support
  * added support for compressed PPP protocol field
  * flow_dissector_key_pppoe::session_id stored in __be16
  * new field: flow_dissector_key_pppoe::type
  * always add an ethtype lookup if PPP/PPPoE options are provided (to
    prevent setting incorrect ethtype)
  * rebase
v3:
  * revert byte order changes in is_ppp_proto_supported from previous
    version
  * add kernel-doc for is_ppp_proto_supported
  * add more CC
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
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   |  71 +++++++-
 drivers/net/ethernet/intel/ice/ice_tc_lib.h   |   8 +
 include/net/flow_dissector.h                  |  13 ++
 include/net/flow_offload.h                    |   6 +
 include/uapi/linux/pkt_cls.h                  |   3 +
 net/core/flow_dissector.c                     |  84 ++++++++-
 net/core/flow_offload.c                       |   7 +
 net/sched/cls_flower.c                        |  61 +++++++
 12 files changed, 426 insertions(+), 9 deletions(-)

-- 
2.35.1

