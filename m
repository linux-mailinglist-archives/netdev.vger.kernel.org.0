Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5574BE9D1
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381595AbiBURTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 12:19:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347637AbiBURTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 12:19:38 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8489CCFB
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 09:19:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645463955; x=1676999955;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tUhXvk+LFkLoswi++f9XcpeeaQoJBVXpSjX5dbLbTgU=;
  b=Kz7WSdTQRU7Z6euwfWylCk7Hmp1i8GZjLA7S/w9tZGqA3dIH8GA1by2+
   A3ZDBQsm6diQ9KwbeFFiaO/TjtMr5g8MWKN+IvZtamEpVjj4qaFuJKUdH
   +oLkw+C0QdJZ9t2nO2q9a9on1RvBMdM//g2e3zHU/lc/wD6MXIkJPEjJh
   8+kfbR07wZosRWXwLU9aKHkmxDG4EBsdYyeodgrSNFMTFN1ZESmVGyfQZ
   Ho5YDSjQgQxzwvgeoFdMF1ZA2k7+9/7/HL6LPpOlr9+0M1Nvj/TknQM/l
   zQyNF+3lU9T5Sda7W20uazM3REz954SgYkAM+PsQN7i00N6zTDEjtp4Mi
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10265"; a="232165822"
X-IronPort-AV: E=Sophos;i="5.88,386,1635231600"; 
   d="scan'208";a="232165822"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 09:19:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,386,1635231600"; 
   d="scan'208";a="490502351"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga003.jf.intel.com with ESMTP; 21 Feb 2022 09:19:12 -0800
Received: from rozewie.igk.intel.com (rozewie.igk.intel.com [10.211.8.69])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 21LHJBnN010069;
        Mon, 21 Feb 2022 17:19:11 GMT
From:   Marcin Szycik <marcin.szycik@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        davem@davemloft.net, kuba@kernel.org, pablo@netfilter.org,
        laforge@gnumonks.org, jiri@resnulli.us,
        osmocom-net-gprs@lists.osmocom.org,
        intel-wired-lan@lists.osuosl.org,
        Marcin Szycik <marcin.szycik@linux.intel.com>
Subject: [PATCH net-next v7 0/7] ice: GTP support in switchdev
Date:   Mon, 21 Feb 2022 11:14:18 +0100
Message-Id: <20220221101425.19776-1-marcin.szycik@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for adding GTP-C and GTP-U filters in switchdev mode.

To create a filter for GTP, create a GTP-type netdev with ip tool, enable
hardware offload, add qdisc and add a filter in tc:

ip link add $GTP0 type gtp role <sgsn/ggsn> hsize <hsize>
ethtool -K $PF0 hw-tc-offload on
tc qdisc add dev $GTP0 ingress
tc filter add dev $GTP0 ingress prio 1 flower enc_key_id 1337 \
action mirred egress redirect dev $VF1_PR

By default, a filter for GTP-U will be added. To add a filter for GTP-C,
specify enc_dst_port = 2123, e.g.:

tc filter add dev $GTP0 ingress prio 1 flower enc_key_id 1337 \
enc_dst_port 2123 action mirred egress redirect dev $VF1_PR

Note: outer IPv6 offload is not supported yet.
Note: GTP-U with no payload offload is not supported yet.

ICE COMMS package is required to create a filter as it contains GTP
profiles.

Changes in iproute2 [1] are required to be able to add GTP netdev and use
GTP-specific options (QFI and PDU type).

[1] https://lore.kernel.org/netdev/20220211182902.11542-1-wojciech.drewek@intel.com/T
---
v2: Adding more CC
v3: Fixed mail thread, sorry for spam
v4: Added GTP echo response in gtp module
v5: Change patch order
v6: Added GTP echo request in gtp module
v7: Fix kernel-docs in ice

Marcin Szycik (1):
  ice: Support GTP-U and GTP-C offload in switchdev

Michal Swiatkowski (1):
  ice: Fix FV offset searching

Wojciech Drewek (5):
  gtp: Allow to create GTP device without FDs
  gtp: Implement GTP echo response
  gtp: Implement GTP echo request
  net/sched: Allow flower to match on GTP options
  gtp: Add support for checking GTP device type

 drivers/net/ethernet/intel/ice/ice.h          |   1 +
 .../net/ethernet/intel/ice/ice_flex_pipe.c    |  52 +-
 .../net/ethernet/intel/ice/ice_flex_pipe.h    |   2 +-
 .../net/ethernet/intel/ice/ice_flex_type.h    |   6 +-
 .../ethernet/intel/ice/ice_protocol_type.h    |  19 +
 drivers/net/ethernet/intel/ice/ice_switch.c   | 630 +++++++++++++++--
 drivers/net/ethernet/intel/ice/ice_switch.h   |   9 +
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   | 105 ++-
 drivers/net/ethernet/intel/ice/ice_tc_lib.h   |   3 +
 drivers/net/gtp.c                             | 661 +++++++++++++++++-
 include/net/gtp.h                             |  42 ++
 include/uapi/linux/gtp.h                      |   2 +
 include/uapi/linux/if_link.h                  |   2 +
 include/uapi/linux/if_tunnel.h                |   4 +-
 include/uapi/linux/pkt_cls.h                  |  15 +
 net/sched/cls_flower.c                        | 116 +++
 16 files changed, 1565 insertions(+), 104 deletions(-)

-- 
2.35.1

