Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C60035A2683
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 13:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234289AbiHZLF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 07:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344200AbiHZLEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 07:04:37 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48BF830F70
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 04:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661511859; x=1693047859;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mVfFXbHXdc5J9BNZWgXlaSHs05hfNO32943brAaakqA=;
  b=IU87v8YVMv/+E2B7DvjYP/9JrMEZVdivYoXd27l5obyQ6Mb0wFVrV3hK
   iryIVafHYmxzWYxH5BMYTfjxPT5qfnLc8ckYO+JVNZG/tcVQsfLBgvxdz
   yAyF+MYGt+jyryzIm4JFF0eoqPHJiFcmN3VFbljmC9E5r2Q4unqaWnL5N
   PirNrNlzrzeJCe4nos8adRxs09NZOgV6fOM6yWr8532YIJKRgot0nGAW6
   Q07q/QMRTzsF4VVjfnCMpXRkPdba21AiycYqfIJ3H3CtkA8edvz4hr7MN
   iI3ZBZs/MEQfOlHx2LBPnT5bpx8jvXRMtxf0WWD5zXhGZd/HE4yaZai+7
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10450"; a="380775322"
X-IronPort-AV: E=Sophos;i="5.93,265,1654585200"; 
   d="scan'208";a="380775322"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 04:04:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,265,1654585200"; 
   d="scan'208";a="678830889"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga004.fm.intel.com with ESMTP; 26 Aug 2022 04:04:14 -0700
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 27QB4CLq024087;
        Fri, 26 Aug 2022 12:04:12 +0100
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
Subject: [RFC PATCH net-next 0/5] ice: L2TPv3 offload support
Date:   Fri, 26 Aug 2022 13:00:54 +0200
Message-Id: <20220826110059.119927-1-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

