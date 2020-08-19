Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6106D249B6E
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 13:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgHSLPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 07:15:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55339 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgHSLO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 07:14:58 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1k8M3Q-00005A-Ph; Wed, 19 Aug 2020 11:14:52 +0000
From:   Colin King <colin.king@canonical.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Carl Huang <cjhuang@codeaurora.org>,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] ath11k: fix missing error check on call to ath11k_pci_get_user_msi_assignment
Date:   Wed, 19 Aug 2020 12:14:52 +0100
Message-Id: <20200819111452.52419-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The return error check on the call to ath11k_pci_get_user_msi_assignment is
missing.  If an error does occur, num_vectors is still set to zero and
later on a division by zero can occur when variable vector is being
calculated.  Fix this by adding an error check after the call.

Addresses-Coverity: ("Division or modulo by zero")
Fixes: d4ecb90b3857 ("ath11k: enable DP interrupt setup for QCA6390")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ath/ath11k/pci.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
index ca7012d46c3f..058885776a3a 100644
--- a/drivers/net/wireless/ath/ath11k/pci.c
+++ b/drivers/net/wireless/ath/ath11k/pci.c
@@ -648,9 +648,12 @@ static int ath11k_pci_ext_irq_config(struct ath11k_base *ab)
 	int i, j, ret, num_vectors = 0;
 	u32 user_base_data = 0, base_vector = 0;
 
-	ath11k_pci_get_user_msi_assignment(ath11k_pci_priv(ab), "DP",
-					   &num_vectors, &user_base_data,
-					   &base_vector);
+	ret = ath11k_pci_get_user_msi_assignment(ath11k_pci_priv(ab), "DP",
+						 &num_vectors,
+						 &user_base_data,
+						 &base_vector);
+	if (ret < 0)
+		return ret;
 
 	for (i = 0; i < ATH11K_EXT_IRQ_GRP_NUM_MAX; i++) {
 		struct ath11k_ext_irq_grp *irq_grp = &ab->ext_irq_grp[i];
-- 
2.27.0

