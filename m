Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5529A4EBD96
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 11:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244786AbiC3JZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 05:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244785AbiC3JZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 05:25:02 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A5A025D1;
        Wed, 30 Mar 2022 02:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648632198; x=1680168198;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=y23RIbKwqNxa/t3JcK6RsI/UqNmh00039XVrepKkUTs=;
  b=QQvNJAelTiUxF5Hpe6RPejOaDI9CLM6E9w1Jf7luynXu8b68nCM1nz3h
   ym7ehqWp6KVLAhPlW0irO7hB50uxmybbCCehBwzj7jT6jGBKgyVAQ1snZ
   ZrMx0Nj6W2EuuyugOzz87yWZCOvmvf4e5VGSFdFmjpYGvaiAxjSZNSM/w
   rrmmaQvK6Ch32/m1gkSUwbW/3pENCywSr/9pkshfM1Ob6MdJOSgvwDlMD
   j5hQ6rLDjF2tGOVg84IU0pyRQXImhIAoaYyD3rV8p4v6BSHnvgjJSJOMA
   QFZU7q1uBKZogx0IHapbcvVuGa+8E5J1CYprznT6QJf0PDjhe6BKpEjPJ
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10301"; a="284403013"
X-IronPort-AV: E=Sophos;i="5.90,222,1643702400"; 
   d="scan'208";a="284403013"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2022 02:23:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,222,1643702400"; 
   d="scan'208";a="519609463"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga002.jf.intel.com with ESMTP; 30 Mar 2022 02:23:13 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 22U9NCcO004547;
        Wed, 30 Mar 2022 10:23:12 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Wojciech Drewek <wojciech.drewek@intel.com>,
        Marcin Szycik <marcin.szycik@linux.intel.com>,
        Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH intel-next] ice: switch: fix a braino in the new dummy packet match definitions
Date:   Wed, 30 Mar 2022 11:20:46 +0200
Message-Id: <20220330092046.2727362-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's a trivial mistake[0] in @ice_dummy_pkt_profile due to which
it incorrectly states that "plain" TCP IPv6 packets should match on
the flag 'inner IPv6', not the 'outer' one.

[0] https://lore.kernel.org/netdev/PH0PR11MB5782637EA9771D3ED4E56012FD1E9@PH0PR11MB5782.namprd11.prod.outlook.com

Fixes: b5c7ae81ff90 ("ice: switch: convert packet template match code to rodata")
Reported-by: Wojciech Drewek <wojciech.drewek@intel.com>
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
Tony, please squash it with the mentioned commit on applying.
Thanks.
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index ed7130b7abfe..496250f9f8fc 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -1276,8 +1276,8 @@ static const struct ice_dummy_pkt_profile ice_dummy_pkt_profiles[] = {
 	ICE_PKT_PROFILE(udp_ipv6, ICE_PKT_OUTER_IPV6 | ICE_PKT_INNER_UDP),
 	ICE_PKT_PROFILE(vlan_udp, ICE_PKT_INNER_UDP | ICE_PKT_VLAN),
 	ICE_PKT_PROFILE(udp, ICE_PKT_INNER_UDP),
-	ICE_PKT_PROFILE(vlan_tcp_ipv6, ICE_PKT_INNER_IPV6 | ICE_PKT_VLAN),
-	ICE_PKT_PROFILE(tcp_ipv6, ICE_PKT_INNER_IPV6),
+	ICE_PKT_PROFILE(vlan_tcp_ipv6, ICE_PKT_OUTER_IPV6 | ICE_PKT_VLAN),
+	ICE_PKT_PROFILE(tcp_ipv6, ICE_PKT_OUTER_IPV6),
 	ICE_PKT_PROFILE(vlan_tcp, ICE_PKT_VLAN),
 	ICE_PKT_PROFILE(tcp, 0),
 };
-- 
2.35.1

