Return-Path: <netdev+bounces-8801-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 73643725D64
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 13:40:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2DEBD280DB1
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 11:40:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAD5333C87;
	Wed,  7 Jun 2023 11:39:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3A06AB7
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 11:39:19 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44661BD2
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 04:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686137957; x=1717673957;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ti0hfHdlFWZCp7J9Fe50YuN18VWq+kt52BEG3JEjSno=;
  b=DnyqXF+eSQ+9NEzpvaJR6U5sjz2V/WqzBvMk+blzRRtCzdIZBY7nJgUx
   KNHpX03ltH/T+SWS3kRGIVBU9EmEwAVGRksmLmZAmxydSb5WYe8PaTfA/
   bdLvqX6scnjI8CBe1hJmdW4Cz5q3tXlWFaz5qsNj/6bny+w4Z3AksJJ4e
   SvdciBEBUYYtruH78uz0VtrQIgqfYZYd7HeMtrj4yIGaG2FQbaugeGWPz
   yC0p/k3mWuY5ce8QXIVPaPNO3gAc7ge3YfQiC6lKIMBdzpIS3go2+4H6d
   3vY6HnJy0eA67G2yx8NmhFN27ePuSTt10+F+Vy1CD49Q5cDhk6Nbu2fQG
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="359432181"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="359432181"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 04:39:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="686935783"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="686935783"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by orsmga006.jf.intel.com with ESMTP; 07 Jun 2023 04:39:08 -0700
Received: from giewont.igk.intel.com (giewont.igk.intel.com [10.211.8.15])
	by irvmail002.ir.intel.com (Postfix) with ESMTP id AF7B435815;
	Wed,  7 Jun 2023 12:39:06 +0100 (IST)
From: Marcin Szycik <marcin.szycik@linux.intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org,
	wojciech.drewek@intel.com,
	michal.swiatkowski@linux.intel.com,
	aleksander.lobakin@intel.com,
	davem@davemloft.net,
	kuba@kernel.org,
	jiri@resnulli.us,
	pabeni@redhat.com,
	jesse.brandeburg@intel.com,
	simon.horman@corigine.com,
	idosch@nvidia.com,
	Marcin Szycik <marcin.szycik@linux.intel.com>
Subject: [PATCH iwl-next v2 5/6] ice: refactor ICE_TC_FLWR_FIELD_ENC_OPTS
Date: Wed,  7 Jun 2023 13:26:05 +0200
Message-Id: <20230607112606.15899-6-marcin.szycik@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230607112606.15899-1-marcin.szycik@linux.intel.com>
References: <20230607112606.15899-1-marcin.szycik@linux.intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

FLOW_DISSECTOR_KEY_ENC_OPTS can be used for multiple headers, but currently
it is treated as GTP-exclusive in ice. Rename ICE_TC_FLWR_FIELD_ENC_OPTS to
ICE_TC_FLWR_FIELD_GTP_OPTS and check for tunnel type earlier. After this
refactor, it is easier to add new headers using FLOW_DISSECTOR_KEY_ENC_OPTS
- instead of checking tunnel type in ice_tc_count_lkups() and
ice_tc_fill_tunnel_outer(), it needs to be checked only once, in
ice_parse_tunnel_attr().

Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/intel/ice/ice_tc_lib.c | 10 +++++-----
 drivers/net/ethernet/intel/ice/ice_tc_lib.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index b54052ef6050..b48ded4bd067 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -27,7 +27,7 @@ ice_tc_count_lkups(u32 flags, struct ice_tc_flower_lyr_2_4_hdrs *headers,
 	if (flags & ICE_TC_FLWR_FIELD_ENC_DST_MAC)
 		lkups_cnt++;
 
-	if (flags & ICE_TC_FLWR_FIELD_ENC_OPTS)
+	if (flags & ICE_TC_FLWR_FIELD_GTP_OPTS)
 		lkups_cnt++;
 
 	if (flags & (ICE_TC_FLWR_FIELD_ENC_SRC_IPV4 |
@@ -220,8 +220,7 @@ ice_tc_fill_tunnel_outer(u32 flags, struct ice_tc_flower_fltr *fltr,
 		i++;
 	}
 
-	if (flags & ICE_TC_FLWR_FIELD_ENC_OPTS &&
-	    (fltr->tunnel_type == TNL_GTPU || fltr->tunnel_type == TNL_GTPC)) {
+	if (flags & ICE_TC_FLWR_FIELD_GTP_OPTS) {
 		list[i].type = ice_proto_type_from_tunnel(fltr->tunnel_type);
 
 		if (fltr->gtp_pdu_info_masks.pdu_type) {
@@ -1305,7 +1304,8 @@ ice_parse_tunnel_attr(struct net_device *dev, struct flow_rule *rule,
 		}
 	}
 
-	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_OPTS)) {
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_OPTS) &&
+	    (fltr->tunnel_type == TNL_GTPU || fltr->tunnel_type == TNL_GTPC)) {
 		struct flow_match_enc_opts match;
 
 		flow_rule_match_enc_opts(rule, &match);
@@ -1316,7 +1316,7 @@ ice_parse_tunnel_attr(struct net_device *dev, struct flow_rule *rule,
 		memcpy(&fltr->gtp_pdu_info_masks, &match.mask->data[0],
 		       sizeof(struct gtp_pdu_session_info));
 
-		fltr->flags |= ICE_TC_FLWR_FIELD_ENC_OPTS;
+		fltr->flags |= ICE_TC_FLWR_FIELD_GTP_OPTS;
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.h b/drivers/net/ethernet/intel/ice/ice_tc_lib.h
index 8bbc1a62bdb1..aed48d1ff83f 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.h
@@ -22,7 +22,7 @@
 #define ICE_TC_FLWR_FIELD_ENC_SRC_L4_PORT	BIT(15)
 #define ICE_TC_FLWR_FIELD_ENC_DST_MAC		BIT(16)
 #define ICE_TC_FLWR_FIELD_ETH_TYPE_ID		BIT(17)
-#define ICE_TC_FLWR_FIELD_ENC_OPTS		BIT(18)
+#define ICE_TC_FLWR_FIELD_GTP_OPTS		BIT(18)
 #define ICE_TC_FLWR_FIELD_CVLAN			BIT(19)
 #define ICE_TC_FLWR_FIELD_PPPOE_SESSID		BIT(20)
 #define ICE_TC_FLWR_FIELD_PPP_PROTO		BIT(21)
-- 
2.31.1


