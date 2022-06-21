Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF273553EB7
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 00:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354763AbiFUWvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 18:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbiFUWu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 18:50:59 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6D7220EC
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 15:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655851858; x=1687387858;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aGpBvxCWBPt6U7gUTskuJyKDrmmHAdYv5l4YrcjMEmk=;
  b=TABYMpO8Jp9zV+KuWaeugA5ZaOSUppjr7p+i4J4HvkU3wPS4dyO5Q2J4
   GjE83lqGFC2WF1Zclh8uqWXX9gofgnIlc3jTPh2bEATKXD1K+a9iK0kK8
   FwFu48XX/ArAqW6cOcw7/FT/d3MxRM9oGue+/+m/S+OzE2NCAdSvjKCAl
   BpEmi17ua8B73bXm8Z4xomitwlF6FkIqwQY6DXUoFC29L+tqzRK/fr0Yp
   dn6Rk6C1FY6NbGktEIk7LhGWgcrT0uzg2BXZFYUekK3Z5Kf5p6KhEo2Fg
   0GouhH4kDNa6DHZ2pQPYvF4dliDw03FKf7zvLfKRTsSF5RYOqztHegZf0
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="277806456"
X-IronPort-AV: E=Sophos;i="5.92,210,1650956400"; 
   d="scan'208";a="277806456"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 15:50:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,210,1650956400"; 
   d="scan'208";a="655359201"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 21 Jun 2022 15:50:57 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Marcin Szycik <marcin.szycik@linux.intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net 1/4] ice: ignore protocol field in GTP offload
Date:   Tue, 21 Jun 2022 15:47:53 -0700
Message-Id: <20220621224756.631765-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220621224756.631765-1-anthony.l.nguyen@intel.com>
References: <20220621224756.631765-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcin Szycik <marcin.szycik@linux.intel.com>

Commit 34a897758efe ("ice: Add support for inner etype in switchdev")
added the ability to match on inner ethertype. A side effect of that change
is that it is now impossible to add some filters for protocols which do not
contain inner ethtype field. tc requires the protocol field to be specified
when providing certain other options, e.g. src_ip. This is a problem in
case of GTP - when user wants to specify e.g. src_ip, they also need to
specify protocol in tc command (otherwise tc fails with: Illegal "src_ip").
Because GTP is a tunnel, the protocol field is treated as inner protocol.
GTP does not contain inner ethtype field and the filter cannot be added.

To fix this, ignore the ethertype field in case of GTP filters.

Fixes: 9a225f81f540 ("ice: Support GTP-U and GTP-C offload in switchdev")
Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_tc_lib.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index 0a0c55fb8699..b677c62a244c 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -993,7 +993,9 @@ ice_parse_cls_flower(struct net_device *filter_dev, struct ice_vsi *vsi,
 		n_proto_key = ntohs(match.key->n_proto);
 		n_proto_mask = ntohs(match.mask->n_proto);
 
-		if (n_proto_key == ETH_P_ALL || n_proto_key == 0) {
+		if (n_proto_key == ETH_P_ALL || n_proto_key == 0 ||
+		    fltr->tunnel_type == TNL_GTPU ||
+		    fltr->tunnel_type == TNL_GTPC) {
 			n_proto_key = 0;
 			n_proto_mask = 0;
 		} else {
-- 
2.35.1

