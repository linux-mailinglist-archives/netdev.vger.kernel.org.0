Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92E1153763A
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 10:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbiE3IHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 04:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbiE3IHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 04:07:06 -0400
Received: from mail-m972.mail.163.com (mail-m972.mail.163.com [123.126.97.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9B1613FBC2;
        Mon, 30 May 2022 01:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=Tj+2x
        aAcY6dalUpOJzC6dld8hSXl1LyIhtvLrJnzwZg=; b=G2nvkRL8UJQWrrTBpV3WZ
        5YFO1arfhl1hIgRxGmzdR1lx5RDQUfUGDMEf4dKLIuCs/e2zVNU9yt4Zo1DC5NC8
        kaZFOUHIEWfvn+ctFmTsdztfZM7YvbvauTEks6ER/dkBuNVm2Ot6rB4b5iNWSOrv
        z5xEGHBmplGj7cUBFLr9a4=
Received: from localhost.localdomain (unknown [123.112.69.106])
        by smtp2 (Coremail) with SMTP id GtxpCgBXFQj0epRilgL9FQ--.40673S4;
        Mon, 30 May 2022 16:06:33 +0800 (CST)
From:   Jianglei Nie <niejianglei2021@163.com>
To:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jianglei Nie <niejianglei2021@163.com>
Subject: [PATCH v2] ath11k: mhi: fix potential memory leak in ath11k_mhi_register()
Date:   Mon, 30 May 2022 16:06:10 +0800
Message-Id: <20220530080610.143925-1-niejianglei2021@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GtxpCgBXFQj0epRilgL9FQ--.40673S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7CF1Dtw1fGF4UZryxuFy8Xwb_yoW8KrW5pF
        4fWw47AFyrAF4fWFWrtF1kJFy3Wa93Ar1DK39rG34rCrnavF90q345JFyrXFyakw4xGFyU
        ZF4Ut3W3Gas8AF7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pibo7AUUUUU=
X-Originating-IP: [123.112.69.106]
X-CM-SenderInfo: xqlhyxxdqjzvrlsqjii6rwjhhfrp/1tbiFQkRjF5mK76qWwAAsd
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mhi_alloc_controller() allocates a memory space for mhi_ctrl. When some
errors occur, mhi_ctrl should be freed by mhi_free_controller() and set
ab_pci->mhi_ctrl = NULL because ab_pci->mhi_ctrl has a dangling pointer
to the freed memory. But when ath11k_mhi_read_addr_from_dt() fails, the
function returns without calling mhi_free_controller(), which will lead
to a memory leak.

We can fix it by calling mhi_free_controller() when
ath11k_mhi_read_addr_from_dt() fails and set ab_pci->mhi_ctrl = NULL in
all of the places where we call mhi_free_controller().

Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
---
 drivers/net/wireless/ath/ath11k/mhi.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mhi.c b/drivers/net/wireless/ath/ath11k/mhi.c
index fc3524e83e52..fc1bbf91c58e 100644
--- a/drivers/net/wireless/ath/ath11k/mhi.c
+++ b/drivers/net/wireless/ath/ath11k/mhi.c
@@ -367,8 +367,7 @@ int ath11k_mhi_register(struct ath11k_pci *ab_pci)
 	ret = ath11k_mhi_get_msi(ab_pci);
 	if (ret) {
 		ath11k_err(ab, "failed to get msi for mhi\n");
-		mhi_free_controller(mhi_ctrl);
-		return ret;
+		goto free_controller;
 	}
 
 	if (!test_bit(ATH11K_PCI_FLAG_MULTI_MSI_VECTORS, &ab_pci->flags))
@@ -377,7 +376,7 @@ int ath11k_mhi_register(struct ath11k_pci *ab_pci)
 	if (test_bit(ATH11K_FLAG_FIXED_MEM_RGN, &ab->dev_flags)) {
 		ret = ath11k_mhi_read_addr_from_dt(mhi_ctrl);
 		if (ret < 0)
-			return ret;
+			goto free_controller;
 	} else {
 		mhi_ctrl->iova_start = 0;
 		mhi_ctrl->iova_stop = 0xFFFFFFFF;
@@ -405,18 +404,22 @@ int ath11k_mhi_register(struct ath11k_pci *ab_pci)
 	default:
 		ath11k_err(ab, "failed assign mhi_config for unknown hw rev %d\n",
 			   ab->hw_rev);
-		mhi_free_controller(mhi_ctrl);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto free_controller;
 	}
 
 	ret = mhi_register_controller(mhi_ctrl, ath11k_mhi_config);
 	if (ret) {
 		ath11k_err(ab, "failed to register to mhi bus, err = %d\n", ret);
-		mhi_free_controller(mhi_ctrl);
-		return ret;
+		goto free_controller;
 	}
 
 	return 0;
+
+free_controller:
+	mhi_free_controller(mhi_ctrl);
+	ab_pci->mhi_ctrl = NULL;
+	return ret;
 }
 
 void ath11k_mhi_unregister(struct ath11k_pci *ab_pci)
-- 
2.25.1

