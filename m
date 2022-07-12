Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD74571F0F
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 17:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbiGLP0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 11:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233605AbiGLP0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 11:26:11 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC2C2714F;
        Tue, 12 Jul 2022 08:26:09 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 6FEC822239;
        Tue, 12 Jul 2022 17:26:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1657639567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=gftElsBm8J9qrT2o/GCtvW399nDzpiAV9w2nv9s38GI=;
        b=XMEYTzH3F3lGOsK1XmdL/baZvICiN7qlvTH14zCuNdjLI2h8orV8Uytnfd7P/KboHEjhmc
        ionFbA5bECLCbrVeK6v4gPoRKIKgCy4wM3N0YVWw8xe6LSe/7Mh3hjtvdy+I2zlR/2XpP7
        HDe41RUjCRxqHhXZfjwHOOVOGiGKc40=
From:   Michael Walle <michael@walle.cc>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH] NFC: nxp-nci: fix deadlock during firmware update
Date:   Tue, 12 Jul 2022 17:25:54 +0200
Message-Id: <20220712152554.2909224-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During firmware update, both nxp_nci_i2c_irq_thread_fn() and
nxp_nci_fw_work() will hold the info_lock mutex and one will wait
for the other via a completion:

nxp_nci_fw_work()
  mutex_lock(info_lock)
  nxp_nci_fw_send()
    wait_for_completion(cmd_completion)
  mutex_unlock(info_lock)

nxp_nci_i2c_irq_thread_fn()
  mutex_lock(info_lock)
    nxp_nci_fw_recv_frame()
      complete(cmd_completion)
  mutex_unlock(info_lock)

This will result in a -ETIMEDOUT error during firmware update (note
that the wait_for_completion() above is a variant with a timeout).

Drop the lock in nxp_nci_fw_work() and instead take it after the
work is done in nxp_nci_fw_work_complete() when the NFC controller mode
is switched and the info structure is updated.

Fixes: dece45855a8b ("NFC: nxp-nci: Add support for NXP NCI chips")
Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/nfc/nxp-nci/firmware.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/nxp-nci/firmware.c b/drivers/nfc/nxp-nci/firmware.c
index 119bf305c642..6a4d4aa7239f 100644
--- a/drivers/nfc/nxp-nci/firmware.c
+++ b/drivers/nfc/nxp-nci/firmware.c
@@ -54,6 +54,7 @@ void nxp_nci_fw_work_complete(struct nxp_nci_info *info, int result)
 	struct nxp_nci_fw_info *fw_info = &info->fw_info;
 	int r;
 
+	mutex_lock(&info->info_lock);
 	if (info->phy_ops->set_mode) {
 		r = info->phy_ops->set_mode(info->phy_id, NXP_NCI_MODE_COLD);
 		if (r < 0 && result == 0)
@@ -66,6 +67,7 @@ void nxp_nci_fw_work_complete(struct nxp_nci_info *info, int result)
 		release_firmware(fw_info->fw);
 		fw_info->fw = NULL;
 	}
+	mutex_unlock(&info->info_lock);
 
 	nfc_fw_download_done(info->ndev->nfc_dev, fw_info->name, (u32) -result);
 }
@@ -172,8 +174,6 @@ void nxp_nci_fw_work(struct work_struct *work)
 	fw_info = container_of(work, struct nxp_nci_fw_info, work);
 	info = container_of(fw_info, struct nxp_nci_info, fw_info);
 
-	mutex_lock(&info->info_lock);
-
 	r = fw_info->cmd_result;
 	if (r < 0)
 		goto exit_work;
@@ -190,7 +190,6 @@ void nxp_nci_fw_work(struct work_struct *work)
 exit_work:
 	if (r < 0 || fw_info->size == 0)
 		nxp_nci_fw_work_complete(info, r);
-	mutex_unlock(&info->info_lock);
 }
 
 int nxp_nci_fw_download(struct nci_dev *ndev, const char *firmware_name)
-- 
2.30.2

