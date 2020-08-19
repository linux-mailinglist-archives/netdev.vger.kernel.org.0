Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C2F249B46
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 12:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbgHSK5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 06:57:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54650 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbgHSK5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 06:57:17 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1k8LmK-0007Cy-MF; Wed, 19 Aug 2020 10:57:12 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] ath11k: fix error check on return from call to ath11k_core_firmware_request
Date:   Wed, 19 Aug 2020 11:57:12 +0100
Message-Id: <20200819105712.51886-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The call to ath11k_core_firmware_request is returning a pointer that
can be set to an error code, however, this is not being checked.
Instead ret is being incorrecly checked for the error return. Fix the
error checking.

Addresses-Coverity: ("Logically dead code")
Fixes: 7b57b2ddec21 ("ath11k: create a common function to request all firmware files")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ath/ath11k/qmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index 91134510364c..4792857678b9 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -1886,7 +1886,7 @@ ath11k_qmi_prepare_bdf_download(struct ath11k_base *ab, int type,
 		break;
 	case ATH11K_QMI_FILE_TYPE_CALDATA:
 		fw_entry = ath11k_core_firmware_request(ab, ATH11K_DEFAULT_CAL_FILE);
-		if (ret) {
+		if (PTR_ERR(fw_entry)) {
 			ath11k_warn(ab, "failed to load %s: %d\n",
 				    ATH11K_DEFAULT_CAL_FILE, ret);
 			goto out;
-- 
2.27.0

