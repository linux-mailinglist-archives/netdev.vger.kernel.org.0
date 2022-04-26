Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1DE150FB0E
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 12:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349260AbiDZKkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 06:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350002AbiDZKjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 06:39:52 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C10EA33379;
        Tue, 26 Apr 2022 03:29:37 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 9A2431E80D56;
        Tue, 26 Apr 2022 18:26:22 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ov-cdY0XkzzQ; Tue, 26 Apr 2022 18:26:19 +0800 (CST)
Received: from ubuntu.localdomain (unknown [101.228.255.56])
        (Authenticated sender: yuzhe@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 1FB091E80CE6;
        Tue, 26 Apr 2022 18:26:19 +0800 (CST)
From:   Yu Zhe <yuzhe@nfschina.com>
To:     mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Cc:     b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, liqiong@nfschina.com,
        kernel-janitors@vger.kernel.org, hukun@nfschina.com,
        Yu Zhe <yuzhe@nfschina.com>, kernel test robot <lkp@intel.com>
Subject: [PATCH v2] batman-adv: remove unnecessary type castings
Date:   Tue, 26 Apr 2022 03:29:31 -0700
Message-Id: <20220426102932.1613820-1-yuzhe@nfschina.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220425113635.1609532-1-yuzhe@nfschina.com>
References: <20220425113635.1609532-1-yuzhe@nfschina.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Yu Zhe <yuzhe@nfschina.com>
[sven@narfation.org: Fix missing const in batadv_choose* functions]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Reported-by: kernel test robot <lkp@intel.com>

---
v2:
- fix discarding 'const' qualifier from pointer target type
---
 net/batman-adv/bridge_loop_avoidance.c |  4 ++--
 net/batman-adv/translation-table.c     | 12 ++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/batman-adv/bridge_loop_avoidance.c b/net/batman-adv/bridge_loop_avoidance.c
index 7f8a14d99cdb..37ce6cfb3520 100644
--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -65,7 +65,7 @@ batadv_bla_send_announce(struct batadv_priv *bat_priv,
  */
 static inline u32 batadv_choose_claim(const void *data, u32 size)
 {
-	struct batadv_bla_claim *claim = (struct batadv_bla_claim *)data;
+	const struct batadv_bla_claim *claim = data;
 	u32 hash = 0;
 
 	hash = jhash(&claim->addr, sizeof(claim->addr), hash);
@@ -86,7 +86,7 @@ static inline u32 batadv_choose_backbone_gw(const void *data, u32 size)
 	const struct batadv_bla_backbone_gw *gw;
 	u32 hash = 0;
 
-	gw = (struct batadv_bla_backbone_gw *)data;
+	gw = data;
 	hash = jhash(&gw->orig, sizeof(gw->orig), hash);
 	hash = jhash(&gw->vid, sizeof(gw->vid), hash);
 
diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index 8478034d3abf..01d30c1e412c 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -103,10 +103,10 @@ static bool batadv_compare_tt(const struct hlist_node *node, const void *data2)
  */
 static inline u32 batadv_choose_tt(const void *data, u32 size)
 {
-	struct batadv_tt_common_entry *tt;
+	const struct batadv_tt_common_entry *tt;
 	u32 hash = 0;
 
-	tt = (struct batadv_tt_common_entry *)data;
+	tt = data;
 	hash = jhash(&tt->addr, ETH_ALEN, hash);
 	hash = jhash(&tt->vid, sizeof(tt->vid), hash);
 
@@ -2766,7 +2766,7 @@ static void batadv_tt_tvlv_generate(struct batadv_priv *bat_priv,
 	u32 i;
 
 	tt_tot = batadv_tt_entries(tt_len);
-	tt_change = (struct batadv_tvlv_tt_change *)tvlv_buff;
+	tt_change = tvlv_buff;
 
 	if (!valid_cb)
 		return;
@@ -3994,7 +3994,7 @@ static void batadv_tt_tvlv_ogm_handler_v1(struct batadv_priv *bat_priv,
 	if (tvlv_value_len < sizeof(*tt_data))
 		return;
 
-	tt_data = (struct batadv_tvlv_tt_data *)tvlv_value;
+	tt_data = tvlv_value;
 	tvlv_value_len -= sizeof(*tt_data);
 
 	num_vlan = ntohs(tt_data->num_vlan);
@@ -4037,7 +4037,7 @@ static int batadv_tt_tvlv_unicast_handler_v1(struct batadv_priv *bat_priv,
 	if (tvlv_value_len < sizeof(*tt_data))
 		return NET_RX_SUCCESS;
 
-	tt_data = (struct batadv_tvlv_tt_data *)tvlv_value;
+	tt_data = tvlv_value;
 	tvlv_value_len -= sizeof(*tt_data);
 
 	tt_vlan_len = sizeof(struct batadv_tvlv_tt_vlan_data);
@@ -4129,7 +4129,7 @@ static int batadv_roam_tvlv_unicast_handler_v1(struct batadv_priv *bat_priv,
 		goto out;
 
 	batadv_inc_counter(bat_priv, BATADV_CNT_TT_ROAM_ADV_RX);
-	roaming_adv = (struct batadv_tvlv_roam_adv *)tvlv_value;
+	roaming_adv = tvlv_value;
 
 	batadv_dbg(BATADV_DBG_TT, bat_priv,
 		   "Received ROAMING_ADV from %pM (client %pM)\n",
-- 
2.25.1

