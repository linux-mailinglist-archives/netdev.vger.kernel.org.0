Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B827578207
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 14:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234929AbiGRMSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 08:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234922AbiGRMSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 08:18:49 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79097BDD
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 05:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658146728; x=1689682728;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jin3FfNKV7gOhWsaDgpdjF6ySp7J3/uc64WCEix2xwY=;
  b=dzBUEangzl1b0+1PcymuktndVcCadNnfI5BFnzItOQEEdnXzxkh5uImJ
   Og5pvOiv69eyd1q5xFmri16kedsQF/xkiilNX7qFA8M0zyhkaasQW0s2r
   F+B3HeNfgXr8QnN0jJov0v6nFFuzCAy1QQXPwteyIElIX+4QJBlDeDFAk
   UHAyHarnF1tggHPI67Cg+API15LY9AJwkX3MzOHxR6B/Jo2MlmcrQ16eG
   hSm88ji4RW+yVkEhSqhQBYduT2NQzlrgm+hwETEsaRotzuaaD3itwoDW7
   9Y7S+sWkbBMnq8evfKVAVW71aNqz8jSH9fPpW0VmOI9ZTSrZgnGcfLF9a
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10411"; a="283771597"
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="283771597"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 05:18:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="686716685"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Jul 2022 05:18:43 -0700
Received: from rozewie.igk.intel.com (rozewie.igk.intel.com [10.211.8.69])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 26ICIfCs016026;
        Mon, 18 Jul 2022 13:18:41 +0100
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
        mostrows@speakeasy.net, paulus@samba.org,
        Marcin Szycik <marcin.szycik@linux.intel.com>
Subject: [RFC PATCH net-next v6 0/4] ice: PPPoE offload support
Date:   Mon, 18 Jul 2022 14:18:09 +0200
Message-Id: <20220718121813.159102-1-marcin.szycik@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

v6:
  * make check for ppp proto more generic
  * fix remaining byte order issues
v5: fix endianness when processing compressed protocols
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
 include/linux/ppp_defs.h                      |  14 ++
 include/net/flow_dissector.h                  |  13 ++
 include/net/flow_offload.h                    |   6 +
 include/uapi/linux/pkt_cls.h                  |   3 +
 net/core/flow_dissector.c                     |  53 +++++-
 net/core/flow_offload.c                       |   7 +
 net/sched/cls_flower.c                        |  64 +++++++
 13 files changed, 412 insertions(+), 9 deletions(-)

-- 
2.35.1

