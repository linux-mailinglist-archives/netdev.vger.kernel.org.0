Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB763193CC
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 21:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbhBKUBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 15:01:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbhBKUBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 15:01:22 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B0EBC061574;
        Thu, 11 Feb 2021 12:00:42 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id r21so5370115wrr.9;
        Thu, 11 Feb 2021 12:00:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=bHdv3jXvDP//T4C5ZhfpHPLC2NxIN03Ob1UB8XrqyU8=;
        b=sAgn8JhLuTn1sERqKPOASKrStvL5IWnrtM3DoTRhTX7SM7ObJTvq2z+V6Y5ZYizRY0
         aeKVsC66tWYjJQ+YAh8qL2a9fvUGbnrM4f5dfq/xhv3JeT98mgz1XB6k2JbcbjU4De0S
         gXDpvFcxrEpxq+dMPkXM0ONNCYFt9JNR7KKYUXa8UuQoYwVSWWYkRNaXCsbaxrQrEPmF
         UTvW22N7p0scNU5w7Ip9eCKqpTs8tWWmUEhKISXWcBA6v0iS16J0CdCw5ERULo4DkbEu
         DF9YDQYwhplzK+dXlKgxmMXVA2vCvqgFq51ajTsf+M6wq4yGdzmFUlj3bF9zz1l8NRG+
         pO6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=bHdv3jXvDP//T4C5ZhfpHPLC2NxIN03Ob1UB8XrqyU8=;
        b=B4rXNsl/Xt7jeWVs3DcxAKvWEHrJg7ALWn+I/6lFlKnYVOpgOcSJV7MqLObU+zrH7+
         bqbZ3N8am3jmEK/A8cI5ZO4X9OowdonwjhlLWJ5PE5FyrjVlVOzPmmEwT/4IdnH1/9o3
         vkoW/XK0WPU322SOSSOElbOHGG3YoSakB0P1BZOZPpANzrpGqcTi22EPYqmOPjOy3yId
         SqeP6FtxJJuNjcJcclqGuxLhOjYMPVUAFCD/kg6zEli99qVUS8BykqzHregHoFvvu5Yc
         Yf3me93UMQedvBAp/ge2Pnf7CtgfrYEVWGBg5jvOWS847Whf80Edq8bQCdJ1U8jrb3uB
         a9Bg==
X-Gm-Message-State: AOAM5303ZdkgUK3Oz/qcral2iUQfnzrLzSpC9twrBq7q0SQB85TXSH+1
        h7w6vwF//CiSUUZimxMvtrQIEe/mJ3/RAA==
X-Google-Smtp-Source: ABdhPJwAnIyCDkm2YCAXaYIGGmDB1fQ6MQf+97oZrjnNkcsuZFCvmPgHht1acdiKTJb459q6rVdF/w==
X-Received: by 2002:adf:8104:: with SMTP id 4mr7210902wrm.265.1613073640583;
        Thu, 11 Feb 2021 12:00:40 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:1524:b28c:2a1c:169e? (p200300ea8f1fad001524b28c2a1c169e.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:1524:b28c:2a1c:169e])
        by smtp.googlemail.com with ESMTPSA id l14sm6680079wrq.87.2021.02.11.12.00.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Feb 2021 12:00:40 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH net-next] iwlwifi: improve tag handling in
 iwl_request_firmware
Message-ID: <a7c29c3f-46d7-979e-e8fc-648fe305dcf2@gmail.com>
Date:   Thu, 11 Feb 2021 21:00:31 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can remove the intermediary string conversion and use drv->fw_index
in the final snprintf directly.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 263c3c0bb..000c0ae8d 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -161,7 +161,6 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw,
 static int iwl_request_firmware(struct iwl_drv *drv, bool first)
 {
 	const struct iwl_cfg *cfg = drv->trans->cfg;
-	char tag[8];
 
 	if (drv->trans->trans_cfg->device_family == IWL_DEVICE_FAMILY_9000 &&
 	    (CSR_HW_REV_STEP(drv->trans->hw_rev) != SILICON_B_STEP &&
@@ -172,13 +171,10 @@ static int iwl_request_firmware(struct iwl_drv *drv, bool first)
 		return -EINVAL;
 	}
 
-	if (first) {
+	if (first)
 		drv->fw_index = cfg->ucode_api_max;
-		sprintf(tag, "%d", drv->fw_index);
-	} else {
+	else
 		drv->fw_index--;
-		sprintf(tag, "%d", drv->fw_index);
-	}
 
 	if (drv->fw_index < cfg->ucode_api_min) {
 		IWL_ERR(drv, "no suitable firmware found!\n");
@@ -198,8 +194,8 @@ static int iwl_request_firmware(struct iwl_drv *drv, bool first)
 		return -ENOENT;
 	}
 
-	snprintf(drv->firmware_name, sizeof(drv->firmware_name), "%s%s.ucode",
-		 cfg->fw_name_pre, tag);
+	snprintf(drv->firmware_name, sizeof(drv->firmware_name), "%s%d.ucode",
+		 cfg->fw_name_pre, drv->fw_index);
 
 	IWL_DEBUG_FW_INFO(drv, "attempting to load firmware '%s'\n",
 			  drv->firmware_name);
-- 
2.30.1

