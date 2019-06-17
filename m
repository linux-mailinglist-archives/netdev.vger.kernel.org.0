Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B94754803E
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 13:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbfFQLJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 07:09:09 -0400
Received: from mout.kundenserver.de ([217.72.192.74]:55229 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726730AbfFQLJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 07:09:09 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MZSym-1i5r5w3peI-00WRtT; Mon, 17 Jun 2019 13:08:59 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, Oz Shlomo <ozsh@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/mlx5e: reduce stack usage in mlx5_eswitch_termtbl_create
Date:   Mon, 17 Jun 2019 13:08:22 +0200
Message-Id: <20190617110855.2085326-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:xpealiSDqaGMOSOW167AmUNZ9keZ5oPMTcByDXU0S+i0b4fbvlg
 UJW7rl7HuiMTPTQXUHK4SEs+H2Cm0UCkKGBPGjL8RpVDWZhxHsDq941KnbmhxHV8dvUNpI7
 U7YHMsPKWIFXcncEpu0dtswxPB3kZP/gPfKzFRxscff2Rfi/Vq/x4XaYEuyEhUJmJy3wsV2
 l6dWCJfvRcK/lsafzoicg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:8eSzBrY2/xk=:02bA9zm8tIK+y6WJJQ9r0q
 Jk21B3ElC1T8zOiw1/+FRSDTbSbPzHXU8BAOwfUwwQkjf9m7HkjJbLlMio2zc/kKXIxlgLWkE
 kfch+THVAbSVZVQ3Cv8jQEwFirU4EFac9SfJOJrMAIFoUzSoetUNLEnkEIEz29IBg7hmHVTwh
 24kK2OLa9M0t4JMoJnLUeVPgU5Gzxd1gJphvMujTVbj9D3KkSLAwoCNFZl7PvDC7h4XH+CoJY
 +4YD1iGthGJM43udOXgXXEQg4vbI4fg+iQ/pUMDre5YWY5OOj/aDHRsQYqEln1FlvzDP8bP/8
 YzzYNkhqudCtWEuBKLa8X0iIVRtS3GErHS9U/Z3VZmlTTlcT+fdyq2w6yA8LO9ogEDylMLpl6
 2SCRw+RCn9jmgyaLepxZNvBP+a4AspHY21m5uP8Vg8S75JcChXQ2YrvEOjQlwBNy7YXHDMQ8j
 FiqpXod4HlHa9Lomgf3xcdRLyMvdHESSMnKSgM6FKyteP/ISoKModZ0P3lDmuXefOO/QvZFah
 go8bY2xBs4qwr3YXA9So7cpfnMhZq+CAtzyCSRwuOOrsYEuBp+Fr17gZno1Efcad9gAeg0Tvp
 fJ01fdQuGiLeRQfqvSh5Oluet/e25lAr72xC4Jl77+VxwcWK0VK2ljSaylYG9MzHRLg9rFHnh
 Z4YLjGBHtquRucuxfdShoSChA0N4irT2h6E3U+R5Mhk0K8cZa0Twdmzh3xZA/vz73XQr2EBY0
 /BOflpxH7K/NVHfm1ChxTdLnTS/R9PWxWK+ZvA==
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
---
 .../mlx5/core/eswitch_offloads_termtbl.c      |  2 +-
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 20 +++++++++----------
 include/linux/mlx5/fs.h                       |  2 +-
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
index cb7d8ebe2c95..171f3d4ef9ac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -50,7 +50,7 @@ mlx5_eswitch_termtbl_create(struct mlx5_core_dev *dev,
 			    struct mlx5_flow_act *flow_act)
 {
 	struct mlx5_flow_namespace *root_ns;
-	struct mlx5_flow_spec spec = {};
+	static const struct mlx5_flow_spec spec = {};
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

