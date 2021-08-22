Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB52C3F3FA0
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 16:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbhHVOCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 10:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233009AbhHVOCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 10:02:08 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A05E9C061756;
        Sun, 22 Aug 2021 07:01:27 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id c129-20020a1c35870000b02902e6b6135279so9052485wma.0;
        Sun, 22 Aug 2021 07:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/Fh2fLkAINQvq4cNOqL6qOSjii9B6nvN6TPi70VGrkk=;
        b=dwwQ6WxhbehU1AY9N6lTZ1JkaVX1L6e1Shpgsl8HmnGTmOshzQLDujPzRLYfvBNegK
         JS53BxoYl7vuCNGW9ZQJXbknRzpZxcxh3WviUplnvLAAuMiumD+vwpn2JXIsrpbdzeNY
         zmoVQa3V8Y+riyOUNcvWrFIIEakISzVHXuCg94zsSFf3Ay89bcGhC5vUfHf8HksTJC+z
         JA/mm1afvxCSMcF2Fzn1dkUMWPvbOBn9lDwZZ3I7c/1cCG9L+sGVYC4Wm1P+Uo3dhha9
         h/aKHcsqOLj7VnR1vwl/MvS4FhYlA2GzCcjmtLIbTvAj80jkS4Ch11NbCB6LupZEItyy
         +CxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/Fh2fLkAINQvq4cNOqL6qOSjii9B6nvN6TPi70VGrkk=;
        b=q83wmMjBqCg8yZ/Q8FLjk+IGtWcGJl8K4Ht0wHNNwzEMGzigxr2aqlRMG7EpnY2/3D
         +ZW+7KPOS+MT+Q/H79bHGuaJe3kHagACh6WZgiMtAyzvUsoQRHH6GD0F2HDMQzNdg/Ay
         edV3DBM3gp15HsWVJvQtT4pu2G12+687X79WqHqHXi0irzNs+pcu3gBIHqRTr7LrddQ9
         zQoCIWDQkyW96jayX0Hrt8SpLAY6u4ct1DSbkH46rmY3iBJtM9HSyYC3izSxeqU9iuj9
         jWwLwmO1JlGOCaRR6l9GO7prdlXTIKnNMnE+IL5V/Ui5R5CTqhxVoqNHfYvLBJbE6RW4
         dszA==
X-Gm-Message-State: AOAM530WZdMLPthuoxJ2XYzmLEsCBPn7f24jSC74l0KPvdAUAqXK2DcN
        uLls9OfJsuNBmxKMYxhG48+9loKfKR3y6Q==
X-Google-Smtp-Source: ABdhPJz8yANcHjaGyqQGaY4JSONerEbzonpm3dqQlBV5QmGMTLV4Qmi+BW9OiLV6fzx34H0/2s8Ycw==
X-Received: by 2002:a1c:9acc:: with SMTP id c195mr7114943wme.69.1629640885971;
        Sun, 22 Aug 2021 07:01:25 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:fc53:5e22:f926:c43b? (p200300ea8f084500fc535e22f926c43b.dip0.t-ipconnect.de. [2003:ea:8f08:4500:fc53:5e22:f926:c43b])
        by smtp.googlemail.com with ESMTPSA id b4sm1114901wrp.33.2021.08.22.07.01.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Aug 2021 07:01:25 -0700 (PDT)
Subject: [PATCH 05/12] bnx2x: Read VPD with pci_vpd_alloc()
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com, Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?Q?David_H=c3=a4rdeman?= <david@hardeman.nu>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1ca29408-7bc7-4da5-59c7-87893c9e0442@gmail.com>
Message-ID: <821a334d-ff9d-386e-5f42-9b620ab3dbfa@gmail.com>
Date:   Sun, 22 Aug 2021 15:53:23 +0200
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

Use pci_vpd_alloc() to dynamically allocate a properly sized buffer and
read the full VPD data into it.

This simplifies the code, and we no longer have to make assumptions about
VPD size.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h   |  1 -
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  | 44 +++++--------------
 2 files changed, 10 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
index d04994840..e789430f4 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
@@ -2407,7 +2407,6 @@ void bnx2x_igu_clear_sb_gen(struct bnx2x *bp, u8 func, u8 idu_sb_id,
 #define ETH_MAX_RX_CLIENTS_E2		ETH_MAX_RX_CLIENTS_E1H
 #endif
 
-#define BNX2X_VPD_LEN			128
 #define VENDOR_ID_LEN			4
 
 #define VF_ACQUIRE_THRESH		3
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 6d9813491..0466adf8d 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -12189,50 +12189,29 @@ static int bnx2x_get_hwinfo(struct bnx2x *bp)
 
 static void bnx2x_read_fwinfo(struct bnx2x *bp)
 {
-	int cnt, i, block_end, rodi;
-	char vpd_start[BNX2X_VPD_LEN+1];
+	int i, block_end, rodi;
 	char str_id_reg[VENDOR_ID_LEN+1];
 	char str_id_cap[VENDOR_ID_LEN+1];
-	char *vpd_data;
-	char *vpd_extended_data = NULL;
-	u8 len;
+	unsigned int vpd_len;
+	u8 *vpd_data, len;
 
-	cnt = pci_read_vpd(bp->pdev, 0, BNX2X_VPD_LEN, vpd_start);
 	memset(bp->fw_ver, 0, sizeof(bp->fw_ver));
 
-	if (cnt < BNX2X_VPD_LEN)
-		goto out_not_found;
+	vpd_data = pci_vpd_alloc(bp->pdev, &vpd_len);
+	if (IS_ERR(vpd_data))
+		return;
 
 	/* VPD RO tag should be first tag after identifier string, hence
 	 * we should be able to find it in first BNX2X_VPD_LEN chars
 	 */
-	i = pci_vpd_find_tag(vpd_start, BNX2X_VPD_LEN, PCI_VPD_LRDT_RO_DATA);
+	i = pci_vpd_find_tag(vpd_data, vpd_len, PCI_VPD_LRDT_RO_DATA);
 	if (i < 0)
 		goto out_not_found;
 
 	block_end = i + PCI_VPD_LRDT_TAG_SIZE +
-		    pci_vpd_lrdt_size(&vpd_start[i]);
-
+		    pci_vpd_lrdt_size(&vpd_data[i]);
 	i += PCI_VPD_LRDT_TAG_SIZE;
 
-	if (block_end > BNX2X_VPD_LEN) {
-		vpd_extended_data = kmalloc(block_end, GFP_KERNEL);
-		if (vpd_extended_data  == NULL)
-			goto out_not_found;
-
-		/* read rest of vpd image into vpd_extended_data */
-		memcpy(vpd_extended_data, vpd_start, BNX2X_VPD_LEN);
-		cnt = pci_read_vpd(bp->pdev, BNX2X_VPD_LEN,
-				   block_end - BNX2X_VPD_LEN,
-				   vpd_extended_data + BNX2X_VPD_LEN);
-		if (cnt < (block_end - BNX2X_VPD_LEN))
-			goto out_not_found;
-		vpd_data = vpd_extended_data;
-	} else
-		vpd_data = vpd_start;
-
-	/* now vpd_data holds full vpd content in both cases */
-
 	rodi = pci_vpd_find_info_keyword(vpd_data, i, block_end,
 				   PCI_VPD_RO_KEYWORD_MFR_ID);
 	if (rodi < 0)
@@ -12258,17 +12237,14 @@ static void bnx2x_read_fwinfo(struct bnx2x *bp)
 
 			rodi += PCI_VPD_INFO_FLD_HDR_SIZE;
 
-			if (len < 32 && (len + rodi) <= BNX2X_VPD_LEN) {
+			if (len < 32 && (len + rodi) <= vpd_len) {
 				memcpy(bp->fw_ver, &vpd_data[rodi], len);
 				bp->fw_ver[len] = ' ';
 			}
 		}
-		kfree(vpd_extended_data);
-		return;
 	}
 out_not_found:
-	kfree(vpd_extended_data);
-	return;
+	kfree(vpd_data);
 }
 
 static void bnx2x_set_modes_bitmap(struct bnx2x *bp)
-- 
2.33.0


