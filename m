Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0030B3FF3CD
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 21:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347335AbhIBTHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 15:07:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347293AbhIBTHF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 15:07:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04F14610A2;
        Thu,  2 Sep 2021 19:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630609566;
        bh=rUHwFczmZ5lLk2hlTEsjstLzmMz0KdqpdSwgdHQmbNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dTT5ZxcGGiH69pRD6794c0r4/D2InduhsDubRJwmcUZ5QxZ+v4Mw0Bnxuod+WaZJ3
         eV/ZWHO6U7Im/aV+RqJL4j48fEeFPzBT9p3UWeIHOJOk8uPngxDRXCSu3IV+gMbmdE
         ZjvFlk3k0RkUEgR4z3sqyaZ6mSfC/wfAoFLzBgC3Omf4kp/JbXfIQsTzmraWNOpyzF
         T7JCTsQV1DB/LhMBfZkWtNAunIAgGniPgsxm53Z4gQcCkBvXnaBBsqr8yq2nmpCl/C
         EJ+bPf9RE+quU83ApJT/d4ysM1Koo5ZxkiosgujPB5pwtbiNmgYLGIw3IeNe/un7ZM
         sJFmXF0uq0NlQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/15] net/mlx5e: Use correct return type
Date:   Thu,  2 Sep 2021 12:05:43 -0700
Message-Id: <20210902190554.211497-5-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210902190554.211497-1-saeed@kernel.org>
References: <20210902190554.211497-1-saeed@kernel.org>
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

