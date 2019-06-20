Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CABAD4CE9F
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 15:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729563AbfFTN1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 09:27:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57397 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726428AbfFTN1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 09:27:55 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hdx6V-0004Te-Cq; Thu, 20 Jun 2019 13:27:51 +0000
From:   Colin King <colin.king@canonical.com>
To:     Xue Chaojing <xuechaojing@huawei.com>,
        Aviad Krawczyk <aviad.krawczyk@huawei.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][net-next] hinic: fix dereference of pointer hwdev before it is null checked
Date:   Thu, 20 Jun 2019 14:27:51 +0100
Message-Id: <20190620132751.26438-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently pointer hwdev is dereferenced when assigning hwif before
hwdev is null checked.  Fix this by only derefencing hwdev after the
null check.

Addresses-Coverity: ("Dereference before null check")
Fixes: 4fdc51bb4e92 ("hinic: add support for rss parameters with ethtool")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 .../net/ethernet/huawei/hinic/hinic_port.c    | 21 +++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.c b/drivers/net/ethernet/huawei/hinic/hinic_port.c
index 6b933962de46..1c3b3c0d6298 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.c
@@ -711,14 +711,17 @@ int hinic_get_rss_type(struct hinic_dev *nic_dev, u32 tmpl_idx,
 {
 	struct hinic_rss_context_table ctx_tbl = { 0 };
 	struct hinic_hwdev *hwdev = nic_dev->hwdev;
-	struct hinic_hwif *hwif = hwdev->hwif;
-	struct pci_dev *pdev = hwif->pdev;
+	struct hinic_hwif *hwif;
+	struct pci_dev *pdev;
 	u16 out_size = sizeof(ctx_tbl);
 	int err;
 
 	if (!hwdev || !rss_type)
 		return -EINVAL;
 
+	hwif = hwdev->hwif;
+	pdev = hwif->pdev;
+
 	ctx_tbl.func_id = HINIC_HWIF_FUNC_IDX(hwif);
 	ctx_tbl.template_id = tmpl_idx;
 
@@ -776,14 +779,17 @@ int hinic_rss_get_template_tbl(struct hinic_dev *nic_dev, u32 tmpl_idx,
 {
 	struct hinic_rss_template_key temp_key = { 0 };
 	struct hinic_hwdev *hwdev = nic_dev->hwdev;
-	struct hinic_hwif *hwif = hwdev->hwif;
-	struct pci_dev *pdev = hwif->pdev;
+	struct hinic_hwif *hwif;
+	struct pci_dev *pdev;
 	u16 out_size = sizeof(temp_key);
 	int err;
 
 	if (!hwdev || !temp)
 		return -EINVAL;
 
+	hwif = hwdev->hwif;
+	pdev = hwif->pdev;
+
 	temp_key.func_id = HINIC_HWIF_FUNC_IDX(hwif);
 	temp_key.template_id = tmpl_idx;
 
@@ -832,14 +838,17 @@ int hinic_rss_get_hash_engine(struct hinic_dev *nic_dev, u8 tmpl_idx, u8 *type)
 {
 	struct hinic_rss_engine_type hash_type = { 0 };
 	struct hinic_hwdev *hwdev = nic_dev->hwdev;
-	struct hinic_hwif *hwif = hwdev->hwif;
-	struct pci_dev *pdev = hwif->pdev;
+	struct hinic_hwif *hwif;
+	struct pci_dev *pdev;
 	u16 out_size = sizeof(hash_type);
 	int err;
 
 	if (!hwdev || !type)
 		return -EINVAL;
 
+	hwif = hwdev->hwif;
+	pdev = hwif->pdev;
+
 	hash_type.func_id = HINIC_HWIF_FUNC_IDX(hwif);
 	hash_type.template_id = tmpl_idx;
 
-- 
2.20.1

