Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3191D3A7507
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 05:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbhFOD2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 23:28:01 -0400
Received: from m12-15.163.com ([220.181.12.15]:34740 "EHLO m12-15.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229609AbhFOD2A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 23:28:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=PENobBzBavAaoCQQ+h
        lNAZa+b822kaDMPQDWCLqrhaw=; b=mOANcSqelRHiehVPBETs8E0tGh64MHLs5a
        mEDE3TqVDinnseNvAvwbgrNFbhA0pNvfXZWg1DmsYOwJQT6W6Rj/29jOkkIZbu98
        qkKWOnmTa+fOjxbYp39MQnkk0GtD3eNKjiniOQ6CE6FCheqLg7tnUnsRDxW/HDRW
        /tbF+3u10=
Received: from wengjianfeng.ccdomain.com (unknown [218.17.89.92])
        by smtp11 (Coremail) with SMTP id D8CowABXX3_xB8hgEmjxAg--.74S2;
        Tue, 15 Jun 2021 09:53:04 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     charles.gorand@effinnov.com, krzysztof.kozlowski@canonical.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH] NFC: nxp-nci: remove unnecessary labels
Date:   Tue, 15 Jun 2021 09:52:56 +0800
Message-Id: <20210615015256.13944-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: D8CowABXX3_xB8hgEmjxAg--.74S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tr18Cw43CFyfZw4DWr4kWFg_yoW8tr17pF
        nxXFyayryrJr97WFn5Ar12vFZ5tw18J39rGr9rt393X3WYyryjqr1kCFW0vFWrJrZakFya
        yr4IvFyDuF17JaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jQWrJUUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/xtbBLBmysV++MNL80QAAsY
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

Some labels are meaningless, so we delete them and use the
return statement instead of the goto statement.

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

