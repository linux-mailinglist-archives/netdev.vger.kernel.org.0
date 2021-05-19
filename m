Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 991D43884A5
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 04:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234516AbhESCKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 22:10:42 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:3024 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbhESCKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 22:10:41 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FlGTP3TxhzmWcL;
        Wed, 19 May 2021 10:07:05 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 10:09:21 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 19 May
 2021 10:09:20 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <ecree.xilinx@gmail.com>
Subject: [PATCH -next resend] sfc: farch: fix compile warning in efx_farch_dimension_resources()
Date:   Wed, 19 May 2021 10:11:36 +0800
Message-ID: <20210519021136.1638370-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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
 drivers/net/ethernet/sfc/farch.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sfc/farch.c b/drivers/net/ethernet/sfc/farch.c
index 49df02ecee91..6048b08b89ec 100644
--- a/drivers/net/ethernet/sfc/farch.c
+++ b/drivers/net/ethernet/sfc/farch.c
@@ -1668,13 +1668,17 @@ void efx_farch_rx_pull_indir_table(struct efx_nic *efx)
  */
 void efx_farch_dimension_resources(struct efx_nic *efx, unsigned sram_lim_qw)
 {
-	unsigned vi_count, buftbl_min, total_tx_channels;
+	unsigned vi_count, total_tx_channels;
 
 #ifdef CONFIG_SFC_SRIOV
 	struct siena_nic_data *nic_data = efx->nic_data;
+	unsigned buftbl_min;
 #endif
 
 	total_tx_channels = efx->n_tx_channels + efx->n_extra_tx_channels;
+	vi_count = max(efx->n_channels, total_tx_channels * EFX_MAX_TXQ_PER_CHANNEL);
+
+#ifdef CONFIG_SFC_SRIOV
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

