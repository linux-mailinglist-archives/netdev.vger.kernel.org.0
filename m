Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA90B17BC73
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 13:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgCFMNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 07:13:22 -0500
Received: from simonwunderlich.de ([79.140.42.25]:44514 "EHLO
        simonwunderlich.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbgCFMNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 07:13:21 -0500
Received: from kero.packetmixer.de (p200300C597077300B0A48B46F0435C76.dip0.t-ipconnect.de [IPv6:2003:c5:9707:7300:b0a4:8b46:f043:5c76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 916C56205F;
        Fri,  6 Mar 2020 13:13:19 +0100 (CET)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 2/3] batman-adv: Avoid RCU list-traversal in spinlock
Date:   Fri,  6 Mar 2020 13:13:16 +0100
Message-Id: <20200306121317.28931-3-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200306121317.28931-1-sw@simonwunderlich.de>
References: <20200306121317.28931-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

The new CONFIG_PROVE_RCU_LIST requires a condition statement in
(h)list_for_each_entry_rcu when the code might be executed in a non RCU
non-reader section with the writer lock. Otherwise lockdep might cause a
false positive warning like

  =============================
  WARNING: suspicious RCU usage
  -----------------------------
  translation-table.c:940 RCU-list traversed in non-reader section!!

batman-adv is (mostly) following the examples from the RCU documentation
and is using the normal list-traversal primitives instead of the RCU
list-traversal primitives when the writer (spin)lock is held.

The remaining users of RCU list-traversal primitives with writer spinlock
have to be converted to the same style as the rest of the code.

Reported-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/translation-table.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index 852932838ddc..a9635c882fe0 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -862,7 +862,7 @@ batadv_tt_prepare_tvlv_global_data(struct batadv_orig_node *orig_node,
 	u8 *tt_change_ptr;
 
 	spin_lock_bh(&orig_node->vlan_list_lock);
-	hlist_for_each_entry_rcu(vlan, &orig_node->vlan_list, list) {
+	hlist_for_each_entry(vlan, &orig_node->vlan_list, list) {
 		num_vlan++;
 		num_entries += atomic_read(&vlan->tt.num_entries);
 	}
@@ -888,7 +888,7 @@ batadv_tt_prepare_tvlv_global_data(struct batadv_orig_node *orig_node,
 	(*tt_data)->num_vlan = htons(num_vlan);
 
 	tt_vlan = (struct batadv_tvlv_tt_vlan_data *)(*tt_data + 1);
-	hlist_for_each_entry_rcu(vlan, &orig_node->vlan_list, list) {
+	hlist_for_each_entry(vlan, &orig_node->vlan_list, list) {
 		tt_vlan->vid = htons(vlan->vid);
 		tt_vlan->crc = htonl(vlan->tt.crc);
 
@@ -937,7 +937,7 @@ batadv_tt_prepare_tvlv_local_data(struct batadv_priv *bat_priv,
 	int change_offset;
 
 	spin_lock_bh(&bat_priv->softif_vlan_list_lock);
-	hlist_for_each_entry_rcu(vlan, &bat_priv->softif_vlan_list, list) {
+	hlist_for_each_entry(vlan, &bat_priv->softif_vlan_list, list) {
 		vlan_entries = atomic_read(&vlan->tt.num_entries);
 		if (vlan_entries < 1)
 			continue;
@@ -967,7 +967,7 @@ batadv_tt_prepare_tvlv_local_data(struct batadv_priv *bat_priv,
 	(*tt_data)->num_vlan = htons(num_vlan);
 
 	tt_vlan = (struct batadv_tvlv_tt_vlan_data *)(*tt_data + 1);
-	hlist_for_each_entry_rcu(vlan, &bat_priv->softif_vlan_list, list) {
+	hlist_for_each_entry(vlan, &bat_priv->softif_vlan_list, list) {
 		vlan_entries = atomic_read(&vlan->tt.num_entries);
 		if (vlan_entries < 1)
 			continue;
-- 
2.20.1

