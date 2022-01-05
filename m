Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2943484F25
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 09:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbiAEIQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 03:16:28 -0500
Received: from smtp21.cstnet.cn ([159.226.251.21]:52198 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229821AbiAEIQ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 03:16:27 -0500
Received: from localhost.localdomain (unknown [124.16.138.126])
        by APP-01 (Coremail) with SMTP id qwCowACHjlbAU9Vhsz3RBQ--.44200S2;
        Wed, 05 Jan 2022 16:16:01 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH v3] mac80211: mlme: check for null after calling kmemdup
Date:   Wed,  5 Jan 2022 16:15:59 +0800
Message-Id: <20220105081559.2387083-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: qwCowACHjlbAU9Vhsz3RBQ--.44200S2
X-Coremail-Antispam: 1UD129KBjvJXoWxCrW5WFyxCrWkXF4kWF48JFb_yoW5tF4rpF
        WUZ3yUtr4UJF1DZF1rAr45XFyfCF4UAa4Sy34xAa1kZF9YgF1kGF48u3yvvF10yF4kGa43
        ZrZ5tF45Ww1DCrDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc2xSY4AK67AK6r43
        MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr
        0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0E
        wIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJV
        W8JwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
        IxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjNJ55UUUU
        U==
X-Originating-IP: [124.16.138.126]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the possible failure of the alloc, the ifmgd->assoc_req_ies might be
NULL pointer returned from kmemdup().
Therefore it might be better to free the skb and return error in order
to fail the association, like ieee80211_assoc_success().
Also, the caller, ieee80211_do_assoc(), needs to deal with the return
value from ieee80211_send_assoc().

Fixes: 4d9ec73d2b78 ("cfg80211: Report Association Request frame IEs in association events")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
v3: Return error if fails and deal with the error in ieee80211_do_assoc.
v2: Change to fail the association if kmemdup returns NULL.
---
 net/mac80211/mlme.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9bed6464c5bd..e4bb7e290828 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -695,7 +695,7 @@ static void ieee80211_add_he_ie(struct ieee80211_sub_if_data *sdata,
 	ieee80211_ie_build_he_6ghz_cap(sdata, skb);
 }
 
-static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
+static int ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
@@ -725,7 +725,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 	if (WARN_ON(!chanctx_conf)) {
 		rcu_read_unlock();
-		return;
+		return 0;
 	}
 	chan = chanctx_conf->def.chan;
 	rcu_read_unlock();
@@ -773,7 +773,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 			9, /* WMM */
 			GFP_KERNEL);
 	if (!skb)
-		return;
+		return 0;
 
 	skb_reserve(skb, local->hw.extra_tx_headroom);
 
@@ -1052,12 +1052,17 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 	if (assoc_data->fils_kek_len &&
 	    fils_encrypt_assoc_req(skb, assoc_data) < 0) {
 		dev_kfree_skb(skb);
-		return;
+		return 0;
 	}
 
 	pos = skb_tail_pointer(skb);
 	kfree(ifmgd->assoc_req_ies);
 	ifmgd->assoc_req_ies = kmemdup(ie_start, pos - ie_start, GFP_ATOMIC);
+	if (!ifmgd->assoc_req_ies) {
+		dev_kfree_skb(skb);
+		return -ENOMEM;
+	}
+
 	ifmgd->assoc_req_ies_len = pos - ie_start;
 
 	drv_mgd_prepare_tx(local, sdata, 0);
@@ -1067,6 +1072,8 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS |
 						IEEE80211_TX_INTFL_MLME_CONN_TX;
 	ieee80211_tx_skb(sdata, skb);
+
+	return 0;
 }
 
 void ieee80211_send_pspoll(struct ieee80211_local *local,
@@ -4470,6 +4477,7 @@ static int ieee80211_do_assoc(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_mgd_assoc_data *assoc_data = sdata->u.mgd.assoc_data;
 	struct ieee80211_local *local = sdata->local;
+	int ret;
 
 	sdata_assert_lock(sdata);
 
@@ -4490,7 +4498,9 @@ static int ieee80211_do_assoc(struct ieee80211_sub_if_data *sdata)
 	sdata_info(sdata, "associate with %pM (try %d/%d)\n",
 		   assoc_data->bss->bssid, assoc_data->tries,
 		   IEEE80211_ASSOC_MAX_TRIES);
-	ieee80211_send_assoc(sdata);
+	ret = ieee80211_send_assoc(sdata);
+	if (ret)
+		return ret;
 
 	if (!ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS)) {
 		assoc_data->timeout = jiffies + IEEE80211_ASSOC_TIMEOUT;
-- 
2.25.1

