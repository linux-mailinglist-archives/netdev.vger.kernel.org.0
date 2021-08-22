Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 772ED3F3F9F
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 16:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbhHVOCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 10:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232791AbhHVOCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 10:02:07 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E288C061756;
        Sun, 22 Aug 2021 07:01:26 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id k8so21969406wrn.3;
        Sun, 22 Aug 2021 07:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=69OYe9tROd3vXXnhUMU2DDb1J6uc6lcFtD6g0FYBe9o=;
        b=loDZL3yDasHCEoYfQOwAoMH6LusUl/iTl9I8gl+M2A2LUT4fnGNZ/YrngCVGP7uRdV
         Gattc73fzDLtCzW/jjwcEbo5HTK+guXwHIKyvlJpJb/D0hooJq0lSBk2/JGPPxlNMdH7
         HwlmPZDRIp1spurh9ReQSAhc0CTiV8xQgdFalL1M1aFVrAH+LPnlgbuHLWXMDMep8v4o
         NjmXMrDmOhorccbXStmOpHUhv743yVZei+LfHQ2PH/3P7jPatdoMhkWnvF9d++WFchoB
         2HmQTTuAOHJc5Mjajmyg5ybfSNCG4rRxwNqUlRYmTf/bYLT2YxpiX36hz9skqJ1qjv03
         F7kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=69OYe9tROd3vXXnhUMU2DDb1J6uc6lcFtD6g0FYBe9o=;
        b=cOLqrw4p5427ZglzydQAS6ocb9dCl5RSVBTaBWW6CTtJVxyVKQbQFbylnYOPwQ1Zoo
         c87HPpa0dB2h4TVa2aj0vCLVfLtgQYFWuA6IVe7wARrOb93Lh6NjA9CT18sz4FSILE5o
         R6ExdyqA/hgORj9k1kRHFj8O09JVW2pJYugkc8wYyurtML1uJoZK0eXN7YDwEvwtE+Xg
         GsePWXKNnbaRvFYao2o9j5sy5zaJ5aguZjBNa069A76YuQFUgtDxkUyGVYCoXjAGxLk9
         dRjwf4oPLgyvj5tSv+nnxmTc0JqWJSQziwsbw3Pd6j2RQlQrVPAjHt+xrFYVuHKhhBN+
         zUlg==
X-Gm-Message-State: AOAM531bb4EIvwd5I1N8Mscj06VIromdvBo+1+aK8xVrVDg6fjk9anI1
        BS6+0owKPy2DPe4N6FXkt2k41sWasu4sMw==
X-Google-Smtp-Source: ABdhPJyIK5Ebc6yicAPcW76i5P1gkw0vuBCxEf/WqTLVvVInH6ty65SP9yFNraKXLnfRjkfgvxYSkw==
X-Received: by 2002:a5d:6483:: with SMTP id o3mr8801278wri.197.1629640884832;
        Sun, 22 Aug 2021 07:01:24 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:fc53:5e22:f926:c43b? (p200300ea8f084500fc535e22f926c43b.dip0.t-ipconnect.de. [2003:ea:8f08:4500:fc53:5e22:f926:c43b])
        by smtp.googlemail.com with ESMTPSA id o14sm12033206wrw.17.2021.08.22.07.01.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Aug 2021 07:01:24 -0700 (PDT)
Subject: [PATCH 04/12] bnx2: Replace open-coded version with swab32s()
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Rasesh Mody <rmody@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1ca29408-7bc7-4da5-59c7-87893c9e0442@gmail.com>
Message-ID: <e4ac6229-1df5-8760-3a87-1ad0ace87137@gmail.com>
Date:   Sun, 22 Aug 2021 15:52:01 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <1ca29408-7bc7-4da5-59c7-87893c9e0442@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use swab32s() instead of open-coding it.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/broadcom/bnx2.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index de1a60a95..599fc1436 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -8041,21 +8041,16 @@ bnx2_read_vpd_fw_ver(struct bnx2 *bp)
 #define BNX2_VPD_LEN		128
 #define BNX2_MAX_VER_SLEN	30
 
-	data = kmalloc(256, GFP_KERNEL);
+	data = kmalloc(BNX2_VPD_LEN, GFP_KERNEL);
 	if (!data)
 		return;
 
-	rc = bnx2_nvram_read(bp, BNX2_VPD_NVRAM_OFFSET, data + BNX2_VPD_LEN,
-			     BNX2_VPD_LEN);
+	rc = bnx2_nvram_read(bp, BNX2_VPD_NVRAM_OFFSET, data, BNX2_VPD_LEN);
 	if (rc)
 		goto vpd_done;
 
-	for (i = 0; i < BNX2_VPD_LEN; i += 4) {
-		data[i] = data[i + BNX2_VPD_LEN + 3];
-		data[i + 1] = data[i + BNX2_VPD_LEN + 2];
-		data[i + 2] = data[i + BNX2_VPD_LEN + 1];
-		data[i + 3] = data[i + BNX2_VPD_LEN];
-	}
+	for (i = 0; i < BNX2_VPD_LEN; i += 4)
+		swab32s((u32 *)&data[i]);
 
 	j = pci_vpd_find_ro_info_keyword(data, BNX2_VPD_LEN,
 					 PCI_VPD_RO_KEYWORD_MFR_ID, &len);
-- 
2.33.0


