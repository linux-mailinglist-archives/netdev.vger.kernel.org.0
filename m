Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04DBDCE2DC
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 15:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbfJGNOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 09:14:21 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:38168 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727010AbfJGNOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 09:14:21 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 7 Oct 2019 15:14:14 +0200
Received: from dev-l-vrt-207-011.mtl.labs.mlnx. (dev-l-vrt-207-011.mtl.labs.mlnx [10.134.207.11])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x97DEEc4028225;
        Mon, 7 Oct 2019 16:14:14 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        alaa@mellanox.com, moshe@mellanox.com,
        Alex Vesker <valex@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH net] net/mlx5: DR, Allow insertion of duplicate rules
Date:   Mon,  7 Oct 2019 16:13:25 +0300
Message-Id: <1570454005-23749-1-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>

Duplicate rules were not allowed to be configured with SW steering.
This restriction caused failures with the replace rule logic done by
upper layers.

This fix allows for multiple rules with the same match values, in
such case the first inserted rules will match.

Fixes: 41d07074154c ("net/mlx5: DR, Expose steering rule functionality")
Signed-off-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

Hi Dave,
I'm temporarily replacing Saeed with the submissions, as he's on vacation.
This patch by Alex removes the rule duplication restriction, as it disrupted
valid flows.

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index 4187f2b112b8..e8b656075c6f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -788,12 +788,10 @@ static int dr_rule_handle_empty_entry(struct mlx5dr_matcher *matcher,
 			 * it means that all the previous stes are the same,
 			 * if so, this rule is duplicated.
 			 */
-			if (mlx5dr_ste_is_last_in_rule(nic_matcher,
-						       matched_ste->ste_chain_location)) {
-				mlx5dr_info(dmn, "Duplicate rule inserted, aborting!!\n");
-				return NULL;
-			}
-			return matched_ste;
+			if (!mlx5dr_ste_is_last_in_rule(nic_matcher, ste_location))
+				return matched_ste;
+
+			mlx5dr_dbg(dmn, "Duplicate rule inserted\n");
 		}
 
 		if (!skip_rehash && dr_rule_need_enlarge_hash(cur_htbl, dmn, nic_dmn)) {
-- 
1.8.3.1

