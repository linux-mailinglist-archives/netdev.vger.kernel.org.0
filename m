Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A747D38BD13
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 05:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238962AbhEUD4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 23:56:45 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3454 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233879AbhEUD4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 23:56:44 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FmXk75wyYzBvQ1;
        Fri, 21 May 2021 11:52:31 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 11:55:19 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 21 May
 2021 11:55:19 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <ecree.xilinx@gmail.com>
Subject: [PATCH -next v2] sfc: farch: fix compile warning in efx_farch_dimension_resources()
Date:   Fri, 21 May 2021 11:57:21 +0800
Message-ID: <20210521035721.1015333-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following kernel build warning when CONFIG_SFC_SRIOV is disabled:

  drivers/net/ethernet/sfc/farch.c: In function ‘efx_farch_dimension_resources’:
  drivers/net/ethernet/sfc/farch.c:1671:21: warning: variable ‘buftbl_min’ set but not used [-Wunused-but-set-variable]
    unsigned vi_count, buftbl_min, total_tx_channels;

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/sfc/farch.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/sfc/farch.c b/drivers/net/ethernet/sfc/farch.c
index 49df02ecee91..148dcd48b58d 100644
--- a/drivers/net/ethernet/sfc/farch.c
+++ b/drivers/net/ethernet/sfc/farch.c
@@ -1668,13 +1668,17 @@ void efx_farch_rx_pull_indir_table(struct efx_nic *efx)
  */
 void efx_farch_dimension_resources(struct efx_nic *efx, unsigned sram_lim_qw)
 {
-	unsigned vi_count, buftbl_min, total_tx_channels;
-
+	unsigned vi_count, total_tx_channels;
 #ifdef CONFIG_SFC_SRIOV
-	struct siena_nic_data *nic_data = efx->nic_data;
+	struct siena_nic_data *nic_data;
+	unsigned buftbl_min;
 #endif
 
 	total_tx_channels = efx->n_tx_channels + efx->n_extra_tx_channels;
+	vi_count = max(efx->n_channels, total_tx_channels * EFX_MAX_TXQ_PER_CHANNEL);
+
+#ifdef CONFIG_SFC_SRIOV
+	nic_data = efx->nic_data;
 	/* Account for the buffer table entries backing the datapath channels
 	 * and the descriptor caches for those channels.
 	 */
@@ -1682,9 +1686,6 @@ void efx_farch_dimension_resources(struct efx_nic *efx, unsigned sram_lim_qw)
 		       total_tx_channels * EFX_MAX_TXQ_PER_CHANNEL * EFX_MAX_DMAQ_SIZE +
 		       efx->n_channels * EFX_MAX_EVQ_SIZE)
 		      * sizeof(efx_qword_t) / EFX_BUF_SIZE);
-	vi_count = max(efx->n_channels, total_tx_channels * EFX_MAX_TXQ_PER_CHANNEL);
-
-#ifdef CONFIG_SFC_SRIOV
 	if (efx->type->sriov_wanted) {
 		if (efx->type->sriov_wanted(efx)) {
 			unsigned vi_dc_entries, buftbl_free;
-- 
2.25.1

