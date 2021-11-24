Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E511945B185
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 02:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbhKXCBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 21:01:05 -0500
Received: from tartarus.angband.pl ([51.83.246.204]:45544 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239402AbhKXCBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 21:01:00 -0500
X-Greylist: delayed 2239 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Nov 2021 21:01:00 EST
Received: from 89-73-149-240.dynamic.chello.pl ([89.73.149.240] helo=barad-dur.angband.pl)
        by tartarus.angband.pl with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <kilobyte@angband.pl>)
        id 1mpgvH-00D8oj-Ld; Wed, 24 Nov 2021 02:18:10 +0100
Received: from [2a02:a31c:8245:f980::4] (helo=valinor.angband.pl)
        by barad-dur.angband.pl with esmtp (Exim 4.94.2)
        (envelope-from <kilobyte@angband.pl>)
        id 1mpgvG-0001mD-9C; Wed, 24 Nov 2021 02:18:06 +0100
Received: from kilobyte by valinor.angband.pl with local (Exim 4.95)
        (envelope-from <kilobyte@valinor.angband.pl>)
        id 1mpgvD-0005px-0j;
        Wed, 24 Nov 2021 02:18:03 +0100
From:   Adam Borowski <kilobyte@angband.pl>
To:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Adam Borowski <kilobyte@angband.pl>
Date:   Wed, 24 Nov 2021 02:17:54 +0100
Message-Id: <20211124011754.22397-1-kilobyte@angband.pl>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 89.73.149.240
X-SA-Exim-Mail-From: kilobyte@angband.pl
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on tartarus.angband.pl
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00=-1.9,RDNS_NONE=0.793,
        SPF_HELO_NONE=0.001,SPF_PASS=-0.001,TVD_RCVD_IP=0.001 autolearn=no
        autolearn_force=no languages=en
Subject: [PATCH] iwlwifi: pcie: fix a warning / build failure
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on tartarus.angband.pl)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/wireless/intel/iwlwifi/pcie/drv.c:
        In function ‘iwl_pci_find_dev_info’:
./include/linux/kernel.h:46:25: error: overflow in conversion from
        ‘long unsigned int’ to ‘int’ changes value from
        ‘18446744073709551615’ to ‘-1’ [-Werror=overflow]

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
Another option would be to #ifdef away iwl_pci_find_dev_info().

 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index c574f041f096..81e8f2fc4982 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1341,7 +1341,7 @@ iwl_pci_find_dev_info(u16 device, u16 subsystem_device,
 {
 	int i;
 
-	for (i = ARRAY_SIZE(iwl_dev_info_table) - 1; i >= 0; i--) {
+	for (i = (int)ARRAY_SIZE(iwl_dev_info_table) - 1; i >= 0; i--) {
 		const struct iwl_dev_info *dev_info = &iwl_dev_info_table[i];
 
 		if (dev_info->device != (u16)IWL_CFG_ANY &&
-- 
2.34.0

