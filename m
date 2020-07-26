Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A54422DEB4
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 13:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728161AbgGZLkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 07:40:18 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:32814
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727927AbgGZLjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 07:39:55 -0400
X-IronPort-AV: E=Sophos;i="5.75,398,1589234400"; 
   d="scan'208";a="355309546"
Received: from palace.rsr.lip6.fr (HELO palace.lip6.fr) ([132.227.105.202])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/AES256-SHA256; 26 Jul 2020 13:39:47 +0200
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     kernel-janitors@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] net/mlx5: drop unnecessary list_empty
Date:   Sun, 26 Jul 2020 12:58:29 +0200
Message-Id: <1595761112-11003-5-git-send-email-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1595761112-11003-1-git-send-email-Julia.Lawall@inria.fr>
References: <1595761112-11003-1-git-send-email-Julia.Lawall@inria.fr>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

list_for_each_entry is able to handle an empty list.
The only effect of avoiding the loop is not initializing the
index variable.
Drop list_empty tests in cases where these variables are not
used.

Note that list_for_each_entry is defined in terms of list_first_entry,
which indicates that it should not be used on an empty list.  But in
list_for_each_entry, the element obtained by list_first_entry is not
really accessed, only the address of its list_head field is compared
to the address of the list head, so the list_first_entry is safe.

The semantic patch that makes this change is as follows (with another
variant for the no brace case): (http://coccinelle.lip6.fr/)

<smpl>
@@
expression x,e;
iterator name list_for_each_entry;
statement S;
identifier i;
@@

-if (!(list_empty(x))) {
   list_for_each_entry(i,x,...) S
- }
 ... when != i
? i = e
</smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c |   13 ++++------
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c    |    5 +--
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index 31abcbb..23a1172 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -474,14 +474,13 @@ static int dr_matcher_add_to_tbl(struct mlx5dr_matcher *matcher)
 	int ret;
 
 	next_matcher = NULL;
-	if (!list_empty(&tbl->matcher_list))
-		list_for_each_entry(tmp_matcher, &tbl->matcher_list, matcher_list) {
-			if (tmp_matcher->prio >= matcher->prio) {
-				next_matcher = tmp_matcher;
-				break;
-			}
-			first = false;
+	list_for_each_entry(tmp_matcher, &tbl->matcher_list, matcher_list) {
+		if (tmp_matcher->prio >= matcher->prio) {
+			next_matcher = tmp_matcher;
+			break;
 		}
+		first = false;
+	}
 
 	prev_matcher = NULL;
 	if (next_matcher && !first)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index cd708dc..6ec5106 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -574,9 +574,8 @@ void mlx5dr_rule_update_rule_member(struct mlx5dr_ste *ste,
 {
 	struct mlx5dr_rule_member *rule_mem;
 
-	if (!list_empty(&ste->rule_list))
-		list_for_each_entry(rule_mem, &ste->rule_list, use_ste_list)
-			rule_mem->ste = new_ste;
+	list_for_each_entry(rule_mem, &ste->rule_list, use_ste_list)
+		rule_mem->ste = new_ste;
 }
 
 static void dr_rule_clean_rule_members(struct mlx5dr_rule *rule,

