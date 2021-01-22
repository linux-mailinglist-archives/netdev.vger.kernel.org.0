Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB44B3002C2
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 13:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbhAVMTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 07:19:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727359AbhAVMJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 07:09:11 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7A9C06174A
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 04:08:30 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id v15so4852554wrx.4
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 04:08:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=8Bbf1qexURyw5HBggdlNQxrcnsreQOWaeHogsb3+oSQ=;
        b=eGBEv7oafv9QPCRAGw6qKT2MAg8EjA99gDESHrfk758vaU1UeBxiShyKt02ZcExMGn
         ZGXk9x6YX91fNoRAthn+h4yyyuteffwlOVvykPs1guQ9dLZ4RPzl5SlK4fV+6BaaLzF6
         1Mc50RS+AYjs8yZXkJ8LTowt3r9bwQdnrUQ4JUM2rFcetTt9vWzFOIFFjOLbcC25JuDo
         UMLmwOG6oqFWf2JvBu3tD2zaU03MvHMlCC6SuBuwBoQmf94u5KK2f2IIUWfp+uBuGwNK
         YpvWjM2zmq25dfM6TjLNaIjD4ISb41d10Sqrb1nd9T9a3fxxpq8wuQ321SZXmnDgRSgB
         U8SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=8Bbf1qexURyw5HBggdlNQxrcnsreQOWaeHogsb3+oSQ=;
        b=puStICsTSQU72Qsetv/McwbaOAQggAc7rceXRMwburGQLyZ5QfPacrZP2v76WaKWQ3
         t7tt7S6OcjIE+4vpsCF7lmD+eXGmjuvhofaoq/fqueuiYwl7wrydeIJ8blGbydER6pyJ
         UGc8HXWwoEwXTprk0HF2U0uoH/Wt61cFDeqr5L4TjECFNvPGyBXKz9Fq/7rDwjnblHQt
         v/JO/kz+WhLudr1VvQVST8Xdy/KFvhZKhuL3u70DwB3KWbm/0XQhzOVPqSW/TJvJc+BL
         s/0F9ZU1E8MQyjlA8FlV6UJF+Iq05K2NEuTL34Dsk3lFFwAbNAgWutPZ1tMxaoEyPufH
         ZWUw==
X-Gm-Message-State: AOAM530fjmANJzFCXdAJlZl4cK2rnFJom8lv9W/QzgFZwgRU/1vR3CfE
        Ya+wQzVVvAfpX49XYf1Qt2jfn0/xfs0=
X-Google-Smtp-Source: ABdhPJxLTyZWnh1es8bKhl7P5qyyi4Jhc6pLIjUYW0tlxJVC3jv8AMsdD+y/8nRG3ast6n+v46aNvA==
X-Received: by 2002:a5d:6809:: with SMTP id w9mr4216931wru.60.1611317309301;
        Fri, 22 Jan 2021 04:08:29 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:5c9d:dd78:3e40:95d? (p200300ea8f0655005c9ddd783e40095d.dip0.t-ipconnect.de. [2003:ea:8f06:5500:5c9d:dd78:3e40:95d])
        by smtp.googlemail.com with ESMTPSA id s1sm11912565wrv.97.2021.01.22.04.08.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jan 2021 04:08:28 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next] tg3: improve PCI VPD access
Message-ID: <cb9e9113-0861-3904-87e0-d4c4ab3c8860@gmail.com>
Date:   Fri, 22 Jan 2021 13:08:22 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When working on the PCI VPD code I also tested with a Broadcom BCM95719
card. tg3 uses internal NVRAM access with this card, so I forced it to
PCI VPD mode for testing. PCI VPD access fails
(i + PCI_VPD_LRDT_TAG_SIZE + j > len) because only TG3_NVM_VPD_LEN (256)
bytes are read, but PCI VPD has 400 bytes on this card.

So add a constant TG3_NVM_PCI_VPD_MAX_LEN that defines the maximum
PCI VPD size. The actual VPD size is returned by pci_read_vpd().
In addition it's not worth looping over pci_read_vpd(). If we miss the
125ms timeout per VPD dword read then definitely something is wrong,
and if the tg3 module loading is killed then there's also not much
benefit in retrying the VPD read.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 30 +++++++++++------------------
 drivers/net/ethernet/broadcom/tg3.h |  1 +
 2 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 7def6d815..4ee9da498 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -12826,11 +12826,13 @@ static __be32 *tg3_vpd_readblock(struct tg3 *tp, u32 *vpdlen)
 
 			offset = tg3_nvram_logical_addr(tp, offset);
 		}
-	}
 
-	if (!offset || !len) {
-		offset = TG3_NVM_VPD_OFF;
-		len = TG3_NVM_VPD_LEN;
+		if (!offset || !len) {
+			offset = TG3_NVM_VPD_OFF;
+			len = TG3_NVM_VPD_LEN;
+		}
+	} else {
+		len = TG3_NVM_PCI_VPD_MAX_LEN;
 	}
 
 	buf = kmalloc(len, GFP_KERNEL);
@@ -12846,26 +12848,16 @@ static __be32 *tg3_vpd_readblock(struct tg3 *tp, u32 *vpdlen)
 			if (tg3_nvram_read_be32(tp, offset + i, &buf[i/4]))
 				goto error;
 		}
+		*vpdlen = len;
 	} else {
-		u8 *ptr;
 		ssize_t cnt;
-		unsigned int pos = 0;
-
-		ptr = (u8 *)&buf[0];
-		for (i = 0; pos < len && i < 3; i++, pos += cnt, ptr += cnt) {
-			cnt = pci_read_vpd(tp->pdev, pos,
-					   len - pos, ptr);
-			if (cnt == -ETIMEDOUT || cnt == -EINTR)
-				cnt = 0;
-			else if (cnt < 0)
-				goto error;
-		}
-		if (pos != len)
+
+		cnt = pci_read_vpd(tp->pdev, 0, len, (u8 *)buf);
+		if (cnt < 0)
 			goto error;
+		*vpdlen = cnt;
 	}
 
-	*vpdlen = len;
-
 	return buf;
 
 error:
diff --git a/drivers/net/ethernet/broadcom/tg3.h b/drivers/net/ethernet/broadcom/tg3.h
index 1000c8940..46ec4fdfd 100644
--- a/drivers/net/ethernet/broadcom/tg3.h
+++ b/drivers/net/ethernet/broadcom/tg3.h
@@ -2101,6 +2101,7 @@
 /* Hardware Legacy NVRAM layout */
 #define TG3_NVM_VPD_OFF			0x100
 #define TG3_NVM_VPD_LEN			256
+#define TG3_NVM_PCI_VPD_MAX_LEN		512
 
 /* Hardware Selfboot NVRAM layout */
 #define TG3_NVM_HWSB_CFG1		0x00000004
-- 
2.30.0

