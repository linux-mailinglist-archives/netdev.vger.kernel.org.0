Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA102581B22
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 22:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233807AbiGZUfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 16:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbiGZUfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 16:35:10 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A6773AB
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 13:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658867708; x=1690403708;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=FdT6m8nW7h5zOcbFhjrVtZ4iD/BgLKtiz4Tq/+OS4kQ=;
  b=XEHV/YsiPMQwtzRElIdgPmO6B6pyCnU8baCzC9bgh5Gsx9gEykEyXtgj
   VJWIklr+a/CQgCiI0CzgyFSRiKxVbj/1HFdRsJ0HWwRXF/NKEEiGeV7kv
   0N6pqIEvWhE9vtPTgrC7uVSk8k1u51pZFBypLWimSFk2UPL4LSt8TekBk
   nOUXV3tG5dWXfhHBneEmohLLXAxZxVIKBwVo7sRhKSinazJzjbtrCLFE9
   Gp/y9Sz9anC7sKK2eEXTvZCb7yAOO53sEDePmeuJn6HpQ8lcJbOnN9iL6
   S8s0cre7n9YKB1pWe/OA0Ap39zYlfr+LOnSw73iwxx9pY+TnuUyUJsO84
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10420"; a="274923290"
X-IronPort-AV: E=Sophos;i="5.93,194,1654585200"; 
   d="scan'208";a="274923290"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 13:35:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,194,1654585200"; 
   d="scan'208";a="658854120"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 26 Jul 2022 13:35:07 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com, jesse.brandeburg@intel.com,
        gustavoars@kernel.org, baowen.zheng@corigine.com,
        boris.sukholitko@broadcom.com, kurt@linutronix.de,
        pablo@netfilter.org, paulb@nvidia.com, simon.horman@corigine.com,
        komachi.yoshiki@gmail.com, zhangkaiheb@126.com,
        michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        alexandr.lobakin@intel.com, gnault@redhat.com,
        mostrows@speakeasy.net, paulus@samba.org,
        marcin.szycik@linux.intel.com
Subject: [PATCH net-next 0/4][pull request] ice: PPPoE offload support
Date:   Tue, 26 Jul 2022 13:31:29 -0700
Message-Id: <20220726203133.2171332-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marcin Szycik says:

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
---
From RFC:
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

The following are changes since commit 35d099da41967f114c6472b838e12014706c26e7:
  Merge branch 'octeontx2-minor-tc-fixes'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

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

