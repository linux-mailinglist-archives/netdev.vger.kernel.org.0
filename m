Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81238484C1F
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 02:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236896AbiAEBdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 20:33:36 -0500
Received: from smtp23.cstnet.cn ([159.226.251.23]:33104 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234314AbiAEBdf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 20:33:35 -0500
Received: from localhost.localdomain (unknown [124.16.138.126])
        by APP-03 (Coremail) with SMTP id rQCowABHT1tV9dRhfS4gBQ--.25741S2;
        Wed, 05 Jan 2022 09:33:09 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH v2] mac80211: mlme: check for null after calling kmemdup
Date:   Wed,  5 Jan 2022 09:33:08 +0800
Message-Id: <20220105013308.2011586-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: rQCowABHT1tV9dRhfS4gBQ--.25741S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Wr1kZFyrAr4xCFykAF4kXrb_yoWkGrg_KF
        n7Zwn8Zw13trWfArWUKFy5ZayfCrsFqFyftF9IkFZ3A34fJ3y7Gw4fXwnxGr4xC3yYvrZ8
        G34q934rJwsrZjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb48FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
        Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
        1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
        7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r
        1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_
        KwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r
        1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij
        64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr
        0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
        IxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbLiSPUUUU
        U==
X-Originating-IP: [124.16.138.126]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the possible failure of the alloc, the ifmgd->assoc_req_ies might be
NULL pointer returned from kmemdup().
Therefore it might be better to free the skb and return in order to fail
the association, like ieee80211_assoc_success().

Fixes: 4d9ec73d2b78 ("cfg80211: Report Association Request frame IEs in association events")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
v2: Change to fail the association if kmemdup returns NULL.
---
 net/mac80211/mlme.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9bed6464c5bd..b5dfdf953286 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1058,6 +1058,11 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 	pos = skb_tail_pointer(skb);
 	kfree(ifmgd->assoc_req_ies);
 	ifmgd->assoc_req_ies = kmemdup(ie_start, pos - ie_start, GFP_ATOMIC);
+	if (!ifmgd->assoc_req_ies) {
+		dev_kfree_skb(skb);
+		return;
+	}
+
 	ifmgd->assoc_req_ies_len = pos - ie_start;
 
 	drv_mgd_prepare_tx(local, sdata, 0);
-- 
2.25.1

