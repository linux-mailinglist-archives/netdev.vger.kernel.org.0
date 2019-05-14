Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 474EF1C5BF
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 11:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbfENJNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 05:13:10 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:35411 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725916AbfENJNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 05:13:10 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from jianbol@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 14 May 2019 12:13:08 +0300
Received: from r-vrt-24-60.mtr.labs.mlnx (r-vrt-24-60.mtr.labs.mlnx [10.213.24.60])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x4E9D8EP015572;
        Tue, 14 May 2019 12:13:08 +0300
From:   Jianbo Liu <jianbol@mellanox.com>
To:     netdev@vger.kernel.org, ecree@solarflare.com
Cc:     Jianbo Liu <jianbol@mellanox.com>
Subject: [PATCH] net/mlx5e: Fix calling wrong function to get inner vlan key and mask
Date:   Tue, 14 May 2019 09:12:52 +0000
Message-Id: <20190514091252.26258-1-jianbol@mellanox.com>
X-Mailer: git-send-email 2.13.6
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When flow_rule_match_XYZ() functions were first introduced,
flow_rule_match_cvlan() for inner vlan is missing.

In mlx5_core driver, to get inner vlan key and mask, flow_rule_match_vlan()
is just called, which is wrong because it obtains outer vlan information by
FLOW_DISSECTOR_KEY_VLAN.

This commit fixes this by changing to call flow_rule_match_cvlan() after
it's added.

Fixes: 8f2566225ae2 ("flow_offload: add flow_rule and flow_match structures and use them")
Signed-off-by: Jianbo Liu <jianbol@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 122f457091a2..542354b5eb4d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1595,7 +1595,7 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CVLAN)) {
 		struct flow_match_vlan match;
 
-		flow_rule_match_vlan(rule, &match);
+		flow_rule_match_cvlan(rule, &match);
 		if (match.mask->vlan_id ||
 		    match.mask->vlan_priority ||
 		    match.mask->vlan_tpid) {
-- 
2.13.6

