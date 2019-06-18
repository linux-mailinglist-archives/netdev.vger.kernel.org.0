Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4F0749F02
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 13:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729605AbfFRLQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 07:16:38 -0400
Received: from mout.kundenserver.de ([212.227.126.135]:49241 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729110AbfFRLQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 07:16:38 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MdNoW-1iCFrv3MLg-00ZMh3; Tue, 18 Jun 2019 13:16:27 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Mark Bloch <markb@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [v2] net/mlx5e: reduce stack usage in mlx5_eswitch_termtbl_create
Date:   Tue, 18 Jun 2019 13:15:06 +0200
Message-Id: <20190618111621.3030135-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:i2PL6r0NEVKSiNUPxbZ77WWqHLxjqQdoMjTBa1JgiLhiYyUZuxi
 3QHgxzOacC5Ep7e1SK3Chjw6ER7qwrglRq+w242TXPTHFSgMdTS2W1JUiEVexPE5aXeNrLZ
 kptqbRP+yCORWNaMUJ9qSmQwRiYpIJTwPKlt/0piaVymOVRN42xPRmIWBMxsokTLaZvKqxC
 e5GQ11QksJtqxqlp+U0vA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:2Z9d6cu2aa0=:X1FmTDKwguaSqfUiXk255R
 7TurpA/JOHwzaAkMd728/8kNbZTF8wQutg0hNNYkK7ZBeuc1v5SH6/z4RZXHVT/zq59mMTiTb
 7qs+95vNeSmmCahe0C/BeilXnWDuWQO9ysADADhhCUzn5OeNUsl7W+Z6NF1ly0DxYsLIo+uFt
 Ex7kwf7IgwBdDHKffvQAb8UNYMviUIHEvl5550bsOkdpjLPcTMl+ej6Mz8CZmEDvH0B7ndTjg
 9Ltq5ZnBVNIam5fzuE6biMZooiPRSbosoWZIkSl1N6oxY9QK4WaqMk4ZiI81jcUoUFBN3GInn
 wqGZUw2uhd+scdmodAfWygHa7UmH7hJaWJd+oVWTWaiz01OL9sLUI+8BGwDBcUKFIHy4OeDca
 WWg+3CVpQQNK/mOJ1UJXiaIbuwRh1o/YK74LVTxMW/M1J3lx4xB/o+V+8tNWbDnj8PhYliqvO
 e/SqIesjLA3qYdBcN59vITaj8GBYEHyIWC8m09ifxM1yXCSOeaidZKPzqHltkuuqFKwqMurLn
 UINMjpSR/38Ph/fy6TPBfpelGDJLyQUI8nwhlQ3dkg92NLoYwstY6XQwd6/2zqfWYst7VLHaE
 h7Tf8U7bdrrKx4oNZiJf6q2pVfVdwpSnQpdHt9p6JxWyMYyVWfjAFfhwLJj07v3NWfF/9X0W7
 SQbCbvjvJyNuli9o79PalO1aukHd5sJEPuRzpN0nOVXQJwykSb7FOhTbN+vxfuJmAxgxf0lHm
 J7MSGHVToWajFdByzakS+KSDAkpXF+q8N9umrQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Putting an empty 'mlx5_flow_spec' structure on the stack is a bit
wasteful and causes a warning on 32-bit architectures when building
with clang -fsanitize-coverage:

drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c: In function 'mlx5_eswitch_termtbl_create':
drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c:90:1: error: the frame size of 1032 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]

Since the structure is never written to, we can statically allocate
it to avoid the stack usage. To be on the safe side, mark all
subsequent function arguments that we pass it into as 'const'
as well.

Fixes: 10caabdaad5a ("net/mlx5e: Use termination table for VLAN push actions")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Saeed Mahameed <saeedm@mellanox.com>
Acked-by: Mark Bloch <markb@mellanox.com>
---
v2: only style changes (reverse xmas tree)
---
 .../mlx5/core/eswitch_offloads_termtbl.c      |  2 +-
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 20 +++++++++----------
 include/linux/mlx5/fs.h                       |  2 +-
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
index cb7d8ebe2c95..1d55a324a17e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -49,8 +49,8 @@ mlx5_eswitch_termtbl_create(struct mlx5_core_dev *dev,
 			    struct mlx5_termtbl_handle *tt,
 			    struct mlx5_flow_act *flow_act)
 {
+	static const struct mlx5_flow_spec spec = {};
 	struct mlx5_flow_namespace *root_ns;
-	struct mlx5_flow_spec spec = {};
 	int prio, flags;
 	int err;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index fe76c6fd6d80..739123e1363b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -584,7 +584,7 @@ static int insert_fte(struct mlx5_flow_group *fg, struct fs_fte *fte)
 }
 
 static struct fs_fte *alloc_fte(struct mlx5_flow_table *ft,
-				u32 *match_value,
+				const u32 *match_value,
 				struct mlx5_flow_act *flow_act)
 {
 	struct mlx5_flow_steering *steering = get_steering(&ft->node);
@@ -612,7 +612,7 @@ static void dealloc_flow_group(struct mlx5_flow_steering *steering,
 
 static struct mlx5_flow_group *alloc_flow_group(struct mlx5_flow_steering *steering,
 						u8 match_criteria_enable,
-						void *match_criteria,
+						const void *match_criteria,
 						int start_index,
 						int end_index)
 {
@@ -642,7 +642,7 @@ static struct mlx5_flow_group *alloc_flow_group(struct mlx5_flow_steering *steer
 
 static struct mlx5_flow_group *alloc_insert_flow_group(struct mlx5_flow_table *ft,
 						       u8 match_criteria_enable,
-						       void *match_criteria,
+						       const void *match_criteria,
 						       int start_index,
 						       int end_index,
 						       struct list_head *prev)
@@ -1285,7 +1285,7 @@ add_rule_fte(struct fs_fte *fte,
 }
 
 static struct mlx5_flow_group *alloc_auto_flow_group(struct mlx5_flow_table  *ft,
-						     struct mlx5_flow_spec *spec)
+						     const struct mlx5_flow_spec *spec)
 {
 	struct list_head *prev = &ft->node.children;
 	struct mlx5_flow_group *fg;
@@ -1451,7 +1451,7 @@ static int check_conflicting_ftes(struct fs_fte *fte, const struct mlx5_flow_act
 }
 
 static struct mlx5_flow_handle *add_rule_fg(struct mlx5_flow_group *fg,
-					    u32 *match_value,
+					    const u32 *match_value,
 					    struct mlx5_flow_act *flow_act,
 					    struct mlx5_flow_destination *dest,
 					    int dest_num,
@@ -1536,7 +1536,7 @@ static void free_match_list(struct match_list_head *head)
 
 static int build_match_list(struct match_list_head *match_head,
 			    struct mlx5_flow_table *ft,
-			    struct mlx5_flow_spec *spec)
+			    const struct mlx5_flow_spec *spec)
 {
 	struct rhlist_head *tmp, *list;
 	struct mlx5_flow_group *g;
@@ -1589,7 +1589,7 @@ static u64 matched_fgs_get_version(struct list_head *match_head)
 
 static struct fs_fte *
 lookup_fte_locked(struct mlx5_flow_group *g,
-		  u32 *match_value,
+		  const u32 *match_value,
 		  bool take_write)
 {
 	struct fs_fte *fte_tmp;
@@ -1622,7 +1622,7 @@ lookup_fte_locked(struct mlx5_flow_group *g,
 static struct mlx5_flow_handle *
 try_add_to_existing_fg(struct mlx5_flow_table *ft,
 		       struct list_head *match_head,
-		       struct mlx5_flow_spec *spec,
+		       const struct mlx5_flow_spec *spec,
 		       struct mlx5_flow_act *flow_act,
 		       struct mlx5_flow_destination *dest,
 		       int dest_num,
@@ -1715,7 +1715,7 @@ try_add_to_existing_fg(struct mlx5_flow_table *ft,
 
 static struct mlx5_flow_handle *
 _mlx5_add_flow_rules(struct mlx5_flow_table *ft,
-		     struct mlx5_flow_spec *spec,
+		     const struct mlx5_flow_spec *spec,
 		     struct mlx5_flow_act *flow_act,
 		     struct mlx5_flow_destination *dest,
 		     int dest_num)
@@ -1823,7 +1823,7 @@ static bool fwd_next_prio_supported(struct mlx5_flow_table *ft)
 
 struct mlx5_flow_handle *
 mlx5_add_flow_rules(struct mlx5_flow_table *ft,
-		    struct mlx5_flow_spec *spec,
+		    const struct mlx5_flow_spec *spec,
 		    struct mlx5_flow_act *flow_act,
 		    struct mlx5_flow_destination *dest,
 		    int num_dest)
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 2ddaa97f2179..c0c029664527 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -200,7 +200,7 @@ struct mlx5_flow_act {
  */
 struct mlx5_flow_handle *
 mlx5_add_flow_rules(struct mlx5_flow_table *ft,
-		    struct mlx5_flow_spec *spec,
+		    const struct mlx5_flow_spec *spec,
 		    struct mlx5_flow_act *flow_act,
 		    struct mlx5_flow_destination *dest,
 		    int num_dest);
-- 
2.20.0

