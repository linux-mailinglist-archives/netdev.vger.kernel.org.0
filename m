Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 996E23ACCEB
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 15:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234243AbhFRN7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 09:59:38 -0400
Received: from m12-12.163.com ([220.181.12.12]:33534 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233754AbhFRN7i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 09:59:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=eCW+C4iVQPGpJOG3QE
        vEPn+ptIsdgDaQpBCpWgq1I7U=; b=oGKw+ZW1F4gDVFYwsejb3kCgoCgj6u14Cj
        41a7G8GWwgaRCbzBza0MdFY4RKtUBguYNbot4HjT7sfqmsLdRHVOQY7dtw2gLrWI
        +81Vww1I7MI4L9X9XjXrMCSa5fwlWlIOMcTbLuYiAcQ96IfYJRyCjzHOMF3RFM/T
        cbwKdGtQk=
Received: from wengjianfeng.ccdomain.com (unknown [218.17.89.92])
        by smtp8 (Coremail) with SMTP id DMCowACnqtbvYsxgV+ZQKg--.33014S2;
        Fri, 18 Jun 2021 17:10:08 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     charles.gorand@effinnov.com, krzysztof.kozlowski@canonical.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH v2] NFC: nxp-nci: remove unnecessary labels
Date:   Fri, 18 Jun 2021 17:10:16 +0800
Message-Id: <20210618091016.19500-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: DMCowACnqtbvYsxgV+ZQKg--.33014S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7uw4kuFW8WFWDWw43Xr48Xrb_yoW8uFWDpF
        13WFyayryrtr97WFn5Ar12vFZ5tw18J39rWr9rt393X3WYyryjqr4kCFW0vFWrJrZakFya
        yr4IvFyDWF17JaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07bUUDXUUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbiERC1sV7+3wZmMQAAsr
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

Simplify the code by removing unnecessary labels and returning directly.

Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
---
 drivers/nfc/nxp-nci/core.c | 39 +++++++++++++--------------------------
 1 file changed, 13 insertions(+), 26 deletions(-)

diff --git a/drivers/nfc/nxp-nci/core.c b/drivers/nfc/nxp-nci/core.c
index a0ce95a..2b0c723 100644
--- a/drivers/nfc/nxp-nci/core.c
+++ b/drivers/nfc/nxp-nci/core.c
@@ -70,21 +70,16 @@ static int nxp_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
 	struct nxp_nci_info *info = nci_get_drvdata(ndev);
 	int r;
 
-	if (!info->phy_ops->write) {
-		r = -ENOTSUPP;
-		goto send_exit;
-	}
+	if (!info->phy_ops->write)
+		return -EOPNOTSUPP;
 
-	if (info->mode != NXP_NCI_MODE_NCI) {
-		r = -EINVAL;
-		goto send_exit;
-	}
+	if (info->mode != NXP_NCI_MODE_NCI)
+		return -EINVAL;
 
 	r = info->phy_ops->write(info->phy_id, skb);
 	if (r < 0)
 		kfree_skb(skb);
 
-send_exit:
 	return r;
 }
 
@@ -104,10 +99,8 @@ int nxp_nci_probe(void *phy_id, struct device *pdev,
 	int r;
 
 	info = devm_kzalloc(pdev, sizeof(struct nxp_nci_info), GFP_KERNEL);
-	if (!info) {
-		r = -ENOMEM;
-		goto probe_exit;
-	}
+	if (!info)
+		return -ENOMEM;
 
 	info->phy_id = phy_id;
 	info->pdev = pdev;
@@ -120,31 +113,25 @@ int nxp_nci_probe(void *phy_id, struct device *pdev,
 	if (info->phy_ops->set_mode) {
 		r = info->phy_ops->set_mode(info->phy_id, NXP_NCI_MODE_COLD);
 		if (r < 0)
-			goto probe_exit;
+			return r;
 	}
 
 	info->mode = NXP_NCI_MODE_COLD;
 
 	info->ndev = nci_allocate_device(&nxp_nci_ops, NXP_NCI_NFC_PROTOCOLS,
 					 NXP_NCI_HDR_LEN, 0);
-	if (!info->ndev) {
-		r = -ENOMEM;
-		goto probe_exit;
-	}
+	if (!info->ndev)
+		return -ENOMEM;
 
 	nci_set_parent_dev(info->ndev, pdev);
 	nci_set_drvdata(info->ndev, info);
 	r = nci_register_device(info->ndev);
-	if (r < 0)
-		goto probe_exit_free_nci;
+	if (r < 0) {
+		nci_free_device(info->ndev);
+		return r;
+	}
 
 	*ndev = info->ndev;
-
-	goto probe_exit;
-
-probe_exit_free_nci:
-	nci_free_device(info->ndev);
-probe_exit:
 	return r;
 }
 EXPORT_SYMBOL(nxp_nci_probe);
-- 
1.9.1


