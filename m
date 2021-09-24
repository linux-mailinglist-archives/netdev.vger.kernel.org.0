Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C323417B45
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 20:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346809AbhIXSt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 14:49:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236495AbhIXStw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 14:49:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A3A761268;
        Fri, 24 Sep 2021 18:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632509298;
        bh=rUHwFczmZ5lLk2hlTEsjstLzmMz0KdqpdSwgdHQmbNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qogh6CbUs0Lbyodq7eNj/Hqqu7Hx+DM4cdSW5pDyuhuRhkraEoBDWSSYrh0TITmuW
         RFmMkhdBIvdKJwTfOO5+/G645nivLam8Q3FEzcCEPaUIhPg+jXlWVdyNyWLJME36yN
         ulOSd/tNmMpp3oJmVca/RJ+ow5SrB3E6gQ7d1cMpAYdBkjxJnLpdbYY5xnxtFzofvP
         snRghWmycXpFS6YbLi0CJyCvrXBxyKf2Gd0hL1NwV0G16xo91I73kW3XIp+5FhVJep
         luBrjTWyUCMNzADNQscaycy06YrAdJf8fjC0JJscBiriQzfshFb9betUVq+SJWKcgf
         CCZSSzMWN0mZQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/12] net/mlx5e: Use correct return type
Date:   Fri, 24 Sep 2021 11:47:59 -0700
Message-Id: <20210924184808.796968-4-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210924184808.796968-1-saeed@kernel.org>
References: <20210924184808.796968-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

modify_header_match_supported() should return type bool but
it returns the value returned by is_action_keys_supported()
which is type int.

is_action_keys_supported() always returns either -EOPNOTSUPP
or 0 and it shouldn't change as the purpose of the function
is checking for support. so just make the function return
a bool type.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 27 +++++++++----------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index ba8164792016..f55fc8553664 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3025,10 +3025,10 @@ struct ipv6_hoplimit_word {
 	__u8	hop_limit;
 };
 
-static int is_action_keys_supported(const struct flow_action_entry *act,
-				    bool ct_flow, bool *modify_ip_header,
-				    bool *modify_tuple,
-				    struct netlink_ext_ack *extack)
+static bool
+is_action_keys_supported(const struct flow_action_entry *act, bool ct_flow,
+			 bool *modify_ip_header, bool *modify_tuple,
+			 struct netlink_ext_ack *extack)
 {
 	u32 mask, offset;
 	u8 htype;
@@ -3056,7 +3056,7 @@ static int is_action_keys_supported(const struct flow_action_entry *act,
 		if (ct_flow && *modify_tuple) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "can't offload re-write of ipv4 address with action ct");
-			return -EOPNOTSUPP;
+			return false;
 		}
 	} else if (htype == FLOW_ACT_MANGLE_HDR_TYPE_IP6) {
 		struct ipv6_hoplimit_word *hoplimit_word =
@@ -3074,7 +3074,7 @@ static int is_action_keys_supported(const struct flow_action_entry *act,
 		if (ct_flow && *modify_tuple) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "can't offload re-write of ipv6 address with action ct");
-			return -EOPNOTSUPP;
+			return false;
 		}
 	} else if (htype == FLOW_ACT_MANGLE_HDR_TYPE_TCP ||
 		   htype == FLOW_ACT_MANGLE_HDR_TYPE_UDP) {
@@ -3082,11 +3082,11 @@ static int is_action_keys_supported(const struct flow_action_entry *act,
 		if (ct_flow) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "can't offload re-write of transport header ports with action ct");
-			return -EOPNOTSUPP;
+			return false;
 		}
 	}
 
-	return 0;
+	return true;
 }
 
 static bool modify_tuple_supported(bool modify_tuple, bool ct_clear,
@@ -3133,7 +3133,7 @@ static bool modify_header_match_supported(struct mlx5e_priv *priv,
 	void *headers_v;
 	u16 ethertype;
 	u8 ip_proto;
-	int i, err;
+	int i;
 
 	headers_c = get_match_headers_criteria(actions, spec);
 	headers_v = get_match_headers_value(actions, spec);
@@ -3151,11 +3151,10 @@ static bool modify_header_match_supported(struct mlx5e_priv *priv,
 		    act->id != FLOW_ACTION_ADD)
 			continue;
 
-		err = is_action_keys_supported(act, ct_flow,
-					       &modify_ip_header,
-					       &modify_tuple, extack);
-		if (err)
-			return err;
+		if (!is_action_keys_supported(act, ct_flow,
+					      &modify_ip_header,
+					      &modify_tuple, extack))
+			return false;
 	}
 
 	if (!modify_tuple_supported(modify_tuple, ct_clear, ct_flow, extack,
-- 
2.31.1

